# Use a base image with Node.js and npm
FROM node:14 as build

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy the application files
COPY . .

# Build the React application
RUN npm run build

# Use a lightweight base image for serving the application
FROM nginx:alpine

# Copy the built application from the previous stage
COPY --from=build /app/build /usr/share/nginx/html


# Replace the placeholder in App.jsx and server.js
RUN sed -i 's/HYPERSWITCH_PUBLISHABLE_KEY/pk_snd_07060e063b3749ff820fa161802785a8/g' ./src/App.jsx
RUN sed -i 's/HYPERSWITCH_API_KEY/api key: snd_sbSQ5rR7AoXiUPQh5KNlIud7gGDOT7ikViQJzWZ3UJ6JAy17aU6PJe8NpJS8QifC/g' ./server.js

# Expose ports
EXPOSE 4242 3000 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
