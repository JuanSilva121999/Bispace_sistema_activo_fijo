const database = require("../../database/db");

const fs = require('fs');
const path = require('path');
const pool = require("../../database/db");
const { lock } = require("../../routes/condicion/condicion.routes");
const { log } = require("console");
const QRCode = require('qrcode');
const PDF = require("html-pdf");
//const { QueryTypes, col } = require("sequelize");
const dominio = process.env.DOMINIO + 'activosqr/'

class controllerActivo {
    static async postActivo(req, res) {
        //console.log(req.body);
        const data = req.body;
        if (req.files) {
            const imagen_path = req.files.Imagen.path;
            console.log(imagen_path);
            const name = imagen_path.split('/');
            let imagen_name = name[3];
            if (imagen_name == undefined) {
                const imagen_path = req.files.Imagen.path; //asignar la ruta donde esta la imagen
                const name = imagen_path.split('\\');//split crea un array y separa el nombre de la imagen
               imagen_name = name[3];//obtiene el nombre de la imagen en el indice 2
            }
            const factura_path = req.files.Factura.path;
            const factura = factura_path.split('/');
            let factura_name = factura[3];
            if (factura_name == undefined) {
                const factura_path = req.files.Factura.path; //asignar la ruta donde esta la imagen
                const factura = factura_path.split('\\');//split crea un array y separa el nombre de la imagen
               factura_name = factura[3];//obtiene el nombre de la imagen en el indice 2
            }
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

                const historial = await pool.query(`
                INSERT INTO public.historialactivofijo
                (codactivo, codempleado, codproyecto, codambiente, estado, fecha, proyecto, asignado_por)
                VALUES(0, 0, 0, 0, '', CURRENT_TIMESTAMP, '', '');

                `, [])
                const result = await pool.query(query, values);
                const activo =  result.rows[0]
                try {

                    const query = `SELECT * FROM activos a inner join rubros r on a.idrubro =  r.idrubro inner join tiposactivos ta on ta.idtipo = a.idtipo  where a.idactivo = $1`
                    let result = await pool.query(query,[activo.idactivo])
                    result = result.rows
                    //console.log(result.length);
                    await procesarResult(result);
                    //console.log(result);
                } catch (error) {
                    console.log(error.message);
                }
                res.status(200).json(result.rows[0]);
            } catch (error) {
                console.log(error);
                res.status(403).send({ message: 'No se registro el activo fijo' });
            }

        }
        //console.log(req.files);
        //console.log(req.path);
    };
    static async getActivoCodigo(req, res) {
        try {
            const query = "SELECT * FROM activos ac INNER JOIN tiposactivos tip ON ac.idTipo=tip.idTipo INNER JOIN proveedores pro ON pro.idProveedor=ac.idProveedor INNER JOIN condiciones cond ON cond.idCondicion=ac.idCondicion inner join qr_activo qa on ac.idactivo = qa.qr_id_activo   WHERE ac.Estado<>'Baja' ;"
            const result = await pool.query(query);
            res.status(200).send({ activos: result.rows });
        } catch (error) {
            console.log(error);
            res.status(500).send(error.message);
        }
    };
    static async putActivo(req, res) {
        try {
            const id = req.params.id;
            const data = req.body;
            //console.log(req.body);
            var img = req.params['img'];
            //console.log(id, ' ', img );        
            if (req.files.Imagen) {
                if (img || img != null || img != undefined) {
                    

                }
                const imagen_path = req.files.Imagen.path; //asignar la ruta donde esta la imagen
                const name = imagen_path.split('/');//split crea un array y separa el nombre de la imagen
                let imagen_name = name[3];//obtiene el nombre de la imagen en el indice 2
                if (imagen_name == undefined) {
                    const imagen_path = req.files.Imagen.path; //asignar la ruta donde esta la imagen
                    const name = imagen_path.split('\\');//split crea un array y separa el nombre de la imagen
                   imagen_name = name[3];//obtiene el nombre de la imagen en el indice 2
                }
                const activo = {
                    idTipo: data.idTipo,
                    Imagen: imagen_name,
                    // Factura: factura_name,
                    Garantia: data.Garantia,
                    Procedencia: data.Procedencia,
                    Descripcion: data.Descripcion,
                    ValorRegistro: data.ValorRegistro,
                    Observaciones: data.Observaciones,
                    idCondicion: data.idCondicion,
                    idRubro: data.idRubro,
                    idProveedor: data.idProveedor
                }
                const query = 'UPDATE activos SET  idtipo= $1, imagen=$2,garantia  = $3,procedencia=$4,descripcion=$5,valorregistro=$6,observaciones= $7,idcondicion=$8,idrubro=$9,idproveedor=$10 WHERE idactivo = $11 RETURNING *';
                const values = [activo.idTipo, activo.Imagen, activo.Garantia, activo.Procedencia, activo.Descripcion, activo.ValorRegistro, activo.Observaciones, activo.idCondicion, activo.idRubro, activo.idProveedor, id];
                const result = await pool.query(query, values);
                if (result.rows.length === 0) {
                    res.status(404).send('activo no encontrado');
                } else {
                    res.status(200).json(result.rows[0]);
                }
            }else{
                const activo = {
                    idTipo: data.idTipo,
                    // Factura: factura_name,
                    Garantia: data.Garantia,
                    Procedencia: data.Procedencia,
                    Descripcion: data.Descripcion,
                    ValorRegistro: data.ValorRegistro,
                    Observaciones: data.Observaciones,
                    idCondicion: data.idCondicion,
                    idRubro: data.idRubro,
                    idProveedor: data.idProveedor
                }
                const query = 'UPDATE activos SET  idtipo= $1,garantia  = $2,procedencia=$3,descripcion=$4,valorregistro=$5,observaciones= $6,idcondicion=$7,idrubro=$8,idproveedor=$9 WHERE idactivo = $10 RETURNING *';
                const values = [activo.idTipo, activo.Garantia, activo.Procedencia, activo.Descripcion, activo.ValorRegistro, activo.Observaciones, activo.idCondicion, activo.idRubro, activo.idProveedor, id];
                const result = await pool.query(query, values);
                if (result.rows.length === 0) {
                    res.status(404).send('activo no encontrado');
                } else {
                    res.status(200).json(result.rows[0]);
                }
            }
        } catch (error) {
            console.log(error);
            res.status(500).send(error.message);
        }

    }
    static async getActivoById(req, res) {

        try {
            const id = req.params.id;
            const query = 'SELECT * FROM activos WHERE idactivo = $1';
            const values = [id];

            const result = await pool.query(query, values);
            const resultado = result.rows;
            console.log(resultado.length);
            if (resultado.length !== 0) {
                res.status(200).json(resultado);
            } else {
                res.status(404).send('Activo no  encontrado');
            }
        } catch (error) {
            res.status(500).send(error.message);
        }
    }
    static async deleteActivo(req, res) {
        console.log('actualizar');
    }
    static async get_imagen(req, res) {
        try {
            var img = req.params['img'];
            console.log(img);
            res.status(200);
            if (img != "null") {//ingresamos una imagen
                let path_img = './src/uploads/activos/' + img;
                const data = path.resolve(path_img)
                console.log('Imagen');
                console.log(data);
                fs.access(data, async (err) => {
                    if (err) {
                      // Archivo no existe, enviar imagen predeterminada
                      let path_img = './src/uploads/activos/default.jpg';
                      res.status(200).sendFile(path.resolve(path_img));
                    } else {
                      // Archivo existe, enviar imagen
                      res.status(200).sendFile(path.resolve(path_img));
                    }
                  });                                            
                
            } else {
                let path_img = './src/uploads/activos/default.jpg';
                res.status(200).sendFile(path.resolve(path_img));
            }
        } catch (error) {
            console.log(error);
        }

    }
    static async get_factura(req, res) {
        try {
            var img = req.params['fac'];
            //console.log(img);
            //console.log(img);
            if (img != "null") {//ingresamos una imagen
                let path_img = './src/uploads/activos/' + img;
                const data = path.resolve(path_img)
                console.log('Imagen');
                console.log(data);
                fs.access(data, async (err) => {
                    if (err) {
                      // Archivo no existe, enviar imagen predeterminada
                      let path_img = './src/uploads/activos/default.jpg';
                      res.status(200).sendFile(path.resolve(path_img));
                    } else {
                      // Archivo existe, enviar imagen
                      res.status(200).sendFile(path.resolve(path_img));
                    }
                  });                                            
                
            } else {
                let path_img = './src/uploads/activos/default.jpg';
                res.status(200).sendFile(path.resolve(path_img));
            }
        } catch (error) {
            console.log(error);
        }


    }

}
function formatDate(date) {
    const options = { year: 'numeric', month: '2-digit', day: '2-digit' };
    return new Date(date).toLocaleDateString(undefined, options);
}
async function generarCodigo(datos) {
    const data = datos;
    const inicio = 'BS';
    const tipo = datos.cod_tipo
    const format = datos.cod;
    const vales = await pool.query(`select qr_cod_activo from qr_activo where left(qr_cod_activo,4) ilike '${inicio}${format}'`)
    //console.log(vales.rows);
    const cantidad = vales.rows.length;
    //console.log(cantidad);
    const numeracion = cantidad + 1
    let numeroFormateado = numeracion.toString().padStart(4, '0');
    const codigo = inicio + tipo+'-' + numeroFormateado
    return codigo
}
async function procesarResult(result) {
    for (const element of result) {
        const cod = await generarCodigo(element);
        const url = dominio + cod;
        console.log(url);
        try {
            const data_url = await new Promise((resolve, reject) => {
                QRCode.toDataURL(url, (err, data) => {
                    if (err) {
                        reject(err);
                    } else {
                        resolve(data);
                    }
                });
            });

            const qry = `
          INSERT INTO public.qr_activo
          (qr_image, qr_fecha_creacion, qr_fecha_emicion, qr_fecha_renovacion, qr_cod_activo, qr_id_activo, qr_estado)
          VALUES($1, $2, $3, $4, $5, $6, $7) returning *;
        `;

            const values = [data_url, new Date(), new Date(), new Date(), cod, element.idactivo, 's'];
            const result = await pool.query(qry, values);
            //console.log("Elemento procesado con éxito");
        } catch (error) {
            console.error("Error:", error);
        }
    }
}
module.exports = controllerActivo;