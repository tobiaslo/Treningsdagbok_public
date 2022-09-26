
BEGIN;

CREATE TABLE Trening (
	id SERIAL PRIMARY KEY,
	nr int NOT NULL,
	dato date NOT NULL,
	rpe int DEFAULT 0 CHECK (rpe >= 0 AND rpe <= 10),
	dagsform int DEFAULT 0 CHECK (dagsform >= 0 AND dagsform <= 10),
	overskrift text NOT NULL,
	kommentar text,
	hoyde int DEFAULT 0 CHECK (hoyde >= 0),
	intervall bool DEFAULT false,
	UNIQUE (nr, dato)
);

CREATE TABLE Bevegelsesform (
	id SERIAL PRIMARY KEY,
	navn text UNIQUE NOT NULL
);

CREATE TABLE Form (
	type int REFERENCES Bevegelsesform(id),
	trening int REFERENCES Trening(id) ON DELETE CASCADE,
	tid int NOT NULL CHECK (tid >= 0),
	distanse real DEFAULT 0.0,
	PRIMARY KEY (trening, type)
);

CREATE TABLE Skade (
	id SERIAL PRIMARY KEY,
	trening int UNIQUE REFERENCES Trening(id) ON DELETE CASCADE,
	kommentar text
);

CREATE TABLE Konkurranse (
	id SERIAL PRIMARY KEY,
	trening int UNIQUE REFERENCES Trening(id) ON DELETE CASCADE,
	fornoyd int NOT NULL CHECK (fornoyd >= 0 AND fornoyd <= 10),
	tid time NOT NULL
);

CREATE TABLE Standardokt_list (
	id SERIAL PRIMARY KEY,
	navn text NOT NULL,
	beskrivelse text
);

CREATE TABLE Standardokt (
	id SERIAL PRIMARY KEY,
	type int NOT NULL REFERENCES Standardokt_list(id),
	trening int NOT NULL UNIQUE REFERENCES Trening(id) ON DELETE CASCADE
);

CREATE TABLE Runder (
	nr int NOT NULL,
	st_id int REFERENCES Standardokt(id) ON DELETE CASCADE,
	tid time NOT NULL,
	avg_HRM int,
	max_HRM int,
	PRIMARY KEY (st_id, nr)
);

COMMIT;