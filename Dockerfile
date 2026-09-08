FROM node:20-alpine AS build

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --ignore-scripts
COPY tsconfig.json ./
COPY src/ ./src/
RUN npx tsc && chmod 755 build/index.js

FROM node:20-alpine

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --ignore-scripts --omit=dev
COPY --from=build /app/build ./build

ENV PORT=3000
ENV NOTION_MARKDOWN_CONVERSION=true

EXPOSE 3000

CMD ["node", "--max-old-space-size=64", "build/index.js", "--transport", "http"]
