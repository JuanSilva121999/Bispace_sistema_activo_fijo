const router=require("express").Router();

const controllerTipoActivo  = require('../../controllers/tipoactivo/tipoactivo.controller');

router.post('/registrar',controllerTipoActivo.posttipoActivo);
router.get('/:id',controllerTipoActivo.gettipoActivoById);
router.put('/editar/:id',controllerTipoActivo.puttipoActivo);
router.delete('/eliminar/:id',controllerTipoActivo.deletetipoActivo);
router.get('s/:nombre?',controllerTipoActivo.gettipoActivoName);



module.exports=router;