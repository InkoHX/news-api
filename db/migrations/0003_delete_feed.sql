-- Migration number: 0003 	 2023-03-29T13:10:05.396Z
-- Delete React blog
DELETE FROM Item WHERE feedId = (SELECT id FROM Feed WHERE url = 'https://reactjs.org/feed.xml');
DELETE FROM Feed WHERE url = 'https://reactjs.org/feed.xml';
