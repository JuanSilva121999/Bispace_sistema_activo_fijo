const database = require("../../database/db");
//const { QueryTypes, col } = require("sequelize");
const jwt= require( "./../../helpers/jwt");

class controllerUsuario{
    static async loginUsuario(req,res){
        console.log('ingresar');
        res.status(200).send({
            jwt: jwt.createToken('usuario_data[0]'),
            user: 'usuario_data[0]',
            // decodi: jwto.verify(jwt.createToken(usuario_data[0]), secret)
        });
    };
    static async getUsuario(req,res){
        console.log('listar');
    };
    static async getUsuarioById(req,res){
        console.log('buscar');
    }
    static async postUsuario(req,res){
        console.log('añadir');
    }
    static async putUsuario(req,res){
        console.log('actualizar');
    }
}

module.exports =  controllerUsuario