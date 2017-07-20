-- save this file in db directory on the CCI server for MySQL, *NOT* iSpace
-- run command: \. db/mymetada.sql
-- tee command: all query result sets displayed on screen are appended into indicated file.
-- For example: every time you run above command a report is saved in file: db/mymetadata_reports.sql

-- NOTE: alternately, you could log into MySQL like this...
-- mysql -u username -p --tee=db/mymetadata_reports.sql
-- end reporting by typing "exit" (w/o quotation marks)

tee db/mymetadata_reports.sql

-- display user database metadata
SELECT now() as report_date, table_schema, table_name, table_type, engine, column_name, column_type, is_nullable, table_rows
FROM information_schema.tables
  natural join information_schema.columns
where table_schema = 'amd14b'
ORDER BY table_name;

-- optional
-- use databasename;
-- show tables;
-- describe tablename;
-- select * from tablename;

-- stop tee'ing on yourself!  :)
notee
