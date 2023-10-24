const pool = require("../../database/db");
//const { QueryTypes, col } = require("sequelize");


class controllerRublo {
    static async postRublo(req, res) {
        //console.log(req.body);
        try {
            const data = req.body;
            const rubro = {
                Nombre: data.Nombre,
                VidaUtil: data.VidaUtil,
                Depreciable: data.Depreciable,
                CoeficienteD: data.CoeficienteD / 100,
                Actualiza: data.Actualiza,
                Codigo : data.Codigo
            }
            const query='INSERT INTO rubros (nombre,vidautil,depreciable,coeficiented,actualiza,cod)VALUES($1,$2,$3,$4,$5,$6)';
            const values =[rubro.Nombre,rubro.VidaUtil,rubro.Depreciable,rubro.CoeficienteD, rubro.Actualiza,rubro.Codigo]
            const result = await pool.query(query,values);
            res.status(200).json(result.rows[0]);
        } catch (error) {
            console.log(error);
            res.status(500).send(error.message);
        }
    };
    static async getRublo(req, res) {
        try {
            const result = await pool.query("SELECT * FROM rubros");
            //const resultados = connection[0];
            //console.log(resultados);
            res.status(200).send({ rubros: result.rows });
        } catch (error) {
            res.status(500).send(error.message);
            console.log(error);
        }
    };
    static async getRubloById(req, res) {
        const { id } = req.params;
        try {
            const query = 'SELECT * FROM rubros WHERE idrubro = $1';
            const result = await pool.query(query, [id]);
            if (result.rows.length === 0) {
                res.status(404).send('Rubro no encontrado');
            } else {
                res.json({ rubro: result.rows[0] });
            }
        } catch (error) {
            console.error(error);
            res.status(500).send('Error al obtener el Rubros');
        }
    };
    static async putRublo(req, res) {
        //console.log(req.body);
        try {
            const id = req.params.id;
            const data  = req.body;
            const query = 'UPDATE rubros SET  nombre = $1, vidautil = $2, depreciable = $3, coeficiented = $4, actualiza  =  $5 WHERE idrubro = $6 RETURNING *';
            const values = [data.Nombre, data.VidaUtil,data.Depreciable,data.CoeficienteD,data.Actualiza,id];
            const result = await pool.query(query, values);
            if (result.rows.length === 0) {
              res.status(404).send('Rubro no encontrado');
            } else {
              res.json(result.rows[0]);
            }
        } catch (error) {
            res.status(500).send(error.message);
        }
    };
    static async deleteRublo(req, res) {
        const {id} =  req.params;
        try {
            const query = 'DELETE FROM rubros WHERE idrubro = $1 RETURNING *';
            const result = await pool.query(query, [id]);
            if (result.rows.length === 0) {
                res.status(404).send('Rubro no encontrado');
            } else {
                res.json({ message: 'Rubro eliminado correctamente', ok: true });
            }
        } catch (error) {
            console.error(error);
            res.status(500).send('Error al eliminar el Rubro');
        }
    };
    static async getRubloName(req, res) {
        console.log('listar');
    };
}

module.exports = controllerRublo;