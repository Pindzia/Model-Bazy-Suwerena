
---drop procedure skladowanie
create procedure skladowanie
	@PESEL int
as
begin
	if exists (select pesel_poddanego from Poddany where pesel_poddanego = @PESEL) and exists (select idMagazyn_Panstwa from Magazyn_Panstwa where id_panstwa = (select id_panstwa from Poddany where pesel_poddanego = @PESEL))
	begin
		insert into Transakcja(pesel_poddanego,zboze,materia³_bud,zloto,idMagazyn_Panstwa)
		values(@PESEL,(select zboze from Poddany where pesel_poddanego = @PESEL),(select materia³_bud from Poddany where pesel_poddanego = @PESEL),(select zloto from Poddany where pesel_poddanego = @PESEL),(select idMagazyn_Panstwa from Magazyn_Panstwa where id_panstwa=(select id_panstwa from Poddany where pesel_poddanego = @PESEL)))
		update Magazyn_Panstwa set zboze=(select zboze from Magazyn_Panstwa where id_panstwa=(select id_panstwa from Poddany where pesel_poddanego = @PESEL))+(select zboze from Poddany where pesel_poddanego = @PESEL) where id_panstwa=(select id_panstwa from Poddany where pesel_poddanego = @PESEL)
		update Poddany set zboze = 0 where pesel_poddanego = @PESEL
		update Magazyn_Panstwa set materia³_bud=(select materia³_bud from Magazyn_Panstwa where id_panstwa=(select id_panstwa from Poddany where pesel_poddanego = @PESEL))+(select materia³_bud from Poddany where pesel_poddanego = @PESEL) where id_panstwa=(select id_panstwa from Poddany where pesel_poddanego = @PESEL)
		update Poddany set materia³_bud = 0 where pesel_poddanego = @PESEL
		update Magazyn_Panstwa set zloto=(select zloto from Magazyn_Panstwa where id_panstwa=(select id_panstwa from Poddany where pesel_poddanego = @PESEL))+(select zloto from Poddany where pesel_poddanego = @PESEL) where id_panstwa=(select id_panstwa from Poddany where pesel_poddanego = @PESEL)
		update Poddany set zloto = 0 where pesel_poddanego = @PESEL
	end
end
---drop procedure UPGRADE
create procedure UPGRADE
	@IDBUD int
as
begin
	if exists (select nr_budowli from Budowla_Mieszkalna where nr_budowli = @IDBUD) and exists (select idMagazyn_Panstwa from Magazyn_Panstwa where id_panstwa = (select id_panstwa from Budowla_Mieszkalna where nr_budowli = @IDBUD))
	begin
	if((select wymagania from Budowla_Mieszkalna where nr_budowli = @IDBUD)<=(select materia³_bud from Magazyn_Panstwa where id_panstwa = (select id_panstwa from Budowla_Mieszkalna where nr_budowli = @IDBUD)))
		begin
		insert into Transakcja_Budowli(nr_budowli,materia³_bud,idMagazyn_Panstwa)
		values(@IDBUD,-(select wymagania from Budowla_Mieszkalna where nr_budowli = @IDBUD),(select idMagazyn_Panstwa from Magazyn_Panstwa where id_panstwa = (select id_panstwa from Budowla_Mieszkalna where nr_budowli = @IDBUD)))
		update Budowla_Mieszkalna set poziom_budowli = poziom_budowli+1 where nr_budowli = @IDBUD
		update Magazyn_Panstwa set materia³_bud = materia³_bud - (select wymagania from Budowla_Mieszkalna where nr_budowli = @IDBUD) where id_panstwa = (select id_panstwa from Budowla_Mieszkalna where nr_budowli = @IDBUD)
		update Budowla_Mieszkalna set wymagania = wymagania + 2000 where nr_budowli = @IDBUD
		end
	end
end

---drop procedure Wojna
create procedure Wojna
	@IDPANATAK int,
	@IDPANOBRON int,
	@PESEL_ZOLN_ZWYC int
as
begin
	if exists (select id_panstwa from Panstwo where id_panstwa = @IDPANATAK) and exists (select id_panstwa from Panstwo where id_panstwa = @IDPANOBRON)
	begin
		if (select [LABS\s396408].warunek_wojenny(@IDPANATAK)) = 1
		begin
			if(select [LABS\s396408].zwyciezca(@IDPANATAK,@IDPANOBRON)) = @IDPANATAK
			begin
			set @PESEL_ZOLN_ZWYC = (select TOP(1) pesel_poddanego from Poddany where id_panstwa = @IDPANATAK and umiejetnosc_poddanego = 'Zolnierz')
			insert into TransakcjaWojenna(pesel_poddanego,zboze,materia³_bud,zloto,idMagazyn_Panstwa)
			values(@PESEL_ZOLN_ZWYC,-(100*(select [LABS\s396408].roznica_wojny(@IDPANATAK,@IDPANOBRON))),-(100*(select [LABS\s396408].roznica_wojny(@IDPANATAK,@IDPANOBRON))),-(100*(select [LABS\s396408].roznica_wojny(@IDPANATAK,@IDPANOBRON))),(select idMagazyn_Panstwa from Magazyn_Panstwa where id_panstwa = @IDPANOBRON))
			update Magazyn_Panstwa set zboze = (select zboze from Magazyn_Panstwa where id_panstwa=@IDPANOBRON)-(100*(select [LABS\s396408].roznica_wojny(@IDPANATAK,@IDPANOBRON))) where id_panstwa = @IDPANOBRON
			update Poddany set zboze = (select zboze from Poddany where pesel_poddanego = @PESEL_ZOLN_ZWYC)+(100*(select [LABS\s396408].roznica_wojny(@IDPANATAK,@IDPANOBRON))) where pesel_poddanego = @PESEL_ZOLN_ZWYC
			update Magazyn_Panstwa set materia³_bud = (select materia³_bud from Magazyn_Panstwa where id_panstwa=@IDPANOBRON)-(100*(select [LABS\s396408].roznica_wojny(@IDPANATAK,@IDPANOBRON))) where id_panstwa = @IDPANOBRON
			update Poddany set materia³_bud = (select materia³_bud from Poddany where pesel_poddanego = @PESEL_ZOLN_ZWYC)+(100*(select [LABS\s396408].roznica_wojny(@IDPANATAK,@IDPANOBRON))) where pesel_poddanego = @PESEL_ZOLN_ZWYC
			update Magazyn_Panstwa set zloto = (select zloto from Magazyn_Panstwa where id_panstwa=@IDPANOBRON)-(100*(select [LABS\s396408].roznica_wojny(@IDPANATAK,@IDPANOBRON))) where id_panstwa = @IDPANOBRON
			update Poddany set zloto = (select zloto from Poddany where pesel_poddanego = @PESEL_ZOLN_ZWYC)+(100*(select [LABS\s396408].roznica_wojny(@IDPANATAK,@IDPANOBRON))) where pesel_poddanego = @PESEL_ZOLN_ZWYC
			Print 'Zwyciezca jest Atakujacy'
			end

			if(select [LABS\s396408].zwyciezca(@IDPANATAK,@IDPANOBRON)) = @IDPANOBRON
			begin
			set @PESEL_ZOLN_ZWYC = (select TOP(1) pesel_poddanego from Poddany where id_panstwa = @IDPANOBRON and umiejetnosc_poddanego = 'Zolnierz')
			insert into TransakcjaWojenna(pesel_poddanego,zboze,materia³_bud,zloto,idMagazyn_Panstwa)
			values(@PESEL_ZOLN_ZWYC,-(100*(select [LABS\s396408].roznica_wojny(@IDPANATAK,@IDPANOBRON))),-(100*(select [LABS\s396408].roznica_wojny(@IDPANATAK,@IDPANOBRON))),-(100*(select [LABS\s396408].roznica_wojny(@IDPANATAK,@IDPANOBRON))),(select idMagazyn_Panstwa from Magazyn_Panstwa where id_panstwa = @IDPANATAK))
			update Magazyn_Panstwa set zboze = (select zboze from Magazyn_Panstwa where id_panstwa=@IDPANATAK)-(100*(select [LABS\s396408].roznica_wojny(@IDPANATAK,@IDPANOBRON))) where id_panstwa = @IDPANATAK
			update Poddany set zboze = (select zboze from Poddany where pesel_poddanego = @PESEL_ZOLN_ZWYC)+(100*(select [LABS\s396408].roznica_wojny(@IDPANATAK,@IDPANOBRON))) where pesel_poddanego = @PESEL_ZOLN_ZWYC
			update Magazyn_Panstwa set materia³_bud = (select materia³_bud from Magazyn_Panstwa where id_panstwa=@IDPANATAK)-(100*(select [LABS\s396408].roznica_wojny(@IDPANATAK,@IDPANOBRON))) where id_panstwa = @IDPANATAK
			update Poddany set materia³_bud = (select materia³_bud from Poddany where pesel_poddanego = @PESEL_ZOLN_ZWYC)+(100*(select [LABS\s396408].roznica_wojny(@IDPANATAK,@IDPANOBRON))) where pesel_poddanego = @PESEL_ZOLN_ZWYC
			update Magazyn_Panstwa set zloto = (select zloto from Magazyn_Panstwa where id_panstwa=@IDPANATAK)-(100*(select [LABS\s396408].roznica_wojny(@IDPANATAK,@IDPANOBRON))) where id_panstwa = @IDPANATAK
			update Poddany set zloto = (select zloto from Poddany where pesel_poddanego = @PESEL_ZOLN_ZWYC)+(100*(select [LABS\s396408].roznica_wojny(@IDPANATAK,@IDPANOBRON))) where pesel_poddanego = @PESEL_ZOLN_ZWYC
			Print'Zwyciezca jest Obronca'
			end

			if(select [LABS\s396408].zwyciezca(@IDPANATAK,@IDPANOBRON)) = 0
			begin
			Print 'REMIS!!'
			end
		end
	end
end

---drop procedure Wymiana
create procedure Wymiana
	@NAZWA_SURH varchar(15),
	@NAZWA_SURP varchar(15),
	@ILOSC int,
	@PESEL_H int,
	@ID_PAN int
as
begin
	if exists (select id_panstwa from Panstwo where id_panstwa = @ID_PAN) and exists (select pesel_poddanego from Poddany where pesel_poddanego = @PESEL_H)
	begin
		if (([LABS\396408].handel_warunHandlarz(@PESEL_H,@NAZWA_SURH,@ILOSC)) = 1) and (([LABS\396408].handel_warunPanstwo(@ID_PAN,@NAZWA_SURH,@ILOSC))) = 1 and (@NAZWA_SURH !=@NAZWA_SURP)
		begin
			insert into TransakcjaHandlowa(pesel_poddanego,ilosc_wym,nazwa_sur_H,nazwa_sur_P,idMagazyn_Panstwa)
			values(@PESEL_H,@ILOSC,@NAZWA_SURH,@NAZWA_SURP,(select idMagazyn_Panstwa from Magazyn_Panstwa where id_panstwa = @ID_PAN))
			update Magazyn_Panstwa set @NAZWA_SURP = (select @NAZWA_SURP from Magazyn_Panstwa)-@ILOSC where id_panstwa = @ID_PAN
			update Magazyn_Panstwa set @NAZWA_SURH = (select @NAZWA_SURH from Magazyn_Panstwa)+@ILOSC where id_panstwa = @ID_PAN
			update Poddany set @NAZWA_SURP = (select @NAZWA_SURP from Poddany where pesel_poddanego = @PESEL_H)+@ILOSC where pesel_poddanego = @PESEL_H
			update Poddany set @NAZWA_SURH = (select @NAZWA_SURH from Poddany where pesel_poddanego = @PESEL_H)-@ILOSC where pesel_poddanego = @PESEL_H
		end
	end
end


declare @zm varchar(max)
declare @tabela varchar(max)
set @tabela = 'poddany'
set @zm = 'select * from ' +@tabela
exec sp_sqlexec @zm

