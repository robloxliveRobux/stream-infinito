FROM node:18-bullseye-slim

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y ffmpeg wget

WORKDIR /app

COPY package*.json ./
RUN npm install
COPY . .

EXPOSE 3000

# Script maestro: Levanta la web, descarga el video de la URL y busca cualquier .mp4 para transmitirlo en bucle infinito
CMD node server.js & \
    if [ ! -f "video_final.mp4" ]; then wget -O video_final.mp4 "$VIDEO_URL"; fi && \
    while true; do ffmpeg -re -stream_loop -1 -i video_final.mp4 -c:v copy -c:a copy -f flv "rtmp://a.rtmp.youtube.com/live2/$YT_KEY"; sleep 5; done
