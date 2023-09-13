const database = require("../../database/db");
//const { QueryTypes, col } = require("sequelize");


class controllerProyecto{
    static async postProyecto(req,res){
        console.log('llenar activo');
    };
    static async getProyecto(req,res){
        console.log('listar');
    };
    static async getProyectoById(req,res){
        console.log('listar');
    };
    static async putProyecto(req,res){
        console.log('listar');
    };
    static async deleteProyecto(req,res){
        console.log('listar');
    };
    static async getProyectoName(req,res){
        console.log('listar');
    };
    static async getProyectosEjecucion(req,res){
        console.log('Extra');
    }
}

module.exports =  controllerProyecto;