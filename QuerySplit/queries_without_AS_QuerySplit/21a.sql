switch to c_r;
switch to relationshipcenter;

set effective_cache_size to '8 GB';
set statement_timeout = '1000s';
SET max_parallel_workers = 0;
SET max_parallel_workers_per_gather = 0;
SET parallel_leader_participation = off;

SELECT MIN(company_name.name) AS company_name,
       MIN(link_type.link) AS link_type,
       MIN(title.title) AS western_follow_up
FROM company_name,
     company_type,
     keyword,
     link_type,
     movie_companies,
     movie_info,
     movie_keyword,
     movie_link,
     title
WHERE company_name.country_code !='[pl]'
  AND (company_name.name LIKE '%Film%'
       OR company_name.name LIKE '%Warner%')
  AND company_type.kind ='production companies'
  AND keyword.keyword ='sequel'
  AND link_type.link LIKE '%follow%'
  AND movie_companies.note IS NULL
  AND movie_info.info IN ('Sweden',
                  'Norway',
                  'Germany',
                  'Denmark',
                  'Swedish',
                  'Denish',
                  'Norwegian',
                  'German')
  AND title.production_year BETWEEN 1950 AND 2000
  AND link_type.id = movie_link.link_type_id
  AND movie_link.movie_id = title.id
  AND title.id = movie_keyword.movie_id
  AND movie_keyword.keyword_id = keyword.id
  AND title.id = movie_companies.movie_id
  AND movie_companies.company_type_id = company_type.id
  AND movie_companies.company_id = company_name.id
  AND movie_info.movie_id = title.id
  AND movie_link.movie_id = movie_keyword.movie_id
  AND movie_link.movie_id = movie_companies.movie_id
  AND movie_keyword.movie_id = movie_companies.movie_id
  AND movie_link.movie_id = movie_info.movie_id
  AND movie_keyword.movie_id = movie_info.movie_id
  AND movie_companies.movie_id = movie_info.movie_id;
