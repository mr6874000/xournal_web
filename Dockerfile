FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    HOME=/root \
    DISPLAY=:1 \
    VNC_PORT=5901 \
    NOVNC_PORT=6080 \
    RESOLUTION=1280x800x24

# Install necessary packages, including xournalpp and its dependencies
RUN apt update && apt install -y \
    x11vnc \
    xvfb \
    fluxbox \
    xournalpp \
    novnc \
    websockify \
    unzip \
    supervisor \
    wget \
    curl \
    libgtk-3-0 \
    libgl1-mesa-glx \
    libglu1-mesa \
    libpoppler-glib8 \
    && apt clean && rm -rf /var/lib/apt/lists/*

# Install noVNC manually and set up symlinks
RUN mkdir -p /opt/novnc && \
    wget -O /opt/novnc/novnc.zip https://github.com/novnc/noVNC/archive/refs/tags/v1.4.0.zip && \
    unzip /opt/novnc/novnc.zip -d /opt/novnc/ && \
    mv /opt/novnc/noVNC-1.4.0 /opt/novnc/noVNC && \
    ln -s /opt/novnc/noVNC/utils/novnc_proxy /usr/bin/novnc_proxy && \
    ln -s /opt/novnc/noVNC/vnc.html /opt/novnc/index.html

# Create the Fluxbox configuration file during the build.  MUCH more reliable.
RUN mkdir -p /root/.fluxbox && \
    echo "[app] (name=xournalpp)" > /root/.fluxbox/apps && \
    echo "  [Deco]        {NONE}" >> /root/.fluxbox/apps && \
    echo "  [Fullscreen]  {yes}" >> /root/.fluxbox/apps && \
    echo "[end]" >> /root/.fluxbox/apps

# Supervisor configuration (Modified - see below)
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose ports
EXPOSE ${VNC_PORT} ${NOVNC_PORT}

# Start supervisord as the main process
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]