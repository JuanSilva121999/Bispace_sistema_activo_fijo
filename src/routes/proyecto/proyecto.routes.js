const router=require("express").Router();

const controllerProyecto  = require('../../controllers/proyecto/proyecto.controller');

router.post('/registrar',controllerProyecto.postProyecto);
router.get('/',controllerProyecto.getProyecto);
router.get('/:id',controllerProyecto.getProyectoById);
router.put('/editar/:id',controllerProyecto.putProyecto);
router.delete('/eliminar/:id',controllerProyecto.deleteProyecto);
router.get('s/:nombre?',controllerProyecto.getProyectoName);

router.get('/listar/ejecucion',controllerProyecto.getProyectosEjecucion)


module.exports=router;