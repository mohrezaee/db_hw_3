SELECT guest.national_code , guest.first_name , guest.last_name , c.caption , c.rating , c.sent_time
FROM comment AS c
INNER JOIN rent ON c.rent_id = rent.rent_id
INNER JOIN guest ON rent.guest_id = guest.national_code -- Anita: in lazeme??
WHERE c.commenter_type = 'guest'
-- AND rent.residence_id = <residence_id>
ORDER BY c.sent_time ASC;