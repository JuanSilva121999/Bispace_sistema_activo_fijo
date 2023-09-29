const router=require("express").Router();

const controllerHistorial  = require('../../controllers/historial/historial.controller');

//router.post('/registrar',controllerHistorial.postHistorial);
//router.get('/:id',controllerHistorial.getHistorialById);
//router.put('/editar/:id',controllerHistorial.putHistorial);
//router.delete('/eliminar/:id',controllerHistorial.deleteHistorial);
//srouter.get('/:nombre?',controllerHistorial.getHistorialName);

router.get('/altas/:nombre?',controllerHistorial.getHistorialActivosFijos);
router.get('/altascod/:nombre',controllerHistorial.getHistorialActivosFijosCod);
router.get('/ufvs/:nombre',controllerHistorial.getHistorialDepreciaciones)


module.exports=router;