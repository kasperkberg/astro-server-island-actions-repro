# Server island + astro:actions breaks in dev (astro 7.3.6+)

```sh
npm install
npm run dev
```

1. Open http://localhost:4321/ (works)
2. Click "Go to /b" (500: `Could not find server component name …/IslandB.astro`)

Restart and open `/b` first, and both pages work.

`IslandB.astro` imports `astro:actions`. Remove that import and the bug goes away.

Works in 7.3.5, broken in 7.3.6 to 7.3.8.

`./repro.sh` does the same thing from a fresh start.
