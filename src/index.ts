import { Hono } from 'hono'
import { cache } from 'hono/cache'
import { cors } from 'hono/cors'
import { read } from '@extractus/feed-extractor'
import { z } from 'zod'

export interface Env {
  DB: D1Database
}

const app = new Hono<{ Bindings: Env }>()

const querySchema = z.object({
  skip: z.string().regex(/^\d+$/s).optional(),
  size: z.string().regex(/^\d+$/s).optional(),
  categories: z.string().regex(/^\d+$/s).optional(),
})

app.use(
  cors({
    origin: ['https://news.inkohx.dev'],
    allowMethods: ['GET'],
    credentials: false,
    maxAge: 3600,
  })
)

app.get(
  '/',
  cache({ cacheName: 'news-api', cacheControl: 'public, max-age=3600' }),
  async (context) => {
    const queries = querySchema.safeParse(context.req.queries())

    if (!queries.success)
      return context.json({ message: 'Invalid queries.' }, 400)

    const categoryIds = await context.env.DB.prepare(
      'SELECT DISTINCT id FROM Category'
    ).all<{ id: number }>()

    if (!categoryIds.success || !categoryIds.results) {
      console.error(categoryIds)
      return context.json({ message: 'Internal Server Error' }, 500)
    }

    const maxCategoriesValue = categoryIds.results.reduce(
      (prev, current) => prev | current.id,
      0
    )
    const categories = queries.data.categories
      ? Number.parseInt(queries.data.categories)
      : maxCategoriesValue
    const skip = queries.data.skip ? Number.parseInt(queries.data.skip) : 0
    const size = queries.data.size ? Number.parseInt(queries.data.size) : 25

    console.log('Categories', categories)
    console.log('Skip', skip)
    console.log('Size', size)

    try {
      if (categories < 1 || categories > maxCategoriesValue)
        throw `"categories" is must be between 1 and ${maxCategoriesValue}.`
      if (skip > Number.MAX_SAFE_INTEGER)
        throw '"skip" is must be between 0 and Number.MAX_SAFE_INTEGER.'
      if (size < 1 || size > 50) throw '"size" is must be between 1 and 50.'
    } catch (message) {
      return context.json({ message }, 400)
    }

    const items = await context.env.DB.prepare(
      `
SELECT Item.url, title, publishedAt, Feed.name
FROM Item
INNER JOIN Feed ON Item.feedId = Feed.id
WHERE
  Item.id NOT IN (
    SELECT id FROM Item ORDER BY publishedAt DESC LIMIT ?1
  ) AND (?2 & Feed.categoryId) = Feed.categoryId
ORDER BY publishedAt DESC LIMIT ?3`
    )
      .bind(skip, categories, size)
      .all<{ name: string; publishedAt: string; title: string; url: string }>()

    return context.json(
      items.results?.map(
        (item) =>
          ({
            ...item,
            publishedAt: new Date(item.publishedAt),
          } ?? [])
      )
    )
  }
)

export default {
  fetch: app.fetch,
  async scheduled(
    _event: ScheduledEvent,
    { DB }: Env,
    _context: Pick<ExecutionContext, 'waitUntil'>
  ) {
    const feeds = await DB.prepare(
      'SELECT id, url FROM Feed WHERE updatedAt < ?'
    )
      .bind(new Date(Date.now() - 3_600_000).toISOString())
      .all<{ id: number; url: string }>()

    if (!feeds.success || !feeds.results) return console.log(feeds)

    for (const { id, url } of feeds.results) {
      const entries = (await read(url)).entries

      if (!entries) continue

      const insertItem = DB.prepare(
        'INSERT OR IGNORE INTO Item (title, url, publishedAt, feedId) VALUES (?, ?, ?, ?)'
      )

      await DB.batch([
        ...entries.map(({ title, link, published }) =>
          insertItem.bind(title, link, published, id)
        ),
        DB.prepare('DELETE FROM Item WHERE publishedAt < ?').bind(
          new Date(Date.now() - 2_678_400_000).toISOString()
        ),
        DB.prepare('UPDATE Feed SET updatedAt = ? WHERE id = ?').bind(
          new Date().toISOString(),
          id
        ),
      ])
    }
  },
}
