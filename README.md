# Aequitas - Text Comparison for PostgreSQL

Aequitas is an extension for PostgreSQL that provides string comparisons using SSE4.2 on x86_64 platforms, and SWAR64 on aarch64 and arm64 platforms.

## Usage

After installation:

```sql
CREATE EXTENSION aequitas;
```

This will create a `schema` called aequitas that contains the comparison functions:

`aequitas.equals(a TEXT, b TEXT)` - returns `BOOLEAN`, `true` if there is an exact match, and `false` if there is not.

`aequitas.strstr(haystack TEXT, needle TEXT)` - returns `INTEGER`, the position of where the needle is found in the haystack, or `-1` if it is not found.
