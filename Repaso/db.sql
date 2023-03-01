drop database if exists Gimnasio;
create database Gimnasio;
use Gimnasio;

create table Sedes(
	id int primary key auto_increment,
	direccion varchar(60),
	nombre varchar(30));
describe Sedes;

create table Clases(
	id int primary key auto_increment,
	nombre varchar(30),
	horario datetime,
	capacidad int,
	id_sede int,
	constraint id_sede foreign key (id_sede) references Sedes(id));
describe Clases;

create table Socios(
	id int primary key auto_increment,
	nombre varchar(30),
	apellido varchar(30),
	nacimiento datetime,
	documento int(8));
describe Socios;

create table Reservas(
	id int primary key auto_increment,
	id_clase int,
	id_socio int,
	constraint id_clase foreign key (id_clase) references Clases(id),
	constraint id_socio foreign key (id_socio) references Socios(id));
describe Reservas;

create table Asistencias(
	id int primary key auto_increment,
	horario datetime,
	id_reserva int,
	constraint id_reserva foreign key (id_reserva) references Reservas(id));
describe Asistencias;

create table Estados(
	id int primary key auto_increment,
	nombre varchar(20));
describe Estados;

create table Planes(
	id int primary key auto_increment,
	nombre varchar(30),
	fecha_limite datetime,
	id_socio2 int,
	id_estado int,
	constraint id_socio2 foreign key (id_socio2) references Socios(id),
	constraint id_estado foreign key (id_estado) references Estados(id));
describe Planes;

create table Sesiones(
	id int primary key auto_increment,
	nombre varchar(30),
	id_plan int,
	constraint id_plan foreign key (id_plan) references Planes(id));
describe Sesiones;

create table Ejercicios(
	id int primary key auto_increment,
	nombre varchar(30),
	series int,
	repeticiones int,
	anotacion varchar(100),
	id_sesion int,
	constraint id_sesion foreign key (id_sesion) references Sesiones(id));
describe Ejercicios;

create table Registros(
	id int primary key auto_increment,
	nombre varchar(30),
	series int,
	repeticiones int,
	peso float,
	observacion varchar(100),
	id_ejercicio int,
	constraint id_ejercicio foreign key (id_ejercicio) references Ejercicios(id));
describe Registros;

/* Querys */

Select count(*) as CantidadSedes
From Sedes;

Select count(*) as CantidadClasesEsteMes
From Clases
Where 'horario' BETWEEN DATE_SUB( NOW( ) , INTERVAL 1 MONTH ) AND NOW( ) + INTERVAL 4 HOUR;

Select nombre, apellido, year(CURDATE()) - year(nacimiento) as 'EdadActual'
From Socios
Where 'EdadActual' > 18;

Select *
From Socios S JOIN Planes P ON S.id = P.id_socio2 JOIN Estados E ON P.id_estado = E.id
Where E.Nombre = 'Activo' and (day(P.fecha_limite) - day(CURDATE())) = 7;

Select *
From Planes P JOIN Sesiones S ON P.id = S.id_plan JOIN Ejercicios E ON S.id = E.id_sesion
Where P.nombre ='hipertrofia' and (E.series * E.repeticiones) > 12;

/* IMPOSIBLE ESTA CONSULTA, DEMASIADO HARDCORE
Select count(*) 
From Socios S JOIN Reservas R On S.id = R.id_socio JOIN Clases C ON R.id_clase = C.id
Where C.nombre = 'Musculacion' and capacidad
*/
