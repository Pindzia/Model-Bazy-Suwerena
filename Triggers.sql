--drop trigger Skill
create trigger Skill
on Poddany
for  insert
as
	begin
	if((select zboze from Magazyn_Panstwa where id_panstwa=(select id_panstwa from inserted))>=(select zboze from Umiejetnosci where umiejetnosc_poddanego = (select umiejetnosc_poddanego from inserted))* -1) and
	((select materia³_bud from Magazyn_Panstwa where id_panstwa=(select id_panstwa from inserted))>=(select materia³_bud from Umiejetnosci where umiejetnosc_poddanego = (select umiejetnosc_poddanego from inserted))* -1) and
	((select zloto from Magazyn_Panstwa where id_panstwa=(select id_panstwa from inserted))>=(select zloto from Umiejetnosci where umiejetnosc_poddanego = (select umiejetnosc_poddanego from inserted))* -1)
		begin
					update Poddany set zboze = (select zboze from Umiejetnosci where umiejetnosc_poddanego = (select umiejetnosc_poddanego from inserted )) 
									  ,zloto = (select zloto from Umiejetnosci where umiejetnosc_poddanego = (select umiejetnosc_poddanego from inserted))
									  ,materia³_bud = (select materia³_bud from Umiejetnosci where umiejetnosc_poddanego = (select umiejetnosc_poddanego from inserted )) where pesel_poddanego = (select pesel_poddanego from inserted )
		end
		else
		begin
		rollback
		print 'Niemasz wystarczajacej ilosci œrodków'
		end
	end


--drop trigger Limit_poddanych
create trigger Limit_poddanych
on Poddany
for insert
as


	begin
	if (select id_panstwa from inserted)is null
		begin
		rollback
		print 'Podaj Pañstwo.Poddany musi mieæ Pañstwo'
		end
	else
		begin
		if((select count(bp.id_panstwa) from Panstwo p join Budowla_Mieszkalna bp on p.id_panstwa=bp.id_panstwa and p.id_panstwa=(select id_panstwa from inserted))=1)
				begin
				if (select Count(*) from Poddany where id_panstwa=(select id_panstwa from inserted)) <= ((select poziom_budowli from Budowla_Mieszkalna where id_panstwa=(select id_panstwa from inserted)) * 10)
						begin
						update Poddany set nr_budowli = (select bn.nr_budowli from Panstwo p join Budowla_Mieszkalna bn on p.id_panstwa = bn.id_panstwa where  p.id_panstwa = (select id_panstwa from inserted)) where pesel_poddanego = (select pesel_poddanego from inserted )
						end
						else
						begin
						rollback
						print 'Za ma³o miejsca.Rozbuduj Budowle mieszkaln¹ panstwa by wytworzyc wiecej poddanych'
						end
				end
				else
				begin
				rollback
				print 'Panstwo Niema Budynku Mieszkalnego'
				end
		end

	end

--drop trigger Limit_magazynu
create trigger Limit_magazynu
on Magazyn_Panstwa
for insert
as
	
	begin
			if(select id_panstwa from inserted)is null
					begin
					rollback
					print 'Podaj Pañstwo.Magazyn musi mieæ Pañstwo'
					end
		else
		begin	
			if ((select Count(*) from Panstwo p join Magazyn_Panstwa mp on p.id_panstwa = mp.id_panstwa where p.id_panstwa=(select id_panstwa from inserted))>1)
					begin
					rollback
					print 'Tylko jeden Magazyn'
					end
		end
	end
	

--drop trigger Limit_budowliMieszkalnej
create trigger Limit_budowliMieszkalnej
on Budowla_Mieszkalna
for insert
as
	begin
		if(select id_panstwa from inserted) is null
					begin
					rollback
					print 'Podaj Pañstwo.Budowla musi mieæ Pañstwo'
					end		
		else
		begin		
			if ((select Count(*) from Panstwo p join Budowla_Mieszkalna bp on p.id_panstwa = bp.id_panstwa where p.id_panstwa=(select id_panstwa from inserted))>1)
							begin
							rollback
							print 'Tylko jeden Budynek Mieszkalny'
							end
		end
	end

---drop trigger WarunekUSUNBUD
create Trigger WarunekUSUNBUD
on Budowla_Mieszkalna
for delete
as
	begin
	delete from Poddany where nr_budowli = (select nr_budowli from deleted)
	end