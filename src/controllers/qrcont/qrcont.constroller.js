const pool = require('../../database/db')
const QRCode = require('qrcode');
const fs = require('fs');

const dominio = 'http://localhost:4200/activosqr/'; // Reemplaza con tu URL

// Genera el código QR


class constrollerQR {
    static async generarQR(req, res) {
        try {

            const query = `SELECT * FROM activos a
            inner join rubros r on a.idrubro =  r.idrubro`
            let result = await pool.query(query)
            result = result.rows
            //console.log(result.length);
            procesarResult(result);
            //console.log(result);
            res.status(200).json({
                ok: true,
                message: 'Se genero los qr '
            })
        } catch (error) {
            console.log(error.message);
            res.status(500).send({
                message: error.message
            })
        }
    }
    static async generarQRById(req, res) {

    }
    static async buscarQR(req, res) {

    }
    static async deleteQR(req, res) {

    }
    static async listarQR(req, res) {
        try {
            const query = 'SELECT * FROM qr_activo qa inner join activos a on a.idactivo =  qa.qr_id_activo inner join tiposactivos ta on ta.idtipo =  a.idtipo'
            let result = await pool.query(query);
            result = result.rows;
            if (result.length != 0) {
                res.status(200).json({
                    ok: true,
                    result: result
                })
            } else {
                res.status(200).json({
                    ok: false,
                    message: 'Ningun registro'
                })
            }

        } catch (error) {
            console.log(error.message);
            res.status(500).send({
                message: error.message
            })
        }
    }
    static async historial(req, res) {
        try {
            const cod_activo =  req.params.cod
            let info = await pool.query( `select * from qr_activo qa inner join activos a on a.idactivo = qa.qr_id_activo inner join tiposactivos ta on ta.idtipo= a.idtipo inner join condiciones c on c.idcondicion = a.idcondicion where qa.qr_cod_activo  = '${cod_activo}'`)
            //console.log(info.rows);
            if (!info.rows) {
                res.status(200).json({
                    ok: false,
                    message : 'El activo no se encuentra con un qr'
                })
            }
            res.status(200).json({
                ok: true,
                activo : info.rows
            })

        } catch (error) {
            console.log(error.message);
            res.status(500).send({
                ok: false,
                error: error.message
            })
        }


    }

}
async function generarCodigo(datos) {
    const data = datos;
    const inicio = 'BP';
    const format = datos.cod;
    const vales = await pool.query(`select qr_cod_activo from qr_activo where left(qr_cod_activo,4) ilike '${inicio}${format}'`)
    //console.log(vales.rows);
    const cantidad = vales.rows.length;
    //console.log(cantidad);
    const numeracion = cantidad + 1
    let numeroFormateado = numeracion.toString().padStart(4, '0');
    const codigo = inicio + format + '-' + numeroFormateado
    //console.log(codigo);
    return codigo
}
async function procesarResult(result) {
    for (const element of result) {
      const cod = await generarCodigo(element);
      const url = dominio + cod;
  
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
  
  // Llamar a la función para procesar los elementos

  
module.exports = constrollerQR