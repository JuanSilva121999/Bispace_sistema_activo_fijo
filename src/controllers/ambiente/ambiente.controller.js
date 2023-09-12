const database = require("../../database/db");
//const { QueryTypes, col } = require("sequelize");


class controllerAmbiente{
    static async postAmbiente(req,res){
        console.log('llenar activo');
    };
    static async getAmbiente(req,res){
        console.log('listar');
    };
    static async getAmbienteById(req,res){
        console.log('listar');
    };
    static async putAmbiente(req,res){
        console.log('listar');
    };
    static async deleteAmbiente(req,res){
        console.log('listar');
    };
    static async getAmbienteName(req,res){
        console.log('listar');
    };
    static async getEdificioAmbienteById(req,res){
        console.log('listar');
    };
}

module.exports =  controllerAmbiente;