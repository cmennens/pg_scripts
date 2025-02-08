-- Shows active locks with related queries
SELECT 
    pg_locks.locktype,
    pg_stat_activity.pid,
    pg_stat_activity.query,
    pg_locks.mode,
    pg_locks.granted
FROM 
    pg_locks
JOIN 
    pg_stat_activity 
    ON pg_locks.pid = pg_stat_activity.pid
WHERE 
    pg_stat_activity.state != 'idle';
