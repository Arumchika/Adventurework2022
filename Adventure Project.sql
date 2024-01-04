----Adventurework2022 for my Internship Project



-----Question 1
------Retrieve information about the products with colour values except null, red, silver/black, white and list price between
-------£75 and £750. Rename the column StandardCost to Price. Also, sort the results in descending order by list price

SELECT *
FROM
Production.Product



SELECT TOP 10
    ProductID,
    Name,
    Color
FROM
    Production.Product
WHERE
    ProductNumber LIKE 'BK%'
ORDER BY
    ListPrice DESC;

Select 
   Name As ProductionName,
   Color,
   ListPrice as Price
   from
   Production.Product
   where
   Color IS NOT NULL 
   And Color NOT IN ('Red', 'Silver', 'Black', 'White')
   AND ListPrice BETWEEN 75 AND 750
   ORDER BY
   ListPrice DESC


------Question 2
------Find all the male employees born between 1962 to 1970 and with hire date greater than 2001 and female employees
------born between 1972 and 1975 and hire date between 2001 and 2002

Select *
from HumanResources.Employee

SELECT 
    Gender, 
    BirthDate, 
    HireDate
FROM 
    HumanResources.Employee
WHERE 
    (Gender = 'M' AND BirthDate BETWEEN '1962-01-01' AND '1970-12-31' AND HireDate > '2001-12-31')
    OR (Gender = 'F' AND BirthDate BETWEEN '1972-01-01' AND '1975-12-31' AND HireDate BETWEEN '2001-01-01' AND '2002-12-31')

----Question 3
--- Create a list of 10 most expensive products that have a product number beginning with ‘BK’. Include only the product
----ID, Name and colour.

Select *
from Production.Product


SELECT TOP 10
    ProductID,
    Name,
    Color
FROM
    Production.Product
WHERE
    ProductNumber LIKE 'BK%'
ORDER BY
    ListPrice DESC


---Question 4
---Create a list of all contact persons, where the first 4 characters of the last name are the same asthe first four characters
---of the email address. Also, for all contacts whose first name and the last name begin with the same characters, create
---a new column called full name combining first name and the last name only. Also provide the length ofthe new column


SELECT * 
from Person.Person

Select *
from
Person.EmailAddress 

SELECT 
    p.FirstName,
    p.LastName,
    e.EmailAddress,
    CONCAT(p.FirstName, ' ', p.LastName) AS FullName,
    LEN(CONCAT(p.FirstName, ' ', p.LastName)) AS FullNameLength
FROM 
    Person.Person AS p
    JOIN Person.EmailAddress AS e
        ON p.BusinessEntityID = e.BusinessEntityID
WHERE 
    LEFT(p.LastName, 4) = LEFT(e.EmailAddress, 4)
    AND LEFT(p.FirstName, 4) = LEFT(p.LastName, 4)


-----Question 5
-----Return all product subcategories that take an average of 3 days or longer to manufacture.
select *
from Production.ProductSubcategory

	SELECT ps.Name AS SubcategoryName, AVG(p.DaysToManufacture) AS AvgDaysToManufacture
FROM Production.Product p
JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
GROUP BY ps.Name
HAVING AVG(p.DaysToManufacture) >= 3


----Question 6
----Create a list of product segmentation by defining criteria that places each item in a predefined segment as follows. If
----price gets less than £200 then low value. If price is between £201 and £750 then mid value. If between £750 and £1250
---then mid to high value else higher value. Filter the results only for black, silver and red color products.

SELECT p.ProductID, p.Name AS ProductName, p.Color, p.ListPrice,
    CASE
        WHEN p.ListPrice < 200 THEN 'Low Value'
        WHEN p.ListPrice >= 201 AND p.ListPrice <= 750 THEN 'Mid Value'
        WHEN p.ListPrice > 750 AND p.ListPrice <= 1250 THEN 'Mid to High Value'
        ELSE 'Higher Value'
    END AS ProductSegment
FROM Production.Product p
WHERE p.Color IN ('Black', 'Silver', 'Red')


----Question 7
----How many Distinct Job title is present in the Employee table?

SELECT *
FROM
HumanResources.Employee

SELECT COUNT(DISTINCT JobTitle) AS NumDistinctJobTitles
FROM HumanResources.Employee


-----Question 8
-----Use employee table and calculate the ages of each employee at the time of hiring.



SELECT BusinessEntityID, NationalIDNumber, BirthDate, HireDate,
       DATEDIFF(YEAR, BirthDate, HireDate) AS AgeAtHiring
FROM HumanResources.Employee


-----Question 9
-----How many employees will be due a long service award in the next 5 years, if long service is 20 years?

SELECT COUNT(*) AS NumEmployeesDueAward
FROM HumanResources.Employee
WHERE DATEDIFF(YEAR, HireDate, GETDATE()) >= 20
  AND DATEDIFF(YEAR, HireDate, GETDATE()) < 25


----Question 10
----How many more years does each employee have to work before reaching sentiment, if sentiment age is 65?

SELECT *
FROM 
HumanResources.Employee


  SELECT BusinessEntityID,
  NationalIDNumber, 
  OrganizationLevel, 
  BirthDate, HireDate,
       65 - DATEDIFF(YEAR, BirthDate, GETDATE()) AS YearsToRetirement
FROM HumanResources.Employee



----Question 11
----Implement new price policy on the product table base on the colour of the item
----If white increase price by 8%, If yellow reduce price by 7.5%, If black increase price by 17.2%. If multi, silver,
--- silver/black or blue take the square root of the price and double the value. Column should be called Newprice. For
----each item, also calculate commission as 37.5% of newly computed list price.


SELECT 
    ProductID,
    Name,
    Color,
    ListPrice,
    CASE 
        WHEN Color = 'White' THEN ListPrice * 1.08
        WHEN Color = 'Yellow' THEN ListPrice * 0.925
        WHEN Color = 'Black' THEN ListPrice * 1.172
        WHEN Color IN ('Multi', 'Silver', 'Silver/Black', 'Blue') THEN (SQRT(ListPrice) * 2)
        ELSE ListPrice
    END AS NewPrice,
    (CASE 
        WHEN Color = 'White' THEN ListPrice * 1.08
        WHEN Color = 'Yellow' THEN ListPrice * 0.925
        WHEN Color = 'Black' THEN ListPrice * 1.172
        WHEN Color IN ('Multi', 'Silver', 'Silver/Black', 'Blue') THEN (SQRT(ListPrice) * 2)
        ELSE ListPrice
    END) * 0.375 AS Commission
FROM Production.Product


                         
----Question 12
----Display the information about the details of an order i.e. order number, order date, amount of order, which customer
----gives the order and which salesman works for that customer and how much commission he gets for an order.

SELECT soh.SalesOrderNumber AS OrderNumber, soh.OrderDate, soh.TotalDue AS AmountOfOrder,
       CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
       CONCAT(sp.FirstName, ' ', sp.LastName) AS SalesmanName,
       soh.TotalDue * sp.CommissionPct AS Commission
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Sales.SalesPerson sp ON c.SalesPersonID = sp.BusinessEntityID;


----Question 13
----For all the products calculate
----Commission as 14.790% of standard cost,
----Margin, if standard cost is increased or decreased as follows:
----Black: +22%,
----Red: -12%
----Silver: +15%
----Multi: +5%
---White: Two times original cost divided by the square root of cost
---For other colours, standard cost remains the same

SELECT 
    Color, 
    Name, 
    StandardCost, 
    Commission = StandardCost * 0.1479, 
    Margin = 
        CASE Color 
            WHEN 'Black' THEN StandardCost * 1.22 
            WHEN 'Red' THEN StandardCost * 0.88 
            WHEN 'Silver' THEN StandardCost * 1.15 
            WHEN 'Multi' THEN StandardCost * 1.05 
            WHEN 'White' THEN (2 * StandardCost) / SQRT(StandardCost) 
            ELSE StandardCost 
        END
FROM Production.Product


---Question 14
---Create a view to find out the top 5 most expensive products for each colour

SELECT p.Color, p.Name, p.StandardCost
FROM Production.Product p
WHERE p.StandardCost IN (
    SELECT TOP 5 StandardCost
    FROM Production.Product
    WHERE Color = p.Color
    ORDER BY StandardCost DESC
)
ORDER BY p.Color, p.StandardCost DESC




 



