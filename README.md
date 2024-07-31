# Rearc-App

Docker and CI/CD Workflow for EKS Deployment
Overview
This section outlines the steps to create a Dockerfile, set up a GitHub Actions workflow for CI/CD, and deploy the application to Amazon EKS.

1. Creating the Dockerfile
To containerize your application, create a Dockerfile in the root directory of your project. Below is a sample Dockerfile configuration:

dockerfile
Copy code
# Use the official Node.js image as the base image
FROM node:14

# Set the working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the application source code
COPY . .

# Expose the application port
EXPOSE 80

# Command to run the application
CMD ["npm", "start"]
2. Kubernetes Deployment Configuration
Create a kubernetes.yaml file to define the Kubernetes deployment for your application. Below is a sample configuration:

yaml
Copy code
apiVersion: apps/v1
kind: Deployment
metadata:
  name: # deployment name
  labels:
    app: reac-app
spec:
  replicas: xx  # Number of desired replicas
  selector:
    matchLabels:
      app: # match label
  template:
    metadata:
      labels:
        app: #label name
    spec:
      containers:
      - name: # caontainer name
        image: # Public ECR image URL
        imagePullPolicy: Always
        ports:
        - containerPort: 80
        env:
        - name: SECRET_WORD
          valueFrom:
            secretKeyRef:
              name: secret-word
              key: SECRET_WORD
3. LoadBalancer Service Configuration
Create a service.yaml file to expose your application through a LoadBalancer. Below is a sample configuration:

yaml
Copy code
apiVersion: v1
kind: Service
metadata:
  name: # service nane
spec:
  type: LoadBalancer
  selector:
    app: # selector name
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
4. Setting Up GitHub Actions Workflow
Create a GitHub Actions workflow file in your repository to automate the build and deployment process. The workflow file should be located at .github/workflows/deploy.yml. Below is a sample configuration:

yaml
Copy code
name: Build and Deploy to EKS

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Set up Node.js
        uses: actions/setup-node@v2
        with:
          node-version: '14'

      - name: Build Docker image
        run: |
          docker build -t public.ecr.aws/q4e4w1b3/reac_app:latest .

      - name: Log in to Amazon ECR
        run: |
          aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/q4e4w1b3

      - name: Push Docker image to ECR
        run: |
          docker push public.ecr.aws/q4e4w1b3/reac_app:latest

      - name: Set up kubectl
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1

      - name: Update kubeconfig
        run: |
          aws eks update-kubeconfig --name rearc-eks-ZfmixeRF --region us-east-1

      - name: Deploy to EKS
        run: |
          kubectl apply -f k8s/kubernetes.yaml
          kubectl apply -f k8s/service.yaml
5. Deployment Process
Once the GitHub Actions workflow is set up, every push to the main branch will trigger the CI/CD pipeline to build the Docker image, push it to Amazon ECR, and deploy the application to your EKS cluster.

6. Verifying Deployment
After the deployment is complete, verify that the application is running by accessing the service using the external LoadBalancer IP. Follow the steps outlined in the Deployment Verification Steps section to confirm that your application is functioning as expected.


Deployment Verification Steps
After deploying the application, each each component is verified to ensure they are functioning correctly by performing the following tests using the external IP of the LoadBalancer

1. Public Cloud & Index Page (contains the secret word)
The below commands are to Verify that the application is accessible and displays the index page:

curl http://<external-ip>/
2. Docker Check
Check if the Docker-related endpoint is accessible:

curl http://<external-ip>/docker

3. Secret Word Check
Verifies that the application returns the secret word:

curl http://<external-ip>/secret_word
4. Load Balancer Check
Ensures that the load balancer is functioning correctly:

curl http://<external-ip>/loadbalanced

5. TLS Check (if applicable)
Upon setting up TLS, verify that the HTTPS connection works (use -k to bypass certificate validation if necessary):

curl -k https://<external-ip>


LoadBalancer's external IP is:
af785e6512905404d9c3b5ada35bd8ce-1242257563.us-east-1.elb.amazonaws.com

The following commands are then run:


curl http://af785e6512905404d9c3b5ada35bd8ce-1242257563.us-east-1.elb.amazonaws.com/
curl http://af785e6512905404d9c3b5ada35bd8ce-1242257563.us-east-1.elb.amazonaws.com/docker
curl http://af785e6512905404d9c3b5ada35bd8ce-1242257563.us-east-1.elb.amazonaws.com/secret_word
curl http://af785e6512905404d9c3b5ada35bd8ce-1242257563.us-east-1.elb.amazonaws.com/loadbalanced
curl -k https://af785e6512905404d9c3b5ada35bd8ce-1242257563.us-east-1.elb.amazonaws.com
