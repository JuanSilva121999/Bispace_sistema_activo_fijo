const pool = require("../../database/db");
const database = require("../../database/db");
//const { QueryTypes, col } = require("sequelize");


class controllerHistorial {
    static async postHistorial(req, res) {
        console.log('llenar activo');
    };
    static async getHistorial(req, res) {
        console.log('listar');
    };
    static async getHistorialById(req, res) {
        console.log('listar');
    };
    static async putHistorial(req, res) {
        console.log('listar');
    };
    static async deleteHistorial(req, res) {
        console.log('listar');
    };
    static async getHistorialName(req, res) {
        console.log('listar');
    };







    static async getHistorialActivosFijos(req, res) {
        try {
            const nombre = req.params['nombre'];
            if (nombre === undefined) {
                const query = "SELECT * FROM historialactivofijo his INNER JOIN activos ac ON ac.idActivo = his.CodActivo INNER JOIN empleados em ON em.idEmpleado = his.CodEmpleado INNER JOIN proyectos pro ON pro.idProyecto = his.CodProyecto INNER JOIN ambientes am ON am.idAmbiente = his.CodAmbiente INNER JOIN edificios ed ON ed.idEdificio = am.idEdificio WHERE em.Nombres ~* '' OR ac.Descripcion ~* '' ORDER BY his.CodActivo; "
                const resul = await pool.query(query);
                if (resul.rows) {
                    res.status(200).send({ activos: resul.rows });
                } else {
                    res.status(403).send({ message: 'No hay historial' });
                }
            } else {
                const query = "SELECT * FROM historialactivofijo his INNER JOIN activos ac ON ac.idActivo = his.CodActivo INNER JOIN empleados em ON em.idEmpleado = his.CodEmpleado INNER JOIN proyectos pro ON pro.idProyecto = his.CodProyecto INNER JOIN ambientes am ON am.idAmbiente = his.CodAmbiente INNER JOIN edificios ed ON ed.idEdificio = am.idEdificio WHERE pro.NombrePro ~* $1 OR em.Nombres ~* $1 OR ac.Descripcion ~* $1 ORDER BY ac.idActivo; ";
                const values = [nombre];
                const resul = await pool.query(query, values)
                if (resul.rows) {
                    res.status(200).send({ activos: resul.rows });
                } else {
                    res.status(403).send({ message: 'No hay historial' });
                }
            }
        } catch (error) {
            console.log(error.message);
            res.status(500).send(error.message);
        }
    };
    static async getHistorialActivosFijosCod(req, res) {
        console.log('listar');
    };
    static async getHistorialDepreciaciones(req, res) {
        console.log('listar');
    };


}

module.exports = controllerHistorial;