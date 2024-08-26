FROM node:alpine3.20 AS base-stage
WORKDIR /usr/app/next-api
COPY package.json pnpm-lock.yaml ./
RUN npm install -g pnpm && \
    pnpm install --frozen-lockfile

FROM base-stage AS build-stage
WORKDIR /usr/app/next-api
COPY . ./
RUN pnpm run build


FROM node:alpine3.20 AS final-stage
WORKDIR /usr/app/next-api
COPY --from=build-stage /usr/app/next-api/public ./public
COPY --from=build-stage /usr/app/next-api/next.config.mjs ./
COPY --from=build-stage /usr/app/next-api/.next/standalone ./
COPY --from=build-stage /usr/app/next-api/.next/static ./.next/static

CMD ["node", "server.js"]
