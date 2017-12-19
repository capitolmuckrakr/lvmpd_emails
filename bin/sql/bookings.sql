CREATE TABLE public.bookings
(
  row_id bigint NOT NULL,
  booking_date date NOT NULL,
  arrest_date date,
  booking_time timestamp without time zone,
  id text,
  last_name text,
  first_name text,
  middle_name text,
  sex text,
  race text,
  age text,
  charge_date date,
  charges text,
  type text,
  event_number text,
  arrest_officer text,
  fbi_code text,
  state_ text,
  filename text,
  PRIMARY KEY (filename, row_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.bookings
  OWNER TO acohen;