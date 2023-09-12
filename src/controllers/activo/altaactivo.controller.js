const database = require("../../database/db");
//const { QueryTypes, col } = require("sequelize");


class controllerAltaActivo{
    static async postAltaActivo(req,res){
        console.log('llenar activo');
    };
    static async getDetalleAltaActivoById(req,res){
        console.log('listar');
    };
    static async deleteAltaActivo(req,res){
        console.log('listar');
    };
    static async getAltaActivo(req,res){
        console.log('listar');
    };
    static async getActivoAlta(req,res){
        console.log('listar');
    };
    static async getEmpleadoAltaActivo(req,res){
        console.log('listar');
    };
    static async getAltaActivoCodigo(req,res){
        console.log('listar');
    };
    static async getDatosAltaActivoById(req,res){
        console.log('listar');
    };
    static async getPDFWithQr(req,res){
        console.log('buscar');
    }
    static async getActivoAltaFiltroFecha(req,res){
        console.log('añadir');
    }

}

module.exports =  controllerAltaActivo;