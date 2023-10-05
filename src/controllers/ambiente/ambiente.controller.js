const pool = require("../../database/db");
//const { QueryTypes, col } = require("sequelize");


class controllerAmbiente{
    static async postAmbiente(req,res){
        try {
            const data =  req.body;
            console.log(data);
            const result =  await pool.query("INSERT INTO public.ambientes (nombreamb, descripcionamb, idedificio) VALUES($1, $2, $3)RETURNING * ",[data.NombreAmb,data.DescripcionAmb,data.idEdificio])
            res.status(200).send({ambiente: result.rows});
        } catch (error) {
            console.log(error.message);
            res.status(500).send(error.message);
        }
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
        try {
            const id =  req.params.id
            const result = await pool.query("SELECT * FROM ambientes where idambiente = $1", [id]);
            //const resultados = connection[0];
            //console.log(resultados);
            res.status(200).send({ ambiente: result.rows });
        } catch (error) {
            res.status(500).send(error.message);
            console.log(error);
        }
    };
    static async putAmbiente(req,res){
        try {
            const data = req.body;
            const id = req.params.id;
            const resultado =  await pool.query("UPDATE public.ambientes SET nombreamb=$1, descripcionamb=$2, idedificio=$3 WHERE idambiente=$4 RETURNING *;",
            [data.NombreAmb,data.DescripcionAmb,data.idEdificio,id])
            res.status(200).send({ambiente: resultado});
        } catch (error) {
            res.status(500).send(error.message);
            console.log(error);
        }
    };
    static async deleteAmbiente(req,res){
        try {
            const id =  req.params.id;
            await pool.query('DELETE FROM ambientes WHERE idAmbiente= $1',[id])
            res.status(200).send({ok: true});
        } catch (error) {
            res.status(500).send(error.message);
            console.log(error);
        }
    };
    static async getAmbienteName(req,res){
        try {
            const nombre =  req.params['nombre'];
            if (nombre === undefined) {
                let result =  await pool.query('SELECT * FROM ambientes am INNER JOIN edificios ed ON am.idedificio =  ed.idedificio ')
                result = result.rows;
                if (result.length >0) {
                    res.status(200).send({ambientes: result}); 
                }
            } else {
                res.status(403).send({message: 'No hay ningun registro'});
            }
        } catch (error) {
            console.log(error.message);
            res.status(500).send(error.message);
        }
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