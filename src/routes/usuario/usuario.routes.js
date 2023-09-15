const router=require("express").Router();

const controllerUsuario  = require('../../controllers/usuario/usuario.controller');

router.post('/login',controllerUsuario.loginUsuario);
router.post('/register',controllerUsuario.postUsuario);
router.put('/editar/:id',controllerUsuario.putUsuario)
router.get('/:id',controllerUsuario.getUsuarioById)
router.get('/',controllerUsuario.getUsuario)

module.exports=router;