const router=require("express").Router();

const controllerMantenimiento  = require('../../controllers/matenimiento/mantenimiento.controller');

router.get('/',controllerMantenimiento.getMantenimiento);
router.post('/registrar',controllerMantenimiento.postMantenimiento);
router.get('/:id',controllerMantenimiento.getMantenimientoById);
router.put('/editar/:id',controllerMantenimiento.putMantenimiento);
router.delete('/eliminar/:id',controllerMantenimiento.deleteMantenimiento);
router.get('/:nombre',controllerMantenimiento.getMantenimientoName);

module.exports=router;