const pool = require("../../database/db");
const database = require("../../database/db");
//const { QueryTypes, col } = require("sequelize");


class controllertipoActivo {
    static async posttipoActivo(req, res) {
        console.log(req.body);

        const { NombreActivo, DescripcionMant,CodTipoActivo } = req.body;
        try {
            const query =  'INSERT INTO tiposactivos (nombreactivo, descripcionmant,cod_tipo) VALUES ($1, $2, $3) RETURNING *';
            const values  =  [NombreActivo, DescripcionMant,CodTipoActivo];
            const result  = await pool.query(query,values);

            res.status(200).json(result.rows[0]);
        } catch (error) {
            console.error(error);
            res.status(500).send('Error al crear un el tipo de Activo');
        }
    };
    static async getipoActivot(req, res) {
        try {
            const result = await pool.query("SELECT * FROM tiposactivos");
            //const resultados = connection[0];
            //console.log(resultados);
            res.status(200).send({ tipoactivo: result.rows });
        } catch (error) {
            res.status(500).send(error.message);
            console.log(error);
        }
    };
    static async gettipoActivoById(req, res) {
        const { id } = req.params;
        try {
            const query = 'SELECT * FROM tiposactivos WHERE idtipo = $1';
            const result = await pool.query(query, [id]);
            if (result.rows.length === 0) {
                res.status(404).send('Tipo de activo no encontrado');
            } else {
                res.json({ tipoactivo: result.rows[0] });
            }
        } catch (error) {
            console.error(error);
            res.status(500).send('Error al obtener el tipo de activo');
        }
    };
    static async puttipoActivo(req, res) {
        console.log(req.body);
        const {id} =  req.params;
        console.log(id);
        const {idTipo,NombreActivo,DescripcionMant,CodTipoActivo}= req.body ;
        try {
            console.log(DescripcionMant);
            const query = 'UPDATE tiposactivos SET  nombreactivo = $1, descripcionmant = $2, cod_tipo = $3 WHERE idtipo = $4 RETURNING *';
            const values = [NombreActivo, DescripcionMant,CodTipoActivo,id];
            const result = await pool.query(query, values);
            console.log(result.rows);
            if (result.rows.length === 0) {
              res.status(404).send('Activo no encontrado');
            } else {
              res.json(result.rows[0]);
            }
          } catch (error) {
            console.error(error);
            res.status(500).send('Error al actualizar el Tipo de Activo');
          }


    };
    static async deletetipoActivo(req, res) {
        const id =  req.params.id
        try {
            const data =  await pool.query('DELETE FROM tiposactivos WHERE idtipo = $1', [id]);
            if (data.rowCount === 0) {
                return res.status(404).send('Tipo de activo no encontrado');
            }
            await pool.query('DELETE FROM activos WHERE idtipo = $1', [id]);
            res.status(200).send({
                ok: true,
                message : 'Tipo de activo eliminado correctamente'
            });
            console.log('listar');
        } catch (error) {
            console.log(error.message);
            res.status(500).send({
                ok: false,
                message : error.message
            })
        }
    };
    static async gettipoActivoName(req, res) {
        console.log('listar');
    };
}

module.exports = controllertipoActivo;