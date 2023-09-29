const { Pool } = require('pg');
const { createWriteStream } = require('fs');
const path = require('path');
//const { QueryTypes, col } = require("sequelize");
class backup {
    static async backups(req, res) {
        const { urlLocal } = req.body;

        try {
            const date = new Date();
            const output = date.toISOString().split('T')[0];
            const backupFilePath = path.join(__dirname, '../../backups', `${output}BackupActivosFijos.sql`);

            const pool = new Pool({
                user: process.env.DB_USER,
                host: process.env.DB_HOST,
                database: process.env.DB_NAME,
                password: process.env.DB_PASSWORD,
                port: process.env.DB_PORT,
            });


            const client = await pool.connect();
            const dumpStream = createWriteStream(backupFilePath);

            // Ejecutar la copia de seguridad y guardarla en el archivo de respaldo

            const { exec } = require('child_process');
            console.log('DB_PASSWORD:', process.env.DB_PASSWORD);
            const data = `pg_dump --dbname=postgresql://${process.env.DB_USER}:${process.env.DB_PASSWORD}@${process.env.DB_HOST}:${process.env.DB_PORT}/${process.env.DB_NAME} --file=${backupFilePath}`
            console.log(data);
            //const pgDumpCommand = `pg_dump --host=${process.env.DB_HOST} --port=${process.env.DB_PORT} --username=${process.env.DB_USER} --dbname=${process.env.DB_NAME} --file=${backupFilePath} --password='${process.env.DB_PASSWORD}'`;


            exec(data, (error, stdout, stderr) => {
                if (error) {
                    console.error(`Error al ejecutar pg_dump: ${error.message}`);
                    res.status(500).json({ message: 'Algo salió mal' });
                }
                if (stderr) {
                    console.error(`Error en stderr de pg_dump: ${stderr}`);
                    res.status(500).json({ message: 'Algo salió mal' });
                }
                const options = {
                    root: path.join(__dirname, '../../backups'),
                };
                res.status(200).sendFile(`${output}BackupActivosFijos.sql`, options);
            });
            //console.log(dumpProcess);
            //dumpProcess.stdout.pipe(dumpStream);

            /*dumpProcess.on('exit', async (code) => {
                dumpStream.end();
                client.release();

                if (code === 0) {
                    const options = {
                        root: path.join(__dirname, '../../backups'),
                    };
                    res.status(200).sendFile(`${output}BackupActivosFijos.sql`, options);
                } else {
                    res.status(500).json({ message: 'Algo salió mal' });
                }
            });*/
        } catch (error) {
            console.log(error);
            res.status(500).send(error.message);
        }
    }
}
module.exports = backup;