const router=require("express").Router();

const controllerDepreciacion  = require('../../controllers/depreciacion/depreciacion.controller');

router.post('/registrar',controllerDepreciacion.postDepreciacionActivo);
router.get('/depreciaciones',controllerDepreciacion.getDepreciaciones)
router.get('/:id',controllerDepreciacion.getDatosDepreciacionById);

router.get('/:nombre?',controllerDepreciacion.getActivosDepreciacionCodigo);

router.post('/valor/registrar',controllerDepreciacion.postValorDepreciacion)
router.get('/valores/depreciacion/',controllerDepreciacion.getValorDepreciacion)
router.delete('/valor/eliminar/:id',controllerDepreciacion.deleteValorDepreciacion)

module.exports=router;