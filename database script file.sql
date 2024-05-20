create database [criminalCases]

USE [criminalCases]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_which_criminal_to_catch_first]    Script Date: 2/4/2024 11:46:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION [dbo].[FN_which_criminal_to_catch_first](@id1 INT, @id2 INT)
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
/****** Object:  Table [dbo].[caseTypes]    Script Date: 2/4/2024 11:46:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[caseTypes](
	[typeId] [int] IDENTITY(1,1) NOT NULL,
	[typeDescription] [varchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[typeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[investigators]    Script Date: 2/4/2024 11:46:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[investigators](
	[investigatorId] [int] IDENTITY(1,1) NOT NULL,
	[firstName] [varchar](20) NOT NULL,
	[lastName] [varchar](20) NOT NULL,
	[specialty] [int] NULL,
	[phoneNumber] [varchar](10) NULL,
	[hireDate] [datetime] NULL,
	[busy] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[investigatorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[criminals]    Script Date: 2/4/2024 11:46:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[criminals](
	[criminalId] [int] IDENTITY(1,1) NOT NULL,
	[firstName] [varchar](20) NULL,
	[lastName] [varchar](20) NULL,
	[height] [float] NULL,
	[age] [int] NULL,
	[description] [varchar](150) NULL,
PRIMARY KEY CLUSTERED 
(
	[criminalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[weapons]    Script Date: 2/4/2024 11:46:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[weapons](
	[weaponId] [int] IDENTITY(1,1) NOT NULL,
	[weaponDescription] [varchar](150) NULL,
	[weaponName] [varchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[weaponId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[cases]    Script Date: 2/4/2024 11:46:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cases](
	[caseId] [int] IDENTITY(1,1) NOT NULL,
	[caseLocation] [varchar](20) NOT NULL,
	[caseDate] [datetime] NOT NULL,
	[caseOpenDate] [datetime] NOT NULL,
	[losses] [varchar](50) NULL,
	[dateCloseCase] [datetime] NULL,
	[description] [varchar](300) NULL,
PRIMARY KEY CLUSTERED 
(
	[caseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[criminalsToCases]    Script Date: 2/4/2024 11:46:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[criminalsToCases](
	[entry] [int] IDENTITY(1,1) NOT NULL,
	[criminalId] [int] NOT NULL,
	[caseId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[entry] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[investigatorsToCases]    Script Date: 2/4/2024 11:46:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[investigatorsToCases](
	[entry] [int] IDENTITY(1,1) NOT NULL,
	[investigatorId] [int] NOT NULL,
	[caseId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[entry] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[weaponsToCases]    Script Date: 2/4/2024 11:46:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[weaponsToCases](
	[entry] [int] IDENTITY(1,1) NOT NULL,
	[weaponId] [int] NOT NULL,
	[caseId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[entry] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[typesToCases]    Script Date: 2/4/2024 11:46:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[typesToCases](
	[entry] [int] IDENTITY(1,1) NOT NULL,
	[typeId] [int] NOT NULL,
	[caseId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[entry] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[combinedCaseData]    Script Date: 2/4/2024 11:46:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create VIEW [dbo].[combinedCaseData] AS
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
GO
/****** Object:  UserDefinedFunction [dbo].[FN_recommend_investigators]    Script Date: 2/4/2024 11:46:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- the function recieves a case Id and returns investigators that specialize in the case
create function [dbo].[FN_recommend_investigators] (@caseId int)
returns table
	as
	return (select * from investigators where investigatorId in (
		select investigatorId from investigators where specialty in (
			select typeId from typesToCases where caseId = @caseId
		) and busy = 0
	)
)
GO
/****** Object:  View [dbo].[criminalsToCrimeTypes]    Script Date: 2/4/2024 11:46:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- the view is an alignment between criminals and the types of crimes they commited,
-- so that when we want to find criminals that commited a certain type of crime, 
-- we can search in the view, 
-- and when we want to find the types of crimes for a certain criminal, we can also look it up in the view
create view [dbo].[criminalsToCrimeTypes]
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
	
GO
/****** Object:  UserDefinedFunction [dbo].[FN_possible_suspects]    Script Date: 2/4/2024 11:46:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[FN_possible_suspects] (@caseId int) 
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
GO
/****** Object:  View [dbo].[most_wanted]    Script Date: 2/4/2024 11:46:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[most_wanted]
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
GO
/****** Object:  View [dbo].[first_two_cases]    Script Date: 2/4/2024 11:46:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[first_two_cases]
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
GO
/****** Object:  Table [dbo].[logCases]    Script Date: 2/4/2024 11:46:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[logCases](
	[entry] [int] IDENTITY(1,1) NOT NULL,
	[actionType] [varchar](20) NOT NULL,
	[caseId] [int] NOT NULL,
	[caseLocation] [varchar](20) NOT NULL,
	[caseDate] [datetime] NOT NULL,
	[caseOpenDate] [datetime] NOT NULL,
	[losses] [varchar](50) NULL,
	[dateCloseCase] [datetime] NULL,
	[description] [varchar](200) NULL,
	[actionDate] [datetime] NOT NULL,
	[hostName] [varchar](50) NOT NULL,
	[userName] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[entry] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cases] ADD  DEFAULT (getdate()) FOR [caseOpenDate]
GO
ALTER TABLE [dbo].[criminalsToCases]  WITH CHECK ADD FOREIGN KEY([caseId])
REFERENCES [dbo].[cases] ([caseId])
GO
ALTER TABLE [dbo].[criminalsToCases]  WITH CHECK ADD FOREIGN KEY([criminalId])
REFERENCES [dbo].[criminals] ([criminalId])
GO
ALTER TABLE [dbo].[investigators]  WITH CHECK ADD FOREIGN KEY([specialty])
REFERENCES [dbo].[caseTypes] ([typeId])
GO
ALTER TABLE [dbo].[investigatorsToCases]  WITH CHECK ADD FOREIGN KEY([caseId])
REFERENCES [dbo].[cases] ([caseId])
GO
ALTER TABLE [dbo].[investigatorsToCases]  WITH CHECK ADD FOREIGN KEY([investigatorId])
REFERENCES [dbo].[investigators] ([investigatorId])
GO
ALTER TABLE [dbo].[typesToCases]  WITH CHECK ADD FOREIGN KEY([caseId])
REFERENCES [dbo].[cases] ([caseId])
GO
ALTER TABLE [dbo].[typesToCases]  WITH CHECK ADD FOREIGN KEY([typeId])
REFERENCES [dbo].[caseTypes] ([typeId])
GO
ALTER TABLE [dbo].[weaponsToCases]  WITH CHECK ADD FOREIGN KEY([caseId])
REFERENCES [dbo].[cases] ([caseId])
GO
ALTER TABLE [dbo].[weaponsToCases]  WITH CHECK ADD FOREIGN KEY([weaponId])
REFERENCES [dbo].[weapons] ([weaponId])
GO
/****** Object:  StoredProcedure [dbo].[PR_add_case]    Script Date: 2/4/2024 11:46:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[PR_add_case]
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
	declare @caseId int = (select top 1 caseId from cases order by caseId desc)
	
	insert into typesToCases 
	select (select typeId from caseTypes where typeDescription like value) as typeId, @caseId as caseId from string_split(@types, ',')
	catch 
	print('no types assigned to case')


	insert into weaponsToCases 
	select (select weaponId from weapons where weaponName like value) as weaponID, @caseId as caseId from string_split(@weapons, ',')
	catch 
	print('no weapons assigned to case')

	print('entered new case to database')
GO
/****** Object:  StoredProcedure [dbo].[PR_assign_investigators]    Script Date: 2/4/2024 11:46:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[PR_assign_investigators]
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
GO
/****** Object:  StoredProcedure [dbo].[PR_close_Case]    Script Date: 2/4/2024 11:46:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[PR_close_Case]
@caseId int
as
	update cases set dateCloseCase = CONVERT(datetime, GETDATE()) where caseId = @caseId and dateCloseCase is null
	update investigators set busy = 0 where investigatorId in (select investigatorId from investigatorsToCases where caseId = @caseId)
GO
/****** Object:  StoredProcedure [dbo].[PR_solve_case]    Script Date: 2/4/2024 11:46:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[PR_solve_case] 
@caseId int,
@criminalIds varchar(max)
as
	insert into criminalsToCases 
	select cast(value as int) criminalId, @caseId as caseId from string_split(@criminalIds, ',') 
GO


go
insert into caseTypes (typeDescription) values('murder')
insert into caseTypes (typeDescription) values('kidnapping')
insert into caseTypes (typeDescription) values('hacking')
insert into caseTypes (typeDescription) values('identity theft')
insert into caseTypes (typeDescription) values('vandalism')
insert into caseTypes (typeDescription) values('cyber fraud')
insert into caseTypes (typeDescription) values('theft')


insert into criminals (firstName, lastName, height, age, description) values
	('John', 'Doe', 1.83, 30, 'Tall with a muscular build, dark hair, and a scar on the left cheek.'),
    ('Jane', 'Smith', 1.73, 42, 'Average height, blonde hair, wears glasses, and has a distinctive birthmark on the neck.'),
    ('Michael', 'Johnson', 1.88, 25, 'Tall and slim, with tattoos on both arms and a piercing on the right eyebrow.'),
    ('Sarah', 'Williams', 1.65, 28, 'Medium height, athletic build, with long black hair and a tattoo of a dragon on the right arm.'),
    ('Robert', 'Anderson', 1.78, 35, 'Well-built with a shaved head, wears a beard, and has a tribal tattoo on the neck.'),
    ('Emily', 'Brown', 1.75, 50, 'Average height, short curly hair, and often seen wearing a leather jacket.'),
    ('David', 'Clark', 1.85, 22, 'Tall and thin, with glasses and a distinctive birthmark on the forehead.'),
    ('Lisa', 'Taylor', 1.68, 38, 'Petite with long red hair, green eyes, and a small scar on the left hand.'),
    ('Daniel', 'Miller', 1.80, 45, 'Medium height, bald, with a large tattoo of a snake on the left forearm.'),
    ('Olivia', 'Moore', 1.83, 32, 'Athletic build, short black hair, and a piercing on the nose.'),
    ('James', 'White', 1.79, 27, 'Slim with glasses, brown hair, and a mole on the right cheek.'),
    ('Hannah', 'Jones', 1.70, 31, 'Average height, long blonde hair, and a tattoo of a butterfly on the wrist.'),
    ('Benjamin', 'Harris', 1.88, 40, 'Tall and muscular, with a beard and a scar on the right forearm.'),
    ('Ava', 'Miller', 1.65, 24, 'Petite with auburn hair, hazel eyes, and a nose ring.'),
    ('Ethan', 'Baker', 1.77, 37, 'Well-dressed with short black hair and a distinctive walk.'),
    ('Sophia', 'King', 1.72, 29, 'Average height, athletic build, with a tattoo of a tiger on the right shoulder.'),
    ('Christopher', 'Evans', 1.81, 33, 'Tall with blue eyes, a shaved head, and a cross tattoo on the neck.'),
    ('Emma', 'Cooper', 1.69, 26, 'Slim with curly brown hair and a small birthmark on the forehead.'),
    ('Liam', 'Fisher', 1.87, 34, 'Tall and athletic, with a scar on the left hand and a piercing on the lip.'),
    ('Mia', 'Scott', 1.74, 39, 'Average height, with long black hair and a tattoo of a star on the left ankle.'),
    ('William', 'Turner', 1.82, 28, 'Well-groomed with short brown hair, glasses, and a suit.');


insert into investigators (firstName, lastName, specialty, phoneNumber, hireDate) values
	('John', 'Smith', 1, '1234567890', '2020-01-15'),
    ('Jane', 'Johnson', 2, '9876543210', '2018-05-20'),
    ('Michael', 'Davis', 3, '1122334455', '2019-09-10'),
    ('Sarah', 'Taylor', 4, '1555666777', '2021-03-08'),
    ('Robert', 'Brown', 5, '1444333222', '2017-07-12'),
    ('Emily', 'Clark', 6, '1888777666', '2022-02-28'),
    ('David', 'Williams', 7, '1666999888', '2016-11-05'),
    ('Lisa', 'Moore', 1, '1222333444', '2023-06-18'),
    ('Daniel', 'Miller', 2, '1888999111', '2014-12-03'),
    ('Olivia', 'Anderson', 3, '1555444666', '2020-07-25'),
    ('James', 'Harris', 4, '1777888999', '2015-10-30'),
    ('Hannah', 'Evans', 5, '1999222333', '2019-04-14'),
    ('Benjamin', 'Baker', 6, '1333444555', '2018-08-22'),
    ('Ava', 'Turner', 7, '1444555666', '2021-11-12'),
    ('Ethan', 'Cooper', 1, '1666777888', '2017-02-09'),
    ('Sophia', 'Fisher', 2, '1222333777', '2022-05-04'),
    ('Christopher', 'Scott', 3, '1333777888', '2016-08-17'),
    ('Emma', 'King', 4, '1555888999', '2018-12-01'),
    ('Liam', 'Turner', 5, '1888999111', '2015-06-28');


insert into cases (caseLocation, caseDate, caseOpenDate, losses, dateCloseCase, description) values
    ('123 Main St', '2021-01-15', '2021-01-05', 'Financial and non-financial losses', '2021-03-15', 'Residential break-in at 123 Main St, Cityville on January 15th. Stolen items include electronics and jewelry, resulting in financial losses of $5,000.00.'),
    ('456 Oak Ave', '2020-09-30', '2020-07-12', 'Financial losses', '2020-09-30', 'Robbery at a local store located at 456 Oak Ave, Townsville on September 30th. Armed suspects demanded cash from store employees and fled with an undisclosed amount, resulting in financial losses of $15,000.50.'),
    ('789 Pine Rd', '2022-02-28', '2022-02-28', 'Financial losses', NULL, 'Cyber fraud incident on February 28th at 789 Pine Rd, Villagetown. Unauthorized access to individuals online accounts. Perpetrators executed fraudulent transactions, leading to substantial financial losses of $100,000.75.'),
    ('101 Elm Blvd', '2020-01-20', '2019-09-10', 'Non-financial losses', '2020-01-20', 'Vandalism at a public park located at 101 Elm Blvd, Hamletville on January 20th. Vandals defaced park structures and public property, causing non-financial losses estimated at $7,500.25.'),
    ('202 Cedar Ln', '2020-06-30', '2020-04-14', 'Financial losses', '2020-06-30', 'Identity theft and financial fraud between April 14th and June 30th at 202 Cedar Ln, Boroughburg. Perpetrators engaged in fraudulent financial activities, resulting in financial losses of $25,000.00.'),
    ('303 Maple St', '2022-11-05', '2022-11-05', 'Financial and non-financial losses', NULL, 'Kidnapping case on November 5th at 303 Maple St, Township. Ransom demands issued. The case is currently under active investigation.'),
    ('404 Birch Ave', '2019-04-20', '2018-12-01', 'Financial losses', '2019-04-20', 'Money laundering and organized crime between December 1st and April 20th at 404 Birch Ave, District City. Various means used to launder funds, resulting in substantial financial transactions under scrutiny.'),
    ('505 Walnut Rd', '2022-01-10', '2021-06-18', 'Financial losses', '2022-01-10', 'Theft of valuable artifacts on January 10th at a cultural institution located at 505 Walnut Rd, Metroville. Stolen artifacts, including paintings and sculptures, have an estimated value of $2,000.75.'),
    ('606 Ash Blvd', '2018-05-15', '2017-02-09', 'Financial losses', '2018-05-15', 'Arson incident in the early hours of May 15th at a commercial building located at 606 Ash Blvd, Suburbia. The fire caused extensive damage to the property, resulting in financial losses of $30,000.25.'),
    ('707 Spruce Ln', '2022-01-10', '2019-04-14', 'Financial losses', NULL, 'Hacking incident on January 10th at a business located at 707 Spruce Ln, Urbanville. Unauthorized access to the companys computer systems, compromising sensitive data and causing financial losses of $12,000.00. The investigation is ongoing.');


insert into typesToCases (typeId, caseId) values
	(1, 1),
    (2, 1),
    (7, 2),
    (6, 2),
    (5, 3),
    (4, 4),
    (2, 5),
    (4, 6),
    (7, 7),
    (5, 8),
    (3, 9);

insert into investigatorsToCases (investigatorId, caseId) values 
	(1, 1),
    (1, 1),
    (2, 1),
    (3, 2),
    (4, 2),
    (5, 3),
    (6, 3),
    (7, 4),
    (8, 4),
    (9, 5),
    (1, 5),
    (1, 6),
    (2, 7),
    (3, 8),
    (4, 8),
    (5, 8),
    (6, 9),
    (7, 9),
    (8, 10),
    (9, 10);


INSERT INTO weapons (weaponName, weaponDescription)
VALUES
    ('Plasma Blaster', 'A handheld blaster that shoots concentrated plasma bolts, capable of melting through armor.'),
    ('Quantum Sword', 'A sword infused with quantum energy, allowing it to cut through any material with ease.'),
    ('Laser Sniper Rifle', 'A high-powered sniper rifle equipped with a precision laser scope for long-range accuracy.'),
    ('Vortex Cannon', 'A device that creates small vortexes, capable of pulling in and immobilizing enemies.'),
    ('Neural Disruptor', 'A non-lethal weapon that disrupts neural signals, incapacitating targets temporarily.'),
    ('Nano Swarm Launcher', 'A launcher that releases swarms of nanobots to disable and disassemble electronic systems.'),
    ('Gravity Hammer', 'A melee weapon that manipulates gravitational fields to deliver devastating shockwaves.'),
    ('Plasma Grenade', 'A throwable grenade that releases a burst of plasma upon impact, sticking to surfaces.'),
    ('Railgun', 'A high-velocity electromagnetic projectile launcher, capable of penetrating thick armor.'),
    ('Energy Shield', 'A portable shield generator that absorbs and deflects incoming energy and projectile attacks.'),
    ('Sonic Disruptor', 'A weapon emitting powerful sonic waves, disorienting and damaging enemies.'),
    ('Molecular Destabilizer', 'A weapon that destabilizes the molecular structure of objects, causing them to disintegrate.'),
    ('EMP Pistol', 'A sidearm that emits an electromagnetic pulse, disabling electronic devices in the vicinity.'),
    ('Acid Sprayer', 'A handheld device that sprays corrosive acid, capable of eating through materials.'),
    ('Cryo Blaster', 'A blaster that shoots freezing beams, slowing down and freezing targets.'),
    ('Nanite Dagger', 'A dagger coated with nanobots that disassemble the molecular structure of whatever it cuts.'),
    ('Plasma Whip', 'A flexible whip that crackles with plasma energy, capable of electrifying and ensnaring targets.'),
    ('Particle Beam Cannon', 'A massive cannon that fires concentrated particle beams with incredible destructive power.'),
    ('Phase Shift Rifle', 'A rifle that temporarily shifts targets out of phase with reality, rendering them intangible.'),
    ('Tesla Coil Gauntlets', 'Gauntlets equipped with miniaturized tesla coils, delivering electric shocks to enemies.'),
    ('Biotic Pulser', 'A device that emits biotic pulses, healing allies and harming enemies within its radius.'),
    ('Graviton Surge Launcher', 'A launcher that releases graviton surges, creating localized gravitational anomalies.'),
    ('Pyro Flamethrower', 'A flamethrower that projects intense flames, burning targets over a wide area.'),
    ('Holographic Decoy Emitter', 'A device that creates holographic decoys to confuse and distract enemies.'),
    ('Neutron Star Cannon', 'A cannon that fires miniature neutron stars, causing massive gravitational disruption.'),
    ('Photon Disintegrator', 'A handheld disintegrator that shoots beams of intense photon energy.'),
    ('Quantum Entanglement Dagger', 'A dagger that utilizes quantum entanglement to instantly teleport to its target.'),
    ('Pulse Wave Shotgun', 'A shotgun that emits pulse waves, knocking back and stunning nearby enemies.'),
    ('Dark Matter Scythe', 'A scythe made from dark matter, capable of cutting through dimensions.'),
    ('Ionized Blade', 'A sword with an ionized edge, allowing it to cut through even the toughest materials.');


INSERT INTO weaponsToCases (weaponID, caseID)
VALUES
    (1, 1),
    (5, 1),
    (3, 2),
    (5, 2),
    (8, 2),
    (4, 3),
    (6, 3),
    (7, 4),
    (9, 4),
    (10, 5),
    (12, 5),
    (15, 5),
    (13, 6),
    (17, 6),
    (11, 7),
    (14, 7),
    (20, 7),
    (16, 8),
    (18, 8),
    (19, 8),
    (21, 8),
    (24, 8),
    (23, 9),
    (25, 9),
    (27, 9);

INSERT INTO criminalsToCases (criminalID, caseID)
VALUES
    (1, 1),
    (2, 1),
    (3, 1),
    (4, 2),
    (5, 2),
    (6, 2),
    (7, 3),
    (8, 3),
    (9, 3),
    (10, 4),
    (11, 4),
    (12, 4),
    (13, 4),
    (14, 4),
    (15, 4),
    (16, 5),
    (17, 5),
    (18, 5),
    (19, 6),
    (20, 6),
    (21, 6),
    (1, 7),
    (2, 7),
    (3, 7),
    (4, 8),
    (5, 8),
    (6, 7),
    (7, 8),
    (8, 8),
    (9, 8);