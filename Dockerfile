FROM node:20-alpine AS base

# Install dependencies only when needed
FROM base AS deps
WORKDIR /app

# Install pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate

COPY package.json ./
# We attempt to copy the lockfile if it exists, but we don't fail if it doesn't
# COPY pnpm-lock.yaml ./ 

# Install dependencies
RUN pnpm install

# Rebuild the source code only when needed
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Install pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate

# Build the application
RUN pnpm run build

# Production image, copy all the files and run
FROM base AS runner
WORKDIR /app

ENV NODE_ENV=production

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/serve.json ./serve.json

EXPOSE 8080

CMD ["npm", "run", "start"]
