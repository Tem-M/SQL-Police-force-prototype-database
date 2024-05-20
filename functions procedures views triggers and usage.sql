-- functions, procedures, views and triggers


use criminalCases
-- the view generates a combined data set where each case is mapped to the criminals, investigators, types and weapons associated to it
-- this view was written with the help of ChatGPT
-- I originally tried writing it with inner joins, but I ended up getting duplicate values in the aggregated cells, so I asked chat gpt to translate it to cross apply
-- cross apply doesn't generate duplicates because when you use join, you are joining for every table to every table,
-- where as in cross apply, you are generating a column based on every other table and applying it to the corresponding row in the base table
go
create VIEW combinedCaseData AS
SELECT
    c.caseID,
    c.caseLocation,
    c.caseOpenDate,
    c.losses AS Losses,
    c.dateCloseCase,
    c.description AS CaseDescription,
    cr.Criminals,
    t.Types,
    i.InvestigatorNames,
	w.Weapons
FROM
    cases c
cross APPLY (
    SELECT STRING_AGG(cr.FirstName + ' ' + cr.LastName, ', ') AS Criminals
    FROM criminalsToCases cc
    JOIN criminals cr ON cc.CriminalID = cr.CriminalID
    WHERE cc.CaseID = c.CaseID
) cr
cross APPLY (
    SELECT STRING_AGG(t.TypeDescription, ', ') AS Types
    FROM TypesToCases tc
    JOIN caseTypes t ON tc.TypeID = t.TypeID
    WHERE tc.CaseID = c.CaseID
) t
cross APPLY (
    SELECT STRING_AGG(i.FirstName + ' ' + i.LastName, ', ') AS InvestigatorNames
    FROM InvestigatorsToCases ic
    JOIN Investigators i ON ic.InvestigatorID = i.InvestigatorID
    WHERE ic.CaseID = c.CaseID
) i
cross APPLY (
	SELECT STRING_AGG(wi.weaponName, ', ') as Weapons
	from weaponsToCases wc 
	join weapons wi on wc.weaponId = wi.weaponId
	where wc.caseId = c.caseId
) w
GROUP BY
    c.caseID,
    c.caseLocation,
    c.caseOpenDate,
    c.dateCloseCase,
	c.losses,
	c.description,
	cr.Criminals,
	t.types,
	i.InvestigatorNames,
	w.Weapons;
go


-- select * from combinedCaseData
-- the procedure recieves case details and the weapons and crime types associated to it
-- and enters all the information to the correct tables
go
alter procedure PR_add_case
@caseLocation varchar(20),
@caseDate datetime,
@caseOpenDate datetime,
@losses varchar(50),
@dateCloseDate datetime,
@description varchar(300),
@types varchar(max), 
@weapons varchar(max)
as
	insert into cases (caseLocation, caseDate, caseOpenDate, losses, dateCloseCase, description)
	values( @caseLocation,
			@caseDate,
			case when @caseOpenDate is not null then @caseOpenDate else GETDATE() end,
			@losses,
			@dateCloseDate,
			@description)
	declare @caseId int = @@identity --(select top 1 caseId from cases order by caseId desc)
	
	begin try
	insert into typesToCases 
	select (select typeId from caseTypes where typeDescription like value) as typeId, @caseId as caseId from string_split(@types, ',')

	end try
	begin catch 
	print('no types assigned to case')
	end catch

	begin try
	insert into weaponsToCases 
	select (select weaponId from weapons where weaponName like value) as weaponID, @caseId as caseId from string_split(@weapons, ',')
	end try
	begin catch 
	print('no weapons assigned to case')
	end catch
	print('entered new case to database')
go


-- clean up
-- delete from weaponsToCases where caseId > 14
-- delete from typesToCases where caseId > 14
-- delete from cases where caseId > 14


go
-- the function recieves a case Id and returns investigators that specialize in the case
create function dbo.FN_recommend_investigators (@caseId int)
returns table
	as
	return (select * from investigators where investigatorId in (
		select investigatorId from investigators where specialty in (
			select typeId from typesToCases where caseId = @caseId
		) and busy = 0
	)
)
go


-- the procedure recieves a caseId and the guilty criminals id's and adds the data to the database
go
create procedure PR_solve_case 
@caseId int,
@criminalIds varchar(max)
as
	insert into criminalsToCases 
	select cast(value as int) criminalId, @caseId as caseId from string_split(@criminalIds, ',') 
go


go
-- the view is an alignment between criminals and the types of crimes they commited,
-- so that when we want to find criminals that commited a certain type of crime, 
-- we can search in the view, 
-- and when we want to find the types of crimes for a certain criminal, we can also look it up in the view
create view criminalsToCrimeTypes
as
select 
	ct.typeId as typeId,
	ct.typeDescription as typeDescription,
	cr.criminalId as criminalId,
	cr.firstName as firstName,
	cr.lastName as lastName
	
	from 
	(
		-- join types to their cases
		caseTypes ct join typesToCases CtC on ct.typeId = CtC.typeId
		join cases c on CtC.caseId = c.caseId
		-- join cases to their criminals
		join criminalsToCases CRtC on c.caseId = CRtC.caseId
		join criminals cr on cr.criminalId = CRtC.criminalId
	) 
	
go


-- the function gets a caseId and returns the possible suspects based on the above view
-- a possible suspect is a criminal that has commited a crime of one of the types assigned to the given case
-- notice: if the case already has assigned criminals, they will appear as suspects as well.
go
create function dbo.FN_possible_suspects (@caseId int) 
returns table
	as
	return
	select distinct cro.criminalId, cro.firstName + ' ' + cro.lastName as name, cro.height, cro.description, cro.age, string_agg(cr.types, ', ') types from 
	criminals cro 
	cross apply (
		select distinct typeId, typeDescription as types from criminalsToCrimeTypes cr where cro.criminalId = cr.criminalId
	) cr
	where cr.typeId in (
		select typeId from typesToCases where caseId= @caseId
	)
	group by cro.criminalId, cro.firstName + ' ' + cro.lastName, cro.height, cro.description, cro.age
go

-- the procedure recieves a caseId, and sets its close date to today, and frees all of it's investigators
go
create procedure PR_close_Case
@caseId int
as
	update cases set dateCloseCase = CONVERT(datetime, GETDATE()) where caseId = @caseId and dateCloseCase is null
	update investigators set busy = 0 where investigatorId in (select investigatorId from investigatorsToCases where caseId = @caseId)
go



-- the procedure recieves a case id and the amount of investigators wanted for the case, 
-- and returns the required amount of investigators that specialize in at least one type the case requires
-- which are also availiabe using the recommend investigators function
-- and also sets them to be busy and prints the chosen investigators
go
create procedure PR_assign_investigators
@caseId int,
@count int
as
	DECLARE @sql NVARCHAR(MAX);

	SET @sql = '
    INSERT INTO investigatorsToCases (investigatorId, caseId)
    SELECT TOP ' + CAST(@count AS NVARCHAR(10)) + ' investigatorId, ' + CAST(@caseId AS NVARCHAR(10)) + ' AS caseId
    FROM FN_recommend_investigators(' + CAST(@caseId AS NVARCHAR(10)) + ')
	';

	exec sp_executesql @sql

	update investigators set busy = 1 where investigatorId in (select investigatorId from investigatorsToCases where caseId = @caseId)
	
	declare @temp table (
		investigatorName varchar(50)
	)

	insert into @temp select firstName +  ' ' + lastName as investigatorName from investigators where investigatorId in (select investigatorId from investigatorsToCases where caseId = @caseId)
	
	declare @names varchar(max) = (select string_agg(investigatorName, ', ') as names from @temp)
	if exists(select * from @temp)
		print('investigators assigned for case: ' + @names)	
	else
		print('no availiabe investigators for the case')
go


-- the triggers log changes to the cases table
go
create trigger newCase on cases
for insert
as 
begin
	insert into logCases (actionType, caseId , caseLocation, caseDate, caseOpenDate, losses, dateCloseCase, description, actionDate, hostName, userName)
	select 'insert', caseId, caseLocation, caseDate, caseOpenDate, losses, dateCloseCase, description, GETDATE(), HOST_ID(), SUSER_NAME() from inserted
end 
go

go 
create trigger updateCase on cases
for update
as 
begin
	insert into logCases (actionType, caseId , caseLocation, caseDate, caseOpenDate, losses, dateCloseCase, description, actionDate, hostName, userName)
	select 'update', caseId, caseLocation, caseDate, caseOpenDate, losses, dateCloseCase, description, GETDATE(), HOST_ID(), SUSER_NAME() from inserted
	union select 'delete for update', caseId, caseLocation, caseDate, caseOpenDate, losses, dateCloseCase, description, GETDATE(), HOST_ID(), SUSER_NAME() from deleted
end
go

create trigger deleteCase on cases 
for delete
as 
begin
	insert into logCases (actionType, caseId , caseLocation, caseDate, caseOpenDate, losses, dateCloseCase, description, actionDate, hostName, userName)
	select 'delete', caseId, caseLocation, caseDate, caseOpenDate, losses, dateCloseCase, description, GETDATE(), HOST_ID(), SUSER_NAME() from deleted
end 
go


-- fix logs
-- truncate table logCases


-- the procedure recommends an order in which to find the criminals
-- we give priority to the criminals that commited more crimes
-- if we have conflict, we prefer to catch the younger ones first
go
create view most_wanted
	as
	select 
		cr.criminalId, 
		cr.firstName+ ' '+cr.lastName as name, 
		cr.height, 
		cr.description, 
		cr.age, 
		ROW_NUMBER() over (order by cr.crimeRating desc, age asc) as [wanted level] 
	from
		(select 
			cr.criminalId, 
			firstName, 
			lastName, 
			height,
			description, 
			age,  
			count(CtC.caseId) as crimeRating 
		from 
			criminals cr join criminalsToCases CtC on cr.criminalId = CtC.criminalId
		group by 
			cr.criminalId, 
			firstName,
			lastName,
			height,
			description, 
			age
		) cr
	group by 
	criminalId,
	firstName + ' ' +lastName, 
	height, 
	description, 
	age,
	cr.crimeRating	
go


create FUNCTION dbo.FN_which_criminal_to_catch_first(@id1 INT, @id2 INT)
RETURNS INT
AS
BEGIN
    RETURN CASE 
        WHEN (SELECT [wanted level] FROM most_wanted WHERE criminalId = @id1) < 
             (SELECT [wanted level] FROM most_wanted WHERE criminalId = @id2) 
        THEN @id1 
        ELSE @id2 
    END
END;
GO

go
create view first_two_cases
	as
	select 
		investigatorId, 
		firstName + ' ' + lastName name, 
		caseId,
		description 
	from (
		select 
			i.investigatorId, 
			firstName, 
			lastName, 
			c.caseId, 
			description, 
			ROW_NUMBER() over (partition by i.investigatorId order by caseDate asc) r
		from 
			investigators i join investigatorsToCases iTc 
			on i.investigatorId = iTc.investigatorId
			join cases c on iTc.caseId = c.caseId
	) iTc
	where r < 3
go


-- usage examples
select * from PR_first_two_cases

-- a crime happened, we have to add it to the database
exec PR_add_case @caseLocation ='City R', @caseDate='2023-03-01', @caseOpenDate = null, @losses = null, @description = null, @dateCloseDate=null, @types = '', @weapons = ''
print('case created')

-- see the addition in the log
select * from logCases

---- investigators came to a conclusion and the criminals we're found, so we will add the information
declare @new int = (select top 1 caseId from cases order by caseId desc);
print('new case id :' + convert(varchar(20), @new))
-- assign investigators to new case
exec PR_assign_investigators @caseId = @new, @count = 1
print('investigators assigned')


--find suspects for new case
select * from dbo.FN_possible_suspects(@new);
print('search for possible suspects')

-- TODO: randomize ids
exec PR_solve_case @caseId = 11, @criminalIds = '2'
print('investigation concluded')


-- we close the case
EXEC PR_close_case @caseId = 11
print('case closed')


go
-- clean up

-- delete from investigatorsToCases where caseId>=1000
-- delete from weaponsToCases where caseId>=1000
-- delete from criminalsToCases where caseId>=1000
-- delete from typesToCases where caseId>=1000
-- delete from cases where caseId>=1000

go
-- view all the info about cases in the database 
select * from combinedCaseData

-- decide which criminal to catch first
declare @res int
set @res = dbo.FN_which_criminal_to_catch_first (5,  9)
print(@res)


-- print first two cases for investigator John Smith
select * from PR_first_two_cases where name='John Smith'