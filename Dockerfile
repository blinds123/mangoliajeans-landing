FROM node:18-alpine

WORKDIR /app

# Copy files
COPY . .

# Install http-server for serving the site
RUN npm install -g http-server

# Expose port
EXPOSE 8000

# Serve the site
CMD ["http-server", "-p", "8000", "-c-1"]
