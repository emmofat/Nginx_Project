# Stage 1: Build custom index page (optional)
FROM alpine:latest AS builder
WORKDIR /app
COPY html/ .
# Add any build steps here (e.g., npm run build for static sites)

# Stage 2: Nginx with custom config
FROM nginx:alpine

# Remove default nginx config and html
RUN rm -rf /etc/nginx/conf.d/default.conf \
    && rm -rf /usr/share/nginx/html/*

# Copy custom nginx configuration
COPY nginx/conf.d/default.conf /etc/nginx/conf.d/

# Copy static files
COPY --from=builder /app/ /usr/share/nginx/html/
# Or directly copy: COPY html/ /usr/share/nginx/html/

# Expose port
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/ || exit 1

# Run nginx (default from base image)
