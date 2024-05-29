
--1 zmiana ceny konkretnego id o 10%
BEGIN TRANSACTION

UPDATE Production.Product 
SET ListPrice = ListPrice * 1.10
WHERE ProductID = 680;
COMMIT TRANSACTION

SELECT * FROM Production.Product


--2 Usuniêcie produktu, którego id jest równe 707 

ALTER TABLE Production.ProductCostHistory NOCHECK CONSTRAINT ALL --wy³¹cza ograniczenia, aby móc usun¹æ rekord, integralnoœæ danych ignorowana
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

ROLLBACK TRANSACTION --wycofuje transakcjê wiêc nic siê nie usuwa

SELECT * FROM Production.Product

ALTER TABLE Production.ProductCostHistory CHECK CONSTRAINT ALL;
ALTER TABLE Production.ProductInventory CHECK CONSTRAINT ALL;
ALTER TABLE Production.ProductListPriceHistory CHECK CONSTRAINT ALL;
ALTER TABLE Production.ProductProductPhoto CHECK CONSTRAINT ALL;
ALTER TABLE Purchasing.ProductVendor CHECK CONSTRAINT ALL;
ALTER TABLE Purchasing.PurchaseOrderDetail CHECK CONSTRAINT ALL;
ALTER TABLE Sales.SpecialOfferProduct CHECK CONSTRAINT ALL;
ALTER TABLE Production.TransactionHistory CHECK CONSTRAINT ALL;


--3 dodaje nowy produkt do tabeli i zatwierdza transakcjê

BEGIN TRANSACTION

INSERT INTO Production.Product (Name, ProductNumber, MakeFlag, FinishedGoodsFlag, SafetyStockLevel, ReorderPoint,StandardCost,ListPrice,
DaysToManufacture, SellStartDate, rowguid, ModifiedDate)
VALUES ('Ball', 'RE-567', 1, 0, 1000, 350, 0.00, 0.00, 1, '2008-04-30 00:00:00.000', NEWID(), '2014-02-09 10:02:36:678')

COMMIT TRANSACTION

SELECT * FROM Production.Product



--4 Aktualizuje standarcost tylko wtedy kiedy suma ich * 1.10 bêdzie mniejsza ni¿ 50 tyœ 

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

--5 dodanie nowego produktu, jeœli istnieje ju¿ taki numer produktu, to cofnij transakcjê, jeœli nie to zatwierdŸ transakcjê 

BEGIN TRANSACTION 

DECLARE @Numer VARCHAR(20);
SET @Numer = 'AL-5381';

IF EXISTS (SELECT 1 FROM Production.Product WHERE ProductNumber = @Numer) --jeœli istnieje ju¿ takie numer to wycofaj, jeœli nie to zatwierdŸ
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


--6 aktualizacja wartoœci orderqty tylko i wy³¹cznie wtedy kiedy ¿adne orderqty nie jest równe zero, jeœli jest anulowanie transakcji 
SELECT * FROM Sales.SalesOrderDetail

BEGIN TRANSACTION 
UPDATE Sales.SalesOrderDetail
SET OrderQty = OrderQty * 2; -- aktualizuje order quantity na now¹ wartoœæ 

IF EXISTS (SELECT OrderQty FROM Sales.SalesOrderDetail WHERE OrderQty = 0) -- jeœli istnieje rekord którego orderqty jest równe zero, to wycofaj, jeœli nie to zatwierdŸ
BEGIN 
	ROLLBACK TRANSACTION 
END
ELSE 
BEGIN 
	COMMIT TRANSACTION 
END 

SELECT * FROM Sales.SalesOrderDetail


-- 7 sprawdza ile produktów ma wiêksz¹ cenê ni¿ œrednia ze wszystkich produktów, jeœli jest ich wiêcej ni¿ 10 to transakcja jest anulowana, jeœli nie to usuwaj¹ siê wszystkie elementy które spe³niaj¹ to kryterium 

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

SET @ile = @@ROWCOUNT; --liczba wszystkich wierszy, na których przeprowadzono operacjê, czyli w tym przypadku usuniêtych 

IF (@ile > 10)
BEGIN 
	RAISERROR('Nie mo¿na usun¹æ wiêcej ni¿ 10 produktów. %d produktów ma wy¿sz¹ cenê ni¿ œrednia.', 16, 1, @ile);
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

