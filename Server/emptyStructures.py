import datetime

def get_empty_statistikk(fraDate, tilDate, statTyper):
	data = {"data": [],
		    "fraUke": fraDate.isocalendar()[1],
		    "fraAar": fraDate.isocalendar()[0],
		    "tilUke": tilDate.isocalendar()[1],
		    "tilAar": tilDate.isocalendar()[0],
		    "labels": [],
		    "statTyper": statTyper,
		    "spesifikkTyper": [],
		    "name": " "}

	date = fraDate
	index = 0
	while date <= tilDate:
		data["labels"].append(f"{date.isocalendar()[1]}-{date.isocalendar()[0]}")
		data["data"].append({"uke": index,
			                 "data": 0})
		date = date + datetime.timedelta(days=7)
		index += 1

	return data
