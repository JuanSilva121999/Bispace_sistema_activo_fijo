const router=require("express").Router();

const controllerRublos  = require('../../controllers/rublo/rublo.controller');

router.post('/registrar',controllerRublos.postRublo);
router.get('s',controllerRublos.getRublo)
router.get('/:id',controllerRublos.getRubloById);
router.put('/editar/:id',controllerRublos.putRublo);
router.delete('/eliminar/:id',controllerRublos.deleteRublo);
router.get('s/:nombre?',controllerRublos.getRubloName);



module.exports=router;