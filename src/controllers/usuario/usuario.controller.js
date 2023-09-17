const { Router, query } = require("express");
const pool = require("../../database/db");
//const { QueryTypes, col } = require("sequelize");
const jwt = require("./../../helpers/jwt");
const bcrypt = require("bcrypt");


class controllerUsuario {
    static async loginUsuario(req, res) {

        try {
            console.log(req.body);
            const data = req.body;
            const query = 'SELECT us.idUsuario, em.Nombres, em.Apellidos, us.Email, us.Password, us.Rol, us.Estado FROM usuarios us INNER JOIN empleados em ON us.idEmplead=em.idEmpleado WHERE us.Email = $1';
            const values = [data.Email];
            const result = await pool.query(query, values);
            const user = result.rows;
            console.log(user.length);
            if (user.length) {
                const datos = user[0]
                //console.log(datos);
                bcrypt.compare(data.Password, datos.password, function (err, check) {
                    console.log(datos);
                    if (check === true) {
                        console.log(data.gettoken);
                        if (data.gettoken) {
                            res.status(200).send({
                                jwt: jwt.createToken(datos),
                                user: datos,
                                // decodi: jwto.verify(jwt.createToken(usuario_data[0]), secret)
                            });
                        } else {
                            res.status(200).send({
                                user: datos,
                                message: 'no token',
                                jwt: jwt.createToken(datos),
                            });
                        }
                    } else {
                        res.status(403).send({ message: 'El corre o contraseña no coinciden' });
                    }
                });
            } else {
                res.status(403).json({ message: 'El correo no existe' });
            }
        } catch (error) {
            res.status(500).send(error.message);
        }

    };
    static async getUsuario(req, res) {
        try {
            const result = await pool.query("SELECT * FROM usuarios");
            //const resultados = connection[0];
            //console.log(resultados);
            res.status(200).send({ usuarios: result.rows });
        } catch (error) {
            res.status(500).send(error.message);
        }
    };
    static async getUsuarioById(req, res) {
        const { id } = req.params;
        try {
            const query = 'SELECT * FROM usuarios WHERE idusuario = $1';
            const result = await pool.query(query, [id]);
            if (result.rows.length === 0) {
                res.status(404).send('Usuario no encontrado');
            } else {
                res.json({ usuario: result.rows[0] });
            }
        } catch (error) {
            console.error(error);
            res.status(500).send('Error al obtener el funcionario');
        }
    }
    static async postUsuario(req, res) {
        try {
            const data = req.body;
            console.log(data);
            if (data.Password && data.Email) {
                bcrypt.hash(data.Password, 10, async function (err, hash) {
                    if (hash) {
                        console.log(hash);
                        const usuario = {
                            idEmplead: data.idEmplead,
                            Email: data.Email,
                            Password: hash,
                            Rol: data.Rol,
                            Estado: data.Estado
                        };
                        try {
                            const query = 'INSERT INTO usuarios (idemplead, email, password, rol, estado) VALUES ($1, $2, $3, $4, $5) RETURNING *';
                            const values = [usuario.idEmplead, usuario.Email, usuario.Password, usuario.Rol, usuario.Estado];
                            const result = await pool.query(query, values);
                            res.status(200).send({ user: result });
                        } catch (error) {
                            console.error(error);
                            res.status(403).send({ error: 'No se registro el usuario' });
                        }
                    }
                });
            } else {
                res.status(403).json({ message: 'No ingreso el email o la contraseña' });
            }
        } catch (error) {
            res.status(500).send(error.message);
        }
    }
    static async putUsuario(req, res) {
        console.log(req.body);
        const { idUsuario, idEmplead, Email, Password, Rol, Estado } = req.body;
        console.log(Password);
        try {
            if (Password == undefined) {
                const query = 'UPDATE usuarios SET  idemplead = $1, email = $2, rol = $3, estado = $4 WHERE idusuario = $5 RETURNING *';
                const values = [idEmplead, Email, Rol, Estado, idUsuario];
                const result = await pool.query(query, values);
                if (result.rows.length === 0) {
                    res.status(404).send('Usuario no encontrado');
                } else {
                    res.json(result.rows[0]);
                }
            } else {
                bcrypt.hash(Password, 10, async function (err, hash) {
                    const query = 'UPDATE usuarios SET  idemplead = $1, email = $2, rol = $3, password  =$4,estado = $5 WHERE idusuario = $6 RETURNING *';
                    const values = [idEmplead, Email, Rol,hash, Estado, idUsuario];
                    const result = await pool.query(query, values);
                    if (result.rows.length === 0) {
                        res.status(404).send('Usuario no encontrado');
                    } else {
                        res.json(result.rows[0]);
                    }


                });
            }

        } catch (error) {
            console.error(error);
            res.status(500).send('Error al actualizar el Empleado');
        }
    }
}

module.exports = controllerUsuario