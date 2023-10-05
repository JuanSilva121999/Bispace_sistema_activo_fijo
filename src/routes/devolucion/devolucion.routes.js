const router=require("express").Router();

const controllerDevolucion  = require('../../controllers/devolucion/devolucion.controller');

router.post('/registrar',controllerDevolucion.postAltaDevolucion);
router.get('/:nombre?',controllerDevolucion.getDevolucionNombre);


module.exports=router;