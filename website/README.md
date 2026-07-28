# MindDeck website

The marketing site is a self-contained Vite, React, and TypeScript project.

## Local development

```bash
npm install
npm run dev
```

## Verification

```bash
npm run test
npm run build
```

The production build is written to `dist/`.

## GitHub Pages

Assets default to a relative base path, which works for project Pages deployments. CI can provide an explicit repository path when needed:

```bash
VITE_BASE_PATH=/MindDeck/ npm run build
```

Store links are intentionally marked as first-release placeholders until the release identities and public URLs exist.
