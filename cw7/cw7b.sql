

USE [AdventureWorks2022];
GO
CREATE SCHEMA ADV;
GO


-- 1
CREATE FUNCTION ADV.genFibonacci(@n INT) --bierze dan¹ liczbê, d³ugoœæ ciagu Fibonacciego
RETURNS NVARCHAR(MAX)
AS
BEGIN
  DECLARE @b INT = 0, @a INT = 1;  -- "b" to pierwszy/poprzedni element, "a" to drugi/aktualny element
  DECLARE @temp INT = 0; -- do tymczsowego przechowywania wartoœci zmiennych
  DECLARE @seq NVARCHAR(MAX) = CONVERT(NVARCHAR(MAX), @b) + ', '; -- zmienna, w której bêdzie przechowywany ci¹g Fibonnaciego
  DECLARE @i INT = 0

  WHILE @i < @n - 1
  BEGIN
    SET @seq = @seq + CONVERT(NVARCHAR(MAX), @a) + ', '; --zamieniamy na nvarcharmax, ¿eby móc przechowywaæ tak¿e przecinki 
    SET @temp = @a; -- przechowuje stare a
    SET @a = @a + @b; --nowe a równa siê stare a plus liczba znajduj¹ca siê przed a 
    SET @b = @temp; --stare a zostaje przypisane do b czyli wartoœci poprzedniej

	SET @i = @i + 1;

  END;
   RETURN @seq; 
END;
GO

CREATE PROCEDURE ADV.getFibonacci (@n INT)
AS
BEGIN
  DECLARE @fib NVARCHAR(MAX);

  SELECT @fib = ADV.genFibonacci(@n); -- przypisuje do zmiennej to co zwróci funkcja

  PRINT @fib; --wypisuje wynik w konsoli
END;
GO

EXEC ADV.getFibonacci @n = 20;  -- wywo³uje procedurê, która wywo³uje funkcje
GO

--2

CREATE TRIGGER triggerUPPERnazwisko
ON Person.Person --okreœla na jakiej tabeli ma dzia³aæ trigger
AFTER INSERT, UPDATE, DELETE -- po u¿yciu którejœ z tych funkcji, zostanie wypisany komunikat na konsoli oraz zmienione nazwisko na wielk¹ literê
AS
BEGIN
	PRINT 'Dokonales/as zmiany na tabeli Person!!' -- komunikat na konsoli 
    UPDATE Person.Person --gdzie dokunujemy zmiany
    SET LastName = UPPER(LastName) -- zmienia atrybut nazwisko na pisane z wielkich liter
	WHERE BusinessEntityID IN (SELECT BusinessEntityID FROM inserted) --ogranicza aktualizacjê do rekordów które zosta³y zmodyfikowane
	
END;
GO

INSERT INTO Person.BusinessEntity (rowguid) -- dodaje nowy wiersz do podanej tabeli
VALUES (NEWID()); --¿eby nie trzeba by³o dawaæ drop constraint, dodajemy nowy wiersz do tabeli BusinessEntity

INSERT INTO Person.Person (BusinessEntityID, PersonType, NameStyle, FirstName, LastName, EmailPromotion, ModifiedDate)
VALUES (20778, 'IN' , 0, 'Sam', 'Sam', 0, '2012-05-27 00:00:00.000'); --sprawdzenie czy trigger dzia³a
GO

UPDATE Person.Person SET FirstName = 'Krzysztof' WHERE BusinessEntityID = 1 --sprawdzenie czy trigger dzia³a

SELECT *
FROM Person.Person
GO


--3

CREATE TRIGGER taxRateMonitoring 
ON [Sales].[SalesTaxRate] 
AFTER UPDATE  --trigger dzia³a tylko po update
AS
BEGIN
	DECLARE @stary FLOAT; --bêd¹ przechowywaæ wartoœci atrybutu taxRate
	DECLARE @nowy FLOAT;

 
    SELECT @stary = TaxRate FROM deleted; --przypisuje usuniête elementy z tabeli wirtualnej
    SELECT @nowy = TaxRate FROM inserted; --przypisuje nowo wstawione 
	 
    IF ABS((@nowy - @stary)/@stary) > 0.3 --sprawdza czy zmiana jest wiêksza od 30%
        BEGIN
			RAISERROR ('Za du¿a zmiana w TaxRate',1,16); -- 1 stopieñ b³êdu, 16 priorytet b³êdu mo¿e byæ dowolny dodatni
			ROLLBACK TRANSACTION; --powoduje anulowanie wprowadzanej zmiany
        END;
END;
GO

UPDATE Sales.SalesTaxRate --sprawdzenie czy trigger dzia³a
SET TaxRate = 30
WHERE SalesTaxRateID = 1

SELECT * FROM Sales.SalesTaxRate

