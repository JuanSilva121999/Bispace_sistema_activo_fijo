const router=  require("express").Router();

const controllerQR =  require ('../../controllers/qrcont/qrcont.constroller');

router.get('/generar' ,controllerQR.generarQR);
router.get('/generar/:id' , controllerQR.generarQRById)
router.get('/listarQR',controllerQR.listarQR)
router.post('/buscarQR',controllerQR.buscarQR)
router.delete('/eliminar/:id', controllerQR.deleteQR)
router.get('/historial/:cod',controllerQR.historial)
router.get('/imprimirQR',controllerQR.imprimirQR)

module.exports= router