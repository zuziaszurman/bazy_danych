USE [firma];
GO
CREATE SCHEMA ksiegowosc;
GO

CREATE TABLE ksiegowosc.pracownicy(
id_pracownika INT NOT NULL PRIMARY KEY,
imie NVARCHAR(20) NOT NULL,
nazwisko NVARCHAR(20) NOT NULL,
adres NVARCHAR(50) NOT NULL, 
telefon INT NOT NULL
);

CREATE TABLE ksiegowosc.godziny(
id_godziny INT NOT NULL PRIMARY KEY,
[data] DATE NOT NULL, 
liczba_godzin INT NOT NULL, 
id_pracownika INT NOT NULL,
FOREIGN KEY (id_pracownika) REFERENCES ksiegowosc.pracownicy(id_pracownika)
);

CREATE TABLE ksiegowosc.pensja(
id_pensji INT NOT NULL PRIMARY KEY, 
stanowisko NVARCHAR(20) NOT NULL,
kwota DECIMAL(10,2) NOT NULL
);

CREATE TABLE ksiegowosc.premie(
id_premii INT NOT NULL PRIMARY KEY,
rodzaj NVARCHAR(20) NOT NULL,
kwota DECIMAL(10,2) NOT NULL
);

CREATE TABLE ksiegowosc.wynagrodzenie(
id_wynagrodzenia INT NOT NULL PRIMARY KEY,
[data] DATE NOT NULL,
id_pracownika INT NOT NULL,
id_godziny INT NOT NULL,
id_pensji INT NOT NULL,
id_premii INT,
FOREIGN KEY (id_pracownika) REFERENCES ksiegowosc.pracownicy(id_pracownika),
FOREIGN KEY (id_godziny) REFERENCES ksiegowosc.godziny(id_godziny),
FOREIGN KEY (id_pensji) REFERENCES ksiegowosc.pensja(id_pensji),
FOREIGN KEY (id_premii) REFERENCES ksiegowosc.premie(id_premii)
);


INSERT INTO [ksiegowosc].[pracownicy] ([id_pracownika], [imie], [nazwisko], [adres], [telefon]) VALUES
(1, 'Jan', 'Kowalski', 'Kraków, ul.D³uga 1', '568798789'),
(2, 'Justyna', 'Taka', 'Poznañ, ul.Krótka 2', '123456789'),
(3, 'Michal', 'Michalowski', 'Miko³ów, ul.Michalska 6', '567890123'),
(4, 'Marcin', 'Kula', 'Kraków, ul.Floriañska 3', '123890567'),
(5, 'Milena', '£opata', 'Warszwa, ul.Zachodnia 4', '566382560'),
(6, 'Bogus³aw', 'Notarowski', 'Boles³awiec, ul.Boles³awska 3', '345652782'),
(7, 'Zdzis³awa', 'Nowa', 'Zagrzeb, ul.Zdzis³owiañska 6', '111111111'),
(8, 'Miros³aw', 'Miros³awski', 'Mikoja³owice, ul.Miko³aja 6', '222222222'),
(9, 'Franicszek', 'Pierwszy;', 'Kraków, ul.Grocka 10', '333333333'),
(10, 'Lechos³aw', 'Drugi', 'Toruñ, ul.Toruñska 10', '444444444');

INSERT INTO [ksiegowosc].[godziny]([id_godziny], [data], [liczba_godzin], [id_pracownika]) VALUES
(1,'2022-10-12', 180, 4),
(2, '2022-10-13', 140,5),
(3, '2022-10-14', 160, 9),
(4,'2022-10-15', 150, 6),
(5, '2022-10-16', 160, 7),
(6, '2022-10-17', 180, 8),
(7,'2022-10-18', 160, 10),
(8, '2022-10-19', 140, 1),
(9, '2022-10-20', 190, 2),
(10,'2022-10-21', 195, 3);

INSERT INTO [ksiegowosc].[premie]([id_premii], [rodzaj], [kwota]) VALUES
(1, 'kwartalna', 250),
(2, 'roczna', 500),
(3, 'œwiêta', 900),
(4, 'pó³roczna', 350), 
(5, 'bonus', 400), 
(6, 'miesiêczna', 100),
(7, 'awans', 1000),
(8, 'tygodniowa', 50),
(9, 'od szefa', 400),
(10, 'za zas³ugi', 600);

INSERT INTO [ksiegowosc].[pensja]([id_pensji], [stanowisko], [kwota]) VALUES
(1, 'ksiêgowa', 5638.87),
(2, 'sprz¹taczka', 4568.90),
(3, 'hr', 4682.52),
(4,'asystent', 1859.90),
(5, 'asystent', 4579.9),
(6, 'programista', 6730.12),
(7, 'asystent', 2202.82),
(8, 'recepcjonistka', 954.90),
(9, 'szef', 9343.90),
(10, 'zastêpca szefa', 8901.81);

INSERT INTO [ksiegowosc].[wynagrodzenie]([id_wynagrodzenia], [data], [id_pracownika], [id_godziny], [id_pensji], [id_premii]) VALUES
(1,'2022-12-10', 10, 7, 1, 2),
(2, '2022-12-11', 9, 3, 2, 3),
(3, '2022-12-12', 8, 6, 3, 4),
(4, '2022-12-13', 7, 5, 4, NULL),
(5, '2022-12-14', 6, 4, 5, 5),
(6, '2022-12-15', 5, 2, 6, 6),
(7, '2022-12-16', 4, 1, 7, NULL),
(8, '2022-12-17', 3, 10, 8, NULL),
(9, '2022-12-18', 2, 9, 9, NULL),
(10, '2022-12-19', 1, 8, 10, 9);

--6A 
SELECT id_pracownika, nazwisko FROM ksiegowosc.pracownicy;

--6B
SELECT id_pracownika
FROM ksiegowosc.wynagrodzenie
INNER JOIN ksiegowosc.pensja ON wynagrodzenie.id_pensji = pensja.id_pensji
WHERE pensja.kwota > 1000;

-- 6C
SELECT id_pracownika
FROM ksiegowosc.wynagrodzenie
INNER JOIN ksiegowosc.pensja ON wynagrodzenie.id_pensji = pensja.id_pensji
WHERE id_premii IS NULL AND pensja.kwota > 2000;

--6D
SELECT imie, nazwisko
FROM ksiegowosc.pracownicy
WHERE imie LIKE 'J%';

--6E
SELECT imie, nazwisko
FROM ksiegowosc.pracownicy
WHERE nazwisko LIKE '%n%' and imie LIKE'%a';

--6F
SELECT imie, nazwisko,liczba_godzin
FROM ksiegowosc.pracownicy
INNER JOIN ksiegowosc.godziny ON pracownicy.id_pracownika = godziny.id_pracownika
WHERE godziny.liczba_godzin >= 160

--6G
SELECT pracownicy.imie, pracownicy.nazwisko, pensja.kwota 
FROM ksiegowosc.pracownicy
INNER JOIN ksiegowosc.wynagrodzenie ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika
INNER JOIN ksiegowosc.pensja ON wynagrodzenie.id_pensji = pensja.id_pensji
WHERE pensja.kwota BETWEEN 1500 AND 3000;

--6H
SELECT imie, nazwisko,liczba_godzin 
FROM ksiegowosc.pracownicy
INNER JOIN ksiegowosc.godziny ON pracownicy.id_pracownika = godziny.id_pracownika
LEFT JOIN ksiegowosc.wynagrodzenie ON pracownicy.id_pracownika = wynagrodzenie.id_premii
WHERE godziny.liczba_godzin >= 160 and wynagrodzenie.id_premii is NULL

--6I
SELECT  imie, nazwisko, kwota
FROM ksiegowosc.pracownicy
INNER JOIN ksiegowosc.wynagrodzenie ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika
INNER JOIN ksiegowosc.pensja ON wynagrodzenie.id_pensji = pensja.id_pensji
ORDER BY pensja.kwota

--6J
SELECT imie, nazwisko, pensja.kwota as pensja, premie.kwota as premia
FROM ksiegowosc.pracownicy
INNER JOIN ksiegowosc.wynagrodzenie ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika
LEFT JOIN ksiegowosc.pensja ON wynagrodzenie.id_pensji = pensja.id_pensji
LEFT JOIN ksiegowosc.premie ON wynagrodzenie.id_premii = premie.id_premii
ORDER BY pensja DESC, premia DESC;

--6K
SELECT pensja.stanowisko, COUNT(*) AS liczba_pracownikow
FROM ksiegowosc.pensja
GROUP BY pensja.stanowisko;

--6L
SELECT
    AVG(pensja.kwota) AS srednia_placa,
    MIN(pensja.kwota) AS minimalna_placa, 
    MAX(pensja.kwota) AS maksymalna_placa
FROM ksiegowosc.wynagrodzenie
INNER JOIN ksiegowosc.pensja ON wynagrodzenie.id_pensji = pensja.id_pensji
WHERE pensja.stanowisko = 'asystent';

--6M
SELECT SUM(pensja.kwota) AS suma_wynagrodzen
FROM ksiegowosc.wynagrodzenie
INNER JOIN ksiegowosc.pensja ON wynagrodzenie.id_pensji = pensja.id_pensji;

--6N
SELECT stanowisko, SUM(pensja.kwota) AS suma_wynagrodzen
FROM ksiegowosc.wynagrodzenie
INNER JOIN ksiegowosc.pensja ON wynagrodzenie.id_pensji = pensja.id_pensji
WHERE stanowisko = 'asystent'
GROUP BY stanowisko;

--6O
SELECT stanowisko, COUNT(wynagrodzenie.id_premii) AS liczba_premii
FROM ksiegowosc.wynagrodzenie
INNER JOIN ksiegowosc.pensja ON wynagrodzenie.id_pensji = pensja.id_pensji
WHERE kwota > 0
AND stanowisko = 'asystent'
GROUP BY stanowisko;

--6P
ALTER TABLE ksiegowosc.godziny
DROP CONSTRAINT [FK__godziny__id_prac__398D8EEE]
ALTER TABLE ksiegowosc.wynagrodzenie
DROP CONSTRAINT [FK__wynagrodz__id_pr__403A8C7D]

DELETE FROM ksiegowosc.pracownicy WHERE id_pracownika IN (
SELECT id_pracownika
FROM ksiegowosc.wynagrodzenie
INNER JOIN ksiegowosc.pensja ON wynagrodzenie.id_pensji = pensja.id_pensji
WHERE pensja.kwota < 1200
);

SELECT id_pracownika, nazwisko FROM ksiegowosc.pracownicy;