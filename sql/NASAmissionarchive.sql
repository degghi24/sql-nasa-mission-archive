-- =====================================================
-- PROGETTO BASI DI DATI
-- Database: NASA Mission Archive
-- Autore: Filippo De Guio, Antonio Hai Xu Tang
-- =====================================================

DROP TABLE IF EXISTS Personale;
DROP TABLE IF EXISTS Commissione;
DROP TABLE IF EXISTS MissioneSperimentale;
DROP TABLE IF EXISTS MissioneConEquipaggio;
DROP TABLE IF EXISTS MissioneRobotica;
DROP TABLE IF EXISTS MissioneDiOsservazione;
DROP TABLE IF EXISTS MissioneSatellitare;
DROP TABLE IF EXISTS Missione;
DROP TABLE IF EXISTS Esperimento;
DROP TABLE IF EXISTS Astronauta;
DROP TABLE IF EXISTS Telescopio;
DROP TABLE IF EXISTS Satellite;
DROP TABLE IF EXISTS VettoreDiLancio;
DROP TABLE IF EXISTS Robot;
DROP TABLE IF EXISTS Programma;
DROP TABLE IF EXISTS SitoDiLancio;
DROP TABLE IF EXISTS Produttore;
DROP TABLE IF EXISTS AgenziaSpaziale;

--------------------------------------------------------------------------------------------------

CREATE TABLE Programma (
    NomeProgramma VARCHAR(100) PRIMARY KEY,
    DataInizio DATE NOT NULL,
    DataFine DATE,
    Status VARCHAR(50) NOT NULL,
    Budget DECIMAL(15,2) NOT NULL
);

CREATE TABLE SitoDiLancio (
    CodiceSito VARCHAR(50) PRIMARY KEY,
    NomeSito VARCHAR(100) NOT NULL,
    Nazione VARCHAR(100) NOT NULL,
    Gestore VARCHAR(100) NOT NULL
);

CREATE TABLE Produttore (
    CodiceAziendale VARCHAR(50) PRIMARY KEY,
    NomeAzienda VARCHAR(100) NOT NULL,
    SedeLegale VARCHAR(150) NOT NULL
);

CREATE TABLE AgenziaSpaziale (
    NomeAgenzia VARCHAR(100) PRIMARY KEY,
    SedeCentrale VARCHAR(150) NOT NULL,
    Direttore VARCHAR(100) NOT NULL
);

CREATE TABLE Robot (
    PIN VARCHAR(50) PRIMARY KEY,
    Alimentazione VARCHAR(50) NOT NULL,
    Autonomia INT NOT NULL
);

CREATE TABLE Astronauta (
    AgenziaSpaziale VARCHAR(100) NOT NULL,
    Callsign VARCHAR(50) PRIMARY KEY,
    NomeAstronauta VARCHAR(100) NOT NULL,
    Nazionalita VARCHAR(100) NOT NULL,
    Ruolo VARCHAR(100) NOT NULL,
    FOREIGN KEY (AgenziaSpaziale)
        REFERENCES AgenziaSpaziale(NomeAgenzia)
);

CREATE TABLE Esperimento (
    AgenziaSpaziale VARCHAR(100) NOT NULL,
    LID VARCHAR(50) PRIMARY KEY,
    Responsabile VARCHAR(100) NOT NULL,
    AreaScientifica VARCHAR(100) NOT NULL,
    FOREIGN KEY (AgenziaSpaziale)
        REFERENCES AgenziaSpaziale(NomeAgenzia)
);

CREATE TABLE Telescopio (
    Produttore VARCHAR(50) NOT NULL,
    Sigla VARCHAR(50) PRIMARY KEY,
    Spettro VARCHAR(100) NOT NULL,
    Ottica VARCHAR(100) NOT NULL,
    FOREIGN KEY (Produttore)
        REFERENCES Produttore(CodiceAziendale)
);

CREATE TABLE Satellite (
    Produttore VARCHAR(50) NOT NULL,
    NoradID VARCHAR(50) PRIMARY KEY,
    Funzione VARCHAR(100) NOT NULL,
    StatoOP VARCHAR(50) NOT NULL,
    FOREIGN KEY (Produttore)
        REFERENCES Produttore(CodiceAziendale)
);

CREATE TABLE VettoreDiLancio (
    Produttore VARCHAR(50) NOT NULL,
    CosparID VARCHAR(50) PRIMARY KEY,
    NomeModello VARCHAR(100) NOT NULL,
    TipoPropellente VARCHAR(100) NOT NULL,
    FOREIGN KEY (Produttore)
        REFERENCES Produttore(CodiceAziendale)
);

CREATE TABLE Missione (
    Programma VARCHAR(100) NOT NULL,
    VettoreLancio VARCHAR(50) NOT NULL,
    SitoDiLancio VARCHAR(50) NOT NULL,
    CodMissione VARCHAR(50) PRIMARY KEY,
    NomeMissione VARCHAR(100) NOT NULL,
    Durata INT NOT NULL,
    Esito VARCHAR(100) NOT NULL,
    FOREIGN KEY (Programma)
        REFERENCES Programma(NomeProgramma),
    FOREIGN KEY (VettoreLancio)
        REFERENCES VettoreDiLancio(CosparID),
    FOREIGN KEY (SitoDiLancio)
        REFERENCES SitoDiLancio(CodiceSito)
);

CREATE TABLE MissioneSperimentale (
    Missione VARCHAR(50) NOT NULL,
    Esperimento VARCHAR(50) NOT NULL,
    NoteTecniche TEXT,
    PRIMARY KEY (Missione, Esperimento),
    FOREIGN KEY (Missione)
        REFERENCES Missione(CodMissione),
    FOREIGN KEY (Esperimento)
        REFERENCES Esperimento(LID)
);

CREATE TABLE MissioneConEquipaggio (
    Missione VARCHAR(50) PRIMARY KEY,
	NumEquipaggio INT NOT NULL
    FOREIGN KEY (Missione)
        REFERENCES Missione(CodMissione)
);

CREATE TABLE MissioneRobotica (
    Missione VARCHAR(50) NOT NULL,
    Robot VARCHAR(50) NOT NULL,
    AmbienteOP VARCHAR(100) NOT NULL,
    PRIMARY KEY (Missione, Robot),
    FOREIGN KEY (Missione)
        REFERENCES Missione(CodMissione),
    FOREIGN KEY (Robot)
        REFERENCES Robot(PIN)
);

CREATE TABLE MissioneDiOsservazione (
    Missione VARCHAR(50) NOT NULL,
    Telescopio VARCHAR(50) NOT NULL,
    Target VARCHAR(100) NOT NULL,
    PRIMARY KEY (Missione, Telescopio),
    FOREIGN KEY (Missione)
        REFERENCES Missione(CodMissione),
    FOREIGN KEY (Telescopio)
        REFERENCES Telescopio(Sigla)
);

CREATE TABLE MissioneSatellitare (
    Missione VARCHAR(50) NOT NULL,
    Satellite VARCHAR(50) NOT NULL,
    Orbita VARCHAR(100) NOT NULL,
    PRIMARY KEY (Missione, Satellite),
    FOREIGN KEY (Missione)
        REFERENCES Missione(CodMissione),
    FOREIGN KEY (Satellite)
        REFERENCES Satellite(NoradID)
);

CREATE TABLE Commissione (
    AgenziaSpaziale VARCHAR(100) NOT NULL,
    Esperimento VARCHAR(50) NOT NULL,
    PRIMARY KEY (AgenziaSpaziale, Esperimento),
    FOREIGN KEY (AgenziaSpaziale)
        REFERENCES AgenziaSpaziale(NomeAgenzia),
    FOREIGN KEY (Esperimento)
        REFERENCES Esperimento(LID)
);

CREATE TABLE Personale (
    Missione VARCHAR(50) NOT NULL,
    Astronauta VARCHAR(50) NOT NULL,
    PRIMARY KEY (Missione, Astronauta),
    FOREIGN KEY (Missione)
        REFERENCES MissioneConEquipaggio(Missione),
    FOREIGN KEY (Astronauta)
        REFERENCES Astronauta(Callsign)
);

------------------------------------------------------------------------------------------------

INSERT INTO AgenziaSpaziale(NomeAgenzia,SedeCentrale,Direttore) VALUES
('NASA','Washington D.C., USA','Bill Nelson'),
('ESA','Parigi, Francia','Josef Aschbacher'),
('JAXA','Tokyo, Giappone','Hiroshi Yamakawa'),
('CSA','Saint-Hubert, Canada','Lisa Campbell');

INSERT INTO Produttore(CodiceAziendale,NomeAzienda,SedeLegale) VALUES
('SPX001','SpaceX','Hawthorne, California, USA'),
('BOE001','Boeing','Chicago, Illinois, USA'),
('ESA001','ArianeGroup','Les Mureaux, Francia'),
('LMT001','Lockheed Martin','Bethesda, Maryland, USA'),
('NAL001','Northrop Grumman','Falls Church, Virginia, USA');

INSERT INTO SitoDiLancio(CodiceSito,NomeSito,Nazione,Gestore) VALUES
('KSC','Kennedy Space Center','USA','NASA'),
('VAFB','Vandenberg Air Force Base','USA','USSF'),
('CSG','Centre Spatial Guyanais','Francia','ESA');

INSERT INTO Robot(PIN,Alimentazione,Autonomia) VALUES
('RB001','Solare/Nucleare',1460),
('RB002','Nucleare',730),
('RB003','Solare',365);

INSERT INTO Programma(NomeProgramma,DataInizio,DataFine,Status,Budget) VALUES
('Apollo','1961-05-25','1972-12-19','Concluso',25400000000.00),
('Artemis','2017-12-11',NULL,'Attivo',93000000000.00),
('Mars Exploration','1964-01-01',NULL,'Attivo',10000000000.00),
('Voyager','1972-01-01','1989-12-31','Concluso',865000000.00),
('Gemini','1961-12-07','1966-11-15','Concluso',5933000000.00);

INSERT INTO Astronauta(AgenziaSpaziale,Callsign,NomeAstronauta,Nazionalita,Ruolo) VALUES
('NASA','EAGLE1','Neil Armstrong','Americana','Comandante'),
('NASA','BUZZ01','Buzz Aldrin','Americana','Pilota LEM'),
('NASA','STAR02','John Young','Americana','Comandante'),
('NASA','MOON77','Michael Collins','Americana','Pilota'),
('CSA','MAPLE9','Chris Hadfield','Canadese','Specialista');

INSERT INTO Esperimento(AgenziaSpaziale,LID,Responsabile,AreaScientifica) VALUES
('NASA','EXP001','Dr. Smith','Geologia'),
('ESA','EXP002','Dr. Müller','Astrobiologia'),
('JAXA','EXP003','Dr. Tanaka','Geologia'),
('NASA','EXP004','Dr. Johnson','Ingegneria'),
('CSA','EXP005','Dr. Tremblay','Fisica quantistica');

INSERT INTO Telescopio(Produttore,Sigla,Spettro,Ottica) VALUES
('LMT001','HST','Visibile/UV','Cassegrain'),
('NAL001','JWST','Infrarosso','Korsch');

INSERT INTO Satellite(Produttore,NoradID,Funzione,StatoOP) VALUES
('SPX001','NOR001','Telecomunicazioni','Operativo'),
('BOE001','NOR002','Meteorologico','Operativo'),
('ESA001','NOR003','Osservazione terrestre','Operativo'),
('LMT001','NOR004','Navigazione','Manutenzione'),
('NAL001','NOR005','Ricerca scientifica','Operativo');

INSERT INTO VettoreDiLancio(Produttore,CosparID,NomeModello,TipoPropellente) VALUES
('SPX001','COS001','Falcon 9','LOX/RP-1'),
('BOE001','COS002','SLS','Idrogeno Liquido'),
('ESA001','COS003','Ariane 5','Criogenico'),
('NAL001','COS004','Pegasus XL','Solido'),
('LMT001','COS005','Atlas V','LOX/RP-1');

INSERT INTO Missione(Programma,VettoreLancio,SitoDiLancio,CodMissione,NomeMissione,Durata,Esito) VALUES
('Apollo','COS002','KSC','MIS001','Apollo 11',8,'Successo'),
('Artemis','COS002','KSC','MIS002','Artemis I',25,'Successo'),
('Mars Exploration','COS001','VAFB','MIS003','Mars Recon',180,'Successo'),
('Voyager','COS005','KSC','MIS004','Voyager Interstellar',5400,'Successo'),
('Artemis','COS001','CSG','MIS005','Europa Probe',365,'In corso'),
('Mars Exploration','COS003','CSG','MIS006','Mars Ice Mapper',420,'Pianificata'),
('Voyager','COS004','VAFB','MIS007','Deep Space Telescope',900,'Successo'),
('Gemini','COS005','KSC','MIS008','Gemini VIII',3,'Successo');

INSERT INTO MissioneConEquipaggio(Missione,NumEquipaggio) VALUES
('MIS001', 3),
('MIS008', 2);

INSERT INTO MissioneRobotica(Missione,Robot,AmbienteOP) VALUES
('MIS003','RB001','Marte'),
('MIS005','RB002','Europa'),
('MIS006','RB003','Marte');

INSERT INTO MissioneDiOsservazione(Missione,Telescopio,Target) VALUES
('MIS004','HST','Spazio interstellare'),
('MIS007','JWST','Galassie primordiali');

INSERT INTO MissioneSatellitare(Missione,Satellite,Orbita) VALUES
('MIS002','NOR001','LEO'),
('MIS003','NOR003','Orbita marziana'),
('MIS004','NOR005','Eliocentrica');

INSERT INTO MissioneSperimentale(Missione,Esperimento,NoteTecniche) VALUES
('MIS002','EXP004','Validazione sistemi di navigazione avanzata'),
('MIS003','EXP003','Studio composizione geologica marziana'),
('MIS005','EXP002','Ricerca su microorganismi in ambienti estremi'),
('MIS006','EXP001','Analisi spettrografica polare'),
('MIS007','EXP005','Test trasmissione quantistica a lunga distanza');

INSERT INTO Commissione(AgenziaSpaziale,Esperimento) VALUES
('NASA','EXP001'),
('NASA','EXP004'),
('ESA','EXP002'),
('JAXA','EXP003'),
('CSA','EXP005');

INSERT INTO Personale(Missione,Astronauta) VALUES
('MIS001','EAGLE1'),
('MIS001','BUZZ01'),
('MIS008','STAR02'),
('MIS008','MOON77'),
('MIS008','MAPLE9');

-----------------------------------------------------------------------------------------------------------------------

--QUERY 1: mostrare i siti di lancio da cui sono decollate almeno 3 missioni
SELECT
    S.CodiceSito,
    S.NomeSito,
    COUNT(M.CodMissione) AS NumMissioni
FROM SitoDiLancio S
JOIN Missione M ON S.CodiceSito = M.SitoDiLancio
GROUP BY S.CodiceSito, S.NomeSito
HAVING COUNT(M.CodMissione) > 3;


--QUERY 2: trovare il numero di astronauti impiegati in missioni per ciascuna agenzia spaziale
SELECT
    A.AgenziaSpaziale,
    COUNT(DISTINCT A.Callsign) AS NumAstronauti
FROM Astronauta A
JOIN Personale P ON A.Callsign = P.Astronauta
GROUP BY A.AgenziaSpaziale;


--QUERY 3: contare il numero di satelliti prodotti da ciascun produttore
SELECT
    P.CodiceAziendale,
    P.NomeAzienda,
    COUNT(S.NoradID) AS NumSatelliti
FROM Produttore P
JOIN Satellite S ON P.CodiceAziendale = S.Produttore
GROUP BY P.CodiceAziendale, P.NomeAzienda;


--QUERY 4: calcolare la durata totale delle missioni robotiche per ciascun robot
SELECT
    R.PIN,
    SUM(M.Durata) AS DurataTotale
FROM Robot R
JOIN MissioneRobotica MR ON R.PIN = MR.Robot
JOIN Missione M ON MR.Missione = M.CodMissione
GROUP BY R.PIN;


--QUERY 5: trovare numero di esperimenti coinvolti in missioni per agenzia spaziale
SELECT
    E.AgenziaSpaziale,
    COUNT(DISTINCT E.LID) AS NumEsperimenti
FROM Esperimento E
JOIN MissioneSperimentale MS ON E.LID = MS.Esperimento
GROUP BY E.AgenziaSpaziale;

-----------------------------------------------------------------------------------------------------------------------------------------------

--INDICE QUERY 1
CREATE INDEX idx_missione_sitodilancio ON Missione(SitoDiLancio);