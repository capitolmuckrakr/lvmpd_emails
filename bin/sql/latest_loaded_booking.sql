SELECT MAX(filename) AS filename
FROM bookings 
WHERE booking_date IN (
	SELECT MAX(booking_date) 
	FROM bookings
);
