const pool = require("../../database/db");
//const { QueryTypes, col } = require("sequelize");


class controllerFuncionario {
    static async postFuncionario(req, res) {
        const { Nombres, Apellidos, Cargo, Telefono, Direccion, idAmbiente,ciEmpleado } = req.body;
        console.log(req.body);
        try {
            const query = 'INSERT INTO empleados (nombres, apellidos, cargo, telefono, direccion, idambient, ci) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *';
            const values = [Nombres, Apellidos, Cargo, Telefono, Direccion, idAmbiente,ciEmpleado];
            const result = await pool.query(query, values);
            res.status(201).json(result.rows[0]);
        } catch (error) {
            console.error(error);
            res.status(500).send('Error al crear un funcionario');
        }

    };
    static async getFuncionario(req, res) {
        try {
            const result = await pool.query("SELECT * FROM empleados e inner join ambientes a on a.idambiente = e.idambient inner join edificios ed on ed.idedificio = a.idedificio");
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
                console.log(result.rows[0]);
                res.status(200).json({
                    funcionario: result.rows[0]});
            }
        } catch (error) {
            console.error(error);
            res.status(500).send('Error al obtener el funcionario');
        }
    };
    static async putFuncionario(req, res) {
        const data = req.body;
        try {
            console.log(data);
            ///Validamos que el Empleado exista en la base de datos
            const empleado =  await pool.query('select * from empleados where idempleado = $1',[data.idEmpleado])
            console.log(empleado.rows);
            if (empleado.rows.length >0) {
                const newData = {
                    nombres : data.Nombres,
                    apellidos : data.Apellidos,
                    cargo : data.Cargo,
                    telefono : data.Telefono,
                    direccion : data.Direccion,
                    idambiente : data.idAmbiente,
                    ci : data.ciEmpleado,
                }
                await pool.query('UPDATE public.empleados SET nombres=$1, apellidos=$2, cargo=$3, telefono=$4, direccion=$5, idambient=$6, ci = $7 WHERE idempleado=$8;',[
                    newData.nombres,
                    newData.apellidos,
                    newData.cargo,
                    newData.telefono,
                    newData.direccion,
                    newData.idambiente,
                    newData.ci,
                    data.idEmpleado
                ])
                res.status(200).json({
                    ok: true,
                    message : 'Actualizacion Completa'
                })
                console.log('Existe el empleado');
            }else{

                console.log('No existe el empleado');
                res.status(404).json({
                    ok :false,
                    message: 'No existe el empleado'
                })
            }
        } catch (error) {
            console.log(error.message);
            res.status(500).send(error.message);
        }
    };
    static async deleteFuncionario(req, res) {
        const { id } = req.params;
        try {
            const query = 'DELETE FROM empleados WHERE idempleado = $1 RETURNING *';
            const result = await pool.query(query, [id]);
            if (result.rows.length === 0) {
                res.status(404).send('Funcionario no encontrado');
            } else {
                res.json({ message: 'Funcionario eliminado correctamente' , ok : true});
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