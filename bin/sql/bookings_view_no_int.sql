CREATE VIEW public.bookings_view_no_int AS
 SELECT bookings.booking_date,
    bookings.arrest_date,
    bookings.booking_time,
    bookings.id,
    bookings.last_name,
    bookings.first_name,
    bookings.middle_name,
    bookings.sex,
    bookings.race,
    bookings.age,
    bookings.charge_date,
    bookings.charges,
    bookings.type,
    bookings.event_number,
    bookings.arrest_officer,
    bookings.fbi_code,
    bookings.state_,
    "left"(bookings.event_number, 6) AS booking_event_number_date,
    "substring"(bookings.event_number, 7, 10) AS booking_event_number
   FROM bookings;