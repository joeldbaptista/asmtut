# `sumsqr.s` walkthrough

This document explains the x86-64 (AT&T syntax, System V AMD64 ABI) implementation
of `sumsqr` in `sumsqr.s`. The function computes `1² + 2² + … + n²` for positive
`n`, and returns `0` for `n ≤ 0`.

```c
int64_t sumsqr(int64_t n);
```

## Calling convention recap

Under the System V AMD64 ABI used on Linux:

- The first integer argument arrives in `%rdi`, the return value goes in `%rax`.
- **Caller-saved** (the called function may freely clobber): `%rax`, `%rcx`,
  `%rdx`, `%rsi`, `%rdi`, `%r8`–`%r11`.
- **Callee-saved** (the called function must preserve, restoring on return):
  `%rbx`, `%rbp`, `%r12`–`%r15`.

If we want a value to survive a `call` instruction, it must either live in a
callee-saved register or be spilled to the stack.

## The `mul` constraint

The single-operand `mul` instruction has a fixed register interface:

```
mul src    ;  rdx:rax = rax * src     (unsigned, 128-bit product)
```

It always writes the high 64 bits of the product into `%rdx`, even when we only
care about the low 64 bits. That makes `%rdx` unsafe to use as a local across
any code path that performs `mul`. (`imul reg, reg` does *not* have this
property — but the goal here is to use `mul`.)

## Register layout

Because `sumsqr` calls `sqr`, and `sqr` uses `mul` (which clobbers `%rdx` and
`%rax`), the loop's running state must live in registers `sqr` cannot touch.
We choose two callee-saved registers:

| Register | Role                       |
|----------|----------------------------|
| `%rbx`   | running sum `s`            |
| `%r12`   | loop counter (the input n) |
| `%rax`   | return value of `sqr`      |
| `%rdi`   | argument register for `sqr`|

Because `%rbx` and `%r12` belong to our caller, we must save them on entry and
restore them on exit.

## Annotated code

```asm
.global sumsqr
.type sumsqr, @function
sumsqr:
    push %rbx              # preserve caller's %rbx (callee-saved)
    push %r12              # preserve caller's %r12 (callee-saved)

    mov  $0, %rbx          # s = 0
    mov  %rdi, %r12        # n = argument

1:  cmp  $0, %r12          # loop head: while (n > 0)
    jle  1f                #   if n <= 0, exit loop (also handles n < 0 → 0)

    mov  %r12, %rdi        # arg to sqr = n
    call sqr               # %rax = n*n  (clobbers %rax, %rdx; %rbx, %r12 safe)
    add  %rax, %rbx        # s += n*n
    dec  %r12              # --n
    jmp  1b                # loop

1:  mov  %rbx, %rax        # return s
    pop  %r12              # restore callee-saved registers
    pop  %rbx
    ret

sqr:
    mov  %rdi, %rax        # %rax = n
    mul  %rax              # %rdx:%rax = n * n  (we keep low 64 bits in %rax)
    ret
```

### Local labels `1:` / `1f` / `1b`

GAS treats numeric labels as local and reusable. `1f` means "the next `1:`
label going forward", `1b` means "the previous `1:` label going backward". The
file uses `1:` twice — once as the loop head and once as the function epilogue
— and the two `j` instructions disambiguate by direction.

### `n ≤ 0` handling

The README requires `sumsqr(n) = 0` for `n < 0`. The first `cmp $0, %r12; jle`
covers both `n == 0` and `n < 0` in one branch: we never enter the loop, `%rbx`
stays at its initial `0`, and that is what we return.

### Why we *don't* preserve `%rcx` or `%rdx`

`sumsqr` does not hold any live data in caller-saved registers across the
`call sqr` — the running sum is in `%rbx`, the counter is in `%r12`. So even
though `sqr` may clobber `%rcx`, `%rdx`, `%rsi`, `%r8`–`%r11`, none of that
matters to us.

### Stack alignment

The ABI requires `%rsp` to be 16-byte aligned *immediately before* a `call`
instruction. On entry to `sumsqr`, `%rsp` is misaligned by 8 (the return
address pushed by our caller's `call`). The two `push`es add another 16 bytes,
leaving `%rsp` misaligned by 8 again — exactly what `sqr` needs at its `call`
site… but `sqr` does no `call` of its own, so alignment inside `sqr` is moot.
The point is that two `push`es (an even number) preserve whatever alignment
parity we entered with, which in our case is fine because we make no further
calls from `sumsqr` that depend on it beyond `sqr`. `sqr` itself only uses
`mov`, `mul`, `ret`, none of which require alignment.

## Verifying the output

`main` in `sumsqr.c` prints a few sample values. Closed-form check:

> Σ k² for k=1..n  =  n(n+1)(2n+1) / 6

| n       | expected            | program output      |
|---------|---------------------|---------------------|
| -10     | 0                   | 0                   |
| 0       | 0                   | 0                   |
| 10      | 385                 | 385                 |
| 100     | 338,350             | 338350              |
| 1,000   | 333,833,500         | 333833500           |
| 10,000  | 333,383,335,000     | 333383335000        |
| 100,000 | 333,338,333,350,000 | 333338333350000     |

All values match.
