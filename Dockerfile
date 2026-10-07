FROM node:24-bookworm-slim AS build
WORKDIR /app
COPY package*.json ./
COPY packages/shared/package.json ./packages/shared/package.json
COPY ekyc-agent-frontend/package.json ./ekyc-agent-frontend/package.json
RUN npm ci --ignore-scripts
COPY . .
RUN npm run lint && npm test && npm run build
FROM nginxinc/nginx-unprivileged:1.28-alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/ekyc-agent-frontend/dist /usr/share/nginx/html
EXPOSE 8080
