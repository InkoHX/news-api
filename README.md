# news.inkohx.dev

俺専用の爆速フィード収集プログラム

## Requirements

- Cloudflare Workers
- Cloudflare D1

## Development

```sh
# 依存インストール
npm ci

# D1のローカル環境構築
npx wrangler d1 execute news --local --file=./d1/schema.sql
npx wrangler d1 execute news --local --file=./d1/seed.sql

# wrangler dev
npm run dev
```

## Production

```sh
npx wrangler d1 execute <production_db_name> --file=./d1/schema.sql

# wrangler publish
npm run deploy
```
