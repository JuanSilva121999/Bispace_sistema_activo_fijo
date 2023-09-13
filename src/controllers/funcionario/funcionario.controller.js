const database = require("../../database/db");
//const { QueryTypes, col } = require("sequelize");


class controllerFuncionario{
    static async postFuncionario(req,res){
        console.log('llenar activo');
    };
    static async getFuncionario(req,res){
        console.log('listar');
    };
    static async getFuncionarioById(req,res){
        console.log('listar');
    };
    static async putFuncionario(req,res){
        console.log('listar');
    };
    static async deleteFuncionario(req,res){
        console.log('listar');
    };
    static async getFuncionarioName(req,res){
        console.log('listar');
    };

}

module.exports =  controllerFuncionario;