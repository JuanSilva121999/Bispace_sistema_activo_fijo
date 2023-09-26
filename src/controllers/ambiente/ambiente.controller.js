const pool = require("../../database/db");
//const { QueryTypes, col } = require("sequelize");


class controllerAmbiente{
    static async postAmbiente(req,res){
        console.log('llenar activo');
    };
    static async getAmbiente(req,res){
        try {
            const result = await pool.query("SELECT * FROM ambientes");
            //const resultados = connection[0];
            //console.log(resultados);
            res.status(200).send({ ambiente: result.rows });
        } catch (error) {
            res.status(500).send(error.message);
            console.log(error);
        }
    };
    static async getAmbienteById(req,res){
        console.log('Byis');
    };
    static async putAmbiente(req,res){
        console.log('listar');
    };
    static async deleteAmbiente(req,res){
        console.log('listar');
    };
    static async getAmbienteName(req,res){
        console.log('Byidsd');
    };
    static async getEdificioAmbienteById(req,res){
        try {
            const id =  req.params.id;
            console.log(id);
            const query  = 'SELECT * FROM ambientes WHERE idedificio  =  $1';
            const result  = await pool.query(query,[id]);
            //console.log(result.rows);
            res.status(200).send({ambientes: result.rows});
        } catch (error) {
            console.log(error);
            res.status(500).send(error.message);
        }
    };
}

module.exports =  controllerAmbiente;