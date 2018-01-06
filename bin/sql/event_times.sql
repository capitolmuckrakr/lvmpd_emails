CREATE TABLE event_times (
pk bigserial primary key,
filename text,
filedate date,
filetime time,
eventdate date,
starttime time,
endtime time
)