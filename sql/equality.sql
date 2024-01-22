CREATE EXTENSION stringtheory;

-- no match
SELECT stringtheory.equals('hello', 'world');

-- match
SELECT stringtheory.equals('hello', 'hello');

-- match on a 16 byte boundary
SELECT stringtheory.equals('1234567890123456', '1234567890123456');

-- no match when partial
SELECT stringtheory.equals('123456', '12345');
