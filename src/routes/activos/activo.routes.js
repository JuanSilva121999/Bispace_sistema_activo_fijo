const router=require("express").Router();
var multipart = require('connect-multiparty'); 
var path = multipart({uploadDir: './src/uploads/activos'});
//console.log(path);
const controllerActivo  = require('../../controllers/activo/activo.controller');

router.post('/registrar',path,controllerActivo.postActivo);
router.get('/:nombre?',controllerActivo.getActivoCodigo);
router.put('/editar/:id/:img',controllerActivo.putActivo);
router.get('/:id',controllerActivo.getActivoById);
router.delete('/eliminar/:id',controllerActivo.deleteActivo);

router.get('/img/:img',controllerActivo.get_imagen);
router.get('/factura/:fac',controllerActivo.get_factura);

module.exports=router;