FROM node:18-bullseye-slim

# Inyectar dependencias: FFmpeg para streaming y Wget para descargas pesadas
RUN apt-get update && apt-get install -y ffmpeg wget

WORKDIR /app

# Instalar estructura del servidor
COPY package*.json ./
RUN npm install

# Copiar el código
COPY . .

EXPOSE 3000

# Ejecución maestra: Inicia el ping web, descarga el video en la nube e inicia el bucle RTMP
CMD node server.js & wget -O video.mp4 "$VIDEO_URL" && ffmpeg -re -stream_loop -1 -i video.mp4 -c:v copy -c:a copy -f flv "rtmp://a.rtmp.youtube.com/live2/$YT_KEY"
