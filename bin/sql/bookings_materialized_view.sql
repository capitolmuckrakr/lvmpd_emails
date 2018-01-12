CREATE MATERIALIZED VIEW public.bookings_view
AS
 SELECT bookings_view_no_int.booking_date,
    bookings_view_no_int.arrest_date,
    bookings_view_no_int.booking_time,
    bookings_view_no_int.id,
    bookings_view_no_int.last_name,
    bookings_view_no_int.first_name,
    bookings_view_no_int.middle_name,
    bookings_view_no_int.sex,
    bookings_view_no_int.race,
    bookings_view_no_int.age,
    bookings_view_no_int.charge_date,
    bookings_view_no_int.charges,
    bookings_view_no_int.type,
    bookings_view_no_int.event_number,
    bookings_view_no_int.arrest_officer,
    bookings_view_no_int.fbi_code,
    bookings_view_no_int.state_,
    (bookings_view_no_int.booking_event_number_date::integer::text || bookings_view_no_int.booking_event_number::integer::text)::bigint AS calls_event_num
   FROM bookings_view_no_int
  WHERE bookings_view_no_int.booking_event_number_date !~ similar_escape('%[A-Z-]%'::text, NULL::text) AND bookings_view_no_int.booking_event_number_date !~~ '%,%'::text AND bookings_view_no_int.booking_event_number_date !~~ '%"%'::text AND bookings_view_no_int.booking_event_number_date IS NOT NULL AND bookings_view_no_int.booking_event_number_date <> ''::text AND bookings_view_no_int.booking_event_number !~ similar_escape('%[A-Z-]%'::text, NULL::text) AND bookings_view_no_int.booking_event_number !~ similar_escape('%`%'::text, NULL::text) AND bookings_view_no_int.booking_event_number <> ''::text
WITH DATA;

ALTER TABLE public.bookings_view
    OWNER TO acohen;


CREATE INDEX bookings_view_age_idx
    ON public.bookings_view USING btree
    (age)
;
CREATE INDEX bookings_view_arrest_date_idx
    ON public.bookings_view USING btree
    (arrest_date)
;
CREATE INDEX bookings_view_booking_date_idx
    ON public.bookings_view USING btree
    (booking_date)
;
CREATE INDEX bookings_view_calls_event_num_idx
    ON public.bookings_view USING btree
    (calls_event_num)
;
CREATE INDEX bookings_view_charge_date_idx
    ON public.bookings_view USING btree
    (charge_date)
;
CREATE INDEX bookings_view_charges_idx
    ON public.bookings_view USING btree
    (charges)
;
CREATE INDEX bookings_view_fbi_code_idx
    ON public.bookings_view USING btree
    (fbi_code)
;
CREATE INDEX bookings_view_first_name_idx
    ON public.bookings_view USING btree
    (first_name)
;
CREATE INDEX bookings_view_id_idx
    ON public.bookings_view USING btree
    (id)
;
CREATE INDEX bookings_view_last_name_idx
    ON public.bookings_view USING btree
    (last_name)
;
CREATE INDEX bookings_view_race_idx
    ON public.bookings_view USING btree
    (race)
;
CREATE INDEX bookings_view_sex_idx
    ON public.bookings_view USING btree
    (sex)
;