
## Treningsdagbok
Program for å logge og lagre trening. 

## Oppdeling
### Database
- Postgresql database
- Lagrer all data
- Inneholder diverse filer for oppsett av database

### Server
- Python server basert på FastAPI
- Henter data fra databasen og sender dem videre ved forespørsel

### Klient
- Swift program som skal gi et grafisk grensesnitt til serveren og APIen
- Laget så enkelt som mulig, viser i stor grad bare en json fil fra serveren
