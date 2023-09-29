const pool = require("../../database/db");
const database = require("../../database/db");
//const { QueryTypes, col } = require("sequelize");


class controllerDepreciacion{
    static async postDepreciacionActivo(req,res){
        try {
            const data = req.body;
            //console.log(data);
            let valor =  await pool.query('SELECT valor FROM valordepreciacion valDep ORDER BY	valDep.Valor DESC LIMIT 1');
            valor = valor.rows[0];
            //console.log(valor);
            const activosDepreciables = await pool.query('SELECT idActivo FROM activos WHERE ValorRegistro >=$1',[valor.valor])
            const actDepr= activosDepreciables.rows;
            for (let index = 0; index < actDepr.length; index++) {
                let CodActivo = actDepr[index].idactivo;
                //console.log(CodActivo);
                let UfvIn = await pool.query (`SELECT UfvInicial FROM activos WHERE idActivo = ${CodActivo}`)
                UfvIn =  UfvIn.rows[0]
                console.log(UfvIn);
                
            }

        } catch (error) {
            res.status(500).send(error.message);
        }
    };
    static async getDatosDepreciacionById(req,res){
        console.log('listar dep by id');
    };
    static async getDepreciaciones(req,res){
        console.log('listar de ');
    };
    static async getActivosDepreciacionCodigo(req,res){
        console.log('listar de cod');
    };
    static async postValorDepreciacion(req,res){
        try {
            const valor =  req.body.Valor;

            const result = await pool.query("INSERT INTO valordepreciacion (valor) values ($1) RETURNING *", [valor]);
            res.status(200).send({valor: result.rows});
        } catch (error) {
            console.log(error.message);
            res.status(500).send(error.message);
        }
    };
    static async getValorDepreciacion(req,res){
        try {
            const query = 'SELECT * FROM valordepreciacion order by valor desc';
            const result =  await pool.query(query)
            if(result.rows.length > 0){
                res.status(200).send({valor: result.rows});
            }else{
                res.status(404).send({message: "No hay valores para depreciar."});
            }
        } catch (error) {
            console.log(error.message);
            res.status(500).send(error.message);
        }
    };
    static async deleteValorDepreciacion(req,res){
        try {
            const id= req.params.id;
            const query = 'DELETE FROM  valordepreciacion WHERE id= $1 RETURNING *';
            const values  = [id]
            const result = await pool.query(query,values);
            res.status(200).send({valor: result});

        } catch (error) {
            console.log(error.message);
            res.status(500).send(error.message);
        }
    };

}

module.exports =  controllerDepreciacion;