-- Migration number: 0002 	 2023-01-03T06:08:33.399Z

PRAGMA foreign_keys=OFF;

CREATE TABLE "new_Item" (
    "url" TEXT NOT NULL PRIMARY KEY,
    "title" TEXT NOT NULL,
    "publishedAt" TEXT DEFAULT '1970-01-01' NOT NULL,
    "feedId" INTEGER NOT NULL,
    CONSTRAINT "Item_feedId_foreign_key" FOREIGN KEY ("feedId") REFERENCES "Feed" ("id") ON UPDATE CASCADE
);

INSERT INTO "new_Item" ("feedId", "publishedAt", "title", "url") SELECT "feedId", "publishedAt", "title", "url" FROM "Item";

DROP TABLE "Item";

ALTER TABLE "new_Item" RENAME TO "Item";

CREATE INDEX "Item_publishedAt_index" ON "Item"("publishedAt");

PRAGMA foreign_keys=ON;
