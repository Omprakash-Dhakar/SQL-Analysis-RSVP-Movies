USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT COUNT(*)  director_mapping_rows FROM director_mapping;
SELECT COUNT(*) genre_rows FROM genre;
SELECT COUNT(*) movie_rows FROM movie;
SELECT COUNT(*) names_rows FROM names;
SELECT COUNT(*) ratings_rows FROM ratings;
SELECT COUNT(*) role_mapping_rows FROM role_mapping;

-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT 
		SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS ID_nulls, 
		SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS title_nulls, 
		SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS year_nulls,
		SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS date_published_nulls,
		SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS duration_nulls,
		SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_nulls,
		SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS worlwide_gross_income_nulls,
		SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS languages_nulls,
		SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS production_company_nulls
FROM movie;



-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT YEAR(date_published) AS Year, COUNT(*) AS number_of_movies
FROM movie
GROUP BY YEAR(date_published);

SELECT MONTH(date_published) AS month_num, COUNT(*) AS number_of_movies
FROM movie
GROUP BY MONTH(date_published)
ORDER BY month_num ASC;

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT COUNT(DISTINCT ID)  NUM_MOVIES
FROM movie
WHERE (country LIKE '%USA%' OR country LIKE '%India%') AND year = 2019;

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT genre
FROM genre;

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT genre, COUNT(MOVIE_ID) AS movie_count
FROM movie
JOIN genre ON movie.id = genre.movie_id
GROUP BY genre
ORDER BY movie_count DESC
LIMIT 1;

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
SELECT COUNT(*)
FROM (
  SELECT movie_id
  FROM genre
  GROUP BY movie_id
  HAVING COUNT(*) = 1
) as only_one_genre;

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT genre, AVG(duration) AS avg_duration
FROM movie
JOIN genre ON movie.id = genre.movie_id
GROUP BY genre;

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH genre_counts AS (
  SELECT genre, COUNT(*) AS movie_count, RANK() OVER (ORDER BY COUNT(*) DESC) AS genre_rank
  FROM genre
  INNER JOIN movie ON genre.movie_id = movie.id
  GROUP BY genre
)
SELECT genre, movie_count, genre_rank
FROM genre_counts
WHERE genre = 'thriller';


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/



-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
  MIN(avg_rating) AS min_avg_rating,
  MAX(avg_rating) AS max_avg_rating,
  MIN(total_votes) AS min_total_votes,
  MAX(total_votes) AS max_total_votes,
  MIN(median_rating) AS min_median_rating,
  MAX(median_rating) AS max_median_rating
FROM ratings;    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
SELECT title, avg_rating, DENSE_RANK() OVER (ORDER BY avg_rating DESC) AS movie_rank
FROM movie
JOIN ratings ON movie.id = ratings.movie_id
ORDER BY avg_rating DESC
LIMIT 10;

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT median_rating, COUNT(*) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY median_rating;


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT production_company, COUNT(*) as movie_count,
DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS prod_company_rank
FROM movie
JOIN ratings ON movie.id = ratings.movie_id
WHERE ratings.avg_rating > 8 AND production_company IS NOT NULL
GROUP BY production_company
ORDER BY movie_count DESC;

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre.genre AS genre, COUNT(DISTINCT movie.title) AS movie_count
FROM movie
JOIN genre ON movie.id = genre.movie_id
JOIN ratings ON movie.id = ratings.movie_id
WHERE movie.date_published BETWEEN '2017-03-01' AND '2017-03-31'
AND movie.country = 'USA'
AND ratings.total_votes >= 1000
GROUP BY genre;

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT movie.title, ratings.avg_rating, genre.genre
FROM movie
JOIN genre ON movie.id = genre.movie_id
JOIN ratings ON movie.id = ratings.movie_id
WHERE movie.title LIKE 'The%' AND ratings.avg_rating > 8;

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT COUNT(*)
FROM movie
JOIN ratings ON movie.id = ratings.movie_id
WHERE movie.date_published BETWEEN '2018-04-01' AND '2019-04-01'
AND ratings.median_rating = 8;

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
SELECT country, SUM(total_votes) AS total_votes
FROM movie
JOIN ratings ON movie.id = ratings.movie_id
WHERE country IN ('Germany', 'Italy')
GROUP BY country;
-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT
  SUM(name IS NULL) AS name_nulls,
  SUM(height IS NULL) AS height_nulls,
  SUM(date_of_birth IS NULL) AS date_of_birth_nulls,
  SUM(known_for_movies IS NULL) AS known_for_movies_nulls
FROM names;

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_genres AS (
  SELECT genre, COUNT(*) AS movie_count
  FROM movie
  JOIN genre ON movie.id = genre.movie_id
  JOIN ratings ON movie.id = ratings.movie_id
  WHERE ratings.avg_rating > 8
  GROUP BY genre
  ORDER BY movie_count DESC
  LIMIT 3
),
top_directors AS (
  SELECT name_id, COUNT(*) AS movie_count
  FROM movie
  JOIN director_mapping ON movie.id = director_mapping.movie_id
  JOIN genre ON movie.id = genre.movie_id
  JOIN ratings ON movie.id = ratings.movie_id
  WHERE genre.genre IN (SELECT genre FROM top_genres)
  AND ratings.avg_rating > 8
  GROUP BY name_id
  ORDER BY movie_count DESC
  LIMIT 3
)
SELECT names.name AS director_name, top_directors.movie_count
FROM top_directors
JOIN names ON top_directors.name_id = names.id;


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
  names.name AS actor_name, 
  COUNT(role_mapping.name_id) AS movie_count
FROM 
  names 
  JOIN role_mapping ON names.id = role_mapping.name_id 
  JOIN movie ON role_mapping.movie_id = movie.id 
  JOIN ratings ON movie.id = ratings.movie_id 
WHERE 
  role_mapping.category = 'Actor' 
  AND ratings.median_rating >= 8 
GROUP BY 
  names.name 
ORDER BY 
  movie_count DESC 
LIMIT 2;

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT production_company AS production_company, SUM(total_votes) AS vote_count, 
	   ROW_NUMBER() OVER (ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM movie 
JOIN ratings ON movie.id = ratings.movie_id 
GROUP BY production_company 
ORDER BY vote_count DESC 
LIMIT 3;


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actors_ratings AS (
  SELECT 
    names.name AS actor_name, 
    movie.id AS movie_id, 
    ratings.avg_rating AS avg_rating, 
    ratings.total_votes AS total_votes
  FROM 
    names 
    INNER JOIN role_mapping ON names.id = role_mapping.name_id 
    INNER JOIN movie ON movie.id = role_mapping.movie_id 
    INNER JOIN ratings ON movie.id = ratings.movie_id 
  WHERE 
    role_mapping.category = 'actor' AND 
    movie.country = 'India'
), 
aggregated_ratings AS (
  SELECT 
    actor_name, 
    SUM(total_votes * avg_rating) / SUM(total_votes) AS actor_avg_rating, 
    SUM(total_votes) AS total_votes, 
    COUNT(DISTINCT movie_id) AS movie_count
  FROM 
    actors_ratings
  GROUP BY 
    actor_name
  HAVING 
    movie_count >= 5
) 
SELECT 
  actor_name, 
  total_votes, 
  movie_count, 
  actor_avg_rating, 
  RANK() OVER (ORDER BY actor_avg_rating DESC, total_votes DESC) AS actor_rank
FROM 
  aggregated_ratings
ORDER BY 
  actor_rank;

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT names.name as actress_name, SUM(ratings.total_votes) as total_votes, COUNT(DISTINCT movie.id) as movie_count, 
	   ROUND(SUM(ratings.avg_rating * ratings.total_votes) / SUM(ratings.total_votes),2) as actress_avg_rating, 
       DENSE_RANK() OVER (ORDER BY SUM(ratings.avg_rating * ratings.total_votes) / SUM(ratings.total_votes) DESC,SUM(ratings.total_votes) DESC) as actress_rank
FROM movie
JOIN role_mapping ON movie.id = role_mapping.movie_id
JOIN names ON role_mapping.name_id = names.id
JOIN ratings ON movie.id = ratings.movie_id
WHERE movie.country = 'India' AND role_mapping.category = 'actress' AND movie.languages = 'Hindi'
GROUP BY names.name
HAVING COUNT(DISTINCT movie.id) >= 3
ORDER BY actress_avg_rating DESC, total_votes DESC
LIMIT 5;

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT title,
AVG(avg_rating) AS avg_rating,
CASE
WHEN AVG(avg_rating) > 8 THEN 'Superhit movie'
WHEN AVG(avg_rating) BETWEEN 7 AND 8 THEN 'Hit movie'
WHEN AVG(avg_rating) BETWEEN 5 AND 7 THEN 'One-time-watch movie'
ELSE 'Flop movie'
END AS classification
FROM movie
JOIN genre ON movie.id = genre.movie_id
JOIN ratings ON movie.id = ratings.movie_id
WHERE genre = 'thriller'
GROUP BY title;


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comedy		|			103		|	       317.4	  |	   106.24	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT     genre,
           Round(Avg(duration))                 AS avg_duration,
           round(sum(Avg(duration)) OVER w1, 1) AS running_total_duration,
           round(avg(avg(duration)) OVER w2, 2) AS moving_avg_duration
FROM       genre g
INNER JOIN movie m
ON         g.movie_id = m.id
GROUP BY   genre 
WINDOW	   w1 AS (ORDER BY genre rows UNBOUNDED PRECEDING),
           w2 AS (ORDER BY genre rows BETWEEN 2 PRECEDING AND 2 following);

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH top_3_genres AS (
  SELECT genre, COUNT(*) as num_movies
  FROM genre
  JOIN movie ON movie.id = genre.movie_id
  GROUP BY genre
  ORDER BY num_movies DESC
  LIMIT 3
),
genres_movies AS (
  SELECT movie.id, movie.title, movie.year, movie.worlwide_gross_income, genre.genre
  FROM movie
  JOIN genre ON movie.id = genre.movie_id
  JOIN top_3_genres ON top_3_genres.genre = genre.genre
),
ranked_movies AS (
  SELECT genre, year, title, worlwide_gross_income, 
  ROW_NUMBER() OVER (PARTITION BY year, genre ORDER BY worlwide_gross_income DESC) as movie_rank
  FROM genres_movies
)
SELECT genre, year, title AS movie_name, worlwide_gross_income, movie_rank
FROM ranked_movies
WHERE movie_rank <= 5
ORDER BY year, genre, movie_rank;


-- Top 3 Genres based on most number of movies



-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH temp AS (
  SELECT production_company, COUNT(*) AS hits, COUNT(languages)
  FROM movie
  JOIN ratings ON movie.id = ratings.movie_id
  WHERE median_rating >= 8 AND POSITION(',' IN languages) AND production_company IS NOT NULL
  GROUP BY production_company
)
SELECT production_company, hits, RANK() OVER (ORDER BY hits DESC) AS prod_comp_rank
FROM temp
ORDER BY hits DESC
LIMIT 2;

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT n.name AS actress_name, COUNT(r.movie_id) AS movie_count,
       AVG(r.avg_rating) AS actress_avg_rating, SUM(r.total_votes) AS total_votes,
       ROW_NUMBER() OVER (ORDER BY COUNT(r.movie_id) DESC) AS actress_rank
FROM names n
JOIN role_mapping rm ON n.id = rm.name_id
JOIN movie m ON m.id = rm.movie_id
JOIN ratings r ON m.id = r.movie_id
JOIN genre g ON m.id = g.movie_id
WHERE rm.category = 'actress' AND g.genre = 'drama' AND r.avg_rating > 8
GROUP BY n.name
ORDER BY movie_count DESC
LIMIT 3;

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

 WITH ctf_date_summary AS
 (SELECT d.name_id, NAME, d.movie_id, m.duration, r.avg_rating, total_votes, m.date_published,
     Lead(date_published,1) OVER(PARTITION BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published
  FROM director_mapping AS d
  INNER JOIN names AS n ON n.id = d.name_id 
  INNER JOIN movie AS m ON m.id = d.movie_id
  INNER JOIN ratings AS r ON r.movie_id = m.id ), 
top_director_summary AS
(
SELECT *, Datediff(next_date_published, date_published) AS date_difference
FROM ctf_date_summary
)
SELECT name_id AS director_id,
NAME AS director_name,
COUNT(movie_id) AS number_of_movies,
ROUND(AVG(date_difference)) AS avg_inter_movie_days,
ROUND(AVG(avg_rating),2) AS avg_rating,
SUM(total_votes) AS total_votes,
MIN(avg_rating) AS min_rating,
MAX(avg_rating) AS max_rating,
SUM(duration) AS total_duration
FROM top_director_summary
GROUP BY director_id
ORDER BY COUNT(movie_id) DESC
limit 9;



