-- how to find all records in a specific date range 
SELECT row_ts::DATE, COUNT(*)
FROM ccvalues
WHERE row_ts >= '2019-07-01 00:00:00' and row_ts <= '2019-07-09 23:59:59'
GROUP BY row_ts::DATE;

SELECT row_ts::DATE, COUNT(*)
FROM ccvalues
GROUP BY row_ts::DATE;



