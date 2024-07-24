# Use Node.js base image
FROM node:18

# Set working directory
WORKDIR /Rearc App_Project/src

# Copy package.json and install dependencies
COPY Rearc App_Project/package*.json ./
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose port
EXPOSE 3000

# Command to run the app
CMD [ "node", "index.js" ]

