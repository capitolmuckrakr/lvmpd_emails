CREATE TABLE rachel_events (
pk bigserial primary key,
filename text,
type text,
description text,
event_num text,
disposition text,
event_time time,
address text
)