const database = require("../../database/db");
//const { QueryTypes, col } = require("sequelize");


class controllerHistorial{
    static async postHistorial(req,res){
        console.log('llenar activo');
    };
    static async getHistorial(req,res){
        console.log('listar');
    };
    static async getHistorialById(req,res){
        console.log('listar');
    };
    static async putHistorial(req,res){
        console.log('listar');
    };
    static async deleteHistorial(req,res){
        console.log('listar');
    };
    static async getHistorialName(req,res){
        console.log('listar');
    };
    static async getHistorialActivosFijos(req,res){
        console.log('listar');
    };
    static async getHistorialActivosFijosCod(req,res){
        console.log('listar');
    };
    static async getHistorialDepreciaciones(req,res){
        console.log('listar');
    };


}

module.exports =  controllerHistorial;