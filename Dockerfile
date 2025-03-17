# Use KasmVNC Ubuntu-based desktop image
FROM kasmweb/ubuntu-focal-desktop:1.13.0

# Switch to root user to install packages
USER root

# Disable the faulty Chrome repo to prevent GPG errors
RUN rm -f /etc/apt/sources.list.d/google-chrome.list || true

# Install software-properties-common, add the universe repository, and *then* update and install xournalpp
RUN apt-get update && \
    apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository universe && \
    apt-get update && \
    apt-get install -y --no-install-recommends xournalpp && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Switch back to non-root user for security
USER 1000

# Set up environment for KasmVNC
ENV USER=kasm-user
ENV HOME=/home/${USER}

# Set the working directory
WORKDIR ${HOME}

# Make sure Xournal++ starts on login.  Use .bashrc
RUN echo 'xournalpp &' >> /home/${USER}/.bashrc && \
    chown ${USER}:${USER} /home/${USER}/.bashrc

# Set the default command to start KasmVNC
CMD ["/usr/bin/supervisord"]