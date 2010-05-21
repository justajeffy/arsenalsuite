--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: jabberd; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA jabberd;


--
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: -
--

CREATE PROCEDURAL LANGUAGE plpgsql;


SET search_path = public, pg_catalog;

--
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
-- Name: hosthistory_user_slave_summary_return; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE hosthistory_user_slave_summary_return AS (
	usr text,
	host text,
	hours numeric
);


--
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
-- Name: waywardhostret; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE waywardhostret AS (
	keyhost integer,
	reason integer
);


--
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
-- Name: assign_single_host(integer, integer, integer[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION assign_single_host(_keyjob integer, _keyhost integer, _tasks integer[]) RETURNS integer
    AS $$
DECLARE
    _hostStatus hoststatus;
    _readyStatus integer;
    _jobstatus jobstatus;
    _job job;
    _minMem integer;
    _keyjobassignment integer;
    _keyjobtaskassignment integer;
    _keytask integer;
    _assignedTasks integer;
BEGIN

_assignedTasks := 0;
SELECT INTO _hostStatus * FROM hoststatus WHERE fkeyHost = _keyhost;

IF _hostStatus.slaveStatus != 'ready' THEN
    ROLLBACK;
    RAISE NOTICE 'Host is no longer ready for frames(status is ) returning';
    return 0;
END IF;

SELECT INTO _job * FROM job WHERE keyjob = _keyjob;

_minMem := _job.minmemory;
IF _minMem = 0 THEN
    SELECT INTO _jobstatus * FROM jobstatus WHERE fkeyjob = _keyjob;
    _minMem := _jobstatus.averagememory;
END IF;
IF _hostStatus.availablememory*1024 - _minMem <= 0 THEN
    RAISE NOTICE 'Host does not have %, memory required %', _hostStatus.availablememory, _minMem;
    ROLLBACK;
    return 0;
END IF;
UPDATE hoststatus SET availablememory = ((availablememory * 1024) - _minMem)/1024 WHERE fkeyhost = _keyhost;

SELECT INTO _readyStatus keyjobassignmentstatus FROM jobassignmentstatus WHERE status = 'ready';
INSERT INTO jobassignment (fkeyjob, fkeyhost, fkeyjobassignmentstatus)
    VALUES (_keyjob, _keyhost, _readyStatus)
    RETURNING keyjobassignment INTO _keyjobassignment;

FOR i IN 1..array_upper(_tasks,1) LOOP
    _keytask := _tasks[i];
    _assignedTasks := _assignedTasks + 1;
    INSERT INTO jobtaskassignment (fkeyjobtask, fkeyjobassignment, fkeyjobassignmentstatus)
        VALUES (_keytask, _keyjobassignment, _readyStatus)
        RETURNING keyjobtaskassignment INTO _keyjobtaskassignment;
    UPDATE jobtask SET fkeyjobtaskassignment = _keyjobtaskassignment, status = 'assigned', fkeyhost = _keyhost 
        WHERE keyjobtask = _keytask;
END LOOP;

IF _job.maxhosts > 0 THEN
    UPDATE jobstatus SET hostsonjob=hostsonjob+1 WHERE fkeyjob = _keyjob;
END IF;

return _assignedTasks;

END;
$$
    LANGUAGE plpgsql;


--
-- Name: assign_single_host(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION assign_single_host(_keyjob integer, _keyhost integer, _packetsize integer) RETURNS integer
    AS $$
DECLARE
    _hostStatus hoststatus;
    _readyStatus integer;
    _jobstatus jobstatus;
    _job job;
    _minMem integer;
    _keyjobassignment integer;
    _keyjobtaskassignment integer;
    _keytask integer;
    _assignedTasks integer;
    _task jobtask;
    _tasksql text;
BEGIN

_assignedTasks := 0;
SELECT INTO _hostStatus * FROM hoststatus WHERE fkeyHost = _keyhost;

IF _hostStatus.slaveStatus != 'ready' THEN
    ROLLBACK;
    RAISE EXCEPTION 'Host is no longer ready for frames(status is ) returning';
    return 0;
END IF;

SELECT INTO _job * FROM job WHERE keyjob = _keyjob;

_minMem := _job.minmemory;
IF _minMem = 0 THEN
    SELECT INTO _jobstatus * FROM jobstatus WHERE fkeyjob = _keyjob;
    _minMem := _jobstatus.averagememory;
END IF;
IF _hostStatus.availablememory*1024 - _minMem <= 0 THEN
    RAISE EXCEPTION 'Host does not have %, memory required %', _hostStatus.availablememory, _minMem;
    ROLLBACK;
    return 0;
END IF;
UPDATE hoststatus SET availablememory = ((availablememory * 1024) - _minMem)/1024 WHERE fkeyhost = _keyhost;

SELECT INTO _readyStatus keyjobassignmentstatus FROM jobassignmentstatus WHERE status = 'ready';
INSERT INTO jobassignment (fkeyjob, fkeyhost, fkeyjobassignmentstatus)
    VALUES (_keyjob, _keyhost, _readyStatus)
    RETURNING keyjobassignment INTO _keyjobassignment;


IF _job.packetType = 'random' THEN
	_tasksql := 'SELECT keyjobtask FROM jobtask WHERE fkeyjob = ' || _keyjob || ' AND status=''new'' ORDER BY random() ASC LIMIT ' || _packetSize;
ELSIF _job.packetType = 'preassigned' THEN
	_tasksql := 'SELECT keyjobtask FROM jobtask WHERE fkeyjob = ' || _keyjob || ' AND fkeyhost=' || _keyhost || ' AND status=''new''';
ELSIF _job.packetType = 'continuous' THEN
	_tasksql := 'SELECT * FROM get_continuous_tasks(' || _keyjob || ', ' || _packetSize || ')';
ELSE
	_tasksql := 'SELECT keyjobtask FROM jobtask WHERE fkeyjob = ' || _keyjob || ' AND status=''new'' ORDER BY jobtask ASC LIMIT ' || _packetSize;
END IF;

FOR _keytask IN EXECUTE(_tasksql) LOOP  
    _assignedTasks := _assignedTasks + 1;
    INSERT INTO jobtaskassignment (fkeyjobtask, fkeyjobassignment, fkeyjobassignmentstatus)
        VALUES (_keytask, _keyjobassignment, _readyStatus)
        RETURNING keyjobtaskassignment INTO _keyjobtaskassignment;
    UPDATE jobtask SET fkeyjobtaskassignment = _keyjobtaskassignment, status = 'assigned', fkeyhost = _keyhost 
        WHERE keyjobtask = _keytask;
END LOOP;

IF _job.maxhosts > 0 THEN
    UPDATE jobstatus SET hostsonjob=hostsonjob+1 WHERE fkeyjob = _keyjob;
END IF;

return _assignedTasks;

END;
$$
    LANGUAGE plpgsql;


--
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
-- Name: epoch_to_timestamp(double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION epoch_to_timestamp(double precision) RETURNS timestamp without time zone
    AS $_$
SELECT ('epoch'::timestamp + $1 * '1 second'::interval)::timestamp;
$_$
    LANGUAGE sql IMMUTABLE STRICT;


--
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
-- Name: hosthistory_keyhosthistory_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hosthistory_keyhosthistory_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: hosthistory_keyhosthistory_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('hosthistory_keyhosthistory_seq', 41712358, true);


--
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
-- Name: job_insert(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION job_insert() RETURNS trigger
    AS $$
BEGIN
	INSERT INTO jobstatus (fkeyjob) VALUES (NEW.keyjob);
RETURN NEW;
END;
$$
    LANGUAGE plpgsql;


--
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

	IF NEW.status IN ('verify', 'suspended', 'deleted') AND OLD.status != 'submit' THEN
		PERFORM cancel_job_assignments(NEW.keyjob);
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
-- Name: jobassignment_after_update(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION jobassignment_after_update() RETURNS trigger
    AS $$
BEGIN
	PERFORM update_host_assignment_count(NEW.fkeyhost);
	return NEW;
END;
$$
    LANGUAGE plpgsql;


--
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
		PERFORM update_host_assignment_count(OLD.fkeyhost);
	END IF;
	RETURN OLD;
END;
$$
    LANGUAGE plpgsql;


--
-- Name: jobassignment_insert(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION jobassignment_insert() RETURNS trigger
    AS $$
BEGIN
	PERFORM updateJobLicenseCounts( NEW.fkeyjob, 1 );

	RETURN NEW;
END;
$$
    LANGUAGE plpgsql;


--
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

	IF OLD.fkeyjobassignmentstatus != NEW.fkeyjobassignmentstatus THEN
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
	END IF;
	RETURN NEW;
END;
$$
    LANGUAGE plpgsql;


--
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
-- Name: return_slave_tasks_2(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION return_slave_tasks_2(_keyhost integer) RETURNS void
    AS $$
DECLARE
	j job;
BEGIN
	FOR j IN SELECT * from job WHERE keyjob IN (
		SELECT fkeyjob FROM JobTask WHERE fkeyhost=_keyhost AND status IN ('assigned','busy') GROUP BY fkeyjob
		)
	LOOP
		IF j.packettype = 'preassigned' THEN
			UPDATE jobtask SET status = 'new' 
				       WHERE fkeyhost=_keyhost 
					 AND fkeyjob=j.keyjob 
					 AND status IN ('assigned','busy');
		ELSE
			UPDATE jobtask SET status = 'new', 
					   fkeyhost=NULL 
				       WHERE fkeyhost=_keyhost 
				         AND fkeyjob=j.keyjob 
				         AND status IN ('assigned','busy');
		END IF;
	END LOOP;
END;
$$
    LANGUAGE plpgsql;


--
-- Name: return_slave_tasks_3(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION return_slave_tasks_3(_keyhost integer) RETURNS void
    AS $$
DECLARE
	cancelledStatusKey int;
BEGIN
	PERFORM return_slave_tasks_2(_keyhost);
	
	SELECT INTO cancelledStatusKey keyjobassignmentstatus FROM jobassignmentstatus WHERE status='cancelled';
	UPDATE JobAssignment SET fkeyjobassignmentstatus=cancelledStatusKey 
	                     WHERE fkeyhost=_keyhost 
	                       AND fkeyjobassignmentstatus IN (SELECT keyjobassignmentstatus 
								FROM jobassignmentstatus 
								WHERE status IN ('ready','copy','busy'));
	UPDATE JobTaskAssignment SET fkeyjobassignmentstatus=cancelledStatusKey 
				 WHERE fkeyjobassignment IN (SELECT keyjobassignment 
								FROM jobassignment 
								WHERE fkeyhost=_keyhost) 
				   AND fkeyjobassignmentstatus IN (SELECT keyjobassignmentstatus 
								      FROM jobassignmentstatus 
								      WHERE status IN ('ready','copy','busy'));
END;
$$
    LANGUAGE plpgsql;


--
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
-- Name: update_host_assignment_count(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_host_assignment_count(_keyhost integer) RETURNS void
    AS $$ 
BEGIN
UPDATE HostStatus hs
SET activeAssignmentCount = coalesce((
	SELECT sum(slots)  
	FROM job j
	JOIN jobassignment ja ON (ja.fkeyjob = j.keyjob)
	JOIN jobassignmentstatus jas ON (ja.fkeyjobassignmentstatus = keyjobassignmentstatus)
	JOIN hoststatus hs ON hs.fkeyhost = ja.fkeyhost
        WHERE jas.status IN ('ready','copy','busy')
	  AND hs.fkeyhost = _keyhost
	GROUP BY hs.fkeyhost),0),
    lastAssignmentChange=NOW()
WHERE hs.fkeyhost = _keyhost;
END;
$$
    LANGUAGE plpgsql;


--
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
-- Name: update_job_deps(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_job_deps(_keyjob integer) RETURNS void
    AS $$
DECLARE
    childDepRec RECORD;
    jobDepRec RECORD;
    newstatus text;
BEGIN
    FOR jobDepRec IN
        SELECT job.keyjob as childKey
        FROM jobdep
        JOIN job ON jobdep.fkeyjob = job.keyjob
        WHERE jobdep.deptype = 1 AND fkeydep = _keyjob
    LOOP
        newstatus := 'ready';
        FOR childDepRec IN
            SELECT status
            FROM jobdep
            JOIN job ON jobdep.fkeydep = job.keyjob
            WHERE keyjob != _keyjob AND fkeyjob = jobDepRec.childKey
        LOOP
            IF childDepRec.status != 'done' AND childDepRec.status != 'deleted' THEN
                newstatus := 'holding';
            END IF;
        END LOOP;
        UPDATE job SET status = newstatus WHERE keyjob = jobDepRec.childKey;
    END LOOP;
    RETURN;
END;    
$$
    LANGUAGE plpgsql;


--
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
-- Name: update_job_links(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_job_links(_keyjob integer) RETURNS void
    AS $$ 
BEGIN
UPDATE jobtask SET status = 'new' WHERE keyjobtask IN (
        SELECT jt1.keyjobtask
        FROM jobdep 
        JOIN jobtask AS jt1 ON jt1.fkeyjob = jobdep.fkeyjob AND jt1.status = 'holding'
        JOIN jobtask AS jt2 ON jt2.fkeyjob = jobdep.fkeydep AND jt2.status = 'done'
        WHERE jobdep.deptype = 2 AND jobdep.fkeydep = _keyjob AND jt1.jobtask = jt2.jobtask
);  
END;
$$
    LANGUAGE plpgsql;


--
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
        holding integer := 0;
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
                ELSIF( cur.status = 'holding' ) THEN
                        holding := cur.c;
                END IF;
        END LOOP;

        UPDATE JobStatus SET
                taskscount = unassigned + assigned + busy + done + cancelled + suspended + holding,
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
-- Name: job_keyjob_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE job_keyjob_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: job_keyjob_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('job_keyjob_seq', 265494, true);


--
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
    minmemory integer,
    scenename text,
    shotname text,
    slots integer DEFAULT 4 NOT NULL
);


--
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
-- Name: /; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR / (
    PROCEDURE = interval_divide,
    LEFTARG = interval,
    RIGHTARG = interval
);


SET search_path = jabberd, pg_catalog;

--
-- Name: active; Type: TABLE; Schema: jabberd; Owner: -; Tablespace: 
--

CREATE TABLE active (
    "collection-owner" text,
    "object-sequence" integer,
    "time" integer
);


--
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
-- Name: logout; Type: TABLE; Schema: jabberd; Owner: -; Tablespace: 
--

CREATE TABLE logout (
    "collection-owner" text,
    "object-sequence" integer,
    "time" integer
);


--
-- Name: object-sequence; Type: SEQUENCE; Schema: jabberd; Owner: -
--

CREATE SEQUENCE "object-sequence"
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: object-sequence; Type: SEQUENCE SET; Schema: jabberd; Owner: -
--

SELECT pg_catalog.setval('"object-sequence"', 1, false);


--
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
-- Name: private; Type: TABLE; Schema: jabberd; Owner: -; Tablespace: 
--

CREATE TABLE private (
    "collection-owner" text,
    "object-sequence" integer,
    ns text,
    xml text
);


--
-- Name: queue; Type: TABLE; Schema: jabberd; Owner: -; Tablespace: 
--

CREATE TABLE queue (
    "collection-owner" text,
    "object-sequence" integer,
    xml text
);


--
-- Name: roster-groups; Type: TABLE; Schema: jabberd; Owner: -; Tablespace: 
--

CREATE TABLE "roster-groups" (
    "collection-owner" text,
    "object-sequence" integer,
    jid text,
    "group" text
);


--
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
-- Name: host_keyhost_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE host_keyhost_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: host_keyhost_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('host_keyhost_seq', 876, true);


--
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
    maxassignments integer DEFAULT 2 NOT NULL,
    fkeyuser integer
);


--
-- Name: hostinterface_keyhostinterface_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hostinterface_keyhostinterface_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: hostinterface_keyhostinterface_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('hostinterface_keyhostinterface_seq', 590, true);


--
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
-- Name: HostInterfacesVerbose; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW "HostInterfacesVerbose" AS
    SELECT host.keyhost, host.backupbytes, host.cpus, host.description, host.diskusage, host.fkeyjob, host.host, host.manufacturer, host.model, host.os, host.rendertime, host.slavepluginlist, host.sn, host.version, host.renderrate, host.dutycycle, host.memory, host.mhtz, host.online, host.uid, host.slavepacketweight, host.framecount, host.viruscount, host.virustimestamp, host.errortempo, host.fkeyhost_backup, host.oldkey, host.abversion, host.laststatuschange, host.loadavg, host.allowmapping, host.allowsleep, host.fkeyjobtask, host.wakeonlan, host.architecture, host.loc_x, host.loc_y, host.loc_z, host.ostext, host.bootaction, host.fkeydiskimage, host.syncname, host.fkeylocation, host.cpuname, host.osversion, host.slavepulse, hostinterface.keyhostinterface, hostinterface.fkeyhost, hostinterface.mac, hostinterface.ip, hostinterface.fkeyhostinterfacetype, hostinterface.switchport, hostinterface.fkeyswitch, hostinterface.inst FROM (host JOIN hostinterface ON ((host.keyhost = hostinterface.fkeyhost)));


--
-- Name: jobtask_keyjobtask_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobtask_keyjobtask_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: jobtask_keyjobtask_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('jobtask_keyjobtask_seq', 22922963, true);


--
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
-- Name: jobtype_keyjobtype_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobtype_keyjobtype_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: jobtype_keyjobtype_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('jobtype_keyjobtype_seq', 35, true);


--
-- Name: jobtype; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobtype (
    keyjobtype integer DEFAULT nextval('jobtype_keyjobtype_seq'::regclass) NOT NULL,
    jobtype text,
    fkeyservice integer,
    icon bytea
);


--
-- Name: StatsByType; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW "StatsByType" AS
    SELECT "substring"((date_trunc('day'::text, ('1970-01-01 10:00:00+10'::timestamp with time zone + ((jobtask.ended)::double precision * '00:00:01'::interval))))::text, 0, 11) AS day, jobtype.jobtype, count(*) AS frames FROM ((jobtask LEFT JOIN job ON ((jobtask.fkeyjob = job.keyjob))) LEFT JOIN jobtype ON ((jobtype.keyjobtype = job.fkeyjobtype))) WHERE (jobtask.status = 'done'::text) GROUP BY "substring"((date_trunc('day'::text, ('1970-01-01 10:00:00+10'::timestamp with time zone + ((jobtask.ended)::double precision * '00:00:01'::interval))))::text, 0, 11), jobtype.jobtype ORDER BY "substring"((date_trunc('day'::text, ('1970-01-01 10:00:00+10'::timestamp with time zone + ((jobtask.ended)::double precision * '00:00:01'::interval))))::text, 0, 11);


--
-- Name: abdownloadstat_keyabdownloadstat_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE abdownloadstat_keyabdownloadstat_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: abdownloadstat_keyabdownloadstat_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('abdownloadstat_keyabdownloadstat_seq', 1, false);


--
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
-- Name: annotation_keyannotation_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE annotation_keyannotation_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: annotation_keyannotation_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('annotation_keyannotation_seq', 1, false);


--
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
-- Name: element_keyelement_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE element_keyelement_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: element_keyelement_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('element_keyelement_seq', 1851, true);


--
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
-- Name: assetdep; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE assetdep (
    keyassetdep integer NOT NULL,
    path text,
    fkeypackage integer,
    fkeyasset integer
);


--
-- Name: assetdep_keyassetdep_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assetdep_keyassetdep_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: assetdep_keyassetdep_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE assetdep_keyassetdep_seq OWNED BY assetdep.keyassetdep;


--
-- Name: assetdep_keyassetdep_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('assetdep_keyassetdep_seq', 1, false);


--
-- Name: assetgroup; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE assetgroup (
    fkeyassettype integer
)
INHERITS (element);


--
-- Name: assetprop; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE assetprop (
    keyassetprop integer NOT NULL,
    fkeyassetproptype integer,
    fkeyasset integer
);


--
-- Name: assetprop_keyassetprop_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assetprop_keyassetprop_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: assetprop_keyassetprop_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE assetprop_keyassetprop_seq OWNED BY assetprop.keyassetprop;


--
-- Name: assetprop_keyassetprop_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('assetprop_keyassetprop_seq', 1, false);


--
-- Name: assetproperty_keyassetproperty_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assetproperty_keyassetproperty_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: assetproperty_keyassetproperty_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('assetproperty_keyassetproperty_seq', 1, false);


--
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
-- Name: assetproptype; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE assetproptype (
    keyassetproptype integer NOT NULL,
    name text,
    depth integer
);


--
-- Name: assetproptype_keyassetproptype_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assetproptype_keyassetproptype_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: assetproptype_keyassetproptype_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE assetproptype_keyassetproptype_seq OWNED BY assetproptype.keyassetproptype;


--
-- Name: assetproptype_keyassetproptype_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('assetproptype_keyassetproptype_seq', 1, false);


--
-- Name: assetset_keyassetset_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assetset_keyassetset_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: assetset_keyassetset_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('assetset_keyassetset_seq', 1, false);


--
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
-- Name: assetsetitem_keyassetsetitem_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assetsetitem_keyassetsetitem_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: assetsetitem_keyassetsetitem_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('assetsetitem_keyassetsetitem_seq', 1, false);


--
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
-- Name: assettemplate_keyassettemplate_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assettemplate_keyassettemplate_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: assettemplate_keyassettemplate_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('assettemplate_keyassettemplate_seq', 172, true);


--
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
-- Name: assettype_keyassettype_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assettype_keyassettype_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: assettype_keyassettype_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('assettype_keyassettype_seq', 3, true);


--
-- Name: assettype; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE assettype (
    keyassettype integer DEFAULT nextval('assettype_keyassettype_seq'::regclass) NOT NULL,
    assettype text,
    deleted boolean
);


--
-- Name: attachment_keyattachment_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE attachment_keyattachment_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: attachment_keyattachment_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('attachment_keyattachment_seq', 1, false);


--
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
-- Name: attachmenttype_keyattachmenttype_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE attachmenttype_keyattachmenttype_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: attachmenttype_keyattachmenttype_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('attachmenttype_keyattachmenttype_seq', 1, false);


--
-- Name: attachmenttype; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE attachmenttype (
    keyattachmenttype integer DEFAULT nextval('attachmenttype_keyattachmenttype_seq'::regclass) NOT NULL,
    attachmenttype text
);


--
-- Name: calendar_keycalendar_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE calendar_keycalendar_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: calendar_keycalendar_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('calendar_keycalendar_seq', 1, false);


--
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
-- Name: calendarcategory_keycalendarcategory_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE calendarcategory_keycalendarcategory_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: calendarcategory_keycalendarcategory_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('calendarcategory_keycalendarcategory_seq', 1, true);


--
-- Name: calendarcategory; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE calendarcategory (
    keycalendarcategory integer DEFAULT nextval('calendarcategory_keycalendarcategory_seq'::regclass) NOT NULL,
    calendarcategory text
);


--
-- Name: checklistitem_keychecklistitem_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE checklistitem_keychecklistitem_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: checklistitem_keychecklistitem_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('checklistitem_keychecklistitem_seq', 1, false);


--
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
-- Name: checkliststatus_keycheckliststatus_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE checkliststatus_keycheckliststatus_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: checkliststatus_keycheckliststatus_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('checkliststatus_keycheckliststatus_seq', 1, false);


--
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
-- Name: client_keyclient_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE client_keyclient_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: client_keyclient_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('client_keyclient_seq', 2, true);


--
-- Name: client; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE client (
    keyclient integer DEFAULT nextval('client_keyclient_seq'::regclass) NOT NULL,
    client text,
    textcard text
);


--
-- Name: config_keyconfig_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE config_keyconfig_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: config_keyconfig_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('config_keyconfig_seq', 29, true);


--
-- Name: config; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE config (
    keyconfig integer DEFAULT nextval('config_keyconfig_seq'::regclass) NOT NULL,
    config text,
    value text
);


--
-- Name: delivery; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE delivery (
    icon bytea
)
INHERITS (element);


--
-- Name: deliveryelement_keydeliveryshot_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE deliveryelement_keydeliveryshot_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: deliveryelement_keydeliveryshot_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('deliveryelement_keydeliveryshot_seq', 1, false);


--
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
-- Name: demoreel_keydemoreel_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE demoreel_keydemoreel_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: demoreel_keydemoreel_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('demoreel_keydemoreel_seq', 1, false);


--
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
-- Name: diskimage_keydiskimage_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE diskimage_keydiskimage_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: diskimage_keydiskimage_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('diskimage_keydiskimage_seq', 8, true);


--
-- Name: diskimage; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE diskimage (
    keydiskimage integer DEFAULT nextval('diskimage_keydiskimage_seq'::regclass) NOT NULL,
    diskimage text,
    path text,
    created timestamp without time zone
);


--
-- Name: dynamichostgroup_keydynamichostgroup_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE dynamichostgroup_keydynamichostgroup_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: dynamichostgroup_keydynamichostgroup_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('dynamichostgroup_keydynamichostgroup_seq', 1, false);


--
-- Name: hostgroup_keyhostgroup_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hostgroup_keyhostgroup_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: hostgroup_keyhostgroup_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('hostgroup_keyhostgroup_seq', 54, true);


--
-- Name: hostgroup; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE hostgroup (
    keyhostgroup integer DEFAULT nextval('hostgroup_keyhostgroup_seq'::regclass) NOT NULL,
    hostgroup text,
    fkeyusr integer,
    private boolean
);


--
-- Name: dynamichostgroup; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE dynamichostgroup (
    keydynamichostgroup integer DEFAULT nextval('dynamichostgroup_keydynamichostgroup_seq'::regclass) NOT NULL,
    hostwhereclause text
)
INHERITS (hostgroup);


--
-- Name: elementdep_keyelementdep_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE elementdep_keyelementdep_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: elementdep_keyelementdep_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('elementdep_keyelementdep_seq', 1, false);


--
-- Name: elementdep; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE elementdep (
    keyelementdep integer DEFAULT nextval('elementdep_keyelementdep_seq'::regclass) NOT NULL,
    fkeyelement integer,
    fkeyelementdep integer,
    relationtype text
);


--
-- Name: elementstatus_keyelementstatus_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE elementstatus_keyelementstatus_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: elementstatus_keyelementstatus_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('elementstatus_keyelementstatus_seq', 8, true);


--
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
-- Name: elementthread_keyelementthread_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE elementthread_keyelementthread_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: elementthread_keyelementthread_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('elementthread_keyelementthread_seq', 31, true);


--
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
    hasattachments integer,
    fkeyjob integer
);


--
-- Name: elementtype_keyelementtype_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE elementtype_keyelementtype_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: elementtype_keyelementtype_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('elementtype_keyelementtype_seq', 8, true);


--
-- Name: elementtype; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE elementtype (
    keyelementtype integer DEFAULT nextval('elementtype_keyelementtype_seq'::regclass) NOT NULL,
    elementtype text,
    sortprefix text
);


--
-- Name: elementtypetasktype_keyelementtypetasktype_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE elementtypetasktype_keyelementtypetasktype_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: elementtypetasktype_keyelementtypetasktype_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('elementtypetasktype_keyelementtypetasktype_seq', 1, false);


--
-- Name: elementtypetasktype; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE elementtypetasktype (
    keyelementtypetasktype integer DEFAULT nextval('elementtypetasktype_keyelementtypetasktype_seq'::regclass) NOT NULL,
    fkeyelementtype integer,
    fkeytasktype integer,
    fkeyassettype integer
);


--
-- Name: elementuser_keyelementuser_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE elementuser_keyelementuser_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: elementuser_keyelementuser_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('elementuser_keyelementuser_seq', 79, true);


--
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
-- Name: eventalert_keyEventAlert_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "eventalert_keyEventAlert_seq"
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: eventalert_keyEventAlert_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"eventalert_keyEventAlert_seq"', 1, false);


--
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
-- Name: filetemplate_keyfiletemplate_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE filetemplate_keyfiletemplate_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: filetemplate_keyfiletemplate_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('filetemplate_keyfiletemplate_seq', 1, false);


--
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
-- Name: filetracker_keyfiletracker_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE filetracker_keyfiletracker_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: filetracker_keyfiletracker_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('filetracker_keyfiletracker_seq', 206762, true);


--
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
-- Name: filetrackerdep_keyfiletrackerdep_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE filetrackerdep_keyfiletrackerdep_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: filetrackerdep_keyfiletrackerdep_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('filetrackerdep_keyfiletrackerdep_seq', 1, false);


--
-- Name: filetrackerdep; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE filetrackerdep (
    keyfiletrackerdep integer DEFAULT nextval('filetrackerdep_keyfiletrackerdep_seq'::regclass) NOT NULL,
    fkeyinput integer,
    fkeyoutput integer
);


--
-- Name: fileversion_keyfileversion_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE fileversion_keyfileversion_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: fileversion_keyfileversion_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('fileversion_keyfileversion_seq', 1, false);


--
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
-- Name: folder_keyfolder_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE folder_keyfolder_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: folder_keyfolder_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('folder_keyfolder_seq', 1, false);


--
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
-- Name: graph_keygraph_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE graph_keygraph_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: graph_keygraph_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('graph_keygraph_seq', 13, true);


--
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
-- Name: graphds_keygraphds_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE graphds_keygraphds_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: graphds_keygraphds_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('graphds_keygraphds_seq', 360, true);


--
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
-- Name: TABLE graphds; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE graphds IS 'Graph Datasource';


--
-- Name: graphpage_keygraphpage_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE graphpage_keygraphpage_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: graphpage_keygraphpage_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('graphpage_keygraphpage_seq', 91, true);


--
-- Name: graphpage; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE graphpage (
    keygraphpage integer DEFAULT nextval('graphpage_keygraphpage_seq'::regclass) NOT NULL,
    fkeygraphpage integer,
    name character varying(32)
);


--
-- Name: graphrelationship_keygraphrelationship_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE graphrelationship_keygraphrelationship_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: graphrelationship_keygraphrelationship_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('graphrelationship_keygraphrelationship_seq', 7, true);


--
-- Name: graphrelationship; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE graphrelationship (
    keygraphrelationship integer DEFAULT nextval('graphrelationship_keygraphrelationship_seq'::regclass) NOT NULL,
    fkeygraphds integer NOT NULL,
    fkeygraph integer NOT NULL,
    negative smallint DEFAULT 0 NOT NULL
);


--
-- Name: gridtemplate_keygridtemplate_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE gridtemplate_keygridtemplate_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: gridtemplate_keygridtemplate_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('gridtemplate_keygridtemplate_seq', 1, false);


--
-- Name: gridtemplate; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE gridtemplate (
    keygridtemplate integer DEFAULT nextval('gridtemplate_keygridtemplate_seq'::regclass) NOT NULL,
    fkeyproject integer,
    gridtemplate text
);


--
-- Name: gridtemplateitem_keygridtemplateitem_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE gridtemplateitem_keygridtemplateitem_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: gridtemplateitem_keygridtemplateitem_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('gridtemplateitem_keygridtemplateitem_seq', 1, false);


--
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
-- Name: groupmapping_keygroupmapping_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE groupmapping_keygroupmapping_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: groupmapping_keygroupmapping_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('groupmapping_keygroupmapping_seq', 1, false);


--
-- Name: groupmapping; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE groupmapping (
    keygroupmapping integer DEFAULT nextval('groupmapping_keygroupmapping_seq'::regclass) NOT NULL,
    fkeygrp integer,
    fkeymapping integer
);


--
-- Name: grp_keygrp_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE grp_keygrp_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: grp_keygrp_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('grp_keygrp_seq', 2, true);


--
-- Name: grp; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE grp (
    keygrp integer DEFAULT nextval('grp_keygrp_seq'::regclass) NOT NULL,
    grp text,
    alias text
);


--
-- Name: gruntscript_keygruntscript_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE gruntscript_keygruntscript_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: gruntscript_keygruntscript_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('gruntscript_keygruntscript_seq', 1, false);


--
-- Name: gruntscript; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE gruntscript (
    keygruntscript integer DEFAULT nextval('gruntscript_keygruntscript_seq'::regclass) NOT NULL,
    runcount integer,
    lastrun date,
    scriptname text
);


--
-- Name: history_keyhistory_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE history_keyhistory_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: history_keyhistory_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('history_keyhistory_seq', 1, false);


--
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
-- Name: hostdailystat_keyhostdailystat_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hostdailystat_keyhostdailystat_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: hostdailystat_keyhostdailystat_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('hostdailystat_keyhostdailystat_seq', 1, false);


--
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
-- Name: hostgroupitem_keyhostgroupitem_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hostgroupitem_keyhostgroupitem_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: hostgroupitem_keyhostgroupitem_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('hostgroupitem_keyhostgroupitem_seq', 6400, true);


--
-- Name: hostgroupitem; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE hostgroupitem (
    keyhostgroupitem integer DEFAULT nextval('hostgroupitem_keyhostgroupitem_seq'::regclass) NOT NULL,
    fkeyhostgroup integer,
    fkeyhost integer
);


--
-- Name: hostinterfacetype_keyhostinterfacetype_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hostinterfacetype_keyhostinterfacetype_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: hostinterfacetype_keyhostinterfacetype_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('hostinterfacetype_keyhostinterfacetype_seq', 3, true);


--
-- Name: hostinterfacetype; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE hostinterfacetype (
    keyhostinterfacetype integer DEFAULT nextval('hostinterfacetype_keyhostinterfacetype_seq'::regclass) NOT NULL,
    hostinterfacetype text
);


--
-- Name: hostload_keyhostload_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hostload_keyhostload_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: hostload_keyhostload_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('hostload_keyhostload_seq', 1, false);


--
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
-- Name: hostmapping_keyhostmapping_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hostmapping_keyhostmapping_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: hostmapping_keyhostmapping_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('hostmapping_keyhostmapping_seq', 1, false);


--
-- Name: hostmapping; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE hostmapping (
    keyhostmapping integer DEFAULT nextval('hostmapping_keyhostmapping_seq'::regclass) NOT NULL,
    fkeyhost integer NOT NULL,
    fkeymapping integer NOT NULL
);


--
-- Name: hostport_keyhostport_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hostport_keyhostport_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: hostport_keyhostport_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('hostport_keyhostport_seq', 745, true);


--
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
-- Name: hostresource_keyhostresource_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hostresource_keyhostresource_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: hostresource_keyhostresource_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('hostresource_keyhostresource_seq', 1, false);


--
-- Name: hostresource; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE hostresource (
    keyhostresource integer DEFAULT nextval('hostresource_keyhostresource_seq'::regclass) NOT NULL,
    fkeyhost integer,
    hostresource text
);


--
-- Name: hosts_ready; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE hosts_ready (
    count bigint
);


--
-- Name: hosts_total; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE hosts_total (
    count bigint
);


--
-- Name: hostservice_keyhostservice_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hostservice_keyhostservice_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: hostservice_keyhostservice_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('hostservice_keyhostservice_seq', 2572314, true);


--
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
-- Name: hostsoftware_keyhostsoftware_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hostsoftware_keyhostsoftware_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: hostsoftware_keyhostsoftware_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('hostsoftware_keyhostsoftware_seq', 283, true);


--
-- Name: hostsoftware; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE hostsoftware (
    keyhostsoftware integer DEFAULT nextval('hostsoftware_keyhostsoftware_seq'::regclass) NOT NULL,
    fkeyhost integer,
    fkeysoftware integer
);


--
-- Name: hoststatus_keyhoststatus_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hoststatus_keyhoststatus_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: hoststatus_keyhoststatus_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('hoststatus_keyhoststatus_seq', 2011, true);


--
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
-- Name: job3delight; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE job3delight (
    framenth integer,
    framenthmode integer,
    exclusiveassignment boolean,
    hastaskprogress boolean,
    minmemory integer,
    scenename text,
    shotname text,
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
-- Name: jobaftereffects; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobaftereffects (
    fkeyjobparent integer,
    endedts timestamp without time zone,
    startedts timestamp without time zone,
    submittedts timestamp without time zone,
    framenth integer,
    framenthmode integer,
    scenename text,
    shotname text,
    comp text,
    frameend integer,
    framestart integer,
    height integer,
    width integer
)
INHERITS (job);


--
-- Name: jobaftereffects7; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobaftereffects7 (
    maxhosts integer,
    environment text,
    framenth integer,
    framenthmode integer,
    scenename text,
    shotname text
)
INHERITS (jobaftereffects);


--
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
    iowait bigint,
    bytesread bigint,
    byteswrite bigint,
    efficiency double precision,
    opsread integer,
    opswrite integer
);


--
-- Name: jobassignment_keyjobassignment_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobassignment_keyjobassignment_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: jobassignment_keyjobassignment_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE jobassignment_keyjobassignment_seq OWNED BY jobassignment.keyjobassignment;


--
-- Name: jobassignment_keyjobassignment_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('jobassignment_keyjobassignment_seq', 990376, true);


--
-- Name: jobassignmentstatus; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobassignmentstatus (
    keyjobassignmentstatus integer NOT NULL,
    status text
);


--
-- Name: jobassignmentstatus_keyjobassignmentstatus_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobassignmentstatus_keyjobassignmentstatus_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: jobassignmentstatus_keyjobassignmentstatus_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE jobassignmentstatus_keyjobassignmentstatus_seq OWNED BY jobassignmentstatus.keyjobassignmentstatus;


--
-- Name: jobassignmentstatus_keyjobassignmentstatus_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('jobassignmentstatus_keyjobassignmentstatus_seq', 6, true);


--
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
    scenename text,
    shotname text,
    framestart integer,
    frameend integer,
    handle text
)
INHERITS (job);


--
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
-- Name: jobcannedbatch_keyjobcannedbatch_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobcannedbatch_keyjobcannedbatch_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: jobcannedbatch_keyjobcannedbatch_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('jobcannedbatch_keyjobcannedbatch_seq', 10, true);


--
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
-- Name: jobcinema4d; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobcinema4d (
    license text,
    fkeyjobparent integer,
    endedts timestamp without time zone,
    startedts timestamp without time zone,
    submittedts timestamp without time zone,
    loggingenabled boolean,
    scenename text,
    shotname text
)
INHERITS (job);


--
-- Name: jobcommandhistory_keyjobcommandhistory_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobcommandhistory_keyjobcommandhistory_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: jobcommandhistory_keyjobcommandhistory_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('jobcommandhistory_keyjobcommandhistory_seq', 6283934, true);


--
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
-- Name: jobdep_keyjobdep_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobdep_keyjobdep_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: jobdep_keyjobdep_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('jobdep_keyjobdep_seq', 78403, true);


--
-- Name: jobdep; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobdep (
    keyjobdep integer DEFAULT nextval('jobdep_keyjobdep_seq'::regclass) NOT NULL,
    fkeyjob integer,
    fkeydep integer,
    deptype integer DEFAULT 1 NOT NULL
);


--
-- Name: joberror_keyjoberror_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE joberror_keyjoberror_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: joberror_keyjoberror_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('joberror_keyjoberror_seq', 511524, true);


--
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
-- Name: joberrorhandler_keyjoberrorhandler_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE joberrorhandler_keyjoberrorhandler_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: joberrorhandler_keyjoberrorhandler_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('joberrorhandler_keyjoberrorhandler_seq', 1, false);


--
-- Name: joberrorhandler; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE joberrorhandler (
    keyjoberrorhandler integer DEFAULT nextval('joberrorhandler_keyjoberrorhandler_seq'::regclass) NOT NULL,
    fkeyjobtype integer,
    errorregex text,
    fkeyjoberrorhandlerscript integer
);


--
-- Name: joberrorhandlerscript_keyjoberrorhandlerscript_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE joberrorhandlerscript_keyjoberrorhandlerscript_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: joberrorhandlerscript_keyjoberrorhandlerscript_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('joberrorhandlerscript_keyjoberrorhandlerscript_seq', 1, false);


--
-- Name: joberrorhandlerscript; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE joberrorhandlerscript (
    keyjoberrorhandlerscript integer DEFAULT nextval('joberrorhandlerscript_keyjoberrorhandlerscript_seq'::regclass) NOT NULL,
    script text
);


--
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
-- Name: jobfusionvideomaker; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobfusionvideomaker (
    framenth integer,
    framenthmode integer,
    exclusiveassignment boolean,
    hastaskprogress boolean,
    minmemory integer,
    scenename text,
    shotname text,
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
-- Name: jobhistory_keyjobhistory_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobhistory_keyjobhistory_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: jobhistory_keyjobhistory_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('jobhistory_keyjobhistory_seq', 314398, true);


--
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
-- Name: jobhistorytype_keyjobhistorytype_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobhistorytype_keyjobhistorytype_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: jobhistorytype_keyjobhistorytype_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('jobhistorytype_keyjobhistorytype_seq', 1, false);


--
-- Name: jobhistorytype; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobhistorytype (
    keyjobhistorytype integer DEFAULT nextval('jobhistorytype_keyjobhistorytype_seq'::regclass) NOT NULL,
    type text
);


--
-- Name: jobhoudinisim10; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobhoudinisim10 (
    scenename text,
    shotname text,
    slices integer,
    tracker text,
    framestart integer,
    frameend integer,
    nodename text
)
INHERITS (job);


--
-- Name: jobmantra100; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobmantra100 (
    keyjobmantra100 integer NOT NULL,
    forceraytrace boolean,
    geocachesize integer,
    height integer,
    qualityflag text,
    renderquality integer,
    threads integer DEFAULT 4 NOT NULL,
    width integer
)
INHERITS (job);


--
-- Name: jobmantra100_keyjobmantra100_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobmantra100_keyjobmantra100_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: jobmantra100_keyjobmantra100_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE jobmantra100_keyjobmantra100_seq OWNED BY jobmantra100.keyjobmantra100;


--
-- Name: jobmantra100_keyjobmantra100_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('jobmantra100_keyjobmantra100_seq', 696, true);


--
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
-- Name: jobmantra95_keyjobmantra95_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobmantra95_keyjobmantra95_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: jobmantra95_keyjobmantra95_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE jobmantra95_keyjobmantra95_seq OWNED BY jobmantra95.keyjobmantra95;


--
-- Name: jobmantra95_keyjobmantra95_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('jobmantra95_keyjobmantra95_seq', 1, false);


--
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
    scenename text,
    shotname text,
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
-- Name: jobmax10; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobmax10 (
    exclusiveassignment boolean,
    hastaskprogress boolean,
    minmemory integer
)
INHERITS (jobmax);


--
-- Name: jobmax2009; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobmax2009 (
)
INHERITS (jobmax);


--
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
    scenename text,
    shotname text,
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
    scenename text,
    shotname text,
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
    scenename text,
    shotname text,
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
-- Name: jobmaya2008; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobmaya2008 (
    exclusiveassignment boolean,
    hastaskprogress boolean,
    minmemory integer
)
INHERITS (jobmaya);


--
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
    minmemory integer,
    scenename text,
    shotname text
)
INHERITS (jobmaya);


--
-- Name: jobmentalray7; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobmentalray7 (
    maxmemory integer,
    fkeyjobparent integer,
    maxhosts integer,
    exclusiveassignment boolean,
    hastaskprogress boolean,
    minmemory integer,
    scenename text,
    shotname text
)
INHERITS (jobmaya);


--
-- Name: jobmentalray8; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobmentalray8 (
    fkeyjobparent integer,
    maxhosts integer,
    framenthmode integer,
    scenename text,
    shotname text
)
INHERITS (jobmaya);


--
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
-- Name: jobnuke52; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobnuke52 (
    scenename text,
    shotname text,
    framestart integer,
    frameend integer,
    outputcount integer
)
INHERITS (job);


--
-- Name: joboutput_keyjoboutput_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE joboutput_keyjoboutput_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: joboutput_keyjoboutput_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('joboutput_keyjoboutput_seq', 264835, true);


--
-- Name: joboutput; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE joboutput (
    keyjoboutput integer DEFAULT nextval('joboutput_keyjoboutput_seq'::regclass) NOT NULL,
    fkeyjob integer,
    name text,
    fkeyfiletracker integer
);


--
-- Name: jobrealflow; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobrealflow (
    framenth integer,
    framenthmode integer,
    exclusiveassignment boolean,
    hastaskprogress boolean,
    minmemory integer,
    scenename text,
    shotname text,
    keyjobrealflow integer NOT NULL,
    framestart integer,
    frameend integer,
    simtype text,
    threads integer
)
INHERITS (job);


--
-- Name: jobrealflow_keyjobrealflow_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobrealflow_keyjobrealflow_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: jobrealflow_keyjobrealflow_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE jobrealflow_keyjobrealflow_seq OWNED BY jobrealflow.keyjobrealflow;


--
-- Name: jobrealflow_keyjobrealflow_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('jobrealflow_keyjobrealflow_seq', 1, false);


--
-- Name: jobrenderman; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobrenderman (
    framestart integer,
    frameend integer,
    version text
)
INHERITS (job);


--
-- Name: jobrenderman_keyjob_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobrenderman_keyjob_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: jobrenderman_keyjob_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('jobrenderman_keyjob_seq', 1, false);


--
-- Name: jobribgen; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobribgen (
    framestart integer,
    frameend integer,
    version text
)
INHERITS (job);


--
-- Name: jobribgen_keyjob_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobribgen_keyjob_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: jobribgen_keyjob_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('jobribgen_keyjob_seq', 1, true);


--
-- Name: jobservice_keyjobservice_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobservice_keyjobservice_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: jobservice_keyjobservice_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('jobservice_keyjobservice_seq', 273119, true);


--
-- Name: jobservice; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobservice (
    keyjobservice integer DEFAULT nextval('jobservice_keyjobservice_seq'::regclass) NOT NULL,
    fkeyjob integer,
    fkeyservice integer
);


--
-- Name: jobshake; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobshake (
    packettype text DEFAULT 'sequential'::text,
    license text,
    fkeyjobparent integer,
    exclusiveassignment boolean,
    hastaskprogress boolean,
    minmemory integer,
    scenename text,
    shotname text,
    framestart integer,
    frameend integer,
    codec text,
    slatepath text,
    framerange text
)
INHERITS (job);


--
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
-- Name: jobstat_keyjobstat_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobstat_keyjobstat_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: jobstat_keyjobstat_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('jobstat_keyjobstat_seq', 306607, true);


--
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
-- Name: jobstatus_keyjobstatus_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobstatus_keyjobstatus_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: jobstatus_keyjobstatus_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('jobstatus_keyjobstatus_seq', 255832, true);


--
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
    scenename text,
    shotname text,
    direction text,
    append text,
    filesfrom text
)
INHERITS (job);


--
-- Name: jobsystem; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobsystem (
)
INHERITS (job);


--
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
-- Name: jobtaskassignment_keyjobtaskassignment_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobtaskassignment_keyjobtaskassignment_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: jobtaskassignment_keyjobtaskassignment_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE jobtaskassignment_keyjobtaskassignment_seq OWNED BY jobtaskassignment.keyjobtaskassignment;


--
-- Name: jobtaskassignment_keyjobtaskassignment_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('jobtaskassignment_keyjobtaskassignment_seq', 4223846, true);


--
-- Name: jobtypemapping_keyjobtypemapping_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobtypemapping_keyjobtypemapping_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: jobtypemapping_keyjobtypemapping_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('jobtypemapping_keyjobtypemapping_seq', 1, false);


--
-- Name: jobtypemapping; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobtypemapping (
    keyjobtypemapping integer DEFAULT nextval('jobtypemapping_keyjobtypemapping_seq'::regclass) NOT NULL,
    fkeyjobtype integer,
    fkeymapping integer
);


--
-- Name: jobxsi; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobxsi (
    maxhosts integer,
    framenth integer,
    scenename text,
    shotname text,
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
-- Name: jobxsiscript; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobxsiscript (
    framenth integer,
    framenthmode integer,
    exclusiveassignment boolean,
    hastaskprogress boolean,
    minmemory integer,
    scenename text,
    shotname text,
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
-- Name: license_keylicense_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE license_keylicense_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: license_keylicense_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('license_keylicense_seq', 19, true);


--
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
    CONSTRAINT check_licenses_inuse CHECK ((inuse <= (total - reserved))),
    CONSTRAINT check_licenses_total CHECK ((available <= total))
);


--
-- Name: location_keylocation_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE location_keylocation_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: location_keylocation_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('location_keylocation_seq', 3, true);


--
-- Name: location; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE location (
    keylocation integer DEFAULT nextval('location_keylocation_seq'::regclass) NOT NULL,
    name text
);


--
-- Name: mapping_keymapping_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mapping_keymapping_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: mapping_keymapping_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('mapping_keymapping_seq', 1, false);


--
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
-- Name: mappingtype_keymappingtype_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mappingtype_keymappingtype_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: mappingtype_keymappingtype_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('mappingtype_keymappingtype_seq', 1, false);


--
-- Name: mappingtype; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE mappingtype (
    keymappingtype integer DEFAULT nextval('mappingtype_keymappingtype_seq'::regclass) NOT NULL,
    name text
);


--
-- Name: methodperms_keymethodperms_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE methodperms_keymethodperms_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: methodperms_keymethodperms_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('methodperms_keymethodperms_seq', 1, false);


--
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
-- Name: notification_keynotification_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notification_keynotification_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: notification_keynotification_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('notification_keynotification_seq', 12063, true);


--
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
-- Name: notificationdestination_keynotificationdestination_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notificationdestination_keynotificationdestination_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: notificationdestination_keynotificationdestination_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('notificationdestination_keynotificationdestination_seq', 1, false);


--
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
-- Name: notificationmethod_keynotificationmethod_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notificationmethod_keynotificationmethod_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: notificationmethod_keynotificationmethod_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('notificationmethod_keynotificationmethod_seq', 1, false);


--
-- Name: notificationmethod; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE notificationmethod (
    keynotificationmethod integer DEFAULT nextval('notificationmethod_keynotificationmethod_seq'::regclass) NOT NULL,
    name text
);


--
-- Name: notificationroute_keynotificationuserroute_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notificationroute_keynotificationuserroute_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: notificationroute_keynotificationuserroute_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('notificationroute_keynotificationuserroute_seq', 1, false);


--
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
-- Name: notify_keynotify_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notify_keynotify_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: notify_keynotify_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('notify_keynotify_seq', 1, false);


--
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
-- Name: notifymethod_keynotifymethod_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notifymethod_keynotifymethod_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: notifymethod_keynotifymethod_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('notifymethod_keynotifymethod_seq', 1, false);


--
-- Name: notifymethod; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE notifymethod (
    keynotifymethod integer DEFAULT nextval('notifymethod_keynotifymethod_seq'::regclass) NOT NULL,
    notifymethod text
);


--
-- Name: notifysent_keynotifysent_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notifysent_keynotifysent_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: notifysent_keynotifysent_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('notifysent_keynotifysent_seq', 1, false);


--
-- Name: notifysent; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE notifysent (
    keynotifysent integer DEFAULT nextval('notifysent_keynotifysent_seq'::regclass) NOT NULL,
    fkeynotify integer,
    fkeysyslog integer
);


--
-- Name: notifywho_keynotifywho_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notifywho_keynotifywho_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: notifywho_keynotifywho_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('notifywho_keynotifywho_seq', 1, false);


--
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
-- Name: package; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE package (
    keypackage integer NOT NULL,
    version integer,
    fkeystatus integer
);


--
-- Name: package_keypackage_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE package_keypackage_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: package_keypackage_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE package_keypackage_seq OWNED BY package.keypackage;


--
-- Name: package_keypackage_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('package_keypackage_seq', 1, false);


--
-- Name: packageoutput; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE packageoutput (
    keypackageoutput integer NOT NULL,
    fkeyasset integer
);


--
-- Name: packageoutput_keypackageoutput_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE packageoutput_keypackageoutput_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: packageoutput_keypackageoutput_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE packageoutput_keypackageoutput_seq OWNED BY packageoutput.keypackageoutput;


--
-- Name: packageoutput_keypackageoutput_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('packageoutput_keypackageoutput_seq', 1, false);


--
-- Name: pathsynctarget_keypathsynctarget_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pathsynctarget_keypathsynctarget_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: pathsynctarget_keypathsynctarget_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('pathsynctarget_keypathsynctarget_seq', 1, false);


--
-- Name: pathsynctarget; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pathsynctarget (
    keypathsynctarget integer DEFAULT nextval('pathsynctarget_keypathsynctarget_seq'::regclass) NOT NULL,
    fkeypathtracker integer,
    fkeyprojectstorage integer
);


--
-- Name: pathtemplate_keypathtemplate_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pathtemplate_keypathtemplate_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: pathtemplate_keypathtemplate_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('pathtemplate_keypathtemplate_seq', 1, false);


--
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
-- Name: pathtracker_keypathtracker_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pathtracker_keypathtracker_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: pathtracker_keypathtracker_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('pathtracker_keypathtracker_seq', 1, false);


--
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
-- Name: permission_keypermission_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE permission_keypermission_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: permission_keypermission_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('permission_keypermission_seq', 2, true);


--
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
-- Name: phoneno_keyphoneno_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE phoneno_keyphoneno_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: phoneno_keyphoneno_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('phoneno_keyphoneno_seq', 1, false);


--
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
-- Name: phonetype_keyphonetype_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE phonetype_keyphonetype_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: phonetype_keyphonetype_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('phonetype_keyphonetype_seq', 1, false);


--
-- Name: phonetype; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE phonetype (
    keyphonetype integer DEFAULT nextval('phonetype_keyphonetype_seq'::regclass) NOT NULL,
    phonetype text
);


--
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
-- Name: projectresolution_keyprojectresolution_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE projectresolution_keyprojectresolution_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: projectresolution_keyprojectresolution_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('projectresolution_keyprojectresolution_seq', 3, true);


--
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
-- Name: projectstatus_keyprojectstatus_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE projectstatus_keyprojectstatus_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: projectstatus_keyprojectstatus_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('projectstatus_keyprojectstatus_seq', 6, true);


--
-- Name: projectstatus; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE projectstatus (
    keyprojectstatus integer DEFAULT nextval('projectstatus_keyprojectstatus_seq'::regclass) NOT NULL,
    projectstatus text,
    chronology integer
);


--
-- Name: projectstorage_keyprojectstorage_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE projectstorage_keyprojectstorage_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: projectstorage_keyprojectstorage_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('projectstorage_keyprojectstorage_seq', 34, true);


--
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
-- Name: projecttempo; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE projecttempo (
    fkeyproject integer,
    tempo double precision
);


--
-- Name: queueorder; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE queueorder (
    queueorder integer NOT NULL,
    fkeyjob integer NOT NULL
);


--
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
-- Name: renderframe_keyrenderframe_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE renderframe_keyrenderframe_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: renderframe_keyrenderframe_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('renderframe_keyrenderframe_seq', 1, false);


--
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
-- Name: schedule_keyschedule_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE schedule_keyschedule_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: schedule_keyschedule_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('schedule_keyschedule_seq', 1, false);


--
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
-- Name: serverfileaction_keyserverfileaction_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE serverfileaction_keyserverfileaction_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: serverfileaction_keyserverfileaction_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE serverfileaction_keyserverfileaction_seq OWNED BY serverfileaction.keyserverfileaction;


--
-- Name: serverfileaction_keyserverfileaction_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('serverfileaction_keyserverfileaction_seq', 1, false);


--
-- Name: serverfileactionstatus; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE serverfileactionstatus (
    keyserverfileactionstatus integer NOT NULL,
    status text,
    name text
);


--
-- Name: serverfileactionstatus_keyserverfileactionstatus_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE serverfileactionstatus_keyserverfileactionstatus_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: serverfileactionstatus_keyserverfileactionstatus_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE serverfileactionstatus_keyserverfileactionstatus_seq OWNED BY serverfileactionstatus.keyserverfileactionstatus;


--
-- Name: serverfileactionstatus_keyserverfileactionstatus_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('serverfileactionstatus_keyserverfileactionstatus_seq', 1, false);


--
-- Name: serverfileactiontype; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE serverfileactiontype (
    keyserverfileactiontype integer NOT NULL,
    type text
);


--
-- Name: serverfileactiontype_keyserverfileactiontype_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE serverfileactiontype_keyserverfileactiontype_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: serverfileactiontype_keyserverfileactiontype_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE serverfileactiontype_keyserverfileactiontype_seq OWNED BY serverfileactiontype.keyserverfileactiontype;


--
-- Name: serverfileactiontype_keyserverfileactiontype_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('serverfileactiontype_keyserverfileactiontype_seq', 1, false);


--
-- Name: service_keyservice_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE service_keyservice_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: service_keyservice_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('service_keyservice_seq', 44, true);


--
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
-- Name: sessions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sessions (
    id text,
    length integer,
    a_session text,
    "time" timestamp without time zone
);


--
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
-- Name: shotgroup; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE shotgroup (
    shotgroup text
)
INHERITS (element);


--
-- Name: software_keysoftware_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE software_keysoftware_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: software_keysoftware_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('software_keysoftware_seq', 9, true);


--
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
-- Name: status; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE status (
    keystatus integer NOT NULL,
    name text
);


--
-- Name: status_keystatus_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE status_keystatus_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: status_keystatus_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE status_keystatus_seq OWNED BY status.keystatus;


--
-- Name: status_keystatus_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('status_keystatus_seq', 1, false);


--
-- Name: statusset_keystatusset_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE statusset_keystatusset_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: statusset_keystatusset_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('statusset_keystatusset_seq', 1, false);


--
-- Name: statusset; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE statusset (
    keystatusset integer DEFAULT nextval('statusset_keystatusset_seq'::regclass) NOT NULL,
    name text NOT NULL
);


--
-- Name: syslog_keysyslog_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE syslog_keysyslog_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: syslog_keysyslog_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('syslog_keysyslog_seq', 17359, true);


--
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
    ack smallint DEFAULT 0 NOT NULL,
    firstoccurence timestamp without time zone,
    hostname text,
    username text
);


--
-- Name: syslog_count_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE syslog_count_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: syslog_count_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('syslog_count_seq', 1, false);


--
-- Name: syslogrealm_keysyslogrealm_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE syslogrealm_keysyslogrealm_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: syslogrealm_keysyslogrealm_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('syslogrealm_keysyslogrealm_seq', 6, true);


--
-- Name: syslogrealm; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE syslogrealm (
    keysyslogrealm integer DEFAULT nextval('syslogrealm_keysyslogrealm_seq'::regclass) NOT NULL,
    syslogrealm text
);


--
-- Name: syslogseverity_keysyslogseverity_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE syslogseverity_keysyslogseverity_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: syslogseverity_keysyslogseverity_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('syslogseverity_keysyslogseverity_seq', 4, true);


--
-- Name: syslogseverity; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE syslogseverity (
    keysyslogseverity integer DEFAULT nextval('syslogseverity_keysyslogseverity_seq'::regclass) NOT NULL,
    syslogseverity text,
    severity text
);


--
-- Name: task; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE task (
    icon bytea,
    fkeytasktype integer,
    shotgroup integer
)
INHERITS (element);


--
-- Name: tasktype_keytasktype_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tasktype_keytasktype_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: tasktype_keytasktype_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('tasktype_keytasktype_seq', 1, false);


--
-- Name: tasktype; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tasktype (
    keytasktype integer DEFAULT nextval('tasktype_keytasktype_seq'::regclass) NOT NULL,
    tasktype text,
    iconcolor text
);


--
-- Name: taskuser_keytaskuser_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE taskuser_keytaskuser_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: taskuser_keytaskuser_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('taskuser_keytaskuser_seq', 1, false);


--
-- Name: taskuser; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE taskuser (
    keytaskuser integer DEFAULT nextval('taskuser_keytaskuser_seq'::regclass) NOT NULL,
    fkeytask integer,
    fkeyuser integer,
    active integer
);


--
-- Name: thread_keythread_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE thread_keythread_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: thread_keythread_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('thread_keythread_seq', 1, false);


--
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
-- Name: threadcategory_keythreadcategory_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE threadcategory_keythreadcategory_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: threadcategory_keythreadcategory_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('threadcategory_keythreadcategory_seq', 1, false);


--
-- Name: threadcategory; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE threadcategory (
    keythreadcategory integer DEFAULT nextval('threadcategory_keythreadcategory_seq'::regclass) NOT NULL,
    threadcategory text
);


--
-- Name: threadnotify_keythreadnotify_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE threadnotify_keythreadnotify_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: threadnotify_keythreadnotify_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('threadnotify_keythreadnotify_seq', 12, true);


--
-- Name: threadnotify; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE threadnotify (
    keythreadnotify integer DEFAULT nextval('threadnotify_keythreadnotify_seq'::regclass) NOT NULL,
    fkeythread integer,
    fkeyuser integer,
    options integer
);


--
-- Name: thumbnail_keythumbnail_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE thumbnail_keythumbnail_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: thumbnail_keythumbnail_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('thumbnail_keythumbnail_seq', 25, true);


--
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
-- Name: timesheet_keytimesheet_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE timesheet_keytimesheet_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: timesheet_keytimesheet_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('timesheet_keytimesheet_seq', 4, true);


--
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
-- Name: timesheetcategory_keytimesheetcategory_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE timesheetcategory_keytimesheetcategory_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: timesheetcategory_keytimesheetcategory_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('timesheetcategory_keytimesheetcategory_seq', 179, true);


--
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
-- Name: tracker_keytracker_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tracker_keytracker_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: tracker_keytracker_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('tracker_keytracker_seq', 1, false);


--
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
-- Name: trackercategory_keytrackercategory_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE trackercategory_keytrackercategory_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: trackercategory_keytrackercategory_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('trackercategory_keytrackercategory_seq', 1, false);


--
-- Name: trackercategory; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE trackercategory (
    keytrackercategory integer DEFAULT nextval('trackercategory_keytrackercategory_seq'::regclass) NOT NULL,
    trackercategory text
);


--
-- Name: trackerlog_keytrackerlog_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE trackerlog_keytrackerlog_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: trackerlog_keytrackerlog_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('trackerlog_keytrackerlog_seq', 1, false);


--
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
-- Name: trackerqueue_keytrackerqueue_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE trackerqueue_keytrackerqueue_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: trackerqueue_keytrackerqueue_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('trackerqueue_keytrackerqueue_seq', 1, false);


--
-- Name: trackerqueue; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE trackerqueue (
    keytrackerqueue integer DEFAULT nextval('trackerqueue_keytrackerqueue_seq'::regclass) NOT NULL,
    trackerqueue text
);


--
-- Name: trackerseverity_keytrackerseverity_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE trackerseverity_keytrackerseverity_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: trackerseverity_keytrackerseverity_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('trackerseverity_keytrackerseverity_seq', 1, false);


--
-- Name: trackerseverity; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE trackerseverity (
    keytrackerseverity integer DEFAULT nextval('trackerseverity_keytrackerseverity_seq'::regclass) NOT NULL,
    trackerseverity text
);


--
-- Name: trackerstatus_keytrackerstatus_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE trackerstatus_keytrackerstatus_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: trackerstatus_keytrackerstatus_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('trackerstatus_keytrackerstatus_seq', 1, false);


--
-- Name: trackerstatus; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE trackerstatus (
    keytrackerstatus integer DEFAULT nextval('trackerstatus_keytrackerstatus_seq'::regclass) NOT NULL,
    trackerstatus text
);


--
-- Name: userelement_keyuserelement_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE userelement_keyuserelement_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: userelement_keyuserelement_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('userelement_keyuserelement_seq', 1, false);


--
-- Name: userelement; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE userelement (
    keyuserelement integer DEFAULT nextval('userelement_keyuserelement_seq'::regclass) NOT NULL,
    fkeyelement integer,
    fkeyusr integer,
    fkeyuser integer
);


--
-- Name: usermapping_keyusermapping_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE usermapping_keyusermapping_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: usermapping_keyusermapping_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('usermapping_keyusermapping_seq', 1, false);


--
-- Name: usermapping; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE usermapping (
    keyusermapping integer DEFAULT nextval('usermapping_keyusermapping_seq'::regclass) NOT NULL,
    fkeyusr integer,
    fkeymapping integer
);


--
-- Name: userrole_keyuserrole_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE userrole_keyuserrole_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: userrole_keyuserrole_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('userrole_keyuserrole_seq', 3, true);


--
-- Name: userrole; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE userrole (
    keyuserrole integer DEFAULT nextval('userrole_keyuserrole_seq'::regclass) NOT NULL,
    fkeytasktype integer,
    fkeyusr integer
);


--
-- Name: usrgrp_keyusrgrp_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE usrgrp_keyusrgrp_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: usrgrp_keyusrgrp_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('usrgrp_keyusrgrp_seq', 3, true);


--
-- Name: usrgrp; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE usrgrp (
    keyusrgrp integer DEFAULT nextval('usrgrp_keyusrgrp_seq'::regclass) NOT NULL,
    fkeyusr integer,
    fkeygrp integer,
    usrgrp text
);


--
-- Name: version; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE version (
    keyversion integer NOT NULL
);


--
-- Name: version_keyversion_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE version_keyversion_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: version_keyversion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE version_keyversion_seq OWNED BY version.keyversion;


--
-- Name: version_keyversion_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('version_keyversion_seq', 1, false);


--
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
-- Name: keyassetdep; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE assetdep ALTER COLUMN keyassetdep SET DEFAULT nextval('assetdep_keyassetdep_seq'::regclass);


--
-- Name: keyassetprop; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE assetprop ALTER COLUMN keyassetprop SET DEFAULT nextval('assetprop_keyassetprop_seq'::regclass);


--
-- Name: keyassetproptype; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE assetproptype ALTER COLUMN keyassetproptype SET DEFAULT nextval('assetproptype_keyassetproptype_seq'::regclass);


--
-- Name: keyjobassignment; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE jobassignment ALTER COLUMN keyjobassignment SET DEFAULT nextval('jobassignment_keyjobassignment_seq'::regclass);


--
-- Name: keyjobassignmentstatus; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE jobassignmentstatus ALTER COLUMN keyjobassignmentstatus SET DEFAULT nextval('jobassignmentstatus_keyjobassignmentstatus_seq'::regclass);


--
-- Name: keyjobmantra100; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE jobmantra100 ALTER COLUMN keyjobmantra100 SET DEFAULT nextval('jobmantra100_keyjobmantra100_seq'::regclass);


--
-- Name: keyjobmantra95; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE jobmantra95 ALTER COLUMN keyjobmantra95 SET DEFAULT nextval('jobmantra95_keyjobmantra95_seq'::regclass);


--
-- Name: keyjobrealflow; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE jobrealflow ALTER COLUMN keyjobrealflow SET DEFAULT nextval('jobrealflow_keyjobrealflow_seq'::regclass);


--
-- Name: keyjobtaskassignment; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE jobtaskassignment ALTER COLUMN keyjobtaskassignment SET DEFAULT nextval('jobtaskassignment_keyjobtaskassignment_seq'::regclass);


--
-- Name: keypackage; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE package ALTER COLUMN keypackage SET DEFAULT nextval('package_keypackage_seq'::regclass);


--
-- Name: keypackageoutput; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE packageoutput ALTER COLUMN keypackageoutput SET DEFAULT nextval('packageoutput_keypackageoutput_seq'::regclass);


--
-- Name: keyserverfileaction; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE serverfileaction ALTER COLUMN keyserverfileaction SET DEFAULT nextval('serverfileaction_keyserverfileaction_seq'::regclass);


--
-- Name: keyserverfileactionstatus; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE serverfileactionstatus ALTER COLUMN keyserverfileactionstatus SET DEFAULT nextval('serverfileactionstatus_keyserverfileactionstatus_seq'::regclass);


--
-- Name: keyserverfileactiontype; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE serverfileactiontype ALTER COLUMN keyserverfileactiontype SET DEFAULT nextval('serverfileactiontype_keyserverfileactiontype_seq'::regclass);


--
-- Name: keystatus; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE status ALTER COLUMN keystatus SET DEFAULT nextval('status_keystatus_seq'::regclass);


--
-- Name: keyversion; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE version ALTER COLUMN keyversion SET DEFAULT nextval('version_keyversion_seq'::regclass);


SET search_path = jabberd, pg_catalog;

--
-- Data for Name: active; Type: TABLE DATA; Schema: jabberd; Owner: -
--

COPY active ("collection-owner", "object-sequence", "time") FROM stdin;
\.


--
-- Data for Name: authreg; Type: TABLE DATA; Schema: jabberd; Owner: -
--

COPY authreg (username, realm, password, token, sequence, hash) FROM stdin;
\.


--
-- Data for Name: logout; Type: TABLE DATA; Schema: jabberd; Owner: -
--

COPY logout ("collection-owner", "object-sequence", "time") FROM stdin;
\.


--
-- Data for Name: privacy-items; Type: TABLE DATA; Schema: jabberd; Owner: -
--

COPY "privacy-items" ("collection-owner", "object-sequence", list, type, value, deny, "order", block) FROM stdin;
\.


--
-- Data for Name: private; Type: TABLE DATA; Schema: jabberd; Owner: -
--

COPY private ("collection-owner", "object-sequence", ns, xml) FROM stdin;
\.


--
-- Data for Name: queue; Type: TABLE DATA; Schema: jabberd; Owner: -
--

COPY queue ("collection-owner", "object-sequence", xml) FROM stdin;
\.


--
-- Data for Name: roster-groups; Type: TABLE DATA; Schema: jabberd; Owner: -
--

COPY "roster-groups" ("collection-owner", "object-sequence", jid, "group") FROM stdin;
\.


--
-- Data for Name: roster-items; Type: TABLE DATA; Schema: jabberd; Owner: -
--

COPY "roster-items" ("collection-owner", "object-sequence", jid, name, ask, "to", "from") FROM stdin;
\.


--
-- Data for Name: vcard; Type: TABLE DATA; Schema: jabberd; Owner: -
--

COPY vcard ("collection-owner", "object-sequence", fn, nickname, url, tel, email, title, role, bday, "desc", "n-given", "n-family", "adr-street", "adr-extadd", "adr-locality", "adr-region", "adr-pcode", "adr-country", "org-orgname", "org-orgunit") FROM stdin;
\.


SET search_path = public, pg_catalog;

--
-- Data for Name: abdownloadstat; Type: TABLE DATA; Schema: public; Owner: -
--

COPY abdownloadstat (keyabdownloadstat, type, size, fkeyhost, "time", abrev, finished, fkeyjob) FROM stdin;
\.


--
-- Data for Name: annotation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY annotation (keyannotation, notes, sequence, framestart, frameend, markupdata) FROM stdin;
\.


--
-- Data for Name: asset; Type: TABLE DATA; Schema: public; Owner: -
--

COPY asset (keyelement, daysbid, description, fkeyelement, fkeyelementstatus, fkeyelementtype, fkeyproject, fkeythumbnail, name, daysscheduled, daysestimated, status, filepath, fkeyassettype, fkeypathtemplate, fkeystatusset, allowtime, datestart, datecomplete, fkeyassettemplate, icon, fkeystatus, keyasset, version) FROM stdin;
\.


--
-- Data for Name: assetdep; Type: TABLE DATA; Schema: public; Owner: -
--

COPY assetdep (keyassetdep, path, fkeypackage, fkeyasset) FROM stdin;
\.


--
-- Data for Name: assetgroup; Type: TABLE DATA; Schema: public; Owner: -
--

COPY assetgroup (keyelement, daysbid, description, fkeyelement, fkeyelementstatus, fkeyelementtype, fkeyproject, fkeythumbnail, name, daysscheduled, daysestimated, status, filepath, fkeyassettype, fkeypathtemplate, fkeystatusset, allowtime, datestart, datecomplete, fkeyassettemplate, icon) FROM stdin;
\.


--
-- Data for Name: assetprop; Type: TABLE DATA; Schema: public; Owner: -
--

COPY assetprop (keyassetprop, fkeyassetproptype, fkeyasset) FROM stdin;
\.


--
-- Data for Name: assetproperty; Type: TABLE DATA; Schema: public; Owner: -
--

COPY assetproperty (keyassetproperty, name, type, value, fkeyelement) FROM stdin;
\.


--
-- Data for Name: assetproptype; Type: TABLE DATA; Schema: public; Owner: -
--

COPY assetproptype (keyassetproptype, name, depth) FROM stdin;
\.


--
-- Data for Name: assetset; Type: TABLE DATA; Schema: public; Owner: -
--

COPY assetset (keyassetset, fkeyproject, fkeyelementtype, fkeyassettype, name) FROM stdin;
\.


--
-- Data for Name: assetsetitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY assetsetitem (keyassetsetitem, fkeyassetset, fkeyassettype, fkeyelementtype, fkeytasktype) FROM stdin;
\.


--
-- Data for Name: assettemplate; Type: TABLE DATA; Schema: public; Owner: -
--

COPY assettemplate (keyassettemplate, fkeyassettype, fkeyelement, fkeyproject, name) FROM stdin;
\.


--
-- Data for Name: assettype; Type: TABLE DATA; Schema: public; Owner: -
--

COPY assettype (keyassettype, assettype, deleted) FROM stdin;
\.


--
-- Data for Name: attachment; Type: TABLE DATA; Schema: public; Owner: -
--

COPY attachment (keyattachment, caption, created, filename, fkeyelement, fkeyuser, origpath, attachment, url, description, fkeyauthor, fkeyattachmenttype) FROM stdin;
\.


--
-- Data for Name: attachmenttype; Type: TABLE DATA; Schema: public; Owner: -
--

COPY attachmenttype (keyattachmenttype, attachmenttype) FROM stdin;
\.


--
-- Data for Name: calendar; Type: TABLE DATA; Schema: public; Owner: -
--

COPY calendar (keycalendar, repeat, fkeycalendarcategory, url, fkeyauthor, fieldname, notifylist, notifybatch, leadtime, notifymask, fkeyusr, private, date, calendar, fkeyproject) FROM stdin;
\.


--
-- Data for Name: calendarcategory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY calendarcategory (keycalendarcategory, calendarcategory) FROM stdin;
\.


--
-- Data for Name: checklistitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY checklistitem (keychecklistitem, body, checklistitem, fkeyproject, fkeythumbnail, fkeytimesheetcategory, type, fkeystatusset) FROM stdin;
\.


--
-- Data for Name: checkliststatus; Type: TABLE DATA; Schema: public; Owner: -
--

COPY checkliststatus (keycheckliststatus, fkeychecklistitem, fkeyelement, state, fkeyelementstatus) FROM stdin;
\.


--
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: -
--

COPY client (keyclient, client, textcard) FROM stdin;
\.


--
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
21	assburnerAutoPacketTarget	420
22	assburnerAutoPacketDefault	150
4	managerDriveLetter	/drd/jobs
5	emailDomain	@drdstudios.com
14	jabberDomain	im.drd.int
15	jabberSystemUser	farm
16	jabberSystemPassword	autologin
23	emailServer	smtp.drd.roam
24	assburnerLogRootDir	/farm/logs/
26	attachmentPathUnix	/farm/logs/.attachments/
27	attachmentPathWin	T:/farm/logs/.attachments/
29	assburnerPulsePeriod	600
25	emailSender	farm@drdstudios.com
8	assburnerTotalFailureErrorThreshold	9
19	assburnerHostErrorLimit	2
28	assburnerLoopTime	4000
\.


--
-- Data for Name: countercache; Type: TABLE DATA; Schema: public; Owner: -
--

COPY countercache (hoststotal, hostsactive, hostsready, jobstotal, jobsactive, jobsdone, lastupdated) FROM stdin;
0	0	243	1043	0	979	2010-05-21 02:00:24.573258
\.


--
-- Data for Name: delivery; Type: TABLE DATA; Schema: public; Owner: -
--

COPY delivery (keyelement, daysbid, description, fkeyelement, fkeyelementstatus, fkeyelementtype, fkeyproject, fkeythumbnail, name, daysscheduled, daysestimated, status, filepath, fkeyassettype, fkeypathtemplate, fkeystatusset, allowtime, datestart, datecomplete, fkeyassettemplate, icon) FROM stdin;
\.


--
-- Data for Name: deliveryelement; Type: TABLE DATA; Schema: public; Owner: -
--

COPY deliveryelement (keydeliveryshot, fkeydelivery, fkeyelement, framestart, frameend) FROM stdin;
\.


--
-- Data for Name: demoreel; Type: TABLE DATA; Schema: public; Owner: -
--

COPY demoreel (keydemoreel, demoreel, datesent, projectlist, contactinfo, notes, playlist, shippingtype) FROM stdin;
\.


--
-- Data for Name: diskimage; Type: TABLE DATA; Schema: public; Owner: -
--

COPY diskimage (keydiskimage, diskimage, path, created) FROM stdin;
\.


--
-- Data for Name: dynamichostgroup; Type: TABLE DATA; Schema: public; Owner: -
--

COPY dynamichostgroup (keyhostgroup, hostgroup, fkeyusr, private, keydynamichostgroup, hostwhereclause) FROM stdin;
\.


--
-- Data for Name: element; Type: TABLE DATA; Schema: public; Owner: -
--

COPY element (keyelement, daysbid, description, fkeyelement, fkeyelementstatus, fkeyelementtype, fkeyproject, fkeythumbnail, name, daysscheduled, daysestimated, status, filepath, fkeyassettype, fkeypathtemplate, fkeystatusset, allowtime, datestart, datecomplete, fkeyassettemplate, icon) FROM stdin;
\.


--
-- Data for Name: elementdep; Type: TABLE DATA; Schema: public; Owner: -
--

COPY elementdep (keyelementdep, fkeyelement, fkeyelementdep, relationtype) FROM stdin;
\.


--
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
-- Data for Name: elementthread; Type: TABLE DATA; Schema: public; Owner: -
--

COPY elementthread (keyelementthread, datetime, elementthread, fkeyelement, fkeyusr, skeyreply, topic, todostatus, hasattachments, fkeyjob) FROM stdin;
\.


--
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
-- Data for Name: elementtypetasktype; Type: TABLE DATA; Schema: public; Owner: -
--

COPY elementtypetasktype (keyelementtypetasktype, fkeyelementtype, fkeytasktype, fkeyassettype) FROM stdin;
\.


--
-- Data for Name: elementuser; Type: TABLE DATA; Schema: public; Owner: -
--

COPY elementuser (keyelementuser, fkeyelement, fkeyuser, active, fkeyassettype) FROM stdin;
\.


--
-- Data for Name: employee; Type: TABLE DATA; Schema: public; Owner: -
--

COPY employee (keyelement, daysbid, description, fkeyelement, fkeyelementstatus, fkeyelementtype, fkeyproject, fkeythumbnail, name, daysscheduled, daysestimated, status, filepath, fkeyassettype, fkeypathtemplate, fkeystatusset, allowtime, datestart, datecomplete, fkeyassettemplate, icon, dateoflastlogon, email, fkeyhost, gpgkey, jid, pager, password, remoteips, schedule, shell, uid, threadnotifybyjabber, threadnotifybyemail, fkeyclient, intranet, homedir, disabled, gid, usr, keyusr, rolemask, usrlevel, remoteok, requestcount, sessiontimeout, logoncount, useradded, oldkeyusr, sid, lastlogontype, namefirst, namelast, dateofhire, dateoftermination, dateofbirth, logon, lockedout, bebackat, comment, userlevel, nopostdays, initials, missingtimesheetcount, namemiddle) FROM stdin;
\.


--
-- Data for Name: eventalert; Type: TABLE DATA; Schema: public; Owner: -
--

COPY eventalert ("keyEventAlert", "fkeyHost", graphds, "sampleType", "samplePeriod", severity, "sampleDirection", varname, "sampleValue") FROM stdin;
\.


--
-- Data for Name: filetemplate; Type: TABLE DATA; Schema: public; Owner: -
--

COPY filetemplate (keyfiletemplate, fkeyelementtype, fkeyproject, fkeytasktype, name, sourcefile, templatefilename, trackertable) FROM stdin;
\.


--
-- Data for Name: filetracker; Type: TABLE DATA; Schema: public; Owner: -
--

COPY filetracker (keyfiletracker, fkeyelement, name, path, filename, fkeypathtemplate, fkeyprojectstorage, storagename) FROM stdin;
\.


--
-- Data for Name: filetrackerdep; Type: TABLE DATA; Schema: public; Owner: -
--

COPY filetrackerdep (keyfiletrackerdep, fkeyinput, fkeyoutput) FROM stdin;
\.


--
-- Data for Name: fileversion; Type: TABLE DATA; Schema: public; Owner: -
--

COPY fileversion (keyfileversion, version, iteration, path, oldfilenames, filename, filenametemplate, automaster, fkeyelement, fkeyfileversion) FROM stdin;
\.


--
-- Data for Name: folder; Type: TABLE DATA; Schema: public; Owner: -
--

COPY folder (keyfolder, folder, mount, tablename, fkey, online, alias, host, link) FROM stdin;
\.


--
-- Data for Name: graph; Type: TABLE DATA; Schema: public; Owner: -
--

COPY graph (keygraph, height, width, vlabel, period, fkeygraphpage, upperlimit, lowerlimit, stack, graphmax, sortorder, graph) FROM stdin;
\.


--
-- Data for Name: graphds; Type: TABLE DATA; Schema: public; Owner: -
--

COPY graphds (keygraphds, varname, dstype, fkeyhost, cdef, graphds, fieldname, filename, negative) FROM stdin;
\.


--
-- Data for Name: graphpage; Type: TABLE DATA; Schema: public; Owner: -
--

COPY graphpage (keygraphpage, fkeygraphpage, name) FROM stdin;
\.


--
-- Data for Name: graphrelationship; Type: TABLE DATA; Schema: public; Owner: -
--

COPY graphrelationship (keygraphrelationship, fkeygraphds, fkeygraph, negative) FROM stdin;
\.


--
-- Data for Name: gridtemplate; Type: TABLE DATA; Schema: public; Owner: -
--

COPY gridtemplate (keygridtemplate, fkeyproject, gridtemplate) FROM stdin;
\.


--
-- Data for Name: gridtemplateitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY gridtemplateitem (keygridtemplateitem, fkeygridtemplate, fkeytasktype, checklistitems, columntype, headername, "position") FROM stdin;
\.


--
-- Data for Name: groupmapping; Type: TABLE DATA; Schema: public; Owner: -
--

COPY groupmapping (keygroupmapping, fkeygrp, fkeymapping) FROM stdin;
\.


--
-- Data for Name: grp; Type: TABLE DATA; Schema: public; Owner: -
--

COPY grp (keygrp, grp, alias) FROM stdin;
\.


--
-- Data for Name: gruntscript; Type: TABLE DATA; Schema: public; Owner: -
--

COPY gruntscript (keygruntscript, runcount, lastrun, scriptname) FROM stdin;
\.


--
-- Data for Name: history; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history (keyhistory, date, fkeyelement, fkeyusr, history) FROM stdin;
\.


--
-- Data for Name: host; Type: TABLE DATA; Schema: public; Owner: -
--

COPY host (keyhost, backupbytes, cpus, description, diskusage, fkeyjob, host, manufacturer, model, os, rendertime, slavepluginlist, sn, version, renderrate, dutycycle, memory, mhtz, online, uid, slavepacketweight, framecount, viruscount, virustimestamp, errortempo, fkeyhost_backup, oldkey, abversion, laststatuschange, loadavg, allowmapping, allowsleep, fkeyjobtask, wakeonlan, architecture, loc_x, loc_y, loc_z, ostext, bootaction, fkeydiskimage, syncname, fkeylocation, cpuname, osversion, slavepulse, puppetpulse, maxassignments, fkeyuser) FROM stdin;
\.


--
-- Data for Name: hostdailystat; Type: TABLE DATA; Schema: public; Owner: -
--

COPY hostdailystat (keyhostdailystat, fkeyhost, readytime, assignedtime, copytime, loadtime, busytime, offlinetime, date, tasksdone, loaderrors, taskerrors, loaderrortime, busyerrortime) FROM stdin;
\.


--
-- Data for Name: hostgroup; Type: TABLE DATA; Schema: public; Owner: -
--

COPY hostgroup (keyhostgroup, hostgroup, fkeyusr, private) FROM stdin;
\.


--
-- Data for Name: hostgroupitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY hostgroupitem (keyhostgroupitem, fkeyhostgroup, fkeyhost) FROM stdin;
\.


--
-- Data for Name: hosthistory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY hosthistory (keyhosthistory, fkeyhost, fkeyjob, fkeyjobstat, status, laststatus, datetime, duration, fkeyjobtask, fkeyjobtype, nextstatus, success, fkeyjoberror, change_from_ip, fkeyjobcommandhistory) FROM stdin;
\.


--
-- Data for Name: hostinterface; Type: TABLE DATA; Schema: public; Owner: -
--

COPY hostinterface (keyhostinterface, fkeyhost, mac, ip, fkeyhostinterfacetype, switchport, fkeyswitch, inst) FROM stdin;
\.


--
-- Data for Name: hostinterfacetype; Type: TABLE DATA; Schema: public; Owner: -
--

COPY hostinterfacetype (keyhostinterfacetype, hostinterfacetype) FROM stdin;
1	Primary
2	Alias
3	CNAME
\.


--
-- Data for Name: hostload; Type: TABLE DATA; Schema: public; Owner: -
--

COPY hostload (keyhostload, fkeyhost, loadavg, loadavgadjust, loadavgadjusttimestamp) FROM stdin;
\.


--
-- Data for Name: hostmapping; Type: TABLE DATA; Schema: public; Owner: -
--

COPY hostmapping (keyhostmapping, fkeyhost, fkeymapping) FROM stdin;
\.


--
-- Data for Name: hostport; Type: TABLE DATA; Schema: public; Owner: -
--

COPY hostport (keyhostport, fkeyhost, port, monitor, monitorstatus) FROM stdin;
\.


--
-- Data for Name: hostresource; Type: TABLE DATA; Schema: public; Owner: -
--

COPY hostresource (keyhostresource, fkeyhost, hostresource) FROM stdin;
\.


--
-- Data for Name: hosts_ready; Type: TABLE DATA; Schema: public; Owner: -
--

COPY hosts_ready (count) FROM stdin;
\.


--
-- Data for Name: hosts_total; Type: TABLE DATA; Schema: public; Owner: -
--

COPY hosts_total (count) FROM stdin;
\.


--
-- Data for Name: hostservice; Type: TABLE DATA; Schema: public; Owner: -
--

COPY hostservice (keyhostservice, fkeyhost, fkeyservice, hostserviceinfo, hostservice, fkeysyslog, enabled, pulse, remotelogport) FROM stdin;
\.


--
-- Data for Name: hostsoftware; Type: TABLE DATA; Schema: public; Owner: -
--

COPY hostsoftware (keyhostsoftware, fkeyhost, fkeysoftware) FROM stdin;
\.


--
-- Data for Name: hoststatus; Type: TABLE DATA; Schema: public; Owner: -
--

COPY hoststatus (keyhoststatus, fkeyhost, slavestatus, laststatuschange, slavepulse, fkeyjobtask, online, activeassignmentcount, availablememory, lastassignmentchange) FROM stdin;
\.


--
-- Data for Name: job; Type: TABLE DATA; Schema: public; Owner: -
--

COPY job (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots) FROM stdin;
\.


--
-- Data for Name: job3delight; Type: TABLE DATA; Schema: public; Owner: -
--

COPY job3delight (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots, width, height, framestart, frameend, threads, processes, jobscript, jobscriptparam) FROM stdin;
\.


--
-- Data for Name: jobaftereffects; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobaftereffects (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots, comp, frameend, framestart, height, width) FROM stdin;
\.


--
-- Data for Name: jobaftereffects7; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobaftereffects7 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots, comp, frameend, framestart, height, width) FROM stdin;
\.


--
-- Data for Name: jobaftereffects8; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobaftereffects8 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots, comp, frameend, framestart, height, width) FROM stdin;
\.


--
-- Data for Name: jobassignment; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobassignment (keyjobassignment, fkeyjob, fkeyjobassignmentstatus, fkeyhost, stdout, stderr, command, maxmemory, started, ended, fkeyjoberror, realtime, usertime, systime, iowait, bytesread, byteswrite, efficiency, opsread, opswrite) FROM stdin;
\.


--
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
-- Data for Name: jobautodeskburn; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobautodeskburn (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots, framestart, frameend, handle) FROM stdin;
\.


--
-- Data for Name: jobbatch; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobbatch (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots, cmd, restartafterfinish, restartaftershutdown, passslaveframesasparam, disablewow64fsredirect) FROM stdin;
\.


--
-- Data for Name: jobcannedbatch; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobcannedbatch (keyjobcannedbatch, name, "group", cmd, disablewow64fsredirect) FROM stdin;
2	Switch2Mac	DualBoot	sh -c "/usr/local/bin/switchtomac && reboot"	\N
3	Switch2Linux	DualBoot	sh -c "/usr/local/bin/switchtolinux && reboot"	\N
4	Switch to Mac	DualBoot	sh -c "/mnt/x5/Global/infrastructure/perl/scripts/switchtomac"	\N
5	Switch to Linux	DualBoot	sh -c "/mnt/x5/Global/infrastructure/perl/scripts/switchtolinux"	\N
6	puppet	Admin	/usr/sbin/puppetd --test	f
7	yum-update	Admin	/usr/bin/yum update -y	f
8	gnglia	Restart Ganglia	/sbin/service gmond restart	f
9	Tank Fuse restart	Admin	/sbin/service tank_hf2_fuse restart	f
10	restart tasklogger	Services	svc-restart tasklogger	f
\.


--
-- Data for Name: jobcinema4d; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobcinema4d (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots) FROM stdin;
\.


--
-- Data for Name: jobcommandhistory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobcommandhistory (keyjobcommandhistory, stderr, stdout, command, memory, fkeyjob, fkeyhost, fkeyhosthistory, iowait, realtime, systime, usertime) FROM stdin;
\.


--
-- Data for Name: jobdep; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobdep (keyjobdep, fkeyjob, fkeydep, deptype) FROM stdin;
\.


--
-- Data for Name: joberror; Type: TABLE DATA; Schema: public; Owner: -
--

COPY joberror (keyjoberror, fkeyhost, fkeyjob, frames, message, errortime, count, cleared, lastoccurrence, timeout) FROM stdin;
\.


--
-- Data for Name: joberrorhandler; Type: TABLE DATA; Schema: public; Owner: -
--

COPY joberrorhandler (keyjoberrorhandler, fkeyjobtype, errorregex, fkeyjoberrorhandlerscript) FROM stdin;
\.


--
-- Data for Name: joberrorhandlerscript; Type: TABLE DATA; Schema: public; Owner: -
--

COPY joberrorhandlerscript (keyjoberrorhandlerscript, script) FROM stdin;
\.


--
-- Data for Name: jobfusion; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobfusion (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots, frameend, framestart, framelist, allframesassingletask, outputcount) FROM stdin;
\.


--
-- Data for Name: jobfusionvideomaker; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobfusionvideomaker (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots, codec, inputframepath, sequenceframestart, sequenceframeend, allframesassingletask, framelist, outputcount) FROM stdin;
\.


--
-- Data for Name: jobhistory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobhistory (keyjobhistory, fkeyjobhistorytype, fkeyjob, fkeyhost, fkeyuser, message, created) FROM stdin;
\.


--
-- Data for Name: jobhistorytype; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobhistorytype (keyjobhistorytype, type) FROM stdin;
\.


--
-- Data for Name: jobhoudinisim10; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobhoudinisim10 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots, slices, tracker, framestart, frameend, nodename) FROM stdin;
\.


--
-- Data for Name: jobmantra100; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobmantra100 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots, keyjobmantra100, forceraytrace, geocachesize, height, qualityflag, renderquality, threads, width) FROM stdin;
\.


--
-- Data for Name: jobmantra95; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobmantra95 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots, keyjobmantra95, forceraytrace, geocachesize, height, qualityflag, renderquality, threads, width) FROM stdin;
\.


--
-- Data for Name: jobmax; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobmax (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots, camera, elementfile, fileoriginal, flag_h, flag_v, flag_w, flag_x2, flag_xa, flag_xc, flag_xd, flag_xe, flag_xf, flag_xh, flag_xk, flag_xn, flag_xo, flag_xp, flag_xv, frameend, framelist, framestart, exrattributes, exrchannels, exrsavebitdepth, startupscript) FROM stdin;
\.


--
-- Data for Name: jobmax10; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobmax10 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots, camera, elementfile, fileoriginal, flag_h, flag_v, flag_w, flag_x2, flag_xa, flag_xc, flag_xd, flag_xe, flag_xf, flag_xh, flag_xk, flag_xn, flag_xo, flag_xp, flag_xv, frameend, framelist, framestart, exrattributes, exrchannels, exrsavebitdepth, startupscript) FROM stdin;
\.


--
-- Data for Name: jobmax2009; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobmax2009 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots, camera, elementfile, fileoriginal, flag_h, flag_v, flag_w, flag_x2, flag_xa, flag_xc, flag_xd, flag_xe, flag_xf, flag_xh, flag_xk, flag_xn, flag_xo, flag_xp, flag_xv, frameend, framelist, framestart, exrattributes, exrchannels, exrsavebitdepth, startupscript) FROM stdin;
\.


--
-- Data for Name: jobmax5; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobmax5 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots, camera, fileoriginal, flag_h, framestart, frameend, flag_w, flag_xv, flag_x2, flag_xa, flag_xe, flag_xk, flag_xd, flag_xh, flag_xo, flag_xf, flag_xn, flag_xp, flag_xc, flag_v, elementfile, framelist) FROM stdin;
\.


--
-- Data for Name: jobmax6; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobmax6 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots, camera, elementfile, fileoriginal, flag_h, flag_v, flag_w, flag_x2, flag_xa, flag_xc, flag_xd, flag_xe, flag_xf, flag_xh, flag_xk, flag_xn, flag_xo, flag_xp, flag_xv, frameend, framelist, framestart) FROM stdin;
\.


--
-- Data for Name: jobmax7; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobmax7 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots, camera, elementfile, fileoriginal, flag_h, flag_v, flag_w, flag_x2, flag_xa, flag_xc, flag_xd, flag_xe, flag_xf, flag_xh, flag_xk, flag_xn, flag_xo, flag_xp, flag_xv, frameend, framelist, framestart, exrattributes, exrchannels, exrsavebitdepth, startupscript) FROM stdin;
\.


--
-- Data for Name: jobmax8; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobmax8 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots, camera, elementfile, fileoriginal, flag_h, flag_v, flag_w, flag_x2, flag_xa, flag_xc, flag_xd, flag_xe, flag_xf, flag_xh, flag_xk, flag_xn, flag_xo, flag_xp, flag_xv, frameend, framelist, framestart, exrattributes, exrchannels, exrsavebitdepth, startupscript) FROM stdin;
\.


--
-- Data for Name: jobmax9; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobmax9 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots, camera, elementfile, fileoriginal, flag_h, flag_v, flag_w, flag_x2, flag_xa, flag_xc, flag_xd, flag_xe, flag_xf, flag_xh, flag_xk, flag_xn, flag_xo, flag_xp, flag_xv, frameend, framelist, framestart, exrattributes, exrchannels, exrsavebitdepth, startupscript) FROM stdin;
\.


--
-- Data for Name: jobmaxscript; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobmaxscript (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots, script, maxtime, outputfiles, filelist, silent, maxversion, runmax64) FROM stdin;
\.


--
-- Data for Name: jobmaya; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobmaya (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots, framestart, frameend, camera, renderer, projectpath, width, height, append) FROM stdin;
\.


--
-- Data for Name: jobmaya2008; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobmaya2008 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots, framestart, frameend, camera, renderer, projectpath, width, height, append) FROM stdin;
\.


--
-- Data for Name: jobmaya2009; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobmaya2009 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots, framestart, frameend, camera, renderer, projectpath, width, height, append) FROM stdin;
\.


--
-- Data for Name: jobmaya7; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobmaya7 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots, framestart, frameend, camera, renderer, projectpath, width, height, append) FROM stdin;
\.


--
-- Data for Name: jobmaya8; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobmaya8 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots, framestart, frameend, camera, renderer, projectpath, width, height, append) FROM stdin;
\.


--
-- Data for Name: jobmaya85; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobmaya85 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots, framestart, frameend, camera, renderer, projectpath, width, height, append) FROM stdin;
\.


--
-- Data for Name: jobmentalray7; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobmentalray7 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots, framestart, frameend, camera, renderer, projectpath, width, height, append) FROM stdin;
\.


--
-- Data for Name: jobmentalray8; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobmentalray8 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots, framestart, frameend, camera, renderer, projectpath, width, height, append) FROM stdin;
\.


--
-- Data for Name: jobmentalray85; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobmentalray85 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots, framestart, frameend, camera, renderer, projectpath, width, height, append) FROM stdin;
\.


--
-- Data for Name: jobnuke51; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobnuke51 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots, framestart, frameend, outputcount) FROM stdin;
\.


--
-- Data for Name: jobnuke52; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobnuke52 (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots, framestart, frameend, outputcount) FROM stdin;
\.


--
-- Data for Name: joboutput; Type: TABLE DATA; Schema: public; Owner: -
--

COPY joboutput (keyjoboutput, fkeyjob, name, fkeyfiletracker) FROM stdin;
\.


--
-- Data for Name: jobrealflow; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobrealflow (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots, keyjobrealflow, framestart, frameend, simtype, threads) FROM stdin;
\.


--
-- Data for Name: jobrenderman; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobrenderman (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots, framestart, frameend, version) FROM stdin;
\.


--
-- Data for Name: jobribgen; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobribgen (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots, framestart, frameend, version) FROM stdin;
\.


--
-- Data for Name: jobservice; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobservice (keyjobservice, fkeyjob, fkeyservice) FROM stdin;
\.


--
-- Data for Name: jobshake; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobshake (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots, framestart, frameend, codec, slatepath, framerange) FROM stdin;
\.


--
-- Data for Name: jobspool; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobspool (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots, flowfile, flowpath, holdend, inputfile, inputpath, outputfile, inputstart, inputend, holdstart, importmode, keepinqueue, lastscanned, jobpath) FROM stdin;
\.


--
-- Data for Name: jobstat; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobstat (keyjobstat, fkeyelement, fkeyproject, fkeyusr, pass, taskcount, taskscompleted, tasktime, started, ended, name, errorcount, mintasktime, maxtasktime, avgtasktime, totaltasktime, minerrortime, maxerrortime, avgerrortime, totalerrortime, mincopytime, maxcopytime, avgcopytime, totalcopytime, copycount, minloadtime, maxloadtime, avgloadtime, totalloadtime, loadcount, submitted, totalcputime, mincputime, maxcputime, avgcputime, minmemory, maxmemory, avgmemory, minefficiency, maxefficiency, avgefficiency, totalbytesread, minbytesread, maxbytesread, avgbytesread, totalopsread, minopsread, maxopsread, avgopsread, totalbyteswrite, minbyteswrite, maxbyteswrite, avgbyteswrite, totalopswrite, minopswrite, maxopswrite, avgopswrite, totaliowait, miniowait, maxiowait, avgiowait) FROM stdin;
\.


--
-- Data for Name: jobstatus; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobstatus (keyjobstatus, hostsonjob, fkeyjob, tasksunassigned, taskscount, tasksdone, taskscancelled, taskssuspended, tasksassigned, tasksbusy, tasksaveragetime, health, joblastupdated, errorcount, lastnotifiederrorcount, averagememory) FROM stdin;
\.


--
-- Data for Name: jobsync; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobsync (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots, direction, append, filesfrom) FROM stdin;
\.


--
-- Data for Name: jobsystem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobsystem (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots) FROM stdin;
\.


--
-- Data for Name: jobtask; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobtask (keyjobtask, ended, fkeyhost, fkeyjob, status, jobtask, label, fkeyjoboutput, progress, fkeyjobtaskassignment) FROM stdin;
\.


--
-- Data for Name: jobtaskassignment; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobtaskassignment (keyjobtaskassignment, fkeyjobassignment, memory, started, ended, fkeyjobassignmentstatus, fkeyjobtask, fkeyjoberror) FROM stdin;
\.


--
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
-- Data for Name: jobtypemapping; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobtypemapping (keyjobtypemapping, fkeyjobtype, fkeymapping) FROM stdin;
\.


--
-- Data for Name: jobxsi; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobxsi (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots, framestart, frameend, framelist, pass, flag_w, flag_h, deformmotionblur, motionblur, renderer, resolutionx, resolutiony) FROM stdin;
\.


--
-- Data for Name: jobxsiscript; Type: TABLE DATA; Schema: public; Owner: -
--

COPY jobxsiscript (keyjob, fkeyelement, fkeyhost, fkeyjobtype, fkeyproject, fkeyusr, hostlist, job, jobtime, outputpath, status, submitted, started, ended, expires, deleteoncomplete, hostsonjob, taskscount, tasksunassigned, tasksdone, tasksaveragetime, priority, errorcount, queueorder, packettype, packetsize, queueeta, notifyonerror, notifyoncomplete, maxtasktime, cleaned, filesize, btinfohash, rendertime, abversion, deplist, args, filename, filemd5sum, fkeyjobstat, username, domain, password, stats, currentmapserverweight, loadtimeaverage, tasksassigned, tasksbusy, prioritizeoutertasks, outertasksassigned, lastnotifiederrorcount, taskscancelled, taskssuspended, health, maxloadtime, license, maxmemory, fkeyjobparent, endedts, startedts, submittedts, maxhosts, personalpriority, loggingenabled, environment, runassubmitter, checkfilemd5, uploadedfile, framenth, framenthmode, exclusiveassignment, hastaskprogress, minmemory, scenename, shotname, slots, framestart, frameend, scriptrequiresui, scriptfile, xsifile, scriptmethod, framelist) FROM stdin;
\.


--
-- Data for Name: license; Type: TABLE DATA; Schema: public; Owner: -
--

COPY license (keylicense, license, fkeyhost, fkeysoftware, total, available, reserved, inuse) FROM stdin;
15	fah	\N	\N	8	8	\N	\N
16	nuke_r	\N	\N	12	12	0	0
18	vue	\N	\N	13	3	0	0
19	ocula	\N	\N	5	5	0	0
14	hbatch	\N	\N	6	6	0	0
17	3delight	\N	\N	128	37	10	0
\.


--
-- Data for Name: location; Type: TABLE DATA; Schema: public; Owner: -
--

COPY location (keylocation, name) FROM stdin;
1	SMO
2	VCO
3	BrianHarding
\.


--
-- Data for Name: mapping; Type: TABLE DATA; Schema: public; Owner: -
--

COPY mapping (keymapping, fkeyhost, share, mount, fkeymappingtype, description) FROM stdin;
\.


--
-- Data for Name: mappingtype; Type: TABLE DATA; Schema: public; Owner: -
--

COPY mappingtype (keymappingtype, name) FROM stdin;
\.


--
-- Data for Name: methodperms; Type: TABLE DATA; Schema: public; Owner: -
--

COPY methodperms (keymethodperms, method, users, groups, fkeyproject) FROM stdin;
\.


--
-- Data for Name: notification; Type: TABLE DATA; Schema: public; Owner: -
--

COPY notification (keynotification, created, subject, message, component, event, routed, fkeyelement) FROM stdin;
\.


--
-- Data for Name: notificationdestination; Type: TABLE DATA; Schema: public; Owner: -
--

COPY notificationdestination (keynotificationdestination, fkeynotification, fkeynotificationmethod, delivered, destination, fkeyuser, routed) FROM stdin;
\.


--
-- Data for Name: notificationmethod; Type: TABLE DATA; Schema: public; Owner: -
--

COPY notificationmethod (keynotificationmethod, name) FROM stdin;
\.


--
-- Data for Name: notificationroute; Type: TABLE DATA; Schema: public; Owner: -
--

COPY notificationroute (keynotificationuserroute, eventmatch, componentmatch, fkeyuser, subjectmatch, messagematch, actions, priority, fkeyelement, routeassetdescendants) FROM stdin;
\.


--
-- Data for Name: notify; Type: TABLE DATA; Schema: public; Owner: -
--

COPY notify (keynotify, notify, fkeyusr, fkeysyslogrealm, severitymask, starttime, endtime, threshhold, notifyclass, notifymethod, fkeynotifymethod, threshold) FROM stdin;
\.


--
-- Data for Name: notifymethod; Type: TABLE DATA; Schema: public; Owner: -
--

COPY notifymethod (keynotifymethod, notifymethod) FROM stdin;
\.


--
-- Data for Name: notifysent; Type: TABLE DATA; Schema: public; Owner: -
--

COPY notifysent (keynotifysent, fkeynotify, fkeysyslog) FROM stdin;
\.


--
-- Data for Name: notifywho; Type: TABLE DATA; Schema: public; Owner: -
--

COPY notifywho (keynotifywho, class, fkeynotify, fkeyusr, fkey) FROM stdin;
\.


--
-- Data for Name: package; Type: TABLE DATA; Schema: public; Owner: -
--

COPY package (keypackage, version, fkeystatus) FROM stdin;
\.


--
-- Data for Name: packageoutput; Type: TABLE DATA; Schema: public; Owner: -
--

COPY packageoutput (keypackageoutput, fkeyasset) FROM stdin;
\.


--
-- Data for Name: pathsynctarget; Type: TABLE DATA; Schema: public; Owner: -
--

COPY pathsynctarget (keypathsynctarget, fkeypathtracker, fkeyprojectstorage) FROM stdin;
\.


--
-- Data for Name: pathtemplate; Type: TABLE DATA; Schema: public; Owner: -
--

COPY pathtemplate (keypathtemplate, name, pathtemplate, pathre, filenametemplate, filenamere, version, pythoncode) FROM stdin;
\.


--
-- Data for Name: pathtracker; Type: TABLE DATA; Schema: public; Owner: -
--

COPY pathtracker (keypathtracker, fkeyelement, path, fkeypathtemplate, fkeyprojectstorage, storagename) FROM stdin;
\.


--
-- Data for Name: permission; Type: TABLE DATA; Schema: public; Owner: -
--

COPY permission (keypermission, methodpattern, fkeyusr, permission, fkeygrp, class) FROM stdin;
1	\N	2	2777	\N	Blur::
2	\N	122	0777	2	Blur::
\.


--
-- Data for Name: phoneno; Type: TABLE DATA; Schema: public; Owner: -
--

COPY phoneno (keyphoneno, phoneno, fkeyphonetype, fkeyemployee, domain) FROM stdin;
\.


--
-- Data for Name: phonetype; Type: TABLE DATA; Schema: public; Owner: -
--

COPY phonetype (keyphonetype, phonetype) FROM stdin;
\.


--
-- Data for Name: project; Type: TABLE DATA; Schema: public; Owner: -
--

COPY project (keyelement, daysbid, description, fkeyelement, fkeyelementstatus, fkeyelementtype, fkeyproject, fkeythumbnail, name, daysscheduled, daysestimated, status, filepath, fkeyassettype, fkeypathtemplate, fkeystatusset, allowtime, datestart, datecomplete, fkeyassettemplate, icon, compoutputdrive, datedue, filetype, fkeyclient, notes, renderoutputdrive, script, shortname, wipdrive, projectnumber, frames, nda, dayrate, usefilecreation, dailydrive, lastscanned, fkeyprojectstatus, assburnerweight, project, fps, resolution, resolutionwidth, resolutionheight, archived, deliverymedium, renderpixelaspect) FROM stdin;
\.


--
-- Data for Name: projectresolution; Type: TABLE DATA; Schema: public; Owner: -
--

COPY projectresolution (keyprojectresolution, deliveryformat, fkeyproject, height, outputformat, projectresolution, width, pixelaspect, fps) FROM stdin;
\.


--
-- Data for Name: projectstatus; Type: TABLE DATA; Schema: public; Owner: -
--

COPY projectstatus (keyprojectstatus, projectstatus, chronology) FROM stdin;
1	New	10
2	Production	20
3	Post-Production	30
4	Completed	40
\.


--
-- Data for Name: projectstorage; Type: TABLE DATA; Schema: public; Owner: -
--

COPY projectstorage (keyprojectstorage, fkeyproject, name, location, storagename, "default", fkeyhost) FROM stdin;
\.


--
-- Data for Name: projecttempo; Type: TABLE DATA; Schema: public; Owner: -
--

COPY projecttempo (fkeyproject, tempo) FROM stdin;
\N	0.001
\.


--
-- Data for Name: queueorder; Type: TABLE DATA; Schema: public; Owner: -
--

COPY queueorder (queueorder, fkeyjob) FROM stdin;
\.


--
-- Data for Name: rangefiletracker; Type: TABLE DATA; Schema: public; Owner: -
--

COPY rangefiletracker (keyfiletracker, fkeyelement, name, path, filename, fkeypathtemplate, fkeyprojectstorage, storagename, filenametemplate, framestart, frameend, fkeyresolution, renderelement) FROM stdin;
\.


--
-- Data for Name: renderframe; Type: TABLE DATA; Schema: public; Owner: -
--

COPY renderframe (keyrenderframe, fkeyshot, frame, fkeyresolution, status) FROM stdin;
\.


--
-- Data for Name: schedule; Type: TABLE DATA; Schema: public; Owner: -
--

COPY schedule (keyschedule, fkeyuser, date, starthour, hours, fkeyelement, fkeyassettype, fkeycreatedbyuser, duration, starttime) FROM stdin;
\.


--
-- Data for Name: serverfileaction; Type: TABLE DATA; Schema: public; Owner: -
--

COPY serverfileaction (keyserverfileaction, fkeyserverfileactionstatus, fkeyserverfileactiontype, fkeyhost, destpath, errormessage, sourcepath) FROM stdin;
\.


--
-- Data for Name: serverfileactionstatus; Type: TABLE DATA; Schema: public; Owner: -
--

COPY serverfileactionstatus (keyserverfileactionstatus, status, name) FROM stdin;
\.


--
-- Data for Name: serverfileactiontype; Type: TABLE DATA; Schema: public; Owner: -
--

COPY serverfileactiontype (keyserverfileactiontype, type) FROM stdin;
\.


--
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
41	AB_manager	\N	\N	\N	\N	\N	\N	\N
36	3Delight	\N	17	t	\N	t	\N	\N
40	cputest	\N	\N	t	\N	t	\N	\N
42	grind	\N	\N	t	\N	\N	\N	\N
43	Vue	\N	18	t	\N	t	\N	\N
44	ocula	\N	19	t	\N	t	\N	\N
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY sessions (id, length, a_session, "time") FROM stdin;
\.


--
-- Data for Name: shot; Type: TABLE DATA; Schema: public; Owner: -
--

COPY shot (keyelement, daysbid, description, fkeyelement, fkeyelementstatus, fkeyelementtype, fkeyproject, fkeythumbnail, name, daysscheduled, daysestimated, status, filepath, fkeyassettype, fkeypathtemplate, fkeystatusset, allowtime, datestart, datecomplete, fkeyassettemplate, icon, dialog, frameend, framestart, shot, framestartedl, frameendedl, camerainfo, scriptpage) FROM stdin;
\.


--
-- Data for Name: shotgroup; Type: TABLE DATA; Schema: public; Owner: -
--

COPY shotgroup (keyelement, daysbid, description, fkeyelement, fkeyelementstatus, fkeyelementtype, fkeyproject, fkeythumbnail, name, daysscheduled, daysestimated, status, filepath, fkeyassettype, fkeypathtemplate, fkeystatusset, allowtime, datestart, datecomplete, fkeyassettemplate, icon, shotgroup) FROM stdin;
\.


--
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
-- Data for Name: status; Type: TABLE DATA; Schema: public; Owner: -
--

COPY status (keystatus, name) FROM stdin;
\.


--
-- Data for Name: statusset; Type: TABLE DATA; Schema: public; Owner: -
--

COPY statusset (keystatusset, name) FROM stdin;
\.


--
-- Data for Name: syslog; Type: TABLE DATA; Schema: public; Owner: -
--

COPY syslog (keysyslog, fkeyhost, fkeysyslogrealm, fkeysyslogseverity, message, count, lastoccurrence, created, class, method, ack, firstoccurence, hostname, username) FROM stdin;
\.


--
-- Data for Name: syslogrealm; Type: TABLE DATA; Schema: public; Owner: -
--

COPY syslogrealm (keysyslogrealm, syslogrealm) FROM stdin;
1	Servers
2	Slaves
3	Security
4	System
5	Network
6	Rodin
\.


--
-- Data for Name: syslogseverity; Type: TABLE DATA; Schema: public; Owner: -
--

COPY syslogseverity (keysyslogseverity, syslogseverity, severity) FROM stdin;
1	Warning	Warning
2	Minor	Minor
3	Major	Major
4	Critical	Critical
\.


--
-- Data for Name: task; Type: TABLE DATA; Schema: public; Owner: -
--

COPY task (keyelement, daysbid, description, fkeyelement, fkeyelementstatus, fkeyelementtype, fkeyproject, fkeythumbnail, name, daysscheduled, daysestimated, status, filepath, fkeyassettype, fkeypathtemplate, fkeystatusset, allowtime, datestart, datecomplete, fkeyassettemplate, icon, fkeytasktype, shotgroup) FROM stdin;
\.


--
-- Data for Name: tasktype; Type: TABLE DATA; Schema: public; Owner: -
--

COPY tasktype (keytasktype, tasktype, iconcolor) FROM stdin;
\.


--
-- Data for Name: taskuser; Type: TABLE DATA; Schema: public; Owner: -
--

COPY taskuser (keytaskuser, fkeytask, fkeyuser, active) FROM stdin;
\.


--
-- Data for Name: thread; Type: TABLE DATA; Schema: public; Owner: -
--

COPY thread (keythread, thread, topic, tablename, fkey, datetime, fkeyauthor, skeyreply, fkeyusr, fkeythreadcategory) FROM stdin;
\.


--
-- Data for Name: threadcategory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY threadcategory (keythreadcategory, threadcategory) FROM stdin;
\.


--
-- Data for Name: threadnotify; Type: TABLE DATA; Schema: public; Owner: -
--

COPY threadnotify (keythreadnotify, fkeythread, fkeyuser, options) FROM stdin;
\.


--
-- Data for Name: thumbnail; Type: TABLE DATA; Schema: public; Owner: -
--

COPY thumbnail (keythumbnail, cliprect, date, fkeyelement, fkeyuser, originalfile, image) FROM stdin;
\.


--
-- Data for Name: timesheet; Type: TABLE DATA; Schema: public; Owner: -
--

COPY timesheet (keytimesheet, datetime, fkeyelement, fkeyemployee, fkeyproject, fkeytimesheetcategory, scheduledhour, datetimesubmitted, unscheduledhour, comment) FROM stdin;
\.


--
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
-- Data for Name: tracker; Type: TABLE DATA; Schema: public; Owner: -
--

COPY tracker (keytracker, tracker, fkeysubmitter, fkeyassigned, fkeycategory, fkeyseverity, fkeystatus, datetarget, datechanged, datesubmitted, description, timeestimate, fkeytrackerqueue) FROM stdin;
\.


--
-- Data for Name: trackercategory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY trackercategory (keytrackercategory, trackercategory) FROM stdin;
\.


--
-- Data for Name: trackerlog; Type: TABLE DATA; Schema: public; Owner: -
--

COPY trackerlog (keytrackerlog, fkeytracker, fkeyusr, datelogged, message) FROM stdin;
\.


--
-- Data for Name: trackerqueue; Type: TABLE DATA; Schema: public; Owner: -
--

COPY trackerqueue (keytrackerqueue, trackerqueue) FROM stdin;
\.


--
-- Data for Name: trackerseverity; Type: TABLE DATA; Schema: public; Owner: -
--

COPY trackerseverity (keytrackerseverity, trackerseverity) FROM stdin;
\.


--
-- Data for Name: trackerstatus; Type: TABLE DATA; Schema: public; Owner: -
--

COPY trackerstatus (keytrackerstatus, trackerstatus) FROM stdin;
\.


--
-- Data for Name: userelement; Type: TABLE DATA; Schema: public; Owner: -
--

COPY userelement (keyuserelement, fkeyelement, fkeyusr, fkeyuser) FROM stdin;
\.


--
-- Data for Name: usermapping; Type: TABLE DATA; Schema: public; Owner: -
--

COPY usermapping (keyusermapping, fkeyusr, fkeymapping) FROM stdin;
\.


--
-- Data for Name: userrole; Type: TABLE DATA; Schema: public; Owner: -
--

COPY userrole (keyuserrole, fkeytasktype, fkeyusr) FROM stdin;
1	14	2
2	10	122
3	57	122
\.


--
-- Data for Name: usr; Type: TABLE DATA; Schema: public; Owner: -
--

COPY usr (keyelement, daysbid, description, fkeyelement, fkeyelementstatus, fkeyelementtype, fkeyproject, fkeythumbnail, name, daysscheduled, daysestimated, status, filepath, fkeyassettype, fkeypathtemplate, fkeystatusset, allowtime, datestart, datecomplete, fkeyassettemplate, icon, dateoflastlogon, email, fkeyhost, gpgkey, jid, pager, password, remoteips, schedule, shell, uid, threadnotifybyjabber, threadnotifybyemail, fkeyclient, intranet, homedir, disabled, gid, usr, keyusr, rolemask, usrlevel, remoteok, requestcount, sessiontimeout, logoncount, useradded, oldkeyusr, sid, lastlogontype) FROM stdin;
\.


--
-- Data for Name: usrgrp; Type: TABLE DATA; Schema: public; Owner: -
--

COPY usrgrp (keyusrgrp, fkeyusr, fkeygrp, usrgrp) FROM stdin;
1	2	1	\N
2	2	2	\N
3	122	1	\N
\.


--
-- Data for Name: version; Type: TABLE DATA; Schema: public; Owner: -
--

COPY version (keyversion) FROM stdin;
\.


--
-- Data for Name: versionfiletracker; Type: TABLE DATA; Schema: public; Owner: -
--

COPY versionfiletracker (keyfiletracker, fkeyelement, name, path, filename, fkeypathtemplate, fkeyprojectstorage, storagename, filenametemplate, fkeyversionfiletracker, oldfilenames, version, iteration, automaster) FROM stdin;
\.


--
-- Name: abdownloadstat_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY abdownloadstat
    ADD CONSTRAINT abdownloadstat_pkey PRIMARY KEY (keyabdownloadstat);


--
-- Name: annotation_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY annotation
    ADD CONSTRAINT annotation_pkey PRIMARY KEY (keyannotation);


--
-- Name: assetdep_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assetdep
    ADD CONSTRAINT assetdep_pkey PRIMARY KEY (keyassetdep);


--
-- Name: assetprop_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assetprop
    ADD CONSTRAINT assetprop_pkey PRIMARY KEY (keyassetprop);


--
-- Name: assetproperty_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assetproperty
    ADD CONSTRAINT assetproperty_pkey PRIMARY KEY (keyassetproperty);


--
-- Name: assetproptype_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assetproptype
    ADD CONSTRAINT assetproptype_pkey PRIMARY KEY (keyassetproptype);


--
-- Name: assetset_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assetset
    ADD CONSTRAINT assetset_pkey PRIMARY KEY (keyassetset);


--
-- Name: assetsetitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assetsetitem
    ADD CONSTRAINT assetsetitem_pkey PRIMARY KEY (keyassetsetitem);


--
-- Name: assettemplate_fkeyproject_fkeyassettype_name_unique; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assettemplate
    ADD CONSTRAINT assettemplate_fkeyproject_fkeyassettype_name_unique UNIQUE (fkeyproject, fkeyassettype, name);


--
-- Name: assettemplate_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assettemplate
    ADD CONSTRAINT assettemplate_pkey PRIMARY KEY (keyassettemplate);


--
-- Name: assettype_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assettype
    ADD CONSTRAINT assettype_pkey PRIMARY KEY (keyassettype);


--
-- Name: attachment_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY attachment
    ADD CONSTRAINT attachment_pkey PRIMARY KEY (keyattachment);


--
-- Name: attachmenttype_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY attachmenttype
    ADD CONSTRAINT attachmenttype_pkey PRIMARY KEY (keyattachmenttype);


--
-- Name: c_host_ip; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hostinterface
    ADD CONSTRAINT c_host_ip UNIQUE (fkeyhost, ip);


--
-- Name: calendar_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY calendar
    ADD CONSTRAINT calendar_pkey PRIMARY KEY (keycalendar);


--
-- Name: calendarcategory_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY calendarcategory
    ADD CONSTRAINT calendarcategory_pkey PRIMARY KEY (keycalendarcategory);


--
-- Name: checklistitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY checklistitem
    ADD CONSTRAINT checklistitem_pkey PRIMARY KEY (keychecklistitem);


--
-- Name: checkliststatus_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY checkliststatus
    ADD CONSTRAINT checkliststatus_pkey PRIMARY KEY (keycheckliststatus);


--
-- Name: client_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY client
    ADD CONSTRAINT client_pkey PRIMARY KEY (keyclient);


--
-- Name: config_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY config
    ADD CONSTRAINT config_pkey PRIMARY KEY (keyconfig);


--
-- Name: deliveryelement_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY deliveryelement
    ADD CONSTRAINT deliveryelement_pkey PRIMARY KEY (keydeliveryshot);


--
-- Name: demoreel_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY demoreel
    ADD CONSTRAINT demoreel_pkey PRIMARY KEY (keydemoreel);


--
-- Name: diskimage_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY diskimage
    ADD CONSTRAINT diskimage_pkey PRIMARY KEY (keydiskimage);


--
-- Name: dynamichostgroup_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY dynamichostgroup
    ADD CONSTRAINT dynamichostgroup_pkey PRIMARY KEY (keydynamichostgroup);


--
-- Name: element_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY element
    ADD CONSTRAINT element_pkey PRIMARY KEY (keyelement);


--
-- Name: elementdep_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY elementdep
    ADD CONSTRAINT elementdep_pkey PRIMARY KEY (keyelementdep);


--
-- Name: elementstatus_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY elementstatus
    ADD CONSTRAINT elementstatus_pkey PRIMARY KEY (keyelementstatus);


--
-- Name: elementthread_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY elementthread
    ADD CONSTRAINT elementthread_pkey PRIMARY KEY (keyelementthread);


--
-- Name: elementtype_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY elementtype
    ADD CONSTRAINT elementtype_pkey PRIMARY KEY (keyelementtype);


--
-- Name: elementtypetasktype_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY elementtypetasktype
    ADD CONSTRAINT elementtypetasktype_pkey PRIMARY KEY (keyelementtypetasktype);


--
-- Name: elementuser_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY elementuser
    ADD CONSTRAINT elementuser_pkey PRIMARY KEY (keyelementuser);


--
-- Name: eventalert_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY eventalert
    ADD CONSTRAINT eventalert_pkey PRIMARY KEY ("keyEventAlert");


--
-- Name: filetemplate_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY filetemplate
    ADD CONSTRAINT filetemplate_pkey PRIMARY KEY (keyfiletemplate);


--
-- Name: filetracker_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY filetracker
    ADD CONSTRAINT filetracker_pkey PRIMARY KEY (keyfiletracker);


--
-- Name: filetrackerdep_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY filetrackerdep
    ADD CONSTRAINT filetrackerdep_pkey PRIMARY KEY (keyfiletrackerdep);


--
-- Name: fileversion_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY fileversion
    ADD CONSTRAINT fileversion_pkey PRIMARY KEY (keyfileversion);


--
-- Name: folder_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY folder
    ADD CONSTRAINT folder_pkey PRIMARY KEY (keyfolder);


--
-- Name: graph_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY graph
    ADD CONSTRAINT graph_pkey PRIMARY KEY (keygraph);


--
-- Name: graphds_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY graphds
    ADD CONSTRAINT graphds_pkey PRIMARY KEY (keygraphds);


--
-- Name: graphpage_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY graphpage
    ADD CONSTRAINT graphpage_pkey PRIMARY KEY (keygraphpage);


--
-- Name: graphrel_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY graphrelationship
    ADD CONSTRAINT graphrel_pkey PRIMARY KEY (keygraphrelationship);


--
-- Name: gridtemplate_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY gridtemplate
    ADD CONSTRAINT gridtemplate_pkey PRIMARY KEY (keygridtemplate);


--
-- Name: gridtemplateitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY gridtemplateitem
    ADD CONSTRAINT gridtemplateitem_pkey PRIMARY KEY (keygridtemplateitem);


--
-- Name: groupmapping_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY groupmapping
    ADD CONSTRAINT groupmapping_pkey PRIMARY KEY (keygroupmapping);


--
-- Name: grp_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY grp
    ADD CONSTRAINT grp_pkey PRIMARY KEY (keygrp);


--
-- Name: gruntscript_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY gruntscript
    ADD CONSTRAINT gruntscript_pkey PRIMARY KEY (keygruntscript);


--
-- Name: history_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY history
    ADD CONSTRAINT history_pkey PRIMARY KEY (keyhistory);


--
-- Name: host_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY host
    ADD CONSTRAINT host_pkey PRIMARY KEY (keyhost);


--
-- Name: hostdailystat_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hostdailystat
    ADD CONSTRAINT hostdailystat_pkey PRIMARY KEY (keyhostdailystat);


--
-- Name: hostgroup_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hostgroup
    ADD CONSTRAINT hostgroup_pkey PRIMARY KEY (keyhostgroup);


--
-- Name: hostgroupitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hostgroupitem
    ADD CONSTRAINT hostgroupitem_pkey PRIMARY KEY (keyhostgroupitem);


--
-- Name: hosthistory_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hosthistory
    ADD CONSTRAINT hosthistory_pkey PRIMARY KEY (keyhosthistory);


--
-- Name: hostinterface_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hostinterface
    ADD CONSTRAINT hostinterface_pkey PRIMARY KEY (keyhostinterface);


--
-- Name: hostinterfacetype_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hostinterfacetype
    ADD CONSTRAINT hostinterfacetype_pkey PRIMARY KEY (keyhostinterfacetype);


--
-- Name: hostload_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hostload
    ADD CONSTRAINT hostload_pkey PRIMARY KEY (keyhostload);


--
-- Name: hostmapping_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hostmapping
    ADD CONSTRAINT hostmapping_pkey PRIMARY KEY (keyhostmapping);


--
-- Name: hostport_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hostport
    ADD CONSTRAINT hostport_pkey PRIMARY KEY (keyhostport);


--
-- Name: hostresource_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hostresource
    ADD CONSTRAINT hostresource_pkey PRIMARY KEY (keyhostresource);


--
-- Name: hostservice_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hostservice
    ADD CONSTRAINT hostservice_pkey PRIMARY KEY (keyhostservice);


--
-- Name: hostsoftware_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hostsoftware
    ADD CONSTRAINT hostsoftware_pkey PRIMARY KEY (keyhostsoftware);


--
-- Name: hoststatus_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hoststatus
    ADD CONSTRAINT hoststatus_pkey PRIMARY KEY (keyhoststatus);


--
-- Name: job_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY job
    ADD CONSTRAINT job_pkey PRIMARY KEY (keyjob);


--
-- Name: jobae_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobaftereffects
    ADD CONSTRAINT jobae_pkey PRIMARY KEY (keyjob);


--
-- Name: jobassignment_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobassignment
    ADD CONSTRAINT jobassignment_pkey PRIMARY KEY (keyjobassignment);


--
-- Name: jobassignmentstatus_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobassignmentstatus
    ADD CONSTRAINT jobassignmentstatus_pkey PRIMARY KEY (keyjobassignmentstatus);


--
-- Name: jobcannedbatch_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobcannedbatch
    ADD CONSTRAINT jobcannedbatch_pkey PRIMARY KEY (keyjobcannedbatch);


--
-- Name: jobcommandhistory_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobcommandhistory
    ADD CONSTRAINT jobcommandhistory_pkey PRIMARY KEY (keyjobcommandhistory);


--
-- Name: jobdep_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobdep
    ADD CONSTRAINT jobdep_pkey PRIMARY KEY (keyjobdep);


--
-- Name: joberror_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY joberror
    ADD CONSTRAINT joberror_pkey PRIMARY KEY (keyjoberror);


--
-- Name: joberrorhandler_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY joberrorhandler
    ADD CONSTRAINT joberrorhandler_pkey PRIMARY KEY (keyjoberrorhandler);


--
-- Name: joberrorhandlerscript_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY joberrorhandlerscript
    ADD CONSTRAINT joberrorhandlerscript_pkey PRIMARY KEY (keyjoberrorhandlerscript);


--
-- Name: jobhistory_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobhistory
    ADD CONSTRAINT jobhistory_pkey PRIMARY KEY (keyjobhistory);


--
-- Name: jobhistorytype_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobhistorytype
    ADD CONSTRAINT jobhistorytype_pkey PRIMARY KEY (keyjobhistorytype);


--
-- Name: jobmantra100_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobmantra100
    ADD CONSTRAINT jobmantra100_pkey PRIMARY KEY (keyjobmantra100);


--
-- Name: jobmantra95_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobmantra95
    ADD CONSTRAINT jobmantra95_pkey PRIMARY KEY (keyjobmantra95);


--
-- Name: jobmax5_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobmax5
    ADD CONSTRAINT jobmax5_pkey PRIMARY KEY (keyjob);


--
-- Name: jobmax8_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobmax8
    ADD CONSTRAINT jobmax8_pkey PRIMARY KEY (keyjob);


--
-- Name: joboutput_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY joboutput
    ADD CONSTRAINT joboutput_pkey PRIMARY KEY (keyjoboutput);


--
-- Name: jobrealflow_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobrealflow
    ADD CONSTRAINT jobrealflow_pkey PRIMARY KEY (keyjobrealflow);


--
-- Name: jobservice_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobservice
    ADD CONSTRAINT jobservice_pkey PRIMARY KEY (keyjobservice);


--
-- Name: jobshake_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobshake
    ADD CONSTRAINT jobshake_pkey PRIMARY KEY (keyjob);


--
-- Name: jobstat_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobstat
    ADD CONSTRAINT jobstat_pkey PRIMARY KEY (keyjobstat);


--
-- Name: jobstatus_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobstatus
    ADD CONSTRAINT jobstatus_pkey PRIMARY KEY (keyjobstatus);


--
-- Name: jobtask_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobtask
    ADD CONSTRAINT jobtask_pkey PRIMARY KEY (keyjobtask);


--
-- Name: jobtaskassignment_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobtaskassignment
    ADD CONSTRAINT jobtaskassignment_pkey PRIMARY KEY (keyjobtaskassignment);


--
-- Name: jobtype_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobtype
    ADD CONSTRAINT jobtype_pkey PRIMARY KEY (keyjobtype);


--
-- Name: jobtypemapping_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobtypemapping
    ADD CONSTRAINT jobtypemapping_pkey PRIMARY KEY (keyjobtypemapping);


--
-- Name: license_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY license
    ADD CONSTRAINT license_pkey PRIMARY KEY (keylicense);


--
-- Name: location_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY location
    ADD CONSTRAINT location_pkey PRIMARY KEY (keylocation);


--
-- Name: mapping_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY mapping
    ADD CONSTRAINT mapping_pkey PRIMARY KEY (keymapping);


--
-- Name: mappingtype_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY mappingtype
    ADD CONSTRAINT mappingtype_pkey PRIMARY KEY (keymappingtype);


--
-- Name: methodperms_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY methodperms
    ADD CONSTRAINT methodperms_pkey PRIMARY KEY (keymethodperms);


--
-- Name: notification_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (keynotification);


--
-- Name: notificationdestination_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notificationdestination
    ADD CONSTRAINT notificationdestination_pkey PRIMARY KEY (keynotificationdestination);


--
-- Name: notificationmethod_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notificationmethod
    ADD CONSTRAINT notificationmethod_pkey PRIMARY KEY (keynotificationmethod);


--
-- Name: notificationroute_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notificationroute
    ADD CONSTRAINT notificationroute_pkey PRIMARY KEY (keynotificationuserroute);


--
-- Name: notify_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notify
    ADD CONSTRAINT notify_pkey PRIMARY KEY (keynotify);


--
-- Name: notifymethod_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notifymethod
    ADD CONSTRAINT notifymethod_pkey PRIMARY KEY (keynotifymethod);


--
-- Name: notifysent_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notifysent
    ADD CONSTRAINT notifysent_pkey PRIMARY KEY (keynotifysent);


--
-- Name: notifywho_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notifywho
    ADD CONSTRAINT notifywho_pkey PRIMARY KEY (keynotifywho);


--
-- Name: package_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY package
    ADD CONSTRAINT package_pkey PRIMARY KEY (keypackage);


--
-- Name: packageoutput_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY packageoutput
    ADD CONSTRAINT packageoutput_pkey PRIMARY KEY (keypackageoutput);


--
-- Name: pathsynctarget_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pathsynctarget
    ADD CONSTRAINT pathsynctarget_pkey PRIMARY KEY (keypathsynctarget);


--
-- Name: pathtemplate_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pathtemplate
    ADD CONSTRAINT pathtemplate_pkey PRIMARY KEY (keypathtemplate);


--
-- Name: pathtracker_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pathtracker
    ADD CONSTRAINT pathtracker_pkey PRIMARY KEY (keypathtracker);


--
-- Name: permission_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY permission
    ADD CONSTRAINT permission_pkey PRIMARY KEY (keypermission);


--
-- Name: phoneno_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY phoneno
    ADD CONSTRAINT phoneno_pkey PRIMARY KEY (keyphoneno);


--
-- Name: phonetype_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY phonetype
    ADD CONSTRAINT phonetype_pkey PRIMARY KEY (keyphonetype);


--
-- Name: pkey_aftereffects7; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobaftereffects7
    ADD CONSTRAINT pkey_aftereffects7 PRIMARY KEY (keyjob);


--
-- Name: pkey_aftereffects8; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobaftereffects8
    ADD CONSTRAINT pkey_aftereffects8 PRIMARY KEY (keyjob);


--
-- Name: pkey_employee; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employee
    ADD CONSTRAINT pkey_employee PRIMARY KEY (keyelement);


--
-- Name: pkey_job_maya2008; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobmaya2008
    ADD CONSTRAINT pkey_job_maya2008 PRIMARY KEY (keyjob);


--
-- Name: pkey_job_maya2009; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobmaya2009
    ADD CONSTRAINT pkey_job_maya2009 PRIMARY KEY (keyjob);


--
-- Name: pkey_job_maya85; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobmaya85
    ADD CONSTRAINT pkey_job_maya85 PRIMARY KEY (keyjob);


--
-- Name: pkey_jobautodeskburn; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobautodeskburn
    ADD CONSTRAINT pkey_jobautodeskburn PRIMARY KEY (keyjob);


--
-- Name: pkey_jobbatch; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobbatch
    ADD CONSTRAINT pkey_jobbatch PRIMARY KEY (keyjob);


--
-- Name: pkey_jobmentalray85; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobmentalray85
    ADD CONSTRAINT pkey_jobmentalray85 PRIMARY KEY (keyjob);


--
-- Name: pkey_jobnuke51; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobnuke51
    ADD CONSTRAINT pkey_jobnuke51 PRIMARY KEY (keyjob);


--
-- Name: pkey_jobsync; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobsync
    ADD CONSTRAINT pkey_jobsync PRIMARY KEY (keyjob);


--
-- Name: pkey_shot; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY shot
    ADD CONSTRAINT pkey_shot PRIMARY KEY (keyelement);


--
-- Name: pkey_shotgroup; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY shotgroup
    ADD CONSTRAINT pkey_shotgroup PRIMARY KEY (keyelement);


--
-- Name: pkey_task; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY task
    ADD CONSTRAINT pkey_task PRIMARY KEY (keyelement);


--
-- Name: pkey_usr; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY usr
    ADD CONSTRAINT pkey_usr PRIMARY KEY (keyelement);


--
-- Name: project_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY project
    ADD CONSTRAINT project_pkey PRIMARY KEY (keyelement);


--
-- Name: projectresolution_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY projectresolution
    ADD CONSTRAINT projectresolution_pkey PRIMARY KEY (keyprojectresolution);


--
-- Name: projectstatus_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY projectstatus
    ADD CONSTRAINT projectstatus_pkey PRIMARY KEY (keyprojectstatus);


--
-- Name: projectstorage_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY projectstorage
    ADD CONSTRAINT projectstorage_pkey PRIMARY KEY (keyprojectstorage);


--
-- Name: renderframe_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY renderframe
    ADD CONSTRAINT renderframe_pkey PRIMARY KEY (keyrenderframe);


--
-- Name: schedule_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY schedule
    ADD CONSTRAINT schedule_pkey PRIMARY KEY (keyschedule);


--
-- Name: serverfileaction_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY serverfileaction
    ADD CONSTRAINT serverfileaction_pkey PRIMARY KEY (keyserverfileaction);


--
-- Name: serverfileactionstatus_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY serverfileactionstatus
    ADD CONSTRAINT serverfileactionstatus_pkey PRIMARY KEY (keyserverfileactionstatus);


--
-- Name: serverfileactiontype_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY serverfileactiontype
    ADD CONSTRAINT serverfileactiontype_pkey PRIMARY KEY (keyserverfileactiontype);


--
-- Name: service_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY service
    ADD CONSTRAINT service_pkey PRIMARY KEY (keyservice);


--
-- Name: software_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY software
    ADD CONSTRAINT software_pkey PRIMARY KEY (keysoftware);


--
-- Name: status_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY status
    ADD CONSTRAINT status_pkey PRIMARY KEY (keystatus);


--
-- Name: statusset_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY statusset
    ADD CONSTRAINT statusset_pkey PRIMARY KEY (keystatusset);


--
-- Name: syslog_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY syslog
    ADD CONSTRAINT syslog_pkey PRIMARY KEY (keysyslog);


--
-- Name: syslogrealm_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY syslogrealm
    ADD CONSTRAINT syslogrealm_pkey PRIMARY KEY (keysyslogrealm);


--
-- Name: syslogseverity_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY syslogseverity
    ADD CONSTRAINT syslogseverity_pkey PRIMARY KEY (keysyslogseverity);


--
-- Name: tasktype_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tasktype
    ADD CONSTRAINT tasktype_pkey PRIMARY KEY (keytasktype);


--
-- Name: taskuser_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY taskuser
    ADD CONSTRAINT taskuser_pkey PRIMARY KEY (keytaskuser);


--
-- Name: thread_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY thread
    ADD CONSTRAINT thread_pkey PRIMARY KEY (keythread);


--
-- Name: threadcategory_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY threadcategory
    ADD CONSTRAINT threadcategory_pkey PRIMARY KEY (keythreadcategory);


--
-- Name: threadnotify_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY threadnotify
    ADD CONSTRAINT threadnotify_pkey PRIMARY KEY (keythreadnotify);


--
-- Name: thumbnail_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY thumbnail
    ADD CONSTRAINT thumbnail_pkey PRIMARY KEY (keythumbnail);


--
-- Name: timesheet_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY timesheet
    ADD CONSTRAINT timesheet_pkey PRIMARY KEY (keytimesheet);


--
-- Name: timesheetcategory_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY timesheetcategory
    ADD CONSTRAINT timesheetcategory_pkey PRIMARY KEY (keytimesheetcategory);


--
-- Name: tracker_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tracker
    ADD CONSTRAINT tracker_pkey PRIMARY KEY (keytracker);


--
-- Name: trackercategory_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY trackercategory
    ADD CONSTRAINT trackercategory_pkey PRIMARY KEY (keytrackercategory);


--
-- Name: trackerlog_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY trackerlog
    ADD CONSTRAINT trackerlog_pkey PRIMARY KEY (keytrackerlog);


--
-- Name: trackerqueue_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY trackerqueue
    ADD CONSTRAINT trackerqueue_pkey PRIMARY KEY (keytrackerqueue);


--
-- Name: trackerseverity_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY trackerseverity
    ADD CONSTRAINT trackerseverity_pkey PRIMARY KEY (keytrackerseverity);


--
-- Name: trackerstatus_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY trackerstatus
    ADD CONSTRAINT trackerstatus_pkey PRIMARY KEY (keytrackerstatus);


--
-- Name: userelement_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY userelement
    ADD CONSTRAINT userelement_pkey PRIMARY KEY (keyuserelement);


--
-- Name: usermapping_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY usermapping
    ADD CONSTRAINT usermapping_pkey PRIMARY KEY (keyusermapping);


--
-- Name: userrole_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY userrole
    ADD CONSTRAINT userrole_pkey PRIMARY KEY (keyuserrole);


--
-- Name: usrgrp_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY usrgrp
    ADD CONSTRAINT usrgrp_pkey PRIMARY KEY (keyusrgrp);


--
-- Name: version_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY version
    ADD CONSTRAINT version_pkey PRIMARY KEY (keyversion);


--
-- Name: x_hostservice_fkeyhost_fkeyservice; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hostservice
    ADD CONSTRAINT x_hostservice_fkeyhost_fkeyservice UNIQUE (fkeyhost, fkeyservice);


--
-- Name: fki_fkey_dep; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_fkey_dep ON jobdep USING btree (fkeydep);


--
-- Name: fki_fkey_elementuser_element; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_fkey_elementuser_element ON elementuser USING btree (fkeyelement);


--
-- Name: fki_fkey_elementuser_user; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_fkey_elementuser_user ON elementuser USING btree (fkeyuser);


--
-- Name: fki_fkey_hgi_hg; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_fkey_hgi_hg ON hostgroupitem USING btree (fkeyhostgroup);


--
-- Name: fki_fkey_hgi_host; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_fkey_hgi_host ON hostgroupitem USING btree (fkeyhost);


--
-- Name: fki_fkey_host; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_fkey_host ON jobcommandhistory USING btree (fkeyhost);


--
-- Name: fki_fkey_job; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_fkey_job ON jobdep USING btree (fkeyjob);


--
-- Name: fki_joboutput_fkey_job; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_joboutput_fkey_job ON joboutput USING btree (fkeyjob);


--
-- Name: fki_jobtask_fkey_host; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_jobtask_fkey_host ON jobtask USING btree (fkeyhost);


--
-- Name: fki_jobtask_fkey_job; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_jobtask_fkey_job ON jobtask USING btree (fkeyjob);


--
-- Name: x_annotation_sequence; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_annotation_sequence ON annotation USING btree (sequence);


--
-- Name: x_config_config; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_config_config ON config USING btree (config);


--
-- Name: x_filetracker_fkeyelement; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_filetracker_fkeyelement ON filetracker USING btree (fkeyelement);


--
-- Name: x_filetracker_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_filetracker_name ON filetracker USING btree (name);


--
-- Name: x_filetracker_path; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_filetracker_path ON filetracker USING btree (path);


--
-- Name: x_filetrackerdep_fkeyinput; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_filetrackerdep_fkeyinput ON filetrackerdep USING btree (fkeyinput);


--
-- Name: x_filetrackerdep_fkeyoutput; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_filetrackerdep_fkeyoutput ON filetrackerdep USING btree (fkeyoutput);


--
-- Name: x_hosthistory_datetime; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_hosthistory_datetime ON hosthistory USING btree (datetime);


--
-- Name: x_hosthistory_datetimeplusduration; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_hosthistory_datetimeplusduration ON hosthistory USING btree (((datetime + duration)));


--
-- Name: x_hosthistory_fkeyhost; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_hosthistory_fkeyhost ON hosthistory USING btree (fkeyhost);


--
-- Name: x_hosthistory_fkeyjob; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_hosthistory_fkeyjob ON hosthistory USING btree (fkeyjob);


--
-- Name: x_hostmapping_fkeymapping; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_hostmapping_fkeymapping ON hostmapping USING btree (fkeymapping);


--
-- Name: x_hostservice_fkeyhost; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_hostservice_fkeyhost ON hostservice USING btree (fkeyhost);


--
-- Name: x_hostservice_fkeyservice; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_hostservice_fkeyservice ON hostservice USING btree (fkeyservice);


--
-- Name: x_hoststatus_host; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_hoststatus_host ON hoststatus USING btree (fkeyhost);


--
-- Name: x_hoststatus_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_hoststatus_status ON hoststatus USING btree (slavestatus);


--
-- Name: x_jch_job; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_jch_job ON jobcommandhistory USING btree (fkeyjob);


--
-- Name: x_job_fkeyusr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_job_fkeyusr ON job USING btree (fkeyusr) WHERE ((((status = 'new'::text) OR (status = 'ready'::text)) OR (status = 'started'::text)) OR (status = 'done'::text));


--
-- Name: x_job_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_job_status ON job USING btree (status) WHERE ((((status = 'new'::text) OR (status = 'ready'::text)) OR (status = 'started'::text)) OR (status = 'done'::text));


--
-- Name: x_jobassignment_fkeyjob; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_jobassignment_fkeyjob ON jobassignment USING btree (fkeyjob);


--
-- Name: x_jobassignment_host; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_jobassignment_host ON jobassignment USING btree (fkeyhost);


--
-- Name: x_jobassignment_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_jobassignment_status ON jobassignment USING btree (fkeyjobassignmentstatus);


--
-- Name: x_joberror_cleared; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_joberror_cleared ON joberror USING btree (cleared);


--
-- Name: x_joberror_fkeyjob; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_joberror_fkeyjob ON joberror USING btree (fkeyjob);


--
-- Name: x_jobmax7_fkeyusr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_jobmax7_fkeyusr ON jobmax USING btree (fkeyusr) WHERE ((((status = 'new'::text) OR (status = 'ready'::text)) OR (status = 'started'::text)) OR (status = 'done'::text));


--
-- Name: x_jobmax7_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_jobmax7_status ON jobmax USING btree (status) WHERE ((((status = 'new'::text) OR (status = 'ready'::text)) OR (status = 'started'::text)) OR (status = 'done'::text));


--
-- Name: x_jobmax8_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_jobmax8_status ON jobmax8 USING btree (status);


--
-- Name: x_jobservice_job; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_jobservice_job ON jobservice USING btree (fkeyjob);


--
-- Name: x_jobstatus_job; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_jobstatus_job ON jobstatus USING btree (fkeyjob);


--
-- Name: x_jobtask_jobtaskassignment; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_jobtask_jobtaskassignment ON jobtask USING btree (fkeyjobtaskassignment);


--
-- Name: x_jobtask_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_jobtask_status ON jobtask USING btree (jobtask);


--
-- Name: x_jobtaskassignment_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_jobtaskassignment_status ON jobtaskassignment USING btree (fkeyjobassignmentstatus);


--
-- Name: x_rangefiletracker_fkeyelement; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_rangefiletracker_fkeyelement ON rangefiletracker USING btree (fkeyelement);


--
-- Name: x_rangefiletracker_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_rangefiletracker_name ON rangefiletracker USING btree (name);


--
-- Name: x_rangefiletracker_path; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_rangefiletracker_path ON rangefiletracker USING btree (path);


--
-- Name: x_schedule_fkeyelement; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_schedule_fkeyelement ON schedule USING btree (fkeyelement);


--
-- Name: x_schedule_fkeyuser; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_schedule_fkeyuser ON schedule USING btree (fkeyuser);


--
-- Name: x_syslog_ack; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_syslog_ack ON syslog USING btree (ack);


--
-- Name: x_timesheet_fkeyemployee; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_timesheet_fkeyemployee ON timesheet USING btree (fkeyemployee);


--
-- Name: x_timesheet_fkeyproject; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_timesheet_fkeyproject ON timesheet USING btree (fkeyproject);


--
-- Name: x_versionfiletracker_fkeyelement; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_versionfiletracker_fkeyelement ON versionfiletracker USING btree (fkeyelement);


--
-- Name: x_versionfiletracker_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_versionfiletracker_name ON versionfiletracker USING btree (name);


--
-- Name: x_versionfiletracker_path; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX x_versionfiletracker_path ON versionfiletracker USING btree (path);


--
-- Name: hoststatus_update_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER hoststatus_update_trigger
    BEFORE UPDATE ON hoststatus
    FOR EACH ROW
    EXECUTE PROCEDURE hoststatus_update();


--
-- Name: job3delight_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER job3delight_insert
    AFTER INSERT ON job3delight
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- Name: job3delight_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER job3delight_update
    BEFORE UPDATE ON job3delight
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- Name: job_error_insert_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER job_error_insert_trigger
    AFTER INSERT ON joberror
    FOR EACH ROW
    EXECUTE PROCEDURE job_error_insert();


--
-- Name: job_error_update_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER job_error_update_trigger
    AFTER UPDATE ON joberror
    FOR EACH ROW
    EXECUTE PROCEDURE job_error_increment();


--
-- Name: job_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER job_insert
    AFTER INSERT ON job
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- Name: job_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER job_update
    BEFORE UPDATE ON job
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- Name: jobaftereffects7_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobaftereffects7_insert
    AFTER INSERT ON jobaftereffects7
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- Name: jobaftereffects7_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobaftereffects7_update
    BEFORE UPDATE ON jobaftereffects7
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- Name: jobaftereffects8_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobaftereffects8_insert
    AFTER INSERT ON jobaftereffects8
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- Name: jobaftereffects8_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobaftereffects8_update
    BEFORE UPDATE ON jobaftereffects8
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- Name: jobaftereffects_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobaftereffects_insert
    AFTER INSERT ON jobaftereffects
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- Name: jobaftereffects_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobaftereffects_update
    BEFORE UPDATE ON jobaftereffects
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- Name: jobassignment_after_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobassignment_after_trigger
    AFTER INSERT OR UPDATE ON jobassignment
    FOR EACH ROW
    EXECUTE PROCEDURE jobassignment_after_update();


--
-- Name: jobassignment_delete_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobassignment_delete_trigger
    BEFORE DELETE ON jobassignment
    FOR EACH ROW
    EXECUTE PROCEDURE jobassignment_delete();


--
-- Name: jobassignment_insert_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobassignment_insert_trigger
    BEFORE INSERT ON jobassignment
    FOR EACH ROW
    EXECUTE PROCEDURE jobassignment_insert();


--
-- Name: jobassignment_update_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobassignment_update_trigger
    BEFORE UPDATE ON jobassignment
    FOR EACH ROW
    EXECUTE PROCEDURE jobassignment_update();


--
-- Name: jobautodeskburn_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobautodeskburn_insert
    AFTER INSERT ON jobautodeskburn
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- Name: jobautodeskburn_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobautodeskburn_update
    BEFORE UPDATE ON jobautodeskburn
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- Name: jobbatch_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobbatch_insert
    AFTER INSERT ON jobbatch
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- Name: jobbatch_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobbatch_update
    BEFORE UPDATE ON jobbatch
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- Name: jobcinema4d_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobcinema4d_insert
    AFTER INSERT ON jobcinema4d
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- Name: jobcinema4d_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobcinema4d_update
    BEFORE UPDATE ON jobcinema4d
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- Name: joberror_inc; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER joberror_inc
    AFTER INSERT OR UPDATE ON joberror
    FOR EACH ROW
    EXECUTE PROCEDURE joberror_inc();


--
-- Name: jobfusion_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobfusion_insert
    AFTER INSERT ON jobfusion
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- Name: jobfusion_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobfusion_update
    BEFORE UPDATE ON jobfusion
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- Name: jobfusionvideomaker_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobfusionvideomaker_insert
    AFTER INSERT ON jobfusionvideomaker
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- Name: jobfusionvideomaker_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobfusionvideomaker_update
    BEFORE UPDATE ON jobfusionvideomaker
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- Name: jobhoudinisim10_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobhoudinisim10_insert
    AFTER INSERT ON jobhoudinisim10
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- Name: jobhoudinisim10_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobhoudinisim10_update
    BEFORE UPDATE ON jobhoudinisim10
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- Name: jobmantra100_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmantra100_insert
    AFTER INSERT ON jobmantra100
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- Name: jobmantra100_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmantra100_update
    BEFORE UPDATE ON jobmantra100
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- Name: jobmax10_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmax10_insert
    AFTER INSERT ON jobmax10
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- Name: jobmax10_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmax10_update
    BEFORE UPDATE ON jobmax10
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- Name: jobmax2009_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmax2009_insert
    AFTER INSERT ON jobmaya2009
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- Name: jobmax2009_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmax2009_insert
    AFTER INSERT ON jobmax2009
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- Name: jobmax2009_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmax2009_update
    BEFORE UPDATE ON jobmax2009
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- Name: jobmax7_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmax7_insert
    AFTER INSERT ON jobmax7
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- Name: jobmax7_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmax7_update
    BEFORE UPDATE ON jobmax7
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- Name: jobmax8_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmax8_insert
    AFTER INSERT ON jobmax8
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- Name: jobmax8_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmax8_update
    BEFORE UPDATE ON jobmax8
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- Name: jobmax9_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmax9_insert
    AFTER INSERT ON jobmax9
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- Name: jobmax9_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmax9_update
    BEFORE UPDATE ON jobmax9
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- Name: jobmaxscript_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmaxscript_insert
    AFTER INSERT ON jobmaxscript
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- Name: jobmaxscript_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmaxscript_update
    BEFORE UPDATE ON jobmaxscript
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- Name: jobmaya2008_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmaya2008_insert
    AFTER INSERT ON jobmaya2008
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- Name: jobmaya2008_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmaya2008_update
    BEFORE UPDATE ON jobmaya2008
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- Name: jobmaya2009_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmaya2009_insert
    AFTER INSERT ON jobmaya2009
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- Name: jobmaya2009_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmaya2009_update
    BEFORE UPDATE ON jobmaya2009
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- Name: jobmaya7_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmaya7_insert
    AFTER INSERT ON jobmaya7
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- Name: jobmaya7_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmaya7_update
    BEFORE UPDATE ON jobmaya7
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- Name: jobmaya85_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmaya85_insert
    AFTER INSERT ON jobmaya85
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- Name: jobmaya85_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmaya85_update
    BEFORE UPDATE ON jobmaya85
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- Name: jobmentalray85_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmentalray85_insert
    AFTER INSERT ON jobmentalray85
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- Name: jobmentalray85_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobmentalray85_update
    BEFORE UPDATE ON jobmentalray85
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- Name: jobnuke51_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobnuke51_insert
    AFTER INSERT ON jobnuke51
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- Name: jobnuke51_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobnuke51_update
    BEFORE UPDATE ON jobnuke51
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- Name: jobnuke52_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobnuke52_insert
    AFTER INSERT ON jobnuke52
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- Name: jobnuke52_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobnuke52_update
    BEFORE UPDATE ON jobnuke52
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- Name: jobrealflow_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobrealflow_insert
    AFTER INSERT ON jobrealflow
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- Name: jobrealflow_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobrealflow_update
    BEFORE UPDATE ON jobrealflow
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- Name: jobshake_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobshake_insert
    AFTER INSERT ON jobshake
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- Name: jobshake_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobshake_update
    BEFORE UPDATE ON jobshake
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- Name: jobsync_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobsync_insert
    AFTER INSERT ON jobsync
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- Name: jobsync_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobsync_update
    BEFORE UPDATE ON jobsync
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- Name: jobtaskassignment_update_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobtaskassignment_update_trigger
    BEFORE UPDATE ON jobtaskassignment
    FOR EACH ROW
    EXECUTE PROCEDURE jobtaskassignment_update();


--
-- Name: jobxsi_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobxsi_insert
    AFTER INSERT ON jobxsi
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- Name: jobxsi_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobxsi_update
    BEFORE UPDATE ON jobxsi
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- Name: jobxsiscript_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobxsiscript_insert
    AFTER INSERT ON jobxsiscript
    FOR EACH ROW
    EXECUTE PROCEDURE job_insert();


--
-- Name: jobxsiscript_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobxsiscript_update
    BEFORE UPDATE ON jobxsiscript
    FOR EACH ROW
    EXECUTE PROCEDURE job_update();


--
-- Name: sync_host_to_hoststatus_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER sync_host_to_hoststatus_trigger
    AFTER INSERT OR DELETE ON host
    FOR EACH STATEMENT
    EXECUTE PROCEDURE sync_host_to_hoststatus_trigger();


--
-- Name: update_hostload; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_hostload
    BEFORE UPDATE ON hostload
    FOR EACH ROW
    EXECUTE PROCEDURE update_hostload();


--
-- Name: update_hostservice; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_hostservice
    BEFORE UPDATE ON hostservice
    FOR EACH ROW
    EXECUTE PROCEDURE update_hostservice();


--
-- Name: fkey_eventalert_host; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY eventalert
    ADD CONSTRAINT fkey_eventalert_host FOREIGN KEY ("fkeyHost") REFERENCES host(keyhost);


--
-- Name: fkey_graphrel_graph; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY graphrelationship
    ADD CONSTRAINT fkey_graphrel_graph FOREIGN KEY (fkeygraph) REFERENCES graph(keygraph) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fkey_graphrel_graphds; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY graphrelationship
    ADD CONSTRAINT fkey_graphrel_graphds FOREIGN KEY (fkeygraphds) REFERENCES graphds(keygraphds) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fkey_hgi_hg; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hostgroupitem
    ADD CONSTRAINT fkey_hgi_hg FOREIGN KEY (fkeyhostgroup) REFERENCES hostgroup(keyhostgroup) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fkey_hgi_host; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hostgroupitem
    ADD CONSTRAINT fkey_hgi_host FOREIGN KEY (fkeyhost) REFERENCES host(keyhost) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fkey_host; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY jobcommandhistory
    ADD CONSTRAINT fkey_host FOREIGN KEY (fkeyhost) REFERENCES host(keyhost) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: fkey_hostinterface_host; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hostinterface
    ADD CONSTRAINT fkey_hostinterface_host FOREIGN KEY (fkeyhost) REFERENCES host(keyhost) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fkey_hostport_host; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hostport
    ADD CONSTRAINT fkey_hostport_host FOREIGN KEY (fkeyhost) REFERENCES host(keyhost) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fkey_hostservice_host; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hostservice
    ADD CONSTRAINT fkey_hostservice_host FOREIGN KEY (fkeyhost) REFERENCES host(keyhost) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fkey_hostservice_service; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hostservice
    ADD CONSTRAINT fkey_hostservice_service FOREIGN KEY (fkeyservice) REFERENCES service(keyservice) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fkey_hostsoftware_host; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hostsoftware
    ADD CONSTRAINT fkey_hostsoftware_host FOREIGN KEY (fkeyhost) REFERENCES host(keyhost) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fkey_hostsoftware_software; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hostsoftware
    ADD CONSTRAINT fkey_hostsoftware_software FOREIGN KEY (fkeysoftware) REFERENCES software(keysoftware) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fkey_hoststatus_host; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hoststatus
    ADD CONSTRAINT fkey_hoststatus_host FOREIGN KEY (fkeyhost) REFERENCES host(keyhost) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fkey_syslog_host; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY syslog
    ADD CONSTRAINT fkey_syslog_host FOREIGN KEY (fkeyhost) REFERENCES host(keyhost) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fkey_syslog_realm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY syslog
    ADD CONSTRAINT fkey_syslog_realm FOREIGN KEY (fkeysyslogrealm) REFERENCES syslogrealm(keysyslogrealm) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fkey_syslog_severity; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY syslog
    ADD CONSTRAINT fkey_syslog_severity FOREIGN KEY (fkeysyslogseverity) REFERENCES syslogseverity(keysyslogseverity) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: jobtask_fkey_host; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY jobtask
    ADD CONSTRAINT jobtask_fkey_host FOREIGN KEY (fkeyhost) REFERENCES host(keyhost) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: public; Type: ACL; Schema: -; Owner: -
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

