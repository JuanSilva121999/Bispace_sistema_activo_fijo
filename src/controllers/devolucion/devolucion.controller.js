const pool = require("../../database/db");
const database = require("../../database/db");
//const { QueryTypes, col } = require("sequelize");


class controllerDevolucion{
    static async postAltaDevolucion(req,res){
        try {
            const data =  req.body
            //console.log(data);
            const cod =  data.CodActivo;
            //console.log(cod);
            let activo =  await pool.query ('select * from activos ac inner join altaactivos alt on ac.idactivo = alt.idactiv inner join proyectos pr on alt.idproyecto =  pr.idproyecto where ac.idactivo = $1',[cod])
            activo =  activo.rows[0];
            console.log(activo);
            const datos = {
                codactivo: activo.idactivo,
                codempleado: activo.idempleado,
                idcondici: data.CodCondicion,
                motivo: data.Motivo,
                fechadevolucion : new Date(),
                proyecto : activo.nombrepro ,
                observaciones : data.Observaciones
            }
            await pool.query(`INSERT INTO public.historial_devoluciones (fecha_devolucion, empleado_id, equipo_id, detalle_devolucion) VALUES( current_date, $1, $2, $3);`,[datos.codempleado,datos.codactivo,datos.motivo])
            await pool.query(`
            UPDATE public.activos
            SET estado='Activo' ,idcondicion=$1
            WHERE idactivo=$2;
            `,
            [data.CodCondicion,data.CodActivo])
            console.log(datos);
            const result  =  await pool.query(`INSERT INTO public.devoluciones
            (codactivo, codempleado, idcondici, motivo, fechadevolucion, proyecto, observaciones)
            VALUES($1, $2, $3, $4, $5, $6, $7) RETURNING *;
            `,[datos.codactivo,datos.codempleado,datos.idcondici,datos.motivo,datos.fechadevolucion, datos.proyecto,datos.observaciones])
            if(result.rows===0){
                res.status(200).send({
                    message: 'No se resgistro la devolucion'
                })
            }else{
                res.status(200).send({
                    message: 'Devolución de activo exitosa',
                    altaactivo: result.rows
                })
            }
        } catch (error) {
            console.log(error);
            res.status(500).send(error.message)
        }
    };
    static async getDevolucionNombre(req,res){
        try {
            console.log('Listado de devoluciones');
            const nombre  =  req.params['nombre']
            if (nombre === undefined) {
                const query =`SELECT 
                dev.Motivo, 
                em.Nombres, 
                ac.Imagen, 
                em.Apellidos, 
                ac.Descripcion AS "ActivoFijo", 
                ac.idActivo AS "Codigo", 
                con.Nombre AS "Condicion", 
                dev.Observaciones, 
                dev.FechaDevolucion, 
                dev.proyecto
              FROM 
                devoluciones dev 
              INNER JOIN 
                empleados em ON em.idEmpleado = dev.CodEmpleado 
              INNER JOIN 
                condiciones con ON con.idCondicion = dev.idCondici 
              INNER JOIN 
                activos ac ON ac.idActivo = dev.CodActivo 
              ORDER BY 
                dev.idDevolucion DESC;
              `
              const result  =  await pool.query(query);
              if(result.rows.length){
                res.status(200).send({devolucion: result.rows});
              }
            } else {
                res.status(200).send({message: 'No hay ningun registro de devolución'});
            }
        } catch (error) {
            console.log(error);
            res.status(500).send(error.message)
        }
    };
    
}

module.exports =  controllerDevolucion;