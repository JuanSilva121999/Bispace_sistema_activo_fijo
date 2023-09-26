const pool = require("../../database/db");

//const { QueryTypes, col } = require("sequelize");


class controllerEdificio{
    static async postEdificio(req,res){
        console.log('llenar activo');
    };
    static async getEdificio(req,res){
        try {
            const query  = 'SELECT * FROM edificios'
            const result =  await pool.query(query);
            res.status(200).send({edificios: result.rows});
        } catch (error) {
            console.log(error);
            res.status(500).send(error.message);
            
        }
    };
    static async getEdificioById(req,res){
        console.log('listar');
    };
    static async putEdificio(req,res){
        console.log('listar');
    };
    static async deleteEdificio(req,res){
        console.log('listar');
    };
    static async getEdificioName(req,res){
        console.log('listar');
    };

}

module.exports =  controllerEdificio;