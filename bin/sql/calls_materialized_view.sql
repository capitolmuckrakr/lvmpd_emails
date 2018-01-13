CREATE MATERIALIZED VIEW public.calls_view
AS
 SELECT t1.event_num AS eventnum,
    t1.type,
    t1.description,
    t3.definition,
    t1.address,
    t1.event_time AS eventtime,
    t2.eventdate,
    ("substring"(t1.event_num, 4, 6)::integer::text || "substring"(t1.event_num, 10, 10)::integer::text)::bigint AS bookings_event_num
   FROM events t1
     JOIN event_times t2 USING (filename)
     LEFT JOIN lk_dispositioncodes t3 ON t1.disposition = t3.code::text
  ORDER BY t1.event_num DESC
WITH DATA;

ALTER TABLE public.calls_view
    OWNER TO acohen;


CREATE INDEX calls_view_address_idx
    ON public.calls_view USING btree
    (address)
;
CREATE INDEX calls_view_bookings_event_num_idx
    ON public.calls_view USING btree
    (bookings_event_num)
;
CREATE INDEX calls_view_description_idx
    ON public.calls_view USING btree
    (description)
;
CREATE INDEX calls_view_eventdate_idx
    ON public.calls_view USING btree
    (eventdate)
;
CREATE INDEX calls_view_eventnum_idx
    ON public.calls_view USING btree
    (eventnum)
;
CREATE INDEX calls_view_type_idx
    ON public.calls_view USING btree
    (type)
;