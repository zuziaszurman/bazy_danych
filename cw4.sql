
USE [firma];
GO
CREATE SCHEMA rozliczenia;
GO

CREATE TABLE rozliczenia.pracownicy(
id_pracownika INTEGER NOT NULL PRIMARY KEY,
imie NVARCHAR(50) NOT NULL,
nazwisko NVARCHAR(50) NOT NULL,
adres NVARCHAR(100) NOT NULL,
telefon INTEGER NOT NULL
);

CREATE TABLE rozliczenia.godziny(
id_godziny INTEGER NOT NULL PRIMARY KEY,
data DATE NOT NULL,
liczba_godzin INTEGER, 
id_pracownika INTEGER
);

CREATE TABLE rozliczenia.pensje(
id_pensji INTEGER NOT NULL PRIMARY KEY,
stanowisko NVARCHAR(20) NOT NULL,
kwota DECIMAL(10,2) NOT NULL,
id_premii INTEGER
);

CREATE TABLE rozliczenia.premie(
id_premii INTEGER NOT NULL PRIMARY KEY,
rodzaj NVARCHAR(20),
kwota DECIMAL(10,2)
);

ALTER TABLE rozliczenia.pensje
ADD FOREIGN KEY (id_premii) REFERENCES rozliczenia.premie(id_premii);

ALTER TABLE rozliczenia.godziny
ADD FOREIGN KEY (id_pracownika) REFERENCES rozliczenia.pracownicy(id_pracownika);

ALTER TABLE rozliczenia.pensje
ADD kwota_brutto DECIMAL(10,2);

UPDATE rozliczenia.pensje
SET kwota_brutto = kwota;

ALTER TABLE rozliczenia.pensje
DROP COLUMN kwota;


INSERT INTO [rozliczenia].[pracownicy] ([id_pracownika], [imie], [nazwisko], [adres], [telefon]) VALUES
(1, 'Jan', 'Kowalski', 'Krak�w, ul.D�uga 1', '568798789'),
(2, 'Justyna', 'Taka', 'Pozna�, ul.Kr�tka 2', '123456789'),
(3, 'Michal', 'Michalowski', 'Miko��w, ul.Michalska 6', '567890123'),
(4, 'Marcin', 'Kula', 'Krak�w, ul.Floria�ska 3', '123890567'),
(5, 'Milena', '�opata', 'Warszwa, ul.Zachodnia 4', '566382560'),
(6, 'Bogus�aw', 'Bogu�', 'Boles�awiec, ul.Boles�awska 3', '345652782'),
(7, 'Zdzis�awa', 'Zdzis�awska', 'Zagrzeb, ul.Zdzis�owia�ska 6', '111111111'),
(8, 'Miros�aw', 'Miros�awski', 'Mikoja�owice, ul.Miko�aja 6', '222222222'),
(9, 'Franicszek', 'Pierwszy;', 'Krak�w, ul.Grocka 10', '333333333'),
(10, 'Lechos�aw', 'Drugi', 'Toru�, ul.Toru�ska 10', '444444444');

INSERT INTO [rozliczenia].[godziny]([id_godziny], [data], [liczba_godzin], [id_pracownika]) VALUES
(1,'2022-10-12', 45, 4),
(2, '2022-10-13', 40,5),
(3, '2022-10-14', 50, 9),
(4,'2022-10-15', 55, 6),
(5, '2022-10-16', 60, 7),
(6, '2022-10-17', 48, 8),
(7,'2022-10-18', 54, 10),
(8, '2022-10-19', 78, 1),
(9, '2022-10-20', 89, 2),
(10,'2022-10-21', 56, 3);

INSERT INTO [rozliczenia].[premie]([id_premii], [rodzaj], [kwota]) VALUES
(1, 'kwartalna', 250),
(2, 'roczna', 500),
(3, '�wi�ta', 900),
(4, 'p�roczna', 350), 
(5, 'bonus', 400), 
(6, 'miesi�czna', 100),
(7, 'awans', 1000),
(8, 'tygodniowa', 50),
(9, 'od szefa', 400),
(10, 'za zas�ugi', 600);

INSERT INTO [rozliczenia].[pensje]([id_pensji], [stanowisko], [kwota_brutto], [id_premii]) VALUES
(1, 'ksi�gowa', 5638.87, 1),
(2, 'sprz�taczka', 4568.90, 2),
(3, 'hr', 4682.52, 4),
(4,'asystent', 2459.90, 3),
(5, 'ochroniarz', 4579.98, 6),
(6, 'programista', 6730.12, 5),
(7, 'analizer', 9202.82, 7),
(8, 'recepcjonistka', 3454.90, 9),
(9, 'szef', 9343.90, 8),
(10, 'zast�pca szefa', 8901.81, 10);


SELECT nazwisko, adres FROM rozliczenia.pracownicy;

SELECT
    id_godziny,
    data,
    DATEPART(weekday, data) AS dzien_tygodnia,
    DATEPART(month, data) AS miesiac
FROM rozliczenia.godziny;

ALTER TABLE [rozliczenia].[pensje]
ADD [kwota_netto] DECIMAL(10,2);


UPDATE [rozliczenia].[pensje]
SET [kwota_netto] = ROUND([kwota_brutto] * 0.77, 2);

SELECT kwota_netto FROM rozliczenia.pensje;