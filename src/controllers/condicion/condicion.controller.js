const database = require("../../database/db");
//const { QueryTypes, col } = require("sequelize");


class controllerConcidcion{
    static async postCondicion(req,res){
        console.log('llenar activo');
    };
    static async getCondiciones(req,res){
        console.log('listar');
    };
    static async getCondicionById(req,res){
        console.log('listar');
    };
    static async putCondicion(req,res){
        console.log('listar');
    };
    static async deleteCondicion(req,res){
        console.log('listar');
    };
    static async getCondicionName(req,res){
        console.log('listar');
    };
}

module.exports =  controllerConcidcion;