
--1 zmiana ceny konkretnego id o 10%
BEGIN TRANSACTION

UPDATE Production.Product 
SET ListPrice = ListPrice * 1.10
WHERE ProductID = 680;
COMMIT TRANSACTION

SELECT * FROM Production.Product


--2 Usuni�cie produktu, kt�rego id jest r�wne 707 

ALTER TABLE Production.ProductCostHistory NOCHECK CONSTRAINT ALL --wy��cza ograniczenia, aby m�c usun�� rekord, integralno�� danych ignorowana
ALTER TABLE Production.ProductInventory NOCHECK CONSTRAINT ALL
ALTER TABLE Production.ProductListPriceHistory NOCHECK CONSTRAINT ALL
ALTER TABLE Production.ProductProductPhoto NOCHECK CONSTRAINT ALL
ALTER TABLE Purchasing.ProductVendor NOCHECK CONSTRAINT ALL
ALTER TABLE Purchasing.PurchaseOrderDetail NOCHECK CONSTRAINT ALL
ALTER TABLE Sales.SpecialOfferProduct  NOCHECK CONSTRAINT ALL
ALTER TABLE Production.TransactionHistory NOCHECK CONSTRAINT ALL 

BEGIN TRANSACTION

DELETE FROM Production.Product
WHERE ProductID = 707;

ROLLBACK TRANSACTION --wycofuje transakcj� wi�c nic si� nie usuwa

SELECT * FROM Production.Product

ALTER TABLE Production.ProductCostHistory CHECK CONSTRAINT ALL;
ALTER TABLE Production.ProductInventory CHECK CONSTRAINT ALL;
ALTER TABLE Production.ProductListPriceHistory CHECK CONSTRAINT ALL;
ALTER TABLE Production.ProductProductPhoto CHECK CONSTRAINT ALL;
ALTER TABLE Purchasing.ProductVendor CHECK CONSTRAINT ALL;
ALTER TABLE Purchasing.PurchaseOrderDetail CHECK CONSTRAINT ALL;
ALTER TABLE Sales.SpecialOfferProduct CHECK CONSTRAINT ALL;
ALTER TABLE Production.TransactionHistory CHECK CONSTRAINT ALL;


--3 dodaje nowy produkt do tabeli i zatwierdza transakcj�

BEGIN TRANSACTION

INSERT INTO Production.Product (Name, ProductNumber, MakeFlag, FinishedGoodsFlag, SafetyStockLevel, ReorderPoint,StandardCost,ListPrice,
DaysToManufacture, SellStartDate, rowguid, ModifiedDate)
VALUES ('Ball', 'RE-567', 1, 0, 1000, 350, 0.00, 0.00, 1, '2008-04-30 00:00:00.000', NEWID(), '2014-02-09 10:02:36:678')

COMMIT TRANSACTION

SELECT * FROM Production.Product



--4 Aktualizuje standarcost tylko wtedy kiedy suma ich * 1.10 b�dzie mniejsza ni� 50 ty� 

SELECT * FROM Production.Product

BEGIN TRANSACTION 

UPDATE Production.Product
SET StandardCost = StandardCost * 1.10;

IF (SELECT SUM(StandardCost) FROM Production.Product) > 50000
BEGIN 
	ROLLBACK TRANSACTION;
END
ELSE 
BEGIN 
	COMMIT;
END


SELECT * FROM Production.Product 

--5 dodanie nowego produktu, je�li istnieje ju� taki numer produktu, to cofnij transakcj�, je�li nie to zatwierd� transakcj� 

BEGIN TRANSACTION 

DECLARE @Numer VARCHAR(20);
SET @Numer = 'AL-5381';

IF EXISTS (SELECT 1 FROM Production.Product WHERE ProductNumber = @Numer) --je�li istnieje ju� takie numer to wycofaj, je�li nie to zatwierd�
BEGIN 
	ROLLBACK TRANSACTION
END
ELSE
BEGIN
	INSERT INTO Production.Product (Name, ProductNumber, MakeFlag, FinishedGoodsFlag, SafetyStockLevel, ReorderPoint,StandardCost,ListPrice,
		DaysToManufacture, SellStartDate, rowguid, ModifiedDate)
	VALUES ('Ball3', @Numer, 1, 0, 1000, 350, 0.00, 0.00, 1, '2008-04-30 00:00:00.000', NEWID(), '2014-02-09 10:02:36:678') --newid generuje unikalny identyfikator globalny
	COMMIT TRANSACTION
END

SELECT * FROM Production.Product WHERE ProductNumber = @Numer


--6 aktualizacja warto�ci orderqty tylko i wy��cznie wtedy kiedy �adne orderqty nie jest r�wne zero, je�li jest anulowanie transakcji 
SELECT * FROM Sales.SalesOrderDetail

BEGIN TRANSACTION 
UPDATE Sales.SalesOrderDetail
SET OrderQty = OrderQty * 2; -- aktualizuje order quantity na now� warto�� 

IF EXISTS (SELECT OrderQty FROM Sales.SalesOrderDetail WHERE OrderQty = 0) -- je�li istnieje rekord kt�rego orderqty jest r�wne zero, to wycofaj, je�li nie to zatwierd�
BEGIN 
	ROLLBACK TRANSACTION 
END
ELSE 
BEGIN 
	COMMIT TRANSACTION 
END 

SELECT * FROM Sales.SalesOrderDetail


-- 7 sprawdza ile produkt�w ma wi�ksz� cen� ni� �rednia ze wszystkich produkt�w, je�li jest ich wi�cej ni� 10 to transakcja jest anulowana, je�li nie to usuwaj� si� wszystkie elementy kt�re spe�niaj� to kryterium 

ALTER TABLE Production.BillOfMaterials NOCHECK CONSTRAINT ALL
ALTER TABLE Production.WorkOrder NOCHECK CONSTRAINT ALL
ALTER TABLE Production.ProductReview NOCHECK CONSTRAINT ALL
ALTER TABLE Production.ProductDocument NOCHECK CONSTRAINT ALL
ALTER TABLE Production.ProductProductPhoto NOCHECK CONSTRAINT ALL
ALTER TABLE Sales.SpecialOfferProduct NOCHECK CONSTRAINT ALL
ALTER TABLE Production.TransactionHistory NOCHECK CONSTRAINT ALL
ALTER TABLE Production.ProductCostHistory NOCHECK CONSTRAINT ALL
ALTER TABLE Production.ProductListPriceHistory NOCHECK CONSTRAINT ALL
ALTER TABLE Production.ProductInventory NOCHECK CONSTRAINT ALL

SELECT * FROM Production.Product

BEGIN TRANSACTION 

DECLARE @ile INT;
DELETE FROM Production.Product
WHERE StandardCost > (
  SELECT AVG(StandardCost) FROM Production.Product
);

SET @ile = @@ROWCOUNT; --liczba wszystkich wierszy, na kt�rych przeprowadzono operacj�, czyli w tym przypadku usuni�tych 

IF (@ile > 10)
BEGIN 
	RAISERROR('Nie mo�na usun�� wi�cej ni� 10 produkt�w. %d produkt�w ma wy�sz� cen� ni� �rednia.', 16, 1, @ile);
	ROLLBACK TRANSACTION
END
ELSE 
BEGIN 
	COMMIT TRANSACTION
END 

SELECT * FROM Production.Product

ALTER TABLE Production.BillOfMaterials CHECK CONSTRAINT ALL
ALTER TABLE Production.WorkOrder CHECK CONSTRAINT ALL
ALTER TABLE Production.ProductReview CHECK CONSTRAINT ALL
ALTER TABLE Production.ProductDocument CHECK CONSTRAINT ALL
ALTER TABLE Production.ProductProductPhoto CHECK CONSTRAINT ALL
ALTER TABLE Sales.SpecialOfferProduct CHECK CONSTRAINT ALL
ALTER TABLE Production.TransactionHistory CHECK CONSTRAINT ALL
ALTER TABLE Production.ProductCostHistory CHECK CONSTRAINT ALL
ALTER TABLE Production.ProductListPriceHistory CHECK CONSTRAINT ALL
ALTER TABLE Production.ProductInventory CHECK CONSTRAINT ALL

