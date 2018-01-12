/* modified from https://gist.github.com/oinopion/4a207726edba8b99fd0be31cb28124d0 */
CREATE ROLE readaccess;
GRANT USAGE ON SCHEMA public to readaccess;
GRANT SELECT ON public.bookings_view to readaccess;
GRANT SELECT ON public.calls_view to readaccess;
GRANT readaccess TO iteam;

