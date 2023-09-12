const router = require('express').Router();

const user  = require('./usuario/usuario.router');
const activo=require('./activos/activo.router');
const alta= require('./activos/altaactivo.router')
const ambiente  = require('./ambiente/ambiente.routes');
const backup = require('./backup/backups.routes')


router.use('/usr',user);
router.use('/activo',activo);
router.use('/act_alta',alta);
router.use('/ambiente',ambiente)
router.use('backup',backup)

module.exports = router;
