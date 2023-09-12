const router=require("express").Router();

const controllerBackups  = require('../../controllers/backup/backup.controller');

router.use('/backup',controllerBackups.backups);

module.exports  = router