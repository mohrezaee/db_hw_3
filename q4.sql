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

-- AND r.long > x1 AND r.long < x2 AND r.lat > y1 AND r.lat < y2

-- AND rent.rent_from < y AND rent.rent_to > x

ORDER BY (SELECT AVG(comment.rating) FROM residence res
INNER JOIN comment ON res.residence_id = comment.residence_id
WHERE res.residence_id = r.residence_id) DESC

LIMIT 20;