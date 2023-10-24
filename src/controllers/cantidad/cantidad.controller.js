const pool = require("../../database/db");
const database = require("../../database/db");
//const { QueryTypes, col } = require("sequelize");


class controllerCantidad{
    static async getCantidadUso(req,res){
        try {
            const uso =  await pool.query(`SELECT count (*) as "Asignados" from activos WHERE estado='En Uso'`)
            if (uso.rows) {
                res.status(200).send({uso: uso.rows});
            }else{
                res.status(200).send({message : 'ningun registro'});
            }
        } catch (error) {
            console.log(error.message);
            res.status(500).send(error.message);
        }
    };
    static async getCantidadBaja(req,res){
        try {
            const baja =  await pool.query(`SELECT COUNT (*) AS "Baja" FROM  bajas`)
            if (baja.rows) {
                res.status(200).send({
                    baja: baja.rows
                })
            }else{
                res.status(200).send({
                    message: 'Ningun registro en la base de datos'
                })
            }
        } catch (error) {
            console.log(error.message);
            res.status(500).send(error.message);
        }
    };
    static async getCantidadMantenimiento(req,res){
        try {
            const mantenimiento =  await pool.query(`select count (*) as "Mantenimiento" from mantenimiento`)
            if (mantenimiento.rows) {
                res.status(200).send({
                    mantenimiento: mantenimiento.rows
                })
            } else {
                res.status(200).send({
                    message: 'Ningun registro'
                })
            }
        }catch{
            console.log(error.message);
            res.status(500).send(error.message);
        }
    };
    static async getCatidadDisponible(req,res){
        try {
            try {
                const disponible =  await pool.query(`SELECT count (*) as "Disponibles" from activos WHERE estado='Activo'`)
                if (disponible.rows) {
                    res.status(200).send({disponible: disponible.rows});
                }else{
                    res.status(200).send({message : 'ningun registro'});
                }
            } catch (error) {
                console.log(error.message);
                res.status(500).send(error.message);
            }
        } catch (error) {
            console.log(error.message);
            res.status(500).send(error.message);
        }
    };
    static async getCantidadDepreciados(req,res){
        try {
            const cant_depreciados =  await pool.query(`SELECT count(DISTINCT dep.idActivo) AS "cantDepreciados"
            FROM depreciaciones dep;
            `)
            if (cant_depreciados.rows) {
                //console.log(cant_depreciados.rows);
                res.status(200).send({depreciados: cant_depreciados.rows})
            } else {
                res.status(200).send({message : 'ningun registro'});
            }
        } catch (error) {
            console.log(error.message);
            res.status(500).send(error.message);
        }
    };
    static async getCantidadRevalorizados(req,res){
        try {
            const cant_revalorizar =  await pool.query(`select count(*) as "ReqRevalorizacion" from activos ac where ac.ValorActual= 1`)
            if (cant_revalorizar.rows) {
                res.status(200).send({
                    revalorizar : cant_revalorizar.rows
                })
            } else {
                res.status(200).send({
                    message: 'Ningun registro'
                })
            }
        } catch (error) {
            console.log(error.message);
            res.status(500).send(error.message);
        }
    };
    static async getCantidadEdificios(req,res){
        try {
            const cant_edificios =  await pool.query(`select count (*) as "edificios" from proyectos ed`)
            if (cant_edificios.rows) {
                res.status(200).send({
                    edificios: cant_edificios.rows
                })
            } else {
                res.status(200).send({
                    message:'Ningun registro'
                })
            }
        } catch (error) {
            console.log(error.message);
            res.status(500).send(error.message);
        }
    };
    static async getCantRequiereMantenimiento(req,res){
        try {
            const reqMantenimiento =  await pool.query(`select count (*) as ReqMantenimiento
            from activos ac inner join tipoactivos tip on tip.idtipo =  ac.idtipo where ac.estado <> 'Baja' and (ac.idcondicion = 4 or ac.idcondicion = 5)`)
            if (reqMantenimiento.rows) {
                res.status(200).send({
                    reqmantenimiento: reqMantenimiento
                })
            } else {
                res.status(200).send({
                    message : 'Ningun registro'
                })
            }
        } catch (error) {
            console.log(error.message);
            res.status(500).send(error.message);
        }
    };
}

module.exports =  controllerCantidad;