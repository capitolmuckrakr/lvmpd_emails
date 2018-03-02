CREATE MATERIALIZED VIEW public.child_related_bookings_in_last_week
AS
SELECT *
FROM public.bookings_view
WHERE personid IN (
	SELECT DISTINCT t1.personid
	FROM public.bookings_view t1
	JOIN public.bookings_view t2 ON t1.event_number = t2. event_number AND t1.id <> t2.id
	WHERE t1.booking_date >= CURRENT_DATE - interval '1 week' AND t2.booking_date >= CURRENT_DATE - interval '1 week'
	AND t1.charges ILIKE '%child%' AND (t2.charges ILIKE '%murder%' OR t2.charges ILIKE '%sex%')
	UNION
	SELECT DISTINCT t2.personid
	FROM public.bookings_view t1
	JOIN public.bookings_view t2 ON t1.event_number = t2. event_number AND t1.id <> t2.id
	WHERE t1.booking_date >= CURRENT_DATE - interval '1 week' AND t2.booking_date >= CURRENT_DATE - interval '1 week'
	AND t1.charges ILIKE '%child%' AND (t2.charges ILIKE '%murder%' OR t2.charges ILIKE '%sex%')
)
AND booking_date >= CURRENT_DATE - interval '1 week'
ORDER BY booking_time DESC, last_name
WITH DATA;

ALTER TABLE public.child_related_bookings_in_last_week
  OWNER TO acohen;
GRANT ALL ON TABLE public.child_related_bookings_in_last_week TO acohen;
GRANT SELECT ON TABLE public.child_related_bookings_in_last_week TO readaccess;