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
    estado character varying(50) DEFAULT 'En Espera'::character varying,
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


--
-- Data for Name: activos; Type: TABLE DATA; Schema: activo_fijo; Owner: postgres
--

COPY activo_fijo.activos (idactivo, idtipo, imagen, procedencia, descripcion, fecharegistro, valorregistro, valoractual, vidautilactual, observaciones, ufvinicial, estado, anio, mes, idcondicion, idrubro, idproveedor) FROM stdin;
\.


--
-- Data for Name: altaactivos; Type: TABLE DATA; Schema: activo_fijo; Owner: postgres
--

COPY activo_fijo.altaactivos (idalta, codificacion, fechahora, qr, idactiv, idempleado, idproyecto, idambiente) FROM stdin;
\.


--
-- Data for Name: ambientes; Type: TABLE DATA; Schema: activo_fijo; Owner: postgres
--

COPY activo_fijo.ambientes (idambiente, nombreamb, descripcionamb, idedificio) FROM stdin;
\.


--
-- Data for Name: bajas; Type: TABLE DATA; Schema: activo_fijo; Owner: postgres
--

COPY activo_fijo.bajas (idbaja, fechabaja, motivo, idacti) FROM stdin;
\.


--
-- Data for Name: condiciones; Type: TABLE DATA; Schema: activo_fijo; Owner: postgres
--

COPY activo_fijo.condiciones (idcondicion, nombre) FROM stdin;
\.


--
-- Data for Name: depreciaciones; Type: TABLE DATA; Schema: activo_fijo; Owner: postgres
--

COPY activo_fijo.depreciaciones (iddepreciacion, ufvactual, ufvinicial, fecha, valorcontabilizado, factoractual, valoractualizado, incrementoactual, depreciacionacuant, incrementodepacu, depreciacionperiodo, depreciacionacuact, valorneto, porcentajedep, vidautilactual, vidautilmes, idactivo) FROM stdin;
\.


--
-- Data for Name: devoluciones; Type: TABLE DATA; Schema: activo_fijo; Owner: postgres
--

COPY activo_fijo.devoluciones (iddevolucion, codactivo, codempleado, idcondici, motivo, fechadevolucion, proyecto, observaciones) FROM stdin;
\.


--
-- Data for Name: edificios; Type: TABLE DATA; Schema: activo_fijo; Owner: postgres
--

COPY activo_fijo.edificios (idedificio, nombreedi, servicio, direccion, idubicacion) FROM stdin;
\.


--
-- Data for Name: empleados; Type: TABLE DATA; Schema: activo_fijo; Owner: postgres
--

COPY activo_fijo.empleados (idempleado, nombres, apellidos, cargo, telefono, direccion, idambient) FROM stdin;
\.


--
-- Data for Name: mantenimiento; Type: TABLE DATA; Schema: activo_fijo; Owner: postgres
--

COPY activo_fijo.mantenimiento (idmant, fechamant, informe, costo, estado, idact) FROM stdin;
\.


--
-- Data for Name: programas; Type: TABLE DATA; Schema: activo_fijo; Owner: postgres
--

COPY activo_fijo.programas (idprograma, nombreprog) FROM stdin;
\.


--
-- Data for Name: proveedores; Type: TABLE DATA; Schema: activo_fijo; Owner: postgres
--

COPY activo_fijo.proveedores (idproveedor, nombreprov, direccionprov, telefonoprov) FROM stdin;
\.


--
-- Data for Name: proyectos; Type: TABLE DATA; Schema: activo_fijo; Owner: postgres
--

COPY activo_fijo.proyectos (idproyecto, nombrepro, fechainicio, fechafin, idprograma) FROM stdin;
\.


--
-- Data for Name: revalorizaciones; Type: TABLE DATA; Schema: activo_fijo; Owner: postgres
--

COPY activo_fijo.revalorizaciones (idrevalorizacion, codactivo, fecharev, valornuevo, vidautilrev, descripcionrev) FROM stdin;
\.


--
-- Data for Name: rubros; Type: TABLE DATA; Schema: activo_fijo; Owner: postgres
--

COPY activo_fijo.rubros (idrubro, nombre, vidautil, depreciable, coeficiented, actualiza) FROM stdin;
\.


--
-- Data for Name: tiposactivos; Type: TABLE DATA; Schema: activo_fijo; Owner: postgres
--

COPY activo_fijo.tiposactivos (idtipo, nombreactivo, descripcionmant) FROM stdin;
\.


--
-- Data for Name: ubicaciones; Type: TABLE DATA; Schema: activo_fijo; Owner: postgres
--

COPY activo_fijo.ubicaciones (idubicacion, nombrelugar) FROM stdin;
\.


--
-- Data for Name: usuarios; Type: TABLE DATA; Schema: activo_fijo; Owner: postgres
--

COPY activo_fijo.usuarios (idusuario, idemplead, email, password, rol, estado) FROM stdin;
\.


--
-- Data for Name: activos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.activos (idactivo, idtipo, imagen, procedencia, descripcion, fecharegistro, valorregistro, valoractual, vidautilactual, observaciones, ufvinicial, estado, anio, mes, idcondicion, idrubro, idproveedor, factura, garantia) FROM stdin;
11	3	sz1XOrIF8P3MWBciUy0BP0SE.jpg	Compra	Dell Core I 7 	2023-09-22 18:12:55.358676	1500.00	937.50	0	Se adiciono un nuevo disco de 500GB	2.432170	En Uso	0	0	1	3	4	jiDhodalSxRR-ArkYmUMxQPM.jpg	gfd54321
8	3	FiJihilajK4G4XzfXZtIBthi.jpg	Compra	Marca DELL	2023-09-20 12:11:37.079827	4500.00	2812.50	0	Ninguna	2.432170	En Uso	0	0	1	3	4	kA1zw4O-z3v_4ptudl7ZuE3o.jpg	gfd54321
16	3	3nXMUCK3KusMyPTSvCJf1Ys2.jpg	Compra	Dell Core I7	2023-10-03 15:25:03.300444	25000.00	25000.00	0	Cambio de disco	3.000000	En Uso	0	0	1	3	5	PRRCj4Fc4oaJ1xj3XpaXjOEV.jpg	gfd54321
12	3	kXONJRjMjiqNqXjSKMQ9zUF2.jpg	Compra	DELL Core I7 $	2023-09-22 18:14:20.086876	1600.00	1000.00	0		2.432170	Activo	0	0	3	3	4	fj9-EWUtsInxgeJ2s_jyOZel.jpg	gfd54321
15	3	Ji8Ng0fz9mhF94XEqAedI7Qo.jpg	Compr	Marca Dell	2023-09-29 16:14:26.116772	16312.50	10195.32	0	Ninguna	2.432170	Activo	0	0	1	3	4	9qwsbzAxpokqRzzJzIZyNTuE.jpg	gfd54321
14	1	tBb3ymarewzTk-o96T-zQYRA.jpg	Compra	Venta de mesas de aplificacion	2023-09-29 16:10:38.494798	16000.00	13120.00	0	Ninguna	2.432170	Activo	0	0	1	2	4	Us6MhW4vdyFaYJfez43wsnPe.jpg	gfd54321
13	2	WHhwlcHAsezEpN_rLz8N-Rl2.jpg	Compra	Comprado	2023-09-28 15:38:10.244494	150.00	123.00	0	Ninguna	2.432170	Activo	0	0	1	2	4	Vgk-fduxZRooR73Hru3-es6i.jpg	gfd54321
10	4	bDFhZX66MA5FdwScp3rav5oR.jpg	Compra	Dell	2023-09-20 12:46:10.077154	1500.00	937.50	0	Nuevo	2.432170	En Uso	0	0	1	3	4	7mQJKbfTkJWendZYewaV6tIi.jpg	gfd54321
9	2	QsTsobN5MjHq0yY-gk3ghl9-.jpg	Compra	Silla	2023-09-20 12:40:36.085155	50.00	1.00	0	Ninguna	2.432170	Mantenimiento	0	0	2	2	4	_C8WqPVRKFJt_MxfhlE1XQg4.jpg	gfd54321
\.


--
-- Data for Name: altaactivos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.altaactivos (idalta, codificacion, fechahora, qr, idactiv, idempleado, idproyecto, idambiente) FROM stdin;
27	Valor	2023-09-25 12:36:39.883302	data:image/png;base64,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	10	11	1	1
24	Valor	2023-09-25 11:08:58.078269	data:image/png;base64,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	11	11	3	1
34	Valor	2023-09-27 17:19:30.155842	data:image/png;base64,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	12	12	3	1
35	Valor	2023-09-28 14:41:35.652284	data:image/png;base64,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	9	1	1	1
36	Valor	2023-09-28 14:41:48.144131	data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAPQAAAD0CAYAAACsLwv+AAAAAklEQVR4AewaftIAAA2cSURBVO3BQW7s2pLAQFLw/rfM9qxzdABBVb7/CRlhv1hrvcLFWus1LtZar3Gx1nqNi7XWa1ystV7jYq31Ghdrrde4WGu9xsVa6zUu1lqvcbHWeo2LtdZrXKy1XuNirfUaF2ut1/jhIZW/VHGickfFpPJExaQyVUwqJxWTylQxqTxRMamcVEwqU8WkclLxhMpJxR0qf6niiYu11mtcrLVe42Kt9Ro/fFjFJ6l8UsWkckfFHRWTyknFpDJVnFRMKlPFicpUMancoXKHylQxqUwVU8WkMqlMFXdUfJLKJ12stV7jYq31Ghdrrdf44ctU7qi4Q+Wk4qRiUjlRmSomlTsq7lCZKiaVE5WTikllqrij4kRlqphUnqiYVD5J5Y6Kb7pYa73GxVrrNS7WWq/xw8tU3KEyVdyhckfFpHJScUfFEypTxaQyVZyonFRMKlPFpHKiclIxqUwV/2UXa63XuFhrvcbFWus1fngZlZOKO1SmiqnikyomlX9JZaqYVKaK/5KKN7lYa73GxVrrNS7WWq/xw5dV/EsVk8qJyh0qJxUnFXdUTCpTxR0qU8UTKndUnKhMFZPKVDGpfFPF/5KLtdZrXKy1XuNirfUaP3yYyr9UMalMFZPKVDGp3FExqUwVk8pU8UkqU8UdKlPFScWkMlVMKlPFpPJNKlPFicr/sou11mtcrLVe42Kt9Ro/PFTxX6JyojJV3KEyVZxU3KFyR8UTFZPKVDGp3FExqXxSxRMV/yUXa63XuFhrvcbFWus1fnhIZaqYVD6pYqr4SyonFXeoTBVTxaRyovJNFScVJyqfVDGpnFTcofJJFd90sdZ6jYu11mtcrLVew37xh1ROKj5JZaqYVO6oOFGZKk5Unqi4Q2WqmFTuqHhC5aTiDpWTiidUTipOVE4qnrhYa73GxVrrNS7WWq/xw0MqJxV3qJxUTCpPVJyonKh8UsWJyonKVDFVnFRMKlPFicoTFZPKVHFScaIyVZyoTBVPVHzTxVrrNS7WWq9xsdZ6DfvFH1KZKiaVqeJE5aTiROWJikllqphUpopJ5YmKE5U7KiaVJyqeUJkq1v+7WGu9xsVa6zUu1lqv8cNDKp9UMamcVJyoTBVPVNyhckfFicqJyhMVJxVPqJxUTCpTxYnKScWkMlWcqHxTxRMXa63XuFhrvcbFWus1fnioYlK5Q2WqmCruUJkqJpU7Kp6oOFG5o+KbVKaKE5Wp4o6KSWWqmFQ+qeKOiidUvulirfUaF2ut17hYa72G/eKLVKaKSeWOijtUTipOVKaKE5WpYlI5qfgklaniDpVPqphUPqniDpVPqphUpopvulhrvcbFWus1LtZar2G/eEDlpGJSmSqeUHmi4gmVqeIOlZOKSeWOiknliYoTlaniCZU7KiaVT6o4UZkq/tLFWus1LtZar3Gx1noN+8UHqUwVJypPVEwqU8WkclLxTSpTxRMqU8WkckfFicpUcYfKScWkMlXcoTJVTCqfVDGpnFR80sVa6zUu1lqvcbHWeg37xR9SmSomlaniRGWqmFROKk5UpooTlaniDpWTikllqjhReaLiRGWqmFTuqJhUPqniDpWTiknljoonLtZar3Gx1nqNi7XWa/zwkMpUMalMFScVk8odKt+kMlXcoXJHxUnFpDJVTBXfVHFHxRMVJypTxaQyVUwqJxV3VHzTxVrrNS7WWq9xsdZ6jR/+MZWTihOVk4oTlZOKSeWk4qRiUpkq7lC5Q2WqeELlpGKqOFH5JpWpYlKZKk5UTir+0sVa6zUu1lqvcbHWeo0fPkzlROWkYlKZKk4qJpWTihOVqeIJlaliUpkq7qiYVE5UpooTlaliUjlROamYVKaKSWWqOKmYVKaKE5WTiknljoonLtZar3Gx1nqNi7XWa9gvvkjljoo7VKaKT1KZKu5QmSq+SeWk4kTlpOIJlaliUvlLFX9J5aTiiYu11mtcrLVe42Kt9Rr2iy9SmSpOVD6pYlKZKu5QmSomlf+SihOVk4onVKaKO1SmiknljopJZao4UTmp+KaLtdZrXKy1XuNirfUaP3yYyonKHRUnKicqU8WJylRxojJV/CWVqeKbKk5UvkllqphUpopvUjmp+EsXa63XuFhrvcbFWus17Bf/kMonVZyonFRMKlPFpDJVTCpTxYnKVDGp/EsVn6RyR8WJylRxovIvVXzSxVrrNS7WWq9xsdZ6jR8eUpkqTlROKu5QmVROKiaVSWWq+CSVqeJEZaqYVKaKO1T+ksodFZPKVDFVTCp3VNyhckfFpDJVPHGx1nqNi7XWa1ystV7jhw9TmSqmiknlRGWqOKmYVCaVT6p4QmWqmFSeUJkq7qiYVJ6omFROVKaKSeWkYlK5Q2WqOKmYVCaVqeKTLtZar3Gx1nqNi7XWa/zwYRWfVPFExR0qk8odFVPFpHKi8kkVn1Rxh8pJxaQyVUwqT1RMKicVd6hMFZPKpDJVPHGx1nqNi7XWa1ystV7DfvGAyv+Sik9SOak4UZkqPknlkypOVO6omFROKiaVqeJEZaqYVP6XVHzSxVrrNS7WWq9xsdZ6jR8+rOJEZaqYVKaKE5VJ5aRiUpkqTir+kspJxR0qU8WkclIxqUwVJxV3VEwqd6hMFXeo3FFxovJNF2ut17hYa73GxVrrNX54qOJE5QmVqWKquEPlCZV/qeKJiknlpGJSuUPlpOKJijtUpoqTiidUpopvulhrvcbFWus1LtZar2G/+EMqU8UTKndUTCpTxRMqJxWTylQxqTxR8YTKVDGpnFRMKndUnKhMFZPKExWfpDJVfNLFWus1LtZar3Gx1noN+8UHqUwVJyqfVHGHyh0VT6hMFU+oTBVPqNxRcaJyR8WJylQxqUwVJypTxRMqJxWTylTxxMVa6zUu1lqvcbHWeg37xR9SmSomlaniRGWqmFSmiknliYoTlScqJpWpYlKZKp5QuaPiDpWTihOVJyomlaliUvmkik+6WGu9xsVa6zUu1lqvYb94QGWqeELlpOJEZaq4Q+WkYlKZKk5UnqiYVKaKSeWkYlL5popJZaqYVKaKSWWq+EsqU8W/dLHWeo2LtdZrXKy1XsN+8UEqd1RMKlPFEypTxV9SmSomlanik1ROKiaVk4pJZaqYVKaKJ1SmihOVOyomlScqTlSmiicu1lqvcbHWeo2LtdZr/PCQylTxSSpTxaQyVdyhMlWcqNxR8S9VnKg8UTGpnKg8UXGiclIxqZxUTCpTxYnKVPFNF2ut17hYa73GxVrrNewXX6RyUjGpTBUnKicVT6hMFZPKExWTyh0Vk8pJxaTyRMWJyhMVk8oTFScqU8Wk8k0VT1ystV7jYq31GhdrrdewXzygclIxqXxSxR0qU8UdKicVn6QyVZyoTBWTylTxSSpTxYnKVDGp3FHxTSpPVHzTxVrrNS7WWq9xsdZ6DfvFB6l8UsUTKp9UcYfKVHGi8kkVk8pUMalMFZPKHRWfpDJVTCrfVPGEyknFExdrrde4WGu9xsVa6zV+eEjlpGJSOamYVO6omCruUJkqJpWpYlJ5omJSmSpOVO5QeaLiROWJijsqJpWpYlKZKu5QuaPimy7WWq9xsdZ6jYu11mv88Mcq7qiYVO5QuaPiDpVPUpkqJpU7VKaKE5VJZaqYVKaKqWJSOal4QuWOijtU7qiYVE4qnrhYa73GxVrrNS7WWq9hv3hA5aRiUnmi4kTljoo7VKaKf0llqjhROak4UTmpuEPlpGJSOamYVE4q3uRirfUaF2ut17hYa72G/eKDVE4qnlCZKk5Upoo7VE4qvknlkyr+l6hMFScqU8UdKk9UnKhMFScqU8UTF2ut17hYa73GxVrrNewXf0hlqjhRuaPiROWbKk5UpoonVP6lijtUpop/SeWTKiaVk4pPulhrvcbFWus1LtZar2G/+A9TOamYVE4qTlSmik9SOamYVKaKO1TuqJhUpoonVKaKJ1TuqLhDZaq4Q2WqeOJirfUaF2ut17hYa73GDw+p/KWKqeKOihOVk4pJ5Y6KSeWk4gmVqeKk4o6KSeWOiqliUpkqTlSmihOVE5Wp4kTljopPulhrvcbFWus1LtZar/HDh1V8ksqJylQxqUwVJxWTyqRyUnFHxR0qd1TcoXJHxVTxTSpPqNxR8UTFicpU8cTFWus1LtZar3Gx1nqNH75M5Y6KJ1ROVE4qTiomlUllqphU7qi4Q+WbKk5Unqg4qXiiYlKZVD5JZar4pou11mtcrLVe42Kt9Ro/vEzFicqJyonKVDGpPFFxUnGiMlWcqNyhMlVMFScqU8WkMlVMKlPFicpUcUfFpDJVPFHxSRdrrde4WGu9xsVa6zV+eBmVk4o7VKaKv6RyUnGiclLxSSpPVJxUTConFZPKVDGpTCpTxaTySRVPXKy1XuNirfUaF2ut1/jhyyq+qeIOlTsqTlTuqLij4kRlqphU7lCZKk5U7qg4UXmi4qRiUpkqTlROKk5UpopPulhrvcbFWus1LtZar/HDh6n8JZWTipOKSWVSuaNiUpkqJpW/VDGpTBUnKlPFEyp3VJyo3FExqXxTxTddrLVe42Kt9RoXa63XsF+stV7hYq31Ghdrrde4WGu9xsVa6zUu1lqvcbHWeo2LtdZrXKy1XuNirfUaF2ut17hYa73GxVrrNS7WWq9xsdZ6jYu11mv8HzAprsR1mFdIAAAAAElFTkSuQmCC	8	6	1	1
37	Valor	2023-10-03 15:26:01.070214	data:image/png;base64,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	16	12	1	1
\.


--
-- Data for Name: ambientes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ambientes (idambiente, nombreamb, descripcionamb, idedificio) FROM stdin;
1	Sistemas	Area de Desarrollo de Sistemas\n	1
6	Secretaria	Área de Secretarias	1
\.


--
-- Data for Name: bajas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bajas (idbaja, fechabaja, motivo, idacti) FROM stdin;
11	2023-09-20 13:32:50.107259	Dañado	8
12	2023-09-20 13:34:47.078425	Dañado	10
\.


--
-- Data for Name: condiciones; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.condiciones (idcondicion, nombre) FROM stdin;
1	Nuevo
2	Bueno
3	Regular
4	Malo
5	Obsoleto y/o Pesimo
6	Perdido
\.


--
-- Data for Name: depreciaciones; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.depreciaciones (iddepreciacion, ufvactual, ufvinicial, fecha, valorcontabilizado, factoractual, valoractualizado, incrementoactual, depreciacionacuant, incrementodepacu, depreciacionperiodo, depreciacionacuact, valorneto, porcentajedep, vidautilactual, vidautilmes, idactivo) FROM stdin;
60	2.445556	2.432170	2023-10-26 00:00:00	16000.00	0.005504	88.06	16088.06	0.00	0.00	1440.00	1440.00	14560.00	0.10	10	10	14
61	2.445556	2.432170	2023-10-26 00:00:00	16312.50	0.005504	89.78	16402.28	0.00	0.00	3058.59	3058.59	13253.91	0.25	4	4	15
62	2.445556	2.432170	2023-10-26 00:00:00	1500.00	0.005504	8.26	1508.26	0.00	0.00	281.25	281.25	1218.75	0.25	4	4	10
63	2.445556	2.432170	2023-10-26 00:00:00	1500.00	0.005504	8.26	1508.26	0.00	0.00	281.25	281.25	1218.75	0.25	4	4	11
64	2.445556	2.432170	2023-10-26 00:00:00	1600.00	0.005504	8.81	1608.81	0.00	0.00	300.00	300.00	1300.00	0.25	4	4	12
65	2.445556	2.432170	2023-10-26 00:00:00	50.00	0.005504	0.28	50.28	0.00	0.00	4.50	4.50	45.50	0.10	10	10	9
66	2.445556	2.432170	2023-10-26 00:00:00	4500.00	0.005504	24.77	4524.77	0.00	0.00	843.75	843.75	3656.25	0.25	4	4	8
67	2.445556	2.432170	2023-10-26 00:00:00	150.00	0.005504	0.83	150.83	0.00	0.00	13.50	13.50	136.50	0.10	10	10	13
68	2.445556	2.432170	2023-10-02 00:00:00	14560.00	0.005504	80.13	14640.13	1440.00	7.93	1440.00	1440.00	13120.00	0.10	10	10	14
69	2.445556	2.432170	2023-10-02 00:00:00	13253.91	0.005504	72.94	13326.85	3058.59	16.83	3058.59	3058.59	10195.32	0.25	4	4	15
70	2.445556	2.432170	2023-10-02 00:00:00	1218.75	0.005504	6.71	1225.46	281.25	1.55	281.25	281.25	937.50	0.25	4	4	10
71	2.445556	2.432170	2023-10-02 00:00:00	1218.75	0.005504	6.71	1225.46	281.25	1.55	281.25	281.25	937.50	0.25	4	4	11
72	2.445556	2.432170	2023-10-02 00:00:00	1300.00	0.005504	7.15	1307.15	300.00	1.65	300.00	300.00	1000.00	0.25	4	4	12
73	2.445556	2.432170	2023-10-02 00:00:00	45.50	0.005504	0.25	45.75	4.50	0.02	4.50	4.50	41.00	0.10	10	10	9
74	2.445556	2.432170	2023-10-02 00:00:00	3656.25	0.005504	20.12	3676.37	843.75	4.64	843.75	843.75	2812.50	0.25	4	4	8
75	2.445556	2.432170	2023-10-02 00:00:00	136.50	0.005504	0.75	137.25	13.50	0.07	13.50	13.50	123.00	0.10	10	10	13
\.


--
-- Data for Name: devoluciones; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.devoluciones (iddevolucion, codactivo, codempleado, idcondici, motivo, fechadevolucion, proyecto, observaciones) FROM stdin;
1	8	6	3	finalizacion de Gestion	2023-10-05 16:21:30.774	Desarrollo Geo Server Mexico	Ninguna
2	12	12	3	finalizacion de Gestion	2023-10-05 16:26:30.354	Recoleccion de datos 	Ninguna
\.


--
-- Data for Name: edificios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.edificios (idedificio, nombreedi, servicio, direccion, idubicacion, latitud, longitud) FROM stdin;
2	Centro Comercial	Desarrollo de software	Calle Murillo	3	-16.496827	-68.137443
1	Sede Principal	Desarrollo deSoftware	San Fransico	3	-16.496827	-68.137443
\.


--
-- Data for Name: empleados; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.empleados (idempleado, nombres, apellidos, cargo, telefono, direccion, idambient) FROM stdin;
1	Juan Alberto	Silva Cayo	pasante	63215576	Juan Pablo II	1
6	juan	silva	sdsd	63215576	bolivia	1
11	admin	admin	admin	12345678	admin	1
12	Cajero	Cajero	Cajero	65432108	Cajero	1
\.


--
-- Data for Name: historialactivofijo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.historialactivofijo (id, codactivo, codempleado, codproyecto, codambiente, estado, fecha, proyecto, asignado_por) FROM stdin;
2	9	1	1	1	En Uso	2023-09-27 17:13:55.436271	\N	\N
1	8	1	1	1	En Uso	2023-09-27 17:03:03.738045	\N	\N
3	12	12	3	1	En Uso	2023-09-27 17:18:34.00898	\N	\N
6	9	1	1	1	En Uso	2023-09-28 14:41:35.652284	\N	\N
7	8	6	1	1	En Uso	2023-09-28 14:41:48.144131	\N	\N
8	16	12	1	1	En Uso	2023-10-03 15:26:01.070214	\N	\N
\.


--
-- Data for Name: mantenimiento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mantenimiento (idmant, fechamant, informe, costo, estado, idact) FROM stdin;
34	2023-10-17	Pata rota	50.00	Activo	9
\.


--
-- Data for Name: programas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.programas (idprograma, nombreprog) FROM stdin;
1	Desarrollo Sistemas
5	Recopilacion de datos
6	Geo servicio
\.


--
-- Data for Name: proveedores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.proveedores (idproveedor, nombreprov, direccionprov, telefonoprov) FROM stdin;
4	Axs	Murillo	65747852
5	Dell		65874212
\.


--
-- Data for Name: proyectos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.proyectos (idproyecto, nombrepro, fechainicio, fechafin, idprograma) FROM stdin;
1	Desarrollo Geo Server Mexico	2023-09-21	2023-09-29	1
3	Recoleccion de datos 	2023-10-04	2023-10-06	5
\.


--
-- Data for Name: qr_activo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.qr_activo (qr_id, qr_image, qr_fecha_creacion, qr_fecha_emicion, qr_fecha_renovacion, qr_cod_activo, qr_id_activo, qr_estado) FROM stdin;
101	data:image/png;base64,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	2023-10-17	2023-10-17	2023-10-17	BPEC-0001	11	s
102	data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAKQAAACkCAYAAAAZtYVBAAAAAklEQVR4AewaftIAAAYqSURBVO3BQY4kRxLAQDLQ//8yd45+2QQSVT0KCW5mf7DWJQ5rXeSw1kUOa13ksNZFDmtd5LDWRQ5rXeSw1kUOa13ksNZFDmtd5LDWRQ5rXeSw1kUOa13khw+p/E0Vk8onKiaVqeKJypOKSeVJxROVqeKJyt9U8YnDWhc5rHWRw1oX+eHLKr5J5Y2KJyqTyicqnqhMFZPKpPKbKr5J5ZsOa13ksNZFDmtd5IdfpvJGxRsVk8obFd+kMlX8JpWp4g2VNyp+02GtixzWushhrYv88C+n8ptU3qh4orL+v8NaFzmsdZHDWhf54V+u4hMqb1Q8UZkqpopJZap4ojJV/Jcc1rrIYa2LHNa6yA+/rOJmFZPKVPFGxaTyhsqTim+quMlhrYsc1rrIYa2L/PBlKn+TylQxqUwVk8pUMalMFZPKVPGkYlKZKiaVJypTxROVmx3WushhrYsc1rqI/cG/mMpU8U9SmSqeqEwVT1Smiv+Sw1oXOax1kcNaF/nhQypTxaTypGJSeaNiUpkqJpUnFZPKVPGGypOKSWWqmCreUJkqnqhMFZPKk4pPHNa6yGGtixzWusgPH6r4hMqTik+oTBWTyidUpopJ5ZtUnlQ8UZkqnqj8TYe1LnJY6yKHtS7ywy+rmFSmiicqU8Wk8qTiScU3qUwVb1R8QmWqmFQmlScVk8pvOqx1kcNaFzmsdRH7gw+oTBVPVJ5UPFGZKiaVNyomlU9UTCpvVHxC5Y2KSWWqeKIyVXzisNZFDmtd5LDWRX74UMUTlaliUnmiMlU8qXhDZap4ojJVvFHxRGWqmFTeqJhUvqnimw5rXeSw1kUOa13khw+pfKJiUpkqvkllqphUpoqpYlL5TSpTxScqJpU3VKaKbzqsdZHDWhc5rHUR+4MPqHyi4onKVPFEZap4ojJVPFF5UjGpTBVvqEwVb6hMFU9Upoq/6bDWRQ5rXeSw1kXsDz6g8qRiUnlS8YbKVPFEZaqYVKaKJypTxROVT1RMKn9TxW86rHWRw1oXOax1kR8+VPGbVJ5UPFGZKiaVN1Smiicq36QyVUwqTyomlaliUvmbDmtd5LDWRQ5rXeSHD6l8ouJJxaTyROWbVN5QmSqeqDypmFQmlaliUnlDZap4ojJVfOKw1kUOa13ksNZFfvhlFZ9QeaPiicobFZPKpPJNFZPKVDGpvKHypGJSeVLxTYe1LnJY6yKHtS5if/AXqbxR8UTlScWkMlVMKk8qPqHyRsUbKk8qJpWp4onKVPFNh7UucljrIoe1LvLDX1bxhspUMVVMKt9U8QmVNyq+qWJSeaLypGJSmSo+cVjrIoe1LnJY6yI/fEjlScWkMlU8qXii8ptUnlS8UfFEZap4ovJNFZPK33RY6yKHtS5yWOsiP3yo4onKVPFE5Y2KSeUNlaniDZWpYqr4JpWp4onKGypPVH7TYa2LHNa6yGGti/zwZSpTxROVJxWTyicqJpVJ5UnFGypPKqaKJxW/qeINlW86rHWRw1oXOax1kR8+pDJVTCpPKp6ofJPKVDGpPFGZKiaVqeITKlPFpPJPqvimw1oXOax1kcNaF7E/+BdTeaNiUvlNFZPKVPFE5Y2KN1SeVPxNh7UucljrIoe1LvLDh1T+poonFU9UpoonKlPFN6lMFd+kMlU8qfgnHda6yGGtixzWusgPX1bxTSpvqLyh8gmVqeJJxROVb6p4Q+VJxaQyVXzisNZFDmtd5LDWRX74ZSpvVLxRMalMFZPKVDGpTBWTylQxqUwVT1SmiicqT1Q+UTGpTCq/6bDWRQ5rXeSw1kV++JdTmSqeVEwqT1SmijdUflPFGypTxZOKSeU3Hda6yGGtixzWusgP/3EqTyomlanijYpJ5UnFpDJVTBWTylQxqXxCZar4TYe1LnJY6yKHtS7ywy+r+E0Vk8pUMalMKlPFE5U3KiaVJxVPVKaKSeUNlaliqniiMlV84rDWRQ5rXeSw1kV++DKVv0llqphU3lCZKr6p4onKVDFVvFHxRGVSmSqeVHzTYa2LHNa6yGGti9gfrHWJw1oXOax1kcNaFzmsdZHDWhc5rHWRw1oXOax1kcNaFzmsdZHDWhc5rHWRw1oXOax1kcNaF/kfaXfugaLq1V0AAAAASUVORK5CYII=	2023-10-17	2023-10-17	2023-10-17	BPEC-0002	8	s
103	data:image/png;base64,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	2023-10-17	2023-10-17	2023-10-17	BPEC-0003	16	s
104	data:image/png;base64,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	2023-10-17	2023-10-17	2023-10-17	BPEC-0004	12	s
105	data:image/png;base64,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	2023-10-17	2023-10-17	2023-10-17	BPEC-0005	15	s
106	data:image/png;base64,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	2023-10-17	2023-10-17	2023-10-17	BPME-0001	14	s
107	data:image/png;base64,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	2023-10-17	2023-10-17	2023-10-17	BPME-0002	13	s
108	data:image/png;base64,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	2023-10-17	2023-10-17	2023-10-17	BPEC-0006	10	s
109	data:image/png;base64,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	2023-10-17	2023-10-17	2023-10-17	BPME-0003	9	s
\.


--
-- Data for Name: revalorizaciones; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.revalorizaciones (idrevalorizacion, codactivo, fecharev, valornuevo, vidautilrev, descripcionrev) FROM stdin;
1	9	2023-10-02 17:17:00	10.00	\N	Actualizacion
2	9	2023-10-02 17:41:00	150.00	\N	detalle
\.


--
-- Data for Name: rubros; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rubros (idrubro, nombre, vidautil, depreciable, coeficiented, actualiza, cod) FROM stdin;
5	Equipos Topografia	5	f	0.02	t	ET
3	Equipos de Computacion	4	t	0.25	t	EC
2	Muebles y Enseres	10	t	0.1	f	ME
\.


--
-- Data for Name: tiposactivos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tiposactivos (idtipo, nombreactivo, descripcionmant) FROM stdin;
1	Mesa	Cada 3 meses
2	Silla	Nunca
3	Computadoras	Cada 3 meses
4	monitor	Cada 3 meses
\.


--
-- Data for Name: ubicaciones; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ubicaciones (idubicacion, nombrelugar) FROM stdin;
1	san fransisco
2	la paz
3	La Paz
\.


--
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuarios (idusuario, idemplead, email, password, rol, estado) FROM stdin;
1	1	alberto@gmail.com	$2b$10$UW/.spSbyHzI/Z7WE0d0Cu.jesaBh/RtxI3s6PjPkczl.3L/GNEku	ADMIN	ACTIVO
2	1	juan.silva12121999@gmail.com	$2b$10$r78nNmPSm9x.yXalXMoi3uOMdQ1tmqFyEM/4P7TqGDw0wUBDDUmqS	ADMIN	ACTIVO
4	11	admin@admin.com	$2b$10$jxWpItIdooPXWzJryTiL8O2/o20Ko8eKDm2Np/zBxYVoTj9jW86Ya	ADMIN	ACTIVO
3	1	juan@gmail.com	$2b$10$TlEIRf55zk1nYdnqsZ.FVOym31u63CRKqVXsGAUTJAKbMNKVdJV.a	ADMIN	ACTIVO
5	12	cajero@admin.com	$2b$10$h6Wy1Kuq0uHFOjmfQOCYC.JUMPd735yIwSZQHVDkx3Go/JWp0sQMi	R.ALAMACEN	ACTIVO
\.


--
-- Data for Name: valordepreciacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.valordepreciacion (id, fecha_actual, valor) FROM stdin;
3	2023-09-28 15:04:44.292749	3.25
\.


--
-- Name: activos_idactivo_seq; Type: SEQUENCE SET; Schema: activo_fijo; Owner: postgres
--

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

SELECT pg_catalog.setval('public.activos_idactivo_seq', 16, true);


--
-- Name: altaactivos_idalta_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.altaactivos_idalta_seq', 37, true);


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

SELECT pg_catalog.setval('public.devoluciones_iddevolucion_seq', 2, true);


--
-- Name: edificios_idedificio_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.edificios_idedificio_seq', 2, true);


--
-- Name: empleados_idempleado_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.empleados_idempleado_seq', 12, true);


--
-- Name: historialactivofijo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.historialactivofijo_id_seq', 8, true);


--
-- Name: mantenimiento_idmant_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mantenimiento_idmant_seq', 34, true);


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

SELECT pg_catalog.setval('public.qr_activo_qr_id_seq', 109, true);


--
-- Name: revalorizaciones_idrevalorizacion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.revalorizaciones_idrevalorizacion_seq', 2, true);


--
-- Name: rubros_idrubro_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rubros_idrubro_seq', 5, true);


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

