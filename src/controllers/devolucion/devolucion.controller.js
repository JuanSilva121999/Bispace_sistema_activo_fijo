const database = require("../../database/db");
//const { QueryTypes, col } = require("sequelize");


class controllerDevolucion{
    static async postAltaDevolucion(req,res){
        console.log('llenar activo');
    };
    static async getDevolucionNombre(req,res){
        console.log('listar');
    };
    
}

module.exports =  controllerDevolucion;