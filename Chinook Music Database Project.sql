/* Chinook Music Store Database Analysis

For this project, you will be assisting the Chinook team with understanding the media in their store, 
their customers and employees, and their invoice information.

*/

-- Class Questions for Testing our knowledge
--This series of questions below helped to confirm that I have mastered the main concepts taught throughout the SQL lessons.

-- Question 1: What is the most popular music Genre for each country.
WITH PurchaseRanking AS (
    SELECT
        COUNT(Quantity) AS Purchases,
        BillingCountry,
        G.Name AS GenreName,
        G.GenreId,
        DENSE_RANK() OVER (PARTITION BY BillingCountry ORDER BY COUNT(Quantity) DESC) AS PurchaseRank
    FROM 
        Customer C
    JOIN Invoice I ON C.customerid = I.CustomerId
    JOIN InvoiceLine IL ON I.InvoiceId = IL.InvoiceId
    JOIN Track T ON T.TrackId = IL.TrackId
    JOIN Genre G ON G.GenreId = T.GenreId
    GROUP BY BillingCountry, G.Name, G.GenreId
)
SELECT
    Purchases,
    BillingCountry,
    GenreName,
    GenreId
FROM PurchaseRanking
WHERE PurchaseRank = 1;

-- Question 2: Returning the track names that have a song length longer than the average song length.
WITH AVG_song_length AS (
	SELECT avg(Milliseconds) AS avg_song
	FROM Track
)
SELECT Name, Milliseconds
FROM Track
WHERE Milliseconds >= (
	SELECT avg_song
	FROM AVG_song_length
)
ORDER BY Milliseconds DESC;

--Question 3: Determining the customer that has spent the most on music for each country.
WITH PurchaseRanking AS (
    SELECT
		C.Country CountryName,
		C.FirstName FirstName,
		C.LastName LastName,
		SUM(Total) as TotalSpent,
		C.CustomerId CustomerId,
		DENSE_RANK() OVER (PARTITION BY C.CustomerId ORDER BY SUM(Total) DESC) AS PurchaseRank
    FROM 
        Customer C
		JOIN Invoice I 
		ON C.Customerid = I.CustomerId
	GROUP BY CountryName, FirstName, LastName, C.CustomerId
	)
	
SELECT	
	CountryName,
	FirstName,
	LastName,
	TotalSpent,
	CustomerId
FROM PurchaseRanking
WHERE PurchaseRank = 1
-- End of the Practice Questions in Class

/* Project Work:

	For the Project work that I submitted to Udacity, these were the question I answered.
	
*/

/* Question 1 - Which City Has the highest sales in Germany */
SELECT I.BillingCity,
       SUM(IL.UnitPrice*IL.Quantity) AS AmountSold
FROM Invoice I
JOIN InvoiceLine IL ON I.InvoiceId = IL.InvoiceId
WHERE I.BillingCountry = 'Germany'
GROUP BY I.BillingCity
ORDER BY AmountSold DESC;

/* Query 2- What are the Top Sold Genres in Germany?
We will use the following Tables: Invoice, InvoiceLine, Track, Genre*/
SELECT G.Name AS GenreName,
       I.BillingCountry,
       SUM(IL.UnitPrice*IL.Quantity) AS AmountSold
FROM Invoice I
JOIN InvoiceLine IL ON I.InvoiceId = IL.InvoiceId
JOIN Track T ON T.TrackId = IL.TrackId
JOIN Genre G ON G.GenreId = T.GenreId
WHERE I.BillingCountry = 'Germany'
GROUP BY GenreName,
         I.BillingCountry
ORDER BY AmountSold DESC
LIMIT 5;

/* Query 3 - Who is the Best Customer in Germany?
We will use the following Tables: Customer, Invoice, InvoiceLine*/
SELECT C.CustomerId,
       C.FirstName || ' ' || C.LastName AS FullName,
       SUM(I.total) AS total_purchase,
       I.BillingCountry
FROM Customer C
JOIN Invoice I ON C.customerid = I.CustomerId
WHERE I.BillingCountry = 'Germany'
GROUP BY C.CustomerId,
         FullName,
         I.BillingCountry
ORDER BY total_purchase DESC;

/* Query 4 - What are the top Genre preferences in Europe*/
SELECT CASE
-- Categorizing Countries into their respective Continents
           WHEN BillingCountry IN ('Afghanistan',
                                   'Armenia',
                                   'Azerbaijan',
                                   'Bahrain',
                                   'Lao',
                                   'Bangladesh',
                                   'Kyrgyz Republic',
                                   'Hong Kong, China',
                                   'Bhutan',
                                   'British Indian Ocean Territory',
                                   'Brunei',
                                   'Cambodia',
                                   'China',
                                   'Cyprus',
                                   'Egypt',
                                   'Georgia',
                                   'Hong Kong',
                                   'India',
                                   'Indonesia',
                                   'Iran',
                                   'Iraq',
                                   'Israel',
                                   'Japan',
                                   'Jordan',
                                   'Kazakhstan',
                                   'Kuwait',
                                   'Kyrgyzstan',
                                   'Laos',
                                   'Lebanon',
                                   'Macau',
                                   'Malaysia',
                                   'Maldives',
                                   'Mongolia',
                                   'Myanmar',
                                   'Nepal',
                                   'North Korea',
                                   'Oman',
                                   'Pakistan',
                                   'Palestine',
                                   'Philippines',
                                   'Qatar',
                                   'Russia',
                                   'Saudi Arabia',
                                   'Singapore',
                                   'South Korea',
                                   'Sri Lanka',
                                   'Syria',
                                   'Taiwan',
                                   'Tajikistan',
                                   'Thailand',
                                   'Timor-Leste',
                                   'East Timor',
                                   'Turkey',
                                   'Turkmenistan',
                                   'United Arab Emirates',
                                   'Uzbekistan',
                                   'Vietnam',
                                   'Yemen') THEN 'Asia' -- Asian Countries
           WHEN BillingCountry IN ('Algeria',
                                   'Angola',
                                   'Benin',
                                   'Botswana',
                                   'Burkina Faso',
                                   'Burundi',
                                   'Cape Verde',
                                   'Cameroon',
                                   'Central African Republic',
                                   'Chad',
                                   'Comoros',
                                   'Congo',
                                   'Congo, Rep.',
                                   'Djibouti',
                                   'Egypt',
                                   'Equatorial Guinea',
                                   'Eritrea',
                                   'Eswatini',
                                   'Ethiopia',
                                   'Gabon',
                                   'Gambia',
                                   'Ghana',
                                   'Guinea',
                                   'Guinea-Bissau',
                                   'Ivory Coast',
                                   "Cote d\'Ivoire",
                                   'Kenya',
                                   'Lesotho',
                                   'Liberia',
                                   'Libya',
                                   'Madagascar',
                                   'Malawi',
                                   'Mali',
                                   'Mauritania',
                                   'Mauritius',
                                   'Morocco',
                                   'Mozambique',
                                   'Namibia',
                                   'Niger',
                                   'Nigeria',
                                   'Rwanda',
                                   'Sao Tome and Principe',
                                   'Senegal',
                                   'Seychelles',
                                   'Sierra Leone',
                                   'Somalia',
                                   'South Africa',
                                   'South Sudan',
                                   'Sudan',
                                   'Tanzania',
                                   'Togo',
                                   'Tunisia',
                                   'Uganda',
                                   'Zambia',
                                   'Zimbabwe') THEN 'Africa' -- African Countries
           WHEN BillingCountry IN ('Albania',
                                   'Andorra',
                                   'Armenia',
                                   'Austria',
                                   'Azerbaijan',
                                   'Slovak Republic',
                                   'Belarus',
                                   'Belgium',
                                   'Bosnia and Herzegovina',
                                   'Bulgaria',
                                   'Croatia',
                                   'Cyprus',
                                   'Czechia',
                                   'Czech Republic',
                                   'Denmark',
                                   'Estonia',
                                   'Finland',
                                   'France',
                                   'Georgia',
                                   'Germany',
                                   'Greece',
                                   'Hungary',
                                   'Iceland',
                                   'Ireland',
                                   'Italy',
                                   'Kazakhstan',
                                   'Latvia',
                                   'Liechtenstein',
                                   'Lithuania',
                                   'Luxembourg',
                                   'Malta',
                                   'Moldova',
                                   'Monaco',
                                   'Montenegro',
                                   'Netherlands',
                                   'North Macedonia',
                                   'Norway',
                                   'Poland',
                                   'Portugal',
                                   'Romania',
                                   'Russia',
                                   'San Marino',
                                   'Serbia',
                                   'Slovakia',
                                   'Slovenia',
                                   'Spain',
                                   'Sweden',
                                   'Switzerland',
                                   'Turkey',
                                   'Ukraine',
                                   'United Kingdom',
                                   'Vatican City') THEN 'Europe' -- European Countries
           WHEN BillingCountry IN ('Antigua and Barbuda',
                                   'Bahamas',
                                   'Barbados',
                                   'Belize',
                                   'Canada',
                                   'Costa Rica',
                                   'Cuba',
                                   'Dominica',
                                   'Dominican Republic',
                                   'El Salvador',
                                   'Grenada',
                                   'Guatemala',
                                   'Haiti',
                                   'Honduras',
                                   'Jamaica',
                                   'Mexico',
                                   'Nicaragua',
                                   'Panama',
                                   'Saint Kitts and Nevis',
                                   'Saint Lucia',
                                   'Saint Vincent and the Grenadines',
                                   'Trinidad and Tobago',
                                   'United States',
                                   'USA') THEN 'North America' -- North American Countries
           WHEN BillingCountry IN ('Argentina',
                                   'Bolivia',
                                   'Brazil',
                                   'Chile',
                                   'Colombia',
                                   'Ecuador',
                                   'Guyana',
                                   'Paraguay',
                                   'Peru',
                                   'Suriname',
                                   'Uruguay',
                                   'Venezuela') THEN 'South America' -- South American Countries
           WHEN BillingCountry IN ('Australia',
                                   'Fiji',
                                   'Kiribati',
                                   'Marshall Islands',
                                   'Micronesia',
                                   'Nauru',
                                   'New Zealand',
                                   'Palau',
                                   'Papua New',
                                   'Guinea',
                                   'Samoa',
                                   'Solomon Islands',
                                   'Tonga',
                                   'Tuvalu',
                                   'Vanuatu') THEN 'Oceania' -- Oceanian Countries
           ELSE 'Unknown' -- Unrecognized Continents
       END AS Continent,
       G.Name AS GenreName,
       G.GenreId,
       COUNT(Quantity) AS Purchases
FROM Customer C
JOIN Invoice I ON C.customerid = I.CustomerId
JOIN InvoiceLine IL ON I.InvoiceId = IL.InvoiceId
JOIN Track T ON T.TrackId = IL.TrackId
JOIN Genre G ON G.GenreId = T.GenreId
WHERE Continent = 'Europe'
GROUP BY GenreName,
         G.GenreId,
         Continent
ORDER BY Purchases DESC
LIMIT 10;
-- End of Project Work