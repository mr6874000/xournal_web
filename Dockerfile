FROM ubuntu:22.04

# Set environment variables
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

# Set up TigerVNC server
RUN mkdir -p ~/.vnc && \
    echo "x11vnc -forever -usepw -display :1 -rfbport ${VNC_PORT}" > ~/.vnc/x11vnc.sh && \
    chmod +x ~/.vnc/x11vnc.sh

# Install noVNC manually and set up symlinks
RUN mkdir -p /opt/novnc && \
    wget -O /opt/novnc/novnc.zip https://github.com/novnc/noVNC/archive/refs/tags/v1.4.0.zip && \
    unzip /opt/novnc/novnc.zip -d /opt/novnc/ && \
    mv /opt/novnc/noVNC-1.4.0 /opt/novnc/noVNC && \
    ln -s /opt/novnc/noVNC/utils/novnc_proxy /usr/bin/novnc_proxy && \
    ln -s /opt/novnc/noVNC/vnc.html /opt/novnc/index.html

# Supervisor configuration
RUN mkdir -p /etc/supervisor/conf.d
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose ports for VNC and noVNC
EXPOSE ${VNC_PORT} ${NOVNC_PORT}

# Start services
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
