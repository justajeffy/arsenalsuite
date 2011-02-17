ALTER TABLE license DROP CONSTRAINT check_license_inuse;

ALTER TABLE license
   ADD CONSTRAINT check_license_inuse CHECK (inuse <= total);
