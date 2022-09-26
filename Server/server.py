import psycopg2
import psycopg2.extras
import json
import datetime

from dataModel import Trening
import emptyStructures

import gps_system

class Server():
	def __init__(self):
		dbname = # add database name
		user = # add database username
		pwd = # add database password
		host = '127.0.0.1'
	
		self.conn = psycopg2.connect(user=user,
									 password=pwd,
									 host=host,
									 port= #add port to database, 
									 database=dbname)

		cur = self.conn.cursor()
		cur.execute("SELECT navn, id FROM Standardokt_list;")
		res = cur.fetchall()

		self.alle_st = []
		for t in res:
			self.alle_st.append(t)

		self.gps_data = data_classes.Gps_points()


	def get_empty_oversikt(self, aar: int, ukenr: int):
		"""
		Args:
			aar (int): year of the week
			uke (int): weeknumber of the week
		Returns:
			json: Json on the format
				{
					'aar': (int)
					'nr': (int)
					'tot_dist': 0
					'tot_tid': 0
					'tot_ant': 0
					'dager': [
						{
							'dato': (str)
							'treninger': []
						},] 
				}
		"""
		date = datetime.datetime.strptime(f"{aar},{ukenr},1", "%G,%V,%u")
		dager = []
		for n in range(7):
			dag = {}
			dag['dato'] = (date + datetime.timedelta(days=n)).strftime("%d.%m.%Y")
			dag['treninger'] = []
			dager.append(dag)

		uke = {}
		uke['aar'] = aar
		uke['nr'] = ukenr
		uke['tot_dist'] = 0 
		uke['tot_tid'] = "00:00"
		uke['tot_ant'] = 0
		uke['dager'] = dager
		uke['pie_data'] = []
		uke['pie_labels'] = []

		return uke


	def get_oversikt(self, aar: int, uke: int):

		cur = self.conn.cursor()
		cur.execute("SELECT overskrift, dato, sum(form.tid) as tid, sum(form.distanse) as dist, rpe, trening.id  FROM trening JOIN form ON (trening.id = form.trening) WHERE DATE_PART('week', dato) = %s AND DATE_PART('year', dato) = %s GROUP BY trening.id ORDER BY dato;", (uke, aar))
		
		res = cur.fetchall()
		
	
		dager = self.get_empty_oversikt(aar=aar, ukenr=uke)

		nr = 0
		tot_dist = 0.0
		tot_tid = 0
		for n in res:
			d = {}
			t = {}
	
			t['overskrift'] = n[0]
			t['tid'] = n[2]
			t['dist'] = n[3]
			t['rpe'] = n[4]
			t['id'] = n[5]
			t['nr'] = nr
			nr += 1

			tot_tid += n[2]
			tot_dist += n[3]

			for dag in dager['dager']:
				if dag['dato'] == n[1].strftime("%d.%m.%Y"):
					dag['treninger'].append(t)
					continue

		dager['tot_dist'] = tot_dist
		dager['tot_tid'] = f"{int(tot_tid / 60)}:{tot_tid % 60}"
		dager['tot_ant'] = nr


		cur.execute("SELECT b.navn, sum(f.tid) FROM Form AS f JOIN Bevegelsesform AS b ON (f.type = b.id) JOIN Trening AS t ON (t.id = f.trening) WHERE DATE_PART('year', dato) = %s AND DATE_PART('week', dato) = %s GROUP BY b.navn;", (aar, uke))
		res = cur.fetchall()
		cur.close()

		for r in res:
			dager['pie_labels'].append(r[0])
			dager['pie_data'].append(r[1])

		return dager

	def get_empty_trening(self, dato: str):
		treningJSON = {}
		treningJSON['id'] = 0
		treningJSON['overskrift'] = ""
		treningJSON['dato'] = dato
		treningJSON['kommentar'] = ""
		treningJSON['rpe'] = 0
		treningJSON['dagsform'] = 0
		treningJSON['hoyde'] = 0

		treningJSON['intervall'] = False

		treningJSON['former'] = []
		

		treningJSON['skade'] = False
		treningJSON['skadeKommentar'] = ""

		treningJSON['konkurranse'] = False
		treningJSON['konk_tid'] = ""
		treningJSON['konk_fornoyd'] = 0

		treningJSON['standardokt'] = False
		treningJSON['st_navn'] = ""
		treningJSON['st_runder'] = []
		treningJSON['st_alle_typer'] = [ navn[0] for navn in self.alle_st ]

		cur = self.conn.cursor()
		cur.execute("SELECT navn FROM Bevegelsesform;")
		res = cur.fetchall()

		for t in res:
			f = {}
			f['type'] = t[0]
			f['tid'] = 0
			f['dist'] = 0

			treningJSON['former'].append(f)

		cur.close()

		return treningJSON

	def get_trening(self, id: int, dato: str):

		if id == 0:
			return self.get_empty_trening(dato)

		cur = self.conn.cursor()
		cur.execute("SELECT t.id, t.overskrift, t.kommentar, t.rpe, t.dagsform, t.hoyde, t.intervall, b.navn, f.tid, f.distanse, t.dato FROM trening AS t, form AS f, bevegelsesform AS b WHERE b.id = f.type AND f.trening = t.id AND t.id = %s;", (id,))
		res = cur.fetchall()
		
		try:
			trening = res[0]
		except:
			trening = self.get_empty_trening(dato)
			trening['kommentar'] = "Fant ingen trening"
			return trening
		
		treningJSON = self.get_empty_trening(trening[10].strftime("%d.%m.%Y"))

		treningJSON['id'] = trening[0]
		treningJSON['overskrift'] = trening[1].capitalize()
		treningJSON['kommentar'] = trening[2]
		treningJSON['rpe'] = trening[3]
		treningJSON['dagsform'] = trening[4]
		treningJSON['hoyde'] = trening[5]
		treningJSON['intervall'] = trening[6]

		for form in res:
			for form_in_JSON in treningJSON['former']:
				if form_in_JSON['type'] == form[7]:
					form_in_JSON['tid'] = form[8]
					form_in_JSON['dist'] = form[9]
					continue

		cur.execute("SELECT kommentar FROM Skade WHERE trening = %s;", (treningJSON['id'],))
		res = cur.fetchall()

		if len(res) == 1:
			treningJSON['skade'] = True
			treningJSON['skadeKommentar'] = res[0][0]

		cur.execute("SELECT tid, fornoyd FROM Konkurranse WHERE trening = %s;", (treningJSON['id'],))
		res = cur.fetchall()

		if len(res) == 1:
			treningJSON['konkurranse'] = True
			treningJSON['konk_tid'] = res[0][0]
			treningJSON['konk_fornoyd'] = res[0][1]

		cur.execute("SELECT navn, nr, tid, avg_HRM, max_HRM FROM Standardokt AS s JOIN Runder AS r ON (s.id = r.st_id) JOIN Standardokt_list AS sl ON (sl.id = s.type) WHERE s.trening = %s;", (id,))
		res = cur.fetchall()

		if len(res) > 0:
			treningJSON['standardokt'] = True
			treningJSON['st_navn'] = res[0][0]

			for r in res:
				runde = {}
				runde['nr'] = r[1]
				runde['tid'] = r[2]
				runde['avg_HRM'] = r[3]
				runde['max_HRM'] = r[4]
				treningJSON['st_runder'].append(runde)

		cur.close()
		return treningJSON

	def get_trening_from_strava(self, id, dato):
		treningJSON = self.get_trening(id, dato)

		totalsJSON = gpx_system.get_totals(dato, self.gps_data)

		for typ in treningJSON['former']:
			if typ['type'] in totalsJSON:
				typ['tid'] = totalsJSON[typ['type']]['tid']
				typ['dist'] = totalsJSON[typ['type']]['dist']
			else:
				typ['tid'] = 0
				typ['dist'] = 0
				
		return treningJSON


	def set_trening(self, id: int, trening: Trening):

		if (id == 0):
			self.make_trening(id, trening)
		elif (id > 0):
			self.update_trening(id, trening)
		else:
			print(f"Something is wrong with database and trening with id {id}")


	def update_trening(self, id: int, t: Trening):
		print(f"Going to update trening {id} with overskrift {t.overskrift}")
		cur = self.conn.cursor()

		cur.execute("SELECT navn, id FROM Bevegelsesform;")
		alle_former = cur.fetchall()

		cur.execute("""
			UPDATE trening
			SET overskrift = %s, kommentar = %s, rpe = %s, dagsform = %s, hoyde = %s, intervall = %s
			WHERE id = %s;""",
			(t.overskrift, t.kommentar, t.rpe, t.dagsform, t.hoyde, t.intervall, t.id))

		cur.execute("DELETE FROM Form WHERE trening = %s;", (t.id,))

		for form in t.former:
			if form.tid > 0:
				form_type = 0
				for f in alle_former:
					if form.type == f[0]:
						form_type = f[1]

				cur.execute("INSERT INTO Form (type, trening, tid, distanse) VALUES (%s, %s, %s, %s);", (form_type, t.id, form.tid, form.dist))

		cur.execute("DELETE FROM Skade WHERE trening = %s;", (id,))

		if t.skade:
			cur.execute("INSERT INTO Skade (trening, kommentar VALUES (%s, %s))", (id, t.skadeKommentar))

		cur.execute("DELETE FROM Konkurranse WHERE trening = %s;", (id,))

		if t.konkurranse:
			cur.execute("INSERT INTO Konkurranse (trening, fornoyd, tid) VALUES (%s, %s, %s)", (id, t.konk_fornoyd, datetime.datetime.strptime(t.konk_tid, "%H:%M:%S")))

		cur.execute("DELETE FROM Standardokt WHERE trening = %s;", (id,))
		if t.standardokt:

			st_type = 0
			for s in self.alle_st:
				if t.st_navn == s[0]:
					st_type = s[1]

			cur.execute("INSERT INTO Standardokt (type, trening) VALUES (%s, %s);", (st_type, id))

			if len(t.st_runder) > 0:
				for r in range(len(t.st_runder)):
					if t.st_runder[r].tid != "":
						runde = t.st_runder[r]
						cur.execute("INSERT INTO Runder (nr, st_id, tid, avg_HRM, max_HRM) VALUES (%s, currval('standardokt_id_seq'), %s, %s, %s);", (r, runde.tid, runde.avg_HRM, runde.max_HRM))

		self.conn.commit()

	def make_trening(self, id: int, t: Trening):
		print(f"Going to make new trening with overskrift {t.overskrift}")
		print(datetime.datetime.strptime(t.dato, "%d.%m.%Y"))

		cur = self.conn.cursor()

		cur.execute("SELECT navn, id FROM Bevegelsesform;")
		alle_former = cur.fetchall()
		cur.execute("SELECT count(*) FROM Trening WHERE dato = %s;", (datetime.datetime.strptime(t.dato, "%d.%m.%Y"),))
		nr = cur.fetchall()[0]

		cur.execute("INSERT INTO Trening (nr, dato, overskrift, kommentar, rpe, dagsform, hoyde, intervall) VALUES (%s, %s, %s, %s, %s, %s, %s, %s);",
					(nr, datetime.datetime.strptime(t.dato, "%d.%m.%Y"), t.overskrift, t.kommentar, t.rpe, t.dagsform, t.hoyde, t.intervall))

		for form in t.former:
			if form.tid > 0:
				form_type = 0
				for f in alle_former:
					if form.type == f[0]:
						form_type = f[1]

				cur.execute("INSERT INTO Form (type, trening, tid, distanse) VALUES (%s, currval('trening_id_seq'), %s, %s);", (form_type, form.tid, form.dist))

		if t.skade:
			cur.execute("INSERT INTO Skade (trening, kommentar)", (id, t.skadeKommentar))

		if t.konkurranse:
			cur.execute("INSERT INTO Konkurranse (trening, fornoyd, tid) VALUES (currval('trening_id_seq'), %s, %s)", (id, t.konk_fornoyd, datetime.datetime.strptime(t.konk_tid, "%H:%M:%S")))

		if t.standardokt:

			st_type = 0
			for s in self.alle_st:
				if t.st_navn == s[0]:
					st_type = s[1]

			cur.execute("INSERT INTO Standardokt (type, trening) VALUES (%s, currval('trening_id_seq'));", (st_type,))

			if len(t.st_runder) > 0:
				for r in range(len(t.st_runder)):
					if t.st_runder[r].tid != "":
						runde = t.st_runder[r]
						cur.execute("INSERT INTO Runder (nr, st_id, tid, avg_HRM, max_HRM) VALUES (%s, currval('standardokt_id_seq'), %s, %s, %s);", (r, runde.tid, runde.avg_HRM, runde.max_HRM))

		cur.close()
		self.conn.commit()

	def delete(self, id: int, dato: str):
		cur = self.conn.cursor()
		cur.execute("SELECT dato FROM Trening WHERE id = %s;", (id,))
		res = cur.fetchall()

		if len(res) == 1 and res[0][0].strftime("%d.%m.%Y") == dato:
			cur.execute("DELETE FROM Trening WHERE id = %s;", (id,))
			self.conn.commit()
		else:
			print("No match with date and id")

		cur.close()

	def get_statistikk_query(self, statType: str):
		if statType == "Total tid":
			query = """SELECT DATE_PART('year', dato), DATE_PART('week', dato), sum(form.tid)/60.0::float
		           FROM trening JOIN form ON (trening.id = form.trening)
		           WHERE dato >= %s AND dato <= %s
		           GROUP BY DATE_PART('year', dato), DATE_PART('week', dato)
		           ORDER BY DATE_PART('year', dato), DATE_PART('week', dato);"""
			return query
		elif statType == "Tid løpt":
			query = """SELECT DATE_PART('year', dato), DATE_PART('week', dato), sum(form.tid)/60.0::float
		           FROM trening JOIN form ON (trening.id = form.trening) JOIN bevegelsesform AS b ON (form.type = b.id)
		           WHERE dato >= %s AND dato <= %s AND b.navn LIKE 'Løp%%'
		           GROUP BY DATE_PART('year', dato), DATE_PART('week', dato)
		           ORDER BY DATE_PART('year', dato), DATE_PART('week', dato);"""
			return query
		elif statType == "Tid spesifikk":
			query = """SELECT DATE_PART('year', dato), DATE_PART('week', dato), sum(form.tid)/60.0::float
		           FROM trening JOIN form ON (trening.id = form.trening) JOIN bevegelsesform AS b ON (form.type = b.id)
		           WHERE dato >= %s AND dato <= %s AND b.navn = %s
		           GROUP BY DATE_PART('year', dato), DATE_PART('week', dato)
		           ORDER BY DATE_PART('year', dato), DATE_PART('week', dato);"""
			return query
		elif statType == "Total distanse":
			query = """SELECT DATE_PART('year', dato), DATE_PART('week', dato), sum(form.distanse)
		           FROM trening JOIN form ON (trening.id = form.trening)
		           WHERE dato >= %s AND dato <= %s
		           GROUP BY DATE_PART('year', dato), DATE_PART('week', dato)
		           ORDER BY DATE_PART('year', dato), DATE_PART('week', dato);"""
			return query
		elif statType == "Distanse løpt":
			query = """SELECT DATE_PART('year', dato), DATE_PART('week', dato), sum(form.distanse)
		           FROM trening JOIN form ON (trening.id = form.trening) JOIN bevegelsesform AS b ON (form.type = b.id)
		           WHERE dato >= %s AND dato <= %s AND b.navn LIKE 'Løp%%'
		           GROUP BY DATE_PART('year', dato), DATE_PART('week', dato)
		           ORDER BY DATE_PART('year', dato), DATE_PART('week', dato);"""
			return query
		elif statType == "Distanse spesifikk":
			query = """SELECT DATE_PART('year', dato), DATE_PART('week', dato), sum(form.distanse)
		           FROM trening JOIN form ON (trening.id = form.trening) JOIN bevegelsesform AS b ON (form.type = b.id)
		           WHERE dato >= %s AND dato <= %s AND b.navn = %s
		           GROUP BY DATE_PART('year', dato), DATE_PART('week', dato)
		           ORDER BY DATE_PART('year', dato), DATE_PART('week', dato);"""
			return query
		elif statType == "Total stigning":
			query = """SELECT DATE_PART('year', dato), DATE_PART('week', dato), sum(hoyde)
		           FROM trening
		           WHERE dato >= %s AND dato <= %s
		           GROUP BY DATE_PART('year', dato), DATE_PART('week', dato)
		           ORDER BY DATE_PART('year', dato), DATE_PART('week', dato);"""
			return query
		else:
			return None


	def get_statistikk(self, fraUke: int, fraAar: int, tilUke: int, tilAar: int, statType: int):

		dataList = []

		cur = self.conn.cursor()

		statTyper = ["Total tid", "Tid løpt", "Tid spesifikk", "Total distanse", "Distanse løpt", "Distanse spesifikk", "Total stigning"]

		fraDate = datetime.datetime.strptime(f"1.{fraUke}.{fraAar}", "%u.%V.%G")
		tilDate = datetime.datetime.strptime(f"1.{tilUke}.{tilAar}", "%u.%V.%G")

		emptyData = emptyStructures.get_empty_statistikk(fraDate, tilDate, statTyper)

		#Finne spesifikke typer
		cur.execute("SELECT navn FROM Bevegelsesform;")
		spesifikkTyper = cur.fetchall()
		emptyData["spesifikkTyper"] = [ t[0] for t in spesifikkTyper ]

		query = self.get_statistikk_query(statTyper[statType])
		if query == None:
			print("Dette har kke blitt implementert")
			return NotImplementedError

		if statTyper[statType] == "Tid spesifikk":
			for typ in emptyData["spesifikkTyper"]:
				data = emptyStructures.get_empty_statistikk(fraDate, tilDate, statTyper)
				cur.execute(query, (fraDate, tilDate, typ))
				res = cur.fetchall()

				data["name"] = typ

				for n in range(0, len(res)):
					data["data"][data["labels"].index(f"{int(res[n][1])}-{int(res[n][0])}")]["data"] = res[n][2]

				dataList.append(data)

		else:
			data = emptyData.copy()
			cur.execute(query, (fraDate, tilDate))

			res = cur.fetchall()

			data["name"] = "Total"
			for n in range(0, len(res)):
				data["data"][data["labels"].index(f"{int(res[n][1])}-{int(res[n][0])}")]["data"] = res[n][2]

			dataList.append(data)

		cur.close()
		return dataList


if __name__ == "__main__":
	
	print(Database().get_oversikt())



























