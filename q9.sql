SELECT residence.residence_id, residence.city_id , rent.total_cost, rent.rent_from, rent.rent_to
FROM guest AS g
INNER JOIN rent ON g.national_code = rent.guest_id
INNER JOIN residence ON rent.residence_id = residence.residence_id
-- WHERE rent.confirmed = True
WHERE rent.status = 'confirmed' --Anita: ino chon rent taghir dade boodm taghir dadm.
AND rent.canceled = False
-- AND g.national_code = <guest_id>
ORDER BY rent.rent_from DESC;