FROM node:18-bullseye-slim

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y ffmpeg wget

WORKDIR /app

COPY package*.json ./
RUN npm install
COPY . .

EXPOSE 3000

# Script blindado: Descarga el video y lo procesa con códecs universales compatibles con YouTube
CMD node server.js & \
    if [ ! -f "video_final.mp4" ]; then wget -O video_final.mp4 "$VIDEO_URL"; fi && \
    while true; do ffmpeg -re -stream_loop -1 -i video_final.mp4 \
    -c:v libx264 -preset superfast -b:v 1500k -maxrate 1500k -bufsize 3000k \
    -pix_fmt yuv420p -g 60 -c:a aac -b:a 128k -ar 44100 \
    -f flv "rtmp://a.rtmp.youtube.com/live2/$YT_KEY"; sleep 5; done
