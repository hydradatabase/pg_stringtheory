CREATE EXTENSION aequitas;

-- no match
SELECT aequitas.strstr('hello', 'world');

-- match with 0
SELECT aequitas.strstr('hello', 'hello');

-- match on a 16 byte boundary
SELECT aequitas.strstr('1234567890123456', '1234567890123456');

-- match when partial
SELECT aequitas.strstr('123456', '12345');

-- needle found in haystack
SELECT aequitas.strstr('hello world', 'ello');

-- haystack in needle not found
SELECT aequitas.strstr('ello', 'hello world');
