# "slim" Debian-based Node image — smaller than the default node:20, still
# has a real package manager if you ever need one.
FROM node:20-slim

WORKDIR /app

# Same layer-caching trick as the Python apps: copy just the manifest and
# install first, so `npm install` is only re-run when package.json
# actually changes, not on every source edit.
COPY package.json .
RUN npm install --omit=dev

COPY src ./src

# ARG (build-time) copied into ENV (runtime) — see the matching comment in
# apps/hello-fastapi/Dockerfile for why. This is what /version reports.
ARG APP_VERSION=dev
ENV APP_VERSION=${APP_VERSION}

# node:20-slim already ships a non-root "node" user (uid 1000) — no need
# to create one like the Python images do, just switch to it.
RUN chown -R node:node /app
USER node

EXPOSE 3000

# No `curl` in this slim image, so the healthcheck is a one-liner using
# Node's own built-in http client instead of shelling out to a tool that
# isn't installed.
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', r => process.exit(r.statusCode === 200 ? 0 : 1)).on('error', () => process.exit(1))"

CMD ["node", "src/index.js"]
