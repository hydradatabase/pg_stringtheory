extern "C" {
#include "postgres.h"

#include "fmgr.h"
#include "mb/pg_wchar.h"

#if PG_VERSION_NUM >= 160000
#include "varatt.h"
#endif
};

#include <cstdio>
#include <cstring>

#ifdef HAVE_NEON_INSTRUCTIONS
extern size_t swar64_strstr_anysize(const char *s, unsigned long n,
                                    const char *needle, unsigned long k);
#include "swar64-strstr-v2.cpp"
#else
extern "C" size_t sse42_strstr_anysize(const char *, size_t, const char *,
                                       size_t);
#include "sse4.2-strstr.cpp"
#endif

/*
 * fast_strstr
 *
 * Acts similar to strstr, returning the position of the first match or
 * -1 if none are found.
 */
size_t fast_strstr(char *left, size_t len_left, char *right, size_t len_right) {
#ifdef HAVE_NEON_INSTRUCTIONS
  size_t ret = swar64_strstr_anysize(left, len_left, right, len_right);
#else
  size_t ret = sse42_strstr_anysize(left, len_left, right, len_right);
#endif
  return ret;
}

extern "C" {
/* This sets up the Postgres module. */
PG_MODULE_MAGIC;

/* Our function declarations. */
Datum pg_strstr(PG_FUNCTION_ARGS);
Datum pg_equals(PG_FUNCTION_ARGS);

/* Register our functions. */
PG_FUNCTION_INFO_V1(pg_strstr);
PG_FUNCTION_INFO_V1(pg_equals);

/*
 * pg_strstr
 *
 * Postgres function that returns the position of the first match, or -1
 * if no matches are found.
 */
Datum pg_strstr(PG_FUNCTION_ARGS) {
  /* Get a copy of the first argument as a text type. */
  text *left  = PG_GETARG_TEXT_PP(0);
  text *right = PG_GETARG_TEXT_PP(1);

  /* Get the length of both arguments. */
  size_t len_left  = VARSIZE_ANY_EXHDR(left);
  size_t len_right = VARSIZE_ANY_EXHDR(right);

  /* If either length is 0, no match. */
  if (len_left == 0 || len_right == 0) {
    PG_RETURN_INT32(-1);
  }

  /* If the right side length is greater than the left, we cannot match. */
  if (len_right > len_left) {
    PG_RETURN_INT32(-1);
  }

  /* Make a copy of the data to null terminate. */
  char left_term[ len_left + 1 ];
  memcpy(left_term, VARDATA_ANY(left), len_left);
  left_term[ len_left ] = '\0';
  char right_term[ len_right + 1 ];
  memcpy(right_term, VARDATA_ANY(right), len_right);
  right_term[ len_right ] = '\0';

  /* Get the results from the simd functions. */
  size_t ret = fast_strstr(left_term, len_left, right_term, len_right);

  PG_RETURN_INT32(ret);
}

Datum pg_equals(PG_FUNCTION_ARGS) {
  /* Get a copy of the first argument as a text type. */
  text *left  = PG_GETARG_TEXT_PP(0);
  text *right = PG_GETARG_TEXT_PP(1);

  /* Get the length of both arguments. */
  size_t len_left  = VARSIZE_ANY_EXHDR(left);
  size_t len_right = VARSIZE_ANY_EXHDR(right);

  /* If either length is 0, no match. */
  if (len_left == 0 || len_right == 0) {
    PG_RETURN_BOOL(false);
  }

  /* If the lengths are not the same, it will not match. */
  if (len_right != len_left) {
    PG_RETURN_BOOL(false);
  }

  /* Get the results from the simd functions. */
  size_t ret =
      fast_strstr(VARDATA_ANY(left), len_left, VARDATA_ANY(right), len_right);

  /* If the result is 0, strings are equal. */
  PG_RETURN_BOOL(ret == 0);
}

}; // "C"
