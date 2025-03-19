# Stage 1: Build stage
FROM node:18-alpine AS build

# Set working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy all the application files into the container
COPY . .

# Build the application (for example, React app)
RUN npm run build

# Stage 2: Production stage
FROM nginx:alpine

# Copy the build folder from the previous build stage
COPY --from=build /app/build /usr/share/nginx/html

# Expose the port the app will be available on
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]