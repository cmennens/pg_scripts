-- Finds potential missing indexes based on sequential scans
SELECT 
    schemaname,
    relname AS table_name,
    seq_scan,
    idx_scan,
    (seq_scan - idx_scan) AS potential_missing_indexes
FROM 
    pg_stat_user_tables
WHERE 
    seq_scan > 1000 AND idx_scan < 100
ORDER BY 
    potential_missing_indexes DESC;
