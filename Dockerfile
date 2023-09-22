# Use build arguments to pass sensitive values
ARG API_TOKEN
ARG ANOTHER_SECRET

# Use the official Node.js image as the base image
FROM node:14

# Set environment variables from build arguments
ENV API_TOKEN=$API_TOKEN
ENV ANOTHER_SECRET=$ANOTHER_SECRET

# Set the working directory to /app
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the entire project to the working directory
COPY . .

# Replace the placeholder in App.jsx and server.js
RUN sed -i "s/HYPERSWITCH_PUBLISHABLE_KEY/${API_TOKEN}/g" ./src/App.jsx
RUN sed -i "s/HYPERSWITCH_API_KEY/${ANOTHER_SECRET}/g" ./server.js

# Expose ports
EXPOSE 4242 3000

# Run start-server and start-client
CMD ["npm", "run", "start-server", "&", "npm", "run", "start-client"]

