var jwt = require('jwt-simple');
var moment =  require('moment');

var secret = 'llavesecreta';

exports.createToken = function(user){
    var payload = {
        idUsuario: 'user.idUsuario',
        Nombres: 'user.Nombres',
        Apellidos: 'user.Apellidos',
        Email: 'user.Email',
        Rol: 'user.Rol',
        Estado: 'user.Estado',
        iat: moment().unix(),//fecha de creacion del token
        exp: moment().add(30, 'days').unix(), //expiracion del token
    }
     return jwt.encode(payload, secret);
}