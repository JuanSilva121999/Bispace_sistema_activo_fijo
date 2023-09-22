const pool = require("../../database/db");
const database = require("../../database/db");
//const { QueryTypes, col } = require("sequelize");


class controllerBaja{
    static async posBajaActivo(req,res){
        //console.log(req.body);
        const data = req.body;
        const cod  =  data.CodActivo;
        const asunto  = data.Motivo;
        console.log(cod, ' ', asunto);
        try {
            const query  =  'CALL PA_BajaActivosFijos($1, $2)'
            const values=  [cod, data.Motivo];
            const result  = await pool.query(query,values);
            if (result) {
                res.status(200).send({
                    message: 'Baja de activo fijo exitosa',
                    bajaactivo: result
                });
            }else{
                res.status(403).send({error: 'No se logro de baja el activo fijo'});
            }
        } catch (error) {
            console.log(error);
            res.status(500).send(error.message);
        }
    };
    static async getBajaNombre(req,res){
        try {
            const query  =  'SELECT ac.idActivo as Codigo, ac.Imagen, tip.NombreActivo as TipoActivoFijo, con.Nombre, ac.Descripcion, ba.FechaBaja as Fecha, ba.Motivo FROM bajas ba INNER JOIN activos ac ON ac.idActivo = ba.idActi INNER JOIN tiposactivos tip ON tip.idTipo = ac.idTipo INNER JOIN condiciones con ON con.idCondicion = ac.idCondicion ORDER BY ba.idBaja DESC;';

            const result = await pool.query(query);
            if(result.rows.length){
                res.status(200).send({baja: result.rows});
            }else{
                res.status(403).send({message: 'No hay ningun registro de activos fijos dados de baja'});
            }
            
        } catch (error) {
            console.log(error);
            res.status(500).send(error.message);

        }
    };
    
}

module.exports =  controllerBaja;