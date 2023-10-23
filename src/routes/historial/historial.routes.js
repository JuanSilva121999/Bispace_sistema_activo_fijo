const router=require("express").Router();

const controllerHistorial  = require('../../controllers/historial/historial.controller');

//router.post('/registrar',controllerHistorial.postHistorial);
//router.get('/:id',controllerHistorial.getHistorialById);
//router.put('/editar/:id',controllerHistorial.putHistorial);
//router.delete('/eliminar/:id',controllerHistorial.deleteHistorial);
//srouter.get('/:nombre?',controllerHistorial.getHistorialName);

router.get('/altas/:nombre?',controllerHistorial.getHistorialActivosFijos);
router.get('/altascod/:nombre',controllerHistorial.getHistorialActivosFijosCod);
router.get('/ufvs/:nombre?',controllerHistorial.getHistorialDepreciaciones)
router.get('/asignaciones/:id',controllerHistorial.getHistorialAsignaciones)
router.get('/mantenimiento/:id',controllerHistorial.getHistorialMantenimiento)
router.get('/devoluciones/:id',controllerHistorial.getHistorialDevoluciones)

module.exports=router;