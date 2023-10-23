const express = require('express');
const cors = require('cors');
const morgan = require('morgan');
const database = require('./database/db');
const path = require("path");

class Server {
  constructor() {
    this.app = express();
    this.port = process.env.PORT || 5051;
    this.middlewares();
    this.routes();
  }

  middlewares() {
    this.app.use(cors());
    this.app.use(express.json());
     // directorio publico
    this.app.use(express.static('public'));
    this.app.use(morgan('dev'));
  }

  routes() {
    this.app.use('/api', require('./routes'));
     this.app.get('*', (req, res) => {
       res.sendFile(path.resolve(__dirname, '../public/index.html'));
     });
  }

  listen() {
    this.app.listen(this.port, async () => {
      //await database.sync();
      console.log('Servidor corriendo en puerto:', this.port);
    });
  }
}

module.exports = Server;
