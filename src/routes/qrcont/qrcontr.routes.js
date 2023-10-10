const router=  require("express").Router();

const controllerQR =  require ('../../controllers/qrcont/qrcont.constroller');

router.get('/generar' ,controllerQR.generarQR);
router.get('/generar:id' , controllerQR.generarQRById)
router.post('/buscarQR',controllerQR.buscarQR)
router.delete('/eliminar/:id', controllerQR.deleteQR)

module.exports= router