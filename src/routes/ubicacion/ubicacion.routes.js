const router=require("express").Router();

const controllerUbicacion  = require('../../controllers/ubicacion/ubicacion.controller');

router.post('/registrar',controllerUbicacion.postUbicacion);
router.get('/listar/:nombre?',controllerUbicacion.getUbicacionName);
router.get('/:id',controllerUbicacion.getUbicacionById);
router.put('/editar/:id',controllerUbicacion.putUbicacion);
router.delete('/eliminar/:id',controllerUbicacion.deleteUbicacion);
router.get('/listar/:nombre?',controllerUbicacion.getUbicacionName);



module.exports=router;