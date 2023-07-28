SELECT rent.guest_id, g.first_name, g.last_name, rent.guest_count, rent.rent_from, rent.rent_to
FROM guest AS g
INNER JOIN rent ON rent.guest_id = g.national_code
WHERE rent.status = 'pending';