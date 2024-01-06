# Use the official Dart image as the base image for the first stage
FROM cirrusci/flutter:2.2.3  AS builder

# Set the working directory
WORKDIR /app

# Copy only the necessary files for building the web app
COPY . .

RUN flutter channel master
RUN flutter upgrade
RUN flutter config --enable-web

# Install dependencies
RUN flutter pub get

# Build the Flutter web app
RUN dart pub global activate webdev
RUN dart pub global run webdev build

# Use NGINX as the base image for the second stage
FROM nginx:alpine

# Set the working directory for NGINX
WORKDIR /usr/share/nginx/html

# Copy the built Flutter web app from the builder stage
COPY --from=builder /app/build/web/ .

# Expose port 80 for serving the web application
EXPOSE 80

# Command to start the web server
CMD ["nginx", "-g", "daemon off;"]
