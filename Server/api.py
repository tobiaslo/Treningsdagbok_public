from typing import Optional

from fastapi import FastAPI, Request
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from fastapi.responses import HTMLResponse
from pydantic import BaseModel
from typing import List

from server import Server

from dataModel import Trening
import datetime

app = FastAPI()
server = Server()

@app.get("/oversikt/uke/{aar}/{nr}")
def get_uke(aar: int, nr: int, request: Request):
	"""
	Gets the overview of a specific training week. If both aar and nr is 0,
	the method will return the current week

	Args:
		aar (int): Argument from the URL. The year of the week that the method should get
		nr (int): Argument from URL. The week number that the method should get
	Returns:
		json: Returns a json file with the data
	"""

	if aar == 0 and nr == 0:
		date = datetime.date.today().isocalendar()
		aar = date[0]
		nr = date[1]
	return server.get_oversikt(aar, nr)



@app.get("/oversikt/uke/neste/{aar}/{nr}")
def get_neste_uke(aar: int, nr: int, request: Request):
	"""
	Gets the overview of the next week from a specific training week.

	Args:
		aar (int): Argument from the URL. The year of the specific week
		nr (int): Argument from URL. The week number of the specific week
	Returns:
		json: Returns a json file with the data
	"""

	date = datetime.datetime.strptime(f"{aar},{nr},1", "%G,%V,%u")
	date = date + datetime.timedelta(days=7)
	date = date.isocalendar()
	return server.get_oversikt(aar=date[0], uke=date[1])


@app.get("/oversikt/uke/forrige/{aar}/{nr}")
def get_forrige_uke(aar: int, nr: int, request: Request):
	"""
	Gets the overview of the last week from a specific training week. 

	Args:
		aar (int): Argument from the URL. The year of the specific week
		nr (int): Argument from URL. The week number of the specific week
	Returns:
		json: Returns a json file with the data
	"""

	date = datetime.datetime.strptime(f"{aar},{nr},1", "%G,%V,%u")
	date = date + datetime.timedelta(days=-7)
	date = date.isocalendar()
	return server.get_oversikt(aar=date[0], uke=date[1])


@app.get("/trening/{id}")
def get_trening(id: int, dato: str):
	"""
	Gets all the training details for a specific training

	Args:
		id (int): Argument from the URL. Training ID to the specific training.
			 	  The ID will be a datafield in the weekly overview
		dato (str): Query argument. Date of the training on the format "DD.MM.YYYY"
	Returns:
		json: Returns a json file with the data
	"""

	t = server.get_trening(id, dato)
	return t

@app.get("/trening/import_from_strava/{id}")
def get_trening_from_strava(id: int, dato: str):
	"""
	Gets all the training details for a specific training, with distances and times from strava.
	If training already exits the time and distances will bw overwritten

	Args:
		id (int): Argument from the URL. Training ID to the specific training.
			 	  The ID will be a datafield in the weekly overview
		dato (str): Query argument. Date of the training on the format "DD.MM.YYYY"
	Returns:
		json: Returns a json file with the data
	"""

	t = server.get_trening_from_strava(id, dato)
	return t

@app.post("/post")
def post(trening: Trening):
	"""
	Updates/makes new training.

	Args:
		trening (Trening): The data of the training that will be saved
	Returns:
		json: Updated overview of the week that the training is in.
	"""

	print(trening)
	date = datetime.datetime.strptime(trening.dato, "%d.%m.%Y")

	server.set_trening(trening.id, trening)

	return server.get_oversikt(aar=date.isocalendar()[0], uke=date.isocalendar()[1])


@app.get("/fjern/{id}")
def delete_trening(id: int, dato: str):
	"""
	Removes a training.

	Args:
		trening (Trening): The data of the training that will be removed
	Returns:
		json: Updated overview of the week that the training was in.
	"""
	date = datetime.datetime.strptime(dato, "%d.%m.%Y")

	server.delete(id, dato)
	return server.get_oversikt(aar=date.isocalendar()[0], uke=date.isocalendar()[1])


@app.get("/statistikk")
def get_statistikk(fraUke: int, fraAar: int, tilUke: int, tilAar: int, statType: int):
	"""
	Request statistics about a specific measure and specific time period

	Args:
		fraUke (int): Start week
		fraAar (int): Start year
		tilUke (int): End week
		fraAar (int): End year
		statType (int): Type of statistics that is requested.
					    Integer that represent the requestet type of statistics. 
					    Where 0: "Total tid", 1: "Tid løpt", 2: "Tid spesifikk", 
					    3: "Total distanse", 4: "Distanse løpt", 5: "Distanse spesifikk",
					    6: "Total stigning"
	Returns:
		json: test with statistics
	"""

	if fraUke == 0 and fraAar == 0 and tilUke == 0 and tilAar == 0:
		date = datetime.date.today()
		tilAar = date.isocalendar()[0]
		tilUke = date.isocalendar()[1]

		date = date - datetime.timedelta(days= 7*10)
		fraAar = date.isocalendar()[0]
		fraUke = date.isocalendar()[1]
	elif tilAar < fraAar or (tilAar == fraAar and tilUke < fraUke):
		fraUke = tilUke = fraAar = tilAar = 0

	
	return server.get_statistikk(fraUke=fraUke, fraAar=fraAar, tilUke=tilUke, tilAar=tilAar, statType=statType)

def main():
	import uvicorn
	uvicorn.run(app, host="127.0.0.1", port=8000)


if __name__ == '__main__':
	main()












