SELECT generate_series(1,10) AS id, md5(random()::text) AS test_col; -- generate random pg data
