# news-api.inkohx.dev

色々なサイトのフィードをまとめて JSON 形式で返してくれる API

## 必要なもの

- Cloudflare Workers
- Cloudflare D1

## 環境構築

### 開発用

```sh
# 依存インストール
npm ci

# D1のローカル環境構築
npx wrangler d1 migrations apply DB --local
npx wrangler d1 execute DB --local --file=./db/seed.sql

# wrangler dev
npm run dev
```

### 本番環境

```sh
npx wrangler d1 migrations apply <production_db>

# wrangler publish
npm run deploy
```
