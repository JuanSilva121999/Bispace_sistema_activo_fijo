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
    idubicacion integer NOT NULL
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
    actualiza boolean
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
12	3	kXONJRjMjiqNqXjSKMQ9zUF2.jpg	Compra	DELL Core I7 $	2023-09-22 18:14:20.086876	1600.00	1600.00	0		0.200000	Activo	0	0	1	3	4	fj9-EWUtsInxgeJ2s_jyOZel.jpg	gfd54321
9	2	QsTsobN5MjHq0yY-gk3ghl9-.jpg	Compra	Silla	2023-09-20 12:40:36.085155	50.00	50.00	0	Ninguna	0.200000	En Uso	0	0	2	2	4	_C8WqPVRKFJt_MxfhlE1XQg4.jpg	gfd54321
8	3	FiJihilajK4G4XzfXZtIBthi.jpg	Compra	Marca DELL	2023-09-20 12:11:37.079827	4500.00	4500.00	0	Ninguna	2.100000	En Uso	0	0	1	3	4	kA1zw4O-z3v_4ptudl7ZuE3o.jpg	gfd54321
11	3	sz1XOrIF8P3MWBciUy0BP0SE.jpg	Compra	Dell Core I 7 	2023-09-22 18:12:55.358676	1500.00	1500.00	0	Se adiciono un nuevo disco de 500GB	0.200000	Mantenimiento	0	0	1	3	4	jiDhodalSxRR-ArkYmUMxQPM.jpg	gfd54321
10	4	bDFhZX66MA5FdwScp3rav5oR.jpg	Compra	Dell	2023-09-20 12:46:10.077154	1500.00	1500.00	0	nuevo	0.200000	Mantenimiento	0	0	1	3	4	7mQJKbfTkJWendZYewaV6tIi.jpg	gfd54321
\.


--
-- Data for Name: altaactivos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.altaactivos (idalta, codificacion, fechahora, qr, idactiv, idempleado, idproyecto, idambiente) FROM stdin;
24	Valor	2023-09-25 11:08:58.078269	data:image/png;base64,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	11	11	3	1
25	Valor	2023-09-25 11:09:25.473531	data:image/png;base64,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	8	1	1	1
26	Valor	2023-09-25 11:52:03.46473	data:image/png;base64,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	9	6	1	1
27	Valor	2023-09-25 12:36:39.883302	data:image/png;base64,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	10	11	1	1
\.


--
-- Data for Name: ambientes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ambientes (idambiente, nombreamb, descripcionamb, idedificio) FROM stdin;
1	Of	Desarrollo	1
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
\.


--
-- Data for Name: devoluciones; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.devoluciones (iddevolucion, codactivo, codempleado, idcondici, motivo, fechadevolucion, proyecto, observaciones) FROM stdin;
\.


--
-- Data for Name: edificios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.edificios (idedificio, nombreedi, servicio, direccion, idubicacion) FROM stdin;
1	Of	Desarrollo	San Fransico	1
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
-- Data for Name: mantenimiento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mantenimiento (idmant, fechamant, informe, costo, estado, idact) FROM stdin;
28	2023-09-27	Dañado	150.00	Activo	11
29	2023-09-25	sdfghj	150.00	Activo	10
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
\.


--
-- Data for Name: proyectos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.proyectos (idproyecto, nombrepro, fechainicio, fechafin, idprograma) FROM stdin;
1	Desarrollo Geo Server Mexico	2023-09-21	2023-09-29	1
3	Recoleccion de datos 	2023-09-15	2023-09-17	5
\.


--
-- Data for Name: revalorizaciones; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.revalorizaciones (idrevalorizacion, codactivo, fecharev, valornuevo, vidautilrev, descripcionrev) FROM stdin;
\.


--
-- Data for Name: rubros; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rubros (idrubro, nombre, vidautil, depreciable, coeficiented, actualiza) FROM stdin;
3	Equipos de Computacion	6	t	0.25	t
2	Mueblesy Enseres	10	t	0.1	f
5	Equipos Topografia	5	f	0.02	t
\.


--
-- Data for Name: tiposactivos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tiposactivos (idtipo, nombreactivo, descripcionmant) FROM stdin;
1	Mesa	Cada 3 meses
2	Silla	Nunca
3	Computadoras	Cada 3 meses
4	monitor	5
\.


--
-- Data for Name: ubicaciones; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ubicaciones (idubicacion, nombrelugar) FROM stdin;
1	san fransisco
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

SELECT pg_catalog.setval('public.activos_idactivo_seq', 12, true);


--
-- Name: altaactivos_idalta_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.altaactivos_idalta_seq', 27, true);


--
-- Name: ambientes_idambiente_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ambientes_idambiente_seq', 1, true);


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

SELECT pg_catalog.setval('public.depreciaciones_iddepreciacion_seq', 1, false);


--
-- Name: devoluciones_iddevolucion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.devoluciones_iddevolucion_seq', 1, false);


--
-- Name: edificios_idedificio_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.edificios_idedificio_seq', 1, true);


--
-- Name: empleados_idempleado_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.empleados_idempleado_seq', 12, true);


--
-- Name: mantenimiento_idmant_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mantenimiento_idmant_seq', 29, true);


--
-- Name: programas_idprograma_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.programas_idprograma_seq', 6, true);


--
-- Name: proveedores_idproveedor_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.proveedores_idproveedor_seq', 4, true);


--
-- Name: proyectos_idproyecto_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.proyectos_idproyecto_seq', 4, true);


--
-- Name: revalorizaciones_idrevalorizacion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.revalorizaciones_idrevalorizacion_seq', 1, false);


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

SELECT pg_catalog.setval('public.ubicaciones_idubicacion_seq', 1, true);


--
-- Name: usuarios_idusuario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuarios_idusuario_seq', 5, true);


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

