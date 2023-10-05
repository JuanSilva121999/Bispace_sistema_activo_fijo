const router=require("express").Router();

const controllerAmbiente  = require('../../controllers/ambiente/ambiente.controller');

router.post('/registrar',controllerAmbiente.postAmbiente);
router.get('/listar/:nombre?',controllerAmbiente.getAmbienteName);
router.get('/:id',controllerAmbiente.getAmbienteById);
router.get('/',controllerAmbiente.getAmbiente);
router.put('/editar/:id',controllerAmbiente.putAmbiente);
router.delete('/eliminar/:id',controllerAmbiente.deleteAmbiente);



router.get('/edificio/:id',controllerAmbiente.getEdificioAmbienteById);




module.exports=router;