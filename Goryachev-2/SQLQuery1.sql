--OrgChart
SELECT        DimEmployee.LastName + ', ' + DimEmployee.FirstName AS SalesPerson, DimEmployee_1.LastName + ', ' + DimEmployee_1.FirstName  AS Manager, 
                         
						 	case
		when DimSalesTerritory.SalesTerritoryRegion = 'NA' then '' +  N'' + DimEmployee.Title else DimSalesTerritory.SalesTerritoryRegion + N' ' + DimEmployee.Title
	END 
		AS Tooltip
FROM            DimEmployee INNER JOIN
                         DimEmployee AS DimEmployee_1 ON DimEmployee.ParentEmployeeKey = DimEmployee_1.EmployeeKey INNER JOIN
                         DimSalesTerritory ON DimEmployee.SalesTerritoryKey = DimSalesTerritory.SalesTerritoryKey 
				Where 		DimEmployee.Title like '%Sales Representative%' or DimEmployee.Title like '%Sales Manager%' 



--Treemap 
SELECT        top 1 'World...' as Territory, ' ' as LocatedIn, sum(FactResellerSales.OrderQuantity) as TotOrders, sum(FactResellerSales.SalesAmount) as TotSalesAmount
FROM            FactResellerSales INNER JOIN 
                            DimSalesTerritory ON DimSalesTerritory.SalesTerritoryKey = FactResellerSales.SalesTerritoryKey

UNION

SELECT     DISTINCT   DimSalesTerritory.SalesTerritoryGroup + '...' as Territory, 'World...' as LocatedIn, sum(FactResellerSales.OrderQuantity) as TotOrders, sum(FactResellerSales.SalesAmount) as TotSalesAmount
FROM            DimSalesTerritory INNER JOIN
                         FactResellerSales ON DimSalesTerritory.SalesTerritoryKey = FactResellerSales.SalesTerritoryKey
						 GROUP BY DimSalesTerritory.SalesTerritoryGroup
UNION

SELECT      DimSalesTerritory.SalesTerritoryCountry + '...' as Territory, DimSalesTerritory.SalesTerritoryGroup + '...' as LocatedIn, sum(FactResellerSales.OrderQuantity) as TotOrdes, sum(FactResellerSales.SalesAmount) as TotSalesAmount
FROM            DimSalesTerritory INNER JOIN
                         FactResellerSales ON DimSalesTerritory.SalesTerritoryKey = FactResellerSales.SalesTerritoryKey
						 GROUP BY DimSalesTerritory.SalesTerritoryCountry, DimSalesTerritory.SalesTerritoryGroup
UNION

SELECT         DimSalesTerritory.SalesTerritoryRegion as Territory, DimSalesTerritory.SalesTerritoryCountry + '...' as LocatedIn, sum(FactResellerSales.OrderQuantity) as TotOrders, sum(FactResellerSales.SalesAmount) as TotSalesAmount
FROM            DimSalesTerritory INNER JOIN
                         FactResellerSales ON DimSalesTerritory.SalesTerritoryKey = FactResellerSales.SalesTerritoryKey
						  GROUP BY  DimSalesTerritory.SalesTerritoryRegion, DimSalesTerritory.SalesTerritoryCountry

--BubbleChart 
SELECT DimSalesTerritory.SalesTerritoryRegion, DimProductCategory.EnglishProductCategoryName as Category, FORMAT( FactResellerSales.OrderDate, 'yyyy', 'en-US' ) as 'Year',
 sum(FactResellerSales.OrderQuantity) as TotOrderQty, sum(FactResellerSales.SalesAmount) as TotSalesAmount,  count(FactResellerSales.OrderQuantity) as NbrOrders
FROM            DimProductSubcategory INNER JOIN
                         DimProduct ON DimProductSubcategory.ProductSubcategoryKey = DimProduct.ProductSubcategoryKey INNER JOIN
                         DimProductCategory ON DimProductSubcategory.ProductCategoryKey = DimProductCategory.ProductCategoryKey INNER JOIN
                         FactResellerSales ON DimProduct.ProductKey = FactResellerSales.ProductKey INNER JOIN
                         DimSalesTerritory ON FactResellerSales.SalesTerritoryKey = DimSalesTerritory.SalesTerritoryKey
GROUP BY  DimSalesTerritory.SalesTerritoryRegion , DimProductCategory.EnglishProductCategoryName, FORMAT( FactResellerSales.OrderDate, 'yyyy', 'en-US' )
ORDER BY  DimSalesTerritory.SalesTerritoryRegion, DimProductCategory.EnglishProductCategoryName