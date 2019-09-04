-- create a temp table to store the csv file
CREATE TEMP TABLE t
(obj_guid varchar(100), row_ts date);
CREATE TABLE

-- copy the csv file data into the temp table
\COPY t (obj_guid, row_ts)
FROM '/home/cmennens/obj_guids.csv' WITH (format csv);
COPY 21114

-- insert the two columns values from the csv into the temp table
INSERT INTO cxp.objects (obj_guid, row_ts)
SELECT obj_guid, row_ts FROM t;
INSERT 0 21114

-- drops the temp table you created above when task is done
DROP TABLE t;
DROP TABLE