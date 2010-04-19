--
-- PostgreSQL database dump
--

-- Started on 2010-01-28 13:21:02 EST

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- TOC entry 6 (class 2615 OID 16385)
-- Name: jabberd; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA jabberd;


--
-- TOC entry 1054 (class 2612 OID 16388)
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: -
--

CREATE PROCEDURAL LANGUAGE plpgsql;


SET search_path = public, pg_catalog;

--
-- TOC entry 303 (class 1247 OID 16391)
-- Dependencies: 3 2227
-- Name: hosthistory_status_percentages_return; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE hosthistory_status_percentages_return AS (
	status text,
	loading boolean,
	wasted boolean,
	total_time interval,
	total_perc double precision,
	non_idle_perc double precision,
	non_idle_non_wasted_perc double precision
);


--
-- TOC entry 305 (class 1247 OID 16394)
-- Dependencies: 3 2228
-- Name: hosthistory_status_summary_return; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE hosthistory_status_summary_return AS (
	status text,
	loading boolean,
	wasted boolean,
	count integer,
	total_time interval,
	avg_time interval,
	max_time interval,
	min_time interval
);


--
-- TOC entry 344 (class 1247 OID 16397)
-- Dependencies: 3 2229
-- Name: hosthistory_user_slave_summary_return; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE hosthistory_user_slave_summary_return AS (
	usr text,
	host text,
	hours numeric
);


--
-- TOC entry 346 (class 1247 OID 16400)
-- Dependencies: 3 2230
-- Name: job_gatherstats_result; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE job_gatherstats_result AS (
	mintasktime interval,
	avgtasktime interval,
	maxtasktime interval,
	totaltasktime interval,
	taskcount integer,
	minloadtime interval,
	avgloadtime interval,
	maxloadtime interval,
	totalloadtime interval,
	loadcount integer,
	minerrortime interval,
	avgerrortime interval,
	maxerrortime interval,
	totalerrortime interval,
	errorcount integer,
	mincopytime interval,
	avgcopytime interval,
	maxcopytime interval,
	totalcopytime interval,
	copycount integer,
	totaltime interval
);


--
-- TOC entry 348 (class 1247 OID 16403)
-- Dependencies: 3 2231
-- Name: waywardhostret; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE waywardhostret AS (
	keyhost integer,
	reason integer
);


--
-- TOC entry 21 (class 1255 OID 16404)
-- Dependencies: 3 1054
-- Name: after_update_jobtask(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION after_update_jobtask() RETURNS trigger
    AS $$
DECLARE
BEGIN
	-- Update Job Counters when a tasks status changes
	IF (NEW.status != coalesce(OLD.status,'')) THEN
		PERFORM update_job_task_counts(NEW.fkeyjob);
	END IF;
RETURN new;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 22 (class 1255 OID 16405)
-- Dependencies: 3 1054
-- Name: assignment_status_count(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION assignment_status_count(fkeyjobassignmentstatus integer) RETURNS integer
    AS $$
DECLARE
	status jobassignmentstatus;
BEGIN
	SELECT INTO status * FROM jobassignmentstatus WHERE keyjobassignmentstatus=fkeyjobassignmentstatus;
	IF status.status IN ('done','cancelled','error') THEN
		RETURN 0;
	END IF;
	IF status.status IN ('ready','copy','busy') THEN
		return 1;
	END IF;
	RETURN 0;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 23 (class 1255 OID 16406)
-- Dependencies: 3 1054
-- Name: cancel_job_assignment(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION cancel_job_assignment(_keyjobassignment integer) RETURNS void
    AS $$
DECLARE
	cancelledStatusKey int;
	assignment jobassignment;
	_job job;
BEGIN
	SELECT INTO cancelledStatusKey keyjobassignmentstatus FROM jobassignmentstatus WHERE status='cancelled';
	SELECT INTO assignment * FROM jobassignment WHERE keyjobassignment=_keyjobassignment;
	SELECT INTO _job * FROM job WHERE keyjob=assignment.fkeyjob;

	IF _job.packettype = 'preassigned' THEN
		UPDATE JobTask SET status='new' WHERE fkeyjobtaskassignment IN (SELECT keyjobtaskassignment FROM jobtaskassignment WHERE fkeyjobassignment=_keyjobassignment) AND status IN ('assigned','busy');
	ELSE
		UPDATE JobTask SET status='new', fkeyhost=NULL WHERE fkeyjobtaskassignment IN (SELECT keyjobtaskassignment FROM jobtaskassignment WHERE fkeyjobassignment=_keyjobassignment) AND status IN ('assigned','busy');
	END IF;

	UPDATE JobTaskAssignment SET fkeyjobassignmentstatus=cancelledStatusKey WHERE fkeyjobassignment=_keyjobassignment AND fkeyjobassignmentstatus IN (SELECT keyjobassignmentstatus from jobassignmentstatus WHERE status IN ('ready','copy','busy'));

	-- Dont set it to cancelled if it already cancelled or error
	UPDATE JobAssignment SET fkeyjobassignmentstatus=cancelledStatusKey WHERE keyjobassignment=_keyjobassignment AND fkeyjobassignmentstatus IN (SELECT keyjobassignmentstatus from jobassignmentstatus WHERE status IN ('ready','copy','busy'));
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 25 (class 1255 OID 16407)
-- Dependencies: 1054 3
-- Name: cancel_job_assignments(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION cancel_job_assignments(_keyjob integer) RETURNS void
    AS $$
DECLARE
	cancelledStatusKey int;
	_job job;
BEGIN
	SELECT INTO cancelledStatusKey keyjobassignmentstatus FROM jobassignmentstatus WHERE status='cancelled';
	SELECT INTO _job * FROM job WHERE keyjob=_keyjob;
		
	IF _job.packettype = 'preassigned' THEN
		UPDATE JobTask SET status='new' WHERE fkeyjob=_keyjob AND status IN ('assigned','busy');
	ELSE
		UPDATE JobTask SET status='new', fkeyhost=NULL WHERE fkeyjob=_keyjob AND status IN ('assigned','busy');
	END IF;

	UPDATE JobTaskAssignment SET fkeyjobassignmentstatus=cancelledStatusKey WHERE fkeyjobassignment IN(SELECT keyjobassignment FROM JobAssignment WHERE fkeyjob=_keyjob) AND fkeyjobassignmentstatus IN (SELECT keyjobassignmentstatus from jobassignmentstatus WHERE status IN ('ready','copy','busy'));

	UPDATE JobAssignment SET fkeyjobassignmentstatus=cancelledStatusKey WHERE fkeyjob=_keyjob AND fkeyjobassignmentstatus IN (SELECT keyjobassignmentstatus from jobassignmentstatus WHERE status IN ('ready','copy','busy'));
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 26 (class 1255 OID 16408)
-- Dependencies: 3
-- Name: epoch_to_timestamp(double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION epoch_to_timestamp(double precision) RETURNS timestamp without time zone
    AS $_$
SELECT ('epoch'::timestamp + $1 * '1 second'::interval)::timestamp;
$_$
    LANGUAGE sql IMMUTABLE STRICT;


--
-- TOC entry 27 (class 1255 OID 16409)
-- Dependencies: 3 1054
-- Name: get_continuous_tasks(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION get_continuous_tasks(fkeyjob integer, max_tasks integer) RETURNS SETOF integer
    AS $$
DECLARE
	task RECORD;
	start_task int;
	last_task int;
	cont_len int := -1;
	sav_start_task int;
	sav_end_task int;
	sav_cont_len int := 0;
BEGIN
	FOR task IN SELECT count(*) as cnt, jobtask FROM JobTask WHERE JobTask.fkeyjob=fkeyjob AND status='new' GROUP BY jobtask ORDER BY jobtask ASC LOOP
		IF cont_len < 0 OR (last_task != task.jobTask AND last_task + 1 != task.jobTask) THEN
			start_task := task.jobTask;
			last_task := task.jobTask;
			cont_len := 0;
		END IF;
		cont_len := cont_len + task.cnt;
		last_task := task.jobTask;

		-- Save this sequence, if its better than the last(or if it's the first one)
		IF cont_len > sav_cont_len THEN
			sav_start_task := start_task;
			sav_end_task := task.jobTask;
			sav_cont_len := cont_len;
			-- If we already found enough continous frames, then break out of the loop and return them
			IF cont_len >= max_tasks THEN
				EXIT;
			END IF;
		END IF;

		-- If we already found enough continous frames, then break out of the loop and return them
		IF cont_len >= max_tasks THEN
			EXIT;
		END IF;
	END LOOP;

	IF sav_cont_len > 0 THEN
		FOR task IN SELECT * FROM JobTask WHERE JobTask.fkeyjob=fkeyjob AND status='new' AND jobtask >= sav_start_task AND jobtask <= sav_end_task ORDER BY jobtask ASC LOOP
			RETURN NEXT task.keyjobtask;
		END LOOP;
	END IF;

	RETURN;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 28 (class 1255 OID 16410)
-- Dependencies: 1054 3
-- Name: get_wayward_hosts(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION get_wayward_hosts() RETURNS SETOF integer
    AS $$
DECLARE
	hs hoststatus;
BEGIN
	FOR hs IN SELECT * FROM HostStatus WHERE slavestatus IS NOT NULL AND slavestatus NOT IN ('offline','restart','sleeping','waking','no-ping','stopping') AND now() - slavepulse > '10 minutes'::interval LOOP
		RETURN NEXT hs.fkeyhost;
	END LOOP;

	FOR hs in SELECT * FROM HostStatus WHERE slavestatus='assigned' AND now() - laststatuschange > '5 minutes'::interval LOOP
		RETURN NEXT hs.fkeyhost;
	END LOOP;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 29 (class 1255 OID 16411)
-- Dependencies: 3 1054 348
-- Name: get_wayward_hosts_2(interval, interval); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION get_wayward_hosts_2(pulse_period interval, loop_time interval) RETURNS SETOF waywardhostret
    AS $$
DECLARE
	hs hoststatus;
	ret WaywardHostRet;
BEGIN
	-- Give a host 15 minutes to wake up
	FOR hs IN SELECT * FROM HostStatus WHERE slavestatus='waking' AND now() - laststatuschange > '15 minutes'::interval LOOP
		ret := ROW(hs.fkeyhost,1);
		RETURN NEXT ret;
	END LOOP;

	-- 5 minutes to go offline from stopping or restart
	FOR hs IN SELECT * FROM HostStatus WHERE slavestatus IN ('stopping','starting','restart','reboot','client-update','assigned') AND now() - laststatuschange > '5 minutes'::interval LOOP
		ret := ROW(hs.fkeyhost,1);
		RETURN NEXT ret;
	END LOOP;

	FOR hs IN SELECT * FROM HostStatus WHERE slavestatus IS NOT NULL AND slavestatus IN ('ready','copy','busy','offline') AND (slavepulse IS NULL OR (now() - slavepulse) > (pulse_period + loop_time)) LOOP
		ret := ROW(hs.fkeyhost,2);
		RETURN NEXT ret;
	END LOOP;
END;
$$
    LANGUAGE plpgsql;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 2232 (class 1259 OID 16412)
-- Dependencies: 3
-- Name: countercache; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE countercache (
    hoststotal integer,
    hostsactive integer,
    hostsready integer,
    jobstotal integer,
    jobsactive integer,
    jobsdone integer,
    lastupdated timestamp without time zone
);


--
-- TOC entry 30 (class 1255 OID 16415)
-- Dependencies: 1054 350 3
-- Name: getcounterstate(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getcounterstate() RETURNS countercache
    AS $$
	DECLARE
		cache countercache;
	BEGIN
		SELECT INTO cache * FROM countercache LIMIT 1;
		IF NOT FOUND THEN
			INSERT INTO countercache (hoststotal) values (null);
			cache.lastUpdated := now() - interval'1 year';
		END IF;
		IF now() - cache.lastUpdated > interval'10 seconds' THEN
			DECLARE
				hosts_total int;
				hosts_active int;
				hosts_ready int;
				jobs_total int;
				jobs_active int;
				jobs_done int;
			BEGIN
				SELECT count(*) INTO hosts_total FROM HostService INNER JOIN HostStatus ON HostStatus.fkeyHost=HostService.fkeyHost WHERE fkeyService=23 AND online=1;
				SELECT count(fkeyHost) INTO hosts_active FROM HostStatus WHERE slaveStatus IN('busy','copy', 'assigned') AND online=1;
				SELECT count(fkeyHost) INTO hosts_ready FROM HostStatus WHERE slaveStatus='ready';
				SELECT count(keyJob) INTO jobs_total FROM Job WHERE status IN('submit','verify','holding','ready', 'busy', 'started','suspended','done');
				SELECT count(keyJob) INTO jobs_active FROM Job WHERE status IN ('ready', 'started');
				SELECT count(keyJob) INTO jobs_done FROM Job WHERE status='done';
				UPDATE CounterCache SET hoststotal=hosts_total, hostsactive=hosts_active, hostsReady=hosts_ready,
					jobsTotal=jobs_total, jobsActive=jobs_active, jobsDone=jobs_done, lastUpdated=now();
				SELECT INTO cache * FROM countercache LIMIT 1;
			END;
		END IF;
		RETURN cache;
	END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 2233 (class 1259 OID 16416)
-- Dependencies: 3
-- Name: hosthistory_keyhosthistory_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hosthistory_keyhosthistory_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4304 (class 0 OID 0)
-- Dependencies: 2233
-- Name: hosthistory_keyhosthistory_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('hosthistory_keyhosthistory_seq', 41699853, true);


--
-- TOC entry 2234 (class 1259 OID 16418)
-- Dependencies: 2841 3
-- Name: hosthistory; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE hosthistory (
    keyhosthistory integer DEFAULT nextval('hosthistory_keyhosthistory_seq'::regclass) NOT NULL,
    fkeyhost integer,
    fkeyjob integer,
    fkeyjobstat integer,
    status text,
    laststatus text,
    datetime timestamp without time zone,
    duration interval,
    fkeyjobtask integer,
    fkeyjobtype integer,
    nextstatus text,
    success boolean,
    fkeyjoberror integer,
    change_from_ip inet,
    fkeyjobcommandhistory integer
);


--
-- TOC entry 31 (class 1255 OID 16425)
-- Dependencies: 3 1054 353
-- Name: hosthistory_dynamic_query(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION hosthistory_dynamic_query(where_stmt text, order_limit text) RETURNS SETOF hosthistory
    AS $$
DECLARE
	rec hosthistory;
	query text;
	where_gen text;
BEGIN
	query := 'SELECT * FROM hosthistory ';
	where_gen := where_stmt;
	IF char_length(where_stmt) > 0 THEN
		IF position('where' in lower(where_stmt)) = 0 THEN
			where_gen := 'WHERE ' || where_gen;
		END IF;
		query := query || where_gen;
	END IF;
	IF char_length(order_limit) > 0 THEN
		query := ' ' || order_limit;
	END IF;
	FOR rec IN EXECUTE query LOOP
		RETURN NEXT rec;
	END LOOP;
	RETURN;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 32 (class 1255 OID 16426)
-- Dependencies: 3 1054 353
-- Name: hosthistory_overlaps_timespan(timestamp without time zone, timestamp without time zone, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION hosthistory_overlaps_timespan(time_start timestamp without time zone, time_end timestamp without time zone, where_stmt text, order_limit text) RETURNS SETOF hosthistory
    AS $$
DECLARE
	rec hosthistory;
	where_gen text;
BEGIN
	where_gen := '((	(datetime > ' || quote_literal(time_start) || ')
			AND	(datetime < ' || quote_literal(time_end) || '))
			OR
			-- Ends inside the timespan
			(	(datetime + duration < ' || quote_literal(time_end) || ')
			AND (datetime + duration > ' || quote_literal(time_start) || '))
			OR
			-- Covors the entire timespan
			(	(datetime < ' || quote_literal(time_start) || ')
			AND (
					(datetime + duration > ' || quote_literal(time_end) || ')
				OR 	(duration IS NULL) )
			))';
	IF char_length(where_stmt) > 0 THEN
		where_gen := where_gen || ' AND (' || where_stmt || ')';
	END IF;

	FOR rec IN SELECT * FROM hosthistory_dynamic_query( where_gen, order_limit ) LOOP
		RETURN NEXT rec;
	END LOOP;
	RETURN;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 33 (class 1255 OID 16427)
-- Dependencies: 3 1054 303
-- Name: hosthistory_status_percentages(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION hosthistory_status_percentages(query_input text) RETURNS SETOF hosthistory_status_percentages_return
    AS $$
DECLARE
	rec hosthistory_status_summary_return;
	ret hosthistory_status_percentages_return;
	total_time interval := '0 minutes';
	non_idle_time interval := '0 minutes';
	non_idle_non_wasted_time interval := '0 minutes';
BEGIN
	FOR rec IN SELECT * FROM hosthistory_status_summary( query_input ) LOOP
		IF rec.total_time IS NOT NULL THEN
			total_time := total_time + rec.total_time;
			IF rec.status IN ('busy','copy','assigned') THEN
				non_idle_time := non_idle_time + rec.total_time;
				IF rec.wasted=false THEN
					non_idle_non_wasted_time := non_idle_non_wasted_time + rec.total_time;
				END IF;
			END IF;
		END IF;
	END LOOP;
	-- Can I keep the values from the first select and loop through them twice, seems i should be able to...
	FOR rec IN SELECT * FROM hosthistory_status_summary( query_input ) LOOP
		ret.status := rec.status;
		ret.loading := rec.loading;
		ret.wasted := rec.wasted;
		ret.total_time := rec.total_time;
		ret.total_perc := rec.total_time / total_time;
		ret.non_idle_non_wasted_perc := NULL;
		ret.non_idle_perc := NULL;
		IF rec.status IN ('busy','copy','assigned') THEN
			ret.non_idle_perc := rec.total_time / non_idle_time;
			IF rec.wasted=false THEN
				ret.non_idle_non_wasted_perc := rec.total_time / non_idle_non_wasted_time;
			END IF;
		END IF;
		RETURN NEXT ret;
	END LOOP;
	RETURN;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 34 (class 1255 OID 16428)
-- Dependencies: 3 1054 303
-- Name: hosthistory_status_percentages_duration_adjusted(timestamp without time zone, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION hosthistory_status_percentages_duration_adjusted(history_start timestamp without time zone, history_end timestamp without time zone) RETURNS SETOF hosthistory_status_percentages_return
    AS $$
DECLARE
	rec hosthistory_status_percentages_return;
BEGIN
	FOR rec IN SELECT * FROM hosthistory_status_percentages( 
		'hosthistory_timespan_duration_adjusted( ' || quote_literal(history_start) || ', ' || quote_literal(history_end) || ','''','''')' ) LOOP
		RETURN NEXT rec;
	END LOOP;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 35 (class 1255 OID 16429)
-- Dependencies: 1054 3 305
-- Name: hosthistory_status_summary(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION hosthistory_status_summary(query_input text) RETURNS SETOF hosthistory_status_summary_return
    AS $$
DECLARE
 rec hosthistory_status_summary_return;
 query text;
BEGIN
	query := 'SELECT 
		status,
		(fkeyjobtask is null and status=''busy'') as loading,
		status=''busy'' AND ((fkeyjobtask is null AND nextstatus=''ready'' AND nextstatus IS NOT NULL) OR (fkeyjobtask IS NOT null AND success is null)) as error,
		count(*),
		sum(duration),
		avg(duration),
		max(duration),
		min(duration)
		FROM ' || query_input || 
		' GROUP BY status, loading, error
		ORDER BY status';

	FOR rec IN EXECUTE query LOOP
		RETURN NEXT rec;
	END LOOP;
	RETURN;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 36 (class 1255 OID 16430)
-- Dependencies: 3 305 1054
-- Name: hosthistory_status_summary_duration_adjusted(timestamp without time zone, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION hosthistory_status_summary_duration_adjusted(history_start timestamp without time zone, history_end timestamp without time zone) RETURNS SETOF hosthistory_status_summary_return
    AS $$
DECLARE
	rec hosthistory_status_summary_return;
BEGIN
	FOR rec IN SELECT * FROM hosthistory_status_summary( 
		'hosthistory_timespan_duration_adjusted( ' || quote_literal(history_start) || ', ' || quote_literal(history_end) || ','''','''')' ) LOOP
		RETURN NEXT rec;
	END LOOP;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 37 (class 1255 OID 16431)
-- Dependencies: 1054 3 353
-- Name: hosthistory_timespan_duration_adjusted(timestamp without time zone, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION hosthistory_timespan_duration_adjusted(time_start timestamp without time zone, time_end timestamp without time zone) RETURNS SETOF hosthistory
    AS $$
DECLARE
	rec hosthistory;
	dur interval;
BEGIN
	FOR rec IN SELECT
		*
		FROM HostHistory
		WHERE
			-- Starts inside the timespan
			(	(datetime > time_start)
			AND	(datetime < time_end))
			OR
			-- Ends inside the timespan
			(	(datetime + duration < time_end)
			AND (datetime + duration > time_start))
			OR
			-- Covors the entire timespan
			(	(datetime < time_start)
			AND (
					(datetime + duration > time_end)
				OR 	(duration IS NULL) )
			)
		LOOP
			dur := rec.duration;

			-- Account for hosthistory records that havent finished
			IF dur IS NULL THEN
				dur := now() - rec.datetime;
			END IF;

			-- Cut off front
			IF rec.datetime < time_start THEN
				dur := dur - (time_start - rec.datetime);
			END IF;
			
			-- Cut off the end
			IF rec.datetime + rec.duration > time_end THEN
				dur := dur - ((rec.datetime + rec.duration) - rec.datetime);
			END IF;

			rec.duration := dur;

			RETURN NEXT rec;
		END LOOP;
	RETURN;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 38 (class 1255 OID 16432)
-- Dependencies: 3 353 1054
-- Name: hosthistory_timespan_duration_adjusted(timestamp without time zone, timestamp without time zone, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION hosthistory_timespan_duration_adjusted(time_start timestamp without time zone, time_end timestamp without time zone, where_stmt text, order_limit text) RETURNS SETOF hosthistory
    AS $$
DECLARE
	rec hosthistory;
	dur interval;
	end_ts timestamp;
BEGIN
	FOR rec IN SELECT * FROM hosthistory_overlaps_timespan( time_start, time_end, where_stmt, order_limit ) LOOP
			dur := rec.duration;
			-- Account for hosthistory records that havent finished
			IF dur IS NULL THEN
				dur := now() - rec.datetime;
			END IF;

			end_ts := rec.datetime + dur;
			-- Cut off front
			IF rec.datetime < time_start THEN
				dur := dur - (time_start - rec.datetime);
			END IF;
			
			-- Cut off the end
			IF end_ts > time_end THEN
				dur := dur - (end_ts - time_end);
			END IF;

			rec.duration := justify_hours(dur);

			RETURN NEXT rec;
		END LOOP;
	RETURN;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 39 (class 1255 OID 16433)
-- Dependencies: 3 344 1054
-- Name: hosthistory_user_slave_summary(timestamp without time zone, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION hosthistory_user_slave_summary(history_start timestamp without time zone, history_end timestamp without time zone) RETURNS SETOF hosthistory_user_slave_summary_return
    AS $$
DECLARE
	ret hosthistory_user_slave_summary_return;
BEGIN
	FOR ret IN
		SELECT
			usr.name,
			host.host,
			(extract(epoch from sum) / 3600)::numeric(8,2) as totalHours
			FROM
				(SELECT
					sum(duration),
					fkeyhost
				FROM
					hosthistory_timespan_duration_adjusted(history_start,history_end, '', '') as hosthistory
				WHERE
					hosthistory.status in ('ready','busy','copy','assigned')
				GROUP BY fkeyhost)
			AS 	iq,
				host,
				usr
			WHERE
				host.keyhost=iq.fkeyhost
			AND usr.fkeyhost=host.keyhost
			ORDER BY sum desc
	LOOP
		RETURN NEXT ret;
	END LOOP;
	RETURN;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 40 (class 1255 OID 16434)
-- Dependencies: 1054 3
-- Name: hoststatus_update(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION hoststatus_update() RETURNS trigger
    AS $$
BEGIN
	IF (NEW.slavestatus IS NOT NULL)
	AND (NEW.slavestatus != OLD.slavestatus) THEN
		NEW.lastStatusChange = NOW();
	END IF;

	IF (NEW.slavestatus IS NOT NULL)
	AND (NEW.slavestatus != OLD.slavestatus) THEN
		UPDATE hosthistory SET duration = now() - datetime, nextstatus=NEW.slavestatus WHERE duration is null and fkeyhost=NEW.fkeyhost;
		INSERT INTO hosthistory (datetime,fkeyhost,status,laststatus, change_from_ip) VALUES (now(),NEW.fkeyhost,NEW.slavestatus,OLD.slavestatus,inet_client_addr());
	END IF;
	
	RETURN NEW;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 41 (class 1255 OID 16435)
-- Dependencies: 3 1054
-- Name: increment_loadavgadjust(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION increment_loadavgadjust(_fkeyhost integer) RETURNS void
    AS $$
DECLARE
	loadavgadjust_inc float;
BEGIN
	SELECT INTO loadavgadjust_inc value::float FROM config WHERE config='assburnerLoadAvgAdjustInc';
	UPDATE HostLoad SET loadavgadjust=loadavgadjust_inc+loadavgadjust WHERE fkeyhost=_fkeyhost;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 42 (class 1255 OID 16436)
-- Dependencies: 1054 3
-- Name: insert_jobtask(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION insert_jobtask() RETURNS trigger
    AS $$
BEGIN
UPDATE JobStatus SET tasksCount = tasksCount + 1, tasksUnassigned = tasksUnassigned + 1 WHERE fkeyJob = NEW.fkeyjob;
RETURN NEW;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 43 (class 1255 OID 16437)
-- Dependencies: 1054 3
-- Name: interval_divide(interval, interval); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION interval_divide(numerator interval, denominator interval) RETURNS double precision
    AS $$
BEGIN
	RETURN extract(epoch from numerator) / extract(epoch from denominator)::float;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 44 (class 1255 OID 16438)
-- Dependencies: 1054 3
-- Name: job_error_increment(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION job_error_increment() RETURNS trigger
    AS $$
BEGIN
	IF (NEW.cleared IS NULL OR NEW.cleared=false) AND (NEW.count > coalesce(OLD.count,0)) THEN
		UPDATE jobstatus SET errorcount=errorcount+1 where fkeyjob=NEW.fkeyjob;
	END IF;

	IF (NEW.cleared = true) AND (coalesce(OLD.cleared,false)=false) THEN
		UPDATE jobstatus SET errorcount=errorcount-NEW.count WHERE fkeyjob=NEW.fkeyjob;
	END IF;
	RETURN NEW;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 45 (class 1255 OID 16439)
-- Dependencies: 1054 3
-- Name: job_error_insert(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION job_error_insert() RETURNS trigger
    AS $$
BEGIN
	UPDATE jobstatus SET errorcount=errorcount+1 WHERE fkeyjob=NEW.fkeyjob;
	RETURN NEW;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 46 (class 1255 OID 16440)
-- Dependencies: 1054 346 3
-- Name: job_gatherstats(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION job_gatherstats(_keyjob integer) RETURNS job_gatherstats_result
    AS $$
DECLARE
        ret Job_GatherStats_Result;
BEGIN
        SELECT INTO ret.mintasktime, ret.avgtasktime, ret.maxtasktime, ret.totaltasktime, ret.taskcount
                                min(ja.ended-ja.started) as minloadtime,
                                avg(ja.ended-ja.started) as avgloadtime,
                                max(ja.ended-ja.started) as maxloadtime,
                                sum(ja.ended-ja.started) as totalloadtime,
                                count(*) as loadcount
                        FROM jobtaskassignment jta
                        JOIN jobassignmentstatus jas ON jas.keyjobassignmentstatus=jta.fkeyjobassignmentstatus
                        JOIN jobassignment ja ON ja.keyjobassignment=jta.fkeyjobassignment
                        WHERE
                                ja.fkeyjob=_keyjob
                                AND jas.status='done'
                        GROUP BY jas.status;
        -- Load Times
        SELECT INTO ret.minloadtime, ret.avgloadtime, ret.maxloadtime, ret.totalloadtime, ret.loadcount
                                min(ja.ended-ja.started) as minloadtime,
                                avg(ja.ended-ja.started) as avgloadtime,
                                max(ja.ended-ja.started) as maxloadtime,
                                sum(ja.ended-ja.started) as totalloadtime,
                                count(*) as loadcount
                        FROM jobtaskassignment jta
                        JOIN jobassignmentstatus jas ON jas.keyjobassignmentstatus=jta.fkeyjobassignmentstatus
                        JOIN jobassignment ja ON ja.keyjobassignment=jta.fkeyjobassignment
                        WHERE
                                ja.fkeyjob=_keyjob
                                AND jas.status='copy'
                        GROUP BY jas.status;
        -- Error Times
        SELECT INTO ret.minerrortime, ret.avgerrortime, ret.maxerrortime, ret.totalerrortime, ret.errorcount
                                min(ja.ended-ja.started) as minloadtime,
                                avg(ja.ended-ja.started) as avgloadtime,
                                max(ja.ended-ja.started) as maxloadtime,
                                sum(ja.ended-ja.started) as totalloadtime,
                                count(*) as loadcount
                        FROM jobtaskassignment jta
                        JOIN jobassignmentstatus jas ON jas.keyjobassignmentstatus=jta.fkeyjobassignmentstatus
                        JOIN jobassignment ja ON ja.keyjobassignment=jta.fkeyjobassignment
                        WHERE
                                ja.fkeyjob=_keyjob
                                AND jas.status='error'
                        GROUP BY jas.status;
        SELECT INTO ret.mincopytime, ret.avgcopytime, ret.maxcopytime, ret.totalcopytime, ret.copycount
                                min(ja.ended-ja.started) as minloadtime,
                                avg(ja.ended-ja.started) as avgloadtime,
                                max(ja.ended-ja.started) as maxloadtime,
                                sum(ja.ended-ja.started) as totalloadtime,
                                count(*) as loadcount
                        FROM jobtaskassignment jta
                        JOIN jobassignmentstatus jas ON jas.keyjobassignmentstatus=jta.fkeyjobassignmentstatus
                        JOIN jobassignment ja ON ja.keyjobassignment=jta.fkeyjobassignment
                        WHERE
                                ja.fkeyjob=_keyjob
                                AND jas.status='copy'
                        GROUP BY jas.status;
        ret.totaltime := '0 minutes'::interval;
        IF ret.totaltasktime IS NOT NULL THEN
                ret.totaltime := ret.totaltime + ret.totaltasktime;
        END IF;
        IF ret.totalloadtime IS NOT NULL THEN
                ret.totaltime := ret.totaltime + ret.totalloadtime;
        END IF;
        IF ret.totalerrortime IS NOT NULL THEN
                ret.totaltime := ret.totaltime + ret.totalerrortime;
        END IF;
        RETURN ret;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 47 (class 1255 OID 16441)
-- Dependencies: 1054 3
-- Name: job_insert(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION job_insert() RETURNS trigger
    AS $$
BEGIN
	INSERT INTO jobstat (name,fkeyelement,fkeyproject,fkeyusr) VALUES (NEW.job, NEW.fkeyelement, NEW.fkeyproject, NEW.fkeyusr) RETURNING keyjobstat INTO NEW.fkeyjobstat;
	INSERT INTO jobstatus (fkeyjob) VALUES (NEW.keyjob);
RETURN NEW;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 48 (class 1255 OID 16442)
-- Dependencies: 1054 3
-- Name: job_update(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION job_update() RETURNS trigger
    AS $$
DECLARE
	stat RECORD;
BEGIN
	-- Set Job.taskscount and Job.tasksunassigned
	IF NEW.status IN ('verify','verify-suspended') THEN
		PERFORM update_job_task_counts(NEW.keyjob);
	END IF;

	IF (NEW.fkeyjobstat IS NOT NULL) THEN
		IF (NEW.status='started' AND OLD.status='ready') THEN
			UPDATE jobstat SET started=NOW() WHERE keyjobstat=NEW.fkeyjobstat AND started IS NULL;
		END IF;
		IF (NEW.status='ready' AND OLD.status='done') THEN
			SELECT INTO stat * from jobstat where keyjobstat=NEW.fkeyjobstat;
			INSERT INTO jobstat (fkeyelement, fkeyproject, taskCount, fkeyusr, started, pass) VALUES (stat.fkeyelement, stat.fkeyproject, stat.taskCount, stat.fkeyusr, NOW(), stat.pass);
			SELECT INTO NEW.fkeyjobstat currval('jobstat_keyjobstat_seq');
		END IF;
		IF (NEW.status IN ('done','deleted') AND OLD.status IN ('ready','started') ) THEN
			UPDATE jobstat
			SET
				ended=NOW(),
				errorcount=iq.errorcount,
				totaltasktime=iq.totaltasktime, mintasktime=iq.mintasktime, maxtasktime=iq.maxtasktime, avgtasktime=iq.avgtasktime,
				totalloadtime=iq.totalloadtime, minloadtime=iq.minloadtime, maxloadtime=iq.maxloadtime, avgloadtime=iq.avgloadtime,
				totalerrortime=iq.totalerrortime, minerrortime=iq.minerrortime, maxerrortime=iq.maxerrortime, avgerrortime=iq.avgerrortime,
				totalcopytime=iq.totalcopytime, mincopytime=iq.mincopytime, maxcopytime=iq.maxcopytime, avgcopytime=iq.avgcopytime
			FROM (select * FROM Job_GatherStats(NEW.keyjob)) as iq
			WHERE keyjobstat=NEW.fkeyjobstat;
			UPDATE jobstat
			SET
				taskcount=iq.taskscount,
				taskscompleted=iq.tasksdone
			FROM (select jobstatus.taskscount, jobstatus.tasksdone FROM jobstatus WHERE jobstatus.fkeyjob=NEW.keyjob) as iq
			WHERE keyjobstat=NEW.fkeyjobstat;
		END IF;
	END IF;

	RETURN NEW;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 49 (class 1255 OID 16443)
-- Dependencies: 1054 3
-- Name: jobassignment_delete(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION jobassignment_delete() RETURNS trigger
    AS $$
DECLARE
	oldstatusval int := 0;
BEGIN
	oldstatusval := assignment_status_count(OLD.fkeyjobassignmentstatus);
	IF oldstatusval > 0 THEN
		PERFORM updateJobLicenseCounts( OLD.fkeyjob, -1 );
	END IF;
	IF oldstatusval > 0 THEN
		UPDATE HostStatus SET activeAssignmentCount=coalesce(activeAssignmentCount,0)-oldstatusval, lastAssignmentChange=NOW() WHERE HostStatus.fkeyhost=OLD.fkeyhost;
	END IF;
	RETURN OLD;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 50 (class 1255 OID 16444)
-- Dependencies: 1054 3
-- Name: jobassignment_insert(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION jobassignment_insert() RETURNS trigger
    AS $$
DECLARE
	newstatusval int := 0;
BEGIN
	newstatusval := assignment_status_count(NEW.fkeyjobassignmentstatus);
	IF newstatusval > 0 THEN
		UPDATE HostStatus SET activeassignmentCount=coalesce(activeassignmentCount,0)+newstatusval,lastAssignmentChange=NOW() WHERE HostStatus.fkeyhost=NEW.fkeyhost;
	END IF;
	-- If we are starting at 'new','ready', or 'busy', we need to update license counts for the services
	IF newstatusval > 0 THEN
		PERFORM updateJobLicenseCounts( NEW.fkeyjob, 1 );
	END IF;
	RETURN NEW;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 51 (class 1255 OID 16445)
-- Dependencies: 1054 3
-- Name: jobassignment_update(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION jobassignment_update() RETURNS trigger
    AS $$
DECLARE
	currentjob job;
	oldstatusval int := 0;
	newstatusval int := 0;
	assignmentcountchange int :=0;
BEGIN
	IF NEW.fkeyhost != OLD.fkeyhost THEN
		-- TODO: Raise some kind of error
		RAISE NOTICE 'JobAssignment.fkeyhost is immutable';
	END IF;

	oldstatusval := assignment_status_count(OLD.fkeyjobassignmentstatus);
	newstatusval := assignment_status_count(NEW.fkeyjobassignmentstatus);

	-- Update license count if status is changing from one that requires a license to one that doesnt
	IF oldstatusval > newstatusval THEN
		PERFORM updateJobLicenseCounts( NEW.fkeyjob, -1 );
		IF NEW.started IS NOT NULL THEN
			NEW.ended := NOW();
		END IF;
	END IF;
	IF newstatusval > oldstatusval THEN
		PERFORM updateJobLicenseCounts( NEW.fkeyjob, 1 );
	END IF;

	-- Update the number of active assignments for the hsot
	IF newstatusval != oldstatusval THEN
		UPDATE HostStatus SET activeAssignmentCount=coalesce(activeAssignmentCount,0)+(newstatusval-oldstatusval), lastAssignmentChange=NOW() WHERE HostStatus.fkeyhost=NEW.fkeyhost;
	END IF;
	RETURN NEW;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 52 (class 1255 OID 16446)
-- Dependencies: 3 1054
-- Name: joberror_inc(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION joberror_inc() RETURNS trigger
    AS $$
DECLARE
	j RECORD;
BEGIN
	SELECT INTO j * FROM job WHERE keyjob=NEW.fkeyjob;
	IF (j.fkeyjobstat IS NOT NULL) THEN
		UPDATE jobstat SET errorcount=errorcount+1 WHERE keyjobstat=j.fkeyjobstat;
	END IF;
	RETURN NULL;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 53 (class 1255 OID 16447)
-- Dependencies: 1054 3
-- Name: jobtaskassignment_update(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION jobtaskassignment_update() RETURNS trigger
    AS $$
DECLARE
	cancelledStatusKey int;
	busyStatusKey int;
BEGIN
	SELECT INTO cancelledStatusKey keyjobassignmentstatus FROM jobassignmentstatus WHERE status='cancelled';
	SELECT INTO busyStatusKey keyjobassignmentstatus FROM jobassignmentstatus WHERE status='busy';
	IF NEW.fkeyjobassignmentstatus = cancelledStatusKey AND OLD.fkeyjobassignmentstatus = busyStatusKey THEN
		UPDATE JobAssignment SET fkeyjobassignmentstatus=cancelledStatusKey WHERE keyjobassignment=NEW.fkeyjobassignment;
	END IF;
	RETURN NEW;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 55 (class 1255 OID 16448)
-- Dependencies: 3 1054
-- Name: return_slave_tasks(integer, boolean, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION return_slave_tasks(_keyhost integer, commithoststatus boolean, preassigned boolean) RETURNS void
    AS $$
BEGIN
	IF commitHostStatus THEN
		UPDATE hoststatus SET slaveframes='', fkeyjob=NULL WHERE fkeyhost=_keyhost;
	END IF;
	IF preassigned THEN
		UPDATE jobtask SET status = 'new', started=NULL, memory=NULL, fkeyjobcommandhistory=NULL WHERE fkeyhost=_keyhost AND status IN ('assigned','busy');
	ELSE
		UPDATE jobtask SET status = 'new', fkeyhost=NULL, started=NULL, memory=NULL, fkeyjobcommandhistory=NULL WHERE fkeyhost=_keyhost AND status IN ('assigned','busy');
	END IF;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 56 (class 1255 OID 16449)
-- Dependencies: 3 1054
-- Name: return_slave_tasks_2(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION return_slave_tasks_2(_keyhost integer) RETURNS void
    AS $$
DECLARE
	j job;
BEGIN
	FOR j IN SELECT * from Job WHERE keyjob IN (SELECT fkeyjob FROM JobTask WHERE fkeyhost=_keyhost AND status IN ('assigned','busy')) LOOP
		IF j.packettype = 'preassigned' THEN
			UPDATE jobtask SET status = 'new' WHERE fkeyhost=_keyhost AND fkeyjob=j.keyjob AND status IN ('assigned','busy');
		ELSE
			UPDATE jobtask SET status = 'new', fkeyhost=NULL WHERE fkeyhost=_keyhost AND fkeyjob=j.keyjob AND status IN ('assigned','busy');
		END IF;
	END LOOP;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 57 (class 1255 OID 16450)
-- Dependencies: 1054 3
-- Name: return_slave_tasks_3(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION return_slave_tasks_3(_keyhost integer) RETURNS void
    AS $$
DECLARE
	ja jobassignment;
	cancelledStatusKey int;
BEGIN
	PERFORM return_slave_tasks_2(_keyhost);
	
	SELECT INTO cancelledStatusKey keyjobassignmentstatus FROM jobassignmentstatus WHERE status='cancelled';
	UPDATE JobAssignment SET fkeyjobassignmentstatus=cancelledStatusKey WHERE fkeyhost=_keyhost AND fkeyjobassignmentstatus IN (SELECT keyjobassignmentstatus FROM jobassignmentstatus WHERE status IN ('ready','copy','busy'));
	UPDATE JobTaskAssignment SET fkeyjobassignmentstatus=cancelledStatusKey WHERE fkeyjobassignment IN (SELECT keyjobassignment FROM jobassignment WHERE fkeyhost=_keyhost) AND fkeyjobassignmentstatus IN (SELECT keyjobassignmentstatus FROM jobassignmentstatus WHERE status IN ('ready','copy','busy'));
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 58 (class 1255 OID 16451)
-- Dependencies: 3 1054
-- Name: sync_host_to_hoststatus(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION sync_host_to_hoststatus() RETURNS void
    AS $$
DECLARE
BEGIN
	DELETE FROM HostStatus WHERE fkeyhost NOT IN (SELECT keyhost FROM Host);
	INSERT INTO HostStatus (fkeyhost) SELECT keyhost FROM Host WHERE keyhost NOT IN (SELECT fkeyhost FROM HostStatus WHERE fkeyhost IS NOT NULL);
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 59 (class 1255 OID 16452)
-- Dependencies: 3 1054
-- Name: sync_host_to_hoststatus_trigger(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION sync_host_to_hoststatus_trigger() RETURNS trigger
    AS $$
BEGIN
	PERFORM sync_host_to_hoststatus();
	RETURN NEW;
END
$$
    LANGUAGE plpgsql;


--
-- TOC entry 60 (class 1255 OID 16453)
-- Dependencies: 3 1054
-- Name: update_host(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_host() RETURNS trigger
    AS $$
DECLARE
currentjob job;
BEGIN
IF (NEW.slavestatus IS NOT NULL)
 AND (NEW.slavestatus != OLD.slavestatus) THEN
	NEW.lastStatusChange = NOW();
	IF (NEW.slavestatus != 'busy') THEN
		NEW.fkeyjobtask = NULL;
	END IF;
END IF;

-- Increment Job.hostsOnJob
--IF (NEW.fkeyjob IS NOT NULL AND (NEW.fkeyjob != OLD.fkeyjob OR OLD.fkeyjob IS NULL) ) THEN
--	UPDATE Job SET hostsOnJob=hostsOnJob+1 WHERE keyjob=NEW.fkeyjob;
--END IF;

-- Decrement Job.hostsOnJob
--IF (OLD.fkeyjob IS NOT NULL AND (OLD.fkeyjob != NEW.fkeyjob OR NEW.fkeyjob IS NULL) ) THEN
--	UPDATE Job SET hostsOnJob=hostsOnJob-1 WHERE keyjob=OLD.fkeyjob;
--END IF;

IF (NEW.slavestatus IS NOT NULL)
 AND ((NEW.slavestatus != OLD.slavestatus) OR (NEW.fkeyjobtask != OLD.fkeyjobtask) OR ((OLD.fkeyjobtask IS NULL) != (NEW.fkeyjobtask IS NULL))) THEN
	SELECT INTO currentjob * from job where keyjob=NEW.fkeyjob;
	UPDATE hosthistory SET duration = now() - datetime, nextstatus=NEW.slavestatus WHERE duration is null and fkeyhost=NEW.keyhost;
	INSERT INTO hosthistory (datetime,fkeyhost,fkeyjob,fkeyjobstat,status,laststatus,fkeyjobtype,fkeyjobtask) values (now(),NEW.keyhost,NEW.fkeyjob,currentjob.fkeyjobstat,NEW.slavestatus,OLD.slavestatus,currentjob.fkeyjobtype,NEW.fkeyjobtask);
END IF;
RETURN NEW;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 61 (class 1255 OID 16454)
-- Dependencies: 3 1054
-- Name: update_hostload(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_hostload() RETURNS trigger
    AS $$
DECLARE
	seconds float;
BEGIN
	IF NEW.loadavg != OLD.loadavg THEN
		IF OLD.loadavgadjusttimestamp IS NULL THEN
			seconds := 1;
		ELSE
			seconds := extract(epoch FROM (NOW() - OLD.loadavgadjusttimestamp)::interval);
		END IF;
		IF seconds > 0 THEN
			-- 20 Second Half-Life
			NEW.loadavgadjust = OLD.loadavgadjust / ( 1.0 + (seconds * .05) );
			IF NEW.loadavgadjust < .01 THEN
				NEW.loadavgadjust = 0.0;
			END IF;
			NEW.loadavgadjusttimestamp = NOW();
		END IF; 

		-- Remove this once all the clients are updated
		UPDATE Host SET loadavg=NEW.loadavg + NEW.loadavgadjust WHERE keyhost=NEW.fkeyhost;

	END IF;
	RETURN NEW;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 62 (class 1255 OID 16455)
-- Dependencies: 3 1054
-- Name: update_hostservice(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_hostservice() RETURNS trigger
    AS $$
DECLARE
BEGIN
IF (NEW.pulse != OLD.pulse) OR (NEW.pulse IS NOT NULL AND OLD.pulse IS NULL) THEN
	UPDATE HostStatus Set slavepulse=NEW.pulse WHERE HostStatus.fkeyhost=NEW.fkeyhost;
END IF;
RETURN NEW;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 63 (class 1255 OID 16456)
-- Dependencies: 1054 3
-- Name: update_job_health(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_job_health() RETURNS void
    AS $$
DECLARE
	j job;
BEGIN
	FOR j IN SELECT * FROM job WHERE status='started' ORDER BY keyjob ASC LOOP
		PERFORM update_single_job_health( j );
	END LOOP;
	RETURN;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 64 (class 1255 OID 16457)
-- Dependencies: 1054 3
-- Name: update_job_health_by_key(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_job_health_by_key(jobkey integer) RETURNS void
    AS $$
DECLARE
	j job;
BEGIN
	SELECT INTO j * FROM job WHERE keyjob=jobkey;
	PERFORM update_single_job_health( j );
	RETURN;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 65 (class 1255 OID 16458)
-- Dependencies: 1054 3
-- Name: update_job_tallies(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_job_tallies() RETURNS trigger
    AS $$
DECLARE
        cur RECORD;
BEGIN
        BEGIN
                FOR cur IN SELECT * FROM job_tally_dirty LOOP
                        PERFORM update_job_task_counts( cur.fkeyjob );
                END LOOP;
                DELETE FROM job_tally_dirty;
        EXCEPTION
                WHEN undefined_table THEN
                        -- Do nothing
        END;
RETURN NEW;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 66 (class 1255 OID 16459)
-- Dependencies: 1054 3
-- Name: update_job_task_counts(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_job_task_counts(_keyjob integer) RETURNS void
    AS $$
DECLARE
	cur RECORD;
	unassigned integer := 0;
	busy integer := 0;
	assigned integer := 0;
	done integer := 0;
	cancelled integer := 0;
	suspended integer := 0;
BEGIN
	FOR cur IN 
		SELECT status, count(*) as c FROM jobtask WHERE fkeyjob=_keyjob
		GROUP BY status
	LOOP
		IF( cur.status = 'new' ) THEN
			unassigned := cur.c;
		ELSIF( cur.status = 'assigned' ) THEN
			assigned := cur.c;
		ELSIF( cur.status = 'busy' ) THEN
			busy := cur.c;
		ELSIF( cur.status = 'done' ) THEN
			done := cur.c;
		ELSIF( cur.status = 'cancelled' ) THEN
			cancelled := cur.c;
		ELSIF( cur.status = 'suspended' ) THEN
			suspended := cur.c;
		END IF;
	END LOOP;
	
	UPDATE JobStatus SET
		taskscount = unassigned + assigned + busy + done + cancelled + suspended,
		tasksUnassigned = unassigned,
		tasksAssigned = assigned,
		tasksBusy = busy,
		tasksDone = done,
		tasksCancelled = cancelled,
		tasksSuspended = suspended
	WHERE fkeyjob = _keyjob;
	RETURN;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 24 (class 1255 OID 16460)
-- Dependencies: 1054 3
-- Name: update_jobtask(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_jobtask() RETURNS trigger
    AS $$
DECLARE
BEGIN
	--
	-- Update HostStatus to show current command history and task
	--
RETURN new;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 54 (class 1255 OID 16461)
-- Dependencies: 1054 3
-- Name: update_jobtask_counts(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_jobtask_counts() RETURNS trigger
    AS $$
DECLARE
BEGIN
        -- Update Job Counters when a tasks status changes
        IF (NEW.status != OLD.status) THEN
		PERFORM update_job_task_counts(NEW.fkeyjob);
        END IF;
RETURN new;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 67 (class 1255 OID 16462)
-- Dependencies: 1054 3
-- Name: update_laststatuschange(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_laststatuschange() RETURNS trigger
    AS $$
DECLARE
currentjob job;
BEGIN
IF (NEW.slavestatus IS NOT NULL)
 AND (NEW.slavestatus != OLD.slavestatus) THEN
	NEW.lastStatusChange = NOW();
	IF (NEW.slavestatus != 'busy') THEN
		NEW.fkeyjobtask = NULL;
	END IF;
END IF;

-- Increment Job.hostsOnJob
IF (NEW.fkeyjob IS NOT NULL AND (NEW.fkeyjob != OLD.fkeyjob OR OLD.fkeyjob IS NULL) ) THEN
	UPDATE Job SET hostsOnJob=hostsOnJob+1 WHERE keyjob=NEW.fkeyjob;
END IF;

-- Decrement Job.hostsOnJob
IF (OLD.fkeyjob IS NOT NULL AND (OLD.fkeyjob != NEW.fkeyjob OR NEW.fkeyjob IS NULL) ) THEN
	UPDATE Job SET hostsOnJob=hostsOnJob-1 WHERE keyjob=OLD.fkeyjob;
END IF;

IF (NEW.slavestatus IS NOT NULL)
 AND ((NEW.slavestatus != OLD.slavestatus) OR (NEW.fkeyjobtask != OLD.fkeyjobtask) OR ((OLD.fkeyjobtask IS NULL) != (NEW.fkeyjobtask IS NULL))) THEN
	SELECT INTO currentjob * from job where keyjob=NEW.fkeyjob;
	UPDATE hosthistory SET duration = now() - datetime, nextstatus=NEW.slavestatus WHERE duration is null and fkeyhost=NEW.keyhost;
	INSERT INTO hosthistory (datetime,fkeyhost,fkeyjob,fkeyjobstat,status,laststatus,fkeyjobtype,fkeyjobtask) values (now(),NEW.keyhost,NEW.fkeyjob,currentjob.fkeyjobstat,NEW.slavestatus,OLD.slavestatus,currentjob.fkeyjobtype,NEW.fkeyjobtask);
END IF;

RETURN new;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 68 (class 1255 OID 16463)
-- Dependencies: 3 1054
-- Name: update_project_tempo(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_project_tempo() RETURNS void
    AS $$
	DECLARE
		cur RECORD;
		hosts RECORD;
		newtempo float8;
	BEGIN
		SELECT INTO hosts count(*) from hoststatus where slavestatus in ('ready','assigned','busy','copy');
		FOR cur IN
			SELECT projecttempo.fkeyproject, max(projecttempo.tempo) as tempo, sum(jobstatus.hostsonjob) as hostcount, count(job.keyjob) as jobs
			FROM projecttempo LEFT JOIN job ON projecttempo.fkeyproject=job.fkeyproject LEFT JOIN jobstatus ON jobstatus.fkeyjob=job.keyjob
			AND status IN('started','ready')
			GROUP BY projecttempo.fkeyproject
			ORDER BY hostcount ASC
		LOOP
			IF cur.hostcount IS NULL OR cur.hostcount=0 THEN
				DELETE FROM projecttempo WHERE fkeyproject=cur.fkeyproject;
			ELSE
				UPDATE projecttempo SET tempo=(cur.hostcount::float8/hosts.count)::numeric(4,3)::float8 where fkeyproject=cur.fkeyproject;
			END IF;
		END LOOP;
		FOR cur IN
			SELECT job.fkeyproject, sum(jobstatus.hostsonjob) as hostcount
			FROM job INNER JOIN jobstatus ON job.keyjob=jobstatus.fkeyjob
			WHERE status IN('started','ready') AND fkeyproject NOT IN (SELECT fkeyproject FROM projecttempo) AND fkeyproject IS NOT NULL
			GROUP BY job.fkeyproject
		LOOP
			newtempo := (cur.hostcount::float8/hosts.count)::numeric(4,3)::float8;
			IF newtempo > .001 THEN
				INSERT INTO projecttempo (fkeyproject, tempo) values (cur.fkeyproject,newtempo);
			END IF;
		END LOOP;
		RETURN;
	END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 2235 (class 1259 OID 16464)
-- Dependencies: 3
-- Name: job_keyjob_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE job_keyjob_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4305 (class 0 OID 0)
-- Dependencies: 2235
-- Name: job_keyjob_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('job_keyjob_seq', 240775, true);


--
-- TOC entry 2236 (class 1259 OID 16466)
-- Dependencies: 2842 2843 2844 2845 2846 2847 2848 2849 2850 2851 2852 2853 2854 2855 2856 3
-- Name: job; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE job (
    keyjob integer DEFAULT nextval('job_keyjob_seq'::regclass) NOT NULL,
    fkeyelement integer,
    fkeyhost integer,
    fkeyjobtype integer,
    fkeyproject integer,
    fkeyusr integer,
    hostlist text,
    job text,
    jobtime text,
    outputpath text,
    status text DEFAULT 'new'::text,
    submitted integer,
    started integer,
    ended integer,
    expires integer,
    deleteoncomplete integer,
    hostsonjob integer DEFAULT 0,
    taskscount integer DEFAULT 0,
    tasksunassigned integer DEFAULT 0,
    tasksdone integer DEFAULT 0,
    tasksaveragetime integer,
    priority integer DEFAULT 50,
    errorcount integer,
    queueorder integer,
    packettype text DEFAULT 'random'::text,
    packetsize integer,
    queueeta integer,
    notifyonerror text,
    notifyoncomplete text,
    maxtasktime integer DEFAULT 3600,
    cleaned integer,
    filesize integer,
    btinfohash text,
    rendertime integer,
    abversion text,
    deplist text,
    args text,
    filename text,
    filemd5sum text,
    fkeyjobstat integer,
    username text,
    domain text,
    password text,
    stats text,
    currentmapserverweight double precision,
    loadtimeaverage integer,
    tasksassigned integer DEFAULT 0,
    tasksbusy integer DEFAULT 0,
    prioritizeoutertasks boolean,
    outertasksassigned boolean,
    lastnotifiederrorcount integer,
    taskscancelled integer DEFAULT 0,
    taskssuspended integer DEFAULT 0,
    health real,
    maxloadtime integer,
    license text,
    maxmemory integer,
    fkeyjobparent integer,
    endedts timestamp without time zone,
    startedts timestamp without time zone,
    submittedts timestamp without time zone,
    maxhosts integer,
    personalpriority integer DEFAULT 50,
    loggingenabled boolean DEFAULT true NOT NULL,
    environment text,
    runassubmitter boolean,
    checkfilemd5 boolean,
    uploadedfile boolean,
    framenth integer,
    framenthmode integer,
    exclusiveassignment boolean,
    hastaskprogress boolean,
    minmemory integer
);


--
-- TOC entry 69 (class 1255 OID 16487)
-- Dependencies: 357 1054 3
-- Name: update_single_job_health(job); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_single_job_health(j job) RETURNS void
    AS $$
DECLARE
	history hosthistory_status_summary_return;
	successtime interval;
	errortime interval;
	totaltime interval;
	job_health float;
BEGIN
	--RAISE NOTICE 'Updating health of job % %', j.job, j.keyjob;
	successtime := 0;
	errortime := 0;
	FOR history IN SELECT * FROM hosthistory_status_summary( 'hosthistory WHERE fkeyjob=' || quote_literal(j.keyjob) ) LOOP
		IF history.wasted = true THEN
			errortime := errortime + history.total_time;
		ELSE
			IF history.status = 'busy' AND history.loading = false THEN
				successtime := history.total_time;
			END IF;
		END IF;
	END LOOP;
	totaltime := 0;
	IF successtime IS NOT NULL THEN
		totaltime := successtime;
	ELSE
		successtime := 0;
	END IF;
	IF errortime IS NOT NULL THEN
		totaltime := totaltime + errortime;
	END IF;
	IF extract( epoch from totaltime ) > 0 THEN
		job_health := successtime / totaltime;
	ELSE
		job_health := 1.0;
	END IF;
	--RAISE NOTICE 'Got Success Time %, Error Time %, Total Time %, Health %', successtime, errortime, totaltime, job_health;
	UPDATE jobstatus SET health = job_health where jobstatus.fkeyjob=j.keyjob;
	RETURN;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 70 (class 1255 OID 16488)
-- Dependencies: 1054 3
-- Name: updatejoblicensecounts(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION updatejoblicensecounts(fkeyjob integer, countchange integer) RETURNS void
    AS $$
DECLARE
    serv service;
BEGIN
    FOR serv IN SELECT * FROM Service s JOIN JobService js ON (s.keyService = js.fkeyService AND js.fkeyjob=fkeyjob) WHERE fkeyLicense IS NOT NULL LOOP
        UPDATE License SET inUse=greatest(0,coalesce(inUse,0) + countChange) WHERE keylicense=serv.fkeylicense;
    END LOOP;
    RETURN;
END;
$$
    LANGUAGE plpgsql;


--
-- TOC entry 1757 (class 2617 OID 16489)
-- Dependencies: 3 43
-- Name: /; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR / (
    PROCEDURE = interval_divide,
    LEFTARG = interval,
    RIGHTARG = interval
);


SET search_path = jabberd, pg_catalog;

--
-- TOC entry 2237 (class 1259 OID 16490)
-- Dependencies: 6
-- Name: active; Type: TABLE; Schema: jabberd; Owner: -; Tablespace: 
--

CREATE TABLE active (
    "collection-owner" text,
    "object-sequence" integer,
    "time" integer
);


--
-- TOC entry 2238 (class 1259 OID 16496)
-- Dependencies: 6
-- Name: authreg; Type: TABLE; Schema: jabberd; Owner: -; Tablespace: 
--

CREATE TABLE authreg (
    username text,
    realm text,
    password text,
    token text,
    sequence integer,
    hash text
);


--
-- TOC entry 2239 (class 1259 OID 16502)
-- Dependencies: 6
-- Name: logout; Type: TABLE; Schema: jabberd; Owner: -; Tablespace: 
--

CREATE TABLE logout (
    "collection-owner" text,
    "object-sequence" integer,
    "time" integer
);


--
-- TOC entry 2240 (class 1259 OID 16508)
-- Dependencies: 6
-- Name: object-sequence; Type: SEQUENCE; Schema: jabberd; Owner: -
--

CREATE SEQUENCE "object-sequence"
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4306 (class 0 OID 0)
-- Dependencies: 2240
-- Name: object-sequence; Type: SEQUENCE SET; Schema: jabberd; Owner: -
--

SELECT pg_catalog.setval('"object-sequence"', 1, false);


--
-- TOC entry 2241 (class 1259 OID 16510)
-- Dependencies: 6
-- Name: privacy-items; Type: TABLE; Schema: jabberd; Owner: -; Tablespace: 
--

CREATE TABLE "privacy-items" (
    "collection-owner" text,
    "object-sequence" integer,
    list text,
    type text,
    value text,
    deny integer,
    "order" integer,
    block integer
);


--
-- TOC entry 2242 (class 1259 OID 16516)
-- Dependencies: 6
-- Name: private; Type: TABLE; Schema: jabberd; Owner: -; Tablespace: 
--

CREATE TABLE private (
    "collection-owner" text,
    "object-sequence" integer,
    ns text,
    xml text
);


--
-- TOC entry 2243 (class 1259 OID 16522)
-- Dependencies: 6
-- Name: queue; Type: TABLE; Schema: jabberd; Owner: -; Tablespace: 
--

CREATE TABLE queue (
    "collection-owner" text,
    "object-sequence" integer,
    xml text
);


--
-- TOC entry 2244 (class 1259 OID 16528)
-- Dependencies: 6
-- Name: roster-groups; Type: TABLE; Schema: jabberd; Owner: -; Tablespace: 
--

CREATE TABLE "roster-groups" (
    "collection-owner" text,
    "object-sequence" integer,
    jid text,
    "group" text
);


--
-- TOC entry 2245 (class 1259 OID 16534)
-- Dependencies: 6
-- Name: roster-items; Type: TABLE; Schema: jabberd; Owner: -; Tablespace: 
--

CREATE TABLE "roster-items" (
    "collection-owner" text,
    "object-sequence" integer,
    jid text,
    name text,
    ask integer,
    "to" boolean,
    "from" boolean
);


--
-- TOC entry 2246 (class 1259 OID 16540)
-- Dependencies: 6
-- Name: vcard; Type: TABLE; Schema: jabberd; Owner: -; Tablespace: 
--

CREATE TABLE vcard (
    "collection-owner" text,
    "object-sequence" integer,
    fn text,
    nickname text,
    url text,
    tel text,
    email text,
    title text,
    role text,
    bday text,
    "desc" text,
    "n-given" text,
    "n-family" text,
    "adr-street" text,
    "adr-extadd" text,
    "adr-locality" text,
    "adr-region" text,
    "adr-pcode" text,
    "adr-country" text,
    "org-orgname" text,
    "org-orgunit" text
);


SET search_path = public, pg_catalog;

--
-- TOC entry 2247 (class 1259 OID 16546)
-- Dependencies: 3
-- Name: host_keyhost_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE host_keyhost_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4307 (class 0 OID 0)
-- Dependencies: 2247
-- Name: host_keyhost_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('host_keyhost_seq', 569, true);


--
-- TOC entry 2248 (class 1259 OID 16548)
-- Dependencies: 2857 2858 2859 2860 2861 3
-- Name: host; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE host (
    keyhost integer DEFAULT nextval('host_keyhost_seq'::regclass) NOT NULL,
    backupbytes text,
    cpus integer,
    description text,
    diskusage text,
    fkeyjob integer,
    host text NOT NULL,
    manufacturer text,
    model text,
    os text,
    rendertime text,
    slavepluginlist text,
    sn text,
    version text,
    renderrate double precision,
    dutycycle double precision,
    memory integer,
    mhtz integer,
    online integer,
    uid integer,
    slavepacketweight double precision,
    framecount integer,
    viruscount integer,
    virustimestamp date,
    errortempo integer,
    fkeyhost_backup integer,
    oldkey integer,
    abversion text,
    laststatuschange timestamp without time zone,
    loadavg double precision,
    allowmapping boolean DEFAULT false,
    allowsleep boolean DEFAULT false,
    fkeyjobtask integer,
    wakeonlan boolean DEFAULT false,
    architecture text,
    loc_x real,
    loc_y real,
    loc_z real,
    ostext text,
    bootaction text,
    fkeydiskimage integer,
    syncname text,
    fkeylocation integer,
    cpuname text,
    osversion text,
    slavepulse timestamp without time zone,
    puppetpulse timestamp without time zone,
    maxassignments integer DEFAULT 2 NOT NULL
);


--
-- TOC entry 2249 (class 1259 OID 16559)
-- Dependencies: 3
-- Name: hostinterface_keyhostinterface_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hostinterface_keyhostinterface_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4308 (class 0 OID 0)
-- Dependencies: 2249
-- Name: hostinterface_keyhostinterface_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('hostinterface_keyhostinterface_seq', 590, true);


--
-- TOC entry 2250 (class 1259 OID 16561)
-- Dependencies: 2862 3
-- Name: hostinterface; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE hostinterface (
    keyhostinterface integer DEFAULT nextval('hostinterface_keyhostinterface_seq'::regclass) NOT NULL,
    fkeyhost integer NOT NULL,
    mac text,
    ip text,
    fkeyhostinterfacetype integer,
    switchport integer,
    fkeyswitch integer,
    inst text
);


--
-- TOC entry 2251 (class 1259 OID 16568)
-- Dependencies: 2648 3
-- Name: HostInterfacesVerbose; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW "HostInterfacesVerbose" AS
    SELECT host.keyhost, host.backupbytes, host.cpus, host.description, host.diskusage, host.fkeyjob, host.host, host.manufacturer, host.model, host.os, host.rendertime, host.slavepluginlist, host.sn, host.version, host.renderrate, host.dutycycle, host.memory, host.mhtz, host.online, host.uid, host.slavepacketweight, host.framecount, host.viruscount, host.virustimestamp, host.errortempo, host.fkeyhost_backup, host.oldkey, host.abversion, host.laststatuschange, host.loadavg, host.allowmapping, host.allowsleep, host.fkeyjobtask, host.wakeonlan, host.architecture, host.loc_x, host.loc_y, host.loc_z, host.ostext, host.bootaction, host.fkeydiskimage, host.syncname, host.fkeylocation, host.cpuname, host.osversion, host.slavepulse, hostinterface.keyhostinterface, hostinterface.fkeyhost, hostinterface.mac, hostinterface.ip, hostinterface.fkeyhostinterfacetype, hostinterface.switchport, hostinterface.fkeyswitch, hostinterface.inst FROM (host JOIN hostinterface ON ((host.keyhost = hostinterface.fkeyhost)));


--
-- TOC entry 2252 (class 1259 OID 16573)
-- Dependencies: 3
-- Name: jobtask_keyjobtask_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobtask_keyjobtask_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4309 (class 0 OID 0)
-- Dependencies: 2252
-- Name: jobtask_keyjobtask_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('jobtask_keyjobtask_seq', 20003060, true);


--
-- TOC entry 2253 (class 1259 OID 16575)
-- Dependencies: 2863 2864 3
-- Name: jobtask; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobtask (
    keyjobtask integer DEFAULT nextval('jobtask_keyjobtask_seq'::regclass) NOT NULL,
    ended integer,
    fkeyhost integer,
    fkeyjob integer NOT NULL,
    status text DEFAULT 'new'::text,
    jobtask integer,
    label text,
    fkeyjoboutput integer,
    progress integer,
    fkeyjobtaskassignment integer
);


--
-- TOC entry 2254 (class 1259 OID 16583)
-- Dependencies: 3
-- Name: jobtype_keyjobtype_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobtype_keyjobtype_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4310 (class 0 OID 0)
-- Dependencies: 2254
-- Name: jobtype_keyjobtype_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('jobtype_keyjobtype_seq', 35, true);


--
-- TOC entry 2255 (class 1259 OID 16585)
-- Dependencies: 2865 3
-- Name: jobtype; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobtype (
    keyjobtype integer DEFAULT nextval('jobtype_keyjobtype_seq'::regclass) NOT NULL,
    jobtype text,
    fkeyservice integer,
    icon bytea
);


--
-- TOC entry 2256 (class 1259 OID 16592)
-- Dependencies: 2649 3
-- Name: StatsByType; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW "StatsByType" AS
    SELECT "substring"((date_trunc('day'::text, ('1970-01-01 10:00:00+10'::timestamp with time zone + ((jobtask.ended)::double precision * '00:00:01'::interval))))::text, 0, 11) AS day, jobtype.jobtype, count(*) AS frames FROM ((jobtask LEFT JOIN job ON ((jobtask.fkeyjob = job.keyjob))) LEFT JOIN jobtype ON ((jobtype.keyjobtype = job.fkeyjobtype))) WHERE (jobtask.status = 'done'::text) GROUP BY "substring"((date_trunc('day'::text, ('1970-01-01 10:00:00+10'::timestamp with time zone + ((jobtask.ended)::double precision * '00:00:01'::interval))))::text, 0, 11), jobtype.jobtype ORDER BY "substring"((date_trunc('day'::text, ('1970-01-01 10:00:00+10'::timestamp with time zone + ((jobtask.ended)::double precision * '00:00:01'::interval))))::text, 0, 11);


--
-- TOC entry 2257 (class 1259 OID 16597)
-- Dependencies: 3
-- Name: abdownloadstat_keyabdownloadstat_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE abdownloadstat_keyabdownloadstat_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4311 (class 0 OID 0)
-- Dependencies: 2257
-- Name: abdownloadstat_keyabdownloadstat_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('abdownloadstat_keyabdownloadstat_seq', 1, false);


--
-- TOC entry 2258 (class 1259 OID 16599)
-- Dependencies: 2866 3
-- Name: abdownloadstat; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE abdownloadstat (
    keyabdownloadstat integer DEFAULT nextval('abdownloadstat_keyabdownloadstat_seq'::regclass) NOT NULL,
    type text,
    size integer,
    fkeyhost integer,
    "time" integer,
    abrev integer,
    finished timestamp without time zone,
    fkeyjob integer
);


--
-- TOC entry 2259 (class 1259 OID 16606)
-- Dependencies: 3
-- Name: annotation_keyannotation_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE annotation_keyannotation_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4312 (class 0 OID 0)
-- Dependencies: 2259
-- Name: annotation_keyannotation_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('annotation_keyannotation_seq', 1, false);


--
-- TOC entry 2260 (class 1259 OID 16608)
-- Dependencies: 2867 3
-- Name: annotation; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE annotation (
    keyannotation integer DEFAULT nextval('annotation_keyannotation_seq'::regclass) NOT NULL,
    notes text,
    sequence text,
    framestart integer,
    frameend integer,
    markupdata text
);


--
-- TOC entry 2261 (class 1259 OID 16615)
-- Dependencies: 3
-- Name: element_keyelement_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE element_keyelement_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4313 (class 0 OID 0)
-- Dependencies: 2261
-- Name: element_keyelement_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('element_keyelement_seq', 1786, true);


--
-- TOC entry 2262 (class 1259 OID 16617)
-- Dependencies: 2868 3
-- Name: element; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE element (
    keyelement integer DEFAULT nextval('element_keyelement_seq'::regclass) NOT NULL,
    daysbid double precision,
    description text,
    fkeyelement integer,
    fkeyelementstatus integer,
    fkeyelementtype integer,
    fkeyproject integer,
    fkeythumbnail integer,
    name text,
    daysscheduled double precision,
    daysestimated double precision,
    status text,
    filepath text,
    fkeyassettype integer,
    fkeypathtemplate integer,
    fkeystatusset integer,
    allowtime boolean,
    datestart date,
    datecomplete date,
    fkeyassettemplate integer,
    icon bytea
);


--
-- TOC entry 2263 (class 1259 OID 16624)
-- Dependencies: 2869 2262 3
-- Name: asset; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE asset (
    fkeyassettype integer,
    icon bytea,
    fkeystatus integer,
    keyasset integer,
    version integer
)
INHERITS (element);


--
-- TOC entry 2264 (class 1259 OID 16631)
-- Dependencies: 3
-- Name: assetdep; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE assetdep (
    keyassetdep integer NOT NULL,
    path text,
    fkeypackage integer,
    fkeyasset integer
);


--
-- TOC entry 2265 (class 1259 OID 16637)
-- Dependencies: 2264 3
-- Name: assetdep_keyassetdep_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assetdep_keyassetdep_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4314 (class 0 OID 0)
-- Dependencies: 2265
-- Name: assetdep_keyassetdep_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE assetdep_keyassetdep_seq OWNED BY assetdep.keyassetdep;


--
-- TOC entry 4315 (class 0 OID 0)
-- Dependencies: 2265
-- Name: assetdep_keyassetdep_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('assetdep_keyassetdep_seq', 1, false);


--
-- TOC entry 2266 (class 1259 OID 16639)
-- Dependencies: 2871 2262 3
-- Name: assetgroup; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE assetgroup (
    fkeyassettype integer
)
INHERITS (element);


--
-- TOC entry 2267 (class 1259 OID 16646)
-- Dependencies: 3
-- Name: assetprop; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE assetprop (
    keyassetprop integer NOT NULL,
    fkeyassetproptype integer,
    fkeyasset integer
);


--
-- TOC entry 2268 (class 1259 OID 16649)
-- Dependencies: 2267 3
-- Name: assetprop_keyassetprop_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assetprop_keyassetprop_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4316 (class 0 OID 0)
-- Dependencies: 2268
-- Name: assetprop_keyassetprop_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE assetprop_keyassetprop_seq OWNED BY assetprop.keyassetprop;


--
-- TOC entry 4317 (class 0 OID 0)
-- Dependencies: 2268
-- Name: assetprop_keyassetprop_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('assetprop_keyassetprop_seq', 1, false);


--
-- TOC entry 2269 (class 1259 OID 16651)
-- Dependencies: 3
-- Name: assetproperty_keyassetproperty_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assetproperty_keyassetproperty_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4318 (class 0 OID 0)
-- Dependencies: 2269
-- Name: assetproperty_keyassetproperty_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('assetproperty_keyassetproperty_seq', 1, false);


--
-- TOC entry 2270 (class 1259 OID 16653)
-- Dependencies: 2873 3
-- Name: assetproperty; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE assetproperty (
    keyassetproperty integer DEFAULT nextval('assetproperty_keyassetproperty_seq'::regclass) NOT NULL,
    name text,
    type integer,
    value text,
    fkeyelement integer
);


--
-- TOC entry 2271 (class 1259 OID 16660)
-- Dependencies: 3
-- Name: assetproptype; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE assetproptype (
    keyassetproptype integer NOT NULL,
    name text,
    depth integer
);


--
-- TOC entry 2272 (class 1259 OID 16666)
-- Dependencies: 2271 3
-- Name: assetproptype_keyassetproptype_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assetproptype_keyassetproptype_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4319 (class 0 OID 0)
-- Dependencies: 2272
-- Name: assetproptype_keyassetproptype_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE assetproptype_keyassetproptype_seq OWNED BY assetproptype.keyassetproptype;


--
-- TOC entry 4320 (class 0 OID 0)
-- Dependencies: 2272
-- Name: assetproptype_keyassetproptype_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('assetproptype_keyassetproptype_seq', 1, false);


--
-- TOC entry 2273 (class 1259 OID 16668)
-- Dependencies: 3
-- Name: assetset_keyassetset_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assetset_keyassetset_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4321 (class 0 OID 0)
-- Dependencies: 2273
-- Name: assetset_keyassetset_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('assetset_keyassetset_seq', 1, false);


--
-- TOC entry 2274 (class 1259 OID 16670)
-- Dependencies: 2875 3
-- Name: assetset; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE assetset (
    keyassetset integer DEFAULT nextval('assetset_keyassetset_seq'::regclass) NOT NULL,
    fkeyproject integer,
    fkeyelementtype integer,
    fkeyassettype integer,
    name text
);


--
-- TOC entry 2275 (class 1259 OID 16677)
-- Dependencies: 3
-- Name: assetsetitem_keyassetsetitem_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assetsetitem_keyassetsetitem_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4322 (class 0 OID 0)
-- Dependencies: 2275
-- Name: assetsetitem_keyassetsetitem_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('assetsetitem_keyassetsetitem_seq', 1, false);


--
-- TOC entry 2276 (class 1259 OID 16679)
-- Dependencies: 2876 3
-- Name: assetsetitem; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE assetsetitem (
    keyassetsetitem integer DEFAULT nextval('assetsetitem_keyassetsetitem_seq'::regclass) NOT NULL,
    fkeyassetset integer,
    fkeyassettype integer,
    fkeyelementtype integer,
    fkeytasktype integer
);


--
-- TOC entry 2277 (class 1259 OID 16683)
-- Dependencies: 3
-- Name: assettemplate_keyassettemplate_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assettemplate_keyassettemplate_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4323 (class 0 OID 0)
-- Dependencies: 2277
-- Name: assettemplate_keyassettemplate_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('assettemplate_keyassettemplate_seq', 172, true);


--
-- TOC entry 2278 (class 1259 OID 16685)
-- Dependencies: 2877 3
-- Name: assettemplate; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE assettemplate (
    keyassettemplate integer DEFAULT nextval('assettemplate_keyassettemplate_seq'::regclass) NOT NULL,
    fkeyassettype integer,
    fkeyelement integer,
    fkeyproject integer,
    name text
);


--
-- TOC entry 2279 (class 1259 OID 16692)
-- Dependencies: 3
-- Name: assettype_keyassettype_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assettype_keyassettype_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4324 (class 0 OID 0)
-- Dependencies: 2279
-- Name: assettype_keyassettype_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('assettype_keyassettype_seq', 3, true);


--
-- TOC entry 2280 (class 1259 OID 16694)
-- Dependencies: 2878 3
-- Name: assettype; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE assettype (
    keyassettype integer DEFAULT nextval('assettype_keyassettype_seq'::regclass) NOT NULL,
    assettype text,
    deleted boolean
);


--
-- TOC entry 2281 (class 1259 OID 16701)
-- Dependencies: 3
-- Name: attachment_keyattachment_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE attachment_keyattachment_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4325 (class 0 OID 0)
-- Dependencies: 2281
-- Name: attachment_keyattachment_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('attachment_keyattachment_seq', 1, false);


--
-- TOC entry 2282 (class 1259 OID 16703)
-- Dependencies: 2879 3
-- Name: attachment; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE attachment (
    keyattachment integer DEFAULT nextval('attachment_keyattachment_seq'::regclass) NOT NULL,
    caption text,
    created timestamp without time zone,
    filename text,
    fkeyelement integer,
    fkeyuser integer,
    origpath text,
    attachment text,
    url text,
    description text,
    fkeyauthor integer,
    fkeyattachmenttype integer
);


--
-- TOC entry 2283 (class 1259 OID 16710)
-- Dependencies: 3
-- Name: attachmenttype_keyattachmenttype_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE attachmenttype_keyattachmenttype_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4326 (class 0 OID 0)
-- Dependencies: 2283
-- Name: attachmenttype_keyattachmenttype_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('attachmenttype_keyattachmenttype_seq', 1, false);


--
-- TOC entry 2284 (class 1259 OID 16712)
-- Dependencies: 2880 3
-- Name: attachmenttype; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE attachmenttype (
    keyattachmenttype integer DEFAULT nextval('attachmenttype_keyattachmenttype_seq'::regclass) NOT NULL,
    attachmenttype text
);


--
-- TOC entry 2285 (class 1259 OID 16719)
-- Dependencies: 3
-- Name: calendar_keycalendar_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE calendar_keycalendar_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4327 (class 0 OID 0)
-- Dependencies: 2285
-- Name: calendar_keycalendar_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('calendar_keycalendar_seq', 1, false);


--
-- TOC entry 2286 (class 1259 OID 16721)
-- Dependencies: 2881 3
-- Name: calendar; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE calendar (
    keycalendar integer DEFAULT nextval('calendar_keycalendar_seq'::regclass) NOT NULL,
    repeat integer,
    fkeycalendarcategory integer,
    url text,
    fkeyauthor integer,
    fieldname text,
    notifylist text,
    notifybatch text,
    leadtime integer,
    notifymask integer,
    fkeyusr integer,
    private integer,
    date timestamp without time zone,
    calendar text,
    fkeyproject integer
);


--
-- TOC entry 2287 (class 1259 OID 16728)
-- Dependencies: 3
-- Name: calendarcategory_keycalendarcategory_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE calendarcategory_keycalendarcategory_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4328 (class 0 OID 0)
-- Dependencies: 2287
-- Name: calendarcategory_keycalendarcategory_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('calendarcategory_keycalendarcategory_seq', 1, true);


--
-- TOC entry 2288 (class 1259 OID 16730)
-- Dependencies: 2882 3
-- Name: calendarcategory; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE calendarcategory (
    keycalendarcategory integer DEFAULT nextval('calendarcategory_keycalendarcategory_seq'::regclass) NOT NULL,
    calendarcategory text
);


--
-- TOC entry 2289 (class 1259 OID 16737)
-- Dependencies: 3
-- Name: checklistitem_keychecklistitem_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE checklistitem_keychecklistitem_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4329 (class 0 OID 0)
-- Dependencies: 2289
-- Name: checklistitem_keychecklistitem_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('checklistitem_keychecklistitem_seq', 1, false);


--
-- TOC entry 2290 (class 1259 OID 16739)
-- Dependencies: 2883 3
-- Name: checklistitem; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE checklistitem (
    keychecklistitem integer DEFAULT nextval('checklistitem_keychecklistitem_seq'::regclass) NOT NULL,
    body text,
    checklistitem text,
    fkeyproject integer,
    fkeythumbnail integer,
    fkeytimesheetcategory integer,
    type text,
    fkeystatusset integer
);


--
-- TOC entry 2291 (class 1259 OID 16746)
-- Dependencies: 3
-- Name: checkliststatus_keycheckliststatus_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE checkliststatus_keycheckliststatus_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4330 (class 0 OID 0)
-- Dependencies: 2291
-- Name: checkliststatus_keycheckliststatus_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('checkliststatus_keycheckliststatus_seq', 1, false);


--
-- TOC entry 2292 (class 1259 OID 16748)
-- Dependencies: 2884 3
-- Name: checkliststatus; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE checkliststatus (
    keycheckliststatus integer DEFAULT nextval('checkliststatus_keycheckliststatus_seq'::regclass) NOT NULL,
    fkeychecklistitem integer,
    fkeyelement integer,
    state integer,
    fkeyelementstatus integer
);


--
-- TOC entry 2293 (class 1259 OID 16752)
-- Dependencies: 3
-- Name: client_keyclient_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE client_keyclient_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4331 (class 0 OID 0)
-- Dependencies: 2293
-- Name: client_keyclient_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('client_keyclient_seq', 2, true);


--
-- TOC entry 2294 (class 1259 OID 16754)
-- Dependencies: 2885 3
-- Name: client; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE client (
    keyclient integer DEFAULT nextval('client_keyclient_seq'::regclass) NOT NULL,
    client text,
    textcard text
);


--
-- TOC entry 2295 (class 1259 OID 16761)
-- Dependencies: 3
-- Name: config_keyconfig_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE config_keyconfig_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4332 (class 0 OID 0)
-- Dependencies: 2295
-- Name: config_keyconfig_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('config_keyconfig_seq', 25, true);


--
-- TOC entry 2296 (class 1259 OID 16763)
-- Dependencies: 2886 3
-- Name: config; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE config (
    keyconfig integer DEFAULT nextval('config_keyconfig_seq'::regclass) NOT NULL,
    config text,
    value text
);


--
-- TOC entry 2297 (class 1259 OID 16770)
-- Dependencies: 2887 3 2262
-- Name: delivery; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE delivery (
    icon bytea
)
INHERITS (element);


--
-- TOC entry 2298 (class 1259 OID 16777)
-- Dependencies: 3
-- Name: deliveryelement_keydeliveryshot_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE deliveryelement_keydeliveryshot_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4333 (class 0 OID 0)
-- Dependencies: 2298
-- Name: deliveryelement_keydeliveryshot_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('deliveryelement_keydeliveryshot_seq', 1, false);


--
-- TOC entry 2299 (class 1259 OID 16779)
-- Dependencies: 2888 3
-- Name: deliveryelement; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE deliveryelement (
    keydeliveryshot integer DEFAULT nextval('deliveryelement_keydeliveryshot_seq'::regclass) NOT NULL,
    fkeydelivery integer,
    fkeyelement integer,
    framestart integer,
    frameend integer
);


--
-- TOC entry 2300 (class 1259 OID 16783)
-- Dependencies: 3
-- Name: demoreel_keydemoreel_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE demoreel_keydemoreel_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4334 (class 0 OID 0)
-- Dependencies: 2300
-- Name: demoreel_keydemoreel_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('demoreel_keydemoreel_seq', 1, false);


--
-- TOC entry 2301 (class 1259 OID 16785)
-- Dependencies: 2889 3
-- Name: demoreel; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE demoreel (
    keydemoreel integer DEFAULT nextval('demoreel_keydemoreel_seq'::regclass) NOT NULL,
    demoreel text,
    datesent date,
    projectlist text,
    contactinfo text,
    notes text,
    playlist text,
    shippingtype integer
);


--
-- TOC entry 2302 (class 1259 OID 16792)
-- Dependencies: 3
-- Name: diskimage_keydiskimage_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE diskimage_keydiskimage_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4335 (class 0 OID 0)
-- Dependencies: 2302
-- Name: diskimage_keydiskimage_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('diskimage_keydiskimage_seq', 8, true);


--
-- TOC entry 2303 (class 1259 OID 16794)
-- Dependencies: 2890 3
-- Name: diskimage; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE diskimage (
    keydiskimage integer DEFAULT nextval('diskimage_keydiskimage_seq'::regclass) NOT NULL,
    diskimage text,
    path text,
    created timestamp without time zone
);


--
-- TOC entry 2304 (class 1259 OID 16801)
-- Dependencies: 3
-- Name: dynamichostgroup_keydynamichostgroup_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE dynamichostgroup_keydynamichostgroup_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4336 (class 0 OID 0)
-- Dependencies: 2304
-- Name: dynamichostgroup_keydynamichostgroup_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('dynamichostgroup_keydynamichostgroup_seq', 1, false);


--
-- TOC entry 2305 (class 1259 OID 16803)
-- Dependencies: 3
-- Name: hostgroup_keyhostgroup_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hostgroup_keyhostgroup_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4337 (class 0 OID 0)
-- Dependencies: 2305
-- Name: hostgroup_keyhostgroup_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('hostgroup_keyhostgroup_seq', 52, true);


--
-- TOC entry 2306 (class 1259 OID 16805)
-- Dependencies: 2891 3
-- Name: hostgroup; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE hostgroup (
    keyhostgroup integer DEFAULT nextval('hostgroup_keyhostgroup_seq'::regclass) NOT NULL,
    hostgroup text,
    fkeyusr integer,
    private boolean
);


--
-- TOC entry 2307 (class 1259 OID 16812)
-- Dependencies: 2892 2893 2306 3
-- Name: dynamichostgroup; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE dynamichostgroup (
    keydynamichostgroup integer DEFAULT nextval('dynamichostgroup_keydynamichostgroup_seq'::regclass) NOT NULL,
    hostwhereclause text
)
INHERITS (hostgroup);


--
-- TOC entry 2308 (class 1259 OID 16820)
-- Dependencies: 3
-- Name: elementdep_keyelementdep_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE elementdep_keyelementdep_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4338 (class 0 OID 0)
-- Dependencies: 2308
-- Name: elementdep_keyelementdep_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('elementdep_keyelementdep_seq', 1, false);


--
-- TOC entry 2309 (class 1259 OID 16822)
-- Dependencies: 2894 3
-- Name: elementdep; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE elementdep (
    keyelementdep integer DEFAULT nextval('elementdep_keyelementdep_seq'::regclass) NOT NULL,
    fkeyelement integer,
    fkeyelementdep integer,
    relationtype text
);


--
-- TOC entry 2310 (class 1259 OID 16829)
-- Dependencies: 3
-- Name: elementstatus_keyelementstatus_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE elementstatus_keyelementstatus_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4339 (class 0 OID 0)
-- Dependencies: 2310
-- Name: elementstatus_keyelementstatus_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('elementstatus_keyelementstatus_seq', 8, true);


--
-- TOC entry 2311 (class 1259 OID 16831)
-- Dependencies: 2895 3
-- Name: elementstatus; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE elementstatus (
    keyelementstatus integer DEFAULT nextval('elementstatus_keyelementstatus_seq'::regclass) NOT NULL,
    name text,
    color text,
    fkeystatusset integer,
    "order" integer
);


--
-- TOC entry 2312 (class 1259 OID 16838)
-- Dependencies: 3
-- Name: elementthread_keyelementthread_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE elementthread_keyelementthread_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4340 (class 0 OID 0)
-- Dependencies: 2312
-- Name: elementthread_keyelementthread_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('elementthread_keyelementthread_seq', 18, true);


--
-- TOC entry 2313 (class 1259 OID 16840)
-- Dependencies: 2896 3
-- Name: elementthread; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE elementthread (
    keyelementthread integer DEFAULT nextval('elementthread_keyelementthread_seq'::regclass) NOT NULL,
    datetime timestamp without time zone,
    elementthread text,
    fkeyelement integer,
    fkeyusr integer,
    skeyreply integer,
    topic text,
    todostatus integer,
    hasattachments integer
);


--
-- TOC entry 2314 (class 1259 OID 16847)
-- Dependencies: 3
-- Name: elementtype_keyelementtype_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE elementtype_keyelementtype_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4341 (class 0 OID 0)
-- Dependencies: 2314
-- Name: elementtype_keyelementtype_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('elementtype_keyelementtype_seq', 8, true);


--
-- TOC entry 2315 (class 1259 OID 16849)
-- Dependencies: 2897 3
-- Name: elementtype; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE elementtype (
    keyelementtype integer DEFAULT nextval('elementtype_keyelementtype_seq'::regclass) NOT NULL,
    elementtype text,
    sortprefix text
);


--
-- TOC entry 2316 (class 1259 OID 16856)
-- Dependencies: 3
-- Name: elementtypetasktype_keyelementtypetasktype_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE elementtypetasktype_keyelementtypetasktype_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4342 (class 0 OID 0)
-- Dependencies: 2316
-- Name: elementtypetasktype_keyelementtypetasktype_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('elementtypetasktype_keyelementtypetasktype_seq', 1, false);


--
-- TOC entry 2317 (class 1259 OID 16858)
-- Dependencies: 2898 3
-- Name: elementtypetasktype; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE elementtypetasktype (
    keyelementtypetasktype integer DEFAULT nextval('elementtypetasktype_keyelementtypetasktype_seq'::regclass) NOT NULL,
    fkeyelementtype integer,
    fkeytasktype integer,
    fkeyassettype integer
);


--
-- TOC entry 2318 (class 1259 OID 16862)
-- Dependencies: 3
-- Name: elementuser_keyelementuser_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE elementuser_keyelementuser_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4343 (class 0 OID 0)
-- Dependencies: 2318
-- Name: elementuser_keyelementuser_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('elementuser_keyelementuser_seq', 79, true);


--
-- TOC entry 2319 (class 1259 OID 16864)
-- Dependencies: 2899 3
-- Name: elementuser; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE elementuser (
    keyelementuser integer DEFAULT nextval('elementuser_keyelementuser_seq'::regclass) NOT NULL,
    fkeyelement integer,
    fkeyuser integer,
    active boolean,
    fkeyassettype integer
);


--
-- TOC entry 2320 (class 1259 OID 16868)
-- Dependencies: 2900 2901 2262 3
-- Name: usr; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE usr (
    dateoflastlogon date,
    email text,
    fkeyhost integer,
    gpgkey text,
    jid text,
    pager text,
    password text,
    remoteips text,
    schedule text,
    shell text,
    uid integer,
    threadnotifybyjabber integer,
    threadnotifybyemail integer,
    fkeyclient integer,
    intranet integer,
    homedir text,
    disabled integer DEFAULT 0,
    gid integer,
    usr text,
    keyusr integer,
    rolemask text,
    usrlevel integer,
    remoteok integer,
    requestcount integer,
    sessiontimeout integer,
    logoncount integer,
    useradded integer,
    oldkeyusr integer,
    sid text,
    lastlogontype text
)
INHERITS (element);


--
-- TOC entry 2321 (class 1259 OID 16876)
-- Dependencies: 2902 2903 3 2320
-- Name: employee; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE employee (
    namefirst text,
    namelast text,
    dateofhire date,
    dateoftermination date,
    dateofbirth date,
    logon text,
    lockedout integer,
    bebackat timestamp without time zone,
    comment text,
    userlevel integer,
    nopostdays integer,
    initials text,
    missingtimesheetcount integer,
    namemiddle text
)
INHERITS (usr);


--
-- TOC entry 2322 (class 1259 OID 16884)
-- Dependencies: 3
-- Name: eventalert_keyEventAlert_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "eventalert_keyEventAlert_seq"
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4344 (class 0 OID 0)
-- Dependencies: 2322
-- Name: eventalert_keyEventAlert_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"eventalert_keyEventAlert_seq"', 1, false);


--
-- TOC entry 2323 (class 1259 OID 16886)
-- Dependencies: 2904 2905 3
-- Name: eventalert; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE eventalert (
    "keyEventAlert" integer DEFAULT nextval('"eventalert_keyEventAlert_seq"'::regclass) NOT NULL,
    "fkeyHost" integer NOT NULL,
    graphds text NOT NULL,
    "sampleType" character varying(32) NOT NULL,
    "samplePeriod" integer NOT NULL,
    severity smallint DEFAULT 1 NOT NULL,
    "sampleDirection" character varying(32),
    varname text,
    "sampleValue" real
);


--
-- TOC entry 2324 (class 1259 OID 16894)
-- Dependencies: 3
-- Name: filetemplate_keyfiletemplate_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE filetemplate_keyfiletemplate_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4345 (class 0 OID 0)
-- Dependencies: 2324
-- Name: filetemplate_keyfiletemplate_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('filetemplate_keyfiletemplate_seq', 1, false);


--
-- TOC entry 2325 (class 1259 OID 16896)
-- Dependencies: 2906 3
-- Name: filetemplate; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE filetemplate (
    keyfiletemplate integer DEFAULT nextval('filetemplate_keyfiletemplate_seq'::regclass) NOT NULL,
    fkeyelementtype integer,
    fkeyproject integer,
    fkeytasktype integer,
    name text,
    sourcefile text,
    templatefilename text,
    trackertable text
);


--
-- TOC entry 2326 (class 1259 OID 16903)
-- Dependencies: 3
-- Name: filetracker_keyfiletracker_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE filetracker_keyfiletracker_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4346 (class 0 OID 0)
-- Dependencies: 2326
-- Name: filetracker_keyfiletracker_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('filetracker_keyfiletracker_seq', 206400, true);


--
-- TOC entry 2327 (class 1259 OID 16905)
-- Dependencies: 2907 3
-- Name: filetracker; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE filetracker (
    keyfiletracker integer DEFAULT nextval('filetracker_keyfiletracker_seq'::regclass) NOT NULL,
    fkeyelement integer,
    name text,
    path text,
    filename text,
    fkeypathtemplate integer,
    fkeyprojectstorage integer,
    storagename text
);


--
-- TOC entry 2328 (class 1259 OID 16912)
-- Dependencies: 3
-- Name: filetrackerdep_keyfiletrackerdep_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE filetrackerdep_keyfiletrackerdep_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4347 (class 0 OID 0)
-- Dependencies: 2328
-- Name: filetrackerdep_keyfiletrackerdep_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('filetrackerdep_keyfiletrackerdep_seq', 1, false);


--
-- TOC entry 2329 (class 1259 OID 16914)
-- Dependencies: 2908 3
-- Name: filetrackerdep; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE filetrackerdep (
    keyfiletrackerdep integer DEFAULT nextval('filetrackerdep_keyfiletrackerdep_seq'::regclass) NOT NULL,
    fkeyinput integer,
    fkeyoutput integer
);


--
-- TOC entry 2330 (class 1259 OID 16918)
-- Dependencies: 3
-- Name: fileversion_keyfileversion_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE fileversion_keyfileversion_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4348 (class 0 OID 0)
-- Dependencies: 2330
-- Name: fileversion_keyfileversion_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('fileversion_keyfileversion_seq', 1, false);


--
-- TOC entry 2331 (class 1259 OID 16920)
-- Dependencies: 2909 3
-- Name: fileversion; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE fileversion (
    keyfileversion integer DEFAULT nextval('fileversion_keyfileversion_seq'::regclass) NOT NULL,
    version integer,
    iteration integer,
    path text,
    oldfilenames text,
    filename text,
    filenametemplate text,
    automaster integer,
    fkeyelement integer,
    fkeyfileversion integer
);


--
-- TOC entry 2332 (class 1259 OID 16927)
-- Dependencies: 3
-- Name: folder_keyfolder_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE folder_keyfolder_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4349 (class 0 OID 0)
-- Dependencies: 2332
-- Name: folder_keyfolder_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('folder_keyfolder_seq', 1, false);


--
-- TOC entry 2333 (class 1259 OID 16929)
-- Dependencies: 2910 3
-- Name: folder; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE folder (
    keyfolder integer DEFAULT nextval('folder_keyfolder_seq'::regclass) NOT NULL,
    folder text,
    mount text,
    tablename text,
    fkey integer,
    online integer,
    alias text,
    host text,
    link text
);


--
-- TOC entry 2334 (class 1259 OID 16936)
-- Dependencies: 3
-- Name: graph_keygraph_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE graph_keygraph_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4350 (class 0 OID 0)
-- Dependencies: 2334
-- Name: graph_keygraph_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('graph_keygraph_seq', 13, true);


--
-- TOC entry 2335 (class 1259 OID 16938)
-- Dependencies: 2911 2912 2913 3
-- Name: graph; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE graph (
    keygraph integer DEFAULT nextval('graph_keygraph_seq'::regclass) NOT NULL,
    height integer,
    width integer,
    vlabel character varying(64),
    period character varying(32),
    fkeygraphpage integer,
    upperlimit real,
    lowerlimit real,
    stack smallint DEFAULT 0 NOT NULL,
    graphmax smallint DEFAULT 0 NOT NULL,
    sortorder smallint,
    graph character varying(64)
);


--
-- TOC entry 2336 (class 1259 OID 16944)
-- Dependencies: 3
-- Name: graphds_keygraphds_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE graphds_keygraphds_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4351 (class 0 OID 0)
-- Dependencies: 2336
-- Name: graphds_keygraphds_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('graphds_keygraphds_seq', 360, true);


--
-- TOC entry 2337 (class 1259 OID 16946)
-- Dependencies: 2914 3
-- Name: graphds; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE graphds (
    keygraphds integer DEFAULT nextval('graphds_keygraphds_seq'::regclass) NOT NULL,
    varname character varying(64),
    dstype character varying(16),
    fkeyhost integer,
    cdef text,
    graphds text,
    fieldname text,
    filename text,
    negative boolean
);


--
-- TOC entry 4352 (class 0 OID 0)
-- Dependencies: 2337
-- Name: TABLE graphds; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE graphds IS 'Graph Datasource';


--
-- TOC entry 2338 (class 1259 OID 16953)
-- Dependencies: 3
-- Name: graphpage_keygraphpage_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE graphpage_keygraphpage_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4353 (class 0 OID 0)
-- Dependencies: 2338
-- Name: graphpage_keygraphpage_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('graphpage_keygraphpage_seq', 59, true);


--
-- TOC entry 2339 (class 1259 OID 16955)
-- Dependencies: 2915 3
-- Name: graphpage; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE graphpage (
    keygraphpage integer DEFAULT nextval('graphpage_keygraphpage_seq'::regclass) NOT NULL,
    fkeygraphpage integer,
    name character varying(32)
);


--
-- TOC entry 2340 (class 1259 OID 16959)
-- Dependencies: 3
-- Name: graphrelationship_keygraphrelationship_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE graphrelationship_keygraphrelationship_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4354 (class 0 OID 0)
-- Dependencies: 2340
-- Name: graphrelationship_keygraphrelationship_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('graphrelationship_keygraphrelationship_seq', 7, true);


--
-- TOC entry 2341 (class 1259 OID 16961)
-- Dependencies: 2916 2917 3
-- Name: graphrelationship; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE graphrelationship (
    keygraphrelationship integer DEFAULT nextval('graphrelationship_keygraphrelationship_seq'::regclass) NOT NULL,
    fkeygraphds integer NOT NULL,
    fkeygraph integer NOT NULL,
    negative smallint DEFAULT 0 NOT NULL
);


--
-- TOC entry 2342 (class 1259 OID 16966)
-- Dependencies: 3
-- Name: gridtemplate_keygridtemplate_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE gridtemplate_keygridtemplate_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4355 (class 0 OID 0)
-- Dependencies: 2342
-- Name: gridtemplate_keygridtemplate_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('gridtemplate_keygridtemplate_seq', 1, false);


--
-- TOC entry 2343 (class 1259 OID 16968)
-- Dependencies: 2918 3
-- Name: gridtemplate; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE gridtemplate (
    keygridtemplate integer DEFAULT nextval('gridtemplate_keygridtemplate_seq'::regclass) NOT NULL,
    fkeyproject integer,
    gridtemplate text
);


--
-- TOC entry 2344 (class 1259 OID 16975)
-- Dependencies: 3
-- Name: gridtemplateitem_keygridtemplateitem_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE gridtemplateitem_keygridtemplateitem_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4356 (class 0 OID 0)
-- Dependencies: 2344
-- Name: gridtemplateitem_keygridtemplateitem_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('gridtemplateitem_keygridtemplateitem_seq', 1, false);


--
-- TOC entry 2345 (class 1259 OID 16977)
-- Dependencies: 2919 3
-- Name: gridtemplateitem; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE gridtemplateitem (
    keygridtemplateitem integer DEFAULT nextval('gridtemplateitem_keygridtemplateitem_seq'::regclass) NOT NULL,
    fkeygridtemplate integer,
    fkeytasktype integer,
    checklistitems text,
    columntype integer,
    headername text,
    "position" integer
);


--
-- TOC entry 2346 (class 1259 OID 16984)
-- Dependencies: 3
-- Name: groupmapping_keygroupmapping_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE groupmapping_keygroupmapping_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4357 (class 0 OID 0)
-- Dependencies: 2346
-- Name: groupmapping_keygroupmapping_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('groupmapping_keygroupmapping_seq', 1, false);


--
-- TOC entry 2347 (class 1259 OID 16986)
-- Dependencies: 2920 3
-- Name: groupmapping; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE groupmapping (
    keygroupmapping integer DEFAULT nextval('groupmapping_keygroupmapping_seq'::regclass) NOT NULL,
    fkeygrp integer,
    fkeymapping integer
);


--
-- TOC entry 2348 (class 1259 OID 16990)
-- Dependencies: 3
-- Name: grp_keygrp_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE grp_keygrp_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4358 (class 0 OID 0)
-- Dependencies: 2348
-- Name: grp_keygrp_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('grp_keygrp_seq', 2, true);


--
-- TOC entry 2349 (class 1259 OID 16992)
-- Dependencies: 2921 3
-- Name: grp; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE grp (
    keygrp integer DEFAULT nextval('grp_keygrp_seq'::regclass) NOT NULL,
    grp text,
    alias text
);


--
-- TOC entry 2350 (class 1259 OID 16999)
-- Dependencies: 3
-- Name: gruntscript_keygruntscript_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE gruntscript_keygruntscript_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4359 (class 0 OID 0)
-- Dependencies: 2350
-- Name: gruntscript_keygruntscript_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('gruntscript_keygruntscript_seq', 1, false);


--
-- TOC entry 2351 (class 1259 OID 17001)
-- Dependencies: 2922 3
-- Name: gruntscript; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE gruntscript (
    keygruntscript integer DEFAULT nextval('gruntscript_keygruntscript_seq'::regclass) NOT NULL,
    runcount integer,
    lastrun date,
    scriptname text
);


--
-- TOC entry 2352 (class 1259 OID 17008)
-- Dependencies: 3
-- Name: history_keyhistory_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE history_keyhistory_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4360 (class 0 OID 0)
-- Dependencies: 2352
-- Name: history_keyhistory_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('history_keyhistory_seq', 1, false);


--
-- TOC entry 2353 (class 1259 OID 17010)
-- Dependencies: 2923 3
-- Name: history; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE history (
    keyhistory integer DEFAULT nextval('history_keyhistory_seq'::regclass) NOT NULL,
    date timestamp without time zone,
    fkeyelement integer,
    fkeyusr integer,
    history text
);


--
-- TOC entry 2354 (class 1259 OID 17017)
-- Dependencies: 3
-- Name: hostdailystat_keyhostdailystat_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hostdailystat_keyhostdailystat_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4361 (class 0 OID 0)
-- Dependencies: 2354
-- Name: hostdailystat_keyhostdailystat_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('hostdailystat_keyhostdailystat_seq', 1, false);


--
-- TOC entry 2355 (class 1259 OID 17019)
-- Dependencies: 2924 3
-- Name: hostdailystat; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE hostdailystat (
    keyhostdailystat integer DEFAULT nextval('hostdailystat_keyhostdailystat_seq'::regclass) NOT NULL,
    fkeyhost integer,
    readytime text,
    assignedtime text,
    copytime text,
    loadtime text,
    busytime text,
    offlinetime text,
    date date,
    tasksdone integer,
    loaderrors integer,
    taskerrors integer,
    loaderrortime text,
    busyerrortime text
);


--
-- TOC entry 2356 (class 1259 OID 17026)
-- Dependencies: 3
-- Name: hostgroupitem_keyhostgroupitem_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hostgroupitem_keyhostgroupitem_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4362 (class 0 OID 0)
-- Dependencies: 2356
-- Name: hostgroupitem_keyhostgroupitem_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('hostgroupitem_keyhostgroupitem_seq', 6079, true);


--
-- TOC entry 2357 (class 1259 OID 17028)
-- Dependencies: 2925 3
-- Name: hostgroupitem; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE hostgroupitem (
    keyhostgroupitem integer DEFAULT nextval('hostgroupitem_keyhostgroupitem_seq'::regclass) NOT NULL,
    fkeyhostgroup integer,
    fkeyhost integer
);


--
-- TOC entry 2358 (class 1259 OID 17032)
-- Dependencies: 3
-- Name: hostinterfacetype_keyhostinterfacetype_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hostinterfacetype_keyhostinterfacetype_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4363 (class 0 OID 0)
-- Dependencies: 2358
-- Name: hostinterfacetype_keyhostinterfacetype_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('hostinterfacetype_keyhostinterfacetype_seq', 3, true);


--
-- TOC entry 2359 (class 1259 OID 17034)
-- Dependencies: 2926 3
-- Name: hostinterfacetype; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE hostinterfacetype (
    keyhostinterfacetype integer DEFAULT nextval('hostinterfacetype_keyhostinterfacetype_seq'::regclass) NOT NULL,
    hostinterfacetype text
);


--
-- TOC entry 2360 (class 1259 OID 17041)
-- Dependencies: 3
-- Name: hostload_keyhostload_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hostload_keyhostload_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4364 (class 0 OID 0)
-- Dependencies: 2360
-- Name: hostload_keyhostload_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('hostload_keyhostload_seq', 1, false);


--
-- TOC entry 2361 (class 1259 OID 17043)
-- Dependencies: 2927 2928 3
-- Name: hostload; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE hostload (
    keyhostload integer DEFAULT nextval('hostload_keyhostload_seq'::regclass) NOT NULL,
    fkeyhost integer,
    loadavg double precision,
    loadavgadjust double precision DEFAULT 0.0,
    loadavgadjusttimestamp timestamp without time zone
);


--
-- TOC entry 2362 (class 1259 OID 17048)
-- Dependencies: 3
-- Name: hostmapping_keyhostmapping_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hostmapping_keyhostmapping_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4365 (class 0 OID 0)
-- Dependencies: 2362
-- Name: hostmapping_keyhostmapping_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('hostmapping_keyhostmapping_seq', 1, false);


--
-- TOC entry 2363 (class 1259 OID 17050)
-- Dependencies: 2929 3
-- Name: hostmapping; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE hostmapping (
    keyhostmapping integer DEFAULT nextval('hostmapping_keyhostmapping_seq'::regclass) NOT NULL,
    fkeyhost integer NOT NULL,
    fkeymapping integer NOT NULL
);


--
-- TOC entry 2364 (class 1259 OID 17054)
-- Dependencies: 3
-- Name: hostport_keyhostport_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hostport_keyhostport_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4366 (class 0 OID 0)
-- Dependencies: 2364
-- Name: hostport_keyhostport_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('hostport_keyhostport_seq', 745, true);


--
-- TOC entry 2365 (class 1259 OID 17056)
-- Dependencies: 2930 2931 3
-- Name: hostport; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE hostport (
    keyhostport integer DEFAULT nextval('hostport_keyhostport_seq'::regclass) NOT NULL,
    fkeyhost integer NOT NULL,
    port integer NOT NULL,
    monitor smallint DEFAULT 0 NOT NULL,
    monitorstatus character varying(16)
);


--
-- TOC entry 2366 (class 1259 OID 17061)
-- Dependencies: 3
-- Name: hostresource_keyhostresource_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hostresource_keyhostresource_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4367 (class 0 OID 0)
-- Dependencies: 2366
-- Name: hostresource_keyhostresource_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('hostresource_keyhostresource_seq', 1, false);


--
-- TOC entry 2367 (class 1259 OID 17063)
-- Dependencies: 2932 3
-- Name: hostresource; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE hostresource (
    keyhostresource integer DEFAULT nextval('hostresource_keyhostresource_seq'::regclass) NOT NULL,
    fkeyhost integer,
    hostresource text
);


--
-- TOC entry 2368 (class 1259 OID 17070)
-- Dependencies: 3
-- Name: hosts_ready; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE hosts_ready (
    count bigint
);


--
-- TOC entry 2369 (class 1259 OID 17073)
-- Dependencies: 3
-- Name: hosts_total; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE hosts_total (
    count bigint
);


--
-- TOC entry 2370 (class 1259 OID 17076)
-- Dependencies: 3
-- Name: hostservice_keyhostservice_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hostservice_keyhostservice_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4368 (class 0 OID 0)
-- Dependencies: 2370
-- Name: hostservice_keyhostservice_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('hostservice_keyhostservice_seq', 2570706, true);


--
-- TOC entry 2371 (class 1259 OID 17078)
-- Dependencies: 2933 3
-- Name: hostservice; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE hostservice (
    keyhostservice integer DEFAULT nextval('hostservice_keyhostservice_seq'::regclass) NOT NULL,
    fkeyhost integer,
    fkeyservice integer,
    hostserviceinfo text,
    hostservice text,
    fkeysyslog integer,
    enabled boolean,
    pulse timestamp without time zone,
    remotelogport integer
);


--
-- TOC entry 2372 (class 1259 OID 17085)
-- Dependencies: 3
-- Name: hostsoftware_keyhostsoftware_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hostsoftware_keyhostsoftware_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4369 (class 0 OID 0)
-- Dependencies: 2372
-- Name: hostsoftware_keyhostsoftware_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('hostsoftware_keyhostsoftware_seq', 283, true);


--
-- TOC entry 2373 (class 1259 OID 17087)
-- Dependencies: 2934 3
-- Name: hostsoftware; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE hostsoftware (
    keyhostsoftware integer DEFAULT nextval('hostsoftware_keyhostsoftware_seq'::regclass) NOT NULL,
    fkeyhost integer,
    fkeysoftware integer
);


--
-- TOC entry 2374 (class 1259 OID 17091)
-- Dependencies: 3
-- Name: hoststatus_keyhoststatus_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hoststatus_keyhoststatus_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4370 (class 0 OID 0)
-- Dependencies: 2374
-- Name: hoststatus_keyhoststatus_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('hoststatus_keyhoststatus_seq', 1702, true);


--
-- TOC entry 2375 (class 1259 OID 17093)
-- Dependencies: 2935 2936 3
-- Name: hoststatus; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE hoststatus (
    keyhoststatus integer DEFAULT nextval('hoststatus_keyhoststatus_seq'::regclass) NOT NULL,
    fkeyhost integer NOT NULL,
    slavestatus character varying(32),
    laststatuschange timestamp without time zone,
    slavepulse timestamp without time zone,
    fkeyjobtask integer,
    online integer,
    activeassignmentcount integer DEFAULT 0,
    availablememory integer,
    lastassignmentchange timestamp without time zone
);


--
-- TOC entry 2376 (class 1259 OID 17098)
-- Dependencies: 2937 2938 2939 2940 2941 2942 2943 2944 2945 2946 2947 2948 2949 2950 2951 2952 3 2236
-- Name: job3delight; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE job3delight (
    framenth integer,
    framenthmode integer,
    exclusiveassignment boolean,
    hastaskprogress boolean,
    minmemory integer,
    width integer,
    height integer,
    framestart integer,
    frameend integer,
    threads integer DEFAULT 4,
    processes integer,
    jobscript text,
    jobscriptparam text
)
INHERITS (job);


--
-- TOC entry 2377 (class 1259 OID 17120)
-- Dependencies: 2953 2954 2955 2956 2957 2958 2959 2960 2961 2962 2963 2964 2965 2966 2967 2236 3
-- Name: jobaftereffects; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobaftereffects (
    fkeyjobparent integer,
    endedts timestamp without time zone,
    startedts timestamp without time zone,
    submittedts timestamp without time zone,
    framenth integer,
    framenthmode integer,
    comp text,
    frameend integer,
    framestart integer,
    height integer,
    width integer
)
INHERITS (job);


--
-- TOC entry 2378 (class 1259 OID 17141)
-- Dependencies: 2968 2969 2970 2971 2972 2973 2974 2975 2976 2977 2978 2979 2980 2981 2982 2377 3
-- Name: jobaftereffects7; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobaftereffects7 (
    maxhosts integer,
    environment text,
    framenth integer,
    framenthmode integer
)
INHERITS (jobaftereffects);


--
-- TOC entry 2379 (class 1259 OID 17162)
-- Dependencies: 2983 2984 2985 2986 2987 2988 2989 2990 2991 2992 2993 2994 2995 2996 2997 2377 3
-- Name: jobaftereffects8; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobaftereffects8 (
    maxhosts integer,
    exclusiveassignment boolean,
    hastaskprogress boolean,
    minmemory integer
)
INHERITS (jobaftereffects);


--
-- TOC entry 2380 (class 1259 OID 17183)
-- Dependencies: 3
-- Name: jobassignment; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobassignment (
    keyjobassignment integer NOT NULL,
    fkeyjob integer,
    fkeyjobassignmentstatus integer,
    fkeyhost integer,
    stdout text,
    stderr text,
    command text,
    maxmemory integer,
    started timestamp without time zone,
    ended timestamp without time zone,
    fkeyjoberror integer,
    realtime double precision,
    usertime double precision,
    systime double precision,
    iowait integer,
    bytesread integer,
    byteswrite integer,
    efficiency double precision,
    opsread integer,
    opswrite integer
);


--
-- TOC entry 2381 (class 1259 OID 17189)
-- Dependencies: 3 2380
-- Name: jobassignment_keyjobassignment_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobassignment_keyjobassignment_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4371 (class 0 OID 0)
-- Dependencies: 2381
-- Name: jobassignment_keyjobassignment_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE jobassignment_keyjobassignment_seq OWNED BY jobassignment.keyjobassignment;


--
-- TOC entry 4372 (class 0 OID 0)
-- Dependencies: 2381
-- Name: jobassignment_keyjobassignment_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('jobassignment_keyjobassignment_seq', 434929, true);


--
-- TOC entry 2382 (class 1259 OID 17191)
-- Dependencies: 3
-- Name: jobassignmentstatus; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobassignmentstatus (
    keyjobassignmentstatus integer NOT NULL,
    status text
);


--
-- TOC entry 2383 (class 1259 OID 17197)
-- Dependencies: 2382 3
-- Name: jobassignmentstatus_keyjobassignmentstatus_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobassignmentstatus_keyjobassignmentstatus_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4373 (class 0 OID 0)
-- Dependencies: 2383
-- Name: jobassignmentstatus_keyjobassignmentstatus_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE jobassignmentstatus_keyjobassignmentstatus_seq OWNED BY jobassignmentstatus.keyjobassignmentstatus;


--
-- TOC entry 4374 (class 0 OID 0)
-- Dependencies: 2383
-- Name: jobassignmentstatus_keyjobassignmentstatus_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('jobassignmentstatus_keyjobassignmentstatus_seq', 6, true);


--
-- TOC entry 2384 (class 1259 OID 17199)
-- Dependencies: 3000 3001 3002 3003 3004 3005 3006 3007 3008 3009 3010 3011 3012 3013 3014 2236 3
-- Name: jobautodeskburn; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobautodeskburn (
    endedts timestamp without time zone,
    startedts timestamp without time zone,
    submittedts timestamp without time zone,
    loggingenabled boolean,
    framenth integer,
    framenthmode integer,
    exclusiveassignment boolean,
    hastaskprogress boolean,
    minmemory integer,
    framestart integer,
    frameend integer,
    handle text
)
INHERITS (job);


--
-- TOC entry 2385 (class 1259 OID 17220)
-- Dependencies: 3015 3016 3017 3018 3019 3020 3021 3022 3023 3024 3025 3026 3027 3028 3029 3030 3 2236
-- Name: jobbatch; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobbatch (
    license text,
    fkeyjobparent integer,
    endedts timestamp without time zone,
    startedts timestamp without time zone,
    submittedts timestamp without time zone,
    maxhosts integer,
    environment text,
    runassubmitter boolean,
    framenth integer,
    framenthmode integer,
    exclusiveassignment boolean,
    hastaskprogress boolean,
    minmemory integer,
    cmd text,
    restartafterfinish boolean DEFAULT false,
    restartaftershutdown boolean,
    passslaveframesasparam boolean,
    disablewow64fsredirect boolean
)
INHERITS (job);


--
-- TOC entry 2386 (class 1259 OID 17242)
-- Dependencies: 3
-- Name: jobcannedbatch_keyjobcannedbatch_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobcannedbatch_keyjobcannedbatch_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4375 (class 0 OID 0)
-- Dependencies: 2386
-- Name: jobcannedbatch_keyjobcannedbatch_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('jobcannedbatch_keyjobcannedbatch_seq', 9, true);


--
-- TOC entry 2387 (class 1259 OID 17244)
-- Dependencies: 3031 3
-- Name: jobcannedbatch; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobcannedbatch (
    keyjobcannedbatch integer DEFAULT nextval('jobcannedbatch_keyjobcannedbatch_seq'::regclass) NOT NULL,
    name text,
    "group" text,
    cmd text,
    disablewow64fsredirect boolean
);


--
-- TOC entry 2388 (class 1259 OID 17251)
-- Dependencies: 3032 3033 3034 3035 3036 3037 3038 3039 3040 3041 3042 3043 3044 3045 3046 2236 3
-- Name: jobcinema4d; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobcinema4d (
    license text,
    fkeyjobparent integer,
    endedts timestamp without time zone,
    startedts timestamp without time zone,
    submittedts timestamp without time zone,
    loggingenabled boolean
)
INHERITS (job);


--
-- TOC entry 2389 (class 1259 OID 17272)
-- Dependencies: 3
-- Name: jobcommandhistory_keyjobcommandhistory_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobcommandhistory_keyjobcommandhistory_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4376 (class 0 OID 0)
-- Dependencies: 2389
-- Name: jobcommandhistory_keyjobcommandhistory_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('jobcommandhistory_keyjobcommandhistory_seq', 6283934, true);


--
-- TOC entry 2390 (class 1259 OID 17274)
-- Dependencies: 3047 3048 3049 3
-- Name: jobcommandhistory; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobcommandhistory (
    keyjobcommandhistory integer DEFAULT nextval('jobcommandhistory_keyjobcommandhistory_seq'::regclass) NOT NULL,
    stderr text DEFAULT ''::text,
    stdout text DEFAULT ''::text,
    command text,
    memory integer,
    fkeyjob integer,
    fkeyhost integer,
    fkeyhosthistory integer,
    iowait integer,
    realtime double precision,
    systime double precision,
    usertime double precision
);


--
-- TOC entry 2391 (class 1259 OID 17283)
-- Dependencies: 3
-- Name: jobdep_keyjobdep_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobdep_keyjobdep_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4377 (class 0 OID 0)
-- Dependencies: 2391
-- Name: jobdep_keyjobdep_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('jobdep_keyjobdep_seq', 60787, true);


--
-- TOC entry 2392 (class 1259 OID 17285)
-- Dependencies: 3050 3
-- Name: jobdep; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobdep (
    keyjobdep integer DEFAULT nextval('jobdep_keyjobdep_seq'::regclass) NOT NULL,
    fkeyjob integer,
    fkeydep integer
);


--
-- TOC entry 2393 (class 1259 OID 17289)
-- Dependencies: 3
-- Name: joberror_keyjoberror_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE joberror_keyjoberror_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4378 (class 0 OID 0)
-- Dependencies: 2393
-- Name: joberror_keyjoberror_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('joberror_keyjoberror_seq', 481234, true);


--
-- TOC entry 2394 (class 1259 OID 17291)
-- Dependencies: 3051 3052 3053 3
-- Name: joberror; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE joberror (
    keyjoberror integer DEFAULT nextval('joberror_keyjoberror_seq'::regclass) NOT NULL,
    fkeyhost integer,
    fkeyjob integer,
    frames text,
    message text,
    errortime integer,
    count integer DEFAULT 1,
    cleared boolean DEFAULT false,
    lastoccurrence timestamp without time zone,
    timeout boolean
);


--
-- TOC entry 2395 (class 1259 OID 17300)
-- Dependencies: 3
-- Name: joberrorhandler_keyjoberrorhandler_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE joberrorhandler_keyjoberrorhandler_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4379 (class 0 OID 0)
-- Dependencies: 2395
-- Name: joberrorhandler_keyjoberrorhandler_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('joberrorhandler_keyjoberrorhandler_seq', 1, false);


--
-- TOC entry 2396 (class 1259 OID 17302)
-- Dependencies: 3054 3
-- Name: joberrorhandler; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE joberrorhandler (
    keyjoberrorhandler integer DEFAULT nextval('joberrorhandler_keyjoberrorhandler_seq'::regclass) NOT NULL,
    fkeyjobtype integer,
    errorregex text,
    fkeyjoberrorhandlerscript integer
);


--
-- TOC entry 2397 (class 1259 OID 17309)
-- Dependencies: 3
-- Name: joberrorhandlerscript_keyjoberrorhandlerscript_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE joberrorhandlerscript_keyjoberrorhandlerscript_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4380 (class 0 OID 0)
-- Dependencies: 2397
-- Name: joberrorhandlerscript_keyjoberrorhandlerscript_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('joberrorhandlerscript_keyjoberrorhandlerscript_seq', 1, false);


--
-- TOC entry 2398 (class 1259 OID 17311)
-- Dependencies: 3055 3
-- Name: joberrorhandlerscript; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE joberrorhandlerscript (
    keyjoberrorhandlerscript integer DEFAULT nextval('joberrorhandlerscript_keyjoberrorhandlerscript_seq'::regclass) NOT NULL,
    script text
);


--
-- TOC entry 2399 (class 1259 OID 17318)
-- Dependencies: 3056 3057 3058 3059 3060 3061 3062 3063 3064 3065 3066 3067 3068 3069 3070 3 2236
-- Name: jobfusion; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobfusion (
    filename text,
    endedts timestamp without time zone,
    startedts timestamp without time zone,
    submittedts timestamp without time zone,
    maxhosts integer,
    framenth integer,
    framenthmode integer,
    exclusiveassignment boolean,
    hastaskprogress boolean,
    minmemory integer,
    frameend integer,
    framestart integer,
    framelist text,
    allframesassingletask boolean,
    outputcount integer
)
INHERITS (job);


--
-- TOC entry 2400 (class 1259 OID 17339)
-- Dependencies: 3071 3072 3073 3074 3075 3076 3077 3078 3079 3080 3081 3082 3083 3084 3085 3 2236
-- Name: jobfusionvideomaker; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobfusionvideomaker (
    framenth integer,
    framenthmode integer,
    exclusiveassignment boolean,
    hastaskprogress boolean,
    minmemory integer,
    codec text,
    inputframepath text,
    sequenceframestart integer,
    sequenceframeend integer,
    allframesassingletask boolean,
    framelist text,
    outputcount integer
)
INHERITS (job);


--
-- TOC entry 2401 (class 1259 OID 17360)
-- Dependencies: 3
-- Name: jobhistory_keyjobhistory_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobhistory_keyjobhistory_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4381 (class 0 OID 0)
-- Dependencies: 2401
-- Name: jobhistory_keyjobhistory_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('jobhistory_keyjobhistory_seq', 153262, true);


--
-- TOC entry 2402 (class 1259 OID 17362)
-- Dependencies: 3086 3
-- Name: jobhistory; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobhistory (
    keyjobhistory integer DEFAULT nextval('jobhistory_keyjobhistory_seq'::regclass) NOT NULL,
    fkeyjobhistorytype integer,
    fkeyjob integer,
    fkeyhost integer,
    fkeyuser integer,
    message text,
    created timestamp without time zone
);


--
-- TOC entry 2403 (class 1259 OID 17369)
-- Dependencies: 3
-- Name: jobhistorytype_keyjobhistorytype_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobhistorytype_keyjobhistorytype_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4382 (class 0 OID 0)
-- Dependencies: 2403
-- Name: jobhistorytype_keyjobhistorytype_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('jobhistorytype_keyjobhistorytype_seq', 1, false);


--
-- TOC entry 2404 (class 1259 OID 17371)
-- Dependencies: 3087 3
-- Name: jobhistorytype; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobhistorytype (
    keyjobhistorytype integer DEFAULT nextval('jobhistorytype_keyjobhistorytype_seq'::regclass) NOT NULL,
    type text
);


--
-- TOC entry 2405 (class 1259 OID 17378)
-- Dependencies: 3088 3089 3090 3091 3092 3093 3094 3095 3096 3097 3098 3099 3100 3101 3102 2236 3
-- Name: jobhoudinisim10; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobhoudinisim10 (
    slices integer,
    tracker text,
    framestart integer,
    frameend integer,
    nodename text
)
INHERITS (job);


--
-- TOC entry 2406 (class 1259 OID 17399)
-- Dependencies: 3103 3104 3105 3106 3107 3108 3109 3110 3111 3112 3113 3114 3115 3116 3117 3 2236
-- Name: jobmantra100; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobmantra100 (
    keyjobmantra100 integer NOT NULL,
    forceraytrace boolean,
    geocachesize integer,
    height integer,
    qualityflag text,
    renderquality integer,
    threads integer,
    width integer
)
INHERITS (job);


--
-- TOC entry 2407 (class 1259 OID 17420)
-- Dependencies: 2406 3
-- Name: jobmantra100_keyjobmantra100_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobmantra100_keyjobmantra100_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4383 (class 0 OID 0)
-- Dependencies: 2407
-- Name: jobmantra100_keyjobmantra100_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE jobmantra100_keyjobmantra100_seq OWNED BY jobmantra100.keyjobmantra100;


--
-- TOC entry 4384 (class 0 OID 0)
-- Dependencies: 2407
-- Name: jobmantra100_keyjobmantra100_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('jobmantra100_keyjobmantra100_seq', 336, true);


--
-- TOC entry 2408 (class 1259 OID 17422)
-- Dependencies: 3119 3120 3121 3122 3123 3124 3125 3126 3127 3128 3129 3130 3131 3132 3133 2236 3
-- Name: jobmantra95; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobmantra95 (
    keyjobmantra95 integer NOT NULL,
    forceraytrace boolean,
    geocachesize integer,
    height integer,
    qualityflag text,
    renderquality integer,
    threads integer,
    width integer
)
INHERITS (job);


--
-- TOC entry 2409 (class 1259 OID 17443)
-- Dependencies: 3 2408
-- Name: jobmantra95_keyjobmantra95_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobmantra95_keyjobmantra95_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4385 (class 0 OID 0)
-- Dependencies: 2409
-- Name: jobmantra95_keyjobmantra95_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE jobmantra95_keyjobmantra95_seq OWNED BY jobmantra95.keyjobmantra95;


--
-- TOC entry 4386 (class 0 OID 0)
-- Dependencies: 2409
-- Name: jobmantra95_keyjobmantra95_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('jobmantra95_keyjobmantra95_seq', 1, false);


--
-- TOC entry 2410 (class 1259 OID 17445)
-- Dependencies: 3135 3136 3137 3138 3139 3140 3141 3142 3143 3144 3145 3146 3147 3148 3149 3150 2236 3
-- Name: jobmax; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobmax (
    fkeyjobtype integer DEFAULT 6,
    filename text,
    license text,
    fkeyjobparent integer,
    loggingenabled boolean,
    environment text,
    framenth integer,
    framenthmode integer,
    camera text,
    elementfile text,
    fileoriginal text,
    flag_h integer,
    flag_v integer,
    flag_w integer,
    flag_x2 integer,
    flag_xa integer,
    flag_xc integer,
    flag_xd integer,
    flag_xe integer,
    flag_xf integer,
    flag_xh integer,
    flag_xk integer,
    flag_xn integer,
    flag_xo integer,
    flag_xp integer,
    flag_xv integer,
    frameend integer,
    framelist text,
    framestart integer,
    exrattributes text,
    exrchannels text,
    exrsavebitdepth integer,
    startupscript text
)
INHERITS (job);


--
-- TOC entry 2411 (class 1259 OID 17467)
-- Dependencies: 3151 3152 3153 3154 3155 3156 3157 3158 3159 3160 3161 3162 3163 3164 3165 3166 3 2410
-- Name: jobmax10; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobmax10 (
    exclusiveassignment boolean,
    hastaskprogress boolean,
    minmemory integer
)
INHERITS (jobmax);


--
-- TOC entry 2412 (class 1259 OID 17489)
-- Dependencies: 3167 3168 3169 3170 3171 3172 3173 3174 3175 3176 3177 3178 3179 3180 3181 3182 3 2410
-- Name: jobmax2009; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobmax2009 (
)
INHERITS (jobmax);


--
-- TOC entry 2413 (class 1259 OID 17511)
-- Dependencies: 3183 3184 3185 3186 3187 3188 3189 3190 3191 3192 3193 3194 3195 3196 3197 2236 3
-- Name: jobmax5; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobmax5 (
    rendertime integer,
    abversion text,
    filename text,
    fkeyjobparent integer,
    endedts timestamp without time zone,
    startedts timestamp without time zone,
    submittedts timestamp without time zone,
    maxhosts integer,
    environment text,
    framenth integer,
    framenthmode integer,
    camera text,
    fileoriginal text,
    flag_h integer,
    framestart integer,
    frameend integer,
    flag_w integer,
    flag_xv integer,
    flag_x2 integer,
    flag_xa integer,
    flag_xe integer,
    flag_xk integer,
    flag_xd integer,
    flag_xh integer,
    flag_xo integer,
    flag_xf integer,
    flag_xn integer,
    flag_xp integer,
    flag_xc integer,
    flag_v integer,
    elementfile text,
    framelist text
)
INHERITS (job);


--
-- TOC entry 2414 (class 1259 OID 17532)
-- Dependencies: 3198 3199 3200 3201 3202 3203 3204 3205 3206 3207 3208 3209 3210 3211 3212 3 2236
-- Name: jobmax6; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobmax6 (
    filename text,
    endedts timestamp without time zone,
    startedts timestamp without time zone,
    submittedts timestamp without time zone,
    maxhosts integer,
    framenth integer,
    camera text,
    elementfile text,
    fileoriginal text,
    flag_h integer,
    flag_v integer,
    flag_w integer,
    flag_x2 integer,
    flag_xa integer,
    flag_xc integer,
    flag_xd integer,
    flag_xe integer,
    flag_xf integer,
    flag_xh integer,
    flag_xk integer,
    flag_xn integer,
    flag_xo integer,
    flag_xp integer,
    flag_xv integer,
    frameend integer,
    framelist text,
    framestart integer
)
INHERITS (job);


--
-- TOC entry 2415 (class 1259 OID 17553)
-- Dependencies: 3213 3214 3215 3216 3217 3218 3219 3220 3221 3222 3223 3224 3225 3226 3227 3228 2410 3
-- Name: jobmax7; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobmax7 (
    license text,
    endedts timestamp without time zone,
    startedts timestamp without time zone,
    submittedts timestamp without time zone,
    environment text,
    checkfilemd5 boolean,
    uploadedfile boolean,
    framenthmode integer,
    exclusiveassignment boolean,
    hastaskprogress boolean,
    minmemory integer
)
INHERITS (jobmax);


--
-- TOC entry 2416 (class 1259 OID 17575)
-- Dependencies: 3229 3230 3231 3232 3233 3234 3235 3236 3237 3238 3239 3240 3241 3242 3243 3244 2410 3
-- Name: jobmax8; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobmax8 (
    fkeyjobparent integer,
    endedts timestamp without time zone,
    startedts timestamp without time zone,
    submittedts timestamp without time zone,
    framenthmode integer,
    exclusiveassignment boolean,
    hastaskprogress boolean,
    minmemory integer
)
INHERITS (jobmax);


--
-- TOC entry 2417 (class 1259 OID 17597)
-- Dependencies: 3245 3246 3247 3248 3249 3250 3251 3252 3253 3254 3255 3256 3257 3258 3259 3260 3 2410
-- Name: jobmax9; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobmax9 (
    endedts timestamp without time zone,
    startedts timestamp without time zone,
    submittedts timestamp without time zone,
    maxhosts integer,
    exclusiveassignment boolean,
    hastaskprogress boolean,
    minmemory integer
)
INHERITS (jobmax);


--
-- TOC entry 2418 (class 1259 OID 17619)
-- Dependencies: 3261 3262 3263 3264 3265 3266 3267 3268 3269 3270 3271 3272 3273 3274 3275 3276 3277 3 2236
-- Name: jobmaxscript; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobmaxscript (
    fkeyjobtype integer DEFAULT 3,
    filename text,
    endedts timestamp without time zone,
    startedts timestamp without time zone,
    submittedts timestamp without time zone,
    maxhosts integer,
    framenth integer,
    framenthmode integer,
    exclusiveassignment boolean,
    hastaskprogress boolean,
    minmemory integer,
    script text,
    maxtime integer,
    outputfiles text,
    filelist text,
    silent boolean DEFAULT true,
    maxversion text,
    runmax64 boolean
)
INHERITS (job);


--
-- TOC entry 2419 (class 1259 OID 17642)
-- Dependencies: 3278 3279 3280 3281 3282 3283 3284 3285 3286 3287 3288 3289 3290 3291 3292 2236 3
-- Name: jobmaya; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobmaya (
    fkeyjobparent integer,
    endedts timestamp without time zone,
    startedts timestamp without time zone,
    submittedts timestamp without time zone,
    loggingenabled boolean,
    environment text,
    checkfilemd5 boolean,
    uploadedfile boolean,
    framenth integer,
    framenthmode integer,
    exclusiveassignment boolean,
    hastaskprogress boolean,
    minmemory integer,
    framestart integer,
    frameend integer,
    camera text,
    renderer text,
    projectpath text,
    width integer,
    height integer,
    append text
)
INHERITS (job);


--
-- TOC entry 2420 (class 1259 OID 17663)
-- Dependencies: 3293 3294 3295 3296 3297 3298 3299 3300 3301 3302 3303 3304 3305 3306 3307 2419 3
-- Name: jobmaya2008; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobmaya2008 (
    exclusiveassignment boolean,
    hastaskprogress boolean,
    minmemory integer
)
INHERITS (jobmaya);


--
-- TOC entry 2421 (class 1259 OID 17684)
-- Dependencies: 3308 3309 3310 3311 3312 3313 3314 3315 3316 3317 3318 3319 3320 3321 3322 3 2419
-- Name: jobmaya2009; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobmaya2009 (
    framenthmode integer,
    exclusiveassignment boolean,
    hastaskprogress boolean,
    minmemory integer
)
INHERITS (jobmaya);


--
-- TOC entry 2422 (class 1259 OID 17705)
-- Dependencies: 3323 3324 3325 3326 3327 3328 3329 3330 3331 3332 3333 3334 3335 3336 3337 2419 3
-- Name: jobmaya7; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobmaya7 (
    maxhosts integer,
    framenthmode integer,
    exclusiveassignment boolean,
    hastaskprogress boolean,
    minmemory integer
)
INHERITS (jobmaya);


--
-- TOC entry 2423 (class 1259 OID 17726)
-- Dependencies: 3338 3339 3340 3341 3342 3343 3344 3345 3346 3347 3348 3349 3350 3351 3352 2419 3
-- Name: jobmaya8; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobmaya8 (
    endedts timestamp without time zone,
    startedts timestamp without time zone,
    submittedts timestamp without time zone,
    maxhosts integer,
    exclusiveassignment boolean,
    hastaskprogress boolean,
    minmemory integer
)
INHERITS (jobmaya);


--
-- TOC entry 2424 (class 1259 OID 17747)
-- Dependencies: 3353 3354 3355 3356 3357 3358 3359 3360 3361 3362 3363 3364 3365 3366 3367 2419 3
-- Name: jobmaya85; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobmaya85 (
    endedts timestamp without time zone,
    startedts timestamp without time zone,
    submittedts timestamp without time zone,
    maxhosts integer,
    framenthmode integer,
    exclusiveassignment boolean,
    hastaskprogress boolean,
    minmemory integer
)
INHERITS (jobmaya);


--
-- TOC entry 2425 (class 1259 OID 17768)
-- Dependencies: 3368 3369 3370 3371 3372 3373 3374 3375 3376 3377 3378 3379 3380 3381 3382 2419 3
-- Name: jobmentalray7; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobmentalray7 (
    maxmemory integer,
    fkeyjobparent integer,
    maxhosts integer,
    exclusiveassignment boolean,
    hastaskprogress boolean,
    minmemory integer
)
INHERITS (jobmaya);


--
-- TOC entry 2426 (class 1259 OID 17789)
-- Dependencies: 3383 3384 3385 3386 3387 3388 3389 3390 3391 3392 3393 3394 3395 3396 3397 2419 3
-- Name: jobmentalray8; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobmentalray8 (
    fkeyjobparent integer,
    maxhosts integer,
    framenthmode integer
)
INHERITS (jobmaya);


--
-- TOC entry 2427 (class 1259 OID 17810)
-- Dependencies: 3398 3399 3400 3401 3402 3403 3404 3405 3406 3407 3408 3409 3410 3411 3412 3 2419
-- Name: jobmentalray85; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobmentalray85 (
    maxhosts integer,
    loggingenabled boolean,
    framenthmode integer,
    exclusiveassignment boolean,
    hastaskprogress boolean,
    minmemory integer
)
INHERITS (jobmaya);


--
-- TOC entry 2428 (class 1259 OID 17831)
-- Dependencies: 3413 3414 3415 3416 3417 3418 3419 3420 3421 3422 3423 3424 3425 3426 3427 3 2236
-- Name: jobnuke51; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobnuke51 (
    framenth integer,
    framenthmode integer,
    exclusiveassignment boolean,
    hastaskprogress boolean,
    minmemory integer,
    framestart integer,
    frameend integer,
    outputcount integer
)
INHERITS (job);


--
-- TOC entry 2429 (class 1259 OID 17852)
-- Dependencies: 3428 3429 3430 3431 3432 3433 3434 3435 3436 3437 3438 3439 3440 3441 3442 2236 3
-- Name: jobnuke52; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobnuke52 (
    framestart integer,
    frameend integer,
    outputcount integer
)
INHERITS (job);


--
-- TOC entry 2430 (class 1259 OID 17873)
-- Dependencies: 3
-- Name: joboutput_keyjoboutput_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE joboutput_keyjoboutput_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4387 (class 0 OID 0)
-- Dependencies: 2430
-- Name: joboutput_keyjoboutput_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('joboutput_keyjoboutput_seq', 240026, true);


--
-- TOC entry 2431 (class 1259 OID 17875)
-- Dependencies: 3443 3
-- Name: joboutput; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE joboutput (
    keyjoboutput integer DEFAULT nextval('joboutput_keyjoboutput_seq'::regclass) NOT NULL,
    fkeyjob integer,
    name text,
    fkeyfiletracker integer
);


--
-- TOC entry 2432 (class 1259 OID 17882)
-- Dependencies: 3444 3445 3446 3447 3448 3449 3450 3451 3452 3453 3454 3455 3456 3457 3458 2236 3
-- Name: jobrealflow; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobrealflow (
    framenth integer,
    framenthmode integer,
    exclusiveassignment boolean,
    hastaskprogress boolean,
    minmemory integer,
    keyjobrealflow integer NOT NULL,
    framestart integer,
    frameend integer,
    simtype text,
    threads integer
)
INHERITS (job);


--
-- TOC entry 2433 (class 1259 OID 17903)
-- Dependencies: 3 2432
-- Name: jobrealflow_keyjobrealflow_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobrealflow_keyjobrealflow_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4388 (class 0 OID 0)
-- Dependencies: 2433
-- Name: jobrealflow_keyjobrealflow_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE jobrealflow_keyjobrealflow_seq OWNED BY jobrealflow.keyjobrealflow;


--
-- TOC entry 4389 (class 0 OID 0)
-- Dependencies: 2433
-- Name: jobrealflow_keyjobrealflow_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('jobrealflow_keyjobrealflow_seq', 1, false);


--
-- TOC entry 2434 (class 1259 OID 17905)
-- Dependencies: 3
-- Name: jobrenderman_keyjob_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobrenderman_keyjob_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4390 (class 0 OID 0)
-- Dependencies: 2434
-- Name: jobrenderman_keyjob_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('jobrenderman_keyjob_seq', 1, false);


--
-- TOC entry 2435 (class 1259 OID 17907)
-- Dependencies: 3460 3461 3
-- Name: jobrenderman; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobrenderman (
    keyjob integer DEFAULT nextval('jobrenderman_keyjob_seq'::regclass) NOT NULL,
    fkeyelement integer,
    fkeyhost integer,
    fkeyjobtype integer,
    fkeyproject integer,
    fkeyusr integer,
    hostlist text,
    job text,
    jobtime text,
    outputpath text,
    status text,
    submitted integer,
    started integer,
    ended integer,
    deleteoncomplete integer,
    hostsonjob integer,
    taskscount integer,
    tasksunassigned integer,
    tasksdone integer,
    tasksaveragetime integer,
    priority integer,
    errorcount integer,
    queueorder integer,
    packettype text,
    packetsize integer,
    queueeta integer,
    notifyonerror text,
    notifyoncomplete text,
    maxtasktime integer,
    cleaned integer,
    filesize integer,
    btinfohash text,
    filename text,
    filemd5sum text,
    fkeyjobstat integer,
    username text,
    domain text,
    password text,
    stats text,
    currentmapserverweight double precision,
    tasksassigned integer,
    tasksbusy integer,
    prioritizeoutertasks boolean,
    outertasksassigned boolean,
    lastnotifiederrorcount integer,
    taskscancelled integer,
    taskssuspended integer,
    health double precision,
    maxloadtime integer,
    framestart integer,
    frameend integer,
    version text,
    license text,
    maxmemory integer,
    fkeyjobparent integer,
    endedts timestamp without time zone,
    startedts timestamp without time zone,
    submittedts timestamp without time zone,
    maxhosts integer,
    personalpriority integer DEFAULT 50,
    loggingenabled boolean,
    environment text,
    checkfilemd5 boolean,
    runassubmitter boolean,
    uploadedfile boolean,
    framenth integer,
    framenthmode integer,
    exclusiveassignment boolean,
    hastaskprogress boolean,
    minmemory integer
);


--
-- TOC entry 2436 (class 1259 OID 17915)
-- Dependencies: 3
-- Name: jobribgen_keyjob_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobribgen_keyjob_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4391 (class 0 OID 0)
-- Dependencies: 2436
-- Name: jobribgen_keyjob_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('jobribgen_keyjob_seq', 1, true);


--
-- TOC entry 2437 (class 1259 OID 17917)
-- Dependencies: 3462 3463 3
-- Name: jobribgen; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobribgen (
    keyjob integer DEFAULT nextval('jobribgen_keyjob_seq'::regclass) NOT NULL,
    fkeyelement integer,
    fkeyhost integer,
    fkeyjobtype integer,
    fkeyproject integer,
    fkeyusr integer,
    hostlist text,
    job text,
    jobtime text,
    outputpath text,
    status text,
    submitted integer,
    started integer,
    ended integer,
    deleteoncomplete integer,
    hostsonjob integer,
    taskscount integer,
    tasksunassigned integer,
    tasksdone integer,
    tasksaveragetime integer,
    priority integer,
    errorcount integer,
    queueorder integer,
    packettype text,
    packetsize integer,
    queueeta integer,
    notifyonerror text,
    notifyoncomplete text,
    maxtasktime integer,
    cleaned integer,
    filesize integer,
    btinfohash text,
    filename text,
    filemd5sum text,
    fkeyjobstat integer,
    username text,
    domain text,
    password text,
    stats text,
    currentmapserverweight double precision,
    tasksassigned integer,
    tasksbusy integer,
    prioritizeoutertasks boolean,
    outertasksassigned boolean,
    lastnotifiederrorcount integer,
    taskscancelled integer,
    taskssuspended integer,
    health double precision,
    maxloadtime integer,
    framestart integer,
    frameend integer,
    version text,
    license text,
    maxmemory integer,
    fkeyjobparent integer,
    endedts timestamp without time zone,
    startedts timestamp without time zone,
    submittedts timestamp without time zone,
    maxhosts integer,
    personalpriority integer DEFAULT 50,
    loggingenabled boolean,
    environment text,
    checkfilemd5 boolean,
    runassubmitter boolean,
    uploadedfile boolean,
    framenth integer,
    framenthmode integer,
    exclusiveassignment boolean,
    hastaskprogress boolean,
    minmemory integer
);


--
-- TOC entry 2438 (class 1259 OID 17925)
-- Dependencies: 3
-- Name: jobservice_keyjobservice_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobservice_keyjobservice_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4392 (class 0 OID 0)
-- Dependencies: 2438
-- Name: jobservice_keyjobservice_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('jobservice_keyjobservice_seq', 247128, true);


--
-- TOC entry 2439 (class 1259 OID 17927)
-- Dependencies: 3464 3
-- Name: jobservice; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobservice (
    keyjobservice integer DEFAULT nextval('jobservice_keyjobservice_seq'::regclass) NOT NULL,
    fkeyjob integer,
    fkeyservice integer
);


--
-- TOC entry 2440 (class 1259 OID 17931)
-- Dependencies: 3465 3466 3467 3468 3469 3470 3471 3472 3473 3474 3475 3476 3477 3478 3479 2236 3
-- Name: jobshake; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobshake (
    packettype text DEFAULT 'sequential'::text,
    license text,
    fkeyjobparent integer,
    exclusiveassignment boolean,
    hastaskprogress boolean,
    minmemory integer,
    framestart integer,
    frameend integer,
    codec text,
    slatepath text,
    framerange text
)
INHERITS (job);


--
-- TOC entry 2441 (class 1259 OID 17952)
-- Dependencies: 3480 3481 3482 3483 3484 3485 3486 3487 3488 3489 3490 3491 3492 3493 3494 2236 3
-- Name: jobspool; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobspool (
    flowfile text,
    flowpath text,
    holdend integer,
    inputfile text,
    inputpath text,
    outputfile text,
    inputstart integer,
    inputend integer,
    holdstart integer,
    importmode integer,
    keepinqueue integer,
    lastscanned integer,
    jobpath text
)
INHERITS (job);


--
-- TOC entry 2442 (class 1259 OID 17973)
-- Dependencies: 3
-- Name: jobstat_keyjobstat_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobstat_keyjobstat_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4393 (class 0 OID 0)
-- Dependencies: 2442
-- Name: jobstat_keyjobstat_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('jobstat_keyjobstat_seq', 270255, true);


--
-- TOC entry 2443 (class 1259 OID 17975)
-- Dependencies: 3495 3496 3497 3498 3499 3
-- Name: jobstat; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobstat (
    keyjobstat integer DEFAULT nextval('jobstat_keyjobstat_seq'::regclass) NOT NULL,
    fkeyelement integer,
    fkeyproject integer,
    fkeyusr integer,
    pass text,
    taskcount integer,
    taskscompleted integer DEFAULT 0,
    tasktime integer DEFAULT 0,
    started timestamp without time zone,
    ended timestamp without time zone,
    name text,
    errorcount integer DEFAULT 0,
    mintasktime interval,
    maxtasktime interval,
    avgtasktime interval,
    totaltasktime interval,
    minerrortime interval,
    maxerrortime interval,
    avgerrortime interval,
    totalerrortime interval,
    mincopytime interval,
    maxcopytime interval,
    avgcopytime interval,
    totalcopytime interval,
    copycount integer,
    minloadtime interval,
    maxloadtime interval,
    avgloadtime interval,
    totalloadtime interval,
    loadcount integer,
    submitted timestamp without time zone DEFAULT now(),
    totalcputime integer,
    mincputime integer,
    maxcputime integer,
    avgcputime integer,
    minmemory integer,
    maxmemory integer,
    avgmemory integer,
    minefficiency double precision,
    maxefficiency double precision,
    avgefficiency double precision,
    totalbytesread integer,
    minbytesread integer,
    maxbytesread integer,
    avgbytesread integer,
    totalopsread integer,
    minopsread integer,
    maxopsread integer,
    avgopsread integer,
    totalbyteswrite integer,
    minbyteswrite integer,
    maxbyteswrite integer,
    avgbyteswrite integer,
    totalopswrite integer,
    minopswrite integer,
    maxopswrite integer,
    avgopswrite integer,
    totaliowait integer,
    miniowait integer,
    maxiowait integer,
    avgiowait integer
);


--
-- TOC entry 2444 (class 1259 OID 17986)
-- Dependencies: 3
-- Name: jobstatus_keyjobstatus_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobstatus_keyjobstatus_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4394 (class 0 OID 0)
-- Dependencies: 2444
-- Name: jobstatus_keyjobstatus_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('jobstatus_keyjobstatus_seq', 231112, true);


--
-- TOC entry 2445 (class 1259 OID 17988)
-- Dependencies: 3500 3501 3502 3503 3504 3505 3506 3507 3508 3509 3
-- Name: jobstatus; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobstatus (
    keyjobstatus integer DEFAULT nextval('jobstatus_keyjobstatus_seq'::regclass) NOT NULL,
    hostsonjob integer DEFAULT 0,
    fkeyjob integer,
    tasksunassigned integer DEFAULT 0,
    taskscount integer DEFAULT 0,
    tasksdone integer DEFAULT 0,
    taskscancelled integer DEFAULT 0,
    taskssuspended integer DEFAULT 0,
    tasksassigned integer DEFAULT 0,
    tasksbusy integer DEFAULT 0,
    tasksaveragetime integer,
    health double precision,
    joblastupdated timestamp without time zone,
    errorcount integer DEFAULT 0,
    lastnotifiederrorcount integer,
    averagememory integer
);


--
-- TOC entry 2446 (class 1259 OID 18001)
-- Dependencies: 3510 3511 3512 3513 3514 3515 3516 3517 3518 3519 3520 3521 3522 3523 3524 3 2236
-- Name: jobsync; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobsync (
    fkeyjobparent integer,
    endedts timestamp without time zone,
    startedts timestamp without time zone,
    submittedts timestamp without time zone,
    maxhosts integer,
    framenth integer,
    framenthmode integer,
    direction text,
    append text,
    filesfrom text
)
INHERITS (job);


--
-- TOC entry 2447 (class 1259 OID 18022)
-- Dependencies: 3525 3526 3527 3528 3529 3530 3531 3532 3533 3534 3535 3536 3537 3538 3539 2236 3
-- Name: jobsystem; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobsystem (
)
INHERITS (job);


--
-- TOC entry 2448 (class 1259 OID 18043)
-- Dependencies: 3
-- Name: jobtaskassignment; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobtaskassignment (
    keyjobtaskassignment integer NOT NULL,
    fkeyjobassignment integer,
    memory integer,
    started timestamp without time zone,
    ended timestamp without time zone,
    fkeyjobassignmentstatus integer,
    fkeyjobtask integer,
    fkeyjoberror integer
);


--
-- TOC entry 2449 (class 1259 OID 18046)
-- Dependencies: 2448 3
-- Name: jobtaskassignment_keyjobtaskassignment_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobtaskassignment_keyjobtaskassignment_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4395 (class 0 OID 0)
-- Dependencies: 2449
-- Name: jobtaskassignment_keyjobtaskassignment_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE jobtaskassignment_keyjobtaskassignment_seq OWNED BY jobtaskassignment.keyjobtaskassignment;


--
-- TOC entry 4396 (class 0 OID 0)
-- Dependencies: 2449
-- Name: jobtaskassignment_keyjobtaskassignment_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('jobtaskassignment_keyjobtaskassignment_seq', 1911282, true);


--
-- TOC entry 2450 (class 1259 OID 18048)
-- Dependencies: 3
-- Name: jobtypemapping_keyjobtypemapping_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobtypemapping_keyjobtypemapping_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4397 (class 0 OID 0)
-- Dependencies: 2450
-- Name: jobtypemapping_keyjobtypemapping_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('jobtypemapping_keyjobtypemapping_seq', 1, false);


--
-- TOC entry 2451 (class 1259 OID 18050)
-- Dependencies: 3541 3
-- Name: jobtypemapping; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobtypemapping (
    keyjobtypemapping integer DEFAULT nextval('jobtypemapping_keyjobtypemapping_seq'::regclass) NOT NULL,
    fkeyjobtype integer,
    fkeymapping integer
);


--
-- TOC entry 2452 (class 1259 OID 18054)
-- Dependencies: 3542 3543 3544 3545 3546 3547 3548 3549 3550 3551 3552 3553 3554 3555 3556 2236 3
-- Name: jobxsi; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobxsi (
    maxhosts integer,
    framenth integer,
    framestart integer,
    frameend integer,
    framelist text,
    pass text,
    flag_w integer,
    flag_h integer,
    deformmotionblur boolean,
    motionblur boolean,
    renderer text,
    resolutionx integer,
    resolutiony integer
)
INHERITS (job);


--
-- TOC entry 2453 (class 1259 OID 18075)
-- Dependencies: 3557 3558 3559 3560 3561 3562 3563 3564 3565 3566 3567 3568 3569 3570 3571 3 2236
-- Name: jobxsiscript; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobxsiscript (
    framenth integer,
    framenthmode integer,
    exclusiveassignment boolean,
    hastaskprogress boolean,
    minmemory integer,
    framestart integer,
    frameend integer,
    scriptrequiresui boolean,
    scriptfile text,
    xsifile text,
    scriptmethod text,
    framelist text
)
INHERITS (job);


--
-- TOC entry 2454 (class 1259 OID 18096)
-- Dependencies: 3
-- Name: license_keylicense_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE license_keylicense_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4398 (class 0 OID 0)
-- Dependencies: 2454
-- Name: license_keylicense_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('license_keylicense_seq', 17, true);


--
-- TOC entry 2455 (class 1259 OID 18098)
-- Dependencies: 3572 3573 3574 3
-- Name: license; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE license (
    keylicense integer DEFAULT nextval('license_keylicense_seq'::regclass) NOT NULL,
    license text,
    fkeyhost integer,
    fkeysoftware integer,
    total integer,
    available integer,
    reserved integer,
    inuse integer,
    CONSTRAINT check_licenses_available CHECK ((available >= 0)),
    CONSTRAINT check_licenses_total CHECK ((available <= total))
);


--
-- TOC entry 2456 (class 1259 OID 18107)
-- Dependencies: 3
-- Name: location_keylocation_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE location_keylocation_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4399 (class 0 OID 0)
-- Dependencies: 2456
-- Name: location_keylocation_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('location_keylocation_seq', 3, true);


--
-- TOC entry 2457 (class 1259 OID 18109)
-- Dependencies: 3575 3
-- Name: location; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE location (
    keylocation integer DEFAULT nextval('location_keylocation_seq'::regclass) NOT NULL,
    name text
);


--
-- TOC entry 2458 (class 1259 OID 18116)
-- Dependencies: 3
-- Name: mapping_keymapping_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mapping_keymapping_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4400 (class 0 OID 0)
-- Dependencies: 2458
-- Name: mapping_keymapping_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('mapping_keymapping_seq', 1, false);


--
-- TOC entry 2459 (class 1259 OID 18118)
-- Dependencies: 3576 3
-- Name: mapping; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE mapping (
    keymapping integer DEFAULT nextval('mapping_keymapping_seq'::regclass) NOT NULL,
    fkeyhost integer,
    share text,
    mount text,
    fkeymappingtype integer,
    description text
);


--
-- TOC entry 2460 (class 1259 OID 18125)
-- Dependencies: 3
-- Name: mappingtype_keymappingtype_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mappingtype_keymappingtype_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4401 (class 0 OID 0)
-- Dependencies: 2460
-- Name: mappingtype_keymappingtype_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('mappingtype_keymappingtype_seq', 1, false);


--
-- TOC entry 2461 (class 1259 OID 18127)
-- Dependencies: 3577 3
-- Name: mappingtype; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE mappingtype (
    keymappingtype integer DEFAULT nextval('mappingtype_keymappingtype_seq'::regclass) NOT NULL,
    name text
);


--
-- TOC entry 2462 (class 1259 OID 18134)
-- Dependencies: 3
-- Name: methodperms_keymethodperms_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE methodperms_keymethodperms_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4402 (class 0 OID 0)
-- Dependencies: 2462
-- Name: methodperms_keymethodperms_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('methodperms_keymethodperms_seq', 1, false);


--
-- TOC entry 2463 (class 1259 OID 18136)
-- Dependencies: 3578 3
-- Name: methodperms; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE methodperms (
    keymethodperms integer DEFAULT nextval('methodperms_keymethodperms_seq'::regclass) NOT NULL,
    method text,
    users text,
    groups text,
    fkeyproject integer
);


--
-- TOC entry 2464 (class 1259 OID 18143)
-- Dependencies: 3
-- Name: notification_keynotification_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notification_keynotification_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4403 (class 0 OID 0)
-- Dependencies: 2464
-- Name: notification_keynotification_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('notification_keynotification_seq', 7047, true);


--
-- TOC entry 2465 (class 1259 OID 18145)
-- Dependencies: 3579 3
-- Name: notification; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE notification (
    keynotification integer DEFAULT nextval('notification_keynotification_seq'::regclass) NOT NULL,
    created timestamp without time zone,
    subject text,
    message text,
    component text,
    event text,
    routed timestamp without time zone,
    fkeyelement integer
);


--
-- TOC entry 2466 (class 1259 OID 18152)
-- Dependencies: 3
-- Name: notificationdestination_keynotificationdestination_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notificationdestination_keynotificationdestination_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4404 (class 0 OID 0)
-- Dependencies: 2466
-- Name: notificationdestination_keynotificationdestination_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('notificationdestination_keynotificationdestination_seq', 1, false);


--
-- TOC entry 2467 (class 1259 OID 18154)
-- Dependencies: 3580 3
-- Name: notificationdestination; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE notificationdestination (
    keynotificationdestination integer DEFAULT nextval('notificationdestination_keynotificationdestination_seq'::regclass) NOT NULL,
    fkeynotification integer,
    fkeynotificationmethod integer,
    delivered timestamp without time zone,
    destination text,
    fkeyuser integer,
    routed timestamp without time zone
);


--
-- TOC entry 2468 (class 1259 OID 18161)
-- Dependencies: 3
-- Name: notificationmethod_keynotificationmethod_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notificationmethod_keynotificationmethod_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4405 (class 0 OID 0)
-- Dependencies: 2468
-- Name: notificationmethod_keynotificationmethod_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('notificationmethod_keynotificationmethod_seq', 1, false);


--
-- TOC entry 2469 (class 1259 OID 18163)
-- Dependencies: 3581 3
-- Name: notificationmethod; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE notificationmethod (
    keynotificationmethod integer DEFAULT nextval('notificationmethod_keynotificationmethod_seq'::regclass) NOT NULL,
    name text
);


--
-- TOC entry 2470 (class 1259 OID 18170)
-- Dependencies: 3
-- Name: notificationroute_keynotificationuserroute_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notificationroute_keynotificationuserroute_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4406 (class 0 OID 0)
-- Dependencies: 2470
-- Name: notificationroute_keynotificationuserroute_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('notificationroute_keynotificationuserroute_seq', 1, false);


--
-- TOC entry 2471 (class 1259 OID 18172)
-- Dependencies: 3582 3
-- Name: notificationroute; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE notificationroute (
    keynotificationuserroute integer DEFAULT nextval('notificationroute_keynotificationuserroute_seq'::regclass) NOT NULL,
    eventmatch text,
    componentmatch text,
    fkeyuser integer,
    subjectmatch text,
    messagematch text,
    actions text,
    priority integer,
    fkeyelement integer,
    routeassetdescendants boolean
);


--
-- TOC entry 2472 (class 1259 OID 18179)
-- Dependencies: 3
-- Name: notify_keynotify_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notify_keynotify_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4407 (class 0 OID 0)
-- Dependencies: 2472
-- Name: notify_keynotify_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('notify_keynotify_seq', 1, false);


--
-- TOC entry 2473 (class 1259 OID 18181)
-- Dependencies: 3583 3
-- Name: notify; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE notify (
    keynotify integer DEFAULT nextval('notify_keynotify_seq'::regclass) NOT NULL,
    notify text,
    fkeyusr integer,
    fkeysyslogrealm integer,
    severitymask text,
    starttime timestamp without time zone,
    endtime timestamp without time zone,
    threshhold integer,
    notifyclass text,
    notifymethod text,
    fkeynotifymethod integer,
    threshold integer
);


--
-- TOC entry 2474 (class 1259 OID 18188)
-- Dependencies: 3
-- Name: notifymethod_keynotifymethod_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notifymethod_keynotifymethod_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4408 (class 0 OID 0)
-- Dependencies: 2474
-- Name: notifymethod_keynotifymethod_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('notifymethod_keynotifymethod_seq', 1, false);


--
-- TOC entry 2475 (class 1259 OID 18190)
-- Dependencies: 3584 3
-- Name: notifymethod; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE notifymethod (
    keynotifymethod integer DEFAULT nextval('notifymethod_keynotifymethod_seq'::regclass) NOT NULL,
    notifymethod text
);


--
-- TOC entry 2476 (class 1259 OID 18197)
-- Dependencies: 3
-- Name: notifysent_keynotifysent_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notifysent_keynotifysent_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4409 (class 0 OID 0)
-- Dependencies: 2476
-- Name: notifysent_keynotifysent_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('notifysent_keynotifysent_seq', 1, false);


--
-- TOC entry 2477 (class 1259 OID 18199)
-- Dependencies: 3585 3
-- Name: notifysent; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE notifysent (
    keynotifysent integer DEFAULT nextval('notifysent_keynotifysent_seq'::regclass) NOT NULL,
    fkeynotify integer,
    fkeysyslog integer
);


--
-- TOC entry 2478 (class 1259 OID 18203)
-- Dependencies: 3
-- Name: notifywho_keynotifywho_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notifywho_keynotifywho_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4410 (class 0 OID 0)
-- Dependencies: 2478
-- Name: notifywho_keynotifywho_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('notifywho_keynotifywho_seq', 1, false);


--
-- TOC entry 2479 (class 1259 OID 18205)
-- Dependencies: 3586 3
-- Name: notifywho; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE notifywho (
    keynotifywho integer DEFAULT nextval('notifywho_keynotifywho_seq'::regclass) NOT NULL,
    class text,
    fkeynotify integer,
    fkeyusr integer,
    fkey integer
);


--
-- TOC entry 2480 (class 1259 OID 18212)
-- Dependencies: 3
-- Name: package; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE package (
    keypackage integer NOT NULL,
    version integer,
    fkeystatus integer
);


--
-- TOC entry 2481 (class 1259 OID 18215)
-- Dependencies: 3 2480
-- Name: package_keypackage_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE package_keypackage_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4411 (class 0 OID 0)
-- Dependencies: 2481
-- Name: package_keypackage_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE package_keypackage_seq OWNED BY package.keypackage;


--
-- TOC entry 4412 (class 0 OID 0)
-- Dependencies: 2481
-- Name: package_keypackage_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('package_keypackage_seq', 1, false);


--
-- TOC entry 2482 (class 1259 OID 18217)
-- Dependencies: 3
-- Name: packageoutput; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE packageoutput (
    keypackageoutput integer NOT NULL,
    fkeyasset integer
);


--
-- TOC entry 2483 (class 1259 OID 18220)
-- Dependencies: 3 2482
-- Name: packageoutput_keypackageoutput_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE packageoutput_keypackageoutput_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4413 (class 0 OID 0)
-- Dependencies: 2483
-- Name: packageoutput_keypackageoutput_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE packageoutput_keypackageoutput_seq OWNED BY packageoutput.keypackageoutput;


--
-- TOC entry 4414 (class 0 OID 0)
-- Dependencies: 2483
-- Name: packageoutput_keypackageoutput_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('packageoutput_keypackageoutput_seq', 1, false);


--
-- TOC entry 2484 (class 1259 OID 18222)
-- Dependencies: 3
-- Name: pathsynctarget_keypathsynctarget_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pathsynctarget_keypathsynctarget_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4415 (class 0 OID 0)
-- Dependencies: 2484
-- Name: pathsynctarget_keypathsynctarget_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('pathsynctarget_keypathsynctarget_seq', 1, false);


--
-- TOC entry 2485 (class 1259 OID 18224)
-- Dependencies: 3589 3
-- Name: pathsynctarget; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pathsynctarget (
    keypathsynctarget integer DEFAULT nextval('pathsynctarget_keypathsynctarget_seq'::regclass) NOT NULL,
    fkeypathtracker integer,
    fkeyprojectstorage integer
);


--
-- TOC entry 2486 (class 1259 OID 18228)
-- Dependencies: 3
-- Name: pathtemplate_keypathtemplate_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pathtemplate_keypathtemplate_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4416 (class 0 OID 0)
-- Dependencies: 2486
-- Name: pathtemplate_keypathtemplate_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('pathtemplate_keypathtemplate_seq', 1, false);


--
-- TOC entry 2487 (class 1259 OID 18230)
-- Dependencies: 3590 3
-- Name: pathtemplate; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pathtemplate (
    keypathtemplate integer DEFAULT nextval('pathtemplate_keypathtemplate_seq'::regclass) NOT NULL,
    name text,
    pathtemplate text,
    pathre text,
    filenametemplate text,
    filenamere text,
    version integer,
    pythoncode text
);


--
-- TOC entry 2488 (class 1259 OID 18237)
-- Dependencies: 3
-- Name: pathtracker_keypathtracker_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pathtracker_keypathtracker_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4417 (class 0 OID 0)
-- Dependencies: 2488
-- Name: pathtracker_keypathtracker_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('pathtracker_keypathtracker_seq', 1, false);


--
-- TOC entry 2489 (class 1259 OID 18239)
-- Dependencies: 3591 3
-- Name: pathtracker; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pathtracker (
    keypathtracker integer DEFAULT nextval('pathtracker_keypathtracker_seq'::regclass) NOT NULL,
    fkeyelement integer,
    path text,
    fkeypathtemplate integer,
    fkeyprojectstorage integer,
    storagename text
);


--
-- TOC entry 2490 (class 1259 OID 18246)
-- Dependencies: 3
-- Name: permission_keypermission_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE permission_keypermission_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4418 (class 0 OID 0)
-- Dependencies: 2490
-- Name: permission_keypermission_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('permission_keypermission_seq', 2, true);


--
-- TOC entry 2491 (class 1259 OID 18248)
-- Dependencies: 3592 3
-- Name: permission; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE permission (
    keypermission integer DEFAULT nextval('permission_keypermission_seq'::regclass) NOT NULL,
    methodpattern text,
    fkeyusr integer,
    permission text,
    fkeygrp integer,
    class text
);


--
-- TOC entry 2492 (class 1259 OID 18255)
-- Dependencies: 3
-- Name: phoneno_keyphoneno_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE phoneno_keyphoneno_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4419 (class 0 OID 0)
-- Dependencies: 2492
-- Name: phoneno_keyphoneno_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('phoneno_keyphoneno_seq', 1, false);


--
-- TOC entry 2493 (class 1259 OID 18257)
-- Dependencies: 3593 3
-- Name: phoneno; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE phoneno (
    keyphoneno integer DEFAULT nextval('phoneno_keyphoneno_seq'::regclass) NOT NULL,
    phoneno text,
    fkeyphonetype integer,
    fkeyemployee integer,
    domain text
);


--
-- TOC entry 2494 (class 1259 OID 18264)
-- Dependencies: 3
-- Name: phonetype_keyphonetype_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE phonetype_keyphonetype_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4420 (class 0 OID 0)
-- Dependencies: 2494
-- Name: phonetype_keyphonetype_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('phonetype_keyphonetype_seq', 1, false);


--
-- TOC entry 2495 (class 1259 OID 18266)
-- Dependencies: 3594 3
-- Name: phonetype; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE phonetype (
    keyphonetype integer DEFAULT nextval('phonetype_keyphonetype_seq'::regclass) NOT NULL,
    phonetype text
);


--
-- TOC entry 2496 (class 1259 OID 18273)
-- Dependencies: 3595 2262 3
-- Name: project; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE project (
    datestart date,
    icon bytea,
    compoutputdrive text,
    datedue date,
    filetype text,
    fkeyclient integer,
    notes text,
    renderoutputdrive text,
    script text,
    shortname text,
    wipdrive text,
    projectnumber integer,
    frames integer,
    nda integer,
    dayrate double precision,
    usefilecreation integer,
    dailydrive text,
    lastscanned timestamp without time zone,
    fkeyprojectstatus integer,
    assburnerweight double precision,
    project text,
    fps integer,
    resolution text,
    resolutionwidth integer,
    resolutionheight integer,
    archived integer,
    deliverymedium text,
    renderpixelaspect text
)
INHERITS (element);


--
-- TOC entry 2497 (class 1259 OID 18280)
-- Dependencies: 3
-- Name: projectresolution_keyprojectresolution_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE projectresolution_keyprojectresolution_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4421 (class 0 OID 0)
-- Dependencies: 2497
-- Name: projectresolution_keyprojectresolution_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('projectresolution_keyprojectresolution_seq', 3, true);


--
-- TOC entry 2498 (class 1259 OID 18282)
-- Dependencies: 3596 3
-- Name: projectresolution; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE projectresolution (
    keyprojectresolution integer DEFAULT nextval('projectresolution_keyprojectresolution_seq'::regclass) NOT NULL,
    deliveryformat text,
    fkeyproject integer,
    height integer,
    outputformat text,
    projectresolution text,
    width integer,
    pixelaspect double precision,
    fps integer
);


--
-- TOC entry 2499 (class 1259 OID 18289)
-- Dependencies: 3
-- Name: projectstatus_keyprojectstatus_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE projectstatus_keyprojectstatus_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4422 (class 0 OID 0)
-- Dependencies: 2499
-- Name: projectstatus_keyprojectstatus_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('projectstatus_keyprojectstatus_seq', 6, true);


--
-- TOC entry 2500 (class 1259 OID 18291)
-- Dependencies: 3597 3
-- Name: projectstatus; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE projectstatus (
    keyprojectstatus integer DEFAULT nextval('projectstatus_keyprojectstatus_seq'::regclass) NOT NULL,
    projectstatus text,
    chronology integer
);


--
-- TOC entry 2501 (class 1259 OID 18298)
-- Dependencies: 3
-- Name: projectstorage_keyprojectstorage_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE projectstorage_keyprojectstorage_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4423 (class 0 OID 0)
-- Dependencies: 2501
-- Name: projectstorage_keyprojectstorage_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('projectstorage_keyprojectstorage_seq', 34, true);


--
-- TOC entry 2502 (class 1259 OID 18300)
-- Dependencies: 3598 3
-- Name: projectstorage; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE projectstorage (
    keyprojectstorage integer DEFAULT nextval('projectstorage_keyprojectstorage_seq'::regclass) NOT NULL,
    fkeyproject integer NOT NULL,
    name text NOT NULL,
    location text NOT NULL,
    storagename text,
    "default" boolean,
    fkeyhost integer
);


--
-- TOC entry 2503 (class 1259 OID 18307)
-- Dependencies: 3
-- Name: projecttempo; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE projecttempo (
    fkeyproject integer,
    tempo double precision
);


--
-- TOC entry 2504 (class 1259 OID 18310)
-- Dependencies: 3599 2327 3
-- Name: rangefiletracker; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rangefiletracker (
    filenametemplate text NOT NULL,
    framestart integer,
    frameend integer,
    fkeyresolution integer,
    renderelement text
)
INHERITS (filetracker);


--
-- TOC entry 2505 (class 1259 OID 18317)
-- Dependencies: 3
-- Name: renderframe_keyrenderframe_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE renderframe_keyrenderframe_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4424 (class 0 OID 0)
-- Dependencies: 2505
-- Name: renderframe_keyrenderframe_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('renderframe_keyrenderframe_seq', 1, false);


--
-- TOC entry 2506 (class 1259 OID 18319)
-- Dependencies: 3600 3
-- Name: renderframe; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE renderframe (
    keyrenderframe integer DEFAULT nextval('renderframe_keyrenderframe_seq'::regclass) NOT NULL,
    fkeyshot integer,
    frame integer,
    fkeyresolution integer,
    status text
);


--
-- TOC entry 2507 (class 1259 OID 18326)
-- Dependencies: 3
-- Name: schedule_keyschedule_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE schedule_keyschedule_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4425 (class 0 OID 0)
-- Dependencies: 2507
-- Name: schedule_keyschedule_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('schedule_keyschedule_seq', 1, false);


--
-- TOC entry 2508 (class 1259 OID 18328)
-- Dependencies: 3601 3
-- Name: schedule; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schedule (
    keyschedule integer DEFAULT nextval('schedule_keyschedule_seq'::regclass) NOT NULL,
    fkeyuser integer,
    date date NOT NULL,
    starthour integer,
    hours integer,
    fkeyelement integer,
    fkeyassettype integer,
    fkeycreatedbyuser integer,
    duration interval,
    starttime time without time zone
);


--
-- TOC entry 2509 (class 1259 OID 18332)
-- Dependencies: 3
-- Name: serverfileaction; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE serverfileaction (
    keyserverfileaction integer NOT NULL,
    fkeyserverfileactionstatus integer,
    fkeyserverfileactiontype integer,
    fkeyhost integer,
    destpath text,
    errormessage text,
    sourcepath text
);


--
-- TOC entry 2510 (class 1259 OID 18338)
-- Dependencies: 2509 3
-- Name: serverfileaction_keyserverfileaction_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE serverfileaction_keyserverfileaction_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4426 (class 0 OID 0)
-- Dependencies: 2510
-- Name: serverfileaction_keyserverfileaction_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE serverfileaction_keyserverfileaction_seq OWNED BY serverfileaction.keyserverfileaction;


--
-- TOC entry 4427 (class 0 OID 0)
-- Dependencies: 2510
-- Name: serverfileaction_keyserverfileaction_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('serverfileaction_keyserverfileaction_seq', 1, false);


--
-- TOC entry 2511 (class 1259 OID 18340)
-- Dependencies: 3
-- Name: serverfileactionstatus; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE serverfileactionstatus (
    keyserverfileactionstatus integer NOT NULL,
    status text,
    name text
);


--
-- TOC entry 2512 (class 1259 OID 18346)
-- Dependencies: 2511 3
-- Name: serverfileactionstatus_keyserverfileactionstatus_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE serverfileactionstatus_keyserverfileactionstatus_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4428 (class 0 OID 0)
-- Dependencies: 2512
-- Name: serverfileactionstatus_keyserverfileactionstatus_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE serverfileactionstatus_keyserverfileactionstatus_seq OWNED BY serverfileactionstatus.keyserverfileactionstatus;


--
-- TOC entry 4429 (class 0 OID 0)
-- Dependencies: 2512
-- Name: serverfileactionstatus_keyserverfileactionstatus_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('serverfileactionstatus_keyserverfileactionstatus_seq', 1, false);


--
-- TOC entry 2513 (class 1259 OID 18348)
-- Dependencies: 3
-- Name: serverfileactiontype; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE serverfileactiontype (
    keyserverfileactiontype integer NOT NULL,
    type text
);


--
-- TOC entry 2514 (class 1259 OID 18354)
-- Dependencies: 2513 3
-- Name: serverfileactiontype_keyserverfileactiontype_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE serverfileactiontype_keyserverfileactiontype_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4430 (class 0 OID 0)
-- Dependencies: 2514
-- Name: serverfileactiontype_keyserverfileactiontype_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE serverfileactiontype_keyserverfileactiontype_seq OWNED BY serverfileactiontype.keyserverfileactiontype;


--
-- TOC entry 4431 (class 0 OID 0)
-- Dependencies: 2514
-- Name: serverfileactiontype_keyserverfileactiontype_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('serverfileactiontype_keyserverfileactiontype_seq', 1, false);


--
-- TOC entry 2515 (class 1259 OID 18356)
-- Dependencies: 3
-- Name: service_keyservice_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE service_keyservice_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4432 (class 0 OID 0)
-- Dependencies: 2515
-- Name: service_keyservice_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('service_keyservice_seq', 40, true);


--
-- TOC entry 2516 (class 1259 OID 18358)
-- Dependencies: 3605 3
-- Name: service; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE service (
    keyservice integer DEFAULT nextval('service_keyservice_seq'::regclass) NOT NULL,
    service text,
    description text,
    fkeylicense integer,
    enabled boolean,
    forbiddenprocesses text,
    active boolean,
    "unique" boolean,
    fkeysoftware integer
);


--
-- TOC entry 2517 (class 1259 OID 18365)
-- Dependencies: 3
-- Name: sessions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sessions (
    id text,
    length integer,
    a_session text,
    "time" timestamp without time zone
);


--
-- TOC entry 2518 (class 1259 OID 18371)
-- Dependencies: 3606 3 2262
-- Name: shot; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE shot (
    dialog text,
    frameend integer,
    framestart integer,
    shot double precision,
    framestartedl integer,
    frameendedl integer,
    camerainfo text,
    scriptpage integer
)
INHERITS (element);


--
-- TOC entry 2519 (class 1259 OID 18378)
-- Dependencies: 3607 2262 3
-- Name: shotgroup; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE shotgroup (
    shotgroup text
)
INHERITS (element);


--
-- TOC entry 2520 (class 1259 OID 18385)
-- Dependencies: 3
-- Name: software_keysoftware_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE software_keysoftware_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4433 (class 0 OID 0)
-- Dependencies: 2520
-- Name: software_keysoftware_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('software_keysoftware_seq', 9, true);


--
-- TOC entry 2521 (class 1259 OID 18387)
-- Dependencies: 3608 3
-- Name: software; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE software (
    keysoftware integer DEFAULT nextval('software_keysoftware_seq'::regclass) NOT NULL,
    software character varying(64),
    icon text,
    vendor character varying(64),
    vendorcontact text,
    active boolean,
    executable text,
    installedpath text,
    sixtyfourbit boolean,
    version double precision
);


--
-- TOC entry 2522 (class 1259 OID 18394)
-- Dependencies: 3
-- Name: status; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE status (
    keystatus integer NOT NULL,
    name text
);


--
-- TOC entry 2523 (class 1259 OID 18400)
-- Dependencies: 3 2522
-- Name: status_keystatus_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE status_keystatus_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4434 (class 0 OID 0)
-- Dependencies: 2523
-- Name: status_keystatus_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE status_keystatus_seq OWNED BY status.keystatus;


--
-- TOC entry 4435 (class 0 OID 0)
-- Dependencies: 2523
-- Name: status_keystatus_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('status_keystatus_seq', 1, false);


--
-- TOC entry 2524 (class 1259 OID 18402)
-- Dependencies: 3
-- Name: statusset_keystatusset_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE statusset_keystatusset_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4436 (class 0 OID 0)
-- Dependencies: 2524
-- Name: statusset_keystatusset_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('statusset_keystatusset_seq', 1, false);


--
-- TOC entry 2525 (class 1259 OID 18404)
-- Dependencies: 3610 3
-- Name: statusset; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE statusset (
    keystatusset integer DEFAULT nextval('statusset_keystatusset_seq'::regclass) NOT NULL,
    name text NOT NULL
);


--
-- TOC entry 2526 (class 1259 OID 18411)
-- Dependencies: 3
-- Name: syslog_keysyslog_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE syslog_keysyslog_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4437 (class 0 OID 0)
-- Dependencies: 2526
-- Name: syslog_keysyslog_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('syslog_keysyslog_seq', 244, true);


--
-- TOC entry 2527 (class 1259 OID 18413)
-- Dependencies: 3611 3612 3613 3614 3615 3
-- Name: syslog; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE syslog (
    keysyslog integer DEFAULT nextval('syslog_keysyslog_seq'::regclass) NOT NULL,
    fkeyhost integer,
    fkeysyslogrealm integer,
    fkeysyslogseverity integer,
    message text,
    count integer DEFAULT nextval(('syslog_count_seq'::text)::regclass),
    lastoccurrence timestamp without time zone DEFAULT now(),
    created timestamp without time zone DEFAULT now(),
    class text,
    method text,
    ack smallint DEFAULT 0 NOT NULL
);


--
-- TOC entry 2528 (class 1259 OID 18424)
-- Dependencies: 3
-- Name: syslog_count_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE syslog_count_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4438 (class 0 OID 0)
-- Dependencies: 2528
-- Name: syslog_count_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('syslog_count_seq', 1, false);


--
-- TOC entry 2529 (class 1259 OID 18426)
-- Dependencies: 3
-- Name: syslogrealm_keysyslogrealm_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE syslogrealm_keysyslogrealm_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4439 (class 0 OID 0)
-- Dependencies: 2529
-- Name: syslogrealm_keysyslogrealm_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('syslogrealm_keysyslogrealm_seq', 5, true);


--
-- TOC entry 2530 (class 1259 OID 18428)
-- Dependencies: 3616 3
-- Name: syslogrealm; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE syslogrealm (
    keysyslogrealm integer DEFAULT nextval('syslogrealm_keysyslogrealm_seq'::regclass) NOT NULL,
    syslogrealm text
);


--
-- TOC entry 2531 (class 1259 OID 18435)
-- Dependencies: 3
-- Name: syslogseverity_keysyslogseverity_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE syslogseverity_keysyslogseverity_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4440 (class 0 OID 0)
-- Dependencies: 2531
-- Name: syslogseverity_keysyslogseverity_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('syslogseverity_keysyslogseverity_seq', 4, true);


--
-- TOC entry 2532 (class 1259 OID 18437)
-- Dependencies: 3617 3
-- Name: syslogseverity; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE syslogseverity (
    keysyslogseverity integer DEFAULT nextval('syslogseverity_keysyslogseverity_seq'::regclass) NOT NULL,
    syslogseverity text,
    severity text
);


--
-- TOC entry 2533 (class 1259 OID 18444)
-- Dependencies: 3618 3 2262
-- Name: task; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE task (
    icon bytea,
    fkeytasktype integer,
    shotgroup integer
)
INHERITS (element);


--
-- TOC entry 2534 (class 1259 OID 18451)
-- Dependencies: 3
-- Name: tasktype_keytasktype_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tasktype_keytasktype_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4441 (class 0 OID 0)
-- Dependencies: 2534
-- Name: tasktype_keytasktype_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('tasktype_keytasktype_seq', 1, false);


--
-- TOC entry 2535 (class 1259 OID 18453)
-- Dependencies: 3619 3
-- Name: tasktype; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tasktype (
    keytasktype integer DEFAULT nextval('tasktype_keytasktype_seq'::regclass) NOT NULL,
    tasktype text,
    iconcolor text
);


--
-- TOC entry 2536 (class 1259 OID 18460)
-- Dependencies: 3
-- Name: taskuser_keytaskuser_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE taskuser_keytaskuser_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4442 (class 0 OID 0)
-- Dependencies: 2536
-- Name: taskuser_keytaskuser_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('taskuser_keytaskuser_seq', 1, false);


--
-- TOC entry 2537 (class 1259 OID 18462)
-- Dependencies: 3620 3
-- Name: taskuser; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE taskuser (
    keytaskuser integer DEFAULT nextval('taskuser_keytaskuser_seq'::regclass) NOT NULL,
    fkeytask integer,
    fkeyuser integer,
    active integer
);


--
-- TOC entry 2538 (class 1259 OID 18466)
-- Dependencies: 3
-- Name: thread_keythread_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE thread_keythread_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4443 (class 0 OID 0)
-- Dependencies: 2538
-- Name: thread_keythread_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('thread_keythread_seq', 1, false);


--
-- TOC entry 2539 (class 1259 OID 18468)
-- Dependencies: 3621 3
-- Name: thread; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE thread (
    keythread integer DEFAULT nextval('thread_keythread_seq'::regclass) NOT NULL,
    thread text,
    topic text,
    tablename text,
    fkey integer,
    datetime timestamp without time zone,
    fkeyauthor integer,
    skeyreply integer,
    fkeyusr integer,
    fkeythreadcategory integer
);


--
-- TOC entry 2540 (class 1259 OID 18475)
-- Dependencies: 3
-- Name: threadcategory_keythreadcategory_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE threadcategory_keythreadcategory_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4444 (class 0 OID 0)
-- Dependencies: 2540
-- Name: threadcategory_keythreadcategory_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('threadcategory_keythreadcategory_seq', 1, false);


--
-- TOC entry 2541 (class 1259 OID 18477)
-- Dependencies: 3622 3
-- Name: threadcategory; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE threadcategory (
    keythreadcategory integer DEFAULT nextval('threadcategory_keythreadcategory_seq'::regclass) NOT NULL,
    threadcategory text
);


--
-- TOC entry 2542 (class 1259 OID 18484)
-- Dependencies: 3
-- Name: threadnotify_keythreadnotify_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE threadnotify_keythreadnotify_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4445 (class 0 OID 0)
-- Dependencies: 2542
-- Name: threadnotify_keythreadnotify_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('threadnotify_keythreadnotify_seq', 9, true);


--
-- TOC entry 2543 (class 1259 OID 18486)
-- Dependencies: 3623 3
-- Name: threadnotify; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE threadnotify (
    keythreadnotify integer DEFAULT nextval('threadnotify_keythreadnotify_seq'::regclass) NOT NULL,
    fkeythread integer,
    fkeyuser integer,
    options integer
);


--
-- TOC entry 2544 (class 1259 OID 18490)
-- Dependencies: 3
-- Name: thumbnail_keythumbnail_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE thumbnail_keythumbnail_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4446 (class 0 OID 0)
-- Dependencies: 2544
-- Name: thumbnail_keythumbnail_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('thumbnail_keythumbnail_seq', 25, true);


--
-- TOC entry 2545 (class 1259 OID 18492)
-- Dependencies: 3624 3
-- Name: thumbnail; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE thumbnail (
    keythumbnail integer DEFAULT nextval('thumbnail_keythumbnail_seq'::regclass) NOT NULL,
    cliprect text,
    date timestamp without time zone,
    fkeyelement integer,
    fkeyuser integer,
    originalfile text,
    image bytea
);


--
-- TOC entry 2546 (class 1259 OID 18499)
-- Dependencies: 3
-- Name: timesheet_keytimesheet_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE timesheet_keytimesheet_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4447 (class 0 OID 0)
-- Dependencies: 2546
-- Name: timesheet_keytimesheet_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('timesheet_keytimesheet_seq', 4, true);


--
-- TOC entry 2547 (class 1259 OID 18501)
-- Dependencies: 3625 3
-- Name: timesheet; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE timesheet (
    keytimesheet integer DEFAULT nextval('timesheet_keytimesheet_seq'::regclass) NOT NULL,
    datetime timestamp without time zone,
    fkeyelement integer,
    fkeyemployee integer,
    fkeyproject integer,
    fkeytimesheetcategory integer,
    scheduledhour double precision,
    datetimesubmitted timestamp without time zone,
    unscheduledhour double precision,
    comment text
);


--
-- TOC entry 2548 (class 1259 OID 18508)
-- Dependencies: 3
-- Name: timesheetcategory_keytimesheetcategory_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE timesheetcategory_keytimesheetcategory_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4448 (class 0 OID 0)
-- Dependencies: 2548
-- Name: timesheetcategory_keytimesheetcategory_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('timesheetcategory_keytimesheetcategory_seq', 179, true);


--
-- TOC entry 2549 (class 1259 OID 18510)
-- Dependencies: 3626 3627 3628 3
-- Name: timesheetcategory; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE timesheetcategory (
    keytimesheetcategory integer DEFAULT nextval('timesheetcategory_keytimesheetcategory_seq'::regclass) NOT NULL,
    timesheetcategory text,
    iconcolor integer,
    hasdaily integer,
    chronology text,
    disabled integer,
    istask boolean,
    fkeypathtemplate integer,
    fkeyelementtype integer DEFAULT 4,
    nameregexp text,
    allowtime boolean,
    color text,
    description text,
    sortcolumn text DEFAULT 'displayName'::text,
    tags text,
    sortnumber integer
);


--
-- TOC entry 2550 (class 1259 OID 18519)
-- Dependencies: 3
-- Name: tracker_keytracker_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tracker_keytracker_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4449 (class 0 OID 0)
-- Dependencies: 2550
-- Name: tracker_keytracker_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('tracker_keytracker_seq', 1, false);


--
-- TOC entry 2551 (class 1259 OID 18521)
-- Dependencies: 3629 3
-- Name: tracker; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tracker (
    keytracker integer DEFAULT nextval('tracker_keytracker_seq'::regclass) NOT NULL,
    tracker text,
    fkeysubmitter integer,
    fkeyassigned integer,
    fkeycategory integer,
    fkeyseverity integer,
    fkeystatus integer,
    datetarget date,
    datechanged timestamp without time zone,
    datesubmitted timestamp without time zone,
    description text,
    timeestimate integer,
    fkeytrackerqueue integer
);


--
-- TOC entry 2552 (class 1259 OID 18528)
-- Dependencies: 3
-- Name: trackercategory_keytrackercategory_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE trackercategory_keytrackercategory_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4450 (class 0 OID 0)
-- Dependencies: 2552
-- Name: trackercategory_keytrackercategory_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('trackercategory_keytrackercategory_seq', 1, false);


--
-- TOC entry 2553 (class 1259 OID 18530)
-- Dependencies: 3630 3
-- Name: trackercategory; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE trackercategory (
    keytrackercategory integer DEFAULT nextval('trackercategory_keytrackercategory_seq'::regclass) NOT NULL,
    trackercategory text
);


--
-- TOC entry 2554 (class 1259 OID 18537)
-- Dependencies: 3
-- Name: trackerlog_keytrackerlog_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE trackerlog_keytrackerlog_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4451 (class 0 OID 0)
-- Dependencies: 2554
-- Name: trackerlog_keytrackerlog_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('trackerlog_keytrackerlog_seq', 1, false);


--
-- TOC entry 2555 (class 1259 OID 18539)
-- Dependencies: 3631 3
-- Name: trackerlog; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE trackerlog (
    keytrackerlog integer DEFAULT nextval('trackerlog_keytrackerlog_seq'::regclass) NOT NULL,
    fkeytracker integer,
    fkeyusr integer,
    datelogged integer,
    message text
);


--
-- TOC entry 2556 (class 1259 OID 18546)
-- Dependencies: 3
-- Name: trackerqueue_keytrackerqueue_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE trackerqueue_keytrackerqueue_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4452 (class 0 OID 0)
-- Dependencies: 2556
-- Name: trackerqueue_keytrackerqueue_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('trackerqueue_keytrackerqueue_seq', 1, false);


--
-- TOC entry 2557 (class 1259 OID 18548)
-- Dependencies: 3632 3
-- Name: trackerqueue; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE trackerqueue (
    keytrackerqueue integer DEFAULT nextval('trackerqueue_keytrackerqueue_seq'::regclass) NOT NULL,
    trackerqueue text
);


--
-- TOC entry 2558 (class 1259 OID 18555)
-- Dependencies: 3
-- Name: trackerseverity_keytrackerseverity_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE trackerseverity_keytrackerseverity_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4453 (class 0 OID 0)
-- Dependencies: 2558
-- Name: trackerseverity_keytrackerseverity_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('trackerseverity_keytrackerseverity_seq', 1, false);


--
-- TOC entry 2559 (class 1259 OID 18557)
-- Dependencies: 3633 3
-- Name: trackerseverity; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE trackerseverity (
    keytrackerseverity integer DEFAULT nextval('trackerseverity_keytrackerseverity_seq'::regclass) NOT NULL,
    trackerseverity text
);


--
-- TOC entry 2560 (class 1259 OID 18564)
-- Dependencies: 3
-- Name: trackerstatus_keytrackerstatus_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE trackerstatus_keytrackerstatus_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4454 (class 0 OID 0)
-- Dependencies: 2560
-- Name: trackerstatus_keytrackerstatus_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('trackerstatus_keytrackerstatus_seq', 1, false);


--
-- TOC entry 2561 (class 1259 OID 18566)
-- Dependencies: 3634 3
-- Name: trackerstatus; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE trackerstatus (
    keytrackerstatus integer DEFAULT nextval('trackerstatus_keytrackerstatus_seq'::regclass) NOT NULL,
    trackerstatus text
);


--
-- TOC entry 2562 (class 1259 OID 18573)
-- Dependencies: 3
-- Name: userelement_keyuserelement_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE userelement_keyuserelement_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4455 (class 0 OID 0)
-- Dependencies: 2562
-- Name: userelement_keyuserelement_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('userelement_keyuserelement_seq', 1, false);


--
-- TOC entry 2563 (class 1259 OID 18575)
-- Dependencies: 3635 3
-- Name: userelement; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE userelement (
    keyuserelement integer DEFAULT nextval('userelement_keyuserelement_seq'::regclass) NOT NULL,
    fkeyelement integer,
    fkeyusr integer,
    fkeyuser integer
);


--
-- TOC entry 2564 (class 1259 OID 18579)
-- Dependencies: 3
-- Name: usermapping_keyusermapping_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE usermapping_keyusermapping_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4456 (class 0 OID 0)
-- Dependencies: 2564
-- Name: usermapping_keyusermapping_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('usermapping_keyusermapping_seq', 1, false);


--
-- TOC entry 2565 (class 1259 OID 18581)
-- Dependencies: 3636 3
-- Name: usermapping; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE usermapping (
    keyusermapping integer DEFAULT nextval('usermapping_keyusermapping_seq'::regclass) NOT NULL,
    fkeyusr integer,
    fkeymapping integer
);


--
-- TOC entry 2566 (class 1259 OID 18585)
-- Dependencies: 3
-- Name: userrole_keyuserrole_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE userrole_keyuserrole_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4457 (class 0 OID 0)
-- Dependencies: 2566
-- Name: userrole_keyuserrole_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('userrole_keyuserrole_seq', 3, true);


--
-- TOC entry 2567 (class 1259 OID 18587)
-- Dependencies: 3637 3
-- Name: userrole; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE userrole (
    keyuserrole integer DEFAULT nextval('userrole_keyuserrole_seq'::regclass) NOT NULL,
    fkeytasktype integer,
    fkeyusr integer
);


--
-- TOC entry 2568 (class 1259 OID 18591)
-- Dependencies: 3
-- Name: usrgrp_keyusrgrp_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE usrgrp_keyusrgrp_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4458 (class 0 OID 0)
-- Dependencies: 2568
-- Name: usrgrp_keyusrgrp_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('usrgrp_keyusrgrp_seq', 3, true);


--
-- TOC entry 2569 (class 1259 OID 18593)
-- Dependencies: 3638 3
-- Name: usrgrp; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE usrgrp (
    keyusrgrp integer DEFAULT nextval('usrgrp_keyusrgrp_seq'::regclass) NOT NULL,
    fkeyusr integer,
    fkeygrp integer,
    usrgrp text
);


--
-- TOC entry 2570 (class 1259 OID 18600)
-- Dependencies: 3
-- Name: version; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE version (
    keyversion integer NOT NULL
);


--
-- TOC entry 2571 (class 1259 OID 18603)
-- Dependencies: 2570 3
-- Name: version_keyversion_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE version_keyversion_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 4459 (class 0 OID 0)
-- Dependencies: 2571
-- Name: version_keyversion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE version_keyversion_seq OWNED BY version.keyversion;


--
-- TOC entry 4460 (class 0 OID 0)
-- Dependencies: 2571
-- Name: version_keyversion_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('version_keyversion_seq', 1, false);


--
-- TOC entry 2572 (class 1259 OID 18605)
-- Dependencies: 3640 3 2327
-- Name: versionfiletracker; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE versionfiletracker (
    filenametemplate text,
    fkeyversionfiletracker integer,
    oldfilenames text,
    version integer,
    iteration integer,
    automaster integer
)
INHERITS (filetracker);


--
-- TOC entry 2870 (class 2604 OID 18612)
-- Dependencies: 2265 2264
-- Name: keyassetdep; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE assetdep ALTER COLUMN keyassetdep SET DEFAULT nextval('assetdep_keyassetdep_seq'::regclass);


--
-- TOC entry 2872 (class 2604 OID 18613)
-- Dependencies: 2268 2267
-- Name: keyassetprop; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE assetprop ALTER COLUMN keyassetprop SET DEFAULT nextval('assetprop_keyassetprop_seq'::regclass);


--
-- TOC entry 2874 (class 2604 OID 18614)
-- Dependencies: 2272 2271
-- Name: keyassetproptype; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE assetproptype ALTER COLUMN keyassetproptype SET DEFAULT nextval('assetproptype_keyassetproptype_seq'::regclass);


--
-- TOC entry 2998 (class 2604 OID 18615)
-- Dependencies: 2381 2380
-- Name: keyjobassignment; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE jobassignment ALTER COLUMN keyjobassignment SET DEFAULT nextval('jobassignment_keyjobassignment_seq'::regclass);


--
-- TOC entry 2999 (class 2604 OID 18616)
-- Dependencies: 2383 2382
-- Name: keyjobassignmentstatus; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE jobassignmentstatus ALTER COLUMN keyjobassignmentstatus SET DEFAULT nextval('jobassignmentstatus_keyjobassignmentstatus_seq'::regclass);


--
-- TOC entry 3118 (class 2604 OID 18617)
-- Dependencies: 2407 2406
-- Name: keyjobmantra100; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE jobmantra100 ALTER COLUMN keyjobmantra100 SET DEFAULT nextval('jobmantra100_keyjobmantra100_seq'::regclass);


--
-- TOC entry 3134 (class 2604 OID 18618)
-- Dependencies: 2409 2408
-- Name: keyjobmantra95; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE jobmantra95 ALTER COLUMN keyjobmantra95 SET DEFAULT nextval('jobmantra95_keyjobmantra95_seq'::regclass);


--
-- TOC entry 3459 (class 2604 OID 18619)
-- Dependencies: 2433 2432
-- Name: keyjobrealflow; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE jobrealflow ALTER COLUMN keyjobrealflow SET DEFAULT nextval('jobrealflow_keyjobrealflow_seq'::regclass);


--
-- TOC entry 3540 (class 2604 OID 18620)
-- Dependencies: 2449 2448
-- Name: keyjobtaskassignment; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE jobtaskassignment ALTER COLUMN keyjobtaskassignment SET DEFAULT nextval('jobtaskassignment_keyjobtaskassignment_seq'::regclass);


--
-- TOC entry 3587 (class 2604 OID 18621)
-- Dependencies: 2481 2480
-- Name: keypackage; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE package ALTER COLUMN keypackage SET DEFAULT nextval('package_keypackage_seq'::regclass);


--
-- TOC entry 3588 (class 2604 OID 18622)
-- Dependencies: 2483 2482
-- Name: keypackageoutput; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE packageoutput ALTER COLUMN keypackageoutput SET DEFAULT nextval('packageoutput_keypackageoutput_seq'::regclass);


--
-- TOC entry 3602 (class 2604 OID 18623)
-- Dependencies: 2510 2509
-- Name: keyserverfileaction; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE serverfileaction ALTER COLUMN keyserverfileaction SET DEFAULT nextval('serverfileaction_keyserverfileaction_seq'::regclass);


--
-- TOC entry 3603 (class 2604 OID 18624)
-- Dependencies: 2512 2511
-- Name: keyserverfileactionstatus; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE serverfileactionstatus ALTER COLUMN keyserverfileactionstatus SET DEFAULT nextval('serverfileactionstatus_keyserverfileactionstatus_seq'::regclass);


--
-- TOC entry 3604 (class 2604 OID 18625)
-- Dependencies: 2514 2513
-- Name: keyserverfileactiontype; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE serverfileactiontype ALTER COLUMN keyserverfileactiontype SET DEFAULT nextval('serverfileactiontype_keyserverfileactiontype_seq'::regclass);


--
-- TOC entry 3609 (class 2604 OID 18626)
-- Dependencies: 2523 2522
-- Name: keystatus; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE status ALTER COLUMN keystatus SET DEFAULT nextval('status_keystatus_seq'::regclass);


--
-- TOC entry 3639 (class 2604 OID 18627)
-- Dependencies: 2571 2570
-- Name: keyversion; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE version ALTER COLUMN keyversion SET DEFAULT nextval('version_keyversion_seq'::regclass);


SET search_path = jabberd, pg_catalog;

--
-- TOC entry 4103 (class 0 OID 16490)
-- Dependencies: 2237
-- Data for Name: active; Type: TABLE DATA; Schema: jabberd; Owner: -
--

COPY active ("collection-owner", "object-sequence", "time") FROM stdin;
\.


--
-- TOC entry 4104 (class 0 OID 16496)
-- Dependencies: 2238
-- Data for Name: authreg; Type: TABLE DATA; Schema: jabberd; Owner: -
--

COPY authreg (username, realm, password, token, sequence, hash) FROM stdin;
\.


--
-- TOC entry 4105 (class 0 OID 16502)
-- Dependencies: 2239
-- Data for Name: logout; Type: TABLE DATA; Schema: jabberd; Owner: -
--

COPY logout ("collection-owner", "object-sequence", "time") FROM stdin;
\.


--
-- TOC entry 4106 (class 0 OID 16510)
-- Dependencies: 2241
-- Data for Name: privacy-items; Type: TABLE DATA; Schema: jabberd; Owner: -
--

COPY "privacy-items" ("collection-owner", "object-sequence", list, type, value, deny, "order", block) FROM stdin;
\.


--
-- TOC entry 4107 (class 0 OID 16516)
-- Dependencies: 2242
-- Data for Name: private; Type: TABLE DATA; Schema: jabberd; Owner: -
--

COPY private ("collection-owner", "object-sequence", ns, xml) FROM stdin;
\.


--
-- TOC entry 4108 (class 0 OID 16522)
-- Dependencies: 2243
-- Data for Name: queue; Type: TABLE DATA; Schema: jabberd; Owner: -
--

COPY queue ("collection-owner", "object-sequence", xml) FROM stdin;
\.


--
-- TOC entry 4109 (class 0 OID 16528)
-- Dependencies: 2244
-- Data for Name: roster-groups; Type: TABLE DATA; Schema: jabberd; Owner: -
--

COPY "roster-groups" ("collection-owner", "object-sequence", jid, "group") FROM stdin;
\.


--
-- TOC entry 4110 (class 0 OID 16534)
-- Dependencies: 2245
-- Data for Name: roster-items; Type: TABLE DATA; Schema: jabberd; Owner: -
--

COPY "roster-items" ("collection-owner", "object-sequence", jid, name, ask, "to", "from") FROM stdin;
\.


--
-- TOC entry 4111 (class 0 OID 16540)
-- Dependencies: 2246
-- Data for Name: vcard; Type: TABLE DATA; Schema: jabberd; Owner: -
--

COPY vcard ("collection-owner", "object-sequence", fn, nickname, url, tel, email, title, role, bday, "desc", "n-given", "n-family", "adr-street", "adr-extadd", "adr-locality", "adr-region", "adr-pcode", "adr-country", "org-orgname", "org-orgunit") FROM stdin;
\.


SET search_path = public, pg_catalog;

--
-- TOC entry 4116 (class 0 OID 16599)
-- Dependencies: 2258
-- Data for Name: abdownloadstat; Type: TABLE DATA; Schema: public; Owner: -
--

COPY abdownloadstat (keyabdownloadstat, type, size, fkeyhost, "time", abrev, finished, fkeyjob) FROM stdin;
\.


--
-- TOC entry 4117 (class 0 OID 16608)
-- Dependencies: 2260
-- Data for Name: annotation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY annotation (keyannotation, notes, sequence, framestart, frameend, markupdata) FROM stdin;
\.


--
-- TOC entry 4119 (class 0 OID 16624)
-- Dependencies: 2263
-- Data for Name: asset; Type: TABLE DATA; Schema: public; Owner: -
--

COPY asset (keyelement, daysbid, description, fkeyelement, fkeyelementstatus, fkeyelementtype, fkeyproject, fkeythumbnail, name, daysscheduled, daysestimated, status, filepath, fkeyassettype, fkeypathtemplate, fkeystatusset, allowtime, datestart, datecomplete, fkeyassettemplate, icon, fkeystatus, keyasset, version) FROM stdin;
\.


--
-- TOC entry 4120 (class 0 OID 16631)
-- Dependencies: 2264
-- Data for Name: assetdep; Type: TABLE DATA; Schema: public; Owner: -
--

COPY assetdep (keyassetdep, path, fkeypackage, fkeyasset) FROM stdin;
\.


--
-- TOC entry 4121 (class 0 OID 16639)
-- Dependencies: 2266
-- Data for Name: assetgroup; Type: TABLE DATA; Schema: public; Owner: -
--

COPY assetgroup (keyelement, daysbid, description, fkeyelement, fkeyelementstatus, fkeyelementtype, fkeyproject, fkeythumbnail, name, daysscheduled, daysestimated, status, filepath, fkeyassettype, fkeypathtemplate, fkeystatusset, allowtime, datestart, datecomplete, fkeyassettemplate, icon) FROM stdin;
\.


--
-- TOC entry 4122 (class 0 OID 16646)
-- Dependencies: 2267
-- Data for Name: assetprop; Type: TABLE DATA; Schema: public; Owner: -
--

COPY assetprop (keyassetprop, fkeyassetproptype, fkeyasset) FROM stdin;
\.


--
-- TOC entry 4123 (class 0 OID 16653)
-- Dependencies: 2270
-- Data for Name: assetproperty; Type: TABLE DATA; Schema: public; Owner: -
--

COPY assetproperty (keyassetproperty, name, type, value, fkeyelement) FROM stdin;
\.


--
-- TOC entry 4124 (class 0 OID 16660)
-- Dependencies: 2271
-- Data for Name: assetproptype; Type: TABLE DATA; Schema: public; Owner: -
--

COPY assetproptype (keyassetproptype, name, depth) FROM stdin;
\.


--
-- TOC entry 4125 (class 0 OID 16670)
-- Dependencies: 2274
-- Data for Name: assetset; Type: TABLE DATA; Schema: public; Owner: -
--

COPY assetset (keyassetset, fkeyproject, fkeyelementtype, fkeyassettype, name) FROM stdin;
\.


--
-- TOC entry 4126 (class 0 OID 16679)
-- Dependencies: 2276
-- Data for Name: assetsetitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY assetsetitem (keyassetsetitem, fkeyassetset, fkeyassettype, fkeyelementtype, fkeytasktype) FROM stdin;
\.


--
-- TOC entry 4127 (class 0 OID 16685)
-- Dependencies: 2278
-- Data for Name: assettemplate; Type: TABLE DATA; Schema: public; Owner: -
--

COPY assettemplate (keyassettemplate, fkeyassettype, fkeyelement, fkeyproject, name) FROM stdin;
\.


--
-- TOC entry 4128 (class 0 OID 16694)
-- Dependencies: 2280
-- Data for Name: assettype; Type: TABLE DATA; Schema: public; Owner: -
--

COPY assettype (keyassettype, assettype, deleted) FROM stdin;
1	Character	f
2	Environment	f
3	Prop	f
\.


--
-- TOC entry 4129 (class 0 OID 16703)
-- Dependencies: 2282
-- Data for Name: attachment; Type: TABLE DATA; Schema: public; Owner: -
--

COPY attachment (keyattachment, caption, created, filename, fkeyelement, fkeyuser, origpath, attachment, url, description, fkeyauthor, fkeyattachmenttype) FROM stdin;
\.


--
-- TOC entry 4130 (class 0 OID 16712)
-- Dependencies: 2284
-- Data for Name: attachmenttype; Type: TABLE DATA; Schema: public; Owner: -
--

COPY attachmenttype (keyattachmenttype, attachmenttype) FROM stdin;
\.


--
-- TOC entry 4131 (class 0 OID 16721)
-- Dependencies: 2286
-- Data for Name: calendar; Type: TABLE DATA; Schema: public; Owner: -
--

COPY calendar (keycalendar, repeat, fkeycalendarcategory, url, fkeyauthor, fieldname, notifylist, notifybatch, leadtime, notifymask, fkeyusr, private, date, calendar, fkeyproject) FROM stdin;
\.


--
-- TOC entry 4132 (class 0 OID 16730)
-- Dependencies: 2288
-- Data for Name: calendarcategory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY calendarcategory (keycalendarcategory, calendarcategory) FROM stdin;
\.


--
-- TOC entry 4133 (class 0 OID 16739)
-- Dependencies: 2290
-- Data for Name: checklistitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY checklistitem (keychecklistitem, body, checklistitem, fkeyproject, fkeythumbnail, fkeytimesheetcategory, type, fkeystatusset) FROM stdin;
\.


--
-- TOC entry 4134 (class 0 OID 16748)
-- Dependencies: 2292
-- Data for Name: checkliststatus; Type: TABLE DATA; Schema: public; Owner: -
--

COPY checkliststatus (keycheckliststatus, fkeychecklistitem, fkeyelement, state, fkeyelementstatus) FROM stdin;
\.


--
-- TOC entry 4135 (class 0 OID 16754)
-- Dependencies: 2294
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: -
--

COPY client (keyclient, client, textcard) FROM stdin;
\.


--
-- TOC entry 4136 (class 0 OID 16763)
-- Dependencies: 2296
-- Data for Name: config; Type: TABLE DATA; Schema: public; Owner: -
--

COPY config (keyconfig, config, value) FROM stdin;
1	compOutputDrives	T:
2	wipOutputDrives	G:
3	renderOutputDrives	S:
6	assburnerFtpEnabled	false
7	assburnerDownloadMethods	nfs
9	assburnerPrioSort	100
10	assburnerErrorSort	10
20	assburnerForkJobVerify	false
11	assburnerSubmissionSort	1
12	assburnerHostsSort	5
17	jabberSystemResource	Autobot
13	assburnerSortMethod	key_even_by_priority
18	assburnerAssignRate	15000
8	assburnerTotalFailureErrorThreshold	100
19	assburnerHostErrorLimit	8
21	assburnerAutoPacketTarget	420
22	assburnerAutoPacketDefault	150
4	managerDriveLetter	/drd/jobs
5	emailDomain	@drdstudios.com
14	jabberDomain	im.drd.int
15	jabberSystemUser	farm
16	jabberSystemPassword	autologin
23	emailServer	smtp.drd.roam
24	assburnerLogRootDir	/farm/logs/
25	emailSender	farm@drdstudios.com
\.


--
-- TOC entry 4100 (class 0 OID 16412)
-- Dependencies: 2232
-- Data for Name: countercache; Type: TABLE DATA; Schema: public; Owner: -
--

COPY countercache (hoststotal, hostsactive, hostsready, jobstotal, jobsactive, jobsdone, lastupdated) FROM stdin;
0	0	51	573	5	476	2010-01-28 13:08:28.909273
\.


--
-- TOC entry 4137 (class 0 OID 16770)
-- Dependencies: 2297
-- Data for Name: delivery; Type: TABLE DATA; Schema: public; Owner: -
--

COPY delivery (keyelement, daysbid, description, fkeyelement, fkeyelementstatus, fkeyelementtype, fkeyproject, fkeythumbnail, name, daysscheduled, daysestimated, status, filepath, fkeyassettype, fkeypathtemplate, fkeystatusset, allowtime, datestart, datecomplete, fkeyassettemplate, icon) FROM stdin;
\.


--
-- TOC entry 4138 (class 0 OID 16779)
-- Dependencies: 2299
-- Data for Name: deliveryelement; Type: TABLE DATA; Schema: public; Owner: -
--

COPY deliveryelement (keydeliveryshot, fkeydelivery, fkeyelement, framestart, frameend) FROM stdin;
\.


--
-- TOC entry 4139 (class 0 OID 16785)
-- Dependencies: 2301
-- Data for Name: demoreel; Type: TABLE DATA; Schema: public; Owner: -
--

COPY demoreel (keydemoreel, demoreel, datesent, projectlist, contactinfo, notes, playlist, shippingtype) FROM stdin;
\.


--
-- TOC entry 4140 (class 0 OID 16794)
-- Dependencies: 2303
-- Data for Name: diskimage; Type: TABLE DATA; Schema: public; Owner: -
--

COPY diskimage (keydiskimage, diskimage, path, created) FROM stdin;
\.


--
-- TOC entry 4142 (class 0 OID 16812)
-- Dependencies: 2307
-- Data for Name: dynamichostgroup; Type: TABLE DATA; Schema: public; Owner: -
--

COPY dynamichostgroup (keyhostgroup, hostgroup, fkeyusr, private, keydynamichostgroup, hostwhereclause) FROM stdin;
\.


--
-- TOC entry 4118 (class 0 OID 16617)
-- Dependencies: 2262
-- Data for Name: element; Type: TABLE DATA; Schema: public; Owner: -
--

COPY element (keyelement, daysbid, description, fkeyelement, fkeyelementstatus, fkeyelementtype, fkeyproject, fkeythumbnail, name, daysscheduled, daysestimated, status, filepath, fkeyassettype, fkeypathtemplate, fkeystatusset, allowtime, datestart, datecomplete, fkeyassettemplate, icon) FROM stdin;
\.


--
-- TOC entry 4143 (class 0 OID 16822)
-- Dependencies: 2309
-- Data for Name: elementdep; Type: TABLE DATA; Schema: public; Owner: -
--

COPY elementdep (keyelementdep, fkeyelement, fkeyelementdep, relationtype) FROM stdin;
\.


--
-- TOC entry 4144 (class 0 OID 16831)
-- Dependencies: 2311
-- Data for Name: elementstatus; Type: TABLE DATA; Schema: public; Owner: -
--

COPY elementstatus (keyelementstatus, name, color, fkeystatusset, "order") FROM stdin;
1	New	#ffffff	\N	1
2	Active	#00ff55	\N	3
3	Poss. Shot	#ff0000	\N	4
4	Omit	#00ff00	\N	5
5	On Hold	\N	\N	2
7	cbb-sv	\N	\N	6
8	cbb-efx	\N	\N	7
6	Final	\N	\N	8
\.


--
-- TOC entry 4145 (class 0 OID 16840)
-- Dependencies: 2313
-- Data for Name: elementthread; Type: TABLE DATA; Schema: public; Owner: -
--

COPY elementthread (keyelementthread, datetime, elementthread, fkeyelement, fkeyusr, skeyreply, topic, todostatus, hasattachments) FROM stdin;
\.


--
-- TOC entry 4146 (class 0 OID 16849)
-- Dependencies: 2315
-- Data for Name: elementtype; Type: TABLE DATA; Schema: public; Owner: -
--

COPY elementtype (keyelementtype, elementtype, sortprefix) FROM stdin;
2	Asset	\N
4	Task	\N
1	Project	\N
3	Shot	\N
6	AssetGroup	\N
7	User	\N
5	ShotGroup	\N
8	Delivery	\N
\.


--
-- TOC entry 4147 (class 0 OID 16858)
-- Dependencies: 2317
-- Data for Name: elementtypetasktype; Type: TABLE DATA; Schema: public; Owner: -
--

COPY elementtypetasktype (keyelementtypetasktype, fkeyelementtype, fkeytasktype, fkeyassettype) FROM stdin;
\.


--
-- TOC entry 4148 (class 0 OID 16864)
-- Dependencies: 2319
-- Data for Name: elementuser; Type: TABLE DATA; Schema: public; Owner: -
--

COPY elementuser (keyelementuser, fkeyelement, fkeyuser, active, fkeyassettype) FROM stdin;
\.


--
-- TOC entry 4150 (class 0 OID 16876)
-- Dependencies: 2321
-- Data for Name: employee; Type: TABLE DATA; Schema: public; Owner: -
--

COPY employee (keyelement, daysbid, description, fkeyelement, fkeyelementstatus, fkeyelementtype, fkeyproject, fkeythumbnail, name, daysscheduled, daysestimated, status, filepath, fkeyassettype, fkeypathtemplate, fkeystatusset, allowtime, datestart, datecomplete, fkeyassettemplate, icon, dateoflastlogon, email, fkeyhost, gpgkey, jid, pager, password, remoteips, schedule, shell, uid, threadnotifybyjabber, threadnotifybyemail, fkeyclient, intranet, homedir, disabled, gid, usr, keyusr, rolemask, usrlevel, remoteok, requestcount, sessiontimeout, logoncount, useradded, oldkeyusr, sid, lastlogontype, namefirst, namelast, dateofhire, dateoftermination, dateofbirth, logon, lockedout, bebackat, comment, userlevel, nopostdays, initials, missingtimesheetcount, namemiddle) FROM stdin;
\.


--
-- TOC entry 4151 (class 0 OID 16886)
-- Dependencies: 2323
-- Data for Name: eventalert; Type: TABLE DATA; Schema: public; Owner: -
--

COPY eventalert ("keyEventAlert", "fkeyHost", graphds, "sampleType", "samplePeriod", severity, "sampleDirection", varname, "sampleValue") FROM stdin;
\.


--
-- TOC entry 4152 (class 0 OID 16896)
-- Dependencies: 2325
-- Data for Name: filetemplate; Type: TABLE DATA; Schema: public; Owner: -
--

COPY filetemplate (keyfiletemplate, fkeyelementtype, fkeyproject, fkeytasktype, name, sourcefile, templatefilename, trackertable) FROM stdin;
\.


--
-- TOC entry 4153 (class 0 OID 16905)
-- Dependencies: 2327
-- Data for Name: filetracker; Type: TABLE DATA; Schema: public; Owner: -
--

COPY filetracker (keyfiletracker, fkeyelement, name, path, filename, fkeypathtemplate, fkeyprojectstorage, storagename) FROM stdin;
\.


--
-- TOC entry 4154 (class 0 OID 16914)
-- Dependencies: 2329
-- Data for Name: filetrackerdep; Type: TABLE DATA; Schema: public; Owner: -
--

COPY filetrackerdep (keyfiletrackerdep, fkeyinput, fkeyoutput) FROM stdin;
\.


--
-- TOC entry 4155 (class 0 OID 16920)
-- Dependencies: 2331
-- Data for Name: fileversion; Type: TABLE DATA; Schema: public; Owner: -
--

COPY fileversion (keyfileversion, version, iteration, path, oldfilenames, filename, filenametemplate, automaster, fkeyelement, fkeyfileversion) FROM stdin;
\.


--
-- TOC entry 4156 (class 0 OID 16929)
-- Dependencies: 2333
-- Data for Name: folder; Type: TABLE DATA; Schema: public; Owner: -
--

COPY folder (keyfolder, folder, mount, tablename, fkey, online, alias, host, link) FROM stdin;
\.


--
-- TOC entry 4157 (class 0 OID 16938)
-- Dependencies: 2335
-- Data for Name: graph; Type: TABLE DATA; Schema: public; Owner: -
--

COPY graph (keygraph, height, width, vlabel, period, fkeygraphpage, upperlimit, lowerlimit, stack, graphmax, sortorder, graph) FROM stdin;
\.


--
-- TOC entry 4158 (class 0 OID 16946)
-- Dependencies: 2337
-- Data for Name: graphds; Type: TABLE DATA; Schema: public; Owner: -
--

COPY graphds (keygraphds, varname, dstype, fkeyhost, cdef, graphds, fieldname, filename, negative) FROM stdin;
\.


--
-- TOC entry 4159 (class 0 OID 16955)
-- Dependencies: 2339
-- Data for Name: graphpage; Type: TABLE DATA; Schema: public; Owner: -
--

COPY graphpage (keygraphpage, fkeygraphpage, name) FROM stdin;
\.


--
-- TOC entry 4160 (class 0 OID 16961)
-- Dependencies: 2341
-- Data for Name: graphrelationship; Type: TABLE DATA; Schema: public; Owner: -
--

COPY graphrelationship (keygraphrelationship, fkeygraphds, fkeygraph, negative) FROM stdin;
\.


--
-- TOC entry 4161 (class 0 OID 16968)
-- Dependencies: 2343
-- Data for Name: gridtemplate; Type: TABLE DATA; Schema: public; Owner: -
--

COPY gridtemplate (keygridtemplate, fkeyproject, gridtemplate) FROM stdin;
\.


--
-- TOC entry 4162 (class 0 OID 16977)
-- Dependencies: 2345
-- Data for Name: gridtemplateitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY gridtemplateitem (keygridtemplateitem, fkeygridtemplate, fkeytasktype, checklistitems, columntype, headername, "position") FROM stdin;
\.


--
-- TOC entry 4163 (class 0 OID 16986)
-- Dependencies: 2347
-- Data for Name: groupmapping; Type: TABLE DATA; Schema: public; Owner: -
--

COPY groupmapping (keygroupmapping, fkeygrp, fkeymapping) FROM stdin;
\.


--
-- TOC entry 4164 (class 0 OID 16992)
-- Dependencies: 2349
-- Data for Name: grp; Type: TABLE DATA; Schema: public; Owner: -
--

COPY grp (keygrp, grp, alias) FROM stdin;
1	Admin	\N
\.


--
-- TOC entry 4165 (class 0 OID 17001)
-- Dependencies: 2351
-- Data for Name: gruntscript; Type: TABLE DATA; Schema: public; Owner: -
--

COPY gruntscript (keygruntscript, runcount, lastrun, scriptname) FROM stdin;
\.


--
-- TOC entry 4166 (class 0 OID 17010)
-- Dependencies: 2353
-- Data for Name: history; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history (keyhistory, date, fkeyelement, fkeyusr, history) FROM stdin;
\.


--
-- TOC entry 4112 (class 0 OID 16548)
-- Dependencies: 2248
-- Data for Name: host; Type: TABLE DATA; Schema: public; Owner: -
--

COPY host (keyhost, backupbytes, cpus, description, diskusage, fkeyjob, host, manufacturer, model, os, rendertime, slavepluginlist, sn, version, renderrate, dutycycle, memory, mhtz, online, uid, slavepacketweight, framecount, viruscount, virustimestamp, errortempo, fkeyhost_backup, oldkey, abversion, laststatuschange, loadavg, allowmapping, allowsleep, fkeyjobtask, wakeonlan, architecture, loc_x, loc_y, loc_z, ostext, bootaction, fkeydiskimage, syncname, fkeylocation, cpuname, osversion, slavepulse, puppetpulse, maxassignments) FROM stdin;
\.


--
-- TOC entry 4167 (class 0 OID 17019)
-- Dependencies: 2355
-- Data for Name: hostdailystat; Type: TABLE DATA; Schema: public; Owner: -
--

COPY hostdailystat (keyhostdailystat, fkeyhost, readytime, assignedtime, copytime, loadtime, busytime, offlinetime, date, tasksdone, loaderrors, taskerrors, loaderrortime, busyerrortime) FROM stdin;
\.


--
-- TOC entry 4141 (class 0 OID 16805)
-- Dependencies: 2306
-- Data for Name: hostgroup; Type: TABLE DATA; Schema: public; Owner: -
--

COPY hostgroup (keyhostgroup, hostgroup, fkeyusr, private) FROM stdin;
\.


--
-- TOC entry 4168 (class 0 OID 17028)
-- Dependencies: 2357
-- Data for Name: hostgroupitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY hostgroupitem (keyhostgroupitem, fkeyhostgroup, fkeyhost) FROM stdin;
\.


--
-- TOC entry 4101 (class 0 OID 16418)
-- Dependencies: 2234
-- Data for Name: hosthistory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY hosthistory (keyhosthistory, fkeyhost, fkeyjob, fkeyjobstat, status, laststatus, datetime, duration, fkeyjobtask, fkeyjobtype, nextstatus, success, fkeyjoberror, change_from_ip, fkeyjobcommandhistory) FROM stdin;
\.


--
-- TOC entry 4113 (class 0 OID 16561)
-- Dependencies: 2250
-- Data for Name: hostinterface; Type: TABLE DATA; Schema: public; Owner: -
--

COPY hostinterface (keyhostinterface, fkeyhost, mac, ip, fkeyhostinterfacetype, switchport, fkeyswitch, inst) FROM stdin;
\.


--
-- TOC entry 4169 (class 0 OID 17034)
-- Dependencies: 2359
-- Data for Name: hostinterfacetype; Type: TABLE DATA; Schema: public; Owner: -
--

COPY hostinterfacetype (keyhostinterfacetype, hostinterfacetype) FROM stdin;
1	Primary
2	Alias
3	CNAME
\.


--
-- TOC entry 4170 (class 0 OID 17043)
-- Dependencies: 2361
-- Data for Name: hostload; Type: TABLE DATA; Schema: public; Owner: -
--

COPY hostload (keyhostload, fkeyhost, loadavg, loadavgadjust, loadavgadjusttimestamp) FROM stdin;
\.


--
-- TOC entry 4171 (class 0 OID 17050)
-- Dependencies: 2363
-- Data for Name: hostmapping; Type: TABLE DATA; Schema: public; Owner: -
--

COPY hostmapping (keyhostmapping, fkeyhost, fkeymapping) FROM stdin;
\.


--
-- TOC entry 4172 (class 0 OID 17056)
-- Dependencies: 2365
-- Data for Name: hostport; Type: TABLE DATA; Schema: public; Owner: -
--

COPY hostport (keyhostport, fkeyhost, port, monitor, monitorstatus) FROM stdin;
\.


--
-- TOC entry 4173 (class 0 OID 17063)
-- Dependencies: 2367
-- Data for Name: hostresource; Type: TABLE DATA; Schema: public; Owner: -
--

COPY hostresource (keyhostresource, fkeyhost, hostresource) FROM stdin;
\.


--
-- TOC entry 4174 (class 0 OID 17070)
-- Dependencies: 2368
-- Data for Name: hosts_ready; Type: TABLE DATA; Schema: public; Owner: -
--

COPY hosts_ready (count) FROM stdin;
\.


--
-- TOC entry 4175 (class 0 OID 17073)
-- Dependencies: 2369
-- Data for Name: hosts_total; Type: TABLE DATA; Schema: public; Owner: -
--

COPY hosts_total (count) FROM stdin;
\.


--
-- TOC entry 4176 (class 0 OID 17078)
-- Dependencies: 2371
-- Data for Name: hostservice; Type: TABLE DATA; Schema: public; Owner: -
--

COPY hostservice (keyhostservice, fkeyhost, fkeyservice, hostserviceinfo, hostservice, fkeysyslog, enabled, pulse, remotelogport) FROM stdin;
\.


--
-- TOC entry 4177 (class 0 OID 17087)
-- Dependencies: 2373
-- Data for Name: hostsoftware; Type: TABLE DATA; Schema: public; Owner: -
--

COPY hostsoftware (keyhostsoftware, fkeyhost, fkeysoftware) FROM stdin;
\.


--
-- TOC entry 4178 (class 0 OID 17093)
-- Dependencies: 2375
-- Data for Name: hoststatus; Type: TABLE DATA; Schema: public; Owner: -
--

COPY hoststatus (keyhoststatus, fkeyhost, slavestatus, laststatuschange, slavepulse, fkeyjobtask, online, activeassignmentcount, availablememory, lastassignmentchange) FROM stdin;
\.


--
-- TOC entry 4102 (class 0 OID 16466)
-- Dependencies: 2236
-- Data for Name: job; Type: TABLE DATA; Schema: public; Owner: -
--

COPY job (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory) FROM stdin;
\.


--
-- TOC entry 4179 (class 0 OID 17098)
-- Dependencies: 2376
-- Data for Name: job3delight; Type: TABLE DATA; Schema: public; Owner: -
--

COPY job3delight (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, width, height, framestart, frameend, threads, processes, jobscript, jobscriptparam) FROM stdin;
\.


--
-- TOC entry 4180 (class 0 OID 17120)
-- Dependencies: 2377
-- Data for Name: jobaftereffects; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobaftereffects (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, comp, frameend, framestart, height, width) FROM stdin;
\.


--
-- TOC entry 4181 (class 0 OID 17141)
-- Dependencies: 2378
-- Data for Name: jobaftereffects7; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobaftereffects7 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, comp, frameend, framestart, height, width) FROM stdin;
\.


--
-- TOC entry 4182 (class 0 OID 17162)
-- Dependencies: 2379
-- Data for Name: jobaftereffects8; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobaftereffects8 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, comp, frameend, framestart, height, width) FROM stdin;
\.


--
-- TOC entry 4183 (class 0 OID 17183)
-- Dependencies: 2380
-- Data for Name: jobassignment; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobassignment (keyjobassignment, fkeyjob, fkeyjobassignmentstatus, fkeyhost, stdout, stderr, command, maxmemory, started, ended, fkeyjoberror, realtime, usertime, systime, iowait, bytesread, byteswrite, efficiency, opsread, opswrite) FROM stdin;
\.


--
-- TOC entry 4184 (class 0 OID 17191)
-- Dependencies: 2382
-- Data for Name: jobassignmentstatus; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobassignmentstatus (keyjobassignmentstatus, status) FROM stdin;
1	ready
2	copy
3	busy
4	done
5	error
6	cancelled
\.


--
-- TOC entry 4185 (class 0 OID 17199)
-- Dependencies: 2384
-- Data for Name: jobautodeskburn; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobautodeskburn (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, framestart, frameend, handle) FROM stdin;
\.


--
-- TOC entry 4186 (class 0 OID 17220)
-- Dependencies: 2385
-- Data for Name: jobbatch; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobbatch (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, cmd, restartafterfinish, restartaftershutdown, passslaveframesasparam, disablewow64fsredirect) FROM stdin;
\.


--
-- TOC entry 4187 (class 0 OID 17244)
-- Dependencies: 2387
-- Data for Name: jobcannedbatch; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobcannedbatch (keyjobcannedbatch, name, "group", cmd, disablewow64fsredirect) FROM stdin;
1	puppet	Admin	/usr/sbin/puppetd --test	f
2	yum-update	Admin	/usr/bin/yum update -y	f
\.


--
-- TOC entry 4188 (class 0 OID 17251)
-- Dependencies: 2388
-- Data for Name: jobcinema4d; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobcinema4d (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory) FROM stdin;
\.


--
-- TOC entry 4189 (class 0 OID 17274)
-- Dependencies: 2390
-- Data for Name: jobcommandhistory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobcommandhistory (keyjobcommandhistory, stderr, stdout, command, memory, fkeyjob, fkeyhost, fkeyhosthistory, iowait, realtime, systime, usertime) FROM stdin;
\.


--
-- TOC entry 4190 (class 0 OID 17285)
-- Dependencies: 2392
-- Data for Name: jobdep; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobdep (keyjobdep, fkeyjob, fkeydep) FROM stdin;
\.


--
-- TOC entry 4191 (class 0 OID 17291)
-- Dependencies: 2394
-- Data for Name: joberror; Type: TABLE DATA; Schema: public; Owner: -
--

COPY joberror (keyjoberror, fkeyhost, fkeyjob, frames, message, errortime, count, cleared, lastoccurrence, timeout) FROM stdin;
\.


--
-- TOC entry 4192 (class 0 OID 17302)
-- Dependencies: 2396
-- Data for Name: joberrorhandler; Type: TABLE DATA; Schema: public; Owner: -
--

COPY joberrorhandler (keyjoberrorhandler, fkeyjobtype, errorregex, fkeyjoberrorhandlerscript) FROM stdin;
\.


--
-- TOC entry 4193 (class 0 OID 17311)
-- Dependencies: 2398
-- Data for Name: joberrorhandlerscript; Type: TABLE DATA; Schema: public; Owner: -
--

COPY joberrorhandlerscript (keyjoberrorhandlerscript, script) FROM stdin;
\.


--
-- TOC entry 4194 (class 0 OID 17318)
-- Dependencies: 2399
-- Data for Name: jobfusion; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobfusion (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, frameend, framestart, framelist, allframesassingletask, outputcount) FROM stdin;
\.


--
-- TOC entry 4195 (class 0 OID 17339)
-- Dependencies: 2400
-- Data for Name: jobfusionvideomaker; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobfusionvideomaker (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, codec, inputframepath, sequenceframestart, sequenceframeend, allframesassingletask, framelist, outputcount) FROM stdin;
\.


--
-- TOC entry 4196 (class 0 OID 17362)
-- Dependencies: 2402
-- Data for Name: jobhistory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobhistory (keyjobhistory, fkeyjobhistorytype, fkeyjob, fkeyhost, fkeyuser, message, created) FROM stdin;
\.


--
-- TOC entry 4197 (class 0 OID 17371)
-- Dependencies: 2404
-- Data for Name: jobhistorytype; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobhistorytype (keyjobhistorytype, type) FROM stdin;
\.


--
-- TOC entry 4198 (class 0 OID 17378)
-- Dependencies: 2405
-- Data for Name: jobhoudinisim10; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobhoudinisim10 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, slices, tracker, framestart, frameend, nodename) FROM stdin;
\.


--
-- TOC entry 4199 (class 0 OID 17399)
-- Dependencies: 2406
-- Data for Name: jobmantra100; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobmantra100 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, keyjobmantra100, forceraytrace, geocachesize, height, qualityflag, renderquality, threads, width) FROM stdin;
\.


--
-- TOC entry 4200 (class 0 OID 17422)
-- Dependencies: 2408
-- Data for Name: jobmantra95; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobmantra95 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, keyjobmantra95, forceraytrace, geocachesize, height, qualityflag, renderquality, threads, width) FROM stdin;
\.


--
-- TOC entry 4201 (class 0 OID 17445)
-- Dependencies: 2410
-- Data for Name: jobmax; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobmax (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, camera, elementfile, fileoriginal, flag_h, flag_v, flag_w, flag_x2, flag_xa, flag_xc, flag_xd, flag_xe, flag_xf, flag_xh, flag_xk, flag_xn, flag_xo, flag_xp, flag_xv, frameend, framelist, framestart, exrattributes, exrchannels, exrsavebitdepth, startupscript) FROM stdin;
\.


--
-- TOC entry 4202 (class 0 OID 17467)
-- Dependencies: 2411
-- Data for Name: jobmax10; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobmax10 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, camera, elementfile, fileoriginal, flag_h, flag_v, flag_w, flag_x2, flag_xa, flag_xc, flag_xd, flag_xe, flag_xf, flag_xh, flag_xk, flag_xn, flag_xo, flag_xp, flag_xv, frameend, framelist, framestart, exrattributes, exrchannels, exrsavebitdepth, startupscript) FROM stdin;
\.


--
-- TOC entry 4203 (class 0 OID 17489)
-- Dependencies: 2412
-- Data for Name: jobmax2009; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobmax2009 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, camera, elementfile, fileoriginal, flag_h, flag_v, flag_w, flag_x2, flag_xa, flag_xc, flag_xd, flag_xe, flag_xf, flag_xh, flag_xk, flag_xn, flag_xo, flag_xp, flag_xv, frameend, framelist, framestart, exrattributes, exrchannels, exrsavebitdepth, startupscript) FROM stdin;
\.


--
-- TOC entry 4204 (class 0 OID 17511)
-- Dependencies: 2413
-- Data for Name: jobmax5; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobmax5 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, camera, fileoriginal, flag_h, framestart, frameend, flag_w, flag_xv, flag_x2, flag_xa, flag_xe, flag_xk, flag_xd, flag_xh, flag_xo, flag_xf, flag_xn, flag_xp, flag_xc, flag_v, elementfile, framelist) FROM stdin;
\.


--
-- TOC entry 4205 (class 0 OID 17532)
-- Dependencies: 2414
-- Data for Name: jobmax6; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobmax6 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, camera, elementfile, fileoriginal, flag_h, flag_v, flag_w, flag_x2, flag_xa, flag_xc, flag_xd, flag_xe, flag_xf, flag_xh, flag_xk, flag_xn, flag_xo, flag_xp, flag_xv, frameend, framelist, framestart) FROM stdin;
\.


--
-- TOC entry 4206 (class 0 OID 17553)
-- Dependencies: 2415
-- Data for Name: jobmax7; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobmax7 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, camera, elementfile, fileoriginal, flag_h, flag_v, flag_w, flag_x2, flag_xa, flag_xc, flag_xd, flag_xe, flag_xf, flag_xh, flag_xk, flag_xn, flag_xo, flag_xp, flag_xv, frameend, framelist, framestart, exrattributes, exrchannels, exrsavebitdepth, startupscript) FROM stdin;
\.


--
-- TOC entry 4207 (class 0 OID 17575)
-- Dependencies: 2416
-- Data for Name: jobmax8; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobmax8 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, camera, elementfile, fileoriginal, flag_h, flag_v, flag_w, flag_x2, flag_xa, flag_xc, flag_xd, flag_xe, flag_xf, flag_xh, flag_xk, flag_xn, flag_xo, flag_xp, flag_xv, frameend, framelist, framestart, exrattributes, exrchannels, exrsavebitdepth, startupscript) FROM stdin;
\.


--
-- TOC entry 4208 (class 0 OID 17597)
-- Dependencies: 2417
-- Data for Name: jobmax9; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobmax9 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, camera, elementfile, fileoriginal, flag_h, flag_v, flag_w, flag_x2, flag_xa, flag_xc, flag_xd, flag_xe, flag_xf, flag_xh, flag_xk, flag_xn, flag_xo, flag_xp, flag_xv, frameend, framelist, framestart, exrattributes, exrchannels, exrsavebitdepth, startupscript) FROM stdin;
\.


--
-- TOC entry 4209 (class 0 OID 17619)
-- Dependencies: 2418
-- Data for Name: jobmaxscript; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobmaxscript (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, script, maxtime, outputfiles, filelist, silent, maxversion, runmax64) FROM stdin;
\.


--
-- TOC entry 4210 (class 0 OID 17642)
-- Dependencies: 2419
-- Data for Name: jobmaya; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobmaya (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, framestart, frameend, camera, renderer, projectpath, width, height, append) FROM stdin;
\.


--
-- TOC entry 4211 (class 0 OID 17663)
-- Dependencies: 2420
-- Data for Name: jobmaya2008; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobmaya2008 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, framestart, frameend, camera, renderer, projectpath, width, height, append) FROM stdin;
\.


--
-- TOC entry 4212 (class 0 OID 17684)
-- Dependencies: 2421
-- Data for Name: jobmaya2009; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobmaya2009 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, framestart, frameend, camera, renderer, projectpath, width, height, append) FROM stdin;
\.


--
-- TOC entry 4213 (class 0 OID 17705)
-- Dependencies: 2422
-- Data for Name: jobmaya7; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobmaya7 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, framestart, frameend, camera, renderer, projectpath, width, height, append) FROM stdin;
\.


--
-- TOC entry 4214 (class 0 OID 17726)
-- Dependencies: 2423
-- Data for Name: jobmaya8; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobmaya8 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, framestart, frameend, camera, renderer, projectpath, width, height, append) FROM stdin;
\.


--
-- TOC entry 4215 (class 0 OID 17747)
-- Dependencies: 2424
-- Data for Name: jobmaya85; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobmaya85 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, framestart, frameend, camera, renderer, projectpath, width, height, append) FROM stdin;
\.


--
-- TOC entry 4216 (class 0 OID 17768)
-- Dependencies: 2425
-- Data for Name: jobmentalray7; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobmentalray7 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, framestart, frameend, camera, renderer, projectpath, width, height, append) FROM stdin;
\.


--
-- TOC entry 4217 (class 0 OID 17789)
-- Dependencies: 2426
-- Data for Name: jobmentalray8; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobmentalray8 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, framestart, frameend, camera, renderer, projectpath, width, height, append) FROM stdin;
\.


--
-- TOC entry 4218 (class 0 OID 17810)
-- Dependencies: 2427
-- Data for Name: jobmentalray85; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobmentalray85 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, framestart, frameend, camera, renderer, projectpath, width, height, append) FROM stdin;
\.


--
-- TOC entry 4219 (class 0 OID 17831)
-- Dependencies: 2428
-- Data for Name: jobnuke51; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobnuke51 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, framestart, frameend, outputcount) FROM stdin;
\.


--
-- TOC entry 4220 (class 0 OID 17852)
-- Dependencies: 2429
-- Data for Name: jobnuke52; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobnuke52 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, framestart, frameend, outputcount) FROM stdin;
\.


--
-- TOC entry 4221 (class 0 OID 17875)
-- Dependencies: 2431
-- Data for Name: joboutput; Type: TABLE DATA; Schema: public; Owner: -
--

COPY joboutput (keyjoboutput, fkeyjob, name, fkeyfiletracker) FROM stdin;
\.


--
-- TOC entry 4222 (class 0 OID 17882)
-- Dependencies: 2432
-- Data for Name: jobrealflow; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobrealflow (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, keyjobrealflow, framestart, frameend, simtype, threads) FROM stdin;
\.


--
-- TOC entry 4223 (class 0 OID 17907)
-- Dependencies: 2435
-- Data for Name: jobrenderman; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobrenderman (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, framestart, frameend, version, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, checkfilemd5, runassubmitter, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory) FROM stdin;
\.


--
-- TOC entry 4224 (class 0 OID 17917)
-- Dependencies: 2437
-- Data for Name: jobribgen; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobribgen (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, framestart, frameend, version, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, checkfilemd5, runassubmitter, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory) FROM stdin;
\.


--
-- TOC entry 4225 (class 0 OID 17927)
-- Dependencies: 2439
-- Data for Name: jobservice; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobservice (keyjobservice, fkeyjob, fkeyservice) FROM stdin;
\.


--
-- TOC entry 4226 (class 0 OID 17931)
-- Dependencies: 2440
-- Data for Name: jobshake; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobshake (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, framestart, frameend, codec, slatepath, framerange) FROM stdin;
\.


--
-- TOC entry 4227 (class 0 OID 17952)
-- Dependencies: 2441
-- Data for Name: jobspool; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobspool (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, flowfile, flowpath, holdend, inputfile, inputpath, outputfile, inputstart, inputend, holdstart, importmode, keepinqueue, lastscanned, jobpath) FROM stdin;
\.


--
-- TOC entry 4228 (class 0 OID 17975)
-- Dependencies: 2443
-- Data for Name: jobstat; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobstat (keyjobstat, fkeyelement, fkeyproject, fkeyusr, pass, taskcount, taskscompleted, tasktime, started, ended, name, errorcount, mintasktime, maxtasktime, avgtasktime, totaltasktime, minerrortime, maxerrortime, avgerrortime, totalerrortime, mincopytime, maxcopytime, avgcopytime, totalcopytime, copycount, minloadtime, maxloadtime, avgloadtime, totalloadtime, loadcount, submitted, totalcputime, mincputime, maxcputime, avgcputime, minmemory, maxmemory, avgmemory, minefficiency, maxefficiency, avgefficiency, totalbytesread, minbytesread, maxbytesread, avgbytesread, totalopsread, minopsread, maxopsread, avgopsread, totalbyteswrite, minbyteswrite, maxbyteswrite, avgbyteswrite, totalopswrite, minopswrite, maxopswrite, avgopswrite, totaliowait, miniowait, maxiowait, avgiowait) FROM stdin;
\.


--
-- TOC entry 4229 (class 0 OID 17988)
-- Dependencies: 2445
-- Data for Name: jobstatus; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobstatus (keyjobstatus, hostsonjob, fkeyjob, tasksunassigned, taskscount, tasksdone, taskscancelled, taskssuspended, tasksassigned, tasksbusy, tasksaveragetime, health, joblastupdated, errorcount, lastnotifiederrorcount, averagememory) FROM stdin;
\.


--
-- TOC entry 4230 (class 0 OID 18001)
-- Dependencies: 2446
-- Data for Name: jobsync; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobsync (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, direction, append, filesfrom) FROM stdin;
\.


--
-- TOC entry 4231 (class 0 OID 18022)
-- Dependencies: 2447
-- Data for Name: jobsystem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobsystem (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory) FROM stdin;
\.


--
-- TOC entry 4114 (class 0 OID 16575)
-- Dependencies: 2253
-- Data for Name: jobtask; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobtask (keyjobtask, ended, fkeyhost, fkeyjob, status, jobtask, label, fkeyjoboutput, progress, fkeyjobtaskassignment) FROM stdin;
\.


--
-- TOC entry 4232 (class 0 OID 18043)
-- Dependencies: 2448
-- Data for Name: jobtaskassignment; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobtaskassignment (keyjobtaskassignment, fkeyjobassignment, memory, started, ended, fkeyjobassignmentstatus, fkeyjobtask, fkeyjoberror) FROM stdin;
\.


--
-- TOC entry 4115 (class 0 OID 16585)
-- Dependencies: 2255
-- Data for Name: jobtype; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobtype (keyjobtype, jobtype, fkeyservice, icon) FROM stdin;
1	Max5	\N	\N
2	Max6	\N	\N
3	Max7	\N	\N
4	Max8	\N	\N
5	Max9	\N	\N
7	MaxScript	\N	\N
17	AfterEffects	6	\N
9	XSI	\N	\N
14	Maya7	3	\N
15	Shake	4	\N
13	Maya8	3	\N
24	AfterEffects7	6	\N
18	RibGen	7	\N
19	RenderMan	7	\N
11	Fusion	8	\N
21	MentalRay7	9	\N
20	Maya85	3	\N
23	MentalRay85	9	\N
22	MentalRay8	9	\N
16	Batch	10	\N
26	AfterEffects8	17	\N
25	Sync	15	\N
27	AutodeskBurn	13	\N
28	Maya2009	3	\N
29	Maya2008	3	\N
30	Nuke51	32	\N
31	Mantra95	33	\N
32	Mantra100	33	\N
33	3Delight	36	\N
34	HoudiniSim10	33	\N
35	Nuke52	32	\N
\.


--
-- TOC entry 4233 (class 0 OID 18050)
-- Dependencies: 2451
-- Data for Name: jobtypemapping; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobtypemapping (keyjobtypemapping, fkeyjobtype, fkeymapping) FROM stdin;
\.


--
-- TOC entry 4234 (class 0 OID 18054)
-- Dependencies: 2452
-- Data for Name: jobxsi; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobxsi (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, framestart, frameend, framelist, pass, flag_w, flag_h, deformmotionblur, motionblur, renderer, resolutionx, resolutiony) FROM stdin;
\.


--
-- TOC entry 4235 (class 0 OID 18075)
-- Dependencies: 2453
-- Data for Name: jobxsiscript; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobxsiscript (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, framestart, frameend, scriptrequiresui, scriptfile, xsifile, scriptmethod, framelist) FROM stdin;
\.


--
-- TOC entry 4236 (class 0 OID 18098)
-- Dependencies: 2455
-- Data for Name: license; Type: TABLE DATA; Schema: public; Owner: -
--

COPY license (keylicense, license, fkeyhost, fkeysoftware, total, available, reserved, inuse) FROM stdin;
\.


--
-- TOC entry 4237 (class 0 OID 18109)
-- Dependencies: 2457
-- Data for Name: location; Type: TABLE DATA; Schema: public; Owner: -
--

COPY location (keylocation, name) FROM stdin;
\.


--
-- TOC entry 4238 (class 0 OID 18118)
-- Dependencies: 2459
-- Data for Name: mapping; Type: TABLE DATA; Schema: public; Owner: -
--

COPY mapping (keymapping, fkeyhost, share, mount, fkeymappingtype, description) FROM stdin;
\.


--
-- TOC entry 4239 (class 0 OID 18127)
-- Dependencies: 2461
-- Data for Name: mappingtype; Type: TABLE DATA; Schema: public; Owner: -
--

COPY mappingtype (keymappingtype, name) FROM stdin;
\.


--
-- TOC entry 4240 (class 0 OID 18136)
-- Dependencies: 2463
-- Data for Name: methodperms; Type: TABLE DATA; Schema: public; Owner: -
--

COPY methodperms (keymethodperms, method, users, groups, fkeyproject) FROM stdin;
\.


--
-- TOC entry 4241 (class 0 OID 18145)
-- Dependencies: 2465
-- Data for Name: notification; Type: TABLE DATA; Schema: public; Owner: -
--

COPY notification (keynotification, created, subject, message, component, event, routed, fkeyelement) FROM stdin;
\.


--
-- TOC entry 4242 (class 0 OID 18154)
-- Dependencies: 2467
-- Data for Name: notificationdestination; Type: TABLE DATA; Schema: public; Owner: -
--

COPY notificationdestination (keynotificationdestination, fkeynotification, fkeynotificationmethod, delivered, destination, fkeyuser, routed) FROM stdin;
\.


--
-- TOC entry 4243 (class 0 OID 18163)
-- Dependencies: 2469
-- Data for Name: notificationmethod; Type: TABLE DATA; Schema: public; Owner: -
--

COPY notificationmethod (keynotificationmethod, name) FROM stdin;
\.


--
-- TOC entry 4244 (class 0 OID 18172)
-- Dependencies: 2471
-- Data for Name: notificationroute; Type: TABLE DATA; Schema: public; Owner: -
--

COPY notificationroute (keynotificationuserroute, eventmatch, componentmatch, fkeyuser, subjectmatch, messagematch, actions, priority, fkeyelement, routeassetdescendants) FROM stdin;
\.


--
-- TOC entry 4245 (class 0 OID 18181)
-- Dependencies: 2473
-- Data for Name: notify; Type: TABLE DATA; Schema: public; Owner: -
--

COPY notify (keynotify, notify, fkeyusr, fkeysyslogrealm, severitymask, starttime, endtime, threshhold, notifyclass, notifymethod, fkeynotifymethod, threshold) FROM stdin;
\.


--
-- TOC entry 4246 (class 0 OID 18190)
-- Dependencies: 2475
-- Data for Name: notifymethod; Type: TABLE DATA; Schema: public; Owner: -
--

COPY notifymethod (keynotifymethod, notifymethod) FROM stdin;
\.


--
-- TOC entry 4247 (class 0 OID 18199)
-- Dependencies: 2477
-- Data for Name: notifysent; Type: TABLE DATA; Schema: public; Owner: -
--

COPY notifysent (keynotifysent, fkeynotify, fkeysyslog) FROM stdin;
\.


--
-- TOC entry 4248 (class 0 OID 18205)
-- Dependencies: 2479
-- Data for Name: notifywho; Type: TABLE DATA; Schema: public; Owner: -
--

COPY notifywho (keynotifywho, class, fkeynotify, fkeyusr, fkey) FROM stdin;
\.


--
-- TOC entry 4249 (class 0 OID 18212)
-- Dependencies: 2480
-- Data for Name: package; Type: TABLE DATA; Schema: public; Owner: -
--

COPY package (keypackage, version, fkeystatus) FROM stdin;
\.


--
-- TOC entry 4250 (class 0 OID 18217)
-- Dependencies: 2482
-- Data for Name: packageoutput; Type: TABLE DATA; Schema: public; Owner: -
--

COPY packageoutput (keypackageoutput, fkeyasset) FROM stdin;
\.


--
-- TOC entry 4251 (class 0 OID 18224)
-- Dependencies: 2485
-- Data for Name: pathsynctarget; Type: TABLE DATA; Schema: public; Owner: -
--

COPY pathsynctarget (keypathsynctarget, fkeypathtracker, fkeyprojectstorage) FROM stdin;
\.


--
-- TOC entry 4252 (class 0 OID 18230)
-- Dependencies: 2487
-- Data for Name: pathtemplate; Type: TABLE DATA; Schema: public; Owner: -
--

COPY pathtemplate (keypathtemplate, name, pathtemplate, pathre, filenametemplate, filenamere, version, pythoncode) FROM stdin;
\.


--
-- TOC entry 4253 (class 0 OID 18239)
-- Dependencies: 2489
-- Data for Name: pathtracker; Type: TABLE DATA; Schema: public; Owner: -
--

COPY pathtracker (keypathtracker, fkeyelement, path, fkeypathtemplate, fkeyprojectstorage, storagename) FROM stdin;
\.


--
-- TOC entry 4254 (class 0 OID 18248)
-- Dependencies: 2491
-- Data for Name: permission; Type: TABLE DATA; Schema: public; Owner: -
--

COPY permission (keypermission, methodpattern, fkeyusr, permission, fkeygrp, class) FROM stdin;
1	\N	2	2777	\N	Blur::
2	\N	122	0777	2	Blur::
\.


--
-- TOC entry 4255 (class 0 OID 18257)
-- Dependencies: 2493
-- Data for Name: phoneno; Type: TABLE DATA; Schema: public; Owner: -
--

COPY phoneno (keyphoneno, phoneno, fkeyphonetype, fkeyemployee, domain) FROM stdin;
\.


--
-- TOC entry 4256 (class 0 OID 18266)
-- Dependencies: 2495
-- Data for Name: phonetype; Type: TABLE DATA; Schema: public; Owner: -
--

COPY phonetype (keyphonetype, phonetype) FROM stdin;
\.


--
-- TOC entry 4257 (class 0 OID 18273)
-- Dependencies: 2496
-- Data for Name: project; Type: TABLE DATA; Schema: public; Owner: -
--

COPY project (keyelement, daysbid, description, fkeyelement, fkeyelementstatus, fkeyelementtype, fkeyproject, fkeythumbnail, name, daysscheduled, daysestimated, status, filepath, fkeyassettype, fkeypathtemplate, fkeystatusset, allowtime, datestart, datecomplete, fkeyassettemplate, icon, compoutputdrive, datedue, filetype, fkeyclient, notes, renderoutputdrive, script, shortname, wipdrive, projectnumber, frames, nda, dayrate, usefilecreation, dailydrive, lastscanned, fkeyprojectstatus, assburnerweight, project, fps, resolution, resolutionwidth, resolutionheight, archived, deliverymedium, renderpixelaspect) FROM stdin;
\.


--
-- TOC entry 4258 (class 0 OID 18282)
-- Dependencies: 2498
-- Data for Name: projectresolution; Type: TABLE DATA; Schema: public; Owner: -
--

COPY projectresolution (keyprojectresolution, deliveryformat, fkeyproject, height, outputformat, projectresolution, width, pixelaspect, fps) FROM stdin;
3	Digibeta	762	1080	TGA	HD 1080	1920	1	24
\.


--
-- TOC entry 4259 (class 0 OID 18291)
-- Dependencies: 2500
-- Data for Name: projectstatus; Type: TABLE DATA; Schema: public; Owner: -
--

COPY projectstatus (keyprojectstatus, projectstatus, chronology) FROM stdin;
1	New	10
2	Production	20
3	Post-Production	30
4	Completed	40
\.


--
-- TOC entry 4260 (class 0 OID 18300)
-- Dependencies: 2502
-- Data for Name: projectstorage; Type: TABLE DATA; Schema: public; Owner: -
--

COPY projectstorage (keyprojectstorage, fkeyproject, name, location, storagename, "default", fkeyhost) FROM stdin;
\.


--
-- TOC entry 4261 (class 0 OID 18307)
-- Dependencies: 2503
-- Data for Name: projecttempo; Type: TABLE DATA; Schema: public; Owner: -
--

COPY projecttempo (fkeyproject, tempo) FROM stdin;
\N	0.001
\.


--
-- TOC entry 4262 (class 0 OID 18310)
-- Dependencies: 2504
-- Data for Name: rangefiletracker; Type: TABLE DATA; Schema: public; Owner: -
--

COPY rangefiletracker (keyfiletracker, fkeyelement, name, path, filename, fkeypathtemplate, fkeyprojectstorage, storagename, filenametemplate, framestart, frameend, fkeyresolution, renderelement) FROM stdin;
\.


--
-- TOC entry 4263 (class 0 OID 18319)
-- Dependencies: 2506
-- Data for Name: renderframe; Type: TABLE DATA; Schema: public; Owner: -
--

COPY renderframe (keyrenderframe, fkeyshot, frame, fkeyresolution, status) FROM stdin;
\.


--
-- TOC entry 4264 (class 0 OID 18328)
-- Dependencies: 2508
-- Data for Name: schedule; Type: TABLE DATA; Schema: public; Owner: -
--

COPY schedule (keyschedule, fkeyuser, date, starthour, hours, fkeyelement, fkeyassettype, fkeycreatedbyuser, duration, starttime) FROM stdin;
\.


--
-- TOC entry 4265 (class 0 OID 18332)
-- Dependencies: 2509
-- Data for Name: serverfileaction; Type: TABLE DATA; Schema: public; Owner: -
--

COPY serverfileaction (keyserverfileaction, fkeyserverfileactionstatus, fkeyserverfileactiontype, fkeyhost, destpath, errormessage, sourcepath) FROM stdin;
\.


--
-- TOC entry 4266 (class 0 OID 18340)
-- Dependencies: 2511
-- Data for Name: serverfileactionstatus; Type: TABLE DATA; Schema: public; Owner: -
--

COPY serverfileactionstatus (keyserverfileactionstatus, status, name) FROM stdin;
\.


--
-- TOC entry 4267 (class 0 OID 18348)
-- Dependencies: 2513
-- Data for Name: serverfileactiontype; Type: TABLE DATA; Schema: public; Owner: -
--

COPY serverfileactiontype (keyserverfileactiontype, type) FROM stdin;
\.


--
-- TOC entry 4268 (class 0 OID 18358)
-- Dependencies: 2516
-- Data for Name: service; Type: TABLE DATA; Schema: public; Owner: -
--

COPY service (keyservice, service, description, fkeylicense, enabled, forbiddenprocesses, active, "unique", fkeysoftware) FROM stdin;
3	Maya	\N	\N	t	maya.bin	\N	\N	\N
8	Fusion	\N	\N	t	Overseer.exe	\N	\N	\N
18	ShakeLinux	\N	\N	t	\N	\N	\N	\N
17	AfterEffects8	\N	\N	t	\N	\N	\N	\N
16	AB_reclaim_tasks	\N	\N	t	\N	\N	\N	\N
14	Spool	\N	\N	t	\N	\N	\N	\N
13	Autodesk_Burn	\N	\N	t	\N	\N	\N	\N
12	AB_manager	\N	\N	t	\N	\N	\N	\N
11	AB_manager	\N	\N	t	\N	\N	\N	\N
10	Batch	\N	\N	t	\N	\N	\N	\N
9	MentalRay	\N	1	t	\N	\N	\N	\N
15	Sync	\N	\N	t	\N	\N	\N	\N
7	RenderMan	\N	\N	t	\N	\N	\N	\N
4	Shake	\N	\N	t	\N	\N	\N	\N
2	AB_manager	\N	\N	t	\N	\N	\N	\N
1	Assburner	\N	\N	t	\N	\N	\N	\N
19	AB_manager	\N	\N	\N	\N	\N	\N	\N
6	AfterEffects7	\N	\N	t	\N	\N	\N	\N
24	LightFactory	\N	\N	t	\N	f	f	\N
20	Twixtor	\N	\N	t	\N	f	f	\N
21	Tinderbox1	\N	\N	t	\N	f	f	\N
22	Tinderbox2	\N	\N	t	\N	f	f	\N
23	Tinderbox3	\N	\N	t	\N	f	f	\N
25	AB_manager	\N	\N	\N	\N	\N	\N	\N
27	AB_manager	\N	\N	\N	\N	\N	\N	\N
30	AB_manager	\N	\N	\N	\N	\N	\N	\N
28	AfterEffectsPPC	\N	\N	t	\N	f	f	\N
29	AfterEffectsIntel	\N	\N	t	\N	f	f	\N
31	Storage	\N	\N	t	\N	\N	\N	\N
26	foobar	\N	\N	t	\N	t	f	\N
5	AB_Reaper	\N	\N	t	\N	t	\N	\N
32	Nuke	\N	16	t	\N	\N	\N	\N
33	Mantra	\N	\N	t	\N	\N	\N	\N
34	hbatch	\N	14	t	\N	t	\N	\N
37	GPU	\N	\N	t	\N	t	\N	\N
38	mocap_bmo_vac	\N	\N	t	\N	\N	\N	\N
39	prores	\N	\N	t	\N	t	\N	\N
35	fah	\N	15	t	\N	t	\N	\N
36	3Delight	\N	17	t	\N	t	\N	\N
40	cputest	\N	\N	t	\N	t	\N	\N
\.


--
-- TOC entry 4269 (class 0 OID 18365)
-- Dependencies: 2517
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY sessions (id, length, a_session, "time") FROM stdin;
\.


--
-- TOC entry 4270 (class 0 OID 18371)
-- Dependencies: 2518
-- Data for Name: shot; Type: TABLE DATA; Schema: public; Owner: -
--

COPY shot (keyelement, daysbid, description, fkeyelement, fkeyelementstatus, fkeyelementtype, fkeyproject, fkeythumbnail, name, daysscheduled, daysestimated, status, filepath, fkeyassettype, fkeypathtemplate, fkeystatusset, allowtime, datestart, datecomplete, fkeyassettemplate, icon, dialog, frameend, framestart, shot, framestartedl, frameendedl, camerainfo, scriptpage) FROM stdin;
\.


--
-- TOC entry 4271 (class 0 OID 18378)
-- Dependencies: 2519
-- Data for Name: shotgroup; Type: TABLE DATA; Schema: public; Owner: -
--

COPY shotgroup (keyelement, daysbid, description, fkeyelement, fkeyelementstatus, fkeyelementtype, fkeyproject, fkeythumbnail, name, daysscheduled, daysestimated, status, filepath, fkeyassettype, fkeypathtemplate, fkeystatusset, allowtime, datestart, datecomplete, fkeyassettemplate, icon, shotgroup) FROM stdin;
\.


--
-- TOC entry 4272 (class 0 OID 18387)
-- Dependencies: 2521
-- Data for Name: software; Type: TABLE DATA; Schema: public; Owner: -
--

COPY software (keysoftware, software, icon, vendor, vendorcontact, active, executable, installedpath, sixtyfourbit, version) FROM stdin;
1	Adobe Photoshop	\N	\N	\N	\N	\N	\N	\N	\N
2	Adobe Photoshop	\N	\N	\N	\N	\N	\N	\N	\N
3	Adobe After Effects	\N	\N	\N	\N	\N	\N	\N	\N
6	3dsMax	\N	\N	\N	\N	\N	\N	\N	\N
7	Boujou	\N	\N	\N	\N	\N	\N	\N	\N
8	Adobe Photoshop	\N	\N	\N	\N	\N	\N	\N	\N
9	Fusion	images/software/dfusion.png	\N	\N	\N	\N	\N	\N	\N
5	Maya	images/software/maya85.xpm	\N	\N	\N	\N	\N	\N	\N
4	Maya	images/software/maya70.xpm	\N	\N	\N	\N	\N	\N	\N
\.


--
-- TOC entry 4273 (class 0 OID 18394)
-- Dependencies: 2522
-- Data for Name: status; Type: TABLE DATA; Schema: public; Owner: -
--

COPY status (keystatus, name) FROM stdin;
\.


--
-- TOC entry 4274 (class 0 OID 18404)
-- Dependencies: 2525
-- Data for Name: statusset; Type: TABLE DATA; Schema: public; Owner: -
--

COPY statusset (keystatusset, name) FROM stdin;
\.


--
-- TOC entry 4275 (class 0 OID 18413)
-- Dependencies: 2527
-- Data for Name: syslog; Type: TABLE DATA; Schema: public; Owner: -
--

COPY syslog (keysyslog, fkeyhost, fkeysyslogrealm, fkeysyslogseverity, message, count, lastoccurrence, created, class, method, ack) FROM stdin;
\.


--
-- TOC entry 4276 (class 0 OID 18428)
-- Dependencies: 2530
-- Data for Name: syslogrealm; Type: TABLE DATA; Schema: public; Owner: -
--

COPY syslogrealm (keysyslogrealm, syslogrealm) FROM stdin;
1	Servers
2	Slaves
3	Security
4	System
5	Network
\.


--
-- TOC entry 4277 (class 0 OID 18437)
-- Dependencies: 2532
-- Data for Name: syslogseverity; Type: TABLE DATA; Schema: public; Owner: -
--

COPY syslogseverity (keysyslogseverity, syslogseverity, severity) FROM stdin;
1	Warning	Warning
2	Minor	Minor
3	Major	Major
4	Critical	Critical
\.


--
-- TOC entry 4278 (class 0 OID 18444)
-- Dependencies: 2533
-- Data for Name: task; Type: TABLE DATA; Schema: public; Owner: -
--

COPY task (keyelement, daysbid, description, fkeyelement, fkeyelementstatus, fkeyelementtype, fkeyproject, fkeythumbnail, name, daysscheduled, daysestimated, status, filepath, fkeyassettype, fkeypathtemplate, fkeystatusset, allowtime, datestart, datecomplete, fkeyassettemplate, icon, fkeytasktype, shotgroup) FROM stdin;
\.


--
-- TOC entry 4279 (class 0 OID 18453)
-- Dependencies: 2535
-- Data for Name: tasktype; Type: TABLE DATA; Schema: public; Owner: -
--

COPY tasktype (keytasktype, tasktype, iconcolor) FROM stdin;
\.


--
-- TOC entry 4280 (class 0 OID 18462)
-- Dependencies: 2537
-- Data for Name: taskuser; Type: TABLE DATA; Schema: public; Owner: -
--

COPY taskuser (keytaskuser, fkeytask, fkeyuser, active) FROM stdin;
\.


--
-- TOC entry 4281 (class 0 OID 18468)
-- Dependencies: 2539
-- Data for Name: thread; Type: TABLE DATA; Schema: public; Owner: -
--

COPY thread (keythread, thread, topic, tablename, fkey, datetime, fkeyauthor, skeyreply, fkeyusr, fkeythreadcategory) FROM stdin;
\.


--
-- TOC entry 4282 (class 0 OID 18477)
-- Dependencies: 2541
-- Data for Name: threadcategory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY threadcategory (keythreadcategory, threadcategory) FROM stdin;
\.


--
-- TOC entry 4283 (class 0 OID 18486)
-- Dependencies: 2543
-- Data for Name: threadnotify; Type: TABLE DATA; Schema: public; Owner: -
--

COPY threadnotify (keythreadnotify, fkeythread, fkeyuser, options) FROM stdin;
\.


--
-- TOC entry 4284 (class 0 OID 18492)
-- Dependencies: 2545
-- Data for Name: thumbnail; Type: TABLE DATA; Schema: public; Owner: -
--

COPY thumbnail (keythumbnail, cliprect, date, fkeyelement, fkeyuser, originalfile, image) FROM stdin;
\.


--
-- TOC entry 4285 (class 0 OID 18501)
-- Dependencies: 2547
-- Data for Name: timesheet; Type: TABLE DATA; Schema: public; Owner: -
--

COPY timesheet (keytimesheet, datetime, fkeyelement, fkeyemployee, fkeyproject, fkeytimesheetcategory, scheduledhour, datetimesubmitted, unscheduledhour, comment) FROM stdin;
\.


--
-- TOC entry 4286 (class 0 OID 18510)
-- Dependencies: 2549
-- Data for Name: timesheetcategory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY timesheetcategory (keytimesheetcategory, timesheetcategory, iconcolor, hasdaily, chronology, disabled, istask, fkeypathtemplate, fkeyelementtype, nameregexp, allowtime, color, description, sortcolumn, tags, sortnumber) FROM stdin;
172	Systems Administration	\N	\N	\N	0	f	\N	4		f	#d4d0c8		displayName	role	\N
168	Modeling Hair	\N	\N	\N	0	t	\N	4		t	#b5c2d6		displayName	schedule,timesheet	\N
36	Compositing	\N	\N	0	0	t	\N	4		t	#dea5a3		displayName	schedule,timesheet	\N
47	Maps	0	\N	0	1	t	\N	4	\N	t	#FFFFFF	\N	displayName	\N	\N
68	Light	\N	\N	\N	\N	f	\N	4	\N	f	#FFFFFF	\N	displayName	\N	\N
49	Animation	0	1	0	0	t	\N	4		t	#89c8b0		displayName	schedule,timesheet	\N
72	Asset Group	\N	\N	\N	0	f	0	6		f	#FFFFFF	\N	displayName	\N	\N
1	Layout	\N	1	40	0	t	\N	4		t	#dcb4c5	Animatic	displayName	schedule,timesheet	\N
42	Scene Assembly Prep	\N	\N	0	1	t	\N	4	\N	t	#FFFFFF	\N	displayName	\N	\N
69	Project	\N	\N	\N	0	f	4	1	[a-zA-Z0-9_]*	f	#c1afc3		displayName		\N
13	Character Set-up	\N	\N	90	1	t	\N	4	\N	t	#FFFFFF	\N	displayName	\N	\N
111	Rigging Face Robot	\N	\N	\N	0	t	1	4		t	#c2baa4		displayName	schedule,timesheet	\N
43	Rigging	\N	\N	0	0	t	\N	4		t	#c2baa4		displayName	schedule,timesheet	\N
20	Facial Clean-up	\N	\N	115	1	t	\N	4	\N	t	#FFFFFF	\N	displayName	\N	\N
78	Rigging Deformation	\N	\N	\N	0	t	\N	5		t	#c2baa4		displayName	schedule,timesheet	\N
53	Sample Still	0	\N	0	1	t	\N	4	\N	t	#FFFFFF	\N	displayName	\N	\N
50	Renders	0	\N	0	1	t	\N	4	\N	t	#FFFFFF	\N	displayName	\N	\N
28	Render farm	\N	\N	410	1	t	\N	4	\N	t	#FFFFFF	\N	displayName	\N	\N
44	Prop Rigging	0	\N	0	1	t	\N	4	\N	t	#FFFFFF	\N	displayName	\N	\N
51	Production	0	\N	0	0	t	0	4		f	#FFFFFF	\N	displayName	\N	\N
46	Pre_Production	0	\N	0	1	t	\N	4	\N	t	#FFFFFF	\N	displayName	\N	\N
63	Misc Rigging	\N	0	0	1	t	\N	4	\N	t	#FFFFFF	\N	displayName	\N	\N
32	Lighting	\N	\N	51	1	t	\N	4	\N	t	#FFFFFF	\N	displayName	\N	\N
79	Rigging Segment	\N	\N	\N	0	t	\N	5		t	#c2baa4		displayName	schedule,timesheet	\N
12	Mocap Body Clean-up	\N	\N	70	0	t	\N	4		t	#acbebc		displayName	schedule,timesheet,role	\N
80	Master Mesh	\N	\N	\N	0	t	0	5		f	#FFFFFF	\N	displayName	\N	\N
81	Master Rig	\N	\N	\N	0	t	0	5		f	#FFFFFF	\N	displayName	\N	\N
11	Mocap Body Session	\N	\N	60	0	t	\N	4		t	#acbebc		displayName	schedule,timesheet	\N
55	Reference	0	\N	0	0	t	0	4		f	#FFFFFF	\N	displayName	\N	\N
54	Materials	0	\N	0	0	t	0	4		f	#FFFFFF	\N	displayName	\N	\N
37	Mocap Direction	\N	\N	0	0	t	\N	4		t	#acbebc		displayName	schedule,timesheet	\N
115	Mocap Facial Clean-up	\N	\N	\N	0	t	\N	4		t	#acbebc		displayName	schedule,timesheet,role	\N
15	Mocap Facial Session	\N	\N	110	0	t	\N	4		t	#acbebc		displayName	schedule,timesheet	\N
25	Tutorials	\N	\N	430	0	t	\N	4		f	#d1c0c2		displayName		\N
10	R&D	\N	\N	30	0	t	\N	4		t	#989898		displayName	schedule,timesheet	\N
45	Information	0	\N	0	1	t	\N	4		t	#989898		displayName		\N
174	Vehicle	\N	\N	\N	0	t	26	4	^[^\\s]*$	t	#b5c2d6		displayName	schedule,timesheet,bid	\N
23	Mocap Prep	\N	\N	55	0	t	\N	4		t	#acbebc		displayName	schedule,timesheet,role	\N
2	Vacation	\N	\N	505	0	t	\N	4		t	#ffbfff	Vacation!!!!!!!!	displayName	schedule,timesheet	\N
56	Development	0	\N	0	0	t	\N	4		t	#dfdfdf		displayName	schedule,timesheet	\N
120	Audio	\N	\N	\N	0	f	1	4	Audio	f	#dfdfdf		displayName		\N
112	Human Resources	\N	\N	\N	0	t	0	4		t	#dfdfdf		displayName	role,schedule,timesheet	\N
9	Storyboards	\N	\N	20	0	t	\N	4		t	#dfdfdf		displayName	schedule,timesheet	\N
57	Bid	0	\N	0	0	t	0	4		f	#dfdfdf		displayName	schedule,timesheet	\N
130	Software Management	\N	\N	\N	0	t	0	4		t	#aaaaff		displayName	timesheet	\N
38	Animatic Modeling	\N	\N	0	1	t	\N	4		t	#dcb4c5		displayName	\N	\N
41	Morph Targets	\N	\N	0	0	t	0	4		f	#b5c2d6		displayName	\N	\N
26	Project prep	\N	\N	5	1	t	\N	4		t	#dfdfdf		displayName	\N	\N
122	Milestone	\N	\N	\N	0	t	\N	4		f	#ff898b		datestart	\N	\N
117	Credit List	\N	\N	\N	0	f	0	4		f	#000000		displayName	\N	\N
19	Scene Assembly	\N	1	150	0	t	\N	4		t	#dea5a3		displayName	timesheet,schedule	\N
126	Lead	\N	\N	\N	0	f	0	4		f	#d4d0c8	Lead and direct his/her team to create 3D animations and characters, using both key-frames and motion capture following the art direction and technical direction, cooperate with art director and technical director.	displayName	role	\N
166	Rigging Lead	\N	\N	\N	0	f	\N	4		f	#d4d0c8		displayName	role	\N
8	Concept Design	\N	\N	10	0	t	\N	4		t	#ecc4af		displayName	schedule,timesheet	\N
17	Cloth	\N	\N	130	0	t	\N	4		t	#d8c8dc		displayName	schedule,timesheet,role	\N
18	FX	\N	\N	140	0	t	\N	4		t	#c8c889		displayName	schedule,timesheet	\N
35	Holiday	\N	\N	508	0	t	\N	4		t	#ffbfff		displayName	schedule,timesheet	\N
175	Matte Painting	\N	\N	\N	0	f	\N	4		f	#ecc4af		displayName	schedule,timesheet	\N
4	Modeling	\N	\N	50	0	t	0	4		t	#b5c2d6		displayName	schedule,timesheet	\N
31	Modeling Texture	\N	\N	141	0	t	\N	4		t	#b5c2d6		displayName	schedule,timesheet	\N
3	Sick	\N	\N	510	0	t	\N	4		t	#ffbfff		displayName	schedule,timesheet	\N
29	Software	\N	\N	420	0	t	\N	4		t	#aaaaff		displayName	schedule,timesheet	\N
6	Supervise	\N	\N	1	0	t	\N	4		t	#dfdfdf		displayName	schedule,timesheet	\N
16	Animation Facial	\N	\N	120	0	t	0	4		t	#89c8b0		displayName	schedule,timesheet	\N
113	Animation Body Mocap	\N	\N	\N	0	t	0	4		t	#89c8b0		displayName	schedule,timesheet	\N
14	Animation Character 	\N	1	100	0	t	0	4		t	#89c8b0		displayName	schedule,timesheet	\N
114	Animation Facial Mocap	\N	\N	\N	0	t	0	4		t	#89c8b0		displayName	schedule,timesheet	\N
27	Scripting	\N	\N	400	0	t	\N	4		t	#989898		displayName	schedule,timesheet	\N
34	Unpaid Leave	\N	\N	507	0	t	\N	4		t	#ffbfff		displayName	schedule,timesheet	\N
40	Tech downtime	\N	\N	0	0	t	0	4		f	#ffbfff		displayName	timesheet	\N
59	Paid Leave	0	0	0	0	t	\N	4		t	#ffbfff		displayName	schedule,timesheet	\N
66	Prop	\N	\N	\N	0	t	18	4	^[^\\s]*$	t	#b5c2d6		displayName	schedule,timesheet	\N
39	Idle Time	\N	\N	0	0	t	0	4		f	#ffbfff		displayName		\N
65	Environment	\N	\N	\N	0	t	\N	4		t	#b5c2d6		displayName	schedule,timesheet	\N
70	Shot	\N	\N	\N	0	f	\N	3		f	#ffffff		shotNumber		\N
177	Layout Shot	\N	\N	\N	0	f	1	4	S(\\d+(?:\\.\\d+))	f	#efefef		displayName		\N
176	Layout Scene	\N	\N	\N	0	f	1	4	Ly(\\d+)	f	#efefef		displayName		\N
95	Point Cache	\N	\N	\N	0	f	1	4		f	#ffffff		displayName		\N
178	QC	\N	\N	55	0	t	\N	4		t	#d4d0c8	QC 	\N		0
24	Shag	\N	\N	135	1	t	\N	4	\N	t	#FFFFFF	\N	displayName	\N	\N
33	Comp Time	\N	\N	506	0	t	\N	4		t	#ffbfff		displayName	schedule,timesheet	\N
21	Editorial	\N	1	160	0	t	\N	4		t	#dfdfdf		displayName	schedule,timesheet	\N
121	Edit	\N	\N	\N	0	f	\N	4	Edit	f	#d4d0c8		displayName	\N	\N
179	Roto	\N	\N	\N	\N	t	\N	4	\N	t	\N	\N	displayName	\N	\N
\.


--
-- TOC entry 4287 (class 0 OID 18521)
-- Dependencies: 2551
-- Data for Name: tracker; Type: TABLE DATA; Schema: public; Owner: -
--

COPY tracker (keytracker, tracker, fkeysubmitter, fkeyassigned, fkeycategory, fkeyseverity, fkeystatus, datetarget, datechanged, datesubmitted, description, timeestimate, fkeytrackerqueue) FROM stdin;
\.


--
-- TOC entry 4288 (class 0 OID 18530)
-- Dependencies: 2553
-- Data for Name: trackercategory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY trackercategory (keytrackercategory, trackercategory) FROM stdin;
\.


--
-- TOC entry 4289 (class 0 OID 18539)
-- Dependencies: 2555
-- Data for Name: trackerlog; Type: TABLE DATA; Schema: public; Owner: -
--

COPY trackerlog (keytrackerlog, fkeytracker, fkeyusr, datelogged, message) FROM stdin;
\.


--
-- TOC entry 4290 (class 0 OID 18548)
-- Dependencies: 2557
-- Data for Name: trackerqueue; Type: TABLE DATA; Schema: public; Owner: -
--

COPY trackerqueue (keytrackerqueue, trackerqueue) FROM stdin;
\.


--
-- TOC entry 4291 (class 0 OID 18557)
-- Dependencies: 2559
-- Data for Name: trackerseverity; Type: TABLE DATA; Schema: public; Owner: -
--

COPY trackerseverity (keytrackerseverity, trackerseverity) FROM stdin;
\.


--
-- TOC entry 4292 (class 0 OID 18566)
-- Dependencies: 2561
-- Data for Name: trackerstatus; Type: TABLE DATA; Schema: public; Owner: -
--

COPY trackerstatus (keytrackerstatus, trackerstatus) FROM stdin;
\.


--
-- TOC entry 4293 (class 0 OID 18575)
-- Dependencies: 2563
-- Data for Name: userelement; Type: TABLE DATA; Schema: public; Owner: -
--

COPY userelement (keyuserelement, fkeyelement, fkeyusr, fkeyuser) FROM stdin;
\.


--
-- TOC entry 4294 (class 0 OID 18581)
-- Dependencies: 2565
-- Data for Name: usermapping; Type: TABLE DATA; Schema: public; Owner: -
--

COPY usermapping (keyusermapping, fkeyusr, fkeymapping) FROM stdin;
\.


--
-- TOC entry 4295 (class 0 OID 18587)
-- Dependencies: 2567
-- Data for Name: userrole; Type: TABLE DATA; Schema: public; Owner: -
--

COPY userrole (keyuserrole, fkeytasktype, fkeyusr) FROM stdin;
\.


--
-- TOC entry 4149 (class 0 OID 16868)
-- Dependencies: 2320
-- Data for Name: usr; Type: TABLE DATA; Schema: public; Owner: -
--

COPY usr (keyelement, daysbid, description, fkeyelement, fkeyelementstatus, fkeyelementtype, fkeyproject, fkeythumbnail, name, daysscheduled, daysestimated, status, filepath, fkeyassettype, fkeypathtemplate, fkeystatusset, allowtime, datestart, datecomplete, fkeyassettemplate, icon, dateoflastlogon, email, fkeyhost, gpgkey, jid, pager, password, remoteips, schedule, shell, uid, threadnotifybyjabber, threadnotifybyemail, fkeyclient, intranet, homedir, disabled, gid, usr, keyusr, rolemask, usrlevel, remoteok, requestcount, sessiontimeout, logoncount, useradded, oldkeyusr, sid, lastlogontype) FROM stdin;
\.


--
-- TOC entry 4296 (class 0 OID 18593)
-- Dependencies: 2569
-- Data for Name: usrgrp; Type: TABLE DATA; Schema: public; Owner: -
--

COPY usrgrp (keyusrgrp, fkeyusr, fkeygrp, usrgrp) FROM stdin;
\.


--
-- TOC entry 4297 (class 0 OID 18600)
-- Dependencies: 2570
-- Data for Name: version; Type: TABLE DATA; Schema: public; Owner: -
--

COPY version (keyversion) FROM stdin;
\.


--
-- TOC entry 4298 (class 0 OID 18605)
-- Dependencies: 2572
-- Data for Name: versionfiletracker; Type: TABLE DATA; Schema: public; Owner: -
--

COPY versionfiletracker (keyfiletracker, fkeyelement, name, path, filename, fkeypathtemplate, fkeyprojectstorage, storagename, filenametemplate, fkeyversionfiletracker, oldfilenames, version, iteration, automaster) FROM stdin;
\.


--
-- TOC entry 3664 (class 2606 OID 24185)
-- Dependencies: 2258 2258
-- Name: abdownloadstat_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY abdownloadstat
    ADD CONSTRAINT abdownloadstat_pkey PRIMARY KEY (keyabdownloadstat);


--
-- TOC entry 3666 (class 2606 OID 24187)
-- Dependencies: 2260 2260
-- Name: annotation_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY annotation
    ADD CONSTRAINT annotation_pkey PRIMARY KEY (keyannotation);


--
-- TOC entry 3671 (class 2606 OID 24189)
-- Dependencies: 2264 2264
-- Name: assetdep_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assetdep
    ADD CONSTRAINT assetdep_pkey PRIMARY KEY (keyassetdep);


--
-- TOC entry 3673 (class 2606 OID 24191)
-- Dependencies: 2267 2267
-- Name: assetprop_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assetprop
    ADD CONSTRAINT assetprop_pkey PRIMARY KEY (keyassetprop);


--
-- TOC entry 3675 (class 2606 OID 24193)
-- Dependencies: 2270 2270
-- Name: assetproperty_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assetproperty
    ADD CONSTRAINT assetproperty_pkey PRIMARY KEY (keyassetproperty);


--
-- TOC entry 3677 (class 2606 OID 24195)
-- Dependencies: 2271 2271
-- Name: assetproptype_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assetproptype
    ADD CONSTRAINT assetproptype_pkey PRIMARY KEY (keyassetproptype);


--
-- TOC entry 3679 (class 2606 OID 24197)
-- Dependencies: 2274 2274
-- Name: assetset_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assetset
    ADD CONSTRAINT assetset_pkey PRIMARY KEY (keyassetset);


--
-- TOC entry 3681 (class 2606 OID 24199)
-- Dependencies: 2276 2276
-- Name: assetsetitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assetsetitem
    ADD CONSTRAINT assetsetitem_pkey PRIMARY KEY (keyassetsetitem);


--
-- TOC entry 3683 (class 2606 OID 24201)
-- Dependencies: 2278 2278 2278 2278
-- Name: assettemplate_fkeyproject_fkeyassettype_name_unique; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assettemplate
    ADD CONSTRAINT assettemplate_fkeyproject_fkeyassettype_name_unique UNIQUE (fkeyproject, fkeyassettype, name);


--
-- TOC entry 3685 (class 2606 OID 24203)
-- Dependencies: 2278 2278
-- Name: assettemplate_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assettemplate
    ADD CONSTRAINT assettemplate_pkey PRIMARY KEY (keyassettemplate);


--
-- TOC entry 3687 (class 2606 OID 24205)
-- Dependencies: 2280 2280
-- Name: assettype_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assettype
    ADD CONSTRAINT assettype_pkey PRIMARY KEY (keyassettype);


--
-- TOC entry 3689 (class 2606 OID 24207)
-- Dependencies: 2282 2282
-- Name: attachment_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY attachment
    ADD CONSTRAINT attachment_pkey PRIMARY KEY (keyattachment);


--
-- TOC entry 3691 (class 2606 OID 24209)
-- Dependencies: 2284 2284
-- Name: attachmenttype_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY attachmenttype
    ADD CONSTRAINT attachmenttype_pkey PRIMARY KEY (keyattachmenttype);


--
-- TOC entry 3654 (class 2606 OID 24211)
-- Dependencies: 2250 2250 2250
-- Name: c_host_ip; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hostinterface
    ADD CONSTRAINT c_host_ip UNIQUE (fkeyhost, ip);


--
-- TOC entry 3693 (class 2606 OID 24213)
-- Dependencies: 2286 2286
-- Name: calendar_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY calendar
    ADD CONSTRAINT calendar_pkey PRIMARY KEY (keycalendar);


--
-- TOC entry 3695 (class 2606 OID 24215)
-- Dependencies: 2288 2288
-- Name: calendarcategory_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY calendarcategory
    ADD CONSTRAINT calendarcategory_pkey PRIMARY KEY (keycalendarcategory);


--
-- TOC entry 3697 (class 2606 OID 24217)
-- Dependencies: 2290 2290
-- Name: checklistitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY checklistitem
    ADD CONSTRAINT checklistitem_pkey PRIMARY KEY (keychecklistitem);


--
-- TOC entry 3699 (class 2606 OID 24219)
-- Dependencies: 2292 2292
-- Name: checkliststatus_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY checkliststatus
    ADD CONSTRAINT checkliststatus_pkey PRIMARY KEY (keycheckliststatus);


--
-- TOC entry 3701 (class 2606 OID 24221)
-- Dependencies: 2294 2294
-- Name: client_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY client
    ADD CONSTRAINT client_pkey PRIMARY KEY (keyclient);


--
-- TOC entry 3703 (class 2606 OID 24223)
-- Dependencies: 2296 2296
-- Name: config_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY config
    ADD CONSTRAINT config_pkey PRIMARY KEY (keyconfig);


--
-- TOC entry 3706 (class 2606 OID 24225)
-- Dependencies: 2299 2299
-- Name: deliveryelement_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY deliveryelement
    ADD CONSTRAINT deliveryelement_pkey PRIMARY KEY (keydeliveryshot);


--
-- TOC entry 3708 (class 2606 OID 24227)
-- Dependencies: 2301 2301
-- Name: demoreel_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY demoreel
    ADD CONSTRAINT demoreel_pkey PRIMARY KEY (keydemoreel);


--
-- TOC entry 3710 (class 2606 OID 24229)
-- Dependencies: 2303 2303
-- Name: diskimage_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY diskimage
    ADD CONSTRAINT diskimage_pkey PRIMARY KEY (keydiskimage);


--
-- TOC entry 3714 (class 2606 OID 24231)
-- Dependencies: 2307 2307
-- Name: dynamichostgroup_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY dynamichostgroup
    ADD CONSTRAINT dynamichostgroup_pkey PRIMARY KEY (keydynamichostgroup);


--
-- TOC entry 3669 (class 2606 OID 24233)
-- Dependencies: 2262 2262
-- Name: element_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY element
    ADD CONSTRAINT element_pkey PRIMARY KEY (keyelement);


--
-- TOC entry 3716 (class 2606 OID 24235)
-- Dependencies: 2309 2309
-- Name: elementdep_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY elementdep
    ADD CONSTRAINT elementdep_pkey PRIMARY KEY (keyelementdep);


--
-- TOC entry 3718 (class 2606 OID 24237)
-- Dependencies: 2311 2311
-- Name: elementstatus_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY elementstatus
    ADD CONSTRAINT elementstatus_pkey PRIMARY KEY (keyelementstatus);


--
-- TOC entry 3720 (class 2606 OID 24239)
-- Dependencies: 2313 2313
-- Name: elementthread_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY elementthread
    ADD CONSTRAINT elementthread_pkey PRIMARY KEY (keyelementthread);


--
-- TOC entry 3722 (class 2606 OID 24241)
-- Dependencies: 2315 2315
-- Name: elementtype_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY elementtype
    ADD CONSTRAINT elementtype_pkey PRIMARY KEY (keyelementtype);


--
-- TOC entry 3724 (class 2606 OID 24243)
-- Dependencies: 2317 2317
-- Name: elementtypetasktype_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY elementtypetasktype
    ADD CONSTRAINT elementtypetasktype_pkey PRIMARY KEY (keyelementtypetasktype);


--
-- TOC entry 3726 (class 2606 OID 24245)
-- Dependencies: 2319 2319
-- Name: elementuser_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY elementuser
    ADD CONSTRAINT elementuser_pkey PRIMARY KEY (keyelementuser);


--
-- TOC entry 3734 (class 2606 OID 24247)
-- Dependencies: 2323 2323
-- Name: eventalert_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY eventalert
    ADD CONSTRAINT eventalert_pkey PRIMARY KEY ("keyEventAlert");


--
-- TOC entry 3736 (class 2606 OID 24249)
-- Dependencies: 2325 2325
-- Name: filetemplate_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY filetemplate
    ADD CONSTRAINT filetemplate_pkey PRIMARY KEY (keyfiletemplate);


--
-- TOC entry 3738 (class 2606 OID 24251)
-- Dependencies: 2327 2327
-- Name: filetracker_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY filetracker
    ADD CONSTRAINT filetracker_pkey PRIMARY KEY (keyfiletracker);


--
-- TOC entry 3743 (class 2606 OID 24253)
-- Dependencies: 2329 2329
-- Name: filetrackerdep_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY filetrackerdep
    ADD CONSTRAINT filetrackerdep_pkey PRIMARY KEY (keyfiletrackerdep);


--
-- TOC entry 3747 (class 2606 OID 24255)
-- Dependencies: 2331 2331
-- Name: fileversion_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY fileversion
    ADD CONSTRAINT fileversion_pkey PRIMARY KEY (keyfileversion);


--
-- TOC entry 3749 (class 2606 OID 24257)
-- Dependencies: 2333 2333
-- Name: folder_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY folder
    ADD CONSTRAINT folder_pkey PRIMARY KEY (keyfolder);


--
-- TOC entry 3751 (class 2606 OID 24259)
-- Dependencies: 2335 2335
-- Name: graph_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY graph
    ADD CONSTRAINT graph_pkey PRIMARY KEY (keygraph);


--
-- TOC entry 3753 (class 2606 OID 24261)
-- Dependencies: 2337 2337
-- Name: graphds_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY graphds
    ADD CONSTRAINT graphds_pkey PRIMARY KEY (keygraphds);


--
-- TOC entry 3755 (class 2606 OID 24263)
-- Dependencies: 2339 2339
-- Name: graphpage_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY graphpage
    ADD CONSTRAINT graphpage_pkey PRIMARY KEY (keygraphpage);


--
-- TOC entry 3757 (class 2606 OID 24265)
-- Dependencies: 2341 2341
-- Name: graphrel_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY graphrelationship
    ADD CONSTRAINT graphrel_pkey PRIMARY KEY (keygraphrelationship);


--
-- TOC entry 3759 (class 2606 OID 24267)
-- Dependencies: 2343 2343
-- Name: gridtemplate_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY gridtemplate
    ADD CONSTRAINT gridtemplate_pkey PRIMARY KEY (keygridtemplate);


--
-- TOC entry 3761 (class 2606 OID 24269)
-- Dependencies: 2345 2345
-- Name: gridtemplateitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY gridtemplateitem
    ADD CONSTRAINT gridtemplateitem_pkey PRIMARY KEY (keygridtemplateitem);


--
-- TOC entry 3763 (class 2606 OID 24271)
-- Dependencies: 2347 2347
-- Name: groupmapping_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY groupmapping
    ADD CONSTRAINT groupmapping_pkey PRIMARY KEY (keygroupmapping);


--
-- TOC entry 3765 (class 2606 OID 24273)
-- Dependencies: 2349 2349
-- Name: grp_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY grp
    ADD CONSTRAINT grp_pkey PRIMARY KEY (keygrp);


--
-- TOC entry 3767 (class 2606 OID 24275)
-- Dependencies: 2351 2351
-- Name: gruntscript_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY gruntscript
    ADD CONSTRAINT gruntscript_pkey PRIMARY KEY (keygruntscript);


--
-- TOC entry 3769 (class 2606 OID 24277)
-- Dependencies: 2353 2353
-- Name: history_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY history
    ADD CONSTRAINT history_pkey PRIMARY KEY (keyhistory);


--
-- TOC entry 3652 (class 2606 OID 24279)
-- Dependencies: 2248 2248
-- Name: host_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY host
    ADD CONSTRAINT host_pkey PRIMARY KEY (keyhost);


--
-- TOC entry 3771 (class 2606 OID 24281)
-- Dependencies: 2355 2355
-- Name: hostdailystat_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hostdailystat
    ADD CONSTRAINT hostdailystat_pkey PRIMARY KEY (keyhostdailystat);


--
-- TOC entry 3712 (class 2606 OID 24283)
-- Dependencies: 2306 2306
-- Name: hostgroup_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hostgroup
    ADD CONSTRAINT hostgroup_pkey PRIMARY KEY (keyhostgroup);


--
-- TOC entry 3775 (class 2606 OID 24285)
-- Dependencies: 2357 2357
-- Name: hostgroupitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hostgroupitem
    ADD CONSTRAINT hostgroupitem_pkey PRIMARY KEY (keyhostgroupitem);


--
-- TOC entry 3642 (class 2606 OID 24287)
-- Dependencies: 2234 2234
-- Name: hosthistory_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hosthistory
    ADD CONSTRAINT hosthistory_pkey PRIMARY KEY (keyhosthistory);


--
-- TOC entry 3656 (class 2606 OID 24289)
-- Dependencies: 2250 2250
-- Name: hostinterface_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hostinterface
    ADD CONSTRAINT hostinterface_pkey PRIMARY KEY (keyhostinterface);


--
-- TOC entry 3777 (class 2606 OID 24291)
-- Dependencies: 2359 2359
-- Name: hostinterfacetype_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hostinterfacetype
    ADD CONSTRAINT hostinterfacetype_pkey PRIMARY KEY (keyhostinterfacetype);


--
-- TOC entry 3779 (class 2606 OID 24293)
-- Dependencies: 2361 2361
-- Name: hostload_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hostload
    ADD CONSTRAINT hostload_pkey PRIMARY KEY (keyhostload);


--
-- TOC entry 3781 (class 2606 OID 24295)
-- Dependencies: 2363 2363
-- Name: hostmapping_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hostmapping
    ADD CONSTRAINT hostmapping_pkey PRIMARY KEY (keyhostmapping);


--
-- TOC entry 3784 (class 2606 OID 24297)
-- Dependencies: 2365 2365
-- Name: hostport_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hostport
    ADD CONSTRAINT hostport_pkey PRIMARY KEY (keyhostport);


--
-- TOC entry 3786 (class 2606 OID 24299)
-- Dependencies: 2367 2367
-- Name: hostresource_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hostresource
    ADD CONSTRAINT hostresource_pkey PRIMARY KEY (keyhostresource);


--
-- TOC entry 3788 (class 2606 OID 24301)
-- Dependencies: 2371 2371
-- Name: hostservice_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hostservice
    ADD CONSTRAINT hostservice_pkey PRIMARY KEY (keyhostservice);


--
-- TOC entry 3794 (class 2606 OID 24303)
-- Dependencies: 2373 2373
-- Name: hostsoftware_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hostsoftware
    ADD CONSTRAINT hostsoftware_pkey PRIMARY KEY (keyhostsoftware);


--
-- TOC entry 3796 (class 2606 OID 24305)
-- Dependencies: 2375 2375
-- Name: hoststatus_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hoststatus
    ADD CONSTRAINT hoststatus_pkey PRIMARY KEY (keyhoststatus);


--
-- TOC entry 3648 (class 2606 OID 24307)
-- Dependencies: 2236 2236
-- Name: job_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY job
    ADD CONSTRAINT job_pkey PRIMARY KEY (keyjob);


--
-- TOC entry 3800 (class 2606 OID 24309)
-- Dependencies: 2377 2377
-- Name: jobae_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobaftereffects
    ADD CONSTRAINT jobae_pkey PRIMARY KEY (keyjob);


--
-- TOC entry 3806 (class 2606 OID 24311)
-- Dependencies: 2380 2380
-- Name: jobassignment_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobassignment
    ADD CONSTRAINT jobassignment_pkey PRIMARY KEY (keyjobassignment);


--
-- TOC entry 3809 (class 2606 OID 24313)
-- Dependencies: 2382 2382
-- Name: jobassignmentstatus_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobassignmentstatus
    ADD CONSTRAINT jobassignmentstatus_pkey PRIMARY KEY (keyjobassignmentstatus);


--
-- TOC entry 3815 (class 2606 OID 24315)
-- Dependencies: 2387 2387
-- Name: jobcannedbatch_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobcannedbatch
    ADD CONSTRAINT jobcannedbatch_pkey PRIMARY KEY (keyjobcannedbatch);


--
-- TOC entry 3818 (class 2606 OID 24317)
-- Dependencies: 2390 2390
-- Name: jobcommandhistory_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobcommandhistory
    ADD CONSTRAINT jobcommandhistory_pkey PRIMARY KEY (keyjobcommandhistory);


--
-- TOC entry 3823 (class 2606 OID 24319)
-- Dependencies: 2392 2392
-- Name: jobdep_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobdep
    ADD CONSTRAINT jobdep_pkey PRIMARY KEY (keyjobdep);


--
-- TOC entry 3825 (class 2606 OID 24321)
-- Dependencies: 2394 2394
-- Name: joberror_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY joberror
    ADD CONSTRAINT joberror_pkey PRIMARY KEY (keyjoberror);


--
-- TOC entry 3829 (class 2606 OID 24323)
-- Dependencies: 2396 2396
-- Name: joberrorhandler_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY joberrorhandler
    ADD CONSTRAINT joberrorhandler_pkey PRIMARY KEY (keyjoberrorhandler);


--
-- TOC entry 3831 (class 2606 OID 24325)
-- Dependencies: 2398 2398
-- Name: joberrorhandlerscript_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY joberrorhandlerscript
    ADD CONSTRAINT joberrorhandlerscript_pkey PRIMARY KEY (keyjoberrorhandlerscript);


--
-- TOC entry 3833 (class 2606 OID 24327)
-- Dependencies: 2402 2402
-- Name: jobhistory_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobhistory
    ADD CONSTRAINT jobhistory_pkey PRIMARY KEY (keyjobhistory);


--
-- TOC entry 3835 (class 2606 OID 24329)
-- Dependencies: 2404 2404
-- Name: jobhistorytype_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobhistorytype
    ADD CONSTRAINT jobhistorytype_pkey PRIMARY KEY (keyjobhistorytype);


--
-- TOC entry 3837 (class 2606 OID 24331)
-- Dependencies: 2406 2406
-- Name: jobmantra100_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobmantra100
    ADD CONSTRAINT jobmantra100_pkey PRIMARY KEY (keyjobmantra100);


--
-- TOC entry 3839 (class 2606 OID 24333)
-- Dependencies: 2408 2408
-- Name: jobmantra95_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobmantra95
    ADD CONSTRAINT jobmantra95_pkey PRIMARY KEY (keyjobmantra95);


--
-- TOC entry 3843 (class 2606 OID 24335)
-- Dependencies: 2413 2413
-- Name: jobmax5_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobmax5
    ADD CONSTRAINT jobmax5_pkey PRIMARY KEY (keyjob);


--
-- TOC entry 3845 (class 2606 OID 24337)
-- Dependencies: 2416 2416
-- Name: jobmax8_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobmax8
    ADD CONSTRAINT jobmax8_pkey PRIMARY KEY (keyjob);


--
-- TOC entry 3859 (class 2606 OID 24339)
-- Dependencies: 2431 2431
-- Name: joboutput_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY joboutput
    ADD CONSTRAINT joboutput_pkey PRIMARY KEY (keyjoboutput);


--
-- TOC entry 3861 (class 2606 OID 24341)
-- Dependencies: 2432 2432
-- Name: jobrealflow_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobrealflow
    ADD CONSTRAINT jobrealflow_pkey PRIMARY KEY (keyjobrealflow);


--
-- TOC entry 3863 (class 2606 OID 24343)
-- Dependencies: 2435 2435
-- Name: jobrenderman_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobrenderman
    ADD CONSTRAINT jobrenderman_pkey PRIMARY KEY (keyjob);


--
-- TOC entry 3865 (class 2606 OID 24345)
-- Dependencies: 2437 2437
-- Name: jobribgen_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobribgen
    ADD CONSTRAINT jobribgen_pkey PRIMARY KEY (keyjob);


--
-- TOC entry 3867 (class 2606 OID 24347)
-- Dependencies: 2439 2439
-- Name: jobservice_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobservice
    ADD CONSTRAINT jobservice_pkey PRIMARY KEY (keyjobservice);


--
-- TOC entry 3870 (class 2606 OID 24349)
-- Dependencies: 2440 2440
-- Name: jobshake_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobshake
    ADD CONSTRAINT jobshake_pkey PRIMARY KEY (keyjob);


--
-- TOC entry 3872 (class 2606 OID 24351)
-- Dependencies: 2443 2443
-- Name: jobstat_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobstat
    ADD CONSTRAINT jobstat_pkey PRIMARY KEY (keyjobstat);


--
-- TOC entry 3874 (class 2606 OID 24353)
-- Dependencies: 2445 2445
-- Name: jobstatus_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobstatus
    ADD CONSTRAINT jobstatus_pkey PRIMARY KEY (keyjobstatus);


--
-- TOC entry 3660 (class 2606 OID 24355)
-- Dependencies: 2253 2253
-- Name: jobtask_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobtask
    ADD CONSTRAINT jobtask_pkey PRIMARY KEY (keyjobtask);


--
-- TOC entry 3879 (class 2606 OID 24357)
-- Dependencies: 2448 2448
-- Name: jobtaskassignment_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobtaskassignment
    ADD CONSTRAINT jobtaskassignment_pkey PRIMARY KEY (keyjobtaskassignment);


--
-- TOC entry 3662 (class 2606 OID 24359)
-- Dependencies: 2255 2255
-- Name: jobtype_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobtype
    ADD CONSTRAINT jobtype_pkey PRIMARY KEY (keyjobtype);


--
-- TOC entry 3881 (class 2606 OID 24361)
-- Dependencies: 2451 2451
-- Name: jobtypemapping_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobtypemapping
    ADD CONSTRAINT jobtypemapping_pkey PRIMARY KEY (keyjobtypemapping);


--
-- TOC entry 3883 (class 2606 OID 24363)
-- Dependencies: 2455 2455
-- Name: license_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY license
    ADD CONSTRAINT license_pkey PRIMARY KEY (keylicense);


--
-- TOC entry 3885 (class 2606 OID 24365)
-- Dependencies: 2457 2457
-- Name: location_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY location
    ADD CONSTRAINT location_pkey PRIMARY KEY (keylocation);


--
-- TOC entry 3887 (class 2606 OID 24367)
-- Dependencies: 2459 2459
-- Name: mapping_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY mapping
    ADD CONSTRAINT mapping_pkey PRIMARY KEY (keymapping);


--
-- TOC entry 3889 (class 2606 OID 24369)
-- Dependencies: 2461 2461
-- Name: mappingtype_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY mappingtype
    ADD CONSTRAINT mappingtype_pkey PRIMARY KEY (keymappingtype);


--
-- TOC entry 3891 (class 2606 OID 24371)
-- Dependencies: 2463 2463
-- Name: methodperms_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY methodperms
    ADD CONSTRAINT methodperms_pkey PRIMARY KEY (keymethodperms);


--
-- TOC entry 3893 (class 2606 OID 24373)
-- Dependencies: 2465 2465
-- Name: notification_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (keynotification);


--
-- TOC entry 3895 (class 2606 OID 24375)
-- Dependencies: 2467 2467
-- Name: notificationdestination_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notificationdestination
    ADD CONSTRAINT notificationdestination_pkey PRIMARY KEY (keynotificationdestination);


--
-- TOC entry 3897 (class 2606 OID 24377)
-- Dependencies: 2469 2469
-- Name: notificationmethod_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notificationmethod
    ADD CONSTRAINT notificationmethod_pkey PRIMARY KEY (keynotificationmethod);


--
-- TOC entry 3899 (class 2606 OID 24379)
-- Dependencies: 2471 2471
-- Name: notificationroute_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notificationroute
    ADD CONSTRAINT notificationroute_pkey PRIMARY KEY (keynotificationuserroute);


--
-- TOC entry 3901 (class 2606 OID 24381)
-- Dependencies: 2473 2473
-- Name: notify_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notify
    ADD CONSTRAINT notify_pkey PRIMARY KEY (keynotify);


--
-- TOC entry 3903 (class 2606 OID 24383)
-- Dependencies: 2475 2475
-- Name: notifymethod_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notifymethod
    ADD CONSTRAINT notifymethod_pkey PRIMARY KEY (keynotifymethod);


--
-- TOC entry 3905 (class 2606 OID 24385)
-- Dependencies: 2477 2477
-- Name: notifysent_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notifysent
    ADD CONSTRAINT notifysent_pkey PRIMARY KEY (keynotifysent);


--
-- TOC entry 3907 (class 2606 OID 24387)
-- Dependencies: 2479 2479
-- Name: notifywho_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notifywho
    ADD CONSTRAINT notifywho_pkey PRIMARY KEY (keynotifywho);


--
-- TOC entry 3909 (class 2606 OID 24389)
-- Dependencies: 2480 2480
-- Name: package_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY package
    ADD CONSTRAINT package_pkey PRIMARY KEY (keypackage);


--
-- TOC entry 3911 (class 2606 OID 24391)
-- Dependencies: 2482 2482
-- Name: packageoutput_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY packageoutput
    ADD CONSTRAINT packageoutput_pkey PRIMARY KEY (keypackageoutput);


--
-- TOC entry 3913 (class 2606 OID 24393)
-- Dependencies: 2485 2485
-- Name: pathsynctarget_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pathsynctarget
    ADD CONSTRAINT pathsynctarget_pkey PRIMARY KEY (keypathsynctarget);


--
-- TOC entry 3915 (class 2606 OID 24395)
-- Dependencies: 2487 2487
-- Name: pathtemplate_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pathtemplate
    ADD CONSTRAINT pathtemplate_pkey PRIMARY KEY (keypathtemplate);


--
-- TOC entry 3917 (class 2606 OID 24397)
-- Dependencies: 2489 2489
-- Name: pathtracker_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pathtracker
    ADD CONSTRAINT pathtracker_pkey PRIMARY KEY (keypathtracker);


--
-- TOC entry 3919 (class 2606 OID 24399)
-- Dependencies: 2491 2491
-- Name: permission_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY permission
    ADD CONSTRAINT permission_pkey PRIMARY KEY (keypermission);


--
-- TOC entry 3921 (class 2606 OID 24401)
-- Dependencies: 2493 2493
-- Name: phoneno_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY phoneno
    ADD CONSTRAINT phoneno_pkey PRIMARY KEY (keyphoneno);


--
-- TOC entry 3923 (class 2606 OID 24403)
-- Dependencies: 2495 2495
-- Name: phonetype_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY phonetype
    ADD CONSTRAINT phonetype_pkey PRIMARY KEY (keyphonetype);


--
-- TOC entry 3802 (class 2606 OID 24405)
-- Dependencies: 2378 2378
-- Name: pkey_aftereffects7; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobaftereffects7
    ADD CONSTRAINT pkey_aftereffects7 PRIMARY KEY (keyjob);


--
-- TOC entry 3804 (class 2606 OID 24407)
-- Dependencies: 2379 2379
-- Name: pkey_aftereffects8; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobaftereffects8
    ADD CONSTRAINT pkey_aftereffects8 PRIMARY KEY (keyjob);


--
-- TOC entry 3732 (class 2606 OID 24409)
-- Dependencies: 2321 2321
-- Name: pkey_employee; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employee
    ADD CONSTRAINT pkey_employee PRIMARY KEY (keyelement);


--
-- TOC entry 3848 (class 2606 OID 24411)
-- Dependencies: 2420 2420
-- Name: pkey_job_maya2008; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobmaya2008
    ADD CONSTRAINT pkey_job_maya2008 PRIMARY KEY (keyjob);


--
-- TOC entry 3850 (class 2606 OID 24413)
-- Dependencies: 2421 2421
-- Name: pkey_job_maya2009; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobmaya2009
    ADD CONSTRAINT pkey_job_maya2009 PRIMARY KEY (keyjob);


--
-- TOC entry 3852 (class 2606 OID 24415)
-- Dependencies: 2424 2424
-- Name: pkey_job_maya85; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobmaya85
    ADD CONSTRAINT pkey_job_maya85 PRIMARY KEY (keyjob);


--
-- TOC entry 3811 (class 2606 OID 24417)
-- Dependencies: 2384 2384
-- Name: pkey_jobautodeskburn; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobautodeskburn
    ADD CONSTRAINT pkey_jobautodeskburn PRIMARY KEY (keyjob);


--
-- TOC entry 3813 (class 2606 OID 24419)
-- Dependencies: 2385 2385
-- Name: pkey_jobbatch; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobbatch
    ADD CONSTRAINT pkey_jobbatch PRIMARY KEY (keyjob);


--
-- TOC entry 3854 (class 2606 OID 24421)
-- Dependencies: 2427 2427
-- Name: pkey_jobmentalray85; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobmentalray85
    ADD CONSTRAINT pkey_jobmentalray85 PRIMARY KEY (keyjob);


--
-- TOC entry 3856 (class 2606 OID 24423)
-- Dependencies: 2428 2428
-- Name: pkey_jobnuke51; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobnuke51
    ADD CONSTRAINT pkey_jobnuke51 PRIMARY KEY (keyjob);


--
-- TOC entry 3877 (class 2606 OID 24425)
-- Dependencies: 2446 2446
-- Name: pkey_jobsync; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobsync
    ADD CONSTRAINT pkey_jobsync PRIMARY KEY (keyjob);


--
-- TOC entry 3950 (class 2606 OID 24427)
-- Dependencies: 2518 2518
-- Name: pkey_shot; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY shot
    ADD CONSTRAINT pkey_shot PRIMARY KEY (keyelement);


--
-- TOC entry 3952 (class 2606 OID 24429)
-- Dependencies: 2519 2519
-- Name: pkey_shotgroup; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY shotgroup
    ADD CONSTRAINT pkey_shotgroup PRIMARY KEY (keyelement);


--
-- TOC entry 3967 (class 2606 OID 24431)
-- Dependencies: 2533 2533
-- Name: pkey_task; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY task
    ADD CONSTRAINT pkey_task PRIMARY KEY (keyelement);


--
-- TOC entry 3730 (class 2606 OID 24433)
-- Dependencies: 2320 2320
-- Name: pkey_usr; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY usr
    ADD CONSTRAINT pkey_usr PRIMARY KEY (keyelement);


--
-- TOC entry 3925 (class 2606 OID 24435)
-- Dependencies: 2496 2496
-- Name: project_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY project
    ADD CONSTRAINT project_pkey PRIMARY KEY (keyelement);


--
-- TOC entry 3927 (class 2606 OID 24437)
-- Dependencies: 2498 2498
-- Name: projectresolution_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY projectresolution
    ADD CONSTRAINT projectresolution_pkey PRIMARY KEY (keyprojectresolution);


--
-- TOC entry 3929 (class 2606 OID 24439)
-- Dependencies: 2500 2500
-- Name: projectstatus_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY projectstatus
    ADD CONSTRAINT projectstatus_pkey PRIMARY KEY (keyprojectstatus);


--
-- TOC entry 3931 (class 2606 OID 24441)
-- Dependencies: 2502 2502
-- Name: projectstorage_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY projectstorage
    ADD CONSTRAINT projectstorage_pkey PRIMARY KEY (keyprojectstorage);


--
-- TOC entry 3936 (class 2606 OID 24443)
-- Dependencies: 2506 2506
-- Name: renderframe_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY renderframe
    ADD CONSTRAINT renderframe_pkey PRIMARY KEY (keyrenderframe);


--
-- TOC entry 3938 (class 2606 OID 24445)
-- Dependencies: 2508 2508
-- Name: schedule_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY schedule
    ADD CONSTRAINT schedule_pkey PRIMARY KEY (keyschedule);


--
-- TOC entry 3942 (class 2606 OID 24447)
-- Dependencies: 2509 2509
-- Name: serverfileaction_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY serverfileaction
    ADD CONSTRAINT serverfileaction_pkey PRIMARY KEY (keyserverfileaction);


--
-- TOC entry 3944 (class 2606 OID 24449)
-- Dependencies: 2511 2511
-- Name: serverfileactionstatus_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY serverfileactionstatus
    ADD CONSTRAINT serverfileactionstatus_pkey PRIMARY KEY (keyserverfileactionstatus);


--
-- TOC entry 3946 (class 2606 OID 24451)
-- Dependencies: 2513 2513
-- Name: serverfileactiontype_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY serverfileactiontype
    ADD CONSTRAINT serverfileactiontype_pkey PRIMARY KEY (keyserverfileactiontype);


--
-- TOC entry 3948 (class 2606 OID 24453)
-- Dependencies: 2516 2516
-- Name: service_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY service
    ADD CONSTRAINT service_pkey PRIMARY KEY (keyservice);


--
-- TOC entry 3954 (class 2606 OID 24455)
-- Dependencies: 2521 2521
-- Name: software_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY software
    ADD CONSTRAINT software_pkey PRIMARY KEY (keysoftware);


--
-- TOC entry 3956 (class 2606 OID 24457)
-- Dependencies: 2522 2522
-- Name: status_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY status
    ADD CONSTRAINT status_pkey PRIMARY KEY (keystatus);


--
-- TOC entry 3958 (class 2606 OID 24459)
-- Dependencies: 2525 2525
-- Name: statusset_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY statusset
    ADD CONSTRAINT statusset_pkey PRIMARY KEY (keystatusset);


--
-- TOC entry 3960 (class 2606 OID 24461)
-- Dependencies: 2527 2527
-- Name: syslog_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY syslog
    ADD CONSTRAINT syslog_pkey PRIMARY KEY (keysyslog);


--
-- TOC entry 3963 (class 2606 OID 24463)
-- Dependencies: 2530 2530
-- Name: syslogrealm_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY syslogrealm
    ADD CONSTRAINT syslogrealm_pkey PRIMARY KEY (keysyslogrealm);


--
-- TOC entry 3965 (class 2606 OID 24465)
-- Dependencies: 2532 2532
-- Name: syslogseverity_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY syslogseverity
    ADD CONSTRAINT syslogseverity_pkey PRIMARY KEY (keysyslogseverity);


--
-- TOC entry 3969 (class 2606 OID 24467)
-- Dependencies: 2535 2535
-- Name: tasktype_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tasktype
    ADD CONSTRAINT tasktype_pkey PRIMARY KEY (keytasktype);


--
-- TOC entry 3971 (class 2606 OID 24469)
-- Dependencies: 2537 2537
-- Name: taskuser_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY taskuser
    ADD CONSTRAINT taskuser_pkey PRIMARY KEY (keytaskuser);


--
-- TOC entry 3973 (class 2606 OID 24471)
-- Dependencies: 2539 2539
-- Name: thread_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY thread
    ADD CONSTRAINT thread_pkey PRIMARY KEY (keythread);


--
-- TOC entry 3975 (class 2606 OID 24473)
-- Dependencies: 2541 2541
-- Name: threadcategory_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY threadcategory
    ADD CONSTRAINT threadcategory_pkey PRIMARY KEY (keythreadcategory);


--
-- TOC entry 3977 (class 2606 OID 24475)
-- Dependencies: 2543 2543
-- Name: threadnotify_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY threadnotify
    ADD CONSTRAINT threadnotify_pkey PRIMARY KEY (keythreadnotify);


--
-- TOC entry 3979 (class 2606 OID 24477)
-- Dependencies: 2545 2545
-- Name: thumbnail_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY thumbnail
    ADD CONSTRAINT thumbnail_pkey PRIMARY KEY (keythumbnail);


--
-- TOC entry 3981 (class 2606 OID 24479)
-- Dependencies: 2547 2547
-- Name: timesheet_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY timesheet
    ADD CONSTRAINT timesheet_pkey PRIMARY KEY (keytimesheet);


--
-- TOC entry 3985 (class 2606 OID 24481)
-- Dependencies: 2549 2549
-- Name: timesheetcategory_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY timesheetcategory
    ADD CONSTRAINT timesheetcategory_pkey PRIMARY KEY (keytimesheetcategory);


--
-- TOC entry 3987 (class 2606 OID 24483)
-- Dependencies: 2551 2551
-- Name: tracker_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tracker
    ADD CONSTRAINT tracker_pkey PRIMARY KEY (keytracker);


--
-- TOC entry 3989 (class 2606 OID 24485)
-- Dependencies: 2553 2553
-- Name: trackercategory_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY trackercategory
    ADD CONSTRAINT trackercategory_pkey PRIMARY KEY (keytrackercategory);


--
-- TOC entry 3991 (class 2606 OID 24487)
-- Dependencies: 2555 2555
-- Name: trackerlog_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY trackerlog
    ADD CONSTRAINT trackerlog_pkey PRIMARY KEY (keytrackerlog);


--
-- TOC entry 3993 (class 2606 OID 24489)
-- Dependencies: 2557 2557
-- Name: trackerqueue_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY trackerqueue
    ADD CONSTRAINT trackerqueue_pkey PRIMARY KEY (keytrackerqueue);


--
-- TOC entry 3995 (class 2606 OID 24491)
-- Dependencies: 2559 2559
-- Name: trackerseverity_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY trackerseverity
    ADD CONSTRAINT trackerseverity_pkey PRIMARY KEY (keytrackerseverity);


--
-- TOC entry 3997 (class 2606 OID 24493)
-- Dependencies: 2561 2561
-- Name: trackerstatus_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY trackerstatus
    ADD CONSTRAINT trackerstatus_pkey PRIMARY KEY (keytrackerstatus);


--
-- TOC entry 3999 (class 2606 OID 24495)
-- Dependencies: 2563 2563
-- Name: userelement_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY userelement
    ADD CONSTRAINT userelement_pkey PRIMARY KEY (keyuserelement);


--
-- TOC entry 4001 (class 2606 OID 24497)
-- Dependencies: 2565 2565
-- Name: usermapping_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY usermapping
    ADD CONSTRAINT usermapping_pkey PRIMARY KEY (keyusermapping);


--
-- TOC entry 4003 (class 2606 OID 24499)
-- Dependencies: 2567 2567
-- Name: userrole_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY userrole
    ADD CONSTRAINT userrole_pkey PRIMARY KEY (keyuserrole);


--
-- TOC entry 4005 (class 2606 OID 24501)
-- Dependencies: 2569 2569
-- Name: usrgrp_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY usrgrp
    ADD CONSTRAINT usrgrp_pkey PRIMARY KEY (keyusrgrp);


--
-- TOC entry 4007 (class 2606 OID 24503)
-- Dependencies: 2570 2570
-- Name: version_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY version
    ADD CONSTRAINT version_pkey PRIMARY KEY (keyversion);


--
-- TOC entry 3791 (class 2606 OID 24505)
-- Dependencies: 2371 2371 2371
-- Name: x_hostservice_fkeyhost_fkeyservice; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hostservice
    ADD CONSTRAINT x_hostservice_fkeyhost_fkeyservice UNIQUE (fkeyhost, fkeyservice);


--
-- TOC entry 3820 (class 1259 OID 24506)
-- Dependencies: 2392
-- Name: fki_fkey_dep; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_fkey_dep ON jobdep USING btree (fkeydep);


--
-- TOC entry 3727 (class 1259 OID 24507)
-- Dependencies: 2319
-- Name: fki_fkey_elementuser_element; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_fkey_elementuser_element ON elementuser USING btree (fkeyelement);


--
-- TOC entry 3728 (class 1259 OID 24508)
-- Dependencies: 2319
-- Name: fki_fkey_elementuser_user; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_fkey_elementuser_user ON elementuser USING btree (fkeyuser);


--
-- TOC entry 3772 (class 1259 OID 24509)
-- Dependencies: 2357
-- Name: fki_fkey_hgi_hg; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_fkey_hgi_hg ON hostgroupitem USING btree (fkeyhostgroup);


--
-- TOC entry 3773 (class 1259 OID 24510)
-- Dependencies: 2357
-- Name: fki_fkey_hgi_host; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_fkey_hgi_host ON hostgroupitem USING btree (fkeyhost);


--
-- TOC entry 3816 (class 1259 OID 24511)
-- Dependencies: 2390
-- Name: fki_fkey_host; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_fkey_host ON jobcommandhistory USING btree (fkeyhost);


--
-- TOC entry 3821 (class 1259 OID 24512)
-- Dependencies: 2392
-- Name: fki_fkey_job; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_fkey_job ON jobdep USING btree (fkeyjob);


--
-- TOC entry 3857 (class 1259 OID 24513)
-- Dependencies: 2431
-- Name: fki_joboutput_fkey_job; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_joboutput_fkey_job ON joboutput USING btree (fkeyjob);


--
-- TOC entry 3657 (class 1259 OID 24514)
-- Dependencies: 2253
-- Name: fki_jobtask_fkey_host; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_jobtask_fkey_host ON jobtask USING btree (fkeyhost);


--
-- TOC entry 3658 (class 1259 OID 24515)
-- Dependencies: 2253
-- Name: fki_jobtask_fkey_job; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_jobtask_fkey_job ON jobtask USING btree (fkeyjob);


--
-- TOC entry 3667 (class 1259 OID 24516)
-- Dependencies: 2260
-- Name: x_annotation_sequence; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_annotation_sequence ON annotation USING btree (sequence);


--
-- TOC entry 3704 (class 1259 OID 24517)
-- Dependencies: 2296
-- Name: x_config_config; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_config_config ON config USING btree (config);


--
-- TOC entry 3739 (class 1259 OID 24518)
-- Dependencies: 2327
-- Name: x_filetracker_fkeyelement; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_filetracker_fkeyelement ON filetracker USING btree (fkeyelement);


--
-- TOC entry 3740 (class 1259 OID 24519)
-- Dependencies: 2327
-- Name: x_filetracker_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_filetracker_name ON filetracker USING btree (name);


--
-- TOC entry 3741 (class 1259 OID 24520)
-- Dependencies: 2327
-- Name: x_filetracker_path; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_filetracker_path ON filetracker USING btree (path);


--
-- TOC entry 3744 (class 1259 OID 24521)
-- Dependencies: 2329
-- Name: x_filetrackerdep_fkeyinput; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_filetrackerdep_fkeyinput ON filetrackerdep USING btree (fkeyinput);


--
-- TOC entry 3745 (class 1259 OID 24522)
-- Dependencies: 2329
-- Name: x_filetrackerdep_fkeyoutput; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_filetrackerdep_fkeyoutput ON filetrackerdep USING btree (fkeyoutput);


--
-- TOC entry 3643 (class 1259 OID 24523)
-- Dependencies: 2234
-- Name: x_hosthistory_datetime; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_hosthistory_datetime ON hosthistory USING btree (datetime);


--
-- TOC entry 3644 (class 1259 OID 24524)
-- Dependencies: 2234 2234
-- Name: x_hosthistory_datetimeplusduration; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_hosthistory_datetimeplusduration ON hosthistory USING btree (((datetime + duration)));


--
-- TOC entry 3645 (class 1259 OID 24525)
-- Dependencies: 2234
-- Name: x_hosthistory_fkeyhost; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_hosthistory_fkeyhost ON hosthistory USING btree (fkeyhost);


--
-- TOC entry 3646 (class 1259 OID 24526)
-- Dependencies: 2234
-- Name: x_hosthistory_fkeyjob; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_hosthistory_fkeyjob ON hosthistory USING btree (fkeyjob);


--
-- TOC entry 3782 (class 1259 OID 24527)
-- Dependencies: 2363
-- Name: x_hostmapping_fkeymapping; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_hostmapping_fkeymapping ON hostmapping USING btree (fkeymapping);


--
-- TOC entry 3789 (class 1259 OID 24528)
-- Dependencies: 2371
-- Name: x_hostservice_fkeyhost; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_hostservice_fkeyhost ON hostservice USING btree (fkeyhost);


--
-- TOC entry 3792 (class 1259 OID 24529)
-- Dependencies: 2371
-- Name: x_hostservice_fkeyservice; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_hostservice_fkeyservice ON hostservice USING btree (fkeyservice);


--
-- TOC entry 3797 (class 1259 OID 24530)
-- Dependencies: 2375
-- Name: x_hoststatus_host; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_hoststatus_host ON hoststatus USING btree (fkeyhost);


--
-- TOC entry 3798 (class 1259 OID 24531)
-- Dependencies: 2375
-- Name: x_hoststatus_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_hoststatus_status ON hoststatus USING btree (slavestatus);


--
-- TOC entry 3819 (class 1259 OID 24532)
-- Dependencies: 2390
-- Name: x_jch_job; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_jch_job ON jobcommandhistory USING btree (fkeyjob);


--
-- TOC entry 3649 (class 1259 OID 24533)
-- Dependencies: 2236 2236
-- Name: x_job_fkeyusr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_job_fkeyusr ON job USING btree (fkeyusr) WHERE ((((status = 'new'::text) OR (status = 'ready'::text)) OR (status = 'started'::text)) OR (status = 'done'::text));


--
-- TOC entry 3650 (class 1259 OID 24534)
-- Dependencies: 2236 2236
-- Name: x_job_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_job_status ON job USING btree (status) WHERE ((((status = 'new'::text) OR (status = 'ready'::text)) OR (status = 'started'::text)) OR (status = 'done'::text));


--
-- TOC entry 3807 (class 1259 OID 24536)
-- Dependencies: 2380
-- Name: x_jobassignment_fkeyjob; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_jobassignment_fkeyjob ON jobassignment USING btree (fkeyjob);


--
-- TOC entry 3826 (class 1259 OID 24537)
-- Dependencies: 2394
-- Name: x_joberror_cleared; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_joberror_cleared ON joberror USING btree (cleared);


--
-- TOC entry 3827 (class 1259 OID 24538)
-- Dependencies: 2394
-- Name: x_joberror_fkeyjob; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_joberror_fkeyjob ON joberror USING btree (fkeyjob);


--
-- TOC entry 3840 (class 1259 OID 24539)
-- Dependencies: 2410 2410
-- Name: x_jobmax7_fkeyusr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_jobmax7_fkeyusr ON jobmax USING btree (fkeyusr) WHERE ((((status = 'new'::text) OR (status = 'ready'::text)) OR (status = 'started'::text)) OR (status = 'done'::text));


--
-- TOC entry 3841 (class 1259 OID 24540)
-- Dependencies: 2410 2410
-- Name: x_jobmax7_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_jobmax7_status ON jobmax USING btree (status) WHERE ((((status = 'new'::text) OR (status = 'ready'::text)) OR (status = 'started'::text)) OR (status = 'done'::text));


--
-- TOC entry 3846 (class 1259 OID 24541)
-- Dependencies: 2416
-- Name: x_jobmax8_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_jobmax8_status ON jobmax8 USING btree (status);


--
-- TOC entry 3868 (class 1259 OID 24542)
-- Dependencies: 2439
-- Name: x_jobservice_job; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_jobservice_job ON jobservice USING btree (fkeyjob);


--
-- TOC entry 3875 (class 1259 OID 24543)
-- Dependencies: 2445
-- Name: x_jobstatus_job; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_jobstatus_job ON jobstatus USING btree (fkeyjob);


--
-- TOC entry 3932 (class 1259 OID 24544)
-- Dependencies: 2504
-- Name: x_rangefiletracker_fkeyelement; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_rangefiletracker_fkeyelement ON rangefiletracker USING btree (fkeyelement);


--
-- TOC entry 3933 (class 1259 OID 24545)
-- Dependencies: 2504
-- Name: x_rangefiletracker_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_rangefiletracker_name ON rangefiletracker USING btree (name);


--
-- TOC entry 3934 (class 1259 OID 24546)
-- Dependencies: 2504
-- Name: x_rangefiletracker_path; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_rangefiletracker_path ON rangefiletracker USING btree (path);


--
-- TOC entry 3939 (class 1259 OID 24547)
-- Dependencies: 2508
-- Name: x_schedule_fkeyelement; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_schedule_fkeyelement ON schedule USING btree (fkeyelement);


--
-- TOC entry 3940 (class 1259 OID 24549)
-- Dependencies: 2508
-- Name: x_schedule_fkeyuser; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_schedule_fkeyuser ON schedule USING btree (fkeyuser);


--
-- TOC entry 3961 (class 1259 OID 24550)
-- Dependencies: 2527
-- Name: x_syslog_ack; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_syslog_ack ON syslog USING btree (ack);


--
-- TOC entry 3982 (class 1259 OID 24551)
-- Dependencies: 2547
-- Name: x_timesheet_fkeyemployee; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_timesheet_fkeyemployee ON timesheet USING btree (fkeyemployee);


--
-- TOC entry 3983 (class 1259 OID 24552)
-- Dependencies: 2547
-- Name: x_timesheet_fkeyproject; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_timesheet_fkeyproject ON timesheet USING btree (fkeyproject);


--
-- TOC entry 4008 (class 1259 OID 24553)
-- Dependencies: 2572
-- Name: x_versionfiletracker_fkeyelement; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_versionfiletracker_fkeyelement ON versionfiletracker USING btree (fkeyelement);


--
-- TOC entry 4009 (class 1259 OID 24554)
-- Dependencies: 2572
-- Name: x_versionfiletracker_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_versionfiletracker_name ON versionfiletracker USING btree (name);


--
-- TOC entry 4010 (class 1259 OID 24555)
-- Dependencies: 2572
-- Name: x_versionfiletracker_path; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_versionfiletracker_path ON versionfiletracker USING btree (path);


--
-- TOC entry 4033 (class 2620 OID 24556)
-- Dependencies: 2375 40
-- Name: hoststatus_update_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER hoststatus_update_trigger
    BEFORE UPDATE ON hoststatus
    FOR EACH ROW
    EXECUTE PROCEDURE hoststatus_update();


--
-- TOC entry 4034 (class 2620 OID 24557)
-- Dependencies: 2376 47
-- Name: job3delight_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER job3delight_insert
    AFTER INSERT ON job3delight
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- TOC entry 4035 (class 2620 OID 24558)
-- Dependencies: 2376 48
-- Name: job3delight_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER job3delight_update
    BEFORE UPDATE ON job3delight
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- TOC entry 4051 (class 2620 OID 24559)
-- Dependencies: 45 2394
-- Name: job_error_insert_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER job_error_insert_trigger
    AFTER INSERT ON joberror
    FOR EACH ROW
    EXECUTE PROCEDURE job_error_insert();


--
-- TOC entry 4052 (class 2620 OID 24560)
-- Dependencies: 44 2394
-- Name: job_error_update_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER job_error_update_trigger
    AFTER UPDATE ON joberror
    FOR EACH ROW
    EXECUTE PROCEDURE job_error_increment();


--
-- TOC entry 4028 (class 2620 OID 24561)
-- Dependencies: 47 2236
-- Name: job_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER job_insert
    AFTER INSERT ON job
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- TOC entry 4029 (class 2620 OID 24562)
-- Dependencies: 2236 48
-- Name: job_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER job_update
    BEFORE UPDATE ON job
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- TOC entry 4038 (class 2620 OID 24563)
-- Dependencies: 47 2378
-- Name: jobaftereffects7_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobaftereffects7_insert
    AFTER INSERT ON jobaftereffects7
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- TOC entry 4039 (class 2620 OID 24564)
-- Dependencies: 2378 48
-- Name: jobaftereffects7_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobaftereffects7_update
    BEFORE UPDATE ON jobaftereffects7
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- TOC entry 4040 (class 2620 OID 24565)
-- Dependencies: 2379 47
-- Name: jobaftereffects8_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobaftereffects8_insert
    AFTER INSERT ON jobaftereffects8
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- TOC entry 4041 (class 2620 OID 24566)
-- Dependencies: 48 2379
-- Name: jobaftereffects8_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobaftereffects8_update
    BEFORE UPDATE ON jobaftereffects8
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- TOC entry 4036 (class 2620 OID 24567)
-- Dependencies: 2377 47
-- Name: jobaftereffects_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobaftereffects_insert
    AFTER INSERT ON jobaftereffects
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- TOC entry 4037 (class 2620 OID 24568)
-- Dependencies: 2377 48
-- Name: jobaftereffects_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobaftereffects_update
    BEFORE UPDATE ON jobaftereffects
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- TOC entry 4042 (class 2620 OID 24569)
-- Dependencies: 2380 49
-- Name: jobassignment_delete_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobassignment_delete_trigger
    BEFORE DELETE ON jobassignment
    FOR EACH ROW
    EXECUTE PROCEDURE jobassignment_delete();


--
-- TOC entry 4043 (class 2620 OID 24570)
-- Dependencies: 50 2380
-- Name: jobassignment_insert_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobassignment_insert_trigger
    BEFORE INSERT ON jobassignment
    FOR EACH ROW
    EXECUTE PROCEDURE jobassignment_insert();


--
-- TOC entry 4044 (class 2620 OID 24571)
-- Dependencies: 51 2380
-- Name: jobassignment_update_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobassignment_update_trigger
    BEFORE UPDATE ON jobassignment
    FOR EACH ROW
    EXECUTE PROCEDURE jobassignment_update();


--
-- TOC entry 4045 (class 2620 OID 24572)
-- Dependencies: 47 2384
-- Name: jobautodeskburn_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobautodeskburn_insert
    AFTER INSERT ON jobautodeskburn
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- TOC entry 4046 (class 2620 OID 24573)
-- Dependencies: 2384 48
-- Name: jobautodeskburn_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobautodeskburn_update
    BEFORE UPDATE ON jobautodeskburn
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- TOC entry 4047 (class 2620 OID 24574)
-- Dependencies: 2385 47
-- Name: jobbatch_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobbatch_insert
    AFTER INSERT ON jobbatch
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- TOC entry 4048 (class 2620 OID 24575)
-- Dependencies: 48 2385
-- Name: jobbatch_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobbatch_update
    BEFORE UPDATE ON jobbatch
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- TOC entry 4049 (class 2620 OID 24576)
-- Dependencies: 47 2388
-- Name: jobcinema4d_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobcinema4d_insert
    AFTER INSERT ON jobcinema4d
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- TOC entry 4050 (class 2620 OID 24577)
-- Dependencies: 48 2388
-- Name: jobcinema4d_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobcinema4d_update
    BEFORE UPDATE ON jobcinema4d
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- TOC entry 4053 (class 2620 OID 24578)
-- Dependencies: 52 2394
-- Name: joberror_inc; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER joberror_inc
    AFTER INSERT OR UPDATE ON joberror
    FOR EACH ROW
    EXECUTE PROCEDURE joberror_inc();


--
-- TOC entry 4054 (class 2620 OID 24579)
-- Dependencies: 47 2399
-- Name: jobfusion_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobfusion_insert
    AFTER INSERT ON jobfusion
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- TOC entry 4055 (class 2620 OID 24580)
-- Dependencies: 2399 48
-- Name: jobfusion_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobfusion_update
    BEFORE UPDATE ON jobfusion
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- TOC entry 4056 (class 2620 OID 24581)
-- Dependencies: 2400 47
-- Name: jobfusionvideomaker_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobfusionvideomaker_insert
    AFTER INSERT ON jobfusionvideomaker
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- TOC entry 4057 (class 2620 OID 24582)
-- Dependencies: 48 2400
-- Name: jobfusionvideomaker_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobfusionvideomaker_update
    BEFORE UPDATE ON jobfusionvideomaker
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- TOC entry 4058 (class 2620 OID 24583)
-- Dependencies: 47 2405
-- Name: jobhoudinisim10_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobhoudinisim10_insert
    AFTER INSERT ON jobhoudinisim10
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- TOC entry 4059 (class 2620 OID 24584)
-- Dependencies: 2405 48
-- Name: jobhoudinisim10_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobhoudinisim10_update
    BEFORE UPDATE ON jobhoudinisim10
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- TOC entry 4060 (class 2620 OID 24585)
-- Dependencies: 47 2406
-- Name: jobmantra100_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmantra100_insert
    AFTER INSERT ON jobmantra100
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- TOC entry 4061 (class 2620 OID 24586)
-- Dependencies: 48 2406
-- Name: jobmantra100_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmantra100_update
    BEFORE UPDATE ON jobmantra100
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- TOC entry 4062 (class 2620 OID 24587)
-- Dependencies: 2411 47
-- Name: jobmax10_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmax10_insert
    AFTER INSERT ON jobmax10
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- TOC entry 4063 (class 2620 OID 24588)
-- Dependencies: 48 2411
-- Name: jobmax10_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmax10_update
    BEFORE UPDATE ON jobmax10
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- TOC entry 4076 (class 2620 OID 24589)
-- Dependencies: 2421 47
-- Name: jobmax2009_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmax2009_insert
    AFTER INSERT ON jobmaya2009
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- TOC entry 4064 (class 2620 OID 24590)
-- Dependencies: 2412 47
-- Name: jobmax2009_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmax2009_insert
    AFTER INSERT ON jobmax2009
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- TOC entry 4065 (class 2620 OID 24591)
-- Dependencies: 48 2412
-- Name: jobmax2009_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmax2009_update
    BEFORE UPDATE ON jobmax2009
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- TOC entry 4066 (class 2620 OID 24592)
-- Dependencies: 47 2415
-- Name: jobmax7_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmax7_insert
    AFTER INSERT ON jobmax7
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- TOC entry 4067 (class 2620 OID 24593)
-- Dependencies: 2415 48
-- Name: jobmax7_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmax7_update
    BEFORE UPDATE ON jobmax7
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- TOC entry 4068 (class 2620 OID 24594)
-- Dependencies: 47 2416
-- Name: jobmax8_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmax8_insert
    AFTER INSERT ON jobmax8
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- TOC entry 4069 (class 2620 OID 24595)
-- Dependencies: 2416 48
-- Name: jobmax8_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmax8_update
    BEFORE UPDATE ON jobmax8
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- TOC entry 4070 (class 2620 OID 24596)
-- Dependencies: 47 2417
-- Name: jobmax9_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmax9_insert
    AFTER INSERT ON jobmax9
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- TOC entry 4071 (class 2620 OID 24597)
-- Dependencies: 48 2417
-- Name: jobmax9_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmax9_update
    BEFORE UPDATE ON jobmax9
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- TOC entry 4072 (class 2620 OID 24598)
-- Dependencies: 47 2418
-- Name: jobmaxscript_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmaxscript_insert
    AFTER INSERT ON jobmaxscript
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- TOC entry 4073 (class 2620 OID 24599)
-- Dependencies: 2418 48
-- Name: jobmaxscript_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmaxscript_update
    BEFORE UPDATE ON jobmaxscript
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- TOC entry 4074 (class 2620 OID 24600)
-- Dependencies: 47 2420
-- Name: jobmaya2008_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmaya2008_insert
    AFTER INSERT ON jobmaya2008
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- TOC entry 4075 (class 2620 OID 24601)
-- Dependencies: 2420 48
-- Name: jobmaya2008_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmaya2008_update
    BEFORE UPDATE ON jobmaya2008
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- TOC entry 4077 (class 2620 OID 24602)
-- Dependencies: 47 2421
-- Name: jobmaya2009_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmaya2009_insert
    AFTER INSERT ON jobmaya2009
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- TOC entry 4078 (class 2620 OID 24603)
-- Dependencies: 48 2421
-- Name: jobmaya2009_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmaya2009_update
    BEFORE UPDATE ON jobmaya2009
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- TOC entry 4079 (class 2620 OID 24604)
-- Dependencies: 2422 47
-- Name: jobmaya7_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmaya7_insert
    AFTER INSERT ON jobmaya7
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- TOC entry 4080 (class 2620 OID 24605)
-- Dependencies: 2422 48
-- Name: jobmaya7_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmaya7_update
    BEFORE UPDATE ON jobmaya7
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- TOC entry 4081 (class 2620 OID 24606)
-- Dependencies: 47 2424
-- Name: jobmaya85_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmaya85_insert
    AFTER INSERT ON jobmaya85
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- TOC entry 4082 (class 2620 OID 24607)
-- Dependencies: 48 2424
-- Name: jobmaya85_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmaya85_update
    BEFORE UPDATE ON jobmaya85
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- TOC entry 4083 (class 2620 OID 24608)
-- Dependencies: 2427 47
-- Name: jobmentalray85_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmentalray85_insert
    AFTER INSERT ON jobmentalray85
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- TOC entry 4084 (class 2620 OID 24609)
-- Dependencies: 48 2427
-- Name: jobmentalray85_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmentalray85_update
    BEFORE UPDATE ON jobmentalray85
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- TOC entry 4085 (class 2620 OID 24610)
-- Dependencies: 47 2428
-- Name: jobnuke51_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobnuke51_insert
    AFTER INSERT ON jobnuke51
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- TOC entry 4086 (class 2620 OID 24611)
-- Dependencies: 48 2428
-- Name: jobnuke51_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobnuke51_update
    BEFORE UPDATE ON jobnuke51
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- TOC entry 4087 (class 2620 OID 24612)
-- Dependencies: 47 2429
-- Name: jobnuke52_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobnuke52_insert
    AFTER INSERT ON jobnuke52
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- TOC entry 4088 (class 2620 OID 24613)
-- Dependencies: 48 2429
-- Name: jobnuke52_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobnuke52_update
    BEFORE UPDATE ON jobnuke52
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- TOC entry 4089 (class 2620 OID 24614)
-- Dependencies: 2432 47
-- Name: jobrealflow_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobrealflow_insert
    AFTER INSERT ON jobrealflow
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- TOC entry 4090 (class 2620 OID 24615)
-- Dependencies: 48 2432
-- Name: jobrealflow_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobrealflow_update
    BEFORE UPDATE ON jobrealflow
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- TOC entry 4091 (class 2620 OID 24616)
-- Dependencies: 47 2440
-- Name: jobshake_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobshake_insert
    AFTER INSERT ON jobshake
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- TOC entry 4092 (class 2620 OID 24617)
-- Dependencies: 48 2440
-- Name: jobshake_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobshake_update
    BEFORE UPDATE ON jobshake
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- TOC entry 4093 (class 2620 OID 24618)
-- Dependencies: 47 2446
-- Name: jobsync_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobsync_insert
    AFTER INSERT ON jobsync
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- TOC entry 4094 (class 2620 OID 24619)
-- Dependencies: 2446 48
-- Name: jobsync_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobsync_update
    BEFORE UPDATE ON jobsync
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- TOC entry 4095 (class 2620 OID 24620)
-- Dependencies: 53 2448
-- Name: jobtaskassignment_update_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobtaskassignment_update_trigger
    BEFORE UPDATE ON jobtaskassignment
    FOR EACH ROW
    EXECUTE PROCEDURE jobtaskassignment_update();


--
-- TOC entry 4096 (class 2620 OID 24621)
-- Dependencies: 47 2452
-- Name: jobxsi_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobxsi_insert
    AFTER INSERT ON jobxsi
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- TOC entry 4097 (class 2620 OID 24622)
-- Dependencies: 48 2452
-- Name: jobxsi_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobxsi_update
    BEFORE UPDATE ON jobxsi
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- TOC entry 4098 (class 2620 OID 24623)
-- Dependencies: 47 2453
-- Name: jobxsiscript_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobxsiscript_insert
    AFTER INSERT ON jobxsiscript
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- TOC entry 4099 (class 2620 OID 24624)
-- Dependencies: 48 2453
-- Name: jobxsiscript_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobxsiscript_update
    BEFORE UPDATE ON jobxsiscript
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- TOC entry 4030 (class 2620 OID 24625)
-- Dependencies: 2248 59
-- Name: sync_host_to_hoststatus_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER sync_host_to_hoststatus_trigger
    AFTER INSERT OR DELETE ON host
    FOR EACH STATEMENT
    EXECUTE PROCEDURE sync_host_to_hoststatus_trigger();


--
-- TOC entry 4031 (class 2620 OID 24626)
-- Dependencies: 2361 61
-- Name: update_hostload; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_hostload
    BEFORE UPDATE ON hostload
    FOR EACH ROW
    EXECUTE PROCEDURE update_hostload();


--
-- TOC entry 4032 (class 2620 OID 24627)
-- Dependencies: 2371 62
-- Name: update_hostservice; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_hostservice
    BEFORE UPDATE ON hostservice
    FOR EACH ROW
    EXECUTE PROCEDURE update_hostservice();


--
-- TOC entry 4013 (class 2606 OID 24628)
-- Dependencies: 2323 2248 3651
-- Name: fkey_eventalert_host; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY eventalert
    ADD CONSTRAINT fkey_eventalert_host FOREIGN KEY ("fkeyHost") REFERENCES host(keyhost);


--
-- TOC entry 4014 (class 2606 OID 24633)
-- Dependencies: 2335 2341 3750
-- Name: fkey_graphrel_graph; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY graphrelationship
    ADD CONSTRAINT fkey_graphrel_graph FOREIGN KEY (fkeygraph) REFERENCES graph(keygraph) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4015 (class 2606 OID 24638)
-- Dependencies: 2341 2337 3752
-- Name: fkey_graphrel_graphds; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY graphrelationship
    ADD CONSTRAINT fkey_graphrel_graphds FOREIGN KEY (fkeygraphds) REFERENCES graphds(keygraphds) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4016 (class 2606 OID 24643)
-- Dependencies: 3711 2306 2357
-- Name: fkey_hgi_hg; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hostgroupitem
    ADD CONSTRAINT fkey_hgi_hg FOREIGN KEY (fkeyhostgroup) REFERENCES hostgroup(keyhostgroup) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4017 (class 2606 OID 24648)
-- Dependencies: 2248 2357 3651
-- Name: fkey_hgi_host; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hostgroupitem
    ADD CONSTRAINT fkey_hgi_host FOREIGN KEY (fkeyhost) REFERENCES host(keyhost) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4024 (class 2606 OID 24653)
-- Dependencies: 2248 2390 3651
-- Name: fkey_host; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY jobcommandhistory
    ADD CONSTRAINT fkey_host FOREIGN KEY (fkeyhost) REFERENCES host(keyhost) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4011 (class 2606 OID 24658)
-- Dependencies: 2248 2250 3651
-- Name: fkey_hostinterface_host; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hostinterface
    ADD CONSTRAINT fkey_hostinterface_host FOREIGN KEY (fkeyhost) REFERENCES host(keyhost) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4018 (class 2606 OID 24663)
-- Dependencies: 2365 3651 2248
-- Name: fkey_hostport_host; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hostport
    ADD CONSTRAINT fkey_hostport_host FOREIGN KEY (fkeyhost) REFERENCES host(keyhost) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4019 (class 2606 OID 24668)
-- Dependencies: 3651 2371 2248
-- Name: fkey_hostservice_host; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hostservice
    ADD CONSTRAINT fkey_hostservice_host FOREIGN KEY (fkeyhost) REFERENCES host(keyhost) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4020 (class 2606 OID 24673)
-- Dependencies: 3947 2371 2516
-- Name: fkey_hostservice_service; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hostservice
    ADD CONSTRAINT fkey_hostservice_service FOREIGN KEY (fkeyservice) REFERENCES service(keyservice) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4021 (class 2606 OID 24678)
-- Dependencies: 2373 3651 2248
-- Name: fkey_hostsoftware_host; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hostsoftware
    ADD CONSTRAINT fkey_hostsoftware_host FOREIGN KEY (fkeyhost) REFERENCES host(keyhost) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4022 (class 2606 OID 24683)
-- Dependencies: 3953 2373 2521
-- Name: fkey_hostsoftware_software; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hostsoftware
    ADD CONSTRAINT fkey_hostsoftware_software FOREIGN KEY (fkeysoftware) REFERENCES software(keysoftware) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4023 (class 2606 OID 24688)
-- Dependencies: 3651 2375 2248
-- Name: fkey_hoststatus_host; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hoststatus
    ADD CONSTRAINT fkey_hoststatus_host FOREIGN KEY (fkeyhost) REFERENCES host(keyhost) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4025 (class 2606 OID 24693)
-- Dependencies: 3651 2248 2527
-- Name: fkey_syslog_host; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY syslog
    ADD CONSTRAINT fkey_syslog_host FOREIGN KEY (fkeyhost) REFERENCES host(keyhost) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4026 (class 2606 OID 24698)
-- Dependencies: 3962 2527 2530
-- Name: fkey_syslog_realm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY syslog
    ADD CONSTRAINT fkey_syslog_realm FOREIGN KEY (fkeysyslogrealm) REFERENCES syslogrealm(keysyslogrealm) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4027 (class 2606 OID 24703)
-- Dependencies: 2532 2527 3964
-- Name: fkey_syslog_severity; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY syslog
    ADD CONSTRAINT fkey_syslog_severity FOREIGN KEY (fkeysyslogseverity) REFERENCES syslogseverity(keysyslogseverity) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4012 (class 2606 OID 24708)
-- Dependencies: 2253 2248 3651
-- Name: jobtask_fkey_host; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY jobtask
    ADD CONSTRAINT jobtask_fkey_host FOREIGN KEY (fkeyhost) REFERENCES host(keyhost) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4303 (class 0 OID 0)
-- Dependencies: 3
-- Name: public; Type: ACL; Schema: -; Owner: -
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2010-01-28 13:21:03 EST

--
-- PostgreSQL database dump complete
--

