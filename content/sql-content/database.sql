
CREATE table Tarifa (
	IdTarifa             char(1)  NOT NULL ,
	PrecioVenta          money  NOT NULL ,
	Descripcion          varchar(50)  NOT NULL ,
	Horas                integer  NOT NULL ,
	PagoHora             money  NOT NULL 
)

GO



CREATE table exponentiation (
	num             integer NOT NULL ,
	result          integer NOT NULL ,
)
GO

CREATE table squad (
	num             integer NOT NULL ,
	result          integer NOT NULL ,
)
GO


Insert Into Tarifa(IdTarifa,PrecioVenta,Descripcion,Horas,PagoHora) Values('A',400,'Herramientas de Oficina',24,40)
Insert Into Tarifa(IdTarifa,PrecioVenta,Descripcion,Horas,PagoHora) Values('B',500,'SoftWare de Desarrollo - Basico',30,50)
Insert Into Tarifa(IdTarifa,PrecioVenta,Descripcion,Horas,PagoHora) Values('C',700,'SoftWare de Desarrollo - Intermedio/Avanzado',30,70)
Insert Into Tarifa(IdTarifa,PrecioVenta,Descripcion,Horas,PagoHora) Values('D',500,'Sistemas Operativos - Intermedio/Avanzado',24,50)
Insert Into Tarifa(IdTarifa,PrecioVenta,Descripcion,Horas,PagoHora) Values('E',700,'Administradores de Bases de Datos',30,60)




Insert Into exponentiation(num,result) Values(2,4)
Insert Into exponentiation(num,result) Values(3,9)



Insert Into squad(num,result) Values(14,4)
Insert Into squad(num,result) Values(36,6)