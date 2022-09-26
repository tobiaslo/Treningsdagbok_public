# --- DATABASE ---

Databse to the project. Made after the ER-diagram from the pdf.

## Realisering

Trening(id, nr, dato, opplevd_anstrengelse, dagsform, overskrift, kommentar, høyde, intervall)
	- KN: id, {dato, nr}
	- PK: id

Form(type, trening, tid, distanse)
	- KN: {trening, type}
	- PK: {trening, type}

Bevegelsesform(id, navn)
	- KN: id
	- PK: id

Skade(id, kommentar, trening)
	- KN: id, trening
	- PK: id

Konkurranse(id, tid, fornøyd, trening)
	- KN: id, trening
	- PK: id
Standardøkt_list(id, navn, beskrivelse)
	- KN: id
	- PK: id

Standardøkt(id, type, trening)
	- KN: id, trening
	- PK: id

Runde(nr, standardøkt_id, tid, avg_HRM, max_HRM)
	- KN: {nr, standardøkt_id}
	- PK: {nr, standardøkt_id}

Fremmednøkkel
	Form(trening) -> Trening(id)
	From(type) -> Bevegelsesform(id)
	Skade(trening) -> Trening(id)
	Konkurranse(trening) -> Trening(id)
	Standardøkt(trening) -> Trening(id)
	Standardøkt(type) -> Standardøkt_list(id)
	Runde(standardøkt_id) -> Standardøkt(id)


## Usage

Start with
```
brew services start postgresql
```

Log in to database with test user
```
psql postgres -U newuser
```
Password to newuser is password.

Port to database is `5432` 