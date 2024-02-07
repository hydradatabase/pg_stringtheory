CREATE TABLE memory_test (i BIGINT, t TEXT);

INSERT INTO memory_test SELECT 1, repeat('a', (2^19)::INTEGER);
INSERT INTO memory_test SELECT 2, repeat('b', (2^20)::INTEGER);
INSERT INTO memory_test SELECT 3, repeat('c', (2^21)::INTEGER);

SELECT i, stringtheory.strstr(t, 'aa') FROM memory_test;
SELECT i, stringtheory.strstr(t, 'bb') FROM memory_test;
SELECT i, stringtheory.strstr(t, 'cc') FROM memory_test;

SELECT i, stringtheory.equals(t, repeat('a', (2^19)::INTEGER)) FROM memory_test;
SELECT i, stringtheory.equals(t, repeat('b', (2^20)::INTEGER)) FROM memory_test;
SELECT i, stringtheory.equals(t, repeat('c', (2^21)::INTEGER)) FROM memory_test;
