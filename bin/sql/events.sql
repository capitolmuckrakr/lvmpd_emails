CREATE TABLE events (
pk bigserial primary key,
filename text,
type text,
description text,
event_num text,
disposition text,
time time,
address text
)