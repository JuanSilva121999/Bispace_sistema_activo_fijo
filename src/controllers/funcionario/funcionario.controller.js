const pool = require("../../database/db");
//const { QueryTypes, col } = require("sequelize");


class controllerFuncionario {
    static async postFuncionario(req, res) {
        const { Nombres, Apellidos, Cargo, Telefono, Direccion, idAmbiente } = req.body;
        console.log(req.body);
        try {
            const query = 'INSERT INTO empleados (nombres, apellidos, cargo, telefono, direccion, idambient) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *';
            const values = [Nombres, Apellidos, Cargo, Telefono, Direccion, idAmbiente];
            const result = await pool.query(query, values);
            res.status(201).json(result.rows[0]);
        } catch (error) {
            console.error(error);
            res.status(500).send('Error al crear un funcionario');
        }

    };
    static async getFuncionario(req, res) {
        try {
            const result = await pool.query("SELECT * FROM empleados");
            //const resultados = connection[0];
            //console.log(resultados);
            res.status(200).send({ funcionarios: result.rows });
        } catch (error) {
            res.status(500).send(error.message);
        }
    };
    static async getFuncionarioById(req, res) {
        const { id } = req.params;
        try {
            const query = 'SELECT * FROM empleados WHERE idempleado = $1';
            const result = await pool.query(query, [id]);
            if (result.rows.length === 0) {
                res.status(404).send('Funcionario no encontrado');
            } else {
                res.json(result.rows[0]);
            }
        } catch (error) {
            console.error(error);
            res.status(500).send('Error al obtener el funcionario');
        }
    };
    static async putFuncionario(req, res) {
        console.log('listar');
    };
    static async deleteFuncionario(req, res) {
        const { id } = req.params;
        try {
            const query = 'DELETE FROM empleados WHERE idempleado = $1 RETURNING *';
            const result = await pool.query(query, [id]);
            if (result.rows.length === 0) {
                res.status(404).send('Funcionario no encontrado');
            } else {
                res.json({ message: 'Funcionario eliminado correctamente' });
            }
        } catch (error) {
            console.error(error);
            res.status(500).send('Error al eliminar el funcionario');
        }
    };
    static async getFuncionarioName(req, res) {
        console.log('listar');
    };

}

module.exports = controllerFuncionario;