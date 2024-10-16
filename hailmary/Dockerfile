# Use the official Rust image as the builder
FROM rust:latest as builder

# Set the working directory
WORKDIR /usr/src/hailmary

# Copy the Cargo.toml and Cargo.lock files
COPY Cargo.toml Cargo.lock ./

# Create a new empty shell project
RUN mkdir src && echo "fn main() { println!(\"Hello, world!\"); }" > src/main.rs

# Build the dependencies
RUN cargo build --release
RUN rm -f target/release/deps/hailmary*

# Copy the source code
COPY . .

# Build the actual application
RUN cargo build --release

# Use a smaller base image for the final image
FROM debian:buster-slim

# Copy the compiled binary from the builder
COPY --from=builder /usr/src/hailmary/target/release/hailmary .

# Set the command to run the binary
CMD ["./hailmary"]