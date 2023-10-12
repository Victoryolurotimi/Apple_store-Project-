CREATE Table appleStore_description_merge  AS

SELECT * FROM appleStore_description1

UNION ALL

SELECT * FROM appleStore_description2

UNION ALL

SELECT * FROM appleStore_description3

UNION ALL

SELECT * FROM appleStore_description4


""Exploratory data analysis""

-- check the number of distinct apps 

SELECT COUNT(DISTINCT id) AS uniqueAppIDs
FROM AppleStore

SELECT COUNT(DISTINCT id) AS uniqueAppIDs
FROM appleStore_description_merge

--check for missing values in important fieldsAppleStore

SELECT COUNT(*) AS missingvalues
FROM AppleStore
WHERE track_name IS NULL OR user_rating IS NULL or prime_genre IS NULL

SELECT COUNT(*) AS missingvalues
FROM appleStore_description_merge 
WHERE app_desc IS NULL 

--find the number of apps based on genre

SELECT prime_genre, COUNT(*) AS numofapps
FROM AppleStore
GROUP BY prime_genre
Order by numofapps DESC

-- get an overview of the apps rating 
SELECT min(user_rating) AS Minuserrating,
	   max(user_rating) AS Maxuserrating,
       avg(user_rating) AS Avguserrating
FROM AppleStore

**data analysis**

--check if paid apps have higher ratings than free apps

SELECT CASE       
			WHEN price > 0 THEN 'paid'
            ELSE 'free'
       END AS App_Type,
       avg(user_rating) AS Avg_RatLog
 FROM AppleStore
 Group BY App_Type
 
 -- Check if apps with multilanguages have higher ratingsAppleStore
 
 SELECT CASE
 			WHEN lang_num < 10 THEN '<10 languages'
            WHEN lang_num BETWEEN 10 and 30 THEN '10-30 languages'
            ELSE '>30 languages'
        END as lang_bracket,
        avg(user_rating) as Avg_Rating
 from AppleStore
 GROUP BY lang_bracket
 order by Avg_Rating DESC
 
 --check genres with low ratings
 
 SELECT prime_genre,
 		avg(user_rating) AS Avg_Rating
 FROM Applestore 
 GROUP BY prime_genre
 ORDER by Avg_Rating ASC
 LIMIT 10
 
 --check the correlation btw app description and user rating
 
 SELECT case 
 			WHEN length(b.app_desc) <500 THEN 'short'
            when length(b.app_desc) BETWEEN 500 AND 1000 THEN 'medium'
            ELSE 'long'
        END as description_length_bucket,
        avg(a.user_rating) AS avg_ratingof_a
 
 FROM
 	  AppleStore AS a
JOIN 
	  appleStore_description_merge AS b
ON
	  a.id =b.id
Group by description_length_bucket
order by avg_ratingof_a DESC

--check top rated apps for each genre

SELECT
	prime_genre,
    track_name,
    user_rating
FROM (
	SELECT
    prime_genre,
    track_name,
    user_rating,
	RANK() OVER(PARTITION BY prime_genre order by user_rating desc, rating_count_tot desc) AS rank
    FROM
    AppleStore
  ) AS a
  where 
  a.rank = 1