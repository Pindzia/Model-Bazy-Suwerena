declare @PESEL int
set @PESEL=100016
exec skladowanie @Pesel

declare @IDBUD int
set @IDBUD = 2
exec UPGRADE @IDBUD

declare @IDPANATAK int
declare @IDPANOBRON int
declare @PESEL_Randomowy int
set @IDPANATAK = 1
set @IDPANOBRON = 2
set @PESEL_Randomowy=100
exec Wojna @IDPANATAK,@IDPANOBRON,@PESEL_Randomowy




declare @NAZWA_SURH varchar(15)
declare @NAZWA_SURP varchar(15)
declare @ILOSC int
declare @PESEL_H int
declare @ID_PAN int
set @NAZWA_SURH = 'materia³_bud'
set @NAZWA_SURP = 'zloto'
set @ILOSC = 200
set @PESEL_H = 100012
set @ID_PAN = 1