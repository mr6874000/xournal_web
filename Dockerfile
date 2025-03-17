FROM ubuntu:22.04

# Set environment variables (consistent with the rest of your setup)
ENV DEBIAN_FRONTEND=noninteractive \
    HOME=/root \
    DISPLAY=:1 \
    VNC_PORT=5901 \
    NOVNC_PORT=6080 \
    RESOLUTION=1280x800x24

# Install necessary packages
RUN apt update && apt install -y \
    x11vnc \
    xvfb \
    fluxbox \
    xournal \
    novnc \
    websockify \
    unzip \
    supervisor \
    wget \
    curl \
    && apt clean && rm -rf /var/lib/apt/lists/*

# Install noVNC manually and set up symlinks (no changes here, but kept for completeness)
RUN mkdir -p /opt/novnc && \
    wget -O /opt/novnc/novnc.zip https://github.com/novnc/noVNC/archive/refs/tags/v1.4.0.zip && \
    unzip /opt/novnc/novnc.zip -d /opt/novnc/ && \
    mv /opt/novnc/noVNC-1.4.0 /opt/novnc/noVNC && \
    ln -s /opt/novnc/noVNC/utils/novnc_proxy /usr/bin/novnc_proxy && \
    ln -s /opt/novnc/noVNC/vnc.html /opt/novnc/index.html

# Supervisor configuration (moved to Dockerfile for better organization)
RUN rm -f /etc/supervisor/conf.d/supervisord.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf


# Expose ports
EXPOSE ${VNC_PORT} ${NOVNC_PORT}

# Start supervisord as the main process
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]