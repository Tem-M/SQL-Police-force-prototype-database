-- create database
create database criminalCases

use criminalCases

-- create tables

create table caseTypes (
	typeId int constraint PK_caseTypes#typeid primary key identity(1,1) NOT NULL,
	typeDescription varchar(20) NOT NULL
)

create table investigators (
	investigatorId int primary key identity(1,1) NOT NULL,
	firstName varchar(20) NOT NULL,
	lastName varchar(20) NOT NULL,
	specialty int FOREIGN KEY references caseTypes(typeId),
	phoneNumber varchar(10),
	hireDate datetime
)

--create table criminalStatus (
--	statusId int primary key identity(1,1) NOT NULL,
--	statusDescription varchar(20) NOT NULL
--)

create table criminals (
	criminalId int primary key identity(1,1) NOT NULL,
	firstName varchar(20),
	lastName varchar(20),
	--criminalStatus int FOREIGN KEY references criminalStatus(statusId),
	height float,
	age int,
	description varchar(150)
)

--create table victimStatus (
--	statusId int primary key identity(1,1) NOT NULL,
--	statusDescription varchar(20) NOT NULL
--)

--create table victims (
--	victimId int primary key identity(1,1) NOT NULL,
--	firstName varchar(20), 
--	lastName varchar(20),
--	victimStatus int FOREIGN KEY references victimStatus(statusId),
--	phone varchar(10)
--)

create table weapons (
	weaponId int primary key identity(1,1) NOT NULL,
	weaponName varchar(20),
	weaponDescription varchar(50)
)

create table cases (
	caseId int primary key identity(1,1) NOT NULL,
	caseLocation varchar(20) NOT NULL,
	caseDate dateTime NOT NULL,
	caseOpenDate dateTime NOT NULL DEFAULT(GETDATE()),
	losses varchar(50),
	dateCloseCase dateTime,
	description varchar(200)
)

create table criminalsToCases (
	entry int primary key identity(1,1) NOT NULL,
	criminalId int foreign key references criminals(criminalId) NOT NULL,
	caseId int foreign key references cases(caseId) NOT NULL
)

create table investigatorsToCases (
	entry int primary key identity(1,1) NOT NULL,
	investigatorId int foreign key references investigators(investigatorId) NOT NULL,
	caseId int foreign key references cases(caseId) NOT NULL
)

create table weaponsToCases (
	entry int primary key identity(1,1) NOT NULL,
	weaponId int foreign key references weapons(weaponId) NOT NULL,
	caseId int foreign key references cases(caseId) NOT NULL
)

--create table victimsToCases (
--	entry int primary key identity(1,1) NOT NULL,
--	victimId int foreign key references victims(victimId) NOT NULL,
--	caseId int foreign key references cases(caseId) NOT NULL
--)

create table typesToCases (
	entry int primary key identity(1,1) NOT NULL,
	typeId int foreign key references caseTypes(typeId) NOT NULL,
	caseId int foreign key references cases(caseId) NOT NULL
)


create table logCases (
	entry int primary key identity(1,1) not null,
	actionType varchar(20) not null,
	caseId int NOT NULL,
	caseLocation varchar(20) NOT NULL,
	caseDate dateTime NOT NULL,
	caseOpenDate dateTime NOT NULL,
	losses varchar(50),
	dateCloseCase dateTime,
	description varchar(200),
	actionDate dateTime not null,
	hostName varchar(50) not null,
	userName varchar(50) not null,
)

 --adding data

-- addingg to caseTypes
insert into caseTypes (typeDescription) values('murder')
insert into caseTypes (typeDescription) values('kidnapping')
insert into caseTypes (typeDescription) values('hacking')
insert into caseTypes (typeDescription) values('identity theft')
insert into caseTypes (typeDescription) values('vandalism')
insert into caseTypes (typeDescription) values('cyber fraud')
insert into caseTypes (typeDescription) values('theft')

 --fixing dependencies and removing unneccisary tables

-- removing criminal status table
--alter table criminals drop constraint FK__criminals__crimi__3E52440B
--alter table criminals drop column criminalStatus
--drop table criminalStatus

-- removing victim status table
--alter table victims drop constraint FK__victims__victimS__4316F928
--alter table victims drop column victimStatus
--drop table victimStatus

-- fixing description data type for criminal table
alter table criminals drop column description
alter table criminals add description varchar(150)

 --adding data to criminals
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

-- adding data to investigators table
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

-- fixing description data type for cases table
alter table cases drop column description
alter table cases add description varchar(300)

-- adding data to cases table
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

-- creating alignment between cases and caseTypes using a cross-reference table
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

-- creating alignment between cases and investigators using a cross-reference table
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

-- fixing weaponDescription data type in weapons table
alter table weapons drop column weaponDescription
alter table weapons add weaponDescription varchar(150)

-- fixing weaponName data type in weapons table
alter table weapons drop column weaponName
alter table weapons add weaponName varchar(30)

-- removing more unnessicary tables
--drop table victimsToCases
--drop table victims

-- adding data to weapons table
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

-- creating alignment between cases and weapons using a cross-reference table
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

-- creating alignment between criminals and investigators using a cross-reference table
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

-- add busy column to investigators and assign values for data we entered earlier
alter table investigators add busy bit

update investigators set busy = 1 where investigatorId in 
(select investigatorId from investigatorsToCases join cases on investigatorsToCases.caseId = cases.caseId
where dateCloseCase is null) 

update investigators set busy = 0 where investigatorId not in 
(select investigatorId from investigatorsToCases join cases on investigatorsToCases.caseId = cases.caseId
where dateCloseCase is null) 

