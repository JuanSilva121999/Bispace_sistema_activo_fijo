const { Router } = require("express");
const pool = require("../../database/db");
//const { QueryTypes, col } = require("sequelize");
const jwt = require("./../../helpers/jwt");
const bcrypt = require("bcrypt");


class controllerUsuario {
    static async loginUsuario(req, res) {
        console.log('ingresar');
        res.status(200).send({
            jwt: jwt.createToken('usuario_data[0]'),
            user: 'usuario_data[0]',
            // decodi: jwto.verify(jwt.createToken(usuario_data[0]), secret)
        });
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
        console.log('buscar');
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
                            res.status(200).send({user: result});
                        } catch (error) {
                            console.error(error);
                            res.status(403).send({error: 'No se registro el usuario'});
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
        console.log('actualizar');
    }
}

module.exports = controllerUsuario