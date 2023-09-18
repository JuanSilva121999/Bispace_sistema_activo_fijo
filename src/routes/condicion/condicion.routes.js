const router=require("express").Router();

const controllerCondiciones  = require('../../controllers/condicion/condicion.controller');

router.post('/registrar',controllerCondiciones.postCondicion);
router.get('/:id',controllerCondiciones.getCondicionById);
router.get('/',controllerCondiciones.getCondiciones);
router.put('/editar/:id',controllerCondiciones.putCondicion);
router.delete('/eliminar/:id',controllerCondiciones.deleteCondicion);
router.get('/:nombre',controllerCondiciones.getCondicionName);

module.exports=router;