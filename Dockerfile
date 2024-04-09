FROM debian:latest
ARG UID=1000
ARG GID=1000

## Install Xtightvnc, openbox, websockify, supervisor, lxterminal, htop and sudo
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends tigervnc-standalone-server openbox python3-websockify supervisor lxterminal htop sudo && \
    groupadd -g $UID nonroot && \
    useradd -s /bin/bash -m -u $GID -g nonroot nonroot && \
    echo 'nonroot ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    rm -rf /var/lib/apt/lists && \
    mkdir -p /usr/share/desktop-directories && \
    apt-get autoremove -y && apt-get clean -y

## Install latest noVNC
USER nonroot
WORKDIR /home/nonroot
RUN sudo apt-get update -y && sudo apt-get install git ca-certificates -y && \
    git clone https://github.com/novnc/noVNC.git && mkdir novnc && \
    cp -R noVNC/app noVNC/core noVNC/vendor/ noVNC/vnc.html novnc && \
    sudo chown -R root:root novnc && sudo mv novnc /usr/share/ && \
    rm -rf noVNC && sudo apt-get remove git ca-certificates -y && sudo apt-get autoremove -y && sudo apt-get clean -y
COPY <<EOF /usr/share/novnc/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <meta http-equiv="refresh" content="0; url=vnc.html?resize=remote&quality=0&compression=0&autoconnect=true">
    <title>Redirecting...</title>
</head>
<body>
    <p>If you are not redirected automatically, <a href="vnc.html?resize=remote&quality=0&compression=0&autoconnect=true">click here</a>.</p>
</body>
</html>
EOF

USER root

COPY <<EOF /etc/supervisord.conf
[supervisord]
nodaemon=true
pidfile=/tmp/supervisord.pid
logfile=/dev/fd/1
logfile_maxbytes=0

[program:x11]
priority=0
command=/usr/bin/Xtigervnc -localhost -rfbport 5900 -SecurityTypes None -AlwaysShared -AcceptKeyEvents -AcceptPointerEvents -AcceptSetDesktopSize -SendCutText -AcceptCutText :0
autorestart=true
stdout_logfile=/dev/fd/1
stdout_logfile_maxbytes=0
redirect_stderr=true

[program:websockify]
priority=0
command=websockify --web=/usr/share/novnc/ 6080 localhost:5900
autorestart=true
stdout_logfile=/dev/fd/1
stdout_logfile_maxbytes=0
redirect_stderr=true

[program:openbox]
priority=1
command=/usr/bin/openbox
environment=DISPLAY=:0
autorestart=true
stdout_logfile=/dev/fd/1
stdout_logfile_maxbytes=0
redirect_stderr=true
EOF

COPY <<EOF /etc/xdg/openbox/menu.xml
<?xml version="1.0" encoding="utf-8"?>
<openbox_menu xmlns="http://openbox.org/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://openbox.org/ file:///usr/share/openbox/menu.xsd">
    <menu id="root-menu" label="Openbox 3">
        <item label="Terminal">
            <action name="Execute">
                <execute>/usr/bin/x-terminal-emulator</execute>
            </action>
        </item>
        <item label="Htop">
            <action name="Execute">
                <execute>/usr/bin/x-terminal-emulator -e htop</execute>
            </action>
        </item>
    </menu>
</openbox_menu>
EOF

USER nonroot
CMD ["sh", "-c", "supervisord"]

## Open ports
EXPOSE 6080
