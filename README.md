# pg_stringtheory - Text Comparison for PostgreSQL

pg_stringtheory is an extension for PostgreSQL that provides string comparisons using SSE4.2 on x86_64 platforms, and SWAR64 on aarch64 and arm64 platforms.

## Usage

After installation:

```sql
CREATE EXTENSION stringtheory;
```

This will create a schema called `stringtheory` that contains the comparison functions:

`stringtheory.equals(a TEXT, b TEXT)` - returns `BOOLEAN`, `true` if there is an exact match, and `false` if there is not.

`stringtheory.strstr(haystack TEXT, needle TEXT)` - returns `INTEGER`, the position of where the needle is found in the haystack, or `-1` if it is not found.

## Internal Testing

Internal testing has shown an improvement on simple searches over `LIKE` using the clickbench dataset:

```
SELECT COUNT(*) FROM hits WHERE URL LIKE '%google%';
Time: 2478.677 ms (00:02.479)
Time: 2487.265 ms (00:02.487)
Time: 2477.202 ms (00:02.477)
Time: 2478.187 ms (00:02.478)
Time: 2465.396 ms (00:02.465)
Time: 2474.502 ms (00:02.475)
Time: 2474.685 ms (00:02.475)
Time: 2462.968 ms (00:02.463)
Time: 2472.771 ms (00:02.473)
Time: 2495.073 ms (00:02.495)
```

Versus pg_stringtheory

```
SELECT COUNT(*) FROM hits WHERE stringtheory.strstr(URL, 'google') != -1;
Time: 2105.663 ms (00:02.106)
Time: 2108.152 ms (00:02.108)
Time: 2121.878 ms (00:02.122)
Time: 2115.838 ms (00:02.116)
Time: 2114.486 ms (00:02.114)
Time: 2106.851 ms (00:02.107)
Time: 2113.555 ms (00:02.114)
Time: 2114.968 ms (00:02.115)
Time: 2130.092 ms (00:02.130)
Time: 2119.556 ms (00:02.120)
```

Tests were run on a cloud AMD host with the SSE4.2 version of pg_stringtheory.
