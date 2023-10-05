
const pool = require("../../database/db");

//const { QueryTypes, col } = require("sequelize");


class controllerEdificio {
    static async postEdificio(req, res) {
        try {
            const data =  req.body;
            console.log(data);
            const result =  await pool.query("INSERT INTO public.edificios (nombreedi, servicio, direccion, idubicacion, latitud, longitud) VALUES($1, $2, $3, $4, $5, $6) RETURNING *;",[data.NombreEdi,data.Servicio,data.Direccion,data.idUbicacion,data.Latitud,data.Longitud])
            const edificio =  result.rows;
            res.status(200).send({ edificios: edificio, ok: true });
        } catch (error) {
            console.log(error);
            res.status(500).send(error.message);
        }
    };
    static async getEdificio(req, res) {
        try {
            const query = 'SELECT * FROM edificios'
            const result = await pool.query(query);
            res.status(200).send({ edificios: result.rows });
        } catch (error) {
            console.log(error);
            res.status(500).send(error.message);

        }
    };
    static async getEdificioById(req, res) {
        try {
            const id =  req.params.id
            const query = 'SELECT * FROM edificios WHERE idedificio = $1'
            const result = await pool.query(query,[id]);
            if (result.rows) {
                res.status(200).send({ edificio: result.rows });
            } else {
                res.status(200).send({message: 'No existe el registro'});
            }
            
        } catch (error) {
            console.log(error);
            res.status(500).send(error.message);

        }
    };
    static async putEdificio(req, res) {
        try {
            const id =  req.params.id;
            const data =  req.body
            console.log(data);
            const query = `UPDATE public.edificios
            SET nombreedi=$1, servicio=$2, direccion=$3, idubicacion=$4
            WHERE idedificio=$5;
            `
            const result  =  await pool.query(query,[data.NombreEdi,data.Servicio,data.Direccion,data.idUbicacion, id])
            const edificio  =  result.rows
            res.status(200).send({edificio: edificio});
        } catch (error) {
            console.log(error);
            res.status(500).send(error.message);
        }
    };
    static async deleteEdificio(req, res) {
        const id =  req.params.id;
        try {
            const query = `DELETE FROM public.edificios
            WHERE idedificio=$1;
            `
            const result =  await pool.query(query,[id]);
            const resultado =  result.rows;
            res.status(200).send({edificio: resultado});
        } catch (error) {
            console.log(error);
            res.status(500).send(error.message);
        }
    };
    static async getEdificioName(req, res) {
        try {
            const nombre = req.params['nombre'];
            if (nombre === undefined) {
                let edificio_list = await pool.query('SELECT * FROM edificios ed INNER JOIN ubicaciones ub ON ed.idubicacion =  ub.idubicacion ')
                edificio_list = edificio_list.rows;
                if (edificio_list.length) {
                    res.status(200).send({ edificios: edificio_list });
                } else {
                    res.status(200).send({ ok: false,message: 'No hay ningun registro con ese nombre' });
                }
            }

        } catch (error) {
            console.log(error);
            res.status(500).send(error.message);
        }
    };

}

module.exports = controllerEdificio;