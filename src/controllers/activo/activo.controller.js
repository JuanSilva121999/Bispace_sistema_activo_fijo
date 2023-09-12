const database = require("../../database/db");
//const { QueryTypes, col } = require("sequelize");


class controllerActivo{
    static async postActivo(req,res){
        console.log('llenar activo');
    };
    static async getActivoCodigo(req,res){
        console.log('listar');
    };
    static async putActivo(req,res){
        console.log('buscar');
    }
    static async getActivoById(req,res){
        console.log('añadir');
    }
    static async deleteActivo(req,res){
        console.log('actualizar');
    }
    static async get_imagen(req,res){
        console.log('añadir');
    }
    static async get_factura(req,res){
        console.log('actualizar');
    }

}

module.exports =  controllerActivo;