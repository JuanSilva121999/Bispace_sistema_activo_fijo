const database = require("../../database/db");

const fs = require('fs');
const path = require('path');
const pool = require("../../database/db");
const { lock } = require("../../routes/condicion/condicion.routes");
const { log } = require("console");
//const { QueryTypes, col } = require("sequelize");


class controllerActivo {
    static async postActivo(req, res) {
        //console.log(req.body);
        const data = req.body;
        if (req.files) {
            const imagen_path = req.files.Imagen.path;
            //console.log(imagen_path);
            const name = imagen_path.split('\\');
            const imagen_name = name[3];

            const factura_path = req.files.Factura.path;
            const factura = factura_path.split('\\');
            const factura_name = factura[3];
            const activo = {
                idTipo: data.idTipo,
                Imagen: imagen_name,
                Factura: factura_name,
                Garantia: data.Garantia,
                Procedencia: data.Procedencia,
                Descripcion: data.Descripcion,
                ValorRegistro: data.ValorRegistro,
                Observaciones: data.Observaciones,
                UfvInicial: data.UfvInicial,
                idCondicion: data.idCondicion,
                idRubro: data.idRubro,
                idProveedor: data.idProveedor
            }
            //console.log(activo);

            const query = 'INSERT INTO activos (idtipo, imagen,factura,garantia,procedencia,descripcion,valorregistro,observaciones,ufvinicial,idcondicion,idrubro,idproveedor,valoractual) VALUES  ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$7) RETURNING *';
            const values = [activo.idTipo, activo.Imagen, activo.Factura, activo.Garantia, activo.Procedencia, activo.Descripcion, activo.ValorRegistro, activo.Observaciones, activo.UfvInicial, activo.idCondicion, activo.idRubro, activo.idProveedor];
            try {
                const result = await pool.query(query, values);
                res.status(200).json(result.rows[0]);
            } catch (error) {
                console.log(error);
                res.status(403).send({message: 'No se registro el activo fijo'});
            }

        }
        //console.log(req.files);
        //console.log(req.path);
    };
    static async getActivoCodigo(req, res) {
        try {
            const query  = "SELECT * FROM activos ac INNER JOIN tiposactivos tip ON ac.idTipo=tip.idTipo INNER JOIN proveedores pro ON pro.idProveedor=ac.idProveedor INNER JOIN condiciones cond ON cond.idCondicion=ac.idCondicion WHERE ac.Estado<>'Baja' ;"
            const result = await pool.query(query);
            res.status(200).send({ activos: result.rows });
        } catch (error) {
            console.log(error);
            res.status(500).send(error.message);
        }
    };
    static async putActivo(req, res) {
        console.log('buscar');
    }
    static async getActivoById(req, res) {
        console.log('añadir');
    }
    static async deleteActivo(req, res) {
        console.log('actualizar');
    }
    static async get_imagen(req, res) {
        var img = req.params['img'];
        res.status(200);
        if(img != "null"){//ingresamos una imagen
            let path_img = './src/uploads/activos/'+img;
            res.status(200).sendFile(path.resolve(path_img));
        }else{
            let path_img = './src/uploads/activos/default.jpg';
            res.status(200).sendFile(path.resolve(path_img));
        }
    }
    static async get_factura(req, res) {
        var img = req.params['fac'];
        console.log(img);
        if(img != "null"){//ingresamos una imagen
            let path_img = './src/uploads/activos/'+img;
            res.status(200).sendFile(path.resolve(path_img));
        }else{
            let path_img = './src/uploads/activos/default.jpg';
            res.status(200).sendFile(path.resolve(path_img));
        }
    
    }

}

module.exports = controllerActivo;