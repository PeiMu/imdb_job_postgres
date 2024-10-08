set effective_cache_size to '8 GB';
set statement_timeout = '1000s';

SET max_parallel_workers = 0;
SET max_parallel_workers_per_gather = 0;
SET parallel_leader_participation = off;

SELECT MIN(title.title) AS movie_title
FROM company_name,
     keyword,
     movie_companies,
     movie_keyword,
     title
WHERE company_name.country_code ='[nl]'
  AND keyword.keyword ='character-name-in-title'
  AND company_name.id = movie_companies.company_id
  AND movie_companies.movie_id = title.id
  AND title.id = movie_keyword.movie_id
  AND movie_keyword.keyword_id = keyword.id
  AND movie_companies.movie_id = movie_keyword.movie_id;

