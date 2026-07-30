FROM node:18-bullseye-slim

RUN apt-get update && apt-get install -y ffmpeg wget

WORKDIR /app

COPY package*.json ./
RUN npm install
COPY . .

EXPOSE 3000

CMD node server.js & \
    rm -f video_final.mp4 && \
    wget -O video_final.mp4 "$VIDEO_URL" && \
    while true; do ffmpeg -re -stream_loop -1 -i video_final.mp4 \
    -c:v libx264 -preset superfast -b:v 1000k -maxrate 1000k -bufsize 2000k \
    -pix_fmt yuv420p -g 60 -c:a aac -b:a 96k -ar 44100 \
    -f flv "rtmp://a.rtmp.youtube.com/live2/$YT_KEY"; sleep 5; done
