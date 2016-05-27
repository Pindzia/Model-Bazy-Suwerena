--drop function warunek_wojenny
create function warunek_wojenny
	(@IDPANATAK int)
	returns bit
as
begin
	if (select count(p1.pesel_poddanego) from Panstwo p join Poddany p1 on p.id_panstwa=p1.id_panstwa and p.id_panstwa=@IDPANATAK where p1.umiejetnosc_poddanego = 'Zolnierz') > 0
		return 1
	return 0
end

--drop function roznica_wojny
create function roznica_wojny
	(@IDPANATAK int,@IDPANOBRON int)
	returns int
begin
declare @armiaA int
declare @armiaB int
declare @roznica int
 
set @armiaA=(select count(p1.pesel_poddanego) from Panstwo p join Poddany p1 on p.id_panstwa=p1.id_panstwa and p.id_panstwa=@IDPANATAK where p1.umiejetnosc_poddanego = 'Zolnierz')
set @armiaB=(select count(p1.pesel_poddanego) from Panstwo p join Poddany p1 on p.id_panstwa=p1.id_panstwa and p.id_panstwa=@IDPANOBRON where p1.umiejetnosc_poddanego = 'Zolnierz')
        if (@armiaA=@armiaB)
                return 0
       
        if(@armiaA>@armiaB)
                begin
                set @roznica = @armiaA - @armiaB
                return @roznica
                end
        set @roznica = @armiaB - @armiaA
        return @roznica
       
               
end

--drop function handel_warunHandlarz
create function handel_warunHandlarz
	(@IDHANDLARZA int, @SUROWIEC_H varchar(15) , @STA£A int)
	returns bit
as
begin
		if (@SUROWIEC_H =	 'zboze')
				begin
				if((select zboze from Poddany where pesel_poddanego= @IDHANDLARZA) >= @STA£A)
					return 1
				end
		if (@SUROWIEC_H =	 'zloto')
				begin
				if((select zloto from Poddany where pesel_poddanego= @IDHANDLARZA) >= @STA£A)
					return 1
				end
		if (@SUROWIEC_H =	 'materia³_bud')
				begin
				if((select materia³_bud from Poddany where pesel_poddanego= @IDHANDLARZA) >= @STA£A)
					return 1
				end
		return 0

end

--drop function handel_warunPanstwo
create function handel_warunPanstwo
	(@IDPANSTWA int, @SUROWIEC_P varchar(15) , @STA£A int)
	returns bit
as
begin
		if (@SUROWIEC_P =	 'zboze')
				begin
				if((select mp.zboze from Panstwo p join Magazyn_Panstwa mp on p.id_panstwa = mp.id_panstwa and p.id_panstwa = @IDPANSTWA) >= @STA£A)
					return 1
				end
		if (@SUROWIEC_P =	 'zloto')
				begin
				if((select mp.zboze from Panstwo p join Magazyn_Panstwa mp on p.id_panstwa = mp.id_panstwa and p.id_panstwa = @IDPANSTWA) >= @STA£A)
					return 1
				end
		if (@SUROWIEC_P =	 'materia³_bud')
				begin
				if((select mp.zboze from Panstwo p join Magazyn_Panstwa mp on p.id_panstwa = mp.id_panstwa and p.id_panstwa = @IDPANSTWA) >= @STA£A)
					return 1
				end
		return 0

end

--drop function zwyciezca
create function zwyciezca
	(@IDPANATAK int,@IDPANOBRON int)
	returns int
begin
declare @armiaA int
declare @armiaB int

 
set @armiaA=(select count(p1.pesel_poddanego) from Panstwo p join Poddany p1 on p.id_panstwa=p1.id_panstwa and p.id_panstwa=@IDPANATAK where p1.umiejetnosc_poddanego = 'Zolnierz')
set @armiaB=(select count(p1.pesel_poddanego) from Panstwo p join Poddany p1 on p.id_panstwa=p1.id_panstwa and p.id_panstwa=@IDPANOBRON where p1.umiejetnosc_poddanego = 'Zolnierz')
        if (@armiaA=@armiaB)
                return 0
       
        if(@armiaA>@armiaB)
                begin
                return @armiaA
                end
        return @armiaB
       
               
end