set effective_cache_size to '8 GB';
set statement_timeout = '1000s';

SET max_parallel_workers = 0;
SET max_parallel_workers_per_gather = 0;
SET parallel_leader_participation = off;

SELECT MIN(title.title) AS american_vhs_movie
FROM company_type,
     info_type,
     movie_companies,
     movie_info,
     title
WHERE company_type.kind = 'production companies'
  AND movie_companies.note LIKE '%(VHS)%'
  AND movie_companies.note LIKE '%(USA)%'
  AND movie_companies.note LIKE '%(1994)%'
  AND movie_info.info IN ('USA',
                  'America')
  AND title.production_year > 2010
  AND title.id = movie_info.movie_id
  AND title.id = movie_companies.movie_id
  AND movie_companies.movie_id = movie_info.movie_id
  AND company_type.id = movie_companies.company_type_id
  AND info_type.id = movie_info.info_type_id;

