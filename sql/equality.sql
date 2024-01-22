CREATE EXTENSION aequitas;

-- no match
SELECT aequitas.equals('hello', 'world');

-- match
SELECT aequitas.equals('hello', 'hello');

-- match on a 16 byte boundary
SELECT aequitas.equals('1234567890123456', '1234567890123456');

-- no match when partial
SELECT aequitas.equals('123456', '12345');
