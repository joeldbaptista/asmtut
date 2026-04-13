# Caller-saved vs Callee-saved registers (System V AMD64 ABI)

On Linux/macOS x86-64, functions follow the **System V AMD64 ABI**. It divides the general-purpose registers into two groups based on who is responsible for preserving their values across a function call.

## The two categories

### Callee-saved ("non-volatile")

If a function wants to use one of these registers, **the function itself** must preserve the caller's value — typically by pushing on entry and popping before `ret`. The caller can assume these registers still hold their original values after the call returns.

- `%rbx`
- `%rbp`
- `%r12`, `%r13`, `%r14`, `%r15`
- `%rsp` (the stack pointer — preserved implicitly by balanced push/pop)

### Caller-saved ("volatile" / "scratch")

These can be clobbered by any called function without warning. If the **caller** has a value it wants to keep across a call, it must save the register itself (push before, pop after, or spill to a stack slot).

- `%rax` (also holds the return value)
- `%rcx`, `%rdx`, `%rsi`, `%rdi` (also used for argument passing)
- `%r8`, `%r9` (also used for argument passing)
- `%r10`, `%r11`

## Argument and return conventions (related)

- Integer/pointer args, in order: `%rdi`, `%rsi`, `%rdx`, `%rcx`, `%r8`, `%r9`. Further args go on the stack.
- Integer return value: `%rax` (and `%rdx` for 128-bit returns).
- All six argument registers are caller-saved, so a callee can freely overwrite them.

## What this looks like in practice

### Using a callee-saved register correctly

```asm
myfunc:
    push %rbx              # save caller's %rbx
    mov  %rdi, %rbx        # now safe to use %rbx
    ...
    pop  %rbx              # restore before returning
    ret
```

### Avoiding the save/restore entirely

Pick a caller-saved register instead, so there's nothing to preserve:

```asm
myfunc:
    mov  %rdi, %rsi        # %rsi is caller-saved, no save needed
    ...
    ret
```

### Caller preserving a value across a call

```asm
    mov  $42, %rcx         # %rcx is caller-saved
    push %rcx              # save it — the call may trash %rcx
    call other_function
    pop  %rcx              # restore
```

## Why it matters

If a function clobbers a callee-saved register without restoring it, the bug often shows up far from the cause: the caller reads a variable it "knows" is in `%rbx`, gets garbage, and misbehaves arbitrarily. The compiler obeys the ABI silently, so mixing hand-written assembly with compiled code makes this the most common class of ABI bug.

## Quick reference table

| Register | Role                              | Preserved across call? |
|----------|-----------------------------------|------------------------|
| `%rax`   | Return value, scratch             | No (caller-saved)      |
| `%rbx`   | General purpose                   | Yes (callee-saved)     |
| `%rcx`   | 4th arg, scratch                  | No                     |
| `%rdx`   | 3rd arg, scratch                  | No                     |
| `%rsi`   | 2nd arg, scratch                  | No                     |
| `%rdi`   | 1st arg, scratch                  | No                     |
| `%rbp`   | Frame pointer (optional)          | Yes                    |
| `%rsp`   | Stack pointer                     | Yes                    |
| `%r8`    | 5th arg, scratch                  | No                     |
| `%r9`    | 6th arg, scratch                  | No                     |
| `%r10`   | Scratch (static chain)            | No                     |
| `%r11`   | Scratch                           | No                     |
| `%r12`–`%r15` | General purpose              | Yes                    |

## Other ABIs

This is specifically System V AMD64. Windows x64 uses a different convention (different argument registers, `%rsi`/`%rdi` are callee-saved there). Always check which ABI applies to your platform.
