const { spawn } = require('child_process');
const http = require('http');
const fs = require('fs');

// Servidor HTTP básico para que Fly.io mantenga la máquina encendida
const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end('Stream service is running 24/7\n');
});

server.listen(3000, () => {
  console.log('Servidor HTTP escuchando en el puerto 3000');
  startStreaming();
});

function startStreaming() {
  const videoUrl = process.env.VIDEO_URL;
  const ytKey = process.env.YT_KEY;

  console.log('Iniciando proceso de descarga y transmisión...');

  // Comando para descargar y transmitir en bucle infinito con FFmpeg
  const cmd = `rm -f video_final.mp4 && wget -O video_final.mp4 "${videoUrl}" && while true; do ffmpeg -re -stream_loop -1 -i video_final.mp4 -vf "scale=-2:720" -c:v libx264 -preset ultrafast -b:v 1500k -maxrate 1500k -bufsize 3000k -pix_fmt yuv420p -g 60 -keyint_min 60 -c:a aac -b:a 128k -f flv "rtmp://a.rtmp.youtube.com/live2/${ytKey}"; sleep 5; done`;

  const streamProcess = spawn(cmd, { shell: true, stdio: 'inherit' });

  streamProcess.on('close', (code) => {
    console.log(`El proceso de streaming terminó con código ${code}, reiniciando en 5 segundos...`);
    setTimeout(startStreaming, 5000);
  });
}
