const database = require("../../database/db");
//const { QueryTypes, col } = require("sequelize");


class controllerDepreciacion{
    static async postDepreciacionActivo(req,res){
        console.log('llenar activo');
    };
    static async getDatosDepreciacionById(req,res){
        console.log('listar');
    };
    static async getDepreciaciones(req,res){
        console.log('listar');
    };
    static async getActivosDepreciacionCodigo(req,res){
        console.log('listar');
    };
    static async postValorDepreciacion(req,res){
        console.log('listar');
    };
    static async getValorDepreciacion(req,res){
        console.log('listar');
    };
    static async deleteValorDepreciacion(req,res){
        console.log('listar');
    };

}

module.exports =  controllerDepreciacion;