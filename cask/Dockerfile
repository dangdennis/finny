# First stage: build dependencies
# FROM hseeberger/scala-sbt:11.0.13_1.5.5_2.13.7 as builder
FROM sbtscala/scala-sbt:eclipse-temurin-jammy-17.0.10_7_1.10.0_3.4.2 as builder

# Set the working directory inside the container.
WORKDIR /app

# Copy the build definition files
COPY build.sc ./
COPY mill ./mill
COPY app ./app

# Install Mill
RUN curl -L https://github.com/com-lihaoyi/mill/releases/download/0.11.6/0.11.6 > /usr/local/bin/mill && \
    chmod +x /usr/local/bin/mill

# Build the dependencies first to cache them
RUN mill app.compile

# Second stage: build the application
# FROM hseeberger/scala-sbt:11.0.13_1.5.5_2.13.7
FROM sbtscala/scala-sbt:eclipse-temurin-jammy-17.0.10_7_1.10.0_3.4.2 as assembly

# Set the working directory inside the container.
WORKDIR /app

# Copy the build definition files again
COPY build.sc ./
COPY mill ./mill
COPY app ./app

# Copy the compiled dependencies from the builder stage
COPY --from=builder /app/out /app/out

# Reinstall Mill
RUN curl -L https://github.com/com-lihaoyi/mill/releases/download/0.11.6/0.11.6 > /usr/local/bin/mill && \
    chmod +x /usr/local/bin/mill

# Build the application
RUN mill app.assembly

FROM eclipse-temurin:22.0.1_8-jre as runner

WORKDIR /app

COPY --from=assembly /app/out/app/assembly.dest/out.jar /app/out/app/assembly.dest/out.jar

# Expose the port that Cask will run on.
EXPOSE 8080

# Define the command to run your app.
CMD ["java", "-jar", "out/app/assembly.dest/out.jar"]