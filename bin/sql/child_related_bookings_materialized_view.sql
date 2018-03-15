CREATE MATERIALIZED VIEW public.child_related_bookings_in_last_week
AS
SELECT *
FROM public.bookings_view
WHERE personid IN (
    SELECT DISTINCT personid
    FROM (
    SELECT DISTINCT t1.*
    FROM bookings_view t1
    JOIN bookings_view t2 ON t1.event_number = t2.event_number AND t1.id <> t2.id AND t1.personid=t2.personid
    WHERE t1.booking_date >= ('now'::text::date - '7 days'::interval) AND t2.booking_date >= ('now'::text::date - '7 days'::interval) AND (
    (t1.charges ~~* '%child%'::text AND (t1.charges ~~* '%murder%'::text OR t1.charges ~~* '%sex%'::text OR t1.charges ~~* '%lewd%'::text)) OR
    (t2.charges ~~* '%child%'::text AND (t2.charges ~~* '%murder%'::text OR t2.charges ~~* '%sex%'::text OR t2.charges ~~* '%lewd%'::text)) OR
    (t1.charges ~~* '%child%'::text AND (t2.charges ~~* '%murder%'::text OR t2.charges ~~* '%sex%'::text OR t2.charges ~~* '%lewd%'::text)) OR
    (t2.charges ~~* '%child%'::text AND (t1.charges ~~* '%murder%'::text OR t1.charges ~~* '%sex%'::text OR t1.charges ~~* '%lewd%'::text))
    )
    UNION
    SELECT DISTINCT t2.*
    FROM bookings_view t1
    JOIN bookings_view t2 ON t1.event_number = t2.event_number AND t1.id <> t2.id AND t1.personid=t2.personid
    WHERE t1.booking_date >= ('now'::text::date - '7 days'::interval) AND t2.booking_date >= ('now'::text::date - '7 days'::interval) AND (
    (t1.charges ~~* '%child%'::text AND (t1.charges ~~* '%murder%'::text OR t1.charges ~~* '%sex%'::text OR t1.charges ~~* '%lewd%'::text)) OR
    (t2.charges ~~* '%child%'::text AND (t2.charges ~~* '%murder%'::text OR t2.charges ~~* '%sex%'::text OR t2.charges ~~* '%lewd%'::text)) OR
    (t1.charges ~~* '%child%'::text AND (t2.charges ~~* '%murder%'::text OR t2.charges ~~* '%sex%'::text OR t2.charges ~~* '%lewd%'::text)) OR
    (t2.charges ~~* '%child%'::text AND (t1.charges ~~* '%murder%'::text OR t1.charges ~~* '%sex%'::text OR t1.charges ~~* '%lewd%'::text))
    )
    ) AS tbl1
    )
AND booking_date >= CURRENT_DATE - interval '1 week'
ORDER BY booking_time DESC, last_name
WITH DATA;

ALTER TABLE public.child_related_bookings_in_last_week
  OWNER TO acohen;
GRANT ALL ON TABLE public.child_related_bookings_in_last_week TO acohen;
GRANT SELECT ON TABLE public.child_related_bookings_in_last_week TO readaccess;