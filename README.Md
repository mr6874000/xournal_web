# 🖥️ xournal-web

This project sets up a lightweight virtual desktop environment inside a Docker container, accessible through your web browser using noVNC. It includes a virtual framebuffer (Xvfb), the Fluxbox window manager, an X11 VNC server, and the **Xournal application, which you can use directly within your web browser**.

## 🚀 Getting Started

### Prerequisites

* Docker installed on your system.
* Docker Compose installed on your system.

### Building the Image

Clone this repository (or just save the `Dockerfile`, `supervisord.conf`, and `docker-compose.yaml`):

```bash
git clone <your_repository_url>
cd <your_repository_directory>
```

Build the Docker image:

```bash
docker build -t xournal-web .
```

### Running with Docker Compose (Recommended)

Use Docker Compose to easily manage and run the container.

```bash
docker-compose up -d
```

This command will create and start the container named `xournal-web` in detached mode, as defined in the `docker-compose.yaml` file.

### Running without Docker Compose (Manual)

If you prefer not to use Docker Compose, you can build and run the container manually:

```bash
docker build -t xournal-web .
docker run -d --name xournal-web -p 6080:6080 -e DISPLAY=:1 -e VNC_PORT=5901 -e NOVNC_PORT=6080 -e RESOLUTION=1280x800x24 xournal-web
```

## 🌐 Accessing the Virtual Desktop

Open your web browser and navigate to:

```
http://<your_docker_host_ip>:6080
```

For example, if your Docker host IP is `192.168.1.100`, the URL would be:

```
[http://192.168.1.100:6080](http://192.168.1.100:6080)
```

You will see the Fluxbox desktop environment, and you can launch and use the **Xournal application directly within this web-based interface**.

## ⚙️ Included Applications

* **Xvfb:** Virtual Framebuffer for running X11 applications without a physical display.
* **Fluxbox:** A fast and lightweight window manager.
* **X11vnc:** A VNC server allowing remote access to the X display.
* **noVNC:** A web-based VNC client, making the desktop accessible in your browser.
* **Xournal:** An application for taking handwritten notes, sketching, keeping a journal or diary, making annotations on PDF files, etc., **accessible through the web browser**.

## 🛠️ Configuration

Configuration is primarily done through environment variables defined in the `docker-compose.yaml` file:

* `DISPLAY`: The display number used by Xvfb (default: `:1`).
* `VNC_PORT`: The port the VNC server listens on (default: `5901`).
* `NOVNC_PORT`: The port the noVNC proxy listens on (default: `6080`).
* `RESOLUTION`: The screen resolution of the virtual desktop (default: `1280x800x24`).

You can modify these values directly in the `docker-compose.yaml` file.

## 📄 `docker-compose.yaml`

Here is the content of your `docker-compose.yaml` file:

```yaml
version: '3.8'

services:
  xournal-web:
    build: .
    container_name: xournal-web
    image: xournal-web
    ports:
      - "6080:6080"  # Expose noVNC on port 6080
    environment:
      - DISPLAY=:1
      - VNC_PORT=5901
      - NOVNC_PORT=6080
      - RESOLUTION=1280x800x24
    restart: unless-stopped
```

This configuration defines a service named `xournal-web` which builds from the current directory (`.`), names the container `xournal-web`, and uses the image name `xournal-web`. It exposes port `6080` for noVNC and sets the specified environment variables. The `restart: unless-stopped` policy ensures the container restarts automatically unless explicitly stopped.

## 📄 supervisord Configuration

The `supervisord.conf` file manages the different processes within the container, ensuring they start and restart as needed.

* **`xvfb`**: Starts the virtual X server.
* **`fluxbox`**: Starts the window manager.
* **`x11vnc`**: Starts the VNC server, connecting to the virtual display.
* **`novnc`**: Starts the noVNC proxy, bridging the web browser to the VNC server.
* **`xournal`**: Starts the Xournal application.

## 💡 Use Cases

* Running graphical applications like **Xournal** in a headless environment and accessing them via a web browser.
* Remote access to a lightweight desktop for note-taking and PDF annotation through the web.
* Testing and development of GUI applications in a consistent web-accessible environment.

## 📜 License

This project is open-source and available under the [MIT License](LICENSE) (if you have one).
