const pool = require("../../database/db");
const database = require("../../database/db");
//const { QueryTypes, col } = require("sequelize");


class controllerRevalorizacion {
    static async postRevalorizacion(req, res) {
        try {
            const data = req.body;
            const query = 'INSERT INTO public.revalorizaciones (codactivo, fecharev, valornuevo, descripcionrev) VALUES($1, $2, $3, $4 )RETURNING *;'
            const values = [data.CodActivo, data.FechaRevalorizacion, data.Valor, data.Descripcion];
            const result = await pool.query(query, values)
            if (result.rows) {
                res.status(200).send({
                    message: 'Revalorizacion de activo fijo exitosa',
                    bajaactivo: result.rows
                });
            } else {
                res.status(403).send({ error: 'No se logro revalorizar el activo fijo' });
            }
            console.log(data);
        } catch (error) {
            console.log(error.message);
            res.status(500).send(error.message);

        }
    };
    static async getRevalorizacion(req, res) {
        console.log('listar');
    };
    static async getRevalorizacionById(req, res) {
        console.log('listar');
    };
    static async putRevalorizacion(req, res) {
        console.log('listar');
    };
    static async deleteRevalorizacion(req, res) {
        console.log('listar');
    };
    static async getRevalorizacionName(req, res) {
        try {
            const nombre = req.params['nombre'];
            // console.log(nombre);
            if (nombre === undefined) {
                let activo_list = await pool.query("SELECT * FROM activos ac INNER JOIN tiposactivos tip ON ac.idTipo=tip.idTipo INNER JOIN revalorizaciones rev ON rev.CodActivo=ac.idActivo order by rev.idRevalorizacion DESC")
                activo_list =  activo_list.rows;
                if (activo_list.length) {
                    console.log(activo_list);
                    res.status(200).send({ activos: activo_list });
                } else {
                    res.status(403).send({ message: 'No hay ningun registro con el codigo o nombre del tipo de activo fijo' });
                }

            } else {
                await connection.query("SELECT * FROM activos ac INNER JOIN tiposactivos tip ON ac.idTipo=tip.idTipo INNER JOIN revalorizaciones rev ON rev.CodActivo=ac.idActivo WHERE ac.idActivo REGEXP LOWER('" + nombre + "') OR tip.NombreActivo REGEXP LOWER('" + nombre + "') order by rev.idRevalorizacion DESC", (err, activo_list) => {
                    if (activo_list.length) {
                        console.log(activo_list);
                        res.status(200).send({ activos: activo_list });
                    } else {
                        res.status(403).send({ message: 'No hay ningun registro con el codigo o nombre del tipo de activo fijo' });
                    }
                });

            }
        } catch (error) {
            console.log(error.message);
            res.status(500).send(error.message);
        }
    };
}

module.exports = controllerRevalorizacion;