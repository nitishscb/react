# Use the official Node.js image as the base image
FROM node:14

# Set the working directory to /app
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the entire project to the working directory
COPY . .

# Replace the placeholder in App.jsx and server.js
RUN sed -i 's/HYPERSWITCH_PUBLISHABLE_KEY/pk_snd_07060e063b3749ff820fa161802785a8/g' ./src/App.jsx
RUN sed -i 's/HYPERSWITCH_API_KEY/api key: snd_sbSQ5rR7AoXiUPQh5KNlIud7gGDOT7ikViQJzWZ3UJ6JAy17aU6PJe8NpJS8QifC/g' ./server.js

# Expose ports
EXPOSE 4242 3000

# Run the server and client
CMD npm run start-server & npm run start-client

