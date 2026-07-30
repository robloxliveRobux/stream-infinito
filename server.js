const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.get('/', (req, res) => res.send('Sistema de Stream 24/7 de Alta Capacidad ACTIVO.'));

app.listen(port, () => console.log(`Puerto de monitoreo abierto: ${port}`));
