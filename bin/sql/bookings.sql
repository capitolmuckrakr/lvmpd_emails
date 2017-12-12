CREATE TABLE public.bookings
(
  row_id bigint NOT NULL,
  booking_date date NOT NULL,
  booking_time timestamp without time zone,
  id text,
  last_name text,
  first_name text,
  middle_name text,
  sex text,
  race text,
  age text,
  charges text,
  type text,
  event_number text,
  arrest_officer text,
  fbi_code text,
  state_ text,
  filename text,
  PRIMARY KEY (booking_date, row_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.bookings
  OWNER TO acohen;