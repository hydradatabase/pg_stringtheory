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
