FROM node:22-alpine AS builder

WORKDIR /ws-scrcpy

RUN apk add --no-cache \
        android-tools \
        git \
        make \
        g++

RUN git clone https://github.com/NetrisTV/ws-scrcpy.git .

RUN npm install && \
    npm run dist

FROM node:22-alpine

ENV LANG=C.UTF-8 \
    NODE_ENV=production

WORKDIR /ws-scrcpy

RUN apk add --no-cache android-tools

COPY --from=builder /ws-scrcpy/dist ./dist
COPY --from=builder /ws-scrcpy/node_modules ./node_modules
COPY --from=builder /ws-scrcpy/package.json ./

EXPOSE 8000

USER node

CMD ["node", "dist/index.js"]
