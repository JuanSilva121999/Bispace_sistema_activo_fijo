const database = require("../../database/db");
//const { QueryTypes, col } = require("sequelize");


class controllerMantenimiento{
    static async postMantenimiento(req,res){
        console.log('llenar activo');
    };
    static async getMantenimiento(req,res){
        console.log('listar');
    };
    static async getMantenimientoById(req,res){
        console.log('listar');
    };
    static async putMantenimiento(req,res){
        console.log('listar');
    };
    static async deleteMantenimiento(req,res){
        console.log('listar');
    };
    static async getMantenimientoName(req,res){
        console.log('listar');
    };
}

module.exports =  controllerMantenimiento;