
--1 Stworzenie tabeli tymczasowej, kt�ra przechowuje informacje na temat stawki i pracownika

--zdefiniowanie tymczosowego zbioru wynik�w
WITH zapis(BusinessEntityID, FirstName, LastName, Rate) 
AS(
	SELECT pp.BusinessEntityID, pp.FirstName, pp.LastName, er.Rate
	FROM Person.Person pp 
	JOIN HumanResources.EmployeePayHistory er ON pp.BusinessEntityID = er.BusinessEntityID -- ��czy tabele za pomoc� odpowiednich ID
)
SELECT BusinessEntityID, FirstName, LastName,MAX(Rate) as Rate --�eby wy�wietla�a si� tylko jedna stawka
INTO #TempEmployeeInfo --zapisanie do konkretnej tabeli tymczasowej
FROM zapis
GROUP BY BusinessEntityID, LastName, FirstName-- �eby dzia�a�o max
SELECT * FROM #TempEmployeeInfo -- Wy�wietlanie tabeli 
DROP TABLE #TempEmployeeInfo --Usuwanie tabeli


--2 Przychody ze sprzeda�y wed�ug firmy i kontaktu

ALTER TABLE SalesLT.Customer
ADD CompanyContact VARCHAR(70); -- dodanie nowej kolumny w tabeli

UPDATE SalesLT.Customer
SET CompanyContact = concat(CompanyName, ' (', FirstName,' ',LastName,')') --ustawia atrybut jako po��czenie innych atrybut�w

WITH zapis2 (CompanyContact, TotalDue)
AS (
	SELECT CompanyContact ,TotalDue FROM SalesLT.Customer JOIN 
	SalesLT.SalesOrderHeader ON SalesLT.SalesOrderHeader.CustomerID = SalesLT.Customer.CustomerID 
)
SELECT CompanyContact, TotalDue as Revenue --wybiera atrybuty z tablei tymczasowej oraz zmienia nazw�
FROM zapis2
ORDER BY CompanyContact --sortuje wyniki rosn�co alfabetycznie


--3 Zwr�ci� warto�� sprzeda�y dla poszczeg�lnych kategorii produkt�w

WITH zapis3 (Name,ProductCategoryID, LineTotal)
AS (
	SELECT [pc].[Name],  pc.ProductCategoryID, so.LineTotal FROM SalesLT.ProductCategory pc 
	JOIN SalesLT.Product p ON  pc.ProductCategoryID = p.ProductCategoryID
	JOIN SalesLT.SalesOrderDetail so ON p.ProductID = so.ProductID
	)
SELECT 
	Name as Category, 
	Convert(Decimal(10,2), Round(SUM(LineTotal), 2)) AS SalesValue --liczy sum� ka�dej unikalnej warto�ci Name
INTO #temp2 --zapisuje wynik do tabeli tymczasowej 
FROM zapis3
GROUP BY Name --musi by� �eby dzia�a�o convert, grupuje wszystkie te same Name w jedn� grup�

SELECT Category, SalesValue FROM #temp2 
WHERE Category = 'Bike Racks' --wybranie odpowiednich kategorii
OR Category = 'Bottles and Cages' 
OR Category = 'Cleaners'
OR Category = 'Helmets'
OR Category = 'Hydration Packs'
OR Category = 'Tires and Tubes'

DROP TABLE #temp2 
