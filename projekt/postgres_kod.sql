

CREATE TABLE GeoEon(
id_eon SERIAL PRIMARY KEY NOT NULL,
nazwa_eon VARCHAR(20)
);

CREATE INDEX idx_id_eon ON GeoEon (id_eon); --tworzy indeksy nieklastrowane

CLUSTER GeoEon USING idx_id_eon;  --najbliższy odpowiednik indeksów klastrowanych sqlserver

CREATE TABLE GeoEra(
id_era SERIAL PRIMARY KEY NOT NULL,
nazwa_era VARCHAR(20),
id_eon INT DEFAULT 1,
FOREIGN KEY(id_eon) REFERENCES GeoEon(id_eon)
);

CREATE INDEX idx_id_era ON GeoEra (id_era);

CLUSTER GeoEra USING idx_id_era; 

CREATE TABLE GeoOkres(
id_okres SERIAL PRIMARY KEY NOT NULL,
nazwa_okres VARCHAR(20),
id_era SERIAL,
FOREIGN KEY(id_era) REFERENCES GeoEra(id_era)
);

CREATE INDEX idx_id_okres ON GeoOkres (id_okres);

CLUSTER GeoOkres USING idx_id_okres; 

CREATE TABLE GeoEpoka(
id_epoka SERIAL PRIMARY KEY NOT NULL,
nazwa_epoka VARCHAR(20), 
id_okres SERIAL,
FOREIGN KEY(id_okres) REFERENCES GeoOkres(id_okres)
);

CREATE INDEX idx_id_epoka ON GeoEpoka (id_epoka);

CLUSTER GeoEpoka USING idx_id_epoka; 

CREATE TABLE GeoPietro(
id_pietro SERIAL PRIMARY KEY NOT NULL,
nazwa_pietro VARCHAR(20),
id_epoka SERIAL,
FOREIGN KEY(id_epoka) REFERENCES GeoEpoka(id_epoka)
);

CREATE INDEX idx_id_pietro ON GeoPietro (id_pietro);

CLUSTER GeoPietro USING idx_id_pietro; 

INSERT INTO GeoEon (nazwa_eon) VALUES ('Fanerozoik');

INSERT INTO GeoEra (nazwa_era) VALUES ('Kenozoik'), ('Mezozoik'), ('Paleozoik');

INSERT INTO GeoOkres (nazwa_okres, id_era) VALUES ('Czwartorząd', 1), ('Neogen', 1), ('Paleogen', 1),
('Kreda', 2), ('Jura', 2), ('Trias', 2), ('Perm', 3), ('Karbon', 3), ('Dewon', 3);

INSERT INTO GeoEpoka (nazwa_epoka, id_okres) VALUES 
('Holocen', 1), ('Plejstocen', 1),
('Pliocen', 2), ('Miocen', 2), ('Oligocen', 3), ('Eocen', 3), ('Paleocen', 3),
('Górna', 4), ('Dolna', 4),
('Górna', 5), ('Środkowa', 5), ('Dolna', 5),
('Górna', 6), ('Środkowa', 6), ('Dolna', 6),
('Górny', 7), ('Dolny', 7),
('Górny', 8), ('Dolny', 8),
('Górny', 9), ('środkowy', 9), ('Dolny', 9);

INSERT INTO GeoPietro (nazwa_pietro, id_epoka) VALUES 
('megalaj', 1), ('northgrip', 1), ('grenland', 1), 
('późny', 2), ('chiban', 2), ('kalabr', 2), ('gelas',2), ('piacent', 3), ('zankl',3), 
('messyn', 4), ('torton', 4), ('serrawal', 4), ('lang', 4), ('burdygał', 4), ('akwitan', 4), 
('szat', 5), ('rupel', 5), 
('priabon',6),('barton', 6),('lutet', 6), ('iprez', 6), 
('tanet', 7), ('zeland', 7), ('dan', 7), 
('mastrycht', 8), ('kampan', 8), ('santon', 8), ('koniak', 8), ('turon', 8), ('cenoman', 8), 
('alb', 9), ('apt', 9), ('barrem', 9), ('hoteryw', 9), ('walanżyn', 9), ('berrias', 9), 
('tyton', 10), ('kimeryd', 10), ('oksford', 10), 
('kelowej', 11), ('baton', 11), ('bajos', 11), 
('aalen', 11), ('toark', 12), ('pliensbach', 12), ('synemur', 12), ('hettang', 12),
('retyk', 13), ('noryk', 13), ('karnik', 13),
('ladyn', 14), ('anizyk', 14),
('olenek', 15), ('ind', 15),
('czangsing', 16), ('wucziaping', 16), ('kapitan', 16), ('word', 16), ('road', 16),
('kungur', 17), ('artinsk', 17), ('sakmar', 17), ('assel', 17),
('gżel', 18), ('kasimow', 18), ('moskow', 18), ('baszkir', 18),
('serpuchow', 19), ('wizen', 19), ('turnej', 19),
('famen', 20), ('fran', 20),
('żywet', 21), ('eifel', 21),
('ems', 22), ('prag', 22), ('lochkow', 22);

SELECT * FROM GeoPietro;


CREATE TABLE GeoTabela (
  id_pietro INT PRIMARY KEY NOT NULL,
  nazwa_pietro VARCHAR(20),
  id_epoka INT,
  nazwa_epoka VARCHAR(20),
  id_okres INT,
  nazwa_okres VARCHAR(20),
  id_era INT,
  nazwa_era VARCHAR(20),
  id_eon INT,
  nazwa_eon VARCHAR(20)
);


INSERT INTO GeoTabela (id_pietro, nazwa_pietro, id_epoka, nazwa_epoka, id_okres, nazwa_okres, id_era, nazwa_era, id_eon, nazwa_eon)
SELECT
  GeoPietro.id_pietro,
  GeoPietro.nazwa_pietro,
  GeoEpoka.id_epoka,
  GeoEpoka.nazwa_epoka,
  GeoOkres.id_okres,
  GeoOkres.nazwa_okres,
  GeoEra.id_era,
  GeoEra.nazwa_era,
  GeoEon.id_eon,
  GeoEon.nazwa_eon
FROM
  GeoPietro
INNER JOIN GeoEpoka ON GeoPietro.id_epoka = GeoEpoka.id_epoka
INNER JOIN GeoOkres ON GeoEpoka.id_okres = GeoOkres.id_okres
INNER JOIN GeoEra ON GeoOkres.id_era = GeoEra.id_era
INNER JOIN GeoEon ON GeoEra.id_eon = GeoEon.id_eon;

SELECT * FROM GeoTabela;

CREATE INDEX idx_id_pietro_geotab ON GeoTabela (id_pietro);

CLUSTER GeoTabela USING idx_id_pietro_geotab; 

	
CREATE TABLE Dziesiec (
  cyfra INT NOT NULL,
  bit INT NOT NULL
);

INSERT INTO Dziesiec (cyfra, bit)
VALUES (0, 0), (1, 1),(2, 0),(3, 1),(4, 0),(5, 1),(6, 0),(7, 1),(8, 0),(9, 1);

CREATE TABLE Milion (
  liczba INT,
  cyfra INT,
  bit INT
);

WITH RECURSIVE Numbers AS (
    SELECT 0 AS liczba
    UNION ALL
    SELECT liczba + 1
    FROM Numbers
    WHERE liczba + 1 < 1000000
)
INSERT INTO Milion (liczba, cyfra, bit)
SELECT n.liczba, n.liczba % 10 AS cyfra, (n.liczba % 10) % 2 AS bit
FROM Numbers n;

SELECT * FROM Milion;

CREATE INDEX idx_liczba ON Milion (liczba);

CLUSTER Milion USING idx_liczba; 


--Zapytanie 1
EXPLAIN ANALYZE
SELECT COUNT(*)
FROM Milion
INNER JOIN GeoTabela ON Milion.liczba % 68 = GeoTabela.id_pietro;

--Zapytanie 2
EXPLAIN ANALYZE
SELECT COUNT(*)
FROM Milion
INNER JOIN GeoPietro ON Milion.liczba % 68 = GeoPietro.id_pietro
INNER JOIN GeoEpoka ON GeoPietro.id_epoka = GeoEpoka.id_epoka
INNER JOIN GeoOkres ON GeoEpoka.id_okres = GeoOkres.id_okres
INNER JOIN GeoEra ON GeoOkres.id_era = GeoEra.id_era
INNER JOIN GeoEon ON GeoEra.id_eon = GeoEon.id_eon;


--Zapytanie 3
EXPLAIN ANALYZE
SELECT COUNT(*)
FROM Milion
WHERE Milion.liczba % 68 = (
    SELECT id_pietro
    FROM GeoTabela
    WHERE Milion.liczba % 68 = id_pietro
);

--Zapytanie 4
EXPLAIN ANALYZE
SELECT COUNT(*)
FROM Milion
WHERE Milion.liczba % 68 = (
    SELECT GeoPietro.id_pietro
    FROM GeoPietro
    INNER JOIN GeoEpoka ON GeoPietro.id_epoka = GeoEpoka.id_epoka
    INNER JOIN GeoOkres ON GeoEpoka.id_okres = GeoOkres.id_okres
    INNER JOIN GeoEra ON GeoOkres.id_era = GeoEra.id_era
    INNER JOIN GeoEon ON GeoEra.id_eon = GeoEon.id_eon
    WHERE Milion.liczba % 68 = GeoPietro.id_pietro
);
