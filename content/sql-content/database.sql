
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




Insert Into exponentiation(num,result) Values(2,4)
Insert Into exponentiation(num,result) Values(3,9)



Insert Into squad(num,result) Values(16,4)
Insert Into squad(num,result) Values(36,6)