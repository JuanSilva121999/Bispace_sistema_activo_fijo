const router=require("express").Router();

const controllerFuncionario  = require('../../controllers/funcionario/funcionario.controller');

router.post('/registrar',controllerFuncionario.postFuncionario);
router.get('/',controllerFuncionario.getFuncionario);
router.get('/:id',controllerFuncionario.getFuncionarioById);
router.put('/editar/:id',controllerFuncionario.putFuncionario);
router.delete('/eliminar/:id',controllerFuncionario.deleteFuncionario);
router.get('/:nombre',controllerFuncionario.getFuncionarioName);

module.exports=router;