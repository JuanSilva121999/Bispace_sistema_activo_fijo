const router=require("express").Router();

const controllerAltaActivo  = require('../../controllers/activo/altaactivo.controller');

router.post('/registrar',controllerAltaActivo.postAltaActivo);
router.get('/empleadoalta',controllerAltaActivo.getEmpleadoAltaActivo);
router.get('/dataaltaactivo/:id/:nombre?',controllerAltaActivo.getDatosAltaActivoById);
router.get('s/:nombre/',controllerAltaActivo.getAltaActivoCodigo);


router.get('/altas/:nombre?',controllerAltaActivo.getActivoAlta);
router.get('/altaFecha/:fecha',controllerAltaActivo.getActivoAltaFiltroFecha);

router.get('/:id',controllerAltaActivo.getDetalleAltaActivoById);
router.get('/',controllerAltaActivo.getAltaActivo);
router.delete('/eliminar/:id',controllerAltaActivo.deleteAltaActivo);
router.get('/pdfwithqr/:id',controllerAltaActivo.getPDFWithQr);


module.exports=router;