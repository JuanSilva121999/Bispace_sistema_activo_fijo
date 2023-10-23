const pool = require("../../database/db");
const database = require("../../database/db");
//const { QueryTypes, col } = require("sequelize");


class controllerHistorial {
    static async postHistorial(req, res) {
        console.log('llenar activo');
    };
    static async getHistorial(req, res) {
        console.log('listar');
    };
    static async getHistorialById(req, res) {
        console.log('listar');
    };
    static async putHistorial(req, res) {
        console.log('listar');
    };
    static async deleteHistorial(req, res) {
        console.log('listar');
    };
    static async getHistorialName(req, res) {
        console.log('listar');
    };


    static async getHistorialActivosFijos(req, res) {
        try {
            const nombre = req.params['nombre'];
            if (nombre === undefined) {
                const query = "SELECT * FROM historialactivofijo his INNER JOIN activos ac ON ac.idActivo = his.CodActivo INNER JOIN empleados em ON em.idEmpleado = his.CodEmpleado INNER JOIN proyectos pro ON pro.idProyecto = his.CodProyecto INNER JOIN ambientes am ON am.idAmbiente = his.CodAmbiente INNER JOIN edificios ed ON ed.idEdificio = am.idEdificio WHERE em.Nombres ~* '' OR ac.Descripcion ~* '' ORDER BY his.CodActivo; "
                const resul = await pool.query(query);
                if (resul.rows) {
                    res.status(200).send({ activos: resul.rows });
                } else {
                    res.status(403).send({ message: 'No hay historial' });
                }
            } else {
                const query = "SELECT * FROM historialactivofijo his INNER JOIN activos ac ON ac.idActivo = his.CodActivo INNER JOIN empleados em ON em.idEmpleado = his.CodEmpleado INNER JOIN proyectos pro ON pro.idProyecto = his.CodProyecto INNER JOIN ambientes am ON am.idAmbiente = his.CodAmbiente INNER JOIN edificios ed ON ed.idEdificio = am.idEdificio WHERE pro.NombrePro ~* $1 OR em.Nombres ~* $1 OR ac.Descripcion ~* $1 ORDER BY ac.idActivo; ";
                const values = [nombre];
                const resul = await pool.query(query, values)
                if (resul.rows) {
                    res.status(200).send({ activos: resul.rows });
                } else {
                    res.status(403).send({ message: 'No hay historial' });
                }
            }
        } catch (error) {
            console.log(error.message);
            res.status(500).send(error.message);
        }
    };
    static async getHistorialActivosFijosCod(req, res) {
        console.log('listar');
    };
    static async getHistorialDepreciaciones(req, res) {
        try {
            const nombre = req.params['nombre'];
            if (nombre === undefined) {
                const historial_dep = await pool.query("SELECT * FROM activos ac INNER JOIN tiposactivos tip  ON tip.idTipo=ac.idTipo INNER JOIN depreciaciones dep ON ac.idActivo=dep.idActivo  order by dep.idActivo");
                    if (historial_dep.rows.length) {
                    res.status(200).send({ depreciaciones: historial_dep.rows });
                } else {
                    res.status(403).send({ message: 'No hay historial' });
                }

            } else {
                await connection.query("SELECT * FROM activos ac INNER JOIN tiposactivos tip  ON tip.idTipo=ac.idTipo INNER JOIN depreciaciones dep ON ac.idActivo=dep.idActivo WHERE dep.idActivo REGEXP LOWER('" + nombre + "') OR ac.Descripcion REGEXP LOWER('" + nombre + "') OR tip.NombreActivo REGEXP LOWER('" + nombre + "') order by dep.idActivo", (err, historial_dep) => {
                    if (historial_dep.length) {
                        res.status(200).send({ depreciaciones: historial_dep });
                    } else {
                        res.status(403).send({ message: 'No hay historial' });
                    }
                });
            }
        } catch (error) {
            console.log(error.message);
            res.status(500).send(error.message);
        }
    };
    static async getHistorialAsignaciones(req,res){
        try {
            const id_act = req.params.id;
            console.log(id_act);
            let historial_asig  = await pool.query(`select * from historial_asignaciones ha inner join activos a on a.idactivo = ha.equipo_id inner join empleados e on e.idempleado = ha.empleado_id inner join proyectos p on p.idproyecto = ha.detalle_asignacion where ha.equipo_id = $1`,[id_act])
            historial_asig =  historial_asig.rows;
            if (historial_asig.length > 0 ) {
                res.status(200).json({
                    ok : true,
                    data: historial_asig
                })
            }else{
                console.log('no hay nada');
                res.status(200).json({
                    ok : false,
                    message: 'ningun registro'
                })
            }
        } catch (error) {
            console.log(error.message);
            res.status(500).send({
                message: error.message
            })
        }
    }
    static async getHistorialDevoluciones(req,res){
        try {
            const id_act = req.params.id;
            let historial_dev = await pool.query(`select * from historial_devoluciones hd inner join empleados e on hd.empleado_id = e.idempleado where hd.equipo_id = $1`,[id_act])
            //console.log(historial_dev);
            historial_dev =  historial_dev.rows;
            if (historial_dev.length > 0 ) {
                res.status(200).json({
                    ok : true,
                    data: historial_dev
                })
            }else{
                console.log('no hay nada');
                res.status(200).json({
                    ok : false,
                    message: 'ningun registro'
                })
            }
        } catch (error) {
            console.log(error.message);
            res.status(500).send({
                message: error.message
            })
        }
    }
    static async getHistorialMantenimiento(req,res){
        try {
            const id_act = req.params.id;
            let historial_man  = await pool.query(`select * from historial_mantenimiento where equipo_id = $1`,[id_act])
            historial_man =  historial_man.rows;
            if (historial_man.length > 0 ) {
                console.log(historial_man);
                res.status(200).json({
                    ok : true,
                    data: historial_man
                })
            }else{
                console.log('no hay nada');
                res.status(200).json({
                    ok : false,
                    message: 'ningun registro'
                })
            }
        } catch (error) {
            console.log(error.message);
            res.status(500).send({
                message: error.message
            })
        }
    }


}

module.exports = controllerHistorial;