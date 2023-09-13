const database = require("../../database/db");
//const { QueryTypes, col } = require("sequelize");


class controllerBaja{
    static async posBajaActivo(req,res){
        console.log('llenar activo');
    };
    static async getBajaNombre(req,res){
        console.log('listar');
    };
    
}

module.exports =  controllerBaja;