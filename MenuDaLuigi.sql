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


-----------------FUNCTION-----------------------------

--tabella listino pizze ordine alfabetico
create function ListinoPizze ()
returns table
as
return
select p.nome,p.prezzo
from pizza as p

select*from dbo.ListinoPizze()

--listino pizze con un ingrediente
create function ListinoPizzeConUnIngrediente(@codiceingr int)
returns table
as
return
select p.nome as pizza,p.prezzo,i.nome as ingredienteScelto
from pizza as p
inner join Ingrediente as i
on i.codicepizza = p.codice
where i.nome =
ALL
(
select i.nome
from pizza as p
inner join Ingrediente as i
on i.codicepizza = p.codice
where i.codice = @codiceingr
group by i.nome)

select*from dbo.ListinoPizzeConUnIngrediente(4)

--n pizze con un ingrediente
create function NPizzeConUnIngrediente(@codiceingr int)
returns INT
as
begin
DECLARE @result int
SELECT @result = count(*)
from pizza as p
inner join Ingrediente as i
on i.codicepizza = p.codice
where i.nome =
ALL
(
select i.nome
from pizza as p
inner join Ingrediente as i
on i.codicepizza = p.codice
where i.codice = @codiceingr
group by i.nome)
return @result
end

select dbo.NPizzeConUnIngrediente(6) as nPizze,i.nome
from Ingrediente as i
where i.codice = 6

--n pizze senza ingrediente
create function NPizzeNOIngrediente(@codiceingr int)
returns INT
as
begin
DECLARE @result int
SELECT @result = count(*)
from pizza as p
--inner join Ingrediente as i
--on i.codicepizza = p.codice
where p.nome 
not in
(
select i.nome
from pizza as p
inner join Ingrediente as i
on i.codicepizza = p.codice
where i.codice = @codiceingr)
return @result
end

select*from Ingrediente

select dbo.NPizzeNOIngrediente(11)as nPizze,i.nome as 'ingrediente non presente'
from Ingrediente as i
where i.codice = 11

--n ingredienti in una pizza (codicepizza)
create function NingredientiPizza(@codicepizza int)
returns int
as
begin
DECLARE @result int
SELECT @result = count(*)
from pizza as p
join Ingrediente as i
on i.codicepizza = p.codice
where i.codicepizza = p.codice and p.nome
in(
select p.nome
from pizza as p
inner join Ingrediente as i
on i.codicepizza = p.codice
where @codicepizza = p.codice)
return @result

end

select dbo.NingredientiPizza(123) as nIngredienti,p.nome
from pizza as p





-----------------------PROCEDURE------------------------------

--elimina ingrediente: sarebbe
delete from Ingrediente where codice= 1 and codicepizza = 3


create procedure EliminaIngrediente @codicepizza int,@codiceingr int

as
begin
	begin try
	
	
		delete from Ingrediente where codice = @codiceingr and codicepizza
		in( --devo recuperare idpizza da ingr
		select i.codicepizza
		from Ingrediente as i
		join pizza as p
		on @codicepizza = i.codicepizza  
		
		)
	end try
	begin catch
	select ERROR_LINE(),ERROR_MESSAGE()
	end catch
end

exec EliminaIngrediente @codicepizza= 133,@codiceingr = 7






---???
--procedure nuova pizza
--SAREBBE
insert into pizza values(140,'napoli',7,2)



create procedure inserisciPizza(@nome varchar(20),@prezzo decimal)
as
begin
   begin try
   declare @ningredienti int
   declare @codicepizza int
   select @codicepizza = p.codice
   from pizza as p
   where p.nome = @nome and p.prezzo = @prezzo
   select @ningredienti = p.ningredienti
   from pizza as p
   where p.nome = @nome and p.prezzo = @prezzo
   insert into pizza values(@codicepizza,@nome,@prezzo,@ningredienti)

   end try
   begin catch
   select ERROR_LINE(),ERROR_MESSAGE(),ERROR_SEVERITY()
   end catch
end


--aggiungi ingrediente
create procedure InserisciIngrediente(@codicepizza int,@codiceingr int)
as
begin
    begin try
	
	declare @nomeingr varchar(20)
	declare @prezzoingr decimal
	declare @scorte int
	select @codiceingr = i.codice
	from Ingrediente as i
	where i.nome = @nomeingr and i.costo = @prezzoingr and i.scortemagazzino = @scorte
	insert into Ingrediente values(@nomeingr,@prezzoingr,@scorte,@codicepizza)
	end try
	begin catch
	select ERROR_LINE(),ERROR_MESSAGE(),ERROR_SEVERITY()
	end catch
end
select*from Ingrediente
exec InserisciIngrediente @codicepizza = 132, @codiceingr = 17






