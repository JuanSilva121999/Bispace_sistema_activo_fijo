const router=require("express").Router();

const controllerCantidad  = require('../../controllers/cantidad/cantidad.controller');

router.get('/uso',controllerCantidad.getCantidadUso);
router.get('/baja',controllerCantidad.getCantidadBaja);
router.get('/mantenimiento',controllerCantidad.getCantidadMantenimiento);
router.get('/disponible',controllerCantidad.getCatidadDisponible);
router.get('/depreciados',controllerCantidad.getCantidadDepreciados);
router.get('/revalorizados',controllerCantidad.getCantidadRevalorizados);
router.get('/edificios',controllerCantidad.getCantidadEdificios);
router.get('/req_mantenimiento',controllerCantidad.getCantRequiereMantenimiento);
module.exports=router;