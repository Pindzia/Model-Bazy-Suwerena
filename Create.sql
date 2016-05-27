-----------------Create---------------------

create table Panstwo (
  id_panstwa int identity(1,1) not null primary key,
  Nazwa varchar(20) not null,
)


create table Umiejetnosci (
  umiejetnosc_poddanego varchar(20) not null primary key check (umiejetnosc_poddanego like '[A-Z]%'),
  zboze int default 0,
  materia³_bud int default 0,
  zloto int default 0,
)


create table Budowla_Mieszkalna (
  nr_budowli int identity(1,1) not null primary key,
  poziom_budowli int not null default 1,
  wymagania int not null default 2000,
  id_panstwa int not null foreign key references Panstwo (id_panstwa),
)


create table Poddany (
  pesel_poddanego int identity (100000,1) not null primary key,
  id_panstwa int foreign key references Panstwo (id_panstwa),
  imie varchar(15) not null check (imie like '[A-Z]%'),
  nazwisko varchar(20) not null check (nazwisko like '[A-Z]%'),
  umiejetnosc_poddanego varchar(20) foreign key references Umiejetnosci (umiejetnosc_poddanego),
  zboze int default 0,
  materia³_bud int default 0,
  zloto int default 0,
  nr_budowli int foreign key references Budowla_Mieszkalna (nr_budowli),
)


create table Magazyn_Panstwa(
  idMagazyn_Panstwa int identity(1,1) not null primary key,
  id_panstwa int foreign key references Panstwo (id_panstwa),
  zboze int default 0,
  materia³_bud int default 0,
  zloto int default 0,
)


create table Transakcja (
  data_transakcji datetime not null primary key default GETDATE(),
  pesel_poddanego int foreign key references Poddany (pesel_poddanego),
  zboze int default 0,
  materia³_bud int default 0,
  zloto int default 0,
  idMagazyn_Panstwa int foreign key references Magazyn_Panstwa (idMagazyn_Panstwa),
)

create table Transakcja_Budowli (
  data_transakcji datetime not null primary key default GETDATE(),
  nr_budowli int foreign key references Budowla_Mieszkalna (nr_budowli),
  materia³_bud int default null,
  idMagazyn_Panstwa int foreign key references Magazyn_Panstwa (idMagazyn_Panstwa),
)

create table TransakcjaHandlowa (
  data_transakcji datetime not null primary key default GETDATE(),
  pesel_poddanego int foreign key references Poddany (pesel_poddanego),
  ilosc_wym int default 0,
  nazwa_sur_H varchar(15),
  nazwa_sur_P varchar(15),
  idMagazyn_Panstwa int foreign key references Magazyn_Panstwa (idMagazyn_Panstwa),
)

create table TransakcjaWojenna (
  data_transakcji datetime not null primary key default GETDATE(),
  pesel_poddanego int foreign key references Poddany (pesel_poddanego),
  zboze int default 0,
  materia³_bud int default 0,
  zloto int default 0,
  idMagazyn_Panstwa int foreign key references Magazyn_Panstwa (idMagazyn_Panstwa),
)