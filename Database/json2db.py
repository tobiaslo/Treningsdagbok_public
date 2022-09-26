
import psycopg2
import json
import datetime
import os


def main():

	dbname = 'postgres'
	user = 'newuser'
	pwd = 'password'
	host = '127.0.0.1'

	conn = psycopg2.connect(user=user,
							password=pwd,
							host=host,
							port="5432", 
							database=dbname)

	cur = conn.cursor()
	cur.execute("DELETE FROM Trening;")
	conn.commit()
	cur.close()
	conn.close()

	for file in os.listdir("/Users/tobiaslomo/Treningsdagbok/data/2020/"):
		if file.split(".")[1] == "json":
			add_week(path= f"/Users/tobiaslomo/Treningsdagbok/data/2020/{file}")
			print(f"Added {file} from 2020 to db")

	for file in os.listdir("/Users/tobiaslomo/Treningsdagbok/data/2021/"):
		if file.split(".")[1] == "json":
			add_week(path= f"/Users/tobiaslomo/Treningsdagbok/data/2021/{file}")
			print(f"Added {file} from 2021 to db")

	for file in os.listdir("/Users/tobiaslomo/Treningsdagbok/data/2022/"):
		if file.split(".")[1] == "json":
			add_week(path= f"/Users/tobiaslomo/Treningsdagbok/data/2022/{file}")
			print(f"Added {file} from 2022 to db")


def add_week(path: str):
	dbname = 'postgres'
	user = 'newuser'
	pwd = 'password'
	host = '127.0.0.1'

	conn = psycopg2.connect(user=user,
							password=pwd,
							host=host,
							port="5432", 
							database=dbname)

	#Opens json file
	f = open(path)
	data = json.load(f)

	for day in data['dager']:
		for i in range(len(day['trening'])):

			# --- Adds training to db ---
			trening = day['trening'][i]

			nr = i
			date = datetime.datetime.strptime(day['dato'], '%d.%m.%Y')
			#print(date)
			rpe = trening['opplevdAnstrengelse']
			dagsform = trening['dagsform']
			overskrift = trening['overskrift']
			kommentar = trening['kommentar']
			hoyde = trening['hoyde']
			intervall = trening['intervall']


			cur = conn.cursor()
			cur.execute("INSERT INTO trening (nr, dato, rpe, dagsform, overskrift, kommentar, hoyde, intervall) VALUES (%s, %s, %s, %s, %s, %s, %s, %s);",
						(nr, date, rpe, dagsform, overskrift, kommentar, hoyde, intervall))
			
			#print(f"Added trening:\nnr: {nr}\ndate: {date}\nrpe: {rpe}\ndagsform: {dagsform}\noverskrift: {overskrift}\nkommentar: {kommentar}\nhoyde: {hoyde}\nintervall: {intervall}\n")

			# --- Adds Former to db ---
			for form in trening['former']:
				if form == None:
					continue
				cur.execute("SELECT id FROM Bevegelsesform WHERE navn = %s;", (form['type'].capitalize(),))
				res = cur.fetchall()
				f_id = res[0][0]

				cur.execute("INSERT INTO Form VALUES (%s, currval('trening_id_seq'), %s, %s)",
							(f_id, form['tid'], form['distanse']))
				#print(f"Added form:\ntype: {f_id}\ntid: {form['tid']}\ndistanse: {form['distanse']}")	

			# --- Adds Skade to db ---
			try:
				kom = trening['skade']
				cur.execute("INSERT INTO Skade (trening, kommentar) VALUES (currval('trening_id_seq'), %s);",
							(kom,))
				#print("Skade!!")
			except KeyError as e:
				#print("Ingen skade :)")
				pass

			# --- Adds Konkurranse to db ---
			try:
				konk = trening['konkurranse']
				tid = None
				if len(konk['tidNøyaktig'].split(':')) == 2:
					tid = datetime.datetime.strptime(konk['tidNøyaktig'], '%M:%S')
				elif len(konk['tidNøyaktig'].split(':')) == 3:
					tid = datetime.datetime.strptime(konk['tidNøyaktig'], '%H:%M:%S')

				#print("Konkurranse")
				cur.execute("INSERT INTO Konkurranse (trening, fornoyd, tid) VALUES (currval('trening_id_seq'), %s, %s);",
							(konk['fornoyd'], tid))
				
			except KeyError as e:
				#print("Ingen konkurranse")
				pass

			# --- Adds Standardokt to db ---
			try:
				st = trening['standarTrening']
				cur.execute("SELECT id FROM Standardokt_list WHERE navn = %s;",
							(st['type'],))
				type_id = cur.fetchall()[0][0]

				cur.execute("INSERT INTO Standardokt (type, trening) VALUES (%s, currval('trening_id_seq'));",
							(type_id,))

				# --- Adds Runde to db ---
				for i in range(len(st['runder'])):
					runde = st['runder'][i]

					tid = None
					if len(runde['tid'].split(':')) == 1:
						time = int(int(runde['tid']) / 60)
						minutter = int(runde['tid'] ) % 60
						tid = datetime.datetime.strptime(f"{time}:{minutter}", '%H:%M')
					elif len(runde['tid'].split(':')) == 2:
						tid = datetime.datetime.strptime(runde['tid'], '%M:%S')


					cur.execute("INSERT INTO Runder VALUES (%s, currval('standardokt_id_seq'), %s, %s, %s);",
								(i, tid, runde['avgHRM'], runde['maxHRM']))

			except KeyError as e:
				#print(f"Error in {e}")
				pass

			conn.commit()
			cur.close()

			


if __name__ == '__main__':
	main()