FROM node:20-slim

WORKDIR /app

COPY package.json .
RUN npm install --omit=dev

COPY src ./src

ARG APP_VERSION=dev
ENV APP_VERSION=${APP_VERSION}

# node:20-slim already ships a non-root "node" user (uid 1000).
RUN chown -R node:node /app
USER node

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', r => process.exit(r.statusCode === 200 ? 0 : 1)).on('error', () => process.exit(1))"

CMD ["node", "src/index.js"]
