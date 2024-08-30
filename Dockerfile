FROM node:14

# Set the working directory inside the container
WORKDIR /ReacApp_Project

# Copy the package.json to the working directory
COPY package.json ./

# Install dependencies
RUN npm install

# Copy the application code from the src directory to the working directory
COPY src/ ./src/

# Expose port (if your app runs on a specific port, change it accordingly)
EXPOSE 3000

# Define the command to run your app
CMD ["node", "src/OOO.js"]

