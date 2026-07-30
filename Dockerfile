FROM node:18-bullseye-slim

RUN apt-get update && apt-get install -y ffmpeg wget

WORKDIR /app

COPY package*.json ./
RUN npm install
COPY . .

EXPOSE 3000

CMD node server.js & \
    rm -f video_final.mp4 video_optimizado.mp4 && \
    wget -O video_final.mp4 "$VIDEO_URL" && \
    ffmpeg -i video_final.mp4 -vf "scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2" -c:v libx264 -preset fast -b:v 1500k -maxrate 1500k -bufsize 3000k -pix_fmt yuv420p -g 60 -c:a aac -b:a 128k video_optimizado.mp4 && \
    while true; do ffmpeg -re -stream_loop -1 -i video_optimizado.mp4 -c copy -f flv "rtmp://a.rtmp.youtube.com/live2/$YT_KEY"; sleep 5; done
