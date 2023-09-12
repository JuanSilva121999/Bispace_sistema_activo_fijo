const database = require("../../database/db");
//const { QueryTypes, col } = require("sequelize");


class controllerUsuario{
    static async loginUsuario(req,res){
        console.log('ingresar');
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