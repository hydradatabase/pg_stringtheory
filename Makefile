.PHONY: lintcheck

SRCS = src/text.cpp
OBJS = $(subst .cpp,.o, $(SRCS))

MODULE_big = stringtheory

PG_CPPFLAGS = -O3 -std=c++17 -I src/sse

UNAME_S := $(shell uname -m)
ifeq ($(UNAME_S),arm64)
	PG_CPPFLAGS += -stdlib=libc++ -DHAVE_NEON_INSTRUCTIONS=1
endif
ifeq ($(UNAME_S),aarch64)
	PG_CPPFLAGS += -DHAVE_NEON_INSTRUCTIONS=1
endif
ifeq ($(UNAME_S),x86_64)
	SHLIB_LINK += -lrt -std=c++17 -msse4.2
	PG_CPPFLAGS += -msse4.2
endif

EXTENSION = stringtheory
DATA = stringtheory--1.0.0.sql
PGFILEDESC = "stringtheory - tools for testing equality"

PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)

REGRESS = equality strstr

include $(PGXS)

lintcheck:
	clang-tidy $(SRCS) -- -I$(INCLUDEDIR) -I$(INCLUDEDIR_SERVER) -I$(PWD)/include -std=c++17
