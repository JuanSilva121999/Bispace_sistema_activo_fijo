-- Creación de tabla activos
CREATE TABLE IF NOT EXISTS activos (
  idActivo SERIAL PRIMARY KEY,
  idTipo INT NOT NULL,
  Imagen VARCHAR(200) NOT NULL,
  Procedencia VARCHAR(50) NOT NULL,
  Descripcion TEXT,
  FechaRegistro TIMESTAMP NOT NULL,
  ValorRegistro NUMERIC(11, 2),
  ValorActual NUMERIC(11, 2),
  VidaUtilActual INT DEFAULT 0,
  Observaciones TEXT,
  UfvInicial NUMERIC(11, 6) DEFAULT 0.000000,
  Estado VARCHAR(50) DEFAULT 'Activo',
  Anio INT DEFAULT 0,
  Mes INT DEFAULT 0,
  idCondicion INT,
  idRubro INT,
  idProveedor INT,
  FOREIGN KEY (idCondicion) REFERENCES condiciones (idCondicion),
  FOREIGN KEY (idRubro) REFERENCES rubros (idRubro),
  FOREIGN KEY (idProveedor) REFERENCES proveedores (idProveedor)
);

-- Creación de tabla altaactivos
CREATE TABLE IF NOT EXISTS altaactivos (
  idAlta SERIAL PRIMARY KEY,
  Codificacion VARCHAR(150),
  FechaHora TIMESTAMP NOT NULL,
  Qr TEXT,
  idActiv INT NOT NULL,
  idEmpleado INT,
  idProyecto INT,
  idAmbiente INT,
  FOREIGN KEY (idActiv) REFERENCES activos (idActivo),
  FOREIGN KEY (idAmbiente) REFERENCES ambientes (idAmbiente),
  FOREIGN KEY (idEmpleado) REFERENCES empleados (idEmpleado),
  FOREIGN KEY (idProyecto) REFERENCES proyectos (idProyecto)
);

-- Creación de tabla ambientes
CREATE TABLE IF NOT EXISTS ambientes (
  idAmbiente SERIAL PRIMARY KEY,
  NombreAmb VARCHAR(150) NOT NULL,
  DescripcionAmb TEXT,
  idEdificio INT NOT NULL,
  FOREIGN KEY (idEdificio) REFERENCES edificios (idEdificio)
);

-- Creación de tabla bajas
CREATE TABLE IF NOT EXISTS bajas (
  idBaja SERIAL PRIMARY KEY,
  FechaBaja TIMESTAMP NOT NULL ,
  Motivo VARCHAR(400),
  idActi INT NOT NULL,
  FOREIGN KEY (idActi) REFERENCES activos (idActivo)
);

-- Creación de tabla condiciones
CREATE TABLE IF NOT EXISTS condiciones (
  idCondicion SERIAL PRIMARY KEY,
  Nombre VARCHAR(50)
);

-- Creación de tabla depreciaciones
CREATE TABLE IF NOT EXISTS depreciaciones (
  idDepreciacion SERIAL PRIMARY KEY,
  UfvActual NUMERIC(11, 6),
  UfvInicial NUMERIC(11, 6),
  Fecha TIMESTAMP NOT NULL,
  ValorContabilizado NUMERIC(11, 2),
  FactorActual NUMERIC(11, 6),
  ValorActualizado NUMERIC(11, 2),
  IncrementoActual NUMERIC(11, 2),
  DepreciacionAcuAnt NUMERIC(11, 2),
  IncrementoDepAcu NUMERIC(11, 2),
  DepreciacionPeriodo NUMERIC(11, 2),
  DepreciacionAcuAct NUMERIC(11, 2),
  ValorNeto NUMERIC(11, 2),
  PorcentajeDep NUMERIC(11, 2),
  VidaUtilActual INT,
  VidaUtilMes INT,
  idActivo INT NOT NULL,
  FOREIGN KEY (idActivo) REFERENCES activos (idActivo)
);

-- Creación de tabla devoluciones
CREATE TABLE IF NOT EXISTS devoluciones (
  idDevolucion SERIAL PRIMARY KEY,
  CodActivo INT,
  CodEmpleado INT,
  idCondici INT,
  Motivo VARCHAR(200),
  FechaDevolucion TIMESTAMP NOT NULL,
  Proyecto TEXT,
  Observaciones TEXT,
  FOREIGN KEY (idCondici) REFERENCES condiciones (idCondicion)
);

-- Creación de tabla edificios
CREATE TABLE IF NOT EXISTS edificios (
  idEdificio SERIAL PRIMARY KEY,
  NombreEdi VARCHAR(300),
  Servicio TEXT,
  Direccion VARCHAR(100),
  idUbicacion INT NOT NULL,
  FOREIGN KEY (idUbicacion) REFERENCES ubicaciones (idUbicacion)
);

-- Creación de tabla empleados
CREATE TABLE IF NOT EXISTS empleados (
  idEmpleado SERIAL PRIMARY KEY,
  Nombres VARCHAR(50) NOT NULL,
  Apellidos VARCHAR(100) NOT NULL,
  Cargo VARCHAR(100) NOT NULL,
  Telefono VARCHAR(15) NOT NULL,
  Direccion VARCHAR(200),
  idAmbient INT NOT NULL,
  FOREIGN KEY (idAmbient) REFERENCES ambientes (idAmbiente)
);

-- Creación de tabla mantenimiento
CREATE TABLE IF NOT EXISTS mantenimiento (
  idMant SERIAL PRIMARY KEY,
  FechaMant DATE NOT NULL,
  Informe VARCHAR(400),
  Costo NUMERIC(11, 2),
  Estado VARCHAR(50),
  idAct INT NOT NULL,
  FOREIGN KEY (idAct) REFERENCES activos (idActivo)
);

-- Creación de tabla programas
CREATE TABLE IF NOT EXISTS programas (
  idPrograma SERIAL PRIMARY KEY,
  NombreProg VARCHAR(150) NOT NULL
);

-- Creación de tabla proveedores
CREATE TABLE IF NOT EXISTS proveedores (
  idProveedor SERIAL PRIMARY KEY,
  NombreProv VARCHAR(70),
  DireccionProv VARCHAR(200),
  TelefonoProv VARCHAR(15)
);

-- Creación de tabla proyectos
CREATE TABLE IF NOT EXISTS proyectos (
  idProyecto SERIAL PRIMARY KEY,
  NombrePro TEXT,
  FechaInicio DATE,
  FechaFin DATE,
  idPrograma INT,
  FOREIGN KEY (idPrograma) REFERENCES programas (idPrograma)
);

-- Creación de tabla revalorizaciones
CREATE TABLE IF NOT EXISTS revalorizaciones (
  idRevalorizacion SERIAL PRIMARY KEY,
  CodActivo INT NOT NULL,
  FechaRev TIMESTAMP NOT NULL,
  ValorNuevo NUMERIC(11, 2),
  VidaUtilRev INT,
  DescripcionRev TEXT,
  FOREIGN KEY (CodActivo) REFERENCES activos (idActivo)
);

-- Creación de tabla rubros
CREATE TABLE IF NOT EXISTS rubros (
  idRubro SERIAL PRIMARY KEY,
  Nombre VARCHAR(50),
  VidaUtil INT,
  Depreciable BOOLEAN,
  CoeficienteD FLOAT,
  Actualiza BOOLEAN
);

-- Creación de tabla tiposactivos
CREATE TABLE IF NOT EXISTS tiposactivos (
  idTipo SERIAL PRIMARY KEY,
  NombreActivo VARCHAR(80),
  DescripcionMant TEXT
);

-- Creación de tabla ubicaciones
CREATE TABLE IF NOT EXISTS ubicaciones (
  idUbicacion SERIAL PRIMARY KEY,
  NombreLugar VARCHAR(150) NOT NULL
);

-- Creación de tabla usuarios
CREATE TABLE IF NOT EXISTS usuarios (
  idUsuario SERIAL PRIMARY KEY,
  idEmplead INT,
  Email VARCHAR(100),
  Password VARCHAR(70),
  Rol VARCHAR(50),
  Estado VARCHAR(50),
  FOREIGN KEY (idEmplead) REFERENCES empleados (idEmpleado)
);

