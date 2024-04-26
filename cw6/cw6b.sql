

USE [firma_];
GO
CREATE SCHEMA ksiegowosc;
GO

CREATE TABLE ksiegowosc.pracownicy(
id_pracownika INT NOT NULL PRIMARY KEY,
imie NVARCHAR(20) NOT NULL,
nazwisko NVARCHAR(20) NOT NULL,
adres NVARCHAR(50) NOT NULL, 
telefon VARCHAR(20) NOT NULL
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
(2, '2022-10-13', 160,5),
(3, '2022-10-14', 160, 9),
(4,'2022-10-15', 160, 6),
(5, '2022-10-16', 160, 7),
(6, '2022-10-17', 180, 8),
(7,'2022-10-18', 160, 10),
(8, '2022-10-19', 160, 1),
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


--CWICZENIA 6

--A dodaj numer kierunkowy do atrybutu telefon
UPDATE ksiegowosc.pracownicy
SET telefon = CONCAT('(+48)', CAST(telefon AS VARCHAR(50))) --CONCAT ³¹czy ze sob¹ ci¹gi znaków, CAST zamienia typ atrybutu
SELECT imie, nazwisko, telefon
FROM ksiegowosc.pracownicy


--B zmodyfikuj atrybut telefon na wyœwietlanie w postaci 111-111-111
UPDATE ksiegowosc.pracownicy
SET telefon = CONCAT(SUBSTRING(telefon, 6, 3), '-', SUBSTRING(telefon, 9, 3), '-', SUBSTRING(telefon, 12,3))
--SUBSTRING pobiera okreœlone znaki zaczynaj¹c od okreœlonej pozycji
SELECT imie, nazwisko, telefon
FROM ksiegowosc.pracownicy


--C wyœwietl dane pracownika, którego nazwisko jest najd³u¿sze za pomoc¹ wielkich liter
SELECT TOP 1 id_pracownika, imie, UPPER(nazwisko) as NAZWISKO, adres, telefon --UPPER konwertuje na wielkie litery
FROM ksiegowosc.pracownicy
ORDER BY LEN(nazwisko) DESC --sortuje wyniki w kolejnoœci od najd³u¿szego do najkrótszego, wed³ug d³ugoœci nazwiska

--D wyœwietl dane pracowników i ich pensje zakodowane za pomoc¹ algorytmu MD5
SELECT imie, nazwisko, HASHBYTES('MD5',  CAST(kwota AS VARCHAR(20))) AS pensja_md5
FROM ksiegowosc.wynagrodzenie
INNER JOIN ksiegowosc.pracownicy ON wynagrodzenie.id_pracownika = pracownicy.id_pracownika
INNER JOIN ksiegowosc.pensja ON wynagrodzenie.id_pensji = pensja.id_pensji


--F wyœwietl premie oraz pensje pracowników wykorzystuj¹c z³¹czenie lewostronne
SELECT
  p.imie,
  p.nazwisko,
  pe.kwota AS pensja,
  pr.kwota AS premia
FROM ksiegowosc.wynagrodzenie w
LEFT JOIN ksiegowosc.pracownicy p ON w.id_pracownika = p.id_pracownika
LEFT JOIN ksiegowosc.premie pr ON w.id_premii = pr.id_premii
LEFT JOIN ksiegowosc.pensja pe ON w.id_pensji = pe.id_pensji

--G wyœwietl raport wed³ug danego schematu
SELECT
		CONCAT('Pracownik ', p.imie, ' ', p.nazwisko, ', w dniu ', FORMAT(w.data, 'dd.MM.yyyy '), 
        'otrzyma³ pensjê ca³kowit¹ na kwotê: ', 
        FORMAT((pe.kwota + ISNULL(pr.kwota, 0)), '0.00') + 'z³', 
        ', gdzie wynagrodzenie zasadnicze wynosi³o: ', 
        FORMAT(pe.kwota, '0.00') + 'z³', 
        ', premia: ', 
        FORMAT(ISNULL(pr.kwota, 0), '0.00') + 'z³',
		', nadgodziny: ',
		CAST((liczba_godzin-160)*30 AS varchar(10)) + 'zl')
AS raport FROM ksiegowosc.wynagrodzenie w
LEFT JOIN ksiegowosc.pracownicy p ON w.id_pracownika = p.id_pracownika
LEFT JOIN ksiegowosc.godziny g ON w.id_godziny = g.id_godziny
LEFT JOIN ksiegowosc.pensja pe ON w.id_pensji = pe.id_pensji
LEFT JOIN ksiegowosc.premie pr ON w.id_premii = pr.id_premii
--FORMAT formatuje wartoœci tekstowe/liczbowe na podany format
--ISNULL sprawdza czy wartoœæ jest równa NULL, jeœli tak to wstawia okreœlon¹ wartoœæ za ni¹ (w tym przypadku 0)


--INNER JOIN zwraca jedynie wartoœci (identyfikatory) wspólne dla obu tabel
--LEFT JOIN zwraca wszystkie dane z tabeli lewej oraz dane z prawej tabeli tylko te co maj¹ ten sam identyfikator, zwraca wszystkie z pierwszej tabeli, ale nie musi zwróciæ wszystkich z drugiej