
CREATE table exponentiation (
	num             integer NOT NULL ,
	result          integer NOT NULL ,
)
GO

CREATE table squad (
	num             integer NOT NULL ,
	result          float NOT NULL ,
)
GO

delete from squad
delete from exponentiation
GO

Insert Into exponentiation(num,result) Values(2,4)
Insert Into exponentiation(num,result) Values(3,9)


Insert Into squad(num,result) Values(16,4)
Insert Into squad(num,result) Values(36,6)