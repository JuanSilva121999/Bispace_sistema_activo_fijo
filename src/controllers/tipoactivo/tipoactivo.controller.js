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
        const {idTipo,NombreActivo,DescripcionMant}= req.body ;
        try {
            console.log(DescripcionMant);
            const query = 'UPDATE tiposactivos SET  nombreactivo = $1, descripcionmant = $2 WHERE idtipo = $3 RETURNING *';
            const values = [NombreActivo, DescripcionMant,id];
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
        console.log('listar');
    };
    static async gettipoActivoName(req, res) {
        console.log('listar');
    };
}

module.exports = controllertipoActivo;