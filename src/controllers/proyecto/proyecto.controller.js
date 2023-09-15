const pool = require("../../database/db");
//const { QueryTypes, col } = require("sequelize");


class controllerProyecto {
    static async postProyecto(req, res) {
        const { NombrePro, FechaInicio, FechaFin, idPrograma } = req.body;
        console.log(req.body);
        try {
            const query = 'INSERT INTO proyectos (nombrepro, fechainicio, fechafin, idprograma) VALUES ($1, $2, $3, $4) RETURNING *';
            const values = [NombrePro, FechaInicio, FechaFin, idPrograma];
            const result = await pool.query(query, values);
            res.status(201).json(result.rows[0]);
        } catch (error) {
            console.error(error);
            res.status(500).send('Error al crear un funcionario');
        }
    };
    static async getProyecto(req, res) {
        try {
            const result = await pool.query("SELECT * FROM proyectos");
            res.status(200).send({ proyectos: result.rows });
        } catch (error) {
            res.status(500).send(error.message);
            console.log(error);
        }
    };
    static async getProyectoById(req, res) {
        const { id } = req.params;
        try {
            const query = 'SELECT * FROM proyectos WHERE idproyecto = $1';
            const result = await pool.query(query, [id]);
            if (result.rows.length === 0) {
                res.status(404).send('proyecto no encontrado');
            } else {
                res.json({ proyecto: result.rows[0] });
            }
        } catch (error) {
            console.error(error);
            res.status(500).send('Error al obtener el funcionario');
        }
    };
    static async putProyecto(req, res) {
        console.log('listar');
    };
    static async deleteProyecto(req, res) {
        const { id } = req.params;
        try {
            const query = 'DELETE FROM proyectos WHERE idproyecto = $1 RETURNING *';
            const result = await pool.query(query, [id]);
            if (result.rows.length === 0) {
                res.status(404).send('Poyecto no encontrado');
            } else {
                res.json({ message: 'Proyecto eliminado correctamente', ok: true });
            }
        } catch (error) {
            console.error(error);
            res.status(500).send('Error al eliminar el funcionario');
        }
    };
    static async getProyectoName(req, res) {
        console.log('listar');
    };
    static async getProyectosEjecucion(req, res) {
        console.log('Extra');
    }
}

module.exports = controllerProyecto;