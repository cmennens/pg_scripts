-- Lists all queries running longer than 5 minutes
SELECT 
    pid,
    now() - pg_stat_activity.query_start AS duration,
    query,
    state
FROM 
    pg_stat_activity
WHERE 
    state = 'active'
    AND now() - pg_stat_activity.query_start > interval '5 minutes'
ORDER BY 
    duration DESC;
