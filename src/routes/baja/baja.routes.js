const router=require("express").Router();

const controllerBaja  = require('../../controllers/baja/baja.controller');

router.post('/registrar',controllerBaja.posBajaActivo);
router.get('/',controllerBaja.getBajaNombre);


module.exports=router;