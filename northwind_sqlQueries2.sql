-- Database: northwind

-- 26. Stokta bulunmayan ürünlerin ürün listesiyle birlikte tedarikçilerin ismi ve iletişim numarasını (`ProductID`, `ProductName`, `CompanyName`, `Phone`) almak için bir sorgu yazın.
SELECT p.product_id, p.product_name, s.company_name, s.phone FROM products p
INNER JOIN suppliers s ON p.supplier_id = s.supplier_id
WHERE p.units_in_stock = 0;

-- 27. 1998 yılı mart ayındaki siparişlerimin adresi, siparişi alan çalışanın adı, çalışanın soyadı
SELECT o.ship_address, e.first_name, e.last_name FROM orders o
INNER JOIN employees e ON o.employee_id = e.employee_id
WHERE EXTRACT(YEAR FROM o.order_date) = 1998
AND EXTRACT(MONTH FROM o.order_date) = 3; 

-- 28. 1997 yılı şubat ayında kaç siparişim var?
SELECT COUNT(*) AS order_count FROM orders
WHERE EXTRACT(YEAR FROM order_date) = 1997
AND EXTRACT(MONTH FROM order_date) = 2;

-- 29. London şehrinden 1998 yılında kaç siparişim var?
SELECT COUNT(*) AS order_count FROM orders
WHERE ship_city = 'London' AND EXTRACT(YEAR FROM order_date) = 1998;

-- 30. 1997 yılında sipariş veren müşterilerimin contactname ve telefon numarası
SELECT  DISTINCT c.contact_name, c.phone FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE EXTRACT(YEAR FROM o.order_date) = 1997;

-- 31. Taşıma ücreti 40 üzeri olan siparişlerim
SELECT * FROM orders
WHERE freight > 40;

-- 32. Taşıma ücreti 40 ve üzeri olan siparişlerimin şehri, müşterisinin adı
SELECT o.ship_city, c.contact_name FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
WHERE freight >= 40;

-- 33. 1997 yılında verilen siparişlerin tarihi, şehri, çalışan adı -soyadı ( ad soyad birleşik olacak ve büyük harf),
SELECT o.order_date, o.ship_city, 
CONCAT(UPPER(e.first_name), ' ', UPPER(e.last_name)) AS employee_name_last_name
FROM orders o
INNER JOIN employees e ON o.employee_id = e.employee_id
WHERE EXTRACT(YEAR FROM o.order_date) = 1997;

-- 34. 1997 yılında sipariş veren müşterilerin contactname i, ve telefon numaraları ( telefon formatı 2223322 gibi olmalı )
SELECT c.contact_name, REGEXP_REPLACE(c.phone, '[^0-9]', '', 'g') AS formatted_phone FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE EXTRACT(YEAR FROM o.order_date) = 1997;

-- 35. Sipariş tarihi, müşteri contact name, çalışan ad, çalışan soyad
SELECT o.order_date, c.contact_name, e.first_name, e.last_name FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN employees e ON o.employee_id = e.employee_id;

-- 36. Geciken siparişlerim?
SELECT * FROM orders
WHERE shipped_date > required_date;

-- 37. Geciken siparişlerimin tarihi, müşterisinin adı
SELECT o.order_date, c.contact_name FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
WHERE shipped_date > required_date;

-- 38. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
SELECT p.product_name, c.category_name, od.quantity FROM products p
INNER JOIN order_details od ON p.product_id = od.product_id
INNER JOIN categories c ON p.category_id = c.category_id
WHERE order_id = 10248;

-- 39. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
SELECT p.product_name, s.company_name FROM products p
INNER JOIN order_details od ON p.product_id = od.product_id
INNER JOIN suppliers s ON p.supplier_id = s.supplier_id
WHERE order_id = 10248;

-- 40. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
SELECT p.product_name, SUM(od.quantity) FROM order_details od
INNER JOIN orders o ON o.order_id = od.order_id
INNER JOIN products p ON p.product_id = od.product_id
WHERE EXTRACT(YEAR FROM o.order_date) = 1997 AND o.employee_id=3
GROUP BY p.product_id;

-- 41. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
SELECT e.employee_id, CONCAT(e.first_name, ' ', e.last_name)
AS employee_name_last_name, o.order_date,
SUM(od.unit_price * (1 - od.discount) * od.quantity) 
AS revenue FROM orders o
INNER JOIN employees e ON o.employee_id = e.employee_id
INNER JOIN order_details od ON o.order_id = od.order_id
WHERE EXTRACT(YEAR FROM o.order_date)=1997
GROUP BY o.order_id,e.employee_id
ORDER BY revenue DESC
LIMIT 1;

-- 42. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
SELECT e.employee_id, CONCAT(e.first_name, ' ', e.last_name)
AS employee_name_last_name, 
SUM(od.unit_price * (1 - od.discount) * od.quantity) as total_sale FROM order_details od
INNER JOIN orders o ON od.order_id = o.order_id
INNER JOIN employees e ON o.employee_id = e.employee_id
WHERE EXTRACT(YEAR FROM o.order_date)=1997
GROUP BY e.employee_id
ORDER BY total_sale DESC
LIMIT 1;

-- 43. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
SELECT p.product_name AS product_name, p.unit_price AS price, c.category_name AS category_name
FROM products p
INNER JOIN categories c ON p.category_id = c.category_id
ORDER BY p.unit_price DESC
LIMIT 1;

-- 44. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
SELECT e.first_name, e.last_name, o.order_date, o.order_id 
FROM orders o
INNER JOIN employees e ON o.employee_id = e.employee_id
ORDER BY o.order_date;

-- 45. SON 5 siparişimin ortalama fiyatı ve orderid nedir?
SELECT  o.order_id, AVG(od.unit_price * od.quantity) AS average_price 
FROM order_details od
INNER JOIN orders o ON od.order_id = o.order_id
GROUP BY o.order_id
ORDER BY o.order_id DESC 
LIMIT 5;

-- 46. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
SELECT p.product_name, c.category_name, SUM(od.quantity) AS total_sale 
FROM products p
INNER JOIN order_details od ON p.product_id = od.product_id
INNER JOIN orders o ON od.order_id = o.order_id
INNER JOIN categories c ON p.category_id = c.category_id
WHERE EXTRACT(MONTH FROM o.order_date)=1
GROUP BY p.product_id, c.category_id; 

-- 47. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
SELECT o.order_id, SUM(od.quantity) AS total_quantity FROM orders o
INNER JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.order_id
HAVING AVG(od.quantity) > (SELECT AVG(quantity) FROM order_details);

-- 48. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
SELECT p.product_name, c.category_name, s.company_name FROM order_details od
INNER JOIN products p ON od.product_id = p.product_id
INNER JOIN suppliers s ON p.supplier_id = s.supplier_id
INNER JOIN categories c ON p.category_id = c.category_id
GROUP BY p.product_id, c.category_id, s.supplier_id
ORDER BY SUM(od.quantity) DESC
LIMIT 1;

-- 49. Kaç ülkeden müşterim var
SELECT COUNT(DISTINCT country) AS country_count FROM customers;

-- 50. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
SELECT e.employee_id, e.first_name, e.last_name, 
SUM(od.unit_price * od.quantity) AS toTAL_sales FROM order_details od
INNER JOIN orders o ON o.order_id = od.order_id
INNER JOIN employees e ON e.employee_id = o.employee_id
WHERE order_date >'01/01/1998' AND e.employee_id = 3
GROUP BY e.employee_id

-- 51. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
SELECT p.product_name, c.category_name, od.quantity FROM products p
INNER JOIN order_details od ON p.product_id = od.product_id
INNER JOIN categories c ON p.category_id = c.category_id
WHERE order_id = 10248;

-- 52. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
SELECT p.product_name, s.company_name FROM products p
INNER JOIN order_details od ON p.product_id = od.product_id
INNER JOIN suppliers s ON p.supplier_id = s.supplier_id
WHERE order_id = 10248;

-- 53. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
SELECT  p.product_name, SUM(od.quantity) FROM order_details od
INNER JOIN orders o ON o.order_id = od.order_id
INNER JOIN products p ON p.product_id = od.product_id
WHERE EXTRACT(YEAR FROM o.order_date) = 1997 AND o.employee_id = 3
GROUP BY p.product_id

-- 54. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
SELECT e.employee_id, CONCAT(e.first_name, ' ', e.last_name)
AS employee_name_last_name, o.order_date,
SUM(od.unit_price * (1 - od.discount) * od.quantity) 
AS revenue FROM orders o
INNER JOIN employees e ON o.employee_id = e.employee_id
INNER JOIN order_details od ON o.order_id = od.order_id
WHERE EXTRACT(YEAR FROM o.order_date)=1997
GROUP BY o.order_id,e.employee_id
ORDER BY revenue DESC
LIMIT 1;

-- 55. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
SELECT e.employee_id, CONCAT(e.first_name, ' ', e.last_name)
AS employee_name_last_name, 
SUM(od.unit_price * (1 - od.discount) * od.quantity) as total_sale FROM order_details od
INNER JOIN orders o ON od.order_id = o.order_id
INNER JOIN employees e ON o.employee_id = e.employee_id
WHERE EXTRACT(YEAR FROM o.order_date)=1997
GROUP BY e.employee_id
ORDER BY total_sale DESC
LIMIT 1;

-- 56. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
SELECT p.product_name AS product_name, p.unit_price AS price, c.category_name AS category_name
FROM products p
INNER JOIN categories c ON p.category_id = c.category_id
ORDER BY p.unit_price DESC
LIMIT 1;

-- 57. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
SELECT e.first_name, e.last_name, o.order_date, o.order_id 
FROM orders o
INNER JOIN employees e ON o.employee_id = e.employee_id
ORDER BY o.order_date;

-- 58. SON 5 siparişimin ortalama fiyatı ve orderid nedir?
SELECT  o.order_id, AVG(od.unit_price * od.quantity) AS average_price 
FROM order_details od
INNER JOIN orders o ON od.order_id = o.order_id
GROUP BY o.order_id
ORDER BY o.order_id DESC 
LIMIT 5;

-- 59. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
SELECT p.product_name, c.category_name, SUM(od.quantity) AS total_sale 
FROM products p
INNER JOIN order_details od ON p.product_id = od.product_id
INNER JOIN orders o ON od.order_id = o.order_id
INNER JOIN categories c ON p.category_id = c.category_id
WHERE EXTRACT(MONTH FROM o.order_date)=1
GROUP BY p.product_id, c.category_id; 

-- 60. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
SELECT o.order_id, SUM(od.quantity) AS total_quantity FROM orders o
INNER JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.order_id
HAVING AVG(od.quantity) > (SELECT AVG(quantity) FROM order_details);

-- 61. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
SELECT p.product_name, c.category_name, s.company_name FROM order_details od
INNER JOIN products p ON od.product_id = p.product_id
INNER JOIN suppliers s ON p.supplier_id = s.supplier_id
INNER JOIN categories c ON p.category_id = c.category_id
GROUP BY p.product_id, c.category_id, s.supplier_id
ORDER BY SUM(od.quantity) DESC
LIMIT 1;

-- 62. Kaç ülkeden müşterim var
SELECT COUNT(DISTINCT country) AS country_count FROM customers;

-- 63. Hangi ülkeden kaç müşterimiz var
SELECT country, COUNT(customer_id) AS customer_count FROM customers
GROUP BY country;

-- 64. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
SELECT e.employee_id, e.first_name, e.last_name, 
SUM(od.unit_price * od.quantity) AS toTAL_sales FROM order_details od
INNER JOIN orders o ON o.order_id = od.order_id
INNER JOIN employees e ON e.employee_id = o.employee_id
WHERE order_date >'01/01/1998' AND e.employee_id = 3
GROUP BY e.employee_id

-- 65. 10 numaralı ID ye sahip ürünümden son 3 ayda ne kadarlık ciro sağladım?
SELECT SUM(od.quantity * od.unit_price) AS total_revenue FROM orders o
INNER JOIN order_details od ON o.order_id = od.order_id
WHERE od.product_id = 10
AND o.order_date >= (SELECT MAX(order_date) - INTERVAL '3 months' FROM orders);

-- 66. Hangi çalışan şimdiye kadar toplam kaç sipariş almış..?
SELECT e.employee_id,
CONCAT(e.first_name, ' ', e.last_name) AS full_name,
COUNT(o.order_id) AS total_orders
FROM employees e
LEFT JOIN orders o ON e.employee_id = o.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name;

-- 67. 91 müşterim var. Sadece 89’u sipariş vermiş. Sipariş vermeyen 2 kişiyi bulun
SELECT c.* FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;

-- 68. Brazil’de bulunan müşterilerin Şirket Adı, TemsilciAdi, Adres, Şehir, Ülke bilgileri
SELECT company_name, contact_name, address, city, country FROM customers
WHERE country = 'Brazil';

-- 69. Brezilya’da olmayan müşteriler
SELECT * FROM customers
WHERE country != 'Brazil';

-- 70. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
SELECT * FROM customers 
WHERE country IN ('Spain', 'France', 'Germany');

-- 71. Faks numarasını bilmediğim müşteriler
SELECT * FROM customers
WHERE fax IS NULL;

-- 72. Londra’da ya da Paris’de bulunan müşterilerim
SELECT * FROM customers 
WHERE city IN ('London', 'Paris');

-- 73. Hem Mexico D.F’da ikamet eden HEM DE ContactTitle bilgisi ‘owner’ olan müşteriler
SELECT * FROM customers
WHERE city = 'México D.F.' AND contact_title = 'Owner';

-- 74. C ile başlayan ürünlerimin isimleri ve fiyatları
SELECT product_name, unit_price FROM products
WHERE product_name LIKE 'C%';

-- 75. Adı (FirstName) ‘A’ harfiyle başlayan çalışanların (Employees); Ad, Soyad ve Doğum Tarihleri
SELECT first_name, last_name, birth_date FROM employees
WHERE first_name LIKE 'A%';

-- 76. İsminde ‘RESTAURANT’ geçen müşterilerimin şirket adları
SELECT company_name FROM customers
WHERE company_name ILIKE '%RESTAURANT%';

-- 77. 50$ ile 100$ arasında bulunan tüm ürünlerin adları ve fiyatları
SELECT product_name, unit_price FROM products
WHERE unit_price BETWEEN 50 AND 100;

-- 78. 1 temmuz 1996 ile 31 Aralık 1996 tarihleri arasındaki siparişlerin (Orders), SiparişID (OrderID) ve SiparişTarihi (OrderDate) bilgileri
SELECT order_id, order_date FROM orders
WHERE order_date BETWEEN '1996-07-01' AND '1996-12-31';

-- 79. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
SELECT * FROM customers 
WHERE country = 'Spain' OR country = 'France' OR country = 'Germany';

-- 80. Faks numarasını bilmediğim müşteriler
SELECT * FROM customers
WHERE fax IS NULL OR fax = '';

-- 81. Müşterilerimi ülkeye göre sıralıyorum:
SELECT * FROM customers 
ORDER BY country;

-- 82. Ürünlerimi en pahalıdan en ucuza doğru sıralama, sonuç olarak ürün adı ve fiyatını istiyoruz
SELECT product_name, unit_price FROM products
ORDER BY unit_price DESC;

-- 83. Ürünlerimi en pahalıdan en ucuza doğru sıralasın, ama stoklarını küçükten-büyüğe doğru göstersin sonuç olarak ürün adı ve fiyatını istiyoruz
SELECT product_name, unit_price FROM products
ORDER BY unit_price DESC, units_in_stock ASC;

-- 84. 1 Numaralı kategoride kaç ürün vardır..?
SELECT COUNT(*) AS total_product_category1 FROM products
WHERE category_id = 1;

-- 85. Kaç farklı ülkeye ihracat yapıyorum..?
SELECT COUNT(DISTINCT ship_country) FROM orders;

-- 86. a.Bu ülkeler hangileri..?
SELECT DISTINCT ship_country FROM orders;

-- 87. En Pahalı 5 ürün
SELECT product_name, unit_price FROM products
ORDER BY unit_price DESC
LIMIT 5;

-- 88. ALFKI CustomerID’sine sahip müşterimin sipariş sayısı..?
SELECT COUNT(*) FROM orders
WHERE customer_id = 'ALFKI';

-- 89. Ürünlerimin toplam maliyeti
SELECT SUM(unit_price * units_in_stock) AS total_cost FROM products;

-- 90. Şirketim, şimdiye kadar ne kadar ciro yapmış..?
SELECT SUM(unit_price * quantity) FROM order_details;

-- 91. Ortalama Ürün Fiyatım
SELECT AVG(unit_price) AS "AveragePrice" FROM products;

-- 92. En Pahalı Ürünün Adı
SELECT product_name FROM products 
ORDER BY unit_price DESC
LIMIT 1;

-- 93. En az kazandıran sipariş
SELECT order_id, SUM(unit_price * quantity) AS "total_price" FROM order_details
GROUP BY order_id
ORDER BY total_price ASC
LIMIT 1;

-- 94. Müşterilerimin içinde en uzun isimli müşteri
SELECT company_name FROM customers
ORDER BY LENGTH(company_name) DESC
LIMIT 1;

-- 95. Çalışanlarımın Ad, Soyad ve Yaşları
SELECT first_name, last_name,
EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM birth_date) AS Age FROM employees;

-- 96. Hangi üründen toplam kaç adet alınmış..?
SELECT p.product_id, p.product_name, SUM(od.quantity) AS "total_sales"
FROM products p
INNER JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.product_id;

-- 97. Hangi siparişte toplam ne kadar kazanmışım..?
SELECT o.order_id, SUM(od.unit_price*(1-od.discount)*od.quantity) FROM orders o
INNER JOIN order_details od ON od.order_id = o.order_id
GROUP BY o.order_id;

-- 98. Hangi kategoride toplam kaç adet ürün bulunuyor..?
SELECT c.category_name, COUNT(p.product_id) AS "TotalAmount" FROM categories c
INNER JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_name;

-- 99. 1000 Adetten fazla satılan ürünler?
SELECT p.product_id, p.product_name, SUM(od.quantity) FROM products p
INNER JOIN order_details od ON od.product_id = p.product_id
GROUP BY p.product_id
HAVING SUM(od.quantity)>1000;

-- 100. Hangi Müşterilerim hiç sipariş vermemiş..?
SELECT c.* FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;