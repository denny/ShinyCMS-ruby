begin;
create role blazer login password 'YOUR-PASSWORD-HERE';
grant connect on database shinycms_development to blazer;
grant usage on schema public to blazer;
grant select on all tables in schema public to blazer;
alter default privileges in schema public grant select on tables to blazer;
commit;
