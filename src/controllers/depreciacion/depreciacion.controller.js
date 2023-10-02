const { query } = require("express");
const pool = require("../../database/db");
const database = require("../../database/db");
//const { QueryTypes, col } = require("sequelize");


class controllerDepreciacion {
    static async postDepreciacionActivo(req, res) {
        try {
            const data = req.body;
            console.log(data);

            let valor = await pool.query('SELECT valor FROM valordepreciacion valDep ORDER BY	valDep.Valor DESC LIMIT 1');
            valor = valor.rows[0];
            //console.log(valor);
            const activosDepreciables = await pool.query('SELECT idActivo FROM activos WHERE ValorRegistro >=$1', [valor.valor])
            const actDepr = activosDepreciables.rows;
            for (let index = 0; index < actDepr.length; index++) {
                let CodActivo = actDepr[index].idactivo;
                console.log(CodActivo);
                let UfvIn = await pool.query(`SELECT UfvInicial FROM activos WHERE idActivo = ${CodActivo}`)
                UfvIn = UfvIn.rows[0].ufvinicial
                //console.log(UfvIn);
                let depreciacion = await pool.query(`select * from depreciaciones where idactivo = ${CodActivo}`)
                depreciacion = depreciacion.rows[0];
                //console.log(depreciacion);
                let valorCont = await pool.query(`select a.valoractual from activos  a where a.idactivo = ${CodActivo}`)
                valorCont = parseFloat(valorCont.rows[0].valoractual);
                console.log('Valor almacenado: ', valorCont);
                if (depreciacion) {
                    //console.log(depreciacion);
                    //console.log('Comienza con la tabla inicial');
                    let datos = await pool.query(`select * from activos a inner join rubros r on a.idrubro = r.idrubro where idactivo = ${CodActivo}`)
                    datos = datos.rows[0]
                    //console.log(datos);
                    let factAc = data.UfvAct / UfvIn - 1;
                    if (isNaN(factAc) || factAc === Infinity) {
                        factAc = 0
                    }
                    let valorAct = valorCont * factAc;
                    let increAct = valorAct + valorCont;
                    let depreAcuAnt = depreciacion.depreciacionacuact
                    let increDepAcu = depreAcuAnt * factAc;
                    const valRec = datos.valorregistro * (datos.coeficiented);
                    const deprePer = (datos.valorregistro - valRec) / datos.vidautil;
                    //console.log(deprePer);
                    const depreAcuAct = deprePer
                    let valorNeto = valorCont - depreAcuAct;
                    const result = await pool.query('INSERT INTO public.depreciaciones (ufvactual, ufvinicial, fecha, valorcontabilizado, factoractual, valoractualizado, incrementoactual, depreciacionacuant, incrementodepacu, depreciacionperiodo, depreciacionacuact, valorneto, porcentajedep, vidautilactual, vidautilmes, idactivo) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16)  RETURNING *',[data.UfvAct,datos.ufvinicial,data.FechaDepreciacion,valorCont,factAc,valorAct,increAct,depreAcuAnt,increDepAcu,deprePer,depreAcuAct,valorNeto,datos.coeficiented,datos.vidautil,datos.vidautil,datos.idactivo])
                    const act = await pool.query(`UPDATE public.activos SET  valoractual=${valorNeto} WHERE idactivo=${CodActivo}`)
                } else {
                    //console.log('Comienza con la tabla inicial');
                    let datos = await pool.query(`select * from activos a inner join rubros r on a.idrubro = r.idrubro where idactivo = ${CodActivo}`)
                    datos = datos.rows[0]
                    //console.log(datos);
                    let factAc = data.UfvAct / UfvIn - 1;
                    if (isNaN(factAc) || factAc === Infinity) {
                        factAc = 0
                    }
                    //console.log(factAc);
                    let valorAct = valorCont * factAc;
                    //console.log(valorAct);
                    let increAct = valorAct + valorCont;
                    //console.log(increAct);
                    let depreAcuAnt = 0
                    let increDepAcu = 0;
                    const valRec = datos.valorregistro * (datos.coeficiented);
                    //console.log(valRec);
                    //console.log(datos.valoractual-valRec);
                    const deprePer = (datos.valoractual - valRec) / datos.vidautil;
                    //console.log(deprePer);
                    const depreAcuAct = deprePer
                    let valorNeto = valorCont - depreAcuAct;
                    const result = await pool.query('INSERT INTO public.depreciaciones (ufvactual, ufvinicial, fecha, valorcontabilizado, factoractual, valoractualizado, incrementoactual, depreciacionacuant, incrementodepacu, depreciacionperiodo, depreciacionacuact, valorneto, porcentajedep, vidautilactual, vidautilmes, idactivo) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16)  RETURNING *', [data.UfvAct, datos.ufvinicial, data.FechaDepreciacion, valorCont, factAc, valorAct, increAct, depreAcuAnt, increDepAcu, deprePer, depreAcuAct, valorNeto, datos.coeficiented, datos.vidautil, datos.vidautil, datos.idactivo])
                    const act = await pool.query(`UPDATE public.activos SET  valoractual=${valorNeto} WHERE idactivo=${CodActivo}`)
                }

            }
            res.status(200).send({
                message: 'Depreciacion exitosa'
            });

        } catch (error) {
            console.log(error);
            res.status(500).send(error.message);
        }
    };
    static async getDatosDepreciacionById(req, res) {
        try {
            const id = req.params.id;//id =idAmbiente
            // console.log(id);
            let data_depreciacion = await pool.query("SELECT * FROM activos ac INNER JOIN tiposactivos tip  ON tip.idTipo=ac.idTipo WHERE ac.idActivo = $1 ", [id]);
            data_depreciacion = data_depreciacion.rows;
            if (data_depreciacion) {
                let detalle_depreciacion = await pool.query("SELECT * FROM activos ac INNER JOIN depreciaciones dep ON dep.idActivo =ac.idActivo WHERE dep.idActivo =$1", [id])
                detalle_depreciacion = detalle_depreciacion.rows;
                if (detalle_depreciacion) {
                    res.status(200).send({
                        activofijo: data_depreciacion,
                        depreciacion: detalle_depreciacion,
                    });
                } else {
                    res.status(404).send({ message: "No hay depreciaciones del activo fijo" });
                }
            } else {
                res.status(404).send({ message: "No hay ningun registro" });
            }
        } catch (error) {
            res.status(500).send(error.message);
        }

    };
    static async getDepreciaciones(req, res) {
        try {
            const nombre = req.params['nombre'];
            // console.log(nombre);
            let Valor = await pool.query(`SELECT valor FROM valordepreciacion valDep ORDER BY	valDep.Valor DESC LIMIT 1`);
            Valor = Valor.rows;
            // console.log(Valor[0].valor);
            if (nombre === undefined) {
                const query = `SELECT * FROM activos ac INNER JOIN tiposactivos tip ON ac.idTipo = tip.idTipo WHERE ac.ufvInicial > 0 AND ac.ValorRegistro >= ${Valor[0].valor}`

                const activo_list = await pool.query(query);
                //console.log(activo_list.rows);
                if (activo_list.rows.length) {
                    res.status(200).send({ activos: activo_list.rows });
                } else {
                    res.status(403).send({ message: 'No hay ningun registro con el codigo o nombre del tipo de activo fijo' });
                }
            } else {
                await connection.query(`SELECT * FROM activos ac INNER JOIN tiposactivos tip ON ac.idTipo=tip.idTipo WHERE ac.ufvInicial > 0 AND ac.ValorRegistro >=${Valor[0].valor} AND (ac.idActivo REGEXP LOWER('${nombre}') OR tip.NombreActivo REGEXP LOWER('${nombre}'))`, (err, activo_list) => {
                    if (activo_list.length) {
                        res.status(200).send({ activos: activo_list });
                    } else {
                        res.status(403).send({ message: 'No hay ningun registro con el codigo o nombre del tipo de activo fijo' });
                    }
                });

            }
        } catch (error) {
            console.log(error);
            res.status(500).send(error.message);
        }
    };
    static async getActivosDepreciacionCodigo(req, res) {
        try {
            const nombre = req.params['nombre'];
            // console.log(nombre);
            let Valor = await pool.query(`SELECT valor FROM valordepreciacion valDep ORDER BY	valDep.Valor DESC LIMIT 1`);
            Valor = Valor.rows;
            // console.log(Valor[0].valor);
            if (nombre === undefined) {
                const query = `SELECT * FROM activos ac INNER JOIN tiposactivos tip ON ac.idTipo = tip.idTipo WHERE ac.ufvInicial > 0 AND ac.ValorRegistro >= ${Valor[0].valor}`

                const activo_list = await pool.query(query);
                //console.log(activo_list.rows);
                if (activo_list.rows.length) {
                    res.status(200).send({ activos: activo_list.rows });
                } else {
                    res.status(403).send({ message: 'No hay ningun registro con el codigo o nombre del tipo de activo fijo' });
                }
            } else {
                await connection.query(`SELECT * FROM activos ac INNER JOIN tiposactivos tip ON ac.idTipo=tip.idTipo WHERE ac.ufvInicial > 0 AND ac.ValorRegistro >=${Valor[0].valor} AND (ac.idActivo REGEXP LOWER('${nombre}') OR tip.NombreActivo REGEXP LOWER('${nombre}'))`, (err, activo_list) => {
                    if (activo_list.length) {
                        res.status(200).send({ activos: activo_list });
                    } else {
                        res.status(403).send({ message: 'No hay ningun registro con el codigo o nombre del tipo de activo fijo' });
                    }
                });

            }
        } catch (error) {
            console.log(error);
            res.status(500).send(error.message);
        }
    };
    static async postValorDepreciacion(req, res) {
        try {
            const valor = req.body.Valor;

            const result = await pool.query("INSERT INTO valordepreciacion (valor) values ($1) RETURNING *", [valor]);
            res.status(200).send({ valor: result.rows });
        } catch (error) {
            console.log(error.message);
            res.status(500).send(error.message);
        }
    };
    static async getValorDepreciacion(req, res) {
        try {
            const query = 'SELECT * FROM valordepreciacion order by valor desc';
            const result = await pool.query(query)
            if (result.rows.length > 0) {
                res.status(200).send({ valor: result.rows });
            } else {
                res.status(404).send({ message: "No hay valores para depreciar." });
            }
        } catch (error) {
            console.log(error.message);
            res.status(500).send(error.message);
        }
    };
    static async deleteValorDepreciacion(req, res) {
        try {
            const id = req.params.id;
            const query = 'DELETE FROM  valordepreciacion WHERE id= $1 RETURNING *';
            const values = [id]
            const result = await pool.query(query, values);
            res.status(200).send({ valor: result });

        } catch (error) {
            console.log(error.message);
            res.status(500).send(error.message);
        }
    };

}

module.exports = controllerDepreciacion;