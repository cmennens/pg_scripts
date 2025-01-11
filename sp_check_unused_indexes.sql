/*
--------------------------------------------------------------------------------
Stored Procedure: sp_check_unused_indexes
--------------------------------------------------------------------------------
Purpose:
    Identifies and lists all unused indexes in the current PostgreSQL database.
    Unused indexes are identified by checking if the `idx_scan` count is zero,
    meaning the index has never been used by the query planner.

Usage:
    CALL sp_check_unused_indexes();

Parameters:
    None

Output:
    - Schema Name (schemaname)
    - Table Name (table_name)
    - Index Name (index_name)
    - Number of Times Used (times_used)
    - Index Size (index_size)

Author:
    Carlos Mennens

Created On:
    1/10/2025

Notes:
    - Indexes that appear in the result set have never been scanned.
    - Regular review of unused indexes is recommended to optimize performance.
    - Consider dropping or re-evaluating these indexes if they are not critical.

Maintenance:
    - Review the stored procedure periodically for accuracy and efficiency.
    - Ensure compatibility with future PostgreSQL versions.

--------------------------------------------------------------------------------
*/

CREATE OR REPLACE PROCEDURE sp_check_unused_indexes()
LANGUAGE plpgsql
AS $$
BEGIN
    -- Notify the user that the procedure has started.
    RAISE NOTICE 'Starting unused index check...';

    -- Query to find indexes that have never been used (idx_scan = 0).
    EXECUTE format($f$
        SELECT
            psui.schemaname,                           -- Schema of the table
            psui.relname AS table_name,                -- Table name
            psui.indexrelname AS index_name,           -- Index name
            psui.idx_scan AS times_used,               -- Number of times the index has been scanned
            pg_size_pretty(pg_relation_size(psui.indexrelid)) AS index_size  -- Human-readable index size
        FROM
            pg_stat_user_indexes psui
            JOIN pg_index pi ON pi.indexrelid = psui.indexrelid
        WHERE
            psui.idx_scan = 0  -- Filter for indexes that have never been used
        ORDER BY
            pg_relation_size(psui.indexrelid) DESC;  -- Show largest unused indexes first
    $f$);

    -- Notify the user that the procedure has completed.
    RAISE NOTICE 'Unused index check completed.';

END;
$$;
