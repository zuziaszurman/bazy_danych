

USE [AdventureWorks2022];
GO
CREATE SCHEMA ADV;
GO


-- 1
CREATE FUNCTION ADV.genFibonacci(@n INT) --bierze dan� liczb�, d�ugo�� ciagu Fibonacciego
RETURNS NVARCHAR(MAX)
AS
BEGIN
��DECLARE @b INT = 0, @a INT = 1;  -- "b" to pierwszy/poprzedni element, "a" to drugi/aktualny element
��DECLARE @temp INT = 0; -- do tymczsowego przechowywania warto�ci zmiennych
��DECLARE @seq NVARCHAR(MAX) = CONVERT(NVARCHAR(MAX), @b) + ', '; -- zmienna, w kt�rej b�dzie przechowywany ci�g Fibonnaciego
  DECLARE @i INT = 0

  WHILE @i < @n - 1
��BEGIN
����SET @seq = @seq + CONVERT(NVARCHAR(MAX), @a) + ', '; --zamieniamy na nvarcharmax, �eby m�c przechowywa� tak�e przecinki 
����SET @temp = @a; -- przechowuje stare a
����SET @a = @a + @b; --nowe a r�wna si� stare a plus liczba znajduj�ca si� przed a 
����SET @b = @temp; --stare a zostaje przypisane do b czyli warto�ci poprzedniej

	SET @i = @i + 1;

��END;
  �RETURN @seq; 
END;
GO

CREATE PROCEDURE ADV.getFibonacci (@n INT)
AS
BEGIN
��DECLARE @fib NVARCHAR(MAX);

��SELECT @fib = ADV.genFibonacci(@n); -- przypisuje do zmiennej to co zwr�ci funkcja

��PRINT @fib; --wypisuje wynik w konsoli
END;
GO

EXEC ADV.getFibonacci @n = 20;  -- wywo�uje procedur�, kt�ra wywo�uje funkcje
GO

--2

CREATE TRIGGER triggerUPPERnazwisko
ON Person.Person --okre�la na jakiej tabeli ma dzia�a� trigger
AFTER INSERT, UPDATE, DELETE -- po u�yciu kt�rej� z tych funkcji, zostanie wypisany komunikat na konsoli oraz zmienione nazwisko na wielk� liter�
AS
BEGIN
	PRINT 'Dokonales/as zmiany na tabeli Person!!' -- komunikat na konsoli 
    UPDATE Person.Person --gdzie dokunujemy zmiany
    SET LastName = UPPER(LastName) -- zmienia atrybut nazwisko na pisane z wielkich liter
	WHERE BusinessEntityID IN (SELECT BusinessEntityID FROM inserted) --ogranicza aktualizacj� do rekord�w kt�re zosta�y zmodyfikowane
	
END;
GO

INSERT INTO Person.BusinessEntity (rowguid) -- dodaje nowy wiersz do podanej tabeli
VALUES (NEWID()); --�eby nie trzeba by�o dawa� drop constraint, dodajemy nowy wiersz do tabeli BusinessEntity

INSERT INTO Person.Person (BusinessEntityID, PersonType, NameStyle, FirstName, LastName, EmailPromotion, ModifiedDate)
VALUES (20778, 'IN' , 0, 'Sam', 'Sam', 0, '2012-05-27 00:00:00.000'); --sprawdzenie czy trigger dzia�a
GO

UPDATE Person.Person SET FirstName = 'Krzysztof' WHERE BusinessEntityID = 1 --sprawdzenie czy trigger dzia�a

SELECT *
FROM Person.Person
GO


--3

CREATE TRIGGER taxRateMonitoring 
ON [Sales].[SalesTaxRate] 
AFTER UPDATE  --trigger dzia�a tylko po update
AS
BEGIN
	DECLARE @stary FLOAT; --b�d� przechowywa� warto�ci atrybutu taxRate
	DECLARE @nowy FLOAT;

 
    SELECT @stary = TaxRate FROM deleted; --przypisuje usuni�te elementy z tabeli wirtualnej
    SELECT @nowy = TaxRate FROM inserted; --przypisuje nowo wstawione 
	 
    IF ABS((@nowy - @stary)/@stary) > 0.3 --sprawdza czy zmiana jest wi�ksza od 30%
        BEGIN
			RAISERROR ('Za du�a zmiana w TaxRate',1,16); -- 1 stopie� b��du, 16 priorytet b��du mo�e by� dowolny dodatni
			ROLLBACK TRANSACTION; --powoduje anulowanie wprowadzanej zmiany
        END;
END;
GO

UPDATE Sales.SalesTaxRate --sprawdzenie czy trigger dzia�a
SET TaxRate = 30
WHERE SalesTaxRateID = 1

SELECT * FROM Sales.SalesTaxRate

