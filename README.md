# news.inkohx.dev

色々なサイトのフィードをまとめてJSON形式で返してくれるAPI

## Requirements

- Cloudflare Workers
- Cloudflare D1

## Development

```sh
# 依存インストール
npm ci

# D1のローカル環境構築
npx wrangler d1 execute <preview_db> --file=./d1/schema.sql
npx wrangler d1 execute <preview_db> --file=./d1/seed.sql

# wrangler dev
npm run dev
```

## Production

```sh
npx wrangler d1 execute <production_db> --file=./d1/schema.sql

# wrangler publish
npm run deploy
```
