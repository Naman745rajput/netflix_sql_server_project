-- 15 Business Problems solution

-- 1. Count the number of Movies vs TV Shows

select 
	type,
	count(*) as total_content 
from netflix 
group by type;

-- 2. Find the most common rating for Movies and TV Shows

select type,rating from 
	(select 
		type,
		rating ,
		count(*) as cnt,
		rank() over(partition by type order by count(*) desc) as ranking
	from netflix
	group by type,rating) as rnk_tb
where 
	ranking=1;

-- 3. List all movies released in a specific year (e.g. 2020)

select * from netflix
where 
	release_year = 2020 
	and
	type ='Movie';

-- 4. Find the top 5 countries with the most content on Netflix


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


-- 5. Identify the longest movie

select
   title ,
   duration,
   cast(LEFT(duration ,CHARINDEX(' ',duration)) as int) as dur
from netflix 
where
   type = 'Movie'
order by dur desc;

-- 6. find content added in the last 5 years

select *
from netflix
where
   date_added >= dateadd(year , -5 , getdate());

-- 7. find all the movies/TV shows directed bt 'Rajiv Chilaka' 

select title from 
	(
		select * from netflix
		CROSS APPLY STRING_SPLIT(TRIM('" ' FROM director), ',')
	) as t1
where value = 'Rajiv Chilaka'

select * from netflix     -- another solution
where director like '%Rajiv Chilaka%';

-- 8. list all TV Shows with more than 5 seasons 


select
   title,				
   cast(LEFT(duration ,CHARINDEX(' ',duration)) as int) as total_seasons
from netflix
where
   type = 'TV Show';

-- 9. count the number of content items in each genre 

select
   genre,
   count(*) as content_count from 
(
select title , (value) as genre from netflix
cross apply string_split(TRIM('"' from listed_in) ,',' )
) as t1
group by genre;

-- 10. find each year and the average number of content releases by india on netflix


select 
    DATEPART(YEAR , date_added),
	COUNT(*) as yearly_content,
	cast(count(*) as numeric)/cast((select count(*) from netflix where country='India') as numeric) *100 
	as avg_content_per_year
from netflix
where
    country='India'
group by DATEPART(YEAR , date_added);


-- 11. list all the movies that are documentries

select * from netflix
cross apply string_split(trim('"' from listed_in) , ',')
where type = 'Movie'
and trim(value) ='Documentaries';

select * from netflix   -- another solution to the above question
where listed_in like '%Documentaries%'
and type = 'Movie';


-- 12. find all the content without a director 

select *
from netflix
where
  director is null;


-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years

select *
from netflix
where
    release_year >= datepart(year ,dateadd(year , -10 , getdate()))
    and
    cast like '%Salman Khan%';


-- 14. find the top 10 actors who have appeared in the highest number of movies produced in india 

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

/* 15. catgorize the content based on the presence of the keywords
       'kill' and 'violence' in the description field. Label content containing these
       keywords as 'Bad' and all other content as 'Good'. count how many items fall 
       into each category */

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




