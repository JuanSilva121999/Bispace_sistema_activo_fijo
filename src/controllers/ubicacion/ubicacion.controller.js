const pool = require("../../database/db");
const database = require("../../database/db");
//const { QueryTypes, col } = require("sequelize");


class controllerUbicacion {
    static async postUbicacion(req, res) {
        try{
            const data = req.body;
            console.log(data);
            const result  = await pool.query("INSERT INTO public.ubicaciones (nombrelugar) VALUES($1) RETURNING *;", [data.NombreLugar]);
            const ubicacion =  result.rows
            res.status(200).send({ubicacion: ubicacion});
        }catch(error){
            res.status(500).send(error.message);
        }  
    };
    static async getUbicacion(req, res) {
        console.log('listar');
    };
    static async getUbicacionById(req, res) {
        console.log('listar por el id');
    };
    static async putUbicacion(req, res) {
        console.log('actualizar');
    };
    static async deleteUbicacion(req, res) {
        console.log('eliminar');
    };
    static async getUbicacionName(req, res) {
        try {
            const nombre = req.params['nombre']
            if (nombre === undefined) {
                let ubicacion = await pool.query('SELECT * FROM ubicaciones')
                ubicacion = ubicacion.rows;
                if (ubicacion.length == 0) {
                    res.status(200).json({
                        ok: false,
                        message: 'No se encuentran registros'
                    })
                } else {
                    return res.status(200).json({
                        ok: true,
                        message: 'No se encuentran registros',
                        ubicacion: ubicacion
                    })
                }
            } else {

            }
        } catch (error) {
            console.log(error.message);
            res.status(500).send(error.message);
        }
    };
}

module.exports = controllerUbicacion;