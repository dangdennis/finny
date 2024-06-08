# First stage: build dependencies
FROM sbtscala/scala-sbt:eclipse-temurin-jammy-21.0.2_13_1.10.0_3.4.2 as builder

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

# Second stage: package the application into a single JAR
FROM sbtscala/scala-sbt:eclipse-temurin-jammy-21.0.2_13_1.10.0_3.4.2 as assembly

WORKDIR /app

# Copy the build definition files
COPY build.sc ./
COPY mill ./mill
COPY app ./app

# Copy the compiled dependencies from the builder stage
COPY --from=builder /app/out /app/out

# Reinstall Mill
RUN curl -L https://github.com/com-lihaoyi/mill/releases/download/0.11.6/0.11.6 > /usr/local/bin/mill && \
    chmod +x /usr/local/bin/mill

# Package the application into a single JAR
RUN mill app.assembly
    
# Third stage: run the application in a minimal image
FROM azul/zulu-openjdk-alpine:21-jre-headless as runner

WORKDIR /app

COPY --from=assembly /app/out/app/assembly.dest/out.jar /app/out/app/assembly.dest/out.jar

# Expose the port that Cask will run on.
EXPOSE 8080

# Define the command to run your app.
CMD ["java", "-jar", "out/app/assembly.dest/out.jar"]