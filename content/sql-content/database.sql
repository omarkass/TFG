  CREATE DATABASE omar


CREATE TABLE dbo.Tarifa (
	IdTarifa             char(1)  NOT NULL ,
	PrecioVenta          money  NOT NULL ,
	Descripcion          varchar(50)  NOT NULL ,
	Horas                integer  NOT NULL ,
	PagoHora             money  NOT NULL 
)

Insert Into Tarifa(IdTarifa,PrecioVenta,Descripcion,Horas,PagoHora) Values('A',400,'Herramientas de Oficina',24,40)
Insert Into Tarifa(IdTarifa,PrecioVenta,Descripcion,Horas,PagoHora) Values('B',500,'SoftWare de Desarrollo - Basico',30,50)
Insert Into Tarifa(IdTarifa,PrecioVenta,Descripcion,Horas,PagoHora) Values('C',700,'SoftWare de Desarrollo - Intermedio/Avanzado',30,70)
Insert Into Tarifa(IdTarifa,PrecioVenta,Descripcion,Horas,PagoHora) Values('D',500,'Sistemas Operativos - Intermedio/Avanzado',24,50)
Insert Into Tarifa(IdTarifa,PrecioVenta,Descripcion,Horas,PagoHora) Values('E',700,'Administradores de Bases de Datos',30,60)