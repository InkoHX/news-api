-- Category table
CREATE TABLE IF NOT EXISTS "Category" (
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "name" TEXT NOT NULL UNIQUE
);

-- Feed table
CREATE TABLE IF NOT EXISTS "Feed" (
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "url" TEXT NOT NULL UNIQUE,
  "name" TEXT NOT NULL UNIQUE,
  "updatedAt" TEXT DEFAULT '1970-01-01' NOT NULL,
  "categoryId" INTEGER NOT NULL,
  CONSTRAINT "Feed_categoryId_fk" FOREIGN KEY ("categoryId") REFERENCES "Category" ON UPDATE CASCADE
);

-- Item table
CREATE TABLE IF NOT EXISTS "Item" (
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "url" TEXT NOT NULL UNIQUE,
  "title" TEXT NOT NULL,
  "publishedAt" TEXT NOT NULL,
  "feedId" INTEGER NOT NULL,
  CONSTRAINT "Item_feedId_fk" FOREIGN KEY ("feedId") REFERENCES "Feed" ON UPDATE CASCADE
);

-- Insert categories
INSERT INTO Category ("id", "name")
VALUES
  (1, 'Programming Language'),
  (2, 'JavaScript Library'),
  (4, 'JavaScript Framework'),
  (8, 'JavaScript Runtime'),
  (16, 'Media'),
  (32, 'Editor/IDE'),
  (64, 'Linux'),
  (128, 'Hosting Service');

-- Insert follow feeds
INSERT INTO Feed ("name", "url", "categoryId")
VALUES
  ('Kotlin', 'https://blog.jetbrains.com/kotlin/feed', 1),
  ('TypeScript', 'https://devblogs.microsoft.com/typescript/feed', 1),
  ('React Blog', 'https://reactjs.org/feed.xml', 2),
  ('Vue Blog', 'https://blog.vuejs.org/feed.rss', 2),
  ('Lit Blog', 'https://lit.dev/blog/atom.xml', 2),
  ('Next.js', 'https://nextjs.org/feed.xml', 4),
  ('Deno News', 'https://buttondown.email/denonews/rss', 8),
  ('Deno Blog', 'https://deno.com/feed', 8),
  ('Node.js Releases', 'https://nodejs.org/en/feed/releases.xml', 8),
  ('Node.js Vulnerability Report', 'https://nodejs.org/en/feed/vulnerability.xml', 8),
  ('GIGAZINE', 'https://gigazine.net/news/rss_2.0/', 16),
  ('IT Media', 'https://rss.itmedia.co.jp/rss/2.0/topstory.xml', 16),
  ('Visual Studio Code', 'https://code.visualstudio.com/feed.xml', 32),
  ('Intelij IDEA', 'https://blog.jetbrains.com/idea/feed', 32),
  ('JetBrains Fleet', 'https://blog.jetbrains.com/fleet/feed', 32),
  ('CLion', 'https://blog.jetbrains.com/clion/feed', 32),
  ('Arch Linux News (JP)', 'https://www.archlinux.jp/feeds/news.xml', 64),
  ('GitHub Blog', 'https://github.blog/feed', 128),
  ('Vercel', 'https://vercel.com/atom', 128),
  ('Netlify', 'https://www.netlify.com/community-feed.xml', 128);
