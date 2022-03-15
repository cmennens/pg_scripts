-- Generate random data in PostgreSQL
SELECT 
  generate_series(1,10) AS id, 
  md5(random()::text) AS test_col;
