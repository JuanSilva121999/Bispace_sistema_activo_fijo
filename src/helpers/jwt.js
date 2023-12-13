var jwt = require('jwt-simple');
var moment =  require('moment');

var secret = 'llavesecreta';

exports.createToken = function(user){
    var payload = {
        idUsuario: 'user.idUsuario',
        Nombres: 'user.Nombres',
        Apellidos: 'user.Apellidos',
        Email: 'user.Email',
        Unidad : 'user.nombreamb',
        Rol: 'user.Rol',
        Estado: 'user.Estado',
        CI: 'user.ci',
        iat: moment().unix(),//fecha de creacion del token
        exp: moment().add(1, 'minute').unix(),

    }
     return jwt.encode(payload, secret);
}