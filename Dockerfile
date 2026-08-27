# Build stage for frontend
FROM node:20-alpine AS builder

WORKDIR /app

# Install dependencies
COPY package.json package-lock.json ./
RUN npm ci

# Copy source and build
COPY . .

# Set production URL for the WebSocket server
ARG VITE_PRODUCTION_URL=wss://graph.jeffemmett.com
ENV VITE_PRODUCTION_URL=$VITE_PRODUCTION_URL

RUN npm run build

# Production stage - nginx for static files + y-websocket for collaboration
FROM node:20-alpine AS production

WORKDIR /app

# Install nginx
RUN apk add --no-cache nginx

# Copy built frontend
COPY --from=builder /app/dist /usr/share/nginx/html

# Create nginx config
RUN mkdir -p /etc/nginx/http.d
COPY nginx.conf /etc/nginx/http.d/default.conf

# Install y-websocket server
RUN npm install y-websocket

# Copy startup script
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

EXPOSE 80 1234

CMD ["/app/start.sh"]
