# Stage 1
FROM alpine:3.8 AS base

RUN apk add --no-cache nodejs-current nodejs-current-npm tini

WORKDIR /usr/src/app/

ENTRYPOINT ["/sbin/tini", "--"]

COPY package*.json ./

# Stage 2
FROM base AS build

COPY . .

RUN npm install && npm run build

# Stage 3
FROM base AS release

COPY --from=build /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/views ./views

EXPOSE 3000

CMD ["npm", "run", "start"]
