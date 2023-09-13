const router=require("express").Router();

const controllerRevalorizacion  = require('../../controllers/revalorizacion/revalorizacion.controller');

router.post('/registrar',controllerRevalorizacion.postRevalorizacion);
router.get('/:id',controllerRevalorizacion.getRevalorizacionById);
router.put('/editar/:id',controllerRevalorizacion.putRevalorizacion);
router.delete('/eliminar/:id',controllerRevalorizacion.deleteRevalorizacion);
router.get('s/:nombre?',controllerRevalorizacion.getRevalorizacionName);



module.exports=router;