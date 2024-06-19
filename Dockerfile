FROM node:20.14.0-alpine3.19 AS build

WORKDIR /usr/src/app

RUN npm install -g pnpm

COPY package.json pnpm-lock.yaml ./

RUN pnpm install --frozen-lockfile

COPY . .

RUN pnpm run build
RUN pnpm install --prod --frozen-lockfile

FROM node:20.14.0-alpine3.19

WORKDIR /usr/src/app

RUN npm install -g pnpm

COPY --from=build /usr/src/app/package.json ./package.json
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules

EXPOSE 3000

CMD [ "pnpm", "run", "start:prod" ]
