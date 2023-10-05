const router=require("express").Router();

const controllerEdificio  = require('../../controllers/edificio/edificio.controller');

router.post('/registrar',controllerEdificio.postEdificio);
router.get('/listar/:nombre?',controllerEdificio.getEdificioName);
router.get('/:id',controllerEdificio.getEdificioById);
router.get('/',controllerEdificio.getEdificio);
router.put('/editar/:id',controllerEdificio.putEdificio);
router.delete('/eliminar/:id',controllerEdificio.deleteEdificio);


module.exports=router;