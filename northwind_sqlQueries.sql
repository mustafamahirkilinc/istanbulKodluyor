-- Database: northwind

SELECT * FROM products

-- 1. Product isimlerini (`ProductName`) ve birim başına miktar (`QuantityPerUnit`) değerlerini almak için sorgu yazın.
SELECT product_name, quantity_per_unit FROM products

-- 2. Ürün Numaralarını (`ProductID`) ve Product isimlerini (`ProductName`) değerlerini almak için sorgu yazın. Artık satılmayan ürünleri (`Discontinued`) filtreleyiniz.
SELECT product_id, product_name FROM products
WHERE discontinued = 1

-- 3. Durdurulmayan (`Discontinued`) Ürün Listesini, Ürün kimliği ve ismi (`ProductID`, `ProductName`) değerleriyle almak için bir sorgu yazın.
SELECT product_id, product_name FROM products
WHERE discontinued = 0

-- 4. Ürünlerin maliyeti 20'dan az olan Ürün listesini (`ProductID`, `ProductName`, `UnitPrice`) almak için bir sorgu yazın.
SELECT product_id, product_name, unit_price FROM products
WHERE unit_price < 20

-- 5. Ürünlerin maliyetinin 15 ile 25 arasında olduğu Ürün listesini (`ProductID`, `ProductName`, `UnitPrice`) almak için bir sorgu yazın.
SELECT product_id, product_name, unit_price FROM products
WHERE unit_price BETWEEN 15 AND 25

-- 6. Ürün listesinin (`ProductName`, `UnitsOnOrder`, `UnitsInStock`) stoğun siparişteki miktardan az olduğunu almak için bir sorgu yazın.
SELECT product_name, units_on_order, units_in_stock FROM products
WHERE units_in_stock < units_on_order

-- 7. İsmi `a` ile başlayan ürünleri listeleyeniz.
SELECT * FROM products
WHERE product_name LIKE 'A%'

-- 8. İsmi `i` ile biten ürünleri listeleyeniz.
SELECT * FROM products
WHERE product_name LIKE '%i'

-- 9. Ürün birim fiyatlarına %18’lik KDV ekleyerek listesini almak (ProductName, UnitPrice, UnitPriceKDV) için bir sorgu yazın.
SELECT product_name, unit_price, (unit_price * 1.18) AS "UnitPriceKDV" FROM products

-- 10. Fiyatı 30 dan büyük kaç ürün var?
SELECT COUNT(*) AS "ProductCount" FROM products
WHERE unit_price > 30

-- 11. Ürünlerin adını tamamen küçültüp fiyat sırasına göre tersten listele
SELECT LOWER(product_name), unit_price FROM products
ORDER BY unit_price DESC

-- 12. Çalışanların ad ve soyadlarını yanyana gelecek şekilde yazdır
SELECT CONCAT(first_name, ' ', last_name) AS "FullName" FROM employees

-- 13. Region alanı NULL olan kaç tedarikçim var?
-- SELECT * FROM suppliers
SELECT COUNT(*) FROM suppliers
WHERE region IS NULL

-- 14. a.Null olmayanlar?
SELECT COUNT(*) FROM suppliers
WHERE region IS NOT NULL

-- 15. Ürün adlarının hepsinin soluna TR koy ve büyültüp olarak ekrana yazdır.
SELECT CONCAT('TR', UPPER(product_name)) AS "ProductName" FROM products

-- 16. a.Fiyatı 20den küçük ürünlerin adının başına TR ekle
SELECT CONCAT('TR', UPPER(product_name)) AS "ProductName", unit_price FROM products
WHERE unit_price > 20

-- 17. En pahalı ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
SELECT product_name, unit_price FROM products
ORDER BY unit_price DESC
LIMIT 1

-- 18. En pahalı on ürünün Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
SELECT product_name, unit_price FROM products
ORDER BY unit_price DESC
LIMIT 10

-- 19. Ürünlerin ortalama fiyatının üzerindeki Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
SELECT product_name, unit_price FROM products
WHERE unit_price > (SELECT AVG(unit_price) FROM products)

-- 20. Stokta olan ürünler satıldığında elde edilen miktar ne kadardır.
-- SELECT product_name, unit_price, units_in_stock, (unit_price * units_in_stock) AS "SalesAmount" FROM products
SELECT SUM(unit_price * units_in_stock) AS "TotalSalesAmount" FROM products

-- 21. Mevcut ve Durdurulan ürünlerin sayılarını almak için bir sorgu yazın.
SELECT COUNT(*) FROM products
WHERE discontinued = 0 OR discontinued = 1

-- 22. Ürünleri kategori isimleriyle birlikte almak için bir sorgu yazın.
SELECT P.product_name, C.category_name FROM products P
JOIN categories C ON C.category_id = P.category_id

-- 23. Ürünlerin kategorilerine göre fiyat ortalamasını almak için bir sorgu yazın.
SELECT C.category_name, AVG(P.unit_price) AS "AveragePrice" FROM categories C
JOIN products P ON P.category_id = C.category_id
GROUP BY C.category_id

-- 24. En pahalı ürünümün adı, fiyatı ve kategorisin adı nedir?
SELECT P.product_name, P.unit_price, C.category_name FROM products P
JOIN categories C ON C.category_id = P.category_id
ORDER BY unit_price DESC
LIMIT 1

-- 25. En çok satılan ürününün adı, kategorisinin adı ve tedarikçisinin adı
SELECT P.product_name, C.category_name, S.company_name, SUM(od.quantity) AS totalquantity FROM order_details AS od
JOIN products AS P ON od.product_id = P.product_id
JOIN suppliers AS S ON P.supplier_id = S.supplier_id
JOIN categories AS C ON P.category_id = C.category_id
GROUP BY P.product_id, C.category_name, S.company_name
ORDER BY SUM(od.quantity) DESC LIMIT 1;
