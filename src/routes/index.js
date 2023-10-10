const router = require('express').Router();

const user  = require('./usuario/usuario.routes');
const activo=require('./activos/activo.routes');
const alta= require('./activos/altaactivo.routes')
const ambiente  = require('./ambiente/ambiente.routes');
const backup = require('./backup/backups.routes')
const baja= require('./baja/baja.routes')
const cantidad= require('./cantidad/cantidad.routes')
const condicion= require('./condicion/condicion.routes')
const depreciacion= require('./depreciacion/depreciacion.routes')
const devolucion= require('./devolucion/devolucion.routes')
const edificio= require('./edificio/edificio.routes')
const funcionario= require('./funcionario/funcionario.routes')
const historial= require('./historial/historial.routes')
const mantenimiento= require('./mantenimiento/mantenimiento.routes')
const programa= require('./programa/programa.routes')
const proveedor =  require('./proveedor/proveedor.routes')
const proyecto  = require('./proyecto/proyecto.routes')
const revalorizacion= require('./revalorizacion/revalorizacion.routes')
const rublo= require('./rublos/rulos.routes')
const tipoactivo= require('./tipoactivo/tipoactivo.routes')
const ubicacion= require('./ubicacion/ubicacion.routes')
const qr =  require('./qrcont/qrcontr.routes')

router.use('/usr',user);
router.use('/activo',activo);
router.use('/act_alta',alta);
router.use('/ambiente',ambiente)
router.use('/backup',backup);
router.use('/baja',baja)
router.use('/cantidad',cantidad)
router.use('/condicion',condicion)
router.use('/depreciacion',depreciacion)
router.use('/devolucion',devolucion)
router.use('/edificio',edificio)
router.use('/funcionario',funcionario)
router.use('/historial',historial)
router.use('/mantenimiento',mantenimiento)
router.use('/programa',programa)
router.use('/proveedor',proveedor)
router.use('/proyecto',proyecto)
router.use('/revalorizacion',revalorizacion)
router.use('/rubro',rublo)
router.use('/tipoactivo',tipoactivo)
router.use('/ubicacion',ubicacion)
router.use('/generarQR' , qr)


module.exports = router;
