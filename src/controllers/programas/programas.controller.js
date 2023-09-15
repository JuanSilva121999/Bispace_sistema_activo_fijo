const pool = require("../../database/db");
//const { QueryTypes, col } = require("sequelize");


class controllerProgramas{
    static async postProgramas(req,res){
        try {
            const data  =  req.body;
            const programa  =  {
                NombreProg:  data.NombreProg
            }
            const query = 'INSERT INTO programas (nombreprog) VALUES ($1) RETURNING *';
            const values = [programa.NombreProg];
            const result  = await pool.query(query,values);
            res.status(200).send({programa: result});
        } catch (error) {
            console.error(error);
            res.status(500).send('Error al crear el programa');
        }
    };
    static async getProgramas(req,res){
        try {
            const result = await pool.query("SELECT * FROM programas");
            //const resultados = connection[0];
            //console.log(resultados);
            res.status(200).send({ programas: result.rows });
        } catch (error) {
            res.status(500).send(error.message);
        }
    };
    static async getProgramasById(req,res){
        console.log('listar');
    };
    static async putProgramas(req,res){
        console.log('listar');
    };
    static async deleteProgramas(req,res){
        console.log('listar');
    };
    static async getProgramasName(req,res){
        console.log('listar');
    };
}

module.exports =  controllerProgramas;