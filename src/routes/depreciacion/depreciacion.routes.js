const router=require("express").Router();

const controllerDepreciacion  = require('../../controllers/depreciacion/depreciacion.controller');

router.post('/registrar',controllerDepreciacion.postDepreciacionActivo);
router.get('/:id',controllerDepreciacion.getDatosDepreciacionById);
router.get('/',controllerDepreciacion.getDepreciaciones)
router.get('/:nombre',controllerDepreciacion.getActivosDepreciacionCodigo);

router.post('/valor/registrar',controllerDepreciacion.postValorDepreciacion)
router.get('/valor/',controllerDepreciacion.getValorDepreciacion)
router.delete('/valor/eliminar/:id',controllerDepreciacion.deleteValorDepreciacion)

module.exports=router;