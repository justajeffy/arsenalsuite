--begin;
delete from job where status='deleted' and ( endedts < now()-'14 days'::interval or (endedts is null and submittedts < now()-'14 days'::interval) );
delete from jobassignment where fkeyjob not in (select keyjob from job);
delete from jobtask where fkeyjob not in(select keyjob from job);
delete from joberror where fkeyjob not in (select keyjob from job);
delete from jobhistory where fkeyjob not in (select keyjob from job);
delete from jobstatus where fkeyjob not in (select keyjob from job);
delete from jobservice where fkeyjob not in (select keyjob from job);
delete from jobdep where fkeyjob not in (select keyjob from job);
delete from joboutput where fkeyjob not in (select keyjob from job);

--commit;
vacuum full;
reindex database blur;
vacuum analyze;
 
