/*
===============================================================================
Stored Procedure: find_long_running_queries
-------------------------------------------------------------------------------
Purpose:
    - Detects long-running queries based on a specified threshold.
    - Optionally terminates those queries if desired.

Parameters:
    - threshold (INTERVAL): 
        The minimum duration a query must run to be considered "long-running".
        Default: '5 minutes'

    - terminate (BOOLEAN): 
        Controls whether to terminate the detected queries.
        - TRUE  => Terminates the identified queries.
        - FALSE => Only lists the identified queries (default).

Usage Examples:
-------------------------------------------------------------------------------
1. List all queries running longer than 10 minutes (DO NOT terminate):
    CALL find_long_running_queries('10 minutes', FALSE);

2. Terminate all queries running longer than 15 minutes:
    CALL find_long_running_queries('15 minutes', TRUE);

3. Use default settings (list queries > 5 minutes, no termination):
    CALL find_long_running_queries();

Security:
    - Ensure only trusted users have EXECUTE privileges on this procedure.

===============================================================================
*/

CREATE OR REPLACE PROCEDURE find_long_running_queries(
    threshold INTERVAL DEFAULT '5 minutes',
    terminate BOOLEAN DEFAULT FALSE
)
LANGUAGE plpgsql
AS $$
DECLARE
    r RECORD;
BEGIN
    -- Loop through active queries that exceed the threshold
    FOR r IN
        SELECT pid, query, now() - query_start AS duration
        FROM pg_stat_activity
        WHERE state = 'active'
          AND now() - query_start > threshold
          AND pid <> pg_backend_pid()         -- Exclude this procedure itself
          AND query NOT ILIKE '%pg_stat_activity%'  -- Exclude monitoring queries
    LOOP
        -- Terminate or List the query based on the 'terminate' flag
        IF terminate THEN
            RAISE NOTICE 'Terminating PID % with query: %', r.pid, r.query;
            PERFORM pg_terminate_backend(r.pid);
        ELSE
            RAISE NOTICE 'Detected long-running query (PID %): %', r.pid, r.query;
        END IF;
    END LOOP;

    -- Notify if no queries matched the criteria
    IF NOT FOUND THEN
        RAISE NOTICE 'No long-running queries found exceeding %.', threshold;
    END IF;
END $$;
