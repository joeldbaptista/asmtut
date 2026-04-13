# `sumseq` - sum of squares of 1 to `N`

Implement the following function:

```c
int64_t sumsqr(int64_t n);
```

**Note** if `n < 0` return 0. In C, this would be implemented like this:

```c
int64_t sumsqr(int64_t n)
{
	int64_t s;

	for (s = 0; n; --n)
		s += n * n;
	return s;
}
```
