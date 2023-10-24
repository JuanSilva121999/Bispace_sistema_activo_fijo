--
-- PostgreSQL database dump
--

-- Dumped from database version 15.2
-- Dumped by pg_dump version 15.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: activo_fijo; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA activo_fijo;


ALTER SCHEMA activo_fijo OWNER TO postgres;

--
-- Name: pa_altaactivosfijos(character varying, character varying, character varying, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.pa_altaactivosfijos(IN cod_empleado character varying, IN cod_activo character varying, IN cod_ambiente character varying, IN cod_proyecto character varying)
    LANGUAGE plpgsql
    AS $$
declare 
BEGIN
   UPDATE public.activos SET estado = 'En Uso' WHERE idactivo = cast(cod_activo as integer);
  	INSERT INTO historialactivofijo (codactivo, codambiente,codempleado, codproyecto, estado)
	VALUES (cast(cod_activo as integer),cast (cod_ambiente as integer),cast(cod_empleado as integer), cast (cod_proyecto as integer), 'En Uso');

   INSERT INTO public.altaactivos
	(codificacion,  idactiv, idempleado, idproyecto, idambiente)
	VALUES('Valor', cast (cod_activo as integer ), cast (cod_empleado as integer), cast (cod_proyecto as integer), cast(cod_ambiente as integer));
END;
$$;


ALTER PROCEDURE public.pa_altaactivosfijos(IN cod_empleado character varying, IN cod_activo character varying, IN cod_ambiente character varying, IN cod_proyecto character varying) OWNER TO postgres;

--
-- Name: pa_bajaactivosfijos(integer, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.pa_bajaactivosfijos(IN cod_activo integer, IN asunto character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
   UPDATE public.activos SET estado = 'Inactivo' WHERE idactivo = cod_activo;
  
   INSERT INTO public.bajas (motivo, idacti) VALUES (asunto, cod_activo) ;
END;
$$;


ALTER PROCEDURE public.pa_bajaactivosfijos(IN cod_activo integer, IN asunto character varying) OWNER TO postgres;

--
-- Name: pa_bajaactivosfijos(character varying, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.pa_bajaactivosfijos(IN cod_activo character varying, IN asunto character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
   UPDATE public.activos SET estado = 'Baja' WHERE idactivo = cast(cod_activo as integer);
  
   INSERT INTO public.bajas (motivo, idacti) VALUES (asunto, cast (cod_activo as integer)) ;
END;
$$;


ALTER PROCEDURE public.pa_bajaactivosfijos(IN cod_activo character varying, IN asunto character varying) OWNER TO postgres;

--
-- Name: pa_depreciacionactivosfijos(integer, numeric, numeric, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.pa_depreciacionactivosfijos(codactivo integer, ufvact numeric, ufvinicial numeric, fechadepreciacion date) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    factoractual numeric;
    valoractualizado numeric;
    incrementoactual numeric;
    depreciacionacuant numeric;
    incrementodepacu numeric;
    depreciacionperiodo numeric;
    depreciacionacuact numeric;
    valorneto numeric;
    porcentajedep numeric;
   valorcontabilizado numeric;
BEGIN
    select a.valorregistro into valorcontabilizado
	from public.activos a 
	where a.idactivo = codactivo;
    factoractual := ufvact / ufvinicial;
    valoractualizado := valorcontabilizado * factoractual;
    incrementoactual := valoractualizado - valorcontabilizado;
   
   
   


    -- Insertar en la tabla depreciaciones
    INSERT INTO public.depreciaciones
    (ufvactual, ufvinicial, fecha, valorcontabilizado, factoractual, valoractualizado, incrementoactual, depreciacionacuant, incrementodepacu, depreciacionperiodo, depreciacionacuact, valorneto, porcentajedep, vidautilactual, vidautilmes, idactivo)
    VALUES
    (ufvact, ufvinicial, fechadepreciacion, valorcontabilizado, factoractual, valoractualizado, incrementoactual, depreciacionacuant, incrementodepacu, depreciacionperiodo, depreciacionacuact, valorneto, porcentajedep, vidautilactual, vidautilmes, codactivo);

    RETURN;
END;
$$;


ALTER FUNCTION public.pa_depreciacionactivosfijos(codactivo integer, ufvact numeric, ufvinicial numeric, fechadepreciacion date) OWNER TO postgres;

--
-- Name: pa_mantenimientoactivosfijos(date, character varying, numeric, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.pa_mantenimientoactivosfijos(IN fechamant date, IN informe character varying, IN costo numeric, IN cod_activo character varying)
    LANGUAGE plpgsql
    AS $$
declare 
BEGIN
   UPDATE public.activos SET estado = 'Mantenimiento' WHERE idactivo = cast(cod_activo as integer);
  
  
  INSERT INTO public.mantenimiento
(fechamant, informe, costo, estado, idact)
VALUES(fechamant , informe , costo , 'Activo', cast (cod_activo as integer));
END;
$$;


ALTER PROCEDURE public.pa_mantenimientoactivosfijos(IN fechamant date, IN informe character varying, IN costo numeric, IN cod_activo character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: activos; Type: TABLE; Schema: activo_fijo; Owner: postgres
--

CREATE TABLE activo_fijo.activos (
    idactivo integer NOT NULL,
    idtipo integer NOT NULL,
    imagen character varying(200) NOT NULL,
    procedencia character varying(50) NOT NULL,
    descripcion text,
    fecharegistro timestamp without time zone NOT NULL,
    valorregistro numeric(11,2),
    valoractual numeric(11,2),
    vidautilactual integer DEFAULT 0,
    observaciones text,
    ufvinicial numeric(11,6) DEFAULT 0.000000,
    estado character varying(50) DEFAULT 'Activo'::character varying,
    anio integer DEFAULT 0,
    mes integer DEFAULT 0,
    idcondicion integer,
    idrubro integer,
    idproveedor integer
);


ALTER TABLE activo_fijo.activos OWNER TO postgres;

--
-- Name: activos_idactivo_seq; Type: SEQUENCE; Schema: activo_fijo; Owner: postgres
--

CREATE SEQUENCE activo_fijo.activos_idactivo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE activo_fijo.activos_idactivo_seq OWNER TO postgres;

--
-- Name: activos_idactivo_seq; Type: SEQUENCE OWNED BY; Schema: activo_fijo; Owner: postgres
--

ALTER SEQUENCE activo_fijo.activos_idactivo_seq OWNED BY activo_fijo.activos.idactivo;


--
-- Name: altaactivos; Type: TABLE; Schema: activo_fijo; Owner: postgres
--

CREATE TABLE activo_fijo.altaactivos (
    idalta integer NOT NULL,
    codificacion character varying(150),
    fechahora timestamp without time zone NOT NULL,
    qr text,
    idactiv integer NOT NULL,
    idempleado integer,
    idproyecto integer,
    idambiente integer
);


ALTER TABLE activo_fijo.altaactivos OWNER TO postgres;

--
-- Name: altaactivos_idalta_seq; Type: SEQUENCE; Schema: activo_fijo; Owner: postgres
--

CREATE SEQUENCE activo_fijo.altaactivos_idalta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE activo_fijo.altaactivos_idalta_seq OWNER TO postgres;

--
-- Name: altaactivos_idalta_seq; Type: SEQUENCE OWNED BY; Schema: activo_fijo; Owner: postgres
--

ALTER SEQUENCE activo_fijo.altaactivos_idalta_seq OWNED BY activo_fijo.altaactivos.idalta;


--
-- Name: ambientes; Type: TABLE; Schema: activo_fijo; Owner: postgres
--

CREATE TABLE activo_fijo.ambientes (
    idambiente integer NOT NULL,
    nombreamb character varying(150) NOT NULL,
    descripcionamb text,
    idedificio integer NOT NULL
);


ALTER TABLE activo_fijo.ambientes OWNER TO postgres;

--
-- Name: ambientes_idambiente_seq; Type: SEQUENCE; Schema: activo_fijo; Owner: postgres
--

CREATE SEQUENCE activo_fijo.ambientes_idambiente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE activo_fijo.ambientes_idambiente_seq OWNER TO postgres;

--
-- Name: ambientes_idambiente_seq; Type: SEQUENCE OWNED BY; Schema: activo_fijo; Owner: postgres
--

ALTER SEQUENCE activo_fijo.ambientes_idambiente_seq OWNED BY activo_fijo.ambientes.idambiente;


--
-- Name: bajas; Type: TABLE; Schema: activo_fijo; Owner: postgres
--

CREATE TABLE activo_fijo.bajas (
    idbaja integer NOT NULL,
    fechabaja timestamp without time zone NOT NULL,
    motivo character varying(400),
    idacti integer NOT NULL
);


ALTER TABLE activo_fijo.bajas OWNER TO postgres;

--
-- Name: bajas_idbaja_seq; Type: SEQUENCE; Schema: activo_fijo; Owner: postgres
--

CREATE SEQUENCE activo_fijo.bajas_idbaja_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE activo_fijo.bajas_idbaja_seq OWNER TO postgres;

--
-- Name: bajas_idbaja_seq; Type: SEQUENCE OWNED BY; Schema: activo_fijo; Owner: postgres
--

ALTER SEQUENCE activo_fijo.bajas_idbaja_seq OWNED BY activo_fijo.bajas.idbaja;


--
-- Name: condiciones; Type: TABLE; Schema: activo_fijo; Owner: postgres
--

CREATE TABLE activo_fijo.condiciones (
    idcondicion integer NOT NULL,
    nombre character varying(50)
);


ALTER TABLE activo_fijo.condiciones OWNER TO postgres;

--
-- Name: condiciones_idcondicion_seq; Type: SEQUENCE; Schema: activo_fijo; Owner: postgres
--

CREATE SEQUENCE activo_fijo.condiciones_idcondicion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE activo_fijo.condiciones_idcondicion_seq OWNER TO postgres;

--
-- Name: condiciones_idcondicion_seq; Type: SEQUENCE OWNED BY; Schema: activo_fijo; Owner: postgres
--

ALTER SEQUENCE activo_fijo.condiciones_idcondicion_seq OWNED BY activo_fijo.condiciones.idcondicion;


--
-- Name: depreciaciones; Type: TABLE; Schema: activo_fijo; Owner: postgres
--

CREATE TABLE activo_fijo.depreciaciones (
    iddepreciacion integer NOT NULL,
    ufvactual numeric(11,6),
    ufvinicial numeric(11,6),
    fecha timestamp without time zone NOT NULL,
    valorcontabilizado numeric(11,2),
    factoractual numeric(11,6),
    valoractualizado numeric(11,2),
    incrementoactual numeric(11,2),
    depreciacionacuant numeric(11,2),
    incrementodepacu numeric(11,2),
    depreciacionperiodo numeric(11,2),
    depreciacionacuact numeric(11,2),
    valorneto numeric(11,2),
    porcentajedep numeric(11,2),
    vidautilactual integer,
    vidautilmes integer,
    idactivo integer NOT NULL
);


ALTER TABLE activo_fijo.depreciaciones OWNER TO postgres;

--
-- Name: depreciaciones_iddepreciacion_seq; Type: SEQUENCE; Schema: activo_fijo; Owner: postgres
--

CREATE SEQUENCE activo_fijo.depreciaciones_iddepreciacion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE activo_fijo.depreciaciones_iddepreciacion_seq OWNER TO postgres;

--
-- Name: depreciaciones_iddepreciacion_seq; Type: SEQUENCE OWNED BY; Schema: activo_fijo; Owner: postgres
--

ALTER SEQUENCE activo_fijo.depreciaciones_iddepreciacion_seq OWNED BY activo_fijo.depreciaciones.iddepreciacion;


--
-- Name: devoluciones; Type: TABLE; Schema: activo_fijo; Owner: postgres
--

CREATE TABLE activo_fijo.devoluciones (
    iddevolucion integer NOT NULL,
    codactivo integer,
    codempleado integer,
    idcondici integer,
    motivo character varying(200),
    fechadevolucion timestamp without time zone NOT NULL,
    proyecto text,
    observaciones text
);


ALTER TABLE activo_fijo.devoluciones OWNER TO postgres;

--
-- Name: devoluciones_iddevolucion_seq; Type: SEQUENCE; Schema: activo_fijo; Owner: postgres
--

CREATE SEQUENCE activo_fijo.devoluciones_iddevolucion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE activo_fijo.devoluciones_iddevolucion_seq OWNER TO postgres;

--
-- Name: devoluciones_iddevolucion_seq; Type: SEQUENCE OWNED BY; Schema: activo_fijo; Owner: postgres
--

ALTER SEQUENCE activo_fijo.devoluciones_iddevolucion_seq OWNED BY activo_fijo.devoluciones.iddevolucion;


--
-- Name: edificios; Type: TABLE; Schema: activo_fijo; Owner: postgres
--

CREATE TABLE activo_fijo.edificios (
    idedificio integer NOT NULL,
    nombreedi character varying(300),
    servicio text,
    direccion character varying(100),
    idubicacion integer NOT NULL
);


ALTER TABLE activo_fijo.edificios OWNER TO postgres;

--
-- Name: edificios_idedificio_seq; Type: SEQUENCE; Schema: activo_fijo; Owner: postgres
--

CREATE SEQUENCE activo_fijo.edificios_idedificio_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE activo_fijo.edificios_idedificio_seq OWNER TO postgres;

--
-- Name: edificios_idedificio_seq; Type: SEQUENCE OWNED BY; Schema: activo_fijo; Owner: postgres
--

ALTER SEQUENCE activo_fijo.edificios_idedificio_seq OWNED BY activo_fijo.edificios.idedificio;


--
-- Name: empleados; Type: TABLE; Schema: activo_fijo; Owner: postgres
--

CREATE TABLE activo_fijo.empleados (
    idempleado integer NOT NULL,
    nombres character varying(50) NOT NULL,
    apellidos character varying(100) NOT NULL,
    cargo character varying(100) NOT NULL,
    telefono character varying(15) NOT NULL,
    direccion character varying(200),
    idambient integer NOT NULL
);


ALTER TABLE activo_fijo.empleados OWNER TO postgres;

--
-- Name: empleados_idempleado_seq; Type: SEQUENCE; Schema: activo_fijo; Owner: postgres
--

CREATE SEQUENCE activo_fijo.empleados_idempleado_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE activo_fijo.empleados_idempleado_seq OWNER TO postgres;

--
-- Name: empleados_idempleado_seq; Type: SEQUENCE OWNED BY; Schema: activo_fijo; Owner: postgres
--

ALTER SEQUENCE activo_fijo.empleados_idempleado_seq OWNED BY activo_fijo.empleados.idempleado;


--
-- Name: mantenimiento; Type: TABLE; Schema: activo_fijo; Owner: postgres
--

CREATE TABLE activo_fijo.mantenimiento (
    idmant integer NOT NULL,
    fechamant date NOT NULL,
    informe character varying(400),
    costo numeric(11,2),
    estado character varying(50),
    idact integer NOT NULL
);


ALTER TABLE activo_fijo.mantenimiento OWNER TO postgres;

--
-- Name: mantenimiento_idmant_seq; Type: SEQUENCE; Schema: activo_fijo; Owner: postgres
--

CREATE SEQUENCE activo_fijo.mantenimiento_idmant_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE activo_fijo.mantenimiento_idmant_seq OWNER TO postgres;

--
-- Name: mantenimiento_idmant_seq; Type: SEQUENCE OWNED BY; Schema: activo_fijo; Owner: postgres
--

ALTER SEQUENCE activo_fijo.mantenimiento_idmant_seq OWNED BY activo_fijo.mantenimiento.idmant;


--
-- Name: programas; Type: TABLE; Schema: activo_fijo; Owner: postgres
--

CREATE TABLE activo_fijo.programas (
    idprograma integer NOT NULL,
    nombreprog character varying(150) NOT NULL
);


ALTER TABLE activo_fijo.programas OWNER TO postgres;

--
-- Name: programas_idprograma_seq; Type: SEQUENCE; Schema: activo_fijo; Owner: postgres
--

CREATE SEQUENCE activo_fijo.programas_idprograma_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE activo_fijo.programas_idprograma_seq OWNER TO postgres;

--
-- Name: programas_idprograma_seq; Type: SEQUENCE OWNED BY; Schema: activo_fijo; Owner: postgres
--

ALTER SEQUENCE activo_fijo.programas_idprograma_seq OWNED BY activo_fijo.programas.idprograma;


--
-- Name: proveedores; Type: TABLE; Schema: activo_fijo; Owner: postgres
--

CREATE TABLE activo_fijo.proveedores (
    idproveedor integer NOT NULL,
    nombreprov character varying(70),
    direccionprov character varying(200),
    telefonoprov character varying(15)
);


ALTER TABLE activo_fijo.proveedores OWNER TO postgres;

--
-- Name: proveedores_idproveedor_seq; Type: SEQUENCE; Schema: activo_fijo; Owner: postgres
--

CREATE SEQUENCE activo_fijo.proveedores_idproveedor_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE activo_fijo.proveedores_idproveedor_seq OWNER TO postgres;

--
-- Name: proveedores_idproveedor_seq; Type: SEQUENCE OWNED BY; Schema: activo_fijo; Owner: postgres
--

ALTER SEQUENCE activo_fijo.proveedores_idproveedor_seq OWNED BY activo_fijo.proveedores.idproveedor;


--
-- Name: proyectos; Type: TABLE; Schema: activo_fijo; Owner: postgres
--

CREATE TABLE activo_fijo.proyectos (
    idproyecto integer NOT NULL,
    nombrepro text,
    fechainicio date,
    fechafin date,
    idprograma integer
);


ALTER TABLE activo_fijo.proyectos OWNER TO postgres;

--
-- Name: proyectos_idproyecto_seq; Type: SEQUENCE; Schema: activo_fijo; Owner: postgres
--

CREATE SEQUENCE activo_fijo.proyectos_idproyecto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE activo_fijo.proyectos_idproyecto_seq OWNER TO postgres;

--
-- Name: proyectos_idproyecto_seq; Type: SEQUENCE OWNED BY; Schema: activo_fijo; Owner: postgres
--

ALTER SEQUENCE activo_fijo.proyectos_idproyecto_seq OWNED BY activo_fijo.proyectos.idproyecto;


--
-- Name: revalorizaciones; Type: TABLE; Schema: activo_fijo; Owner: postgres
--

CREATE TABLE activo_fijo.revalorizaciones (
    idrevalorizacion integer NOT NULL,
    codactivo integer NOT NULL,
    fecharev timestamp without time zone NOT NULL,
    valornuevo numeric(11,2),
    vidautilrev integer,
    descripcionrev text
);


ALTER TABLE activo_fijo.revalorizaciones OWNER TO postgres;

--
-- Name: revalorizaciones_idrevalorizacion_seq; Type: SEQUENCE; Schema: activo_fijo; Owner: postgres
--

CREATE SEQUENCE activo_fijo.revalorizaciones_idrevalorizacion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE activo_fijo.revalorizaciones_idrevalorizacion_seq OWNER TO postgres;

--
-- Name: revalorizaciones_idrevalorizacion_seq; Type: SEQUENCE OWNED BY; Schema: activo_fijo; Owner: postgres
--

ALTER SEQUENCE activo_fijo.revalorizaciones_idrevalorizacion_seq OWNED BY activo_fijo.revalorizaciones.idrevalorizacion;


--
-- Name: rubros; Type: TABLE; Schema: activo_fijo; Owner: postgres
--

CREATE TABLE activo_fijo.rubros (
    idrubro integer NOT NULL,
    nombre character varying(50),
    vidautil integer,
    depreciable boolean,
    coeficiented double precision,
    actualiza boolean
);


ALTER TABLE activo_fijo.rubros OWNER TO postgres;

--
-- Name: rubros_idrubro_seq; Type: SEQUENCE; Schema: activo_fijo; Owner: postgres
--

CREATE SEQUENCE activo_fijo.rubros_idrubro_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE activo_fijo.rubros_idrubro_seq OWNER TO postgres;

--
-- Name: rubros_idrubro_seq; Type: SEQUENCE OWNED BY; Schema: activo_fijo; Owner: postgres
--

ALTER SEQUENCE activo_fijo.rubros_idrubro_seq OWNED BY activo_fijo.rubros.idrubro;


--
-- Name: tiposactivos; Type: TABLE; Schema: activo_fijo; Owner: postgres
--

CREATE TABLE activo_fijo.tiposactivos (
    idtipo integer NOT NULL,
    nombreactivo character varying(80),
    descripcionmant text
);


ALTER TABLE activo_fijo.tiposactivos OWNER TO postgres;

--
-- Name: tiposactivos_idtipo_seq; Type: SEQUENCE; Schema: activo_fijo; Owner: postgres
--

CREATE SEQUENCE activo_fijo.tiposactivos_idtipo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE activo_fijo.tiposactivos_idtipo_seq OWNER TO postgres;

--
-- Name: tiposactivos_idtipo_seq; Type: SEQUENCE OWNED BY; Schema: activo_fijo; Owner: postgres
--

ALTER SEQUENCE activo_fijo.tiposactivos_idtipo_seq OWNED BY activo_fijo.tiposactivos.idtipo;


--
-- Name: ubicaciones; Type: TABLE; Schema: activo_fijo; Owner: postgres
--

CREATE TABLE activo_fijo.ubicaciones (
    idubicacion integer NOT NULL,
    nombrelugar character varying(150) NOT NULL
);


ALTER TABLE activo_fijo.ubicaciones OWNER TO postgres;

--
-- Name: ubicaciones_idubicacion_seq; Type: SEQUENCE; Schema: activo_fijo; Owner: postgres
--

CREATE SEQUENCE activo_fijo.ubicaciones_idubicacion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE activo_fijo.ubicaciones_idubicacion_seq OWNER TO postgres;

--
-- Name: ubicaciones_idubicacion_seq; Type: SEQUENCE OWNED BY; Schema: activo_fijo; Owner: postgres
--

ALTER SEQUENCE activo_fijo.ubicaciones_idubicacion_seq OWNED BY activo_fijo.ubicaciones.idubicacion;


--
-- Name: usuarios; Type: TABLE; Schema: activo_fijo; Owner: postgres
--

CREATE TABLE activo_fijo.usuarios (
    idusuario integer NOT NULL,
    idemplead integer,
    email character varying(100),
    password character varying(70),
    rol character varying(50),
    estado character varying(50)
);


ALTER TABLE activo_fijo.usuarios OWNER TO postgres;

--
-- Name: usuarios_idusuario_seq; Type: SEQUENCE; Schema: activo_fijo; Owner: postgres
--

CREATE SEQUENCE activo_fijo.usuarios_idusuario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE activo_fijo.usuarios_idusuario_seq OWNER TO postgres;

--
-- Name: usuarios_idusuario_seq; Type: SEQUENCE OWNED BY; Schema: activo_fijo; Owner: postgres
--

ALTER SEQUENCE activo_fijo.usuarios_idusuario_seq OWNED BY activo_fijo.usuarios.idusuario;


--
-- Name: activos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.activos (
    idactivo integer NOT NULL,
    idtipo integer NOT NULL,
    imagen character varying(200) NOT NULL,
    procedencia character varying(50) NOT NULL,
    descripcion text,
    fecharegistro timestamp without time zone DEFAULT now() NOT NULL,
    valorregistro numeric(11,2),
    valoractual numeric(11,2),
    vidautilactual integer DEFAULT 0,
    observaciones text,
    ufvinicial numeric(11,6) DEFAULT 0.000000,
    estado character varying(50) DEFAULT 'Activo'::character varying,
    anio integer DEFAULT 0,
    mes integer DEFAULT 0,
    idcondicion integer,
    idrubro integer,
    idproveedor integer,
    factura character varying,
    garantia character varying
);


ALTER TABLE public.activos OWNER TO postgres;

--
-- Name: activos_idactivo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.activos_idactivo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.activos_idactivo_seq OWNER TO postgres;

--
-- Name: activos_idactivo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.activos_idactivo_seq OWNED BY public.activos.idactivo;


--
-- Name: altaactivos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.altaactivos (
    idalta integer NOT NULL,
    codificacion character varying(150),
    fechahora timestamp without time zone DEFAULT now() NOT NULL,
    qr text,
    idactiv integer NOT NULL,
    idempleado integer,
    idproyecto integer,
    idambiente integer
);


ALTER TABLE public.altaactivos OWNER TO postgres;

--
-- Name: altaactivos_idalta_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.altaactivos_idalta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.altaactivos_idalta_seq OWNER TO postgres;

--
-- Name: altaactivos_idalta_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.altaactivos_idalta_seq OWNED BY public.altaactivos.idalta;


--
-- Name: ambientes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ambientes (
    idambiente integer NOT NULL,
    nombreamb character varying(150) NOT NULL,
    descripcionamb text,
    idedificio integer NOT NULL
);


ALTER TABLE public.ambientes OWNER TO postgres;

--
-- Name: ambientes_idambiente_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ambientes_idambiente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ambientes_idambiente_seq OWNER TO postgres;

--
-- Name: ambientes_idambiente_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ambientes_idambiente_seq OWNED BY public.ambientes.idambiente;


--
-- Name: bajas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bajas (
    idbaja integer NOT NULL,
    fechabaja timestamp without time zone DEFAULT now() NOT NULL,
    motivo character varying(400),
    idacti integer NOT NULL
);


ALTER TABLE public.bajas OWNER TO postgres;

--
-- Name: bajas_idbaja_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bajas_idbaja_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bajas_idbaja_seq OWNER TO postgres;

--
-- Name: bajas_idbaja_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bajas_idbaja_seq OWNED BY public.bajas.idbaja;


--
-- Name: condiciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.condiciones (
    idcondicion integer NOT NULL,
    nombre character varying(50)
);


ALTER TABLE public.condiciones OWNER TO postgres;

--
-- Name: condiciones_idcondicion_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.condiciones_idcondicion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.condiciones_idcondicion_seq OWNER TO postgres;

--
-- Name: condiciones_idcondicion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.condiciones_idcondicion_seq OWNED BY public.condiciones.idcondicion;


--
-- Name: depreciaciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.depreciaciones (
    iddepreciacion integer NOT NULL,
    ufvactual numeric(11,6),
    ufvinicial numeric(11,6),
    fecha timestamp without time zone NOT NULL,
    valorcontabilizado numeric(11,2),
    factoractual numeric(11,6),
    valoractualizado numeric(11,2),
    incrementoactual numeric(11,2),
    depreciacionacuant numeric(11,2),
    incrementodepacu numeric(11,2),
    depreciacionperiodo numeric(11,2),
    depreciacionacuact numeric(11,2),
    valorneto numeric(11,2),
    porcentajedep numeric(11,2),
    vidautilactual integer,
    vidautilmes integer,
    idactivo integer NOT NULL
);


ALTER TABLE public.depreciaciones OWNER TO postgres;

--
-- Name: depreciaciones_iddepreciacion_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.depreciaciones_iddepreciacion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.depreciaciones_iddepreciacion_seq OWNER TO postgres;

--
-- Name: depreciaciones_iddepreciacion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.depreciaciones_iddepreciacion_seq OWNED BY public.depreciaciones.iddepreciacion;


--
-- Name: devoluciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.devoluciones (
    iddevolucion integer NOT NULL,
    codactivo integer,
    codempleado integer,
    idcondici integer,
    motivo character varying(200),
    fechadevolucion timestamp without time zone NOT NULL,
    proyecto text,
    observaciones text
);


ALTER TABLE public.devoluciones OWNER TO postgres;

--
-- Name: devoluciones_iddevolucion_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.devoluciones_iddevolucion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.devoluciones_iddevolucion_seq OWNER TO postgres;

--
-- Name: devoluciones_iddevolucion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.devoluciones_iddevolucion_seq OWNED BY public.devoluciones.iddevolucion;


--
-- Name: edificios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.edificios (
    idedificio integer NOT NULL,
    nombreedi character varying(300),
    servicio text,
    direccion character varying(100),
    idubicacion integer NOT NULL,
    latitud double precision,
    longitud double precision
);


ALTER TABLE public.edificios OWNER TO postgres;

--
-- Name: edificios_idedificio_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.edificios_idedificio_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.edificios_idedificio_seq OWNER TO postgres;

--
-- Name: edificios_idedificio_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.edificios_idedificio_seq OWNED BY public.edificios.idedificio;


--
-- Name: empleados; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.empleados (
    idempleado integer NOT NULL,
    nombres character varying(50) NOT NULL,
    apellidos character varying(100) NOT NULL,
    cargo character varying(100) NOT NULL,
    telefono character varying(15) NOT NULL,
    direccion character varying(200),
    idambient integer NOT NULL
);


ALTER TABLE public.empleados OWNER TO postgres;

--
-- Name: empleados_idempleado_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.empleados_idempleado_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.empleados_idempleado_seq OWNER TO postgres;

--
-- Name: empleados_idempleado_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.empleados_idempleado_seq OWNED BY public.empleados.idempleado;


--
-- Name: historial_asignaciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.historial_asignaciones (
    id integer NOT NULL,
    fecha_asignacion date,
    empleado_id integer,
    equipo_id integer,
    detalle_asignacion integer
);


ALTER TABLE public.historial_asignaciones OWNER TO postgres;

--
-- Name: historial_asignaciones_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.historial_asignaciones_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.historial_asignaciones_id_seq OWNER TO postgres;

--
-- Name: historial_asignaciones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.historial_asignaciones_id_seq OWNED BY public.historial_asignaciones.id;


--
-- Name: historial_devoluciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.historial_devoluciones (
    id integer NOT NULL,
    fecha_devolucion date,
    empleado_id integer,
    equipo_id integer,
    detalle_devolucion text
);


ALTER TABLE public.historial_devoluciones OWNER TO postgres;

--
-- Name: historial_devoluciones_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.historial_devoluciones_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.historial_devoluciones_id_seq OWNER TO postgres;

--
-- Name: historial_devoluciones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.historial_devoluciones_id_seq OWNED BY public.historial_devoluciones.id;


--
-- Name: historial_mantenimiento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.historial_mantenimiento (
    id integer NOT NULL,
    fecha_mantenimiento date,
    equipo_id integer,
    detalle_mantenimiento text
);


ALTER TABLE public.historial_mantenimiento OWNER TO postgres;

--
-- Name: historial_mantenimiento_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.historial_mantenimiento_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.historial_mantenimiento_id_seq OWNER TO postgres;

--
-- Name: historial_mantenimiento_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.historial_mantenimiento_id_seq OWNED BY public.historial_mantenimiento.id;


--
-- Name: historialactivofijo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.historialactivofijo (
    id integer NOT NULL,
    codactivo integer,
    codempleado integer,
    codproyecto integer,
    codambiente integer,
    estado text,
    fecha timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    proyecto text,
    asignado_por text
);


ALTER TABLE public.historialactivofijo OWNER TO postgres;

--
-- Name: historialactivofijo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.historialactivofijo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.historialactivofijo_id_seq OWNER TO postgres;

--
-- Name: historialactivofijo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.historialactivofijo_id_seq OWNED BY public.historialactivofijo.id;


--
-- Name: mantenimiento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mantenimiento (
    idmant integer NOT NULL,
    fechamant date NOT NULL,
    informe character varying(400),
    costo numeric(11,2),
    estado character varying(50),
    idact integer NOT NULL
);


ALTER TABLE public.mantenimiento OWNER TO postgres;

--
-- Name: mantenimiento_idmant_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mantenimiento_idmant_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mantenimiento_idmant_seq OWNER TO postgres;

--
-- Name: mantenimiento_idmant_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mantenimiento_idmant_seq OWNED BY public.mantenimiento.idmant;


--
-- Name: programas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.programas (
    idprograma integer NOT NULL,
    nombreprog character varying(150) NOT NULL
);


ALTER TABLE public.programas OWNER TO postgres;

--
-- Name: programas_idprograma_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.programas_idprograma_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.programas_idprograma_seq OWNER TO postgres;

--
-- Name: programas_idprograma_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.programas_idprograma_seq OWNED BY public.programas.idprograma;


--
-- Name: proveedores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.proveedores (
    idproveedor integer NOT NULL,
    nombreprov character varying(70),
    direccionprov character varying(200),
    telefonoprov character varying(15)
);


ALTER TABLE public.proveedores OWNER TO postgres;

--
-- Name: proveedores_idproveedor_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.proveedores_idproveedor_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.proveedores_idproveedor_seq OWNER TO postgres;

--
-- Name: proveedores_idproveedor_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.proveedores_idproveedor_seq OWNED BY public.proveedores.idproveedor;


--
-- Name: proyectos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.proyectos (
    idproyecto integer NOT NULL,
    nombrepro text,
    fechainicio date,
    fechafin date,
    idprograma integer
);


ALTER TABLE public.proyectos OWNER TO postgres;

--
-- Name: proyectos_idproyecto_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.proyectos_idproyecto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.proyectos_idproyecto_seq OWNER TO postgres;

--
-- Name: proyectos_idproyecto_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.proyectos_idproyecto_seq OWNED BY public.proyectos.idproyecto;


--
-- Name: qr_activo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.qr_activo (
    qr_id integer NOT NULL,
    qr_image character varying,
    qr_fecha_creacion date,
    qr_fecha_emicion date,
    qr_fecha_renovacion date,
    qr_cod_activo character varying,
    qr_id_activo integer,
    qr_estado character varying
);


ALTER TABLE public.qr_activo OWNER TO postgres;

--
-- Name: qr_activo_qr_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.qr_activo_qr_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.qr_activo_qr_id_seq OWNER TO postgres;

--
-- Name: qr_activo_qr_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.qr_activo_qr_id_seq OWNED BY public.qr_activo.qr_id;


--
-- Name: revalorizaciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.revalorizaciones (
    idrevalorizacion integer NOT NULL,
    codactivo integer NOT NULL,
    fecharev timestamp without time zone NOT NULL,
    valornuevo numeric(11,2),
    vidautilrev integer,
    descripcionrev text
);


ALTER TABLE public.revalorizaciones OWNER TO postgres;

--
-- Name: revalorizaciones_idrevalorizacion_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.revalorizaciones_idrevalorizacion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.revalorizaciones_idrevalorizacion_seq OWNER TO postgres;

--
-- Name: revalorizaciones_idrevalorizacion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.revalorizaciones_idrevalorizacion_seq OWNED BY public.revalorizaciones.idrevalorizacion;


--
-- Name: rubros; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rubros (
    idrubro integer NOT NULL,
    nombre character varying(50),
    vidautil integer,
    depreciable boolean,
    coeficiented double precision,
    actualiza boolean,
    cod character varying
);


ALTER TABLE public.rubros OWNER TO postgres;

--
-- Name: rubros_idrubro_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rubros_idrubro_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rubros_idrubro_seq OWNER TO postgres;

--
-- Name: rubros_idrubro_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rubros_idrubro_seq OWNED BY public.rubros.idrubro;


--
-- Name: tiposactivos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tiposactivos (
    idtipo integer NOT NULL,
    nombreactivo character varying(80),
    descripcionmant text
);


ALTER TABLE public.tiposactivos OWNER TO postgres;

--
-- Name: tiposactivos_idtipo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tiposactivos_idtipo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tiposactivos_idtipo_seq OWNER TO postgres;

--
-- Name: tiposactivos_idtipo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tiposactivos_idtipo_seq OWNED BY public.tiposactivos.idtipo;


--
-- Name: ubicaciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ubicaciones (
    idubicacion integer NOT NULL,
    nombrelugar character varying(150) NOT NULL
);


ALTER TABLE public.ubicaciones OWNER TO postgres;

--
-- Name: ubicaciones_idubicacion_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ubicaciones_idubicacion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ubicaciones_idubicacion_seq OWNER TO postgres;

--
-- Name: ubicaciones_idubicacion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ubicaciones_idubicacion_seq OWNED BY public.ubicaciones.idubicacion;


--
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios (
    idusuario integer NOT NULL,
    idemplead integer,
    email character varying(100),
    password character varying(70),
    rol character varying(50),
    estado character varying(50)
);


ALTER TABLE public.usuarios OWNER TO postgres;

--
-- Name: usuarios_idusuario_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuarios_idusuario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usuarios_idusuario_seq OWNER TO postgres;

--
-- Name: usuarios_idusuario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuarios_idusuario_seq OWNED BY public.usuarios.idusuario;


--
-- Name: valordepreciacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.valordepreciacion (
    id integer NOT NULL,
    fecha_actual timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    valor numeric(10,2)
);


ALTER TABLE public.valordepreciacion OWNER TO postgres;

--
-- Name: valordepreciacion_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.valordepreciacion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.valordepreciacion_id_seq OWNER TO postgres;

--
-- Name: valordepreciacion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.valordepreciacion_id_seq OWNED BY public.valordepreciacion.id;


--
-- Name: activos idactivo; Type: DEFAULT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.activos ALTER COLUMN idactivo SET DEFAULT nextval('activo_fijo.activos_idactivo_seq'::regclass);


--
-- Name: altaactivos idalta; Type: DEFAULT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.altaactivos ALTER COLUMN idalta SET DEFAULT nextval('activo_fijo.altaactivos_idalta_seq'::regclass);


--
-- Name: ambientes idambiente; Type: DEFAULT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.ambientes ALTER COLUMN idambiente SET DEFAULT nextval('activo_fijo.ambientes_idambiente_seq'::regclass);


--
-- Name: bajas idbaja; Type: DEFAULT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.bajas ALTER COLUMN idbaja SET DEFAULT nextval('activo_fijo.bajas_idbaja_seq'::regclass);


--
-- Name: condiciones idcondicion; Type: DEFAULT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.condiciones ALTER COLUMN idcondicion SET DEFAULT nextval('activo_fijo.condiciones_idcondicion_seq'::regclass);


--
-- Name: depreciaciones iddepreciacion; Type: DEFAULT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.depreciaciones ALTER COLUMN iddepreciacion SET DEFAULT nextval('activo_fijo.depreciaciones_iddepreciacion_seq'::regclass);


--
-- Name: devoluciones iddevolucion; Type: DEFAULT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.devoluciones ALTER COLUMN iddevolucion SET DEFAULT nextval('activo_fijo.devoluciones_iddevolucion_seq'::regclass);


--
-- Name: edificios idedificio; Type: DEFAULT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.edificios ALTER COLUMN idedificio SET DEFAULT nextval('activo_fijo.edificios_idedificio_seq'::regclass);


--
-- Name: empleados idempleado; Type: DEFAULT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.empleados ALTER COLUMN idempleado SET DEFAULT nextval('activo_fijo.empleados_idempleado_seq'::regclass);


--
-- Name: mantenimiento idmant; Type: DEFAULT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.mantenimiento ALTER COLUMN idmant SET DEFAULT nextval('activo_fijo.mantenimiento_idmant_seq'::regclass);


--
-- Name: programas idprograma; Type: DEFAULT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.programas ALTER COLUMN idprograma SET DEFAULT nextval('activo_fijo.programas_idprograma_seq'::regclass);


--
-- Name: proveedores idproveedor; Type: DEFAULT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.proveedores ALTER COLUMN idproveedor SET DEFAULT nextval('activo_fijo.proveedores_idproveedor_seq'::regclass);


--
-- Name: proyectos idproyecto; Type: DEFAULT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.proyectos ALTER COLUMN idproyecto SET DEFAULT nextval('activo_fijo.proyectos_idproyecto_seq'::regclass);


--
-- Name: revalorizaciones idrevalorizacion; Type: DEFAULT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.revalorizaciones ALTER COLUMN idrevalorizacion SET DEFAULT nextval('activo_fijo.revalorizaciones_idrevalorizacion_seq'::regclass);


--
-- Name: rubros idrubro; Type: DEFAULT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.rubros ALTER COLUMN idrubro SET DEFAULT nextval('activo_fijo.rubros_idrubro_seq'::regclass);


--
-- Name: tiposactivos idtipo; Type: DEFAULT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.tiposactivos ALTER COLUMN idtipo SET DEFAULT nextval('activo_fijo.tiposactivos_idtipo_seq'::regclass);


--
-- Name: ubicaciones idubicacion; Type: DEFAULT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.ubicaciones ALTER COLUMN idubicacion SET DEFAULT nextval('activo_fijo.ubicaciones_idubicacion_seq'::regclass);


--
-- Name: usuarios idusuario; Type: DEFAULT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.usuarios ALTER COLUMN idusuario SET DEFAULT nextval('activo_fijo.usuarios_idusuario_seq'::regclass);


--
-- Name: activos idactivo; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activos ALTER COLUMN idactivo SET DEFAULT nextval('public.activos_idactivo_seq'::regclass);


--
-- Name: altaactivos idalta; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.altaactivos ALTER COLUMN idalta SET DEFAULT nextval('public.altaactivos_idalta_seq'::regclass);


--
-- Name: ambientes idambiente; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ambientes ALTER COLUMN idambiente SET DEFAULT nextval('public.ambientes_idambiente_seq'::regclass);


--
-- Name: bajas idbaja; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bajas ALTER COLUMN idbaja SET DEFAULT nextval('public.bajas_idbaja_seq'::regclass);


--
-- Name: condiciones idcondicion; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.condiciones ALTER COLUMN idcondicion SET DEFAULT nextval('public.condiciones_idcondicion_seq'::regclass);


--
-- Name: depreciaciones iddepreciacion; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.depreciaciones ALTER COLUMN iddepreciacion SET DEFAULT nextval('public.depreciaciones_iddepreciacion_seq'::regclass);


--
-- Name: devoluciones iddevolucion; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.devoluciones ALTER COLUMN iddevolucion SET DEFAULT nextval('public.devoluciones_iddevolucion_seq'::regclass);


--
-- Name: edificios idedificio; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.edificios ALTER COLUMN idedificio SET DEFAULT nextval('public.edificios_idedificio_seq'::regclass);


--
-- Name: empleados idempleado; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empleados ALTER COLUMN idempleado SET DEFAULT nextval('public.empleados_idempleado_seq'::regclass);


--
-- Name: historial_asignaciones id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historial_asignaciones ALTER COLUMN id SET DEFAULT nextval('public.historial_asignaciones_id_seq'::regclass);


--
-- Name: historial_devoluciones id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historial_devoluciones ALTER COLUMN id SET DEFAULT nextval('public.historial_devoluciones_id_seq'::regclass);


--
-- Name: historial_mantenimiento id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historial_mantenimiento ALTER COLUMN id SET DEFAULT nextval('public.historial_mantenimiento_id_seq'::regclass);


--
-- Name: historialactivofijo id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historialactivofijo ALTER COLUMN id SET DEFAULT nextval('public.historialactivofijo_id_seq'::regclass);


--
-- Name: mantenimiento idmant; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mantenimiento ALTER COLUMN idmant SET DEFAULT nextval('public.mantenimiento_idmant_seq'::regclass);


--
-- Name: programas idprograma; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.programas ALTER COLUMN idprograma SET DEFAULT nextval('public.programas_idprograma_seq'::regclass);


--
-- Name: proveedores idproveedor; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proveedores ALTER COLUMN idproveedor SET DEFAULT nextval('public.proveedores_idproveedor_seq'::regclass);


--
-- Name: proyectos idproyecto; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proyectos ALTER COLUMN idproyecto SET DEFAULT nextval('public.proyectos_idproyecto_seq'::regclass);


--
-- Name: qr_activo qr_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qr_activo ALTER COLUMN qr_id SET DEFAULT nextval('public.qr_activo_qr_id_seq'::regclass);


--
-- Name: revalorizaciones idrevalorizacion; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.revalorizaciones ALTER COLUMN idrevalorizacion SET DEFAULT nextval('public.revalorizaciones_idrevalorizacion_seq'::regclass);


--
-- Name: rubros idrubro; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rubros ALTER COLUMN idrubro SET DEFAULT nextval('public.rubros_idrubro_seq'::regclass);


--
-- Name: tiposactivos idtipo; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tiposactivos ALTER COLUMN idtipo SET DEFAULT nextval('public.tiposactivos_idtipo_seq'::regclass);


--
-- Name: ubicaciones idubicacion; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ubicaciones ALTER COLUMN idubicacion SET DEFAULT nextval('public.ubicaciones_idubicacion_seq'::regclass);


--
-- Name: usuarios idusuario; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios ALTER COLUMN idusuario SET DEFAULT nextval('public.usuarios_idusuario_seq'::regclass);


--
-- Name: valordepreciacion id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.valordepreciacion ALTER COLUMN id SET DEFAULT nextval('public.valordepreciacion_id_seq'::regclass);




COPY public.ambientes (idambiente, nombreamb, descripcionamb, idedificio) FROM stdin;
1	Sistemas	Area de Desarrollo de Sistemas\n	1

\.
COPY public.edificios (idedificio, nombreedi, servicio, direccion, idubicacion, latitud, longitud) FROM stdin;
--2	Centro Comercial	Desarrollo de software	Calle Murillo	3	-16.496827	-68.137443
1	Sede Principal	Desarrollo deSoftware	San Fransico	3	-16.496827	-68.137443
\.


COPY public.empleados (idempleado, nombres, apellidos, cargo, telefono, direccion, idambient) FROM stdin;
--1	Juan Alberto	Silva Cayo	pasante	63215576	Juan Pablo II	1
--6	juan	silva	sdsd	63215576	bolivia	1
1	admin	admin	admin	12345678	admin	1
--12	Cajero	Cajero	Cajero	65432108	Cajero	1
\.


SELECT pg_catalog.setval('activo_fijo.activos_idactivo_seq', 1, false);


--
-- Name: altaactivos_idalta_seq; Type: SEQUENCE SET; Schema: activo_fijo; Owner: postgres
--

SELECT pg_catalog.setval('activo_fijo.altaactivos_idalta_seq', 1, false);


--
-- Name: ambientes_idambiente_seq; Type: SEQUENCE SET; Schema: activo_fijo; Owner: postgres
--

SELECT pg_catalog.setval('activo_fijo.ambientes_idambiente_seq', 1, false);


--
-- Name: bajas_idbaja_seq; Type: SEQUENCE SET; Schema: activo_fijo; Owner: postgres
--

SELECT pg_catalog.setval('activo_fijo.bajas_idbaja_seq', 1, false);


--
-- Name: condiciones_idcondicion_seq; Type: SEQUENCE SET; Schema: activo_fijo; Owner: postgres
--

SELECT pg_catalog.setval('activo_fijo.condiciones_idcondicion_seq', 1, false);


--
-- Name: depreciaciones_iddepreciacion_seq; Type: SEQUENCE SET; Schema: activo_fijo; Owner: postgres
--

SELECT pg_catalog.setval('activo_fijo.depreciaciones_iddepreciacion_seq', 1, false);


--
-- Name: devoluciones_iddevolucion_seq; Type: SEQUENCE SET; Schema: activo_fijo; Owner: postgres
--

SELECT pg_catalog.setval('activo_fijo.devoluciones_iddevolucion_seq', 1, false);


--
-- Name: edificios_idedificio_seq; Type: SEQUENCE SET; Schema: activo_fijo; Owner: postgres
--

SELECT pg_catalog.setval('activo_fijo.edificios_idedificio_seq', 1, false);


--
-- Name: empleados_idempleado_seq; Type: SEQUENCE SET; Schema: activo_fijo; Owner: postgres
--

SELECT pg_catalog.setval('activo_fijo.empleados_idempleado_seq', 1, false);


--
-- Name: mantenimiento_idmant_seq; Type: SEQUENCE SET; Schema: activo_fijo; Owner: postgres
--

SELECT pg_catalog.setval('activo_fijo.mantenimiento_idmant_seq', 1, false);


--
-- Name: programas_idprograma_seq; Type: SEQUENCE SET; Schema: activo_fijo; Owner: postgres
--

SELECT pg_catalog.setval('activo_fijo.programas_idprograma_seq', 1, false);


--
-- Name: proveedores_idproveedor_seq; Type: SEQUENCE SET; Schema: activo_fijo; Owner: postgres
--

SELECT pg_catalog.setval('activo_fijo.proveedores_idproveedor_seq', 1, false);


--
-- Name: proyectos_idproyecto_seq; Type: SEQUENCE SET; Schema: activo_fijo; Owner: postgres
--

SELECT pg_catalog.setval('activo_fijo.proyectos_idproyecto_seq', 1, false);


--
-- Name: revalorizaciones_idrevalorizacion_seq; Type: SEQUENCE SET; Schema: activo_fijo; Owner: postgres
--

SELECT pg_catalog.setval('activo_fijo.revalorizaciones_idrevalorizacion_seq', 1, false);


--
-- Name: rubros_idrubro_seq; Type: SEQUENCE SET; Schema: activo_fijo; Owner: postgres
--

SELECT pg_catalog.setval('activo_fijo.rubros_idrubro_seq', 1, false);


--
-- Name: tiposactivos_idtipo_seq; Type: SEQUENCE SET; Schema: activo_fijo; Owner: postgres
--

SELECT pg_catalog.setval('activo_fijo.tiposactivos_idtipo_seq', 1, false);


--
-- Name: ubicaciones_idubicacion_seq; Type: SEQUENCE SET; Schema: activo_fijo; Owner: postgres
--

SELECT pg_catalog.setval('activo_fijo.ubicaciones_idubicacion_seq', 1, false);


--
-- Name: usuarios_idusuario_seq; Type: SEQUENCE SET; Schema: activo_fijo; Owner: postgres
--

SELECT pg_catalog.setval('activo_fijo.usuarios_idusuario_seq', 1, false);


--
-- Name: activos_idactivo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.activos_idactivo_seq', 21, true);


--
-- Name: altaactivos_idalta_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.altaactivos_idalta_seq', 42, true);


--
-- Name: ambientes_idambiente_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ambientes_idambiente_seq', 6, true);


--
-- Name: bajas_idbaja_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bajas_idbaja_seq', 12, true);


--
-- Name: condiciones_idcondicion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.condiciones_idcondicion_seq', 12, true);


--
-- Name: depreciaciones_iddepreciacion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.depreciaciones_iddepreciacion_seq', 75, true);


--
-- Name: devoluciones_iddevolucion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.devoluciones_iddevolucion_seq', 4, true);


--
-- Name: edificios_idedificio_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.edificios_idedificio_seq', 2, true);


--
-- Name: empleados_idempleado_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.empleados_idempleado_seq', 12, true);


--
-- Name: historial_asignaciones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.historial_asignaciones_id_seq', 3, true);


--
-- Name: historial_devoluciones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.historial_devoluciones_id_seq', 1, true);


--
-- Name: historial_mantenimiento_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.historial_mantenimiento_id_seq', 1, true);


--
-- Name: historialactivofijo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.historialactivofijo_id_seq', 18, true);


--
-- Name: mantenimiento_idmant_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mantenimiento_idmant_seq', 36, true);


--
-- Name: programas_idprograma_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.programas_idprograma_seq', 6, true);


--
-- Name: proveedores_idproveedor_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.proveedores_idproveedor_seq', 5, true);


--
-- Name: proyectos_idproyecto_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.proyectos_idproyecto_seq', 4, true);


--
-- Name: qr_activo_qr_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.qr_activo_qr_id_seq', 120, true);


--
-- Name: revalorizaciones_idrevalorizacion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.revalorizaciones_idrevalorizacion_seq', 2, true);


--
-- Name: rubros_idrubro_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rubros_idrubro_seq', 7, true);


--
-- Name: tiposactivos_idtipo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tiposactivos_idtipo_seq', 4, true);


--
-- Name: ubicaciones_idubicacion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ubicaciones_idubicacion_seq', 3, true);


--
-- Name: usuarios_idusuario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuarios_idusuario_seq', 5, true);


--
-- Name: valordepreciacion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.valordepreciacion_id_seq', 4, true);


--
-- Name: activos activos_pkey; Type: CONSTRAINT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.activos
    ADD CONSTRAINT activos_pkey PRIMARY KEY (idactivo);


--
-- Name: altaactivos altaactivos_pkey; Type: CONSTRAINT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.altaactivos
    ADD CONSTRAINT altaactivos_pkey PRIMARY KEY (idalta);


--
-- Name: ambientes ambientes_pkey; Type: CONSTRAINT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.ambientes
    ADD CONSTRAINT ambientes_pkey PRIMARY KEY (idambiente);


--
-- Name: bajas bajas_pkey; Type: CONSTRAINT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.bajas
    ADD CONSTRAINT bajas_pkey PRIMARY KEY (idbaja);


--
-- Name: condiciones condiciones_pkey; Type: CONSTRAINT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.condiciones
    ADD CONSTRAINT condiciones_pkey PRIMARY KEY (idcondicion);


--
-- Name: depreciaciones depreciaciones_pkey; Type: CONSTRAINT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.depreciaciones
    ADD CONSTRAINT depreciaciones_pkey PRIMARY KEY (iddepreciacion);


--
-- Name: devoluciones devoluciones_pkey; Type: CONSTRAINT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.devoluciones
    ADD CONSTRAINT devoluciones_pkey PRIMARY KEY (iddevolucion);


--
-- Name: edificios edificios_pkey; Type: CONSTRAINT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.edificios
    ADD CONSTRAINT edificios_pkey PRIMARY KEY (idedificio);


--
-- Name: empleados empleados_pkey; Type: CONSTRAINT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.empleados
    ADD CONSTRAINT empleados_pkey PRIMARY KEY (idempleado);


--
-- Name: mantenimiento mantenimiento_pkey; Type: CONSTRAINT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.mantenimiento
    ADD CONSTRAINT mantenimiento_pkey PRIMARY KEY (idmant);


--
-- Name: programas programas_pkey; Type: CONSTRAINT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.programas
    ADD CONSTRAINT programas_pkey PRIMARY KEY (idprograma);


--
-- Name: proveedores proveedores_pkey; Type: CONSTRAINT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.proveedores
    ADD CONSTRAINT proveedores_pkey PRIMARY KEY (idproveedor);


--
-- Name: proyectos proyectos_pkey; Type: CONSTRAINT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.proyectos
    ADD CONSTRAINT proyectos_pkey PRIMARY KEY (idproyecto);


--
-- Name: revalorizaciones revalorizaciones_pkey; Type: CONSTRAINT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.revalorizaciones
    ADD CONSTRAINT revalorizaciones_pkey PRIMARY KEY (idrevalorizacion);


--
-- Name: rubros rubros_pkey; Type: CONSTRAINT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.rubros
    ADD CONSTRAINT rubros_pkey PRIMARY KEY (idrubro);


--
-- Name: tiposactivos tiposactivos_pkey; Type: CONSTRAINT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.tiposactivos
    ADD CONSTRAINT tiposactivos_pkey PRIMARY KEY (idtipo);


--
-- Name: ubicaciones ubicaciones_pkey; Type: CONSTRAINT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.ubicaciones
    ADD CONSTRAINT ubicaciones_pkey PRIMARY KEY (idubicacion);


--
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (idusuario);


--
-- Name: activos activos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activos
    ADD CONSTRAINT activos_pkey PRIMARY KEY (idactivo);


--
-- Name: altaactivos altaactivos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.altaactivos
    ADD CONSTRAINT altaactivos_pkey PRIMARY KEY (idalta);


--
-- Name: ambientes ambientes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ambientes
    ADD CONSTRAINT ambientes_pkey PRIMARY KEY (idambiente);


--
-- Name: bajas bajas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bajas
    ADD CONSTRAINT bajas_pkey PRIMARY KEY (idbaja);


--
-- Name: condiciones condiciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.condiciones
    ADD CONSTRAINT condiciones_pkey PRIMARY KEY (idcondicion);


--
-- Name: depreciaciones depreciaciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.depreciaciones
    ADD CONSTRAINT depreciaciones_pkey PRIMARY KEY (iddepreciacion);


--
-- Name: devoluciones devoluciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.devoluciones
    ADD CONSTRAINT devoluciones_pkey PRIMARY KEY (iddevolucion);


--
-- Name: edificios edificios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.edificios
    ADD CONSTRAINT edificios_pkey PRIMARY KEY (idedificio);


--
-- Name: empleados empleados_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empleados
    ADD CONSTRAINT empleados_pkey PRIMARY KEY (idempleado);


--
-- Name: historial_asignaciones historial_asignaciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historial_asignaciones
    ADD CONSTRAINT historial_asignaciones_pkey PRIMARY KEY (id);


--
-- Name: historial_devoluciones historial_devoluciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historial_devoluciones
    ADD CONSTRAINT historial_devoluciones_pkey PRIMARY KEY (id);


--
-- Name: historial_mantenimiento historial_mantenimiento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historial_mantenimiento
    ADD CONSTRAINT historial_mantenimiento_pkey PRIMARY KEY (id);


--
-- Name: historialactivofijo historialactivofijo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historialactivofijo
    ADD CONSTRAINT historialactivofijo_pkey PRIMARY KEY (id);


--
-- Name: mantenimiento mantenimiento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mantenimiento
    ADD CONSTRAINT mantenimiento_pkey PRIMARY KEY (idmant);


--
-- Name: programas programas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.programas
    ADD CONSTRAINT programas_pkey PRIMARY KEY (idprograma);


--
-- Name: proveedores proveedores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proveedores
    ADD CONSTRAINT proveedores_pkey PRIMARY KEY (idproveedor);


--
-- Name: proyectos proyectos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proyectos
    ADD CONSTRAINT proyectos_pkey PRIMARY KEY (idproyecto);


--
-- Name: qr_activo qr_activo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qr_activo
    ADD CONSTRAINT qr_activo_pkey PRIMARY KEY (qr_id);


--
-- Name: revalorizaciones revalorizaciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.revalorizaciones
    ADD CONSTRAINT revalorizaciones_pkey PRIMARY KEY (idrevalorizacion);


--
-- Name: rubros rubros_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rubros
    ADD CONSTRAINT rubros_pkey PRIMARY KEY (idrubro);


--
-- Name: tiposactivos tiposactivos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tiposactivos
    ADD CONSTRAINT tiposactivos_pkey PRIMARY KEY (idtipo);


--
-- Name: ubicaciones ubicaciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ubicaciones
    ADD CONSTRAINT ubicaciones_pkey PRIMARY KEY (idubicacion);


--
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (idusuario);


--
-- Name: valordepreciacion valordepreciacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.valordepreciacion
    ADD CONSTRAINT valordepreciacion_pkey PRIMARY KEY (id);


--
-- Name: activos activos_idcondicion_fkey; Type: FK CONSTRAINT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.activos
    ADD CONSTRAINT activos_idcondicion_fkey FOREIGN KEY (idcondicion) REFERENCES public.condiciones(idcondicion);


--
-- Name: activos activos_idproveedor_fkey; Type: FK CONSTRAINT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.activos
    ADD CONSTRAINT activos_idproveedor_fkey FOREIGN KEY (idproveedor) REFERENCES public.proveedores(idproveedor);


--
-- Name: activos activos_idrubro_fkey; Type: FK CONSTRAINT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.activos
    ADD CONSTRAINT activos_idrubro_fkey FOREIGN KEY (idrubro) REFERENCES public.rubros(idrubro);


--
-- Name: altaactivos altaactivos_idactiv_fkey; Type: FK CONSTRAINT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.altaactivos
    ADD CONSTRAINT altaactivos_idactiv_fkey FOREIGN KEY (idactiv) REFERENCES activo_fijo.activos(idactivo);


--
-- Name: altaactivos altaactivos_idambiente_fkey; Type: FK CONSTRAINT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.altaactivos
    ADD CONSTRAINT altaactivos_idambiente_fkey FOREIGN KEY (idambiente) REFERENCES public.ambientes(idambiente);


--
-- Name: altaactivos altaactivos_idempleado_fkey; Type: FK CONSTRAINT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.altaactivos
    ADD CONSTRAINT altaactivos_idempleado_fkey FOREIGN KEY (idempleado) REFERENCES public.empleados(idempleado);


--
-- Name: altaactivos altaactivos_idproyecto_fkey; Type: FK CONSTRAINT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.altaactivos
    ADD CONSTRAINT altaactivos_idproyecto_fkey FOREIGN KEY (idproyecto) REFERENCES public.proyectos(idproyecto);


--
-- Name: ambientes ambientes_idedificio_fkey; Type: FK CONSTRAINT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.ambientes
    ADD CONSTRAINT ambientes_idedificio_fkey FOREIGN KEY (idedificio) REFERENCES public.edificios(idedificio);


--
-- Name: bajas bajas_idacti_fkey; Type: FK CONSTRAINT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.bajas
    ADD CONSTRAINT bajas_idacti_fkey FOREIGN KEY (idacti) REFERENCES activo_fijo.activos(idactivo);


--
-- Name: depreciaciones depreciaciones_idactivo_fkey; Type: FK CONSTRAINT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.depreciaciones
    ADD CONSTRAINT depreciaciones_idactivo_fkey FOREIGN KEY (idactivo) REFERENCES activo_fijo.activos(idactivo);


--
-- Name: devoluciones devoluciones_idcondici_fkey; Type: FK CONSTRAINT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.devoluciones
    ADD CONSTRAINT devoluciones_idcondici_fkey FOREIGN KEY (idcondici) REFERENCES activo_fijo.condiciones(idcondicion);


--
-- Name: edificios edificios_idubicacion_fkey; Type: FK CONSTRAINT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.edificios
    ADD CONSTRAINT edificios_idubicacion_fkey FOREIGN KEY (idubicacion) REFERENCES public.ubicaciones(idubicacion);


--
-- Name: empleados empleados_idambient_fkey; Type: FK CONSTRAINT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.empleados
    ADD CONSTRAINT empleados_idambient_fkey FOREIGN KEY (idambient) REFERENCES activo_fijo.ambientes(idambiente);


--
-- Name: mantenimiento mantenimiento_idact_fkey; Type: FK CONSTRAINT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.mantenimiento
    ADD CONSTRAINT mantenimiento_idact_fkey FOREIGN KEY (idact) REFERENCES activo_fijo.activos(idactivo);


--
-- Name: proyectos proyectos_idprograma_fkey; Type: FK CONSTRAINT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.proyectos
    ADD CONSTRAINT proyectos_idprograma_fkey FOREIGN KEY (idprograma) REFERENCES activo_fijo.programas(idprograma);


--
-- Name: revalorizaciones revalorizaciones_codactivo_fkey; Type: FK CONSTRAINT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.revalorizaciones
    ADD CONSTRAINT revalorizaciones_codactivo_fkey FOREIGN KEY (codactivo) REFERENCES activo_fijo.activos(idactivo);


--
-- Name: usuarios usuarios_idemplead_fkey; Type: FK CONSTRAINT; Schema: activo_fijo; Owner: postgres
--

ALTER TABLE ONLY activo_fijo.usuarios
    ADD CONSTRAINT usuarios_idemplead_fkey FOREIGN KEY (idemplead) REFERENCES activo_fijo.empleados(idempleado);


--
-- Name: activos activos_idcondicion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activos
    ADD CONSTRAINT activos_idcondicion_fkey FOREIGN KEY (idcondicion) REFERENCES public.condiciones(idcondicion);


--
-- Name: activos activos_idproveedor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activos
    ADD CONSTRAINT activos_idproveedor_fkey FOREIGN KEY (idproveedor) REFERENCES public.proveedores(idproveedor);


--
-- Name: activos activos_idrubro_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activos
    ADD CONSTRAINT activos_idrubro_fkey FOREIGN KEY (idrubro) REFERENCES public.rubros(idrubro);


--
-- Name: altaactivos altaactivos_idactiv_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.altaactivos
    ADD CONSTRAINT altaactivos_idactiv_fkey FOREIGN KEY (idactiv) REFERENCES public.activos(idactivo);


--
-- Name: altaactivos altaactivos_idambiente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.altaactivos
    ADD CONSTRAINT altaactivos_idambiente_fkey FOREIGN KEY (idambiente) REFERENCES public.ambientes(idambiente);


--
-- Name: altaactivos altaactivos_idempleado_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.altaactivos
    ADD CONSTRAINT altaactivos_idempleado_fkey FOREIGN KEY (idempleado) REFERENCES public.empleados(idempleado);


--
-- Name: altaactivos altaactivos_idproyecto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.altaactivos
    ADD CONSTRAINT altaactivos_idproyecto_fkey FOREIGN KEY (idproyecto) REFERENCES public.proyectos(idproyecto);


--
-- Name: ambientes ambientes_idedificio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ambientes
    ADD CONSTRAINT ambientes_idedificio_fkey FOREIGN KEY (idedificio) REFERENCES public.edificios(idedificio);


--
-- Name: bajas bajas_idacti_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bajas
    ADD CONSTRAINT bajas_idacti_fkey FOREIGN KEY (idacti) REFERENCES public.activos(idactivo);


--
-- Name: depreciaciones depreciaciones_idactivo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.depreciaciones
    ADD CONSTRAINT depreciaciones_idactivo_fkey FOREIGN KEY (idactivo) REFERENCES public.activos(idactivo);


--
-- Name: devoluciones devoluciones_idcondici_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.devoluciones
    ADD CONSTRAINT devoluciones_idcondici_fkey FOREIGN KEY (idcondici) REFERENCES public.condiciones(idcondicion);


--
-- Name: edificios edificios_idubicacion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.edificios
    ADD CONSTRAINT edificios_idubicacion_fkey FOREIGN KEY (idubicacion) REFERENCES public.ubicaciones(idubicacion);


--
-- Name: empleados empleados_idambient_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empleados
    ADD CONSTRAINT empleados_idambient_fkey FOREIGN KEY (idambient) REFERENCES public.ambientes(idambiente);


--
-- Name: mantenimiento mantenimiento_idact_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mantenimiento
    ADD CONSTRAINT mantenimiento_idact_fkey FOREIGN KEY (idact) REFERENCES public.activos(idactivo);


--
-- Name: proyectos proyectos_idprograma_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proyectos
    ADD CONSTRAINT proyectos_idprograma_fkey FOREIGN KEY (idprograma) REFERENCES public.programas(idprograma);


--
-- Name: revalorizaciones revalorizaciones_codactivo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.revalorizaciones
    ADD CONSTRAINT revalorizaciones_codactivo_fkey FOREIGN KEY (codactivo) REFERENCES public.activos(idactivo);


--
-- Name: usuarios usuarios_idemplead_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_idemplead_fkey FOREIGN KEY (idemplead) REFERENCES public.empleados(idempleado);


--
-- PostgreSQL database dump complete
--

