# Use Node.js base image
FROM node:18

# Set working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json (if available) from the src directory
COPY src/package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code from the src directory
COPY src/ .

# Expose port
EXPOSE 3000

# Command to run the app
CMD [ "node", "000.js" ]
