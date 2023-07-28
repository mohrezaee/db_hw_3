SELECT host.national_code, m.content, m.sent_time
FROM message AS m 
INNER JOIN host on host.national_code = m.host_id
-- WHERE message.guest_id = <guest_id>
ORDER BY m.sent_time;