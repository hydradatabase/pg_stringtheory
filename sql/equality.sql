CREATE EXTENSION IF NOT EXISTS stringtheory;

-- no match
SELECT stringtheory.equals('hello', 'world');

-- match
SELECT stringtheory.equals('hello', 'hello');

-- match on a 16 byte boundary
SELECT stringtheory.equals('1234567890123456', '1234567890123456');

-- no match when partial
SELECT stringtheory.equals('123456', '12345');

-- test equality in a CTE
WITH a AS (SELECT md5(generate_series(1, 1000)::text) b)
SELECT count(*) FROM a
WHERE stringtheory.equals(b, md5('123'));

-- test strstr in a table
CREATE TEMPORARY TABLE stringtheory_test
(a text);

INSERT INTO stringtheory_test
SELECT md5(generate_series(1,1000)::text);

SELECT COUNT(*) FROM stringtheory_test
WHERE stringtheory.equals(a, md5('123'));

DROP TABLE stringtheory_test;
