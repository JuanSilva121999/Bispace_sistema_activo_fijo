const database = require("../../database/db");
//const { QueryTypes, col } = require("sequelize");


class controllerProgramas{
    static async postProgramas(req,res){
        console.log('llenar activo');
    };
    static async getProgramas(req,res){
        console.log('listar');
    };
    static async getProgramasById(req,res){
        console.log('listar');
    };
    static async putProgramas(req,res){
        console.log('listar');
    };
    static async deleteProgramas(req,res){
        console.log('listar');
    };
    static async getProgramasName(req,res){
        console.log('listar');
    };
}

module.exports =  controllerProgramas;