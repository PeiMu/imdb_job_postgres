
set max_parallel_workers = 0;
set effective_cache_size to '8 GB';
set statement_timeout = '1000s';


DO
$do$
DECLARE
   _timing1  timestamptz;
   _start_ts timestamptz;
   _end_ts   timestamptz;
   _overhead numeric;     -- in ms
   _timing   numeric;     -- in ms
BEGIN
   _timing1  := clock_timestamp();
   _start_ts := clock_timestamp();
   _end_ts   := clock_timestamp();
   -- take minimum duration as conservative estimate
   _overhead := 1000 * extract(epoch FROM LEAST(_start_ts - _timing1 , _end_ts - _start_ts));
   _start_ts := clock_timestamp();
perform MIN(cn.name) AS movie_company,
       MIN(mi_idx.info) AS rating,
       MIN(t.title) AS drama_horror_movie
FROM company_name AS cn,
     company_type AS ct,
     info_type AS it1,
     info_type AS it2,
     movie_companies AS mc,
     movie_info AS mi,
     movie_info_idx AS mi_idx,
     title AS t
WHERE cn.country_code = '[us]'
  AND ct.kind = 'production companies'
  AND it1.info = 'genres'
  AND it2.info = 'rating'
  AND mi.info IN ('Drama',
                  'Horror')
  AND mi_idx.info > '8.0'
  AND t.production_year BETWEEN 2005 AND 2008
  AND t.id = mi.movie_id
  AND t.id = mi_idx.movie_id
  AND mi.info_type_id = it1.id
  AND mi_idx.info_type_id = it2.id
  AND t.id = mc.movie_id
  AND ct.id = mc.company_type_id
  AND cn.id = mc.company_id
  AND mc.movie_id = mi.movie_id
  AND mc.movie_id = mi_idx.movie_id
  AND mi.movie_id = mi_idx.movie_id;


   _end_ts   := clock_timestamp();
   
-- RAISE NOTICE 'Timing overhead in ms = %', _overhead;
   RAISE NOTICE 'Execution time in ms = %', 1000 * (extract(epoch FROM _end_ts - _start_ts)) - _overhead;
END
$do$;

