# Use the official Flutter Docker image as the base image
FROM cirrusci/flutter:stable

# Set the working directory in the container
WORKDIR /app

# Copy the pubspec.yaml and pubspec.lock files to the container
COPY pubspec.yaml pubspec.lock ./

# Install dependencies
RUN flutter pub get

# Copy the rest of the application code to the container
COPY . .

# Build the Flutter app for release
RUN flutter build apk --release

# Specify the command to run when the container starts
CMD ["flutter", "run"]
