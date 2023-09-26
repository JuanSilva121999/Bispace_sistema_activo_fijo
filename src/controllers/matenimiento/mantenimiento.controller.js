const pool = require("../../database/db");
//const { QueryTypes, col } = require("sequelize");


class controllerMantenimiento{
    static async postMantenimiento(req,res){
        const data = req.body;
        try {
            const query = 'CALL PA_MantenimientoActivosFijos($1, $2, $3, $4) ';
            const values  = [data.FechaMant, data.Informe ,data.Costo, data.idAct];
            const result =  await pool.query(query,values);
            if(result){
                //console.log(result);
                res.status(200).send({
                    message: 'Activo fijo en mantenimiento',
                    mantenimiento: result
                });
            }else{
                console.log('No se logro realizar el mantenimineto');
                res.status(403).send({error: 'No se logro realizar el mantenimineto'});
            }
        } catch (error) {
            console.log(error);
            res.status(500).send(error.message);
        }

    };
    static async getMantenimiento(req,res){
        console.log('listar');
    };
    static async getMantenimientoById(req,res){
        console.log('listar');
    };
    static async putMantenimiento(req,res){
        console.log('listar');
    };
    static async deleteMantenimiento(req,res){
        console.log('listar');
    };
    static async getMantenimientoName(req,res){
        console.log('listar');
    };
}

module.exports =  controllerMantenimiento;