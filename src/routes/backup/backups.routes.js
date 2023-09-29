const router=require("express").Router();

const controllerBackups  = require('../../controllers/backup/backup.controller');

router.use('/',controllerBackups.backups);

module.exports  = router