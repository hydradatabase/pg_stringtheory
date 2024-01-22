CREATE EXTENSION stringtheory;

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
