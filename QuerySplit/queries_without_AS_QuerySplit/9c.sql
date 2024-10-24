switch to c_r;
switch to relationshipcenter;

set effective_cache_size to '8 GB';
set statement_timeout = '1000s';
SET max_parallel_workers = 0;
SET max_parallel_workers_per_gather = 0;
SET parallel_leader_participation = off;

SELECT MIN(aka_name.name) AS alternative_name,
       MIN(char_name.name) AS voiced_character_name,
       MIN(name.name) AS voicing_actress,
       MIN(title.title) AS american_movie
FROM aka_name,
     char_name,
     cast_info,
     company_name,
     movie_companies,
     name,
     role_type,
     title
WHERE cast_info.note IN ('(voice)',
                  '(voice: Japanese version)',
                  '(voice) (uncredited)',
                  '(voice: English version)')
  AND company_name.country_code ='[us]'
  AND name.gender ='f'
  AND name.name LIKE '%An%'
  AND role_type.role ='actress'
  AND cast_info.movie_id = title.id
  AND title.id = movie_companies.movie_id
  AND cast_info.movie_id = movie_companies.movie_id
  AND movie_companies.company_id = company_name.id
  AND cast_info.role_id = role_type.id
  AND name.id = cast_info.person_id
  AND char_name.id = cast_info.person_role_id
  AND aka_name.person_id = name.id
  AND aka_name.person_id = cast_info.person_id;
