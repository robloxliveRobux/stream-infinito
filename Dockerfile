FROM node:18-bullseye-slim

RUN apt-get update && apt-get install -y ffmpeg wget

WORKDIR /app

COPY package*.json ./
RUN npm install
COPY . .

EXPOSE 3000

CMD rm -f video_final.mp4 && \
    wget -O video_final.mp4 "$VIDEO_URL" && \
    while true; do ffmpeg -re -stream_loop -1 -i video_final.mp4 \
    -vf "scale=-2:720" \
    -c:v libx264 -preset ultrafast -b:v 1500k -maxrate 1500k -bufsize 3000k \
    -pix_fmt yuv420p -g 60 -keyint_min 60 -c:a aac -b:a 128k \
    -f flv "rtmp://a.rtmp.youtube.com/live2/$YT_KEY"; sleep 5; done
