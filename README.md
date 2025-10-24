# Netflix Movies & TV Shows Data Analysis using SQL Server

![netflix_logo](https://github.com/Naman745rajput/netflix_sql_server_project/blob/main/netflix_logo.jpg)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
select 
	type,
	count(*) as total_content 
from netflix 
group by type;
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
select
   type,
   rating
from (select 
		type,
		rating ,
		count(*) as cnt,
		rank() over(partition by type order by count(*) desc) as ranking
	from netflix
	group by type,rating) as rnk_tb
where 
	ranking=1;
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
select * from netflix
where 
	release_year = 2020 
	and
	type ='Movie';
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
select 
	 top 5 Country, 
	count(*) as cnt 
from
		(
		select trim(value) AS Country from netflix
		CROSS APPLY STRING_SPLIT(TRIM('" ' FROM Country), ',')
		) as tb1
group by Country
order by cnt  desc;
```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
select
   title ,
   duration,
   cast(LEFT(duration ,CHARINDEX(' ',duration)) as int) as dur
from netflix 
where
   type = 'Movie'
order by dur desc;
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
select *
from netflix
where
   date_added >= dateadd(year , -5 , getdate());
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
select title from 
	(
		select * from netflix
		CROSS APPLY STRING_SPLIT(TRIM('" ' FROM director), ',')
	) as t1
where value = 'Rajiv Chilaka'

select * from netflix     -- another solution
where director like '%Rajiv Chilaka%';
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
select
   title,				
   cast(LEFT(duration ,CHARINDEX(' ',duration)) as int) as total_seasons
from netflix
where
   type = 'TV Show';
```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
select
   genre,
   count(*) as content_count from 
(
select title , (value) as genre from netflix
cross apply string_split(TRIM('"' from listed_in) ,',' )
) as t1
group by genre;
```

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

```sql
select 
    DATEPART(YEAR , date_added),
	COUNT(*) as yearly_content,
	cast(count(*) as numeric)/cast((select count(*) from netflix where country='India') as numeric) *100 
	as avg_content_per_year
from netflix
where
    country='India'
group by DATEPART(YEAR , date_added);
```

**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List All Movies that are Documentaries

```sql
select *
from netflix  
where
   listed_in like '%Documentaries%'
   and
   type = 'Movie';
```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
select *
from netflix
where
  director is null;
```

**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
select *
from netflix
where
    release_year >= datepart(year ,dateadd(year , -10 , getdate()))
    and
    cast like '%Salman Khan%';
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
select
    top 10 cast,
    count(*) as no_of_movies from 
(
select show_id , title ,country, TRIM(value) as cast
from netflix
cross apply string_split(TRIM('"' from cast) ,',')
where
    country like '%india%'
) as t1 
group by cast
order by no_of_movies desc;
```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
with new_table as 
(
select * ,
	case when description like '%kill%' or
	          description like '%violence%'
		 then 'Bad' else 
		      'Good'
	end as categorized
from netflix
)
select
    categorized,
    count(*) as total_content
from new_table
group by categorized;
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.



## Author - Zero Analyst

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

### Stay Updated and Join the Community

For more content on SQL, data analysis, and other data-related topics, make sure to follow me on social media and join our community:

- **YouTube**: [Subscribe to my channel for tutorials and insights](https://www.youtube.com/@zero_analyst)
- **Instagram**: [Follow me for daily tips and updates](https://www.instagram.com/zero_analyst/)
- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/najirr)
- **Discord**: [Join our community to learn and grow together](https://discord.gg/36h5f2Z5PK)

Thank you for your support, and I look forward to connecting with you!
