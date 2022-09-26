from pydantic import BaseModel
from typing import List

class Form(BaseModel):
	tid: int
	dist: float
	type: str

class Runde(BaseModel):
	nr: int
	tid: str
	avg_HRM: int
	max_HRM: int

class Trening(BaseModel):
	id: int
	dato: str
	overskrift: str
	kommentar: str
	rpe: int 
	dagsform: int 
	hoyde: int 

	intervall: bool

	former: List[Form]

	skade: bool
	skadeKommentar: str

	konkurranse: bool
	konk_tid: str 
	konk_fornoyd: int

	standardokt: bool
	st_navn: str 
	st_runder: List[Runde]
	st_alle_typer: List[str]