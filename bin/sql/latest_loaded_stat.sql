SELECT filename
FROM event_times
WHERE eventdate IN (
	SELECT MAX(eventdate)
	FROM event_times
)
ORDER BY filename DESC
LIMIT 1;
