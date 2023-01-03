-- Migration number: 0001 	 2023-01-03T05:45:21.589Z

CREATE INDEX "Item_publishedAt_index" ON Item (publishedAt);
