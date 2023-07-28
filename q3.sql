SELECT r.residence_id, r.title, r.first_picture_link, host.national_code , host.first_name , host.last_name
FROM residence r INNER JOIN host ON r.host_id = host.national_code
INNER JOIN rent ON rent.residence_id = r.residence_id
INNER JOIN city ON city.city_id = r.city_id

WHERE r.residence_id NOT IN

(SELECT r.residence_id
FROM residence r
INNER JOIN host ON r.host_id = host.national_code
INNER JOIN rent ON rent.residence_id = r.residence_id
INNER JOIN city ON city.city_id = r.city_id)
AND city.city_name = 'Tabriz' AND r.capacity >= 4
AND r.residence_type = 'apartment'
AND EXISTS (SELECT * FROM residence_facility
			INNER JOIN facility ON residence_facility.residence_facility_id = facility.facility_id
		   WHERE residence_facility.residence_id = r.residence_id
		   AND(facility.facility_name = 'free internet access' OR facility.facility_name = 'dedicated parking'))
 
-- AND rent.rent_from < y AND rent.rent_to > x

ORDER BY (SELECT AVG(comment.rating) FROM residence res
INNER JOIN comment ON res.residence_id = comment.residence_id
WHERE res.residence_id = r.residence_id) DESC

LIMIT 20;