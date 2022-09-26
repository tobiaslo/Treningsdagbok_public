import plotly.express as px
import pandas as pd
import numpy as np
from geopy import distance
import time
from datetime import datetime, timedelta
import sys

import gpx 
import strava
import data_classes

def get_dist_array(point, array):
	ret = []
	for p in array:
		ret.append(distance.great_circle((point[0], point[1]), (p[0], p[1])).m)
	return ret



def calc_typer(route, data, threshold=30.0):
	route_np = route

	classification = []

	for point in route_np:

		if data.get_poly().contains_point((point[0], point[1])):
			classification.append("Løp asfalt")
			continue


		euc_dist = np.sum((data.get_pavement_points_np() - point)**2, axis=1)
		dist = get_dist_array(point, data.get_pavement_points_np()[euc_dist.argsort()][:2,:])
			
		if max(dist) < threshold:
			classification.append('Løp asfalt')
			continue

		euc_dist = np.sum((data.get_gravel_points_np() - point)**2, axis=1)
		dist = get_dist_array(point, data.get_gravel_points_np()[euc_dist.argsort()][:2,:])
			
		if max(dist) < threshold:
			classification.append('Løp grus')
		else:
			classification.append('Løp terreng')

	return classification

def calculate_totals(classification: list):

	totals = {}

	for typ in set(clas):
		indices = np.where(np.array(clas) == typ)
		dist = np.sum(t_distance_diff[indices])
		sec = indices[0].size

		totals[typ] = {"tid": str(timedelta(seconds=sec)), "dist": dist / 1000}

	return totals

def get_totals(dato: str, gps_data: Gps_points):

	strava_con = strava.Strava_connection()
	activity_id = strava.get_activity_id(strava_con.access_token(), datetime.strptime(dato, "%d.%m.%Y"))
	t_points = strava.get_data_from_strava(strava_con.access_token(), activity_id, typ="latlng")
	t_distance = strava.get_data_from_strava(strava_con.access_token(), activity_id, typ="distance")
	t_distance_diff = np.ediff1d(np.array(t_distance))
	t_distance_diff = np.insert(t_distance_diff, 0, 0)

	data = data_classes.Gps_points()

	clas = calc_typer(t_points, gps_data)

	totals = calculate_totals(clas)

	return totals









