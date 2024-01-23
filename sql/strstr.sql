CREATE EXTENSION IF NOT EXISTS stringtheory;

-- no match
SELECT stringtheory.strstr('hello', 'world');

-- match with 0
SELECT stringtheory.strstr('hello', 'hello');

-- match on a 16 byte boundary
SELECT stringtheory.strstr('1234567890123456', '1234567890123456');

-- match when partial
SELECT stringtheory.strstr('123456', '12345');

-- needle found in haystack
SELECT stringtheory.strstr('hello world', 'ello');

-- haystack in needle not found
SELECT stringtheory.strstr('ello', 'hello world');

-- test strstr in a CTE
WITH a AS (SELECT md5(generate_series(1, 1000)::text) b)
SELECT COUNT(*) FROM a
WHERE stringtheory.strstr(b, '00') >= 0;

-- test strstr in a table
CREATE TEMPORARY TABLE stringtheory_test
(a text);

INSERT INTO stringtheory_test
SELECT md5(generate_series(1,1000)::text);

SELECT COUNT(*) FROM stringtheory_test
WHERE stringtheory.strstr(a, '00') >= 0;

DROP TABLE stringtheory_test;
