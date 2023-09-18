const pool = require("../../database/db");
//const { QueryTypes, col } = require("sequelize");


class controllerConcidcion{
    static async postCondicion(req,res){
        console.log(req.body);
        try {
            const data =  req.body;
            const condicion = {Nombre  : data.Nombre}
            const query ='INSERT INTO condiciones (nombre) VALUES ($1) RETURNING *';
            const values = [condicion.Nombre] 
            const result  =  await pool.query(query,values)
            res.status(200).json(result.rows[0]);
        } catch (error) {
            res.status(500).send(error.message);
        }
    };
    static async getCondiciones(req,res){
        try {
            const result = await pool.query("SELECT * FROM condiciones");
            //const resultados = connection[0];
            //console.log(resultados);
            res.status(200).send({ condicion: result.rows });
        } catch (error) {
            res.status(500).send(error.message);
            console.log(error);
        }
    };
    static async getCondicionById(req,res){
        console.log('listar');
    };
    static async putCondicion(req,res){
        console.log('listar');
    };
    static async deleteCondicion(req,res){
        console.log('listar');
    };
    static async getCondicionName(req,res){
        console.log('listar');
    };
}

module.exports =  controllerConcidcion;