# Stage 1: Build the React app
FROM node:14.17-alpine AS build

WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the app's source code
COPY . .

# Build the app
RUN npm run build

# Stage 2: Serve the app with NGINX
FROM nginx:1.21-alpine

# Copy the built app from the previous stage
COPY --from=build /app/build /usr/share/nginx/html

# Copy NGINX configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose the container port
EXPOSE 80

# Start NGINX server
CMD ["nginx", "-g", "daemon off;"]
