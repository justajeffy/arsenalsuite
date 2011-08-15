CREATE OR REPLACE VIEW HostInterfacesVerbose AS SELECT host.keyhost, host.backupbytes, host.cpus, host.description, host.diskusage, host.fkeyjob, host.host, host.manufacturer, host.model, host.os, host.rendertime, host.slavepluginlist, host.sn, host.version, host.renderrate, host.dutycycle, host.memory, host.mhtz, host.online, host.uid, host.slavepacketweight, host.framecount, host.viruscount, host.virustimestamp, host.errortempo, host.fkeyhost_backup, host.oldkey, host.abversion, host.laststatuschange, host.loadavg, host.allowmapping, host.allowsleep, host.fkeyjobtask, host.wakeonlan, host.architecture, host.loc_x, host.loc_y, host.loc_z, host.ostext, host.bootaction, host.fkeydiskimage, host.syncname, host.fkeylocation, host.cpuname, host.osversion, host.slavepulse, hostinterface.keyhostinterface, hostinterface.fkeyhost, hostinterface.mac, hostinterface.ip, hostinterface.fkeyhostinterfacetype, hostinterface.switchport, hostinterface.fkeyswitch, hostinterface.inst FROM (host JOIN hostinterface ON ((host.keyhost = hostinterface.fkeyhost)));
ALTER TABLE HostInterfacesVerbose OWNER TO farmer;

CREATE OR REPLACE VIEW StatsByType AS SELECT ''::text AS day, jobtype.jobtype, count(*) AS frames FROM ((jobtask LEFT JOIN job ON ((jobtask.fkeyjob = job.keyjob))) LEFT JOIN jobtype ON ((jobtype.keyjobtype = job.fkeyjobtype))) WHERE (jobtask.status = 'done'::text) GROUP BY jobtype.jobtype;
ALTER TABLE StatsByType OWNER TO farmer;

CREATE OR REPLACE VIEW license_usage AS SELECT service.service, license.license, (license.total - license.reserved), count(*) AS count FROM ((((jobassignment ja JOIN job ON ((ja.fkeyjob = job.keyjob))) JOIN jobservice js ON ((js.fkeyjob = job.keyjob))) JOIN service ON ((js.fkeyservice = service.keyservice))) JOIN license ON ((service.fkeylicense = license.keylicense))) WHERE (ja.fkeyjobassignmentstatus < 4) GROUP BY service.service, license.license, license.total, license.reserved;
ALTER TABLE license_usage OWNER TO farmer;

CREATE OR REPLACE VIEW license_usage_2 AS SELECT service.service, (license.total - license.reserved), count(ja.keyjobassignment) AS count FROM ((((service JOIN jobservice js ON ((js.fkeyservice = service.keyservice))) JOIN job ON ((js.fkeyjob = job.keyjob))) LEFT JOIN jobassignment ja ON (((ja.fkeyjob = job.keyjob) AND (ja.fkeyjobassignmentstatus < 4)))) JOIN license ON ((service.fkeylicense = license.keylicense))) GROUP BY service.service, license.total, license.reserved;
ALTER TABLE license_usage_2 OWNER TO farmer;

CREATE OR REPLACE VIEW pg_stat_statements AS SELECT pg_stat_statements.userid, pg_stat_statements.dbid, pg_stat_statements.query, pg_stat_statements.calls, pg_stat_statements.total_time, pg_stat_statements.rows, pg_stat_statements.shared_blks_hit, pg_stat_statements.shared_blks_read, pg_stat_statements.shared_blks_written, pg_stat_statements.local_blks_hit, pg_stat_statements.local_blks_read, pg_stat_statements.local_blks_written, pg_stat_statements.temp_blks_read, pg_stat_statements.temp_blks_written FROM pg_stat_statements() pg_stat_statements(userid, dbid, query, calls, total_time, rows, shared_blks_hit, shared_blks_read, shared_blks_written, local_blks_hit, local_blks_read, local_blks_written, temp_blks_read, temp_blks_written);
ALTER TABLE pg_stat_statements OWNER TO postgres;

CREATE OR REPLACE VIEW project_slots_limits AS SELECT project.name, project.arsenalslotlimit, project.arsenalslotreserve FROM project WHERE ((project.arsenalslotlimit > (-1)) OR (project.arsenalslotreserve > 0));
ALTER TABLE project_slots_limits OWNER TO farmer;

CREATE OR REPLACE VIEW running_shots_averagetime AS SELECT job.shotname, avg(jobstatus.tasksaveragetime) AS avgtime FROM (job JOIN jobstatus jobstatus ON ((jobstatus.fkeyjob = job.keyjob))) WHERE (job.status = ANY (ARRAY['ready'::text, 'started'::text])) GROUP BY job.shotname;
ALTER TABLE running_shots_averagetime OWNER TO farmer;

CREATE OR REPLACE VIEW running_shots_averagetime_2 AS SELECT job.shotname, project.name, (GREATEST((0)::double precision, avg(GREATEST((0)::double precision, (date_part('epoch'::text, ((jobtaskassignment.ended)::timestamp with time zone - (jobtaskassignment.started)::timestamp with time zone)) * (job.slots)::double precision)))))::numeric AS avgtime FROM ((((jobtaskassignment JOIN jobtask ON ((jobtask.fkeyjobtaskassignment = jobtaskassignment.keyjobtaskassignment))) JOIN job ON ((jobtask.fkeyjob = job.keyjob))) JOIN jobstatus jobstatus ON ((jobstatus.fkeyjob = job.keyjob))) JOIN project ON ((job.fkeyproject = project.keyelement))) WHERE ((jobtaskassignment.ended IS NOT NULL) AND (job.status = ANY (ARRAY['ready'::text, 'started'::text]))) GROUP BY job.shotname, project.name;
ALTER TABLE running_shots_averagetime_2 OWNER TO farmer;

CREATE OR REPLACE VIEW running_shots_averagetime_3 AS SELECT job.shotname, project.name, (GREATEST((0)::double precision, avg(GREATEST((0)::double precision, (date_part('epoch'::text, ((jobassignment.ended)::timestamp with time zone - (jobassignment.started)::timestamp with time zone)) * (jobassignment.assignslots)::double precision)))))::integer AS avgtime FROM ((jobassignment JOIN job ON (((jobassignment.fkeyjob = job.keyjob) AND (job.status = ANY (ARRAY['ready'::text, 'started'::text]))))) JOIN project ON ((job.fkeyproject = project.keyelement))) WHERE (jobassignment.ended IS NOT NULL) GROUP BY job.shotname, project.name;
ALTER TABLE running_shots_averagetime_3 OWNER TO farmer;

CREATE OR REPLACE VIEW running_shots_averagetime_4 AS SELECT job.shotname, project.name, ((sum(jobstatus.averagedonetime))::integer / COALESCE(dw.weight, 1)) AS avgtime FROM (((job JOIN jobstatus ON ((jobstatus.fkeyjob = job.keyjob))) JOIN project ON ((job.fkeyproject = project.keyelement))) LEFT JOIN darwinweight dw ON (((job.shotname = dw.shotname) AND (project.name = dw.projectname)))) WHERE (job.status = ANY (ARRAY['ready'::text, 'started'::text])) GROUP BY job.shotname, project.name, dw.weight ORDER BY job.shotname;
ALTER TABLE running_shots_averagetime_4 OWNER TO postgres;

CREATE OR REPLACE VIEW user_service_current AS SELECT ((usr.name || ':'::text) || service.service), sum(jobstatus.hostsonjob) AS sum FROM ((((usr JOIN job ON (((usr.keyelement = job.fkeyusr) AND (job.status = ANY (ARRAY['ready'::text, 'started'::text]))))) JOIN jobstatus jobstatus ON ((job.keyjob = jobstatus.fkeyjob))) JOIN jobservice js ON ((job.keyjob = js.fkeyjob))) JOIN service ON ((service.keyservice = js.fkeyservice))) GROUP BY usr.name, service.service;
ALTER TABLE user_service_current OWNER TO farmer;

CREATE OR REPLACE VIEW user_service_limits AS SELECT ((usr.name || ':'::text) || service.service), sum(us."limit") AS nottoexceed FROM ((usr JOIN userservice us ON ((usr.keyelement = us."user"))) JOIN service ON ((service.keyservice = us.service))) GROUP BY usr.name, service.service;
ALTER TABLE user_service_limits OWNER TO farmer;

CREATE OR REPLACE VIEW user_slots_limits AS SELECT usr.name, usr.arsenalslotlimit, usr.arsenalslotreserve FROM usr WHERE ((usr.arsenalslotlimit > (-1)) OR (usr.arsenalslotreserve > 0));
ALTER TABLE user_slots_limits OWNER TO farmer;

CREATE OR REPLACE VIEW project_slots_current AS SELECT project.name, COALESCE(sum(jobstatus.hostsonjob), (0)::bigint) AS sum, project.arsenalslotreserve, project.arsenalslotlimit FROM ((project LEFT JOIN job ON (((project.keyelement = job.fkeyproject) AND (job.status = 'started'::text)))) LEFT JOIN jobstatus jobstatus ON ((job.keyjob = jobstatus.fkeyjob))) GROUP BY project.name, project.arsenalslotreserve, project.arsenalslotlimit;
ALTER TABLE project_slots_current OWNER TO farmer;

CREATE OR REPLACE VIEW user_slots_current AS SELECT usr.name, sum(jobstatus.hostsonjob) AS sum FROM ((usr JOIN job ON (((usr.keyelement = job.fkeyusr) AND (job.status = 'started'::text)))) JOIN jobstatus jobstatus ON ((job.keyjob = jobstatus.fkeyjob))) GROUP BY usr.name;
ALTER TABLE user_slots_current OWNER TO farmer;

