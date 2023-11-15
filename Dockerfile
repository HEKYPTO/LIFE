# Use a base image with Zsh installed
FROM debian:latest

# Install Zsh and any necessary packages
RUN apt-get update && apt-get install -y zsh

# Set the TERM environment variable
ENV TERM xterm

# Copy your script into the container
COPY life.zsh /life.zsh

# Set the script as executable
RUN chmod +x /life.zsh

# Set the entrypoint for the container
CMD ["/life.zsh"]
