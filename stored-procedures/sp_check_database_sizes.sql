/***
--------------------------------------------------------------------------------
Stored Procedure: sp_check_database_sizes
--------------------------------------------------------------------------------
Purpose:
    Lists the sizes of all accessible databases in the PostgreSQL instance.
    The procedure returns the top 20 largest databases by size.

Usage:
    CALL sp_check_database_sizes();

Parameters:
    None

Output:
    - Database Name (Name)
    - Owner (Owner)
    - Size (Size) [in human-readable format, e.g., MB/GB]

Author:
    [Your Name]

Created On:
    [Creation Date]

Notes:
    - If the user does not have the CONNECT privilege on a database,
      the size will be displayed as 'No Access'.
    - Results are ordered from the largest to smallest databases.
    - Useful for monitoring storage usage across multiple databases.

Maintenance:
    - Review periodically to ensure performance on large clusters.
    - Extend with logging or alerts if necessary.

--------------------------------------------------------------------------------
***/

CREATE OR REPLACE PROCEDURE sp_check_database_sizes()
LANGUAGE plpgsql
AS $$
BEGIN
    -- Notify the user that the procedure has started.
    RAISE NOTICE 'Starting database size check...';

    -- Execute the query to fetch database sizes.
    EXECUTE format($f$
        SELECT 
            d.datname AS Name,  -- Database name
            pg_catalog.pg_get_userbyid(d.datdba) AS Owner,  -- Database owner
            CASE 
                WHEN pg_catalog.has_database_privilege(d.datname, 'CONNECT')
                    THEN pg_catalog.pg_size_pretty(pg_catalog.pg_database_size(d.datname))  -- Database size if accessible
                ELSE 'No Access'  -- No permission to access the database
            END AS Size
        FROM 
            pg_catalog.pg_database d
        ORDER BY
            CASE 
                WHEN pg_catalog.has_database_privilege(d.datname, 'CONNECT')
                    THEN pg_catalog.pg_database_size(d.datname)  -- Order by size if accessible
                ELSE NULL  -- Nulls first for inaccessible databases
            END DESC
        LIMIT 20;  -- Show only the top 20 largest databases
    $f$);

    -- Notify the user that the procedure has completed.
    RAISE NOTICE 'Database size check completed.';

END;
$$;
