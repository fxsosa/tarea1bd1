-- Para ejecutal el script ejecutar el SQL Comand Line:
-- @C:\SQL\sosaramos_matiasantonio_2.sql

-- Conexion al Sitema;
CONNECT system/admin;

-- Si existe el usuario matias, lo elimino con todos sus objetos para probar una y otra vez;
DROP USER matias CASCADE;

-- Creacion de usuario:
CREATE USER matias IDENTIFIED BY admin DEFAULT TABLESPACE users TEMPORARY TABLESPACE temp QUOTA UNLIMITED ON users;

-- Asignacion de permisos al usuario:
GRANT CREATE SESSION, CREATE TABLE, CREATE SEQUENCE, CREATE ANY INDEX, CREATE VIEW, CREATE TRIGGER TO matias;

-- Desconectar Usuario SYSTEM
DISCONNECT;

-- Conexion de usuario:
CONNECT matias/admin;

--formato fecha
ALTER SESSION SET NLS_DATE_FORMAT='DD/MM/YYYY';

-- Creacion de la tabla Regiones
CREATE TABLE REGIONES (
	REGION_ID NUMBER NOT NULL,
	NOMBRE_REGION VARCHAR2(25),
	CONSTRAINT REGION_ID_PK PRIMARY KEY (REGION_ID)
);

-- Creacion de la tabla Paises
CREATE TABLE PAISES (
	PAIS_ID CHAR(2) NOT NULL,
	NOMBRE_PAIS VARCHAR2(40),
	REGION_ID NUMBER,
	CONSTRAINT PAIS_ID_PK PRIMARY KEY (PAIS_ID),
	CONSTRAINT REGION_ID_FK FOREIGN KEY (REGION_ID) REFERENCES REGIONES(REGION_ID)
);

-- Creacion de la tabla Localidades
CREATE TABLE LOCALIDADES (
	LOCALIDAD_ID NUMBER(4,0),
	DIRECCION VARCHAR2(40),
	CODIGO_POSTAL VARCHAR2(12),
	CIUDAD VARCHAR2(30) NOT NULL,
	ESTADO_PROVINCIA VARCHAR2(25),
	PAIS_ID CHAR(2),
	CONSTRAINT LOCALIDAD_ID_PK PRIMARY KEY (LOCALIDAD_ID),
	CONSTRAINT LOCALIDAD_PAIS_FK FOREIGN KEY (PAIS_ID) REFERENCES PAISES(PAIS_ID)
);

-- Creacion de la tabla trabajos
CREATE TABLE TRABAJOS (
	TRABAJO_ID VARCHAR2(10) NOT NULL,
	TRABAJO_TITULO VARCHAR2(35) NOT NULL,
	SALARIO_MINIMO NUMBER(6,0),
	SALARIO_MAXIMO NUMBER(6,0),
	CONSTRAINT TRABAJO_ID_PK PRIMARY KEY (TRABAJO_ID)
);

-- Creacion de la tabla Departamento
CREATE TABLE DEPARTAMENTOS (
	DEPARTAMENTO_ID NUMBER(4,0) NOT NULL,
	DEPARTAMENTO_NOMBRE VARCHAR2(30) NOT NULL,
	GERENTE_ID NUMBER(6,0),
	LOCALIDAD_ID NUMBER(4,0),
	CONSTRAINT DEPARTAMENTO_ID_PK PRIMARY KEY (DEPARTAMENTO_ID),
	CONSTRAINT LOCALIDAD_ID_FK FOREIGN KEY (LOCALIDAD_ID) REFERENCES LOCALIDADES(LOCALIDAD_ID)
);

-- Creacion de la tabla Empleados
CREATE TABLE EMPLEADOS (
	EMPLEADO_ID NUMBER(6,0) NOT NULL,
	NOMBRE VARCHAR2(20),
	APELLIDO VARCHAR2(25) NOT NULL,
	EMAIL VARCHAR2(25) NOT NULL,
	CELULAR VARCHAR2(20),
	FECHA_CONTRATO DATE NOT NULL,
	TRABAJO_ID VARCHAR2(10) NOT NULL,
	SALARIO NUMBER(8,2),
	COMISION_PCT NUMBER(2,2),
	DEPARTAMENTO_ID NUMBER(4),
	GERENTE_ID NUMBER(6),
	CONSTRAINT EMPLEADO_SALARIO_MIN CHECK (SALARIO > 0),
	CONSTRAINT EMPLEADO_EMAIL_UNI UNIQUE(EMAIL),
	CONSTRAINT EMPLEADOS_EMPLEADO_ID_PK PRIMARY KEY (EMPLEADO_ID),
	CONSTRAINT EMPLEADO_DEPARTAMENTO_FK FOREIGN KEY (DEPARTAMENTO_ID) REFERENCES DEPARTAMENTOS (DEPARTAMENTO_ID),
	CONSTRAINT EMPLEADO_TRABAJOS_FK FOREIGN KEY (TRABAJO_ID) REFERENCES TRABAJOS (TRABAJO_ID),
	CONSTRAINT EMPLEADO_JEFE_FK FOREIGN KEY (GERENTE_ID) REFERENCES EMPLEADOS (EMPLEADO_ID)
);

-- Creacion de la tabla historial trabajo
CREATE TABLE HISTORIAL_TRABAJO (
	EMPLEADO_ID NUMBER(6) NOT NULL,
	FECHA_INICIO DATE NOT NULL,
	FECHA_FIN DATE NOT NULL,
	TRABAJO_ID VARCHAR2(10) NOT NULL,
	DEPARTAMENTO_ID NUMBER(4),
	CONSTRAINT CONTROL_FECHAS_INICIO_FIN CHECK (FECHA_INICIO < FECHA_FIN),
	CONSTRAINT HIST_TRABAJO_EMPLEADO_ID_PK PRIMARY KEY (EMPLEADO_ID, FECHA_INICIO),
	CONSTRAINT HIST_TRABAJO_FK FOREIGN KEY (TRABAJO_ID) REFERENCES TRABAJOS(TRABAJO_ID),
	CONSTRAINT HIST_EMPLEADO_FK FOREIGN KEY (EMPLEADO_ID) REFERENCES EMPLEADOS(EMPLEADO_ID),
	CONSTRAINT HIST_DEPT_FK FOREIGN KEY (DEPARTAMENTO_ID) REFERENCES DEPARTAMENTOS(DEPARTAMENTO_ID)
);

-- ALTERS en Departamento
ALTER TABLE DEPARTAMENTOS ADD CONSTRAINT DPTO_GERENTE_ID FOREIGN KEY (GERENTE_ID) REFERENCES EMPLEADOS (EMPLEADO_ID);

-- INSERTS en la tabla regiones
INSERT INTO REGIONES(REGION_ID, NOMBRE_REGION)
VALUES (1, 'AMERICA DEL NORTE');

INSERT INTO REGIONES(REGION_ID, NOMBRE_REGION)
VALUES (2, 'AMERICA DEL SUR');

INSERT INTO REGIONES(REGION_ID, NOMBRE_REGION)
VALUES (3, 'AMERICA CENTRAL');

INSERT INTO REGIONES(REGION_ID, NOMBRE_REGION)
VALUES (4, 'ASIA ORIENTAL');

INSERT INTO REGIONES(REGION_ID, NOMBRE_REGION)
VALUES (5, 'ASIA DEL NORTE');

-- INSERTS EN LA TABLA PAISES
INSERT INTO PAISES(PAIS_ID, NOMBRE_PAIS, REGION_ID)
VALUES('1', 'PARAGUAY', 2);

INSERT INTO PAISES(PAIS_ID, NOMBRE_PAIS, REGION_ID)
VALUES('2', 'ARGENTINA', 2);

INSERT INTO PAISES(PAIS_ID, NOMBRE_PAIS, REGION_ID)
VALUES('3', 'BRAZIL', 2);

INSERT INTO PAISES(PAIS_ID, NOMBRE_PAIS, REGION_ID)
VALUES('4', 'BOLIVIA', 2);

INSERT INTO PAISES(PAIS_ID, NOMBRE_PAIS, REGION_ID)
VALUES('5', 'PERU', 2);

-- INSERTS en la tabla localidades
INSERT INTO LOCALIDADES(LOCALIDAD_ID, DIRECCION, CODIGO_POSTAL, CIUDAD, ESTADO_PROVINCIA, PAIS_ID)
VALUES(1, 'RUTA 1', '1000', 'CAPIATA', 'CENTRAL', '1');

INSERT INTO LOCALIDADES(LOCALIDAD_ID, DIRECCION, CODIGO_POSTAL, CIUDAD, ESTADO_PROVINCIA, PAIS_ID)
VALUES(2, 'RUTA 2', '1002', 'CAPIATA', 'CENTRAL', '1');

INSERT INTO LOCALIDADES(LOCALIDAD_ID, DIRECCION, CODIGO_POSTAL, CIUDAD, ESTADO_PROVINCIA, PAIS_ID)
VALUES(3, 'RUTA 3', '1004', 'CAPIATA', 'CENTRAL', '1');

INSERT INTO LOCALIDADES(LOCALIDAD_ID, DIRECCION, CODIGO_POSTAL, CIUDAD, ESTADO_PROVINCIA, PAIS_ID)
VALUES(4, 'RUTA 4', '1006', 'CAPIATA', 'CENTRAL', '1');

INSERT INTO LOCALIDADES(LOCALIDAD_ID, DIRECCION, CODIGO_POSTAL, CIUDAD, ESTADO_PROVINCIA, PAIS_ID)
VALUES(5, 'RUTA 5', '1008', 'CAPIATA', 'CENTRAL', '1');

-- INSERT en la tabla TRABAJOS
INSERT INTO TRABAJOS(TRABAJO_ID, TRABAJO_TITULO, SALARIO_MINIMO, SALARIO_MAXIMO)
VALUES('1', 'GERENTE', 300, 600);

INSERT INTO TRABAJOS(TRABAJO_ID, TRABAJO_TITULO, SALARIO_MINIMO, SALARIO_MAXIMO)
VALUES('2', 'DEVELOPER FRONTEND', 200, 400);

INSERT INTO TRABAJOS(TRABAJO_ID, TRABAJO_TITULO, SALARIO_MINIMO, SALARIO_MAXIMO)
VALUES('3', 'DEVELOPER MOBILE', 400, 800);

INSERT INTO TRABAJOS(TRABAJO_ID, TRABAJO_TITULO, SALARIO_MINIMO, SALARIO_MAXIMO)
VALUES('4', 'DEVOPS', 400, 800);

INSERT INTO TRABAJOS(TRABAJO_ID, TRABAJO_TITULO, SALARIO_MINIMO, SALARIO_MAXIMO)
VALUES('5', 'DBA', 400, 800);

-- INSERT en la tabla DEPARTAMENTOS
INSERT INTO DEPARTAMENTOS(DEPARTAMENTO_ID, DEPARTAMENTO_NOMBRE, LOCALIDAD_ID)
VALUES(1, 'GERENCIA', 1);

INSERT INTO DEPARTAMENTOS(DEPARTAMENTO_ID, DEPARTAMENTO_NOMBRE, LOCALIDAD_ID)
VALUES(2, 'RECURSOS HUMANOS', 1);

INSERT INTO DEPARTAMENTOS(DEPARTAMENTO_ID, DEPARTAMENTO_NOMBRE, LOCALIDAD_ID)
VALUES(3, 'TESTING', 1);

INSERT INTO DEPARTAMENTOS(DEPARTAMENTO_ID, DEPARTAMENTO_NOMBRE, LOCALIDAD_ID)
VALUES(4, 'DESARROLLO', 1);

INSERT INTO DEPARTAMENTOS(DEPARTAMENTO_ID, DEPARTAMENTO_NOMBRE, LOCALIDAD_ID)
VALUES(5, 'AUDITORIA', 1);

-- INSERT en la tabla Empleados
INSERT INTO EMPLEADOS(EMPLEADO_ID, NOMBRE, APELLIDO, EMAIL, CELULAR, FECHA_CONTRATO, TRABAJO_ID, SALARIO, COMISION_PCT, DEPARTAMENTO_ID)
VALUES(1, 'MATIAS', 'SOSA', 'sosa@gmail.com', '0982505151', '01/01/2020', '1', 300, 0, 1);

INSERT INTO EMPLEADOS(EMPLEADO_ID, NOMBRE, APELLIDO, EMAIL, CELULAR, FECHA_CONTRATO, TRABAJO_ID, SALARIO, COMISION_PCT, DEPARTAMENTO_ID, GERENTE_ID)
VALUES(2, 'MIGUEL', 'LOPEZ', 'lopez@gmail.com', '0982505154', '02/01/2020', '1', 300, 0, 1, 1);

INSERT INTO EMPLEADOS(EMPLEADO_ID, NOMBRE, APELLIDO, EMAIL, CELULAR, FECHA_CONTRATO, TRABAJO_ID, SALARIO, COMISION_PCT, DEPARTAMENTO_ID, GERENTE_ID)
VALUES(3, 'MIGUEL', 'GONZALEZ', 'gonzalez@gmail.com', '0982505156', '03/01/2020', '1', 300, 0, 1, 1);

INSERT INTO EMPLEADOS(EMPLEADO_ID, NOMBRE, APELLIDO, EMAIL, CELULAR, FECHA_CONTRATO, TRABAJO_ID, SALARIO, COMISION_PCT, DEPARTAMENTO_ID, GERENTE_ID)
VALUES(4, 'DENIS', 'CABALLERO', 'caballero@gmail.com', '0982505158', '04/01/2020', '1', 300, 0, 1, 1);

INSERT INTO EMPLEADOS(EMPLEADO_ID, NOMBRE, APELLIDO, EMAIL, CELULAR, FECHA_CONTRATO, TRABAJO_ID, SALARIO, COMISION_PCT, DEPARTAMENTO_ID, GERENTE_ID)
VALUES(5, 'MATEO', 'RAMOS', 'ramos@gmail.com', '0982505160', '05/01/2020', '1', 300, 0, 1, 1);

--Actualizacion tabla DEPARTAMENTOS
UPDATE DEPARTAMENTOS
SET GERENTE_ID = 1
WHERE DEPARTAMENTO_ID = 1;

UPDATE DEPARTAMENTOS
SET GERENTE_ID = 2
WHERE DEPARTAMENTO_ID = 2;

UPDATE DEPARTAMENTOS
SET GERENTE_ID = 3
WHERE DEPARTAMENTO_ID = 3;

UPDATE DEPARTAMENTOS
SET GERENTE_ID = 4
WHERE DEPARTAMENTO_ID = 4;

UPDATE DEPARTAMENTOS
SET GERENTE_ID = 5
WHERE DEPARTAMENTO_ID = 5;

-- INSERT de la tabla historial trabajo
INSERT INTO HISTORIAL_TRABAJO(EMPLEADO_ID, FECHA_INICIO, FECHA_FIN, TRABAJO_ID, DEPARTAMENTO_ID)
VALUES(1, '01/01/2020', '12/12/2020', 1, 1);

INSERT INTO HISTORIAL_TRABAJO(EMPLEADO_ID, FECHA_INICIO, FECHA_FIN, TRABAJO_ID, DEPARTAMENTO_ID)
VALUES(2, '02/01/2020', '12/12/2020', 1, 1);

INSERT INTO HISTORIAL_TRABAJO(EMPLEADO_ID, FECHA_INICIO, FECHA_FIN, TRABAJO_ID, DEPARTAMENTO_ID)
VALUES(3, '03/01/2020', '12/12/2020', 1, 1);

INSERT INTO HISTORIAL_TRABAJO(EMPLEADO_ID, FECHA_INICIO, FECHA_FIN, TRABAJO_ID, DEPARTAMENTO_ID)
VALUES(4, '04/01/2020', '12/12/2020', 1, 1);

INSERT INTO HISTORIAL_TRABAJO(EMPLEADO_ID, FECHA_INICIO, FECHA_FIN, TRABAJO_ID, DEPARTAMENTO_ID)
VALUES(5, '05/01/2020', '12/12/2020', 1, 1);

COMMIT;

--4- Construir un disparador que permita registrar en la tabla Historial de Trabajo los movimientos de un
--emplado, ya sea un cambio de departamento o un cambio de puesto de trabajo. Es decir, despu??s de cada
--actualizaci??n de los atributos id_trabajo y/o id_departamento de la tabla empleados. Se debe gestionar
--adecuadamente las excepciones que ocurran en los subprogramas.
CREATE OR REPLACE TRIGGER tr_hist_trab
AFTER UPDATE OF TRABAJO_ID, DEPARTAMENTO_ID ON EMPLEADOS
FOR EACH ROW
DECLARE
contadorIdDpto INTEGER;
contadorIdJobs INTEGER;
BEGIN
    SELECT COUNT(*) INTO contadorIdDpto FROM TRABAJOS T WHERE T.TRABAJO_ID = :NEW.TRABAJO_ID;
    SELECT COUNT(*) INTO contadorIdJobs FROM DEPARTAMENTOS D WHERE D.DEPARTAMENTO_ID = :NEW.DEPARTAMENTO_ID;
    IF(contadorIdDpto > 0 AND contadorIdJobs > 0) THEN
        INSERT INTO HISTORIAL_TRABAJO(EMPLEADO_ID, FECHA_INICIO, FECHA_FIN, TRABAJO_ID, DEPARTAMENTO_ID)
        VALUES(:OLD.EMPLEADO_ID, :OLD.FECHA_CONTRATO, SYSDATE, :OLD.TRABAJO_ID, :OLD.DEPARTAMENTO_ID);
    ELSE
        raise_application_error(-20001, 'Error id dpto o id trabajo');
    END IF;
END tr_hist_trab;
/

--5- Crear una vista llamada ???Vista_Empleados??? que nos muestra por cada empleado (id_empleado,
--Nombres + Apellidos, descripci??n del Trabajo actual, Nombres + Apellidos del Jefe, el
--Estado/Provincia/Dpto donde trabaja y a qu?? regi??n pertenece).
--
--empleado--> nombre, apellido, trabajo_id, gerente_id, dpto_id(null)
--trabajo--> trabajo_id, trabajo_titulo(null)
--empleado/gerente--> empleado_id, nombre, apellido
--dpto--> dto_id, localidad_id(null)
--localidad--> localidad_id, pais_id(null)
--paises--> pais_id, region_id(null)
--region--> region_id, nombre_region(null)
--
CREATE OR REPLACE VIEW VISTA_EMPLEADO(ID_EMPLEADO, NOMBRES_APELLIDOS, DESCRIPCION_TRABAJO_ACTUAL, NOMBRES_APELLIDOS_JEFE, ESTADO, REGION) AS
	   SELECT E.EMPLEADO_ID,
	   E.NOMBRE||''||E.APELLIDO,
	   T.TRABAJO_TITULO,
	   J.NOMBRE||''||J.APELLIDO,
           L.ESTADO_PROVINCIA,
	   R.NOMBRE_REGION
           FROM EMPLEADOS E
	   LEFT JOIN TRABAJOS T
	   ON E.TRABAJO_ID = T.TRABAJO_ID
	   LEFT JOIN EMPLEADOS J
	   ON E.GERENTE_ID = J.EMPLEADO_ID
	   LEFT JOIN DEPARTAMENTOS D
	   ON D.DEPARTAMENTO_ID = E.DEPARTAMENTO_ID
	   LEFT JOIN LOCALIDADES L
	   ON D.LOCALIDAD_ID = L.LOCALIDAD_ID
	   LEFT JOIN PAISES P
	   ON L.PAIS_ID = P.PAIS_ID
	   LEFT JOIN REGIONES R
	   ON P.REGION_ID = R.REGION_ID;

--6- Realice una consulta que nos muestre por cada registro del Historial de Trabajo: el id_empleado,
--Nombres + Apellidos del Empleado, Fecha de inicio de contrataci??n, Fecha de fin de contrataci??n, Nombre
--del Departamento, Nombre del Puesto o Cargo del Trabajo.

SELECT H.EMPLEADO_ID, E.NOMBRE||''||E.APELLIDO, H.FECHA_INICIO, H.FECHA_FIN, D.DEPARTAMENTO_NOMBRE, T.TRABAJO_TITULO
FROM HISTORIAL_TRABAJO H
LEFT JOIN TRABAJOS T
ON H.TRABAJO_ID = T.TRABAJO_ID
LEFT JOIN DEPARTAMENTOS D
ON D.DEPARTAMENTO_ID = H.DEPARTAMENTO_ID
LEFT JOIN EMPLEADOS E
ON H.EMPLEADO_ID = E.EMPLEADO_ID;

--Desconexion del usuario
DISCONNECT;
