const router=require("express").Router();

const controllerPrograma  = require('../../controllers/programas/programas.controller');

router.post('/registrar',controllerPrograma.postProgramas);
router.get('/',controllerPrograma.getProgramas);
router.get('/:id',controllerPrograma.getProgramasById);
router.put('/editar/:id',controllerPrograma.putProgramas);
router.delete('/eliminar/:id',controllerPrograma.deleteProgramas);
router.get('/:nombre',controllerPrograma.getProgramasName);

module.exports=router;