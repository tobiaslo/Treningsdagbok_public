# Server

Server made using python and fastAPI. The server is the program that do most of the work on the data. This means some of the methods are big and not very nice. The positive side with this approch is that the swift program is easier and smaller.

## Dependencies

- fastAPI
- pydantic
- typing
- psycopg2
- pandas
- gpxpy
- geopy
- matplotlib
- numpy

## Usage

To start the web API run
```
python3 api.py
```

To start with debug
```
uvicorn api:app --debug
```

