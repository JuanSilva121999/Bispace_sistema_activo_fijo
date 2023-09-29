const pool = require("../../database/db");
//const { QueryTypes, col } = require("sequelize");


class controllerMantenimiento {
    static async postMantenimiento(req, res) {
        const data = req.body;
        try {
            const query = 'CALL PA_MantenimientoActivosFijos($1, $2, $3, $4) ';
            const values = [data.FechaMant, data.Informe, data.Costo, data.idAct];
            const result = await pool.query(query, values);
            if (result) {
                //console.log(result);
                res.status(200).send({
                    message: 'Activo fijo en mantenimiento',
                    mantenimiento: result
                });
            } else {
                console.log('No se logro realizar el mantenimineto');
                res.status(403).send({ error: 'No se logro realizar el mantenimineto' });
            }
        } catch (error) {
            console.log(error);
            res.status(500).send(error.message);
        }

    };
    static async getMantenimiento(req, res) {
        try {
            const query = "SELECT * FROM mantenimiento mant INNER JOIN activos ac ON ac.idActivo = mant.idAct INNER JOIN tiposactivos tip ON tip.idTipo = ac.idTipo  ORDER BY mant.idMant DESC; "
            const values = [];
            const result = await pool.query(query);
            if (result) {
                res.status(200).send({ mantenimiento: result.rows });
            } else {
                res.status(403).send({ message: 'No hay ningun registro en mantenimiento' });
            }
        } catch (error) {
            console.log(error);
            res.status(500).send(error.message);
        }
    };
    static async getMantenimientoById(req, res) {
        console.log('listar');
    };
    static async putMantenimiento(req, res) {
        console.log('listar');
    };
    static async deleteMantenimiento(req, res) {
        try {
            //console.log(req.params);
            const id = req.params.id;
            const EstadoMant = await pool.query("SELECT Estado,idAct FROM mantenimiento WHERE idMant = $1", [id]);
            //console.log(EstadoMant.rows);
            const Activo = {
                Estado: EstadoMant.rows[0].estado
            };
            //console.log(Activo);
            await pool.query("UPDATE activos SET estado  = $1 WHERE idActivo= $2", [Activo.Estado, EstadoMant.rows[0].idact]);

            await pool.query("DELETE FROM mantenimiento WHERE idmant= $1 returning  * ", [id], (err, mantenimiento_delete) => {
                console.log(mantenimiento_delete.rows);
                if (mantenimiento_delete) {
                    res.status(200).send({ mantenimiento: mantenimiento_delete });
                } else {
                    res.status(403).send({ message: 'No se elimino el registro' });
                }
            });
        } catch (error) {
            console.log(error);
            res.status(500).send(error.message);
        }
    };
    static async getMantenimientoName(req, res) {
        console.log('listar');
    };
}

module.exports = controllerMantenimiento;