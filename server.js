const http = require('http');
const PORT = process.env.PORT || 3000;

const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end('Stream 24/7 is active and running perfectly!');
});

server.listen(PORT, () => {
  console.log(`Servidor web activo en el puerto ${PORT}`);
});
