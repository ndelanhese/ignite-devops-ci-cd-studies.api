FROM node:20.12.2-alpine3.19 AS build

WORKDIR /usr/src/app

COPY package.json pnpm-lock* ./
RUN corepack enable pnpm && pnpm i --frozen-lockfile

COPY . .

RUN corepack enable pnpm && pnpm run build
RUN corepack enable pnpm && pnpm i --production && pnpm prune

FROM node:20.12.2-alpine3.19

WORKDIR /usr/src/app

COPY --from=build /usr/src/app/package.json ./package.json
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules

EXPOSE 3000

CMD [ "pnpm", "run", "start:prod" ]