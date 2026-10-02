FROM node:16-bookworm AS builder

WORKDIR /ws-scrcpy

RUN git clone https://github.com/NetrisTV/ws-scrcpy.git .

RUN npm install && \
    npm run dist

FROM node:16-bookworm-slim

ENV LANG=C.UTF-8 \
    NODE_ENV=production

WORKDIR /ws-scrcpy

RUN apt update && \
    apt install android-tools-adb -y \
    && rm -rf /var/lib/apt/lists/* \
    && apt clean
    
COPY --from=builder /ws-scrcpy/dist ./dist
COPY --from=builder /ws-scrcpy/node_modules ./node_modules
COPY --from=builder /ws-scrcpy/package.json ./

EXPOSE 8000

USER node

CMD ["node", "dist/index.js"]
