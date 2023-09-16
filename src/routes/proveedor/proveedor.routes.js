const router=require("express").Router();

const controllerProveedor  = require('../../controllers/proveedor/proveedor.controller');

router.post('/registrar',controllerProveedor.postProveedor);
router.get('/:id',controllerProveedor.getProveedorById);
router.get('/',controllerProveedor.getProveedor);
router.put('/editar/:id',controllerProveedor.putProveedor);
router.delete('/eliminar/:id',controllerProveedor.deleteProveedor);
router.get('es/:nombre?',controllerProveedor.getProveedorName);


module.exports=router;