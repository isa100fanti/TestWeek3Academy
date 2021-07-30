create database DaLuigi

create table Pizza(
codice int not null,
nome varchar(20)not null,
prezzo decimal not null,
ningredienti int not null,
constraint pk_pizza primary key(codice),
constraint index_nome unique clustered(nome),
check (ningredienti > 0),
check (prezzo > 0)

)

create table Ingrediente(
codice int identity(1,1) not null,
nome varchar(20)not null,
costo decimal not null,
scortemagazzino int not null,
codicepizza int not null,
constraint pk_ingrediente primary key clustered (codice),
check (costo > 0),
constraint fk_ingred_pizza foreign key (codicepizza) references Pizza(codice)

)

insert into pizza values(123,'margherita',5,2),(124,'bufala',7,2),(125,'diavola',6,3),
(126,'quattro stagioni',6.5,5),(127,'porcini',7,3),(128,'dioniso',8,6),(129,'ortolana',8,3),
(130,'patate e salsiccia',6,3),(131,'pomodorini',6,3),(132,'quattro formaggi',7.5,4),
(133,'caprese',7.5,3),(134,'zeus',7.5,3)

insert into Ingrediente values('pomodoro',0.5,20,123),('pomodoro',0.5,20,124),('pomodoro',0.5,20,125),('pomodoro',0.5,20,126)
insert into Ingrediente values('mozzarella',1,15,123),('mozzarella',1,15,132),('mozzarella',1,15,133),('mozzarella',1,15,134),('mozzarella',1,15,131),('mozzarella',1,15,130)
insert into Ingrediente values('mozzarella bufala',2,9,124)
insert into Ingrediente values('salame piccante',1.5,3,125),('mozzarella',1,15,125)
select*from Pizza
insert into Ingrediente values('funghi porcini',2,6,127),('mozzarella',1,15,127),('pomodoro',0.5,20,127)
insert into Ingrediente values('funghi',1,7,126),('carciofi',1.5,7,126),('cotto',1,10,126),('olive',1,20,126),('mozzarella',1,15,126)
insert into Ingrediente values('stracchino',1,10,128),('rucola',1,10,128),('grana',2,6,128),('speck',2.5,3,128),('mozzarella',1,15,128),('pomodoro',0.5,20,128)
insert into Ingrediente values('verdure griglia',1.3,30,129),('mozzarella',1,15,129),('pomodoro',0.5,20,129)
insert into Ingrediente values('patate',1,10,130),('salsiccia',1.5,10,130)
insert into Ingrediente values('pomodorini',1,10,131),('ricotta',1.5,10,131)


--procedure nuova pizza
create procedure inserisciPizza(@nome varchar(20),@prezzo decimal)
as
begin
   begin try
   declare @ningredienti int
   declare @codicepizza int
   select @codicepizza = p.codice
   from pizza as p
   where p.nome = @nome
   select @ningredienti = p.ningredienti
   from pizza as p
   where p.nome = @nome
   insert into pizza (codice,nome,prezzo,ningredienti) values(@nome,@prezzo,@ningredienti,@codicepizza)

   end try
   begin catch
   select ERROR_LINE(),ERROR_MESSAGE(),ERROR_SEVERITY()
   end catch
end
exec inserisciPizza @nome = 'napoli',@prezzo = 6 --@codicepizza = 135,
select*from pizza









