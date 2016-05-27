-----------------Select---------------------

select * from Panstwo
select * from Umiejetnosci
select * from Budowla_Mieszkalna
select * from Poddany
select * from Magazyn_Panstwa
select * from Transakcja
select * from Transakcja_Budowli
select * from TransakcjaHandlowa
select * from TransakcjaWojenna


----------------DROP------------------------

drop table Transakcja
drop table Transakcja_Budowli
drop table Magazyn_Panstwa
drop table Poddany
drop table Umiejetnosci
drop table Budowla_Mieszkalna
drop table Panstwo
drop table TransakcjaHandlowa


----------------VIEW-------------------------
--drop view podstawa
Create view podstawa(Panstwo,ilosc_podd)
as
select p.nazwa,Count(p1.pesel_poddanego) from Panstwo p join Poddany p1 on p.id_panstwa=p1.id_panstwa group by p.nazwa
select * from podstawa

--drop view PracownicyPanstw
--zly select zapytac!!
Create view PracownicyPanstw(Panstwo,Farmerzy,Zolnierze,Zlotnicy,Handlowcy,Budowlancy)
as
select p.nazwa, count(p1.umiejetnosc_poddanego),count(p2.umiejetnosc_poddanego),count(p3.umiejetnosc_poddanego),count(p4.umiejetnosc_poddanego),count(p5.umiejetnosc_poddanego) from Panstwo p left outer join Poddany p1 on p.id_panstwa = p1.id_panstwa and p1.umiejetnosc_poddanego='Farmer' left outer join Poddany p2 on p.id_panstwa = p2.id_panstwa and p2.umiejetnosc_poddanego='Zolnierz' left outer join Poddany p3 on p.id_panstwa = p3.id_panstwa and p3.umiejetnosc_poddanego='Zlotnik' left outer join Poddany p4 on p.id_panstwa = p4.id_panstwa and p4.umiejetnosc_poddanego='Handlarz' left outer join Poddany p5 on p.id_panstwa = p5.id_panstwa and p5.umiejetnosc_poddanego='Budowlaniec' group by p.nazwa
select * from PracownicyPanstw