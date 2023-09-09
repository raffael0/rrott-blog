# Install dependencies only when needed
FROM node:20.2-alpine AS builder
# Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine to understand why libc6-compat might be needed.
RUN apk add --no-cache libc6-compat
WORKDIR /app
#COPY package.json yarn.lock ./
COPY . .
COPY package.json yarn.lock ./
RUN yarn install --immutable

# Rebuild the source code only when needed
#FROM node:20.2-alpine AS builder
#WORKDIR /app
#COPY --from=deps /app/node_modules ./node_modules
#COPY --from=deps /app/yarn.lock ./yarn.lock
RUN yarn run build

# Production image, copy all the files and run next
FROM node:20.2-alpine AS runner
WORKDIR /app

ENV NODE_ENV production

#Alpine
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001
#RUN groupadd -g 1001 nodejs
#RUN useradd -m -s /bin/bash -u 1001 -g 1001 nextjs
# You only need to copy next.config.js if you are NOT using the default configuration
COPY --from=builder --chown=nextjs:nodejs /app/next.config.js ./
COPY --from=builder --chown=nextjs:nodejs /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static .next/
#COPY --from=builder /app/node_modules ./node_modules
#COPY --from=builder /app/package.json ./package.json

USER nextjs

EXPOSE 3000

# Next.js collects completely anonymous telemetry data about general usage.
# Learn more here: https://nextjs.org/telemetry
# Uncomment the following line in case you want to disable telemetry.
ENV NEXT_TELEMETRY_DISABLED 1

CMD ["node", "server.js"]
