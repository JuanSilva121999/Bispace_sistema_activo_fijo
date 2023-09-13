const database = require("../../database/db");
//const { QueryTypes, col } = require("sequelize");


class controllerCantidad{
    static async getCantidadUso(req,res){
        console.log('llenar activo');
    };
    static async getCantidadBaja(req,res){
        console.log('listar');
    };
    static async getCantidadMantenimiento(req,res){
        console.log('listar');
    };
    static async getCatidadDisponible(req,res){
        console.log('listar');
    };
    static async getCantidadDepreciados(req,res){
        console.log('listar');
    };
    static async getCantidadRevalorizados(req,res){
        console.log('listar');
    };
    static async getCantidadEdificios(req,res){
        console.log('listar');
    };
    static async getCantRequiereMantenimiento(req,res){
        console.log('listar');
    };
}

module.exports =  controllerCantidad;