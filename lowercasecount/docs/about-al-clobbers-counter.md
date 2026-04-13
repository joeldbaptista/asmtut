# The "%al clobbers counter" bug

This note explains a subtle x86-64 bug that appeared in an earlier version of `lowercase.s`. The current file no longer has the bug — it was fixed by loading characters into `%dl` instead of `%al`.

## The original (buggy) code

```asm
    mov $0, %eax           # counter starts in %eax
    mov %rdi, %rbx         # pointer in %rbx
1:  movb (%rbx), %al       # ← this was the bug
    cmpb $0, %al
    je 1f
    cmpb $'a', %al
    jb 2f
    cmpb $'z', %al
    ja 2f
    inc %eax               # increment counter
2:  incq %rbx
    jmp 1b
1:  ret
```

## Why `%al` and `%eax` are not independent

`%al` is not a separate register — it is **a name for the low 8 bits of `%eax`**. The x86-64 register file layout for this register looks like:

```
|63........32|31........16|15....8|7....0|
              |<--- %eax --------->|
                           |%ah|%al|
              (upper 16 bits have no name)
```

So `%rax`, `%eax`, `%ax`, `%ah`, and `%al` all refer to overlapping pieces of the same physical register. Writing to `%al` modifies the low 8 bits of `%eax` in place, without touching the upper bits.

(A quirk worth knowing: writing to `%eax` *zero-extends* to the full 64-bit `%rax`. But writing to `%al`, `%ah`, or `%ax` does **not** zero-extend — it leaves the surrounding bits alone.)

## What that meant for the counter

Trace through the first couple of iterations on the string `"He..."`:

1. Start: `%eax = 0x00000000` (counter is `0`).
2. `movb (%rbx), %al` loads `'H'` (`0x48`) → `%eax = 0x00000048`.
3. `'H'` fails the `'a'..'z'` range check, so `inc %eax` is skipped.
4. Next iteration: `movb (%rbx), %al` loads `'e'` (`0x65`) → `%eax = 0x00000065`.
5. `'e'` is lowercase, so `inc %eax` → `%eax = 0x00000066`.
6. Next iteration: `movb (%rbx), %al` loads `'l'` (`0x6c`) → `%eax = 0x0000006c`. **The `0x66` from the previous increment is gone** — its low byte got overwritten.

Every iteration clobbered the accumulated count with the current character's byte value. The final return value was essentially "last lowercase letter + 1", not a true count.

## The fix

Use a register whose low byte does *not* overlap with the counter:

```asm
    xor %eax, %eax         # counter in %eax
    mov %rdi, %rsi         # pointer in %rsi (also caller-saved — no save needed)
1:  movb (%rsi), %dl       # character in %dl (low byte of %edx — separate register)
    testb %dl, %dl
    je 1f
    cmpb $'a', %dl
    jb 2f
    cmpb $'z', %dl
    ja 2f
    inc %eax               # counter accumulates cleanly
2:  inc %rsi
    jmp 1b
1:  ret
```

`%edx` and `%eax` are separate physical registers, so loading into `%dl` never disturbs `%eax`. The counter accumulates cleanly and the function returns the correct count.

## Takeaways

- The 8/16/32/64-bit "registers" on x86-64 are windows onto the same underlying physical register. Aliasing is easy to miss when you're focused on one size.
- Pick your scratch register with its full name in mind. If `%eax` is holding a value you care about, don't touch `%al`, `%ah`, or `%ax` either.
- Writing to a 32-bit register (`%eax`) zero-extends to 64 bits; writing to 8- or 16-bit sub-registers does not. This asymmetry is another common source of surprises.
