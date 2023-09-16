const pool = require("../../database/db");
//const { QueryTypes, col } = require("sequelize");


class controllerProveedor{
    static async postProveedor(req,res){
        //console.log(req.body);

        const {NombreProv,DireccionProv,TelefonoProv}= req.body ;
        try {
            const query = 'INSERT INTO proveedores (nombreprov, direccionprov, telefonoprov) VALUES ($1, $2, $3) RETURNING *';
            const values = [NombreProv, DireccionProv, TelefonoProv];
            const result = await pool.query(query, values);
            res.status(200).json(result.rows[0]);
        } catch (error) {
            console.error(error);
            res.status(500).send('Error al crear un funcionario');
        }
    };
    static async getProveedor(req,res){
        try {
            const result = await pool.query("SELECT * FROM proveedores");
            //const resultados = connection[0];
            //console.log(resultados);
            res.status(200).send({ proveedores: result.rows });
        } catch (error) {
            res.status(500).send(error.message);
            console.log(error);
        }
    };
    static async getProveedorById(req,res){
        const { id } = req.params;
        try {
            const query = 'SELECT * FROM proveedores WHERE idproveedor = $1';
            const result = await pool.query(query, [id]);
            if (result.rows.length === 0) {
                res.status(404).send('Proveedor no encontrado');
            } else {
                res.json({ proveedor: result.rows[0] });
            }
        } catch (error) {
            console.error(error);
            res.status(500).send('Error al obtener el funcionario');
        }
    };
    static async putProveedor(req,res){
        console.log(req.body);
        const {idProveedor,NombreProv,DireccionProv,TelefonoProv}= req.body ;
        try {
            const query = 'UPDATE proveedores SET  nombreprov = $1, direccionprov = $2, telefonoprov = $3 WHERE idproveedor = $4 RETURNING *';
            const values = [NombreProv, DireccionProv, TelefonoProv, idProveedor];
            const result = await pool.query(query, values);
            if (result.rows.length === 0) {
              res.status(404).send('Proveedor no encontrado');
            } else {
              res.json(result.rows[0]);
            }
          } catch (error) {
            console.error(error);
            res.status(500).send('Error al actualizar el funcionario');
          }
    };
    static async deleteProveedor(req,res){
        const {id} =  req.params;
        try {
            const query = 'DELETE FROM proveedores WHERE idproveedor = $1 RETURNING *';
            const result = await pool.query(query, [id]);
            if (result.rows.length === 0) {
                res.status(404).send('Poveedor no encontrado');
            } else {
                res.json({ message: 'Proyecto eliminado correctamente', ok: true });
            }
        } catch (error) {
            console.error(error);
            res.status(500).send('Error al eliminar el funcionario');
        }
    };
    static async getProveedorName(req,res){
        console.log('listar');
    };
}

module.exports =  controllerProveedor;