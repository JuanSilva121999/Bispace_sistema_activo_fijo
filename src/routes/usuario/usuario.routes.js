const router=require("express").Router();

const controllerUsuario  = require('../../controllers/usuario/usuario.controller');

router.post('/login',controllerUsuario.loginUsuario);
router.post('/register',controllerUsuario.postUsuario);
router.get('/usuarios',controllerUsuario.getUsuario);
router.put('/usuario/editar/:id',controllerUsuario.putUsuario)
router.get('/usuario/:id',controllerUsuario.getUsuarioById)

module.exports=router;