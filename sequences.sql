CREATE SEQUENCE seq_meh_id;
SELECT setval('seq_meh_id', MAX(id)) FROM meh; 

ALTER TABLE meh ALTER COLUMN id SET DEFAULT
nextval('seq_meh_id');


CREATE vendor_seq start 7000;

CREATE TABLE vendor 
(
    vendor_id int primary key default nextval('vendor_seq'),
    vendor_name varchar(50) unique not null
);

-- And to reset the current value of the sequence:
ALTER SEQUENCE vendor_seq restart 8000;
