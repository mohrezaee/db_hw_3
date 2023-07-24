CREATE TABLE IF NOT EXISTS host
(
    national_code varchar(10) PRIMARY KEY,
    first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL,
    balance int NOT NULL DEFAULT 0,
    confirmed boolean NOT NULL DEFAULT False,
    pic_link varchar(100),
    CHECK (length(national_code) = 10 )
);

CREATE TABLE IF NOT EXISTS city
(
    city_id serial PRIMARY KEY,
    city_name varchar(50)
);

CREATE TABLE IF NOT EXISTS residence
(
    residence_id serial UNIQUE,
    title varchar(50), --Anita: ino ezafe kardm.
    host_id varchar(10),
    lat float NOT NULL,
    long float NOT NULL,
    price int NOT NULL CHECK (price > 0),
    capacity int NOT NULL,
    room_count int NOT NULL CHECK (room_count > 0),
    residence_type varchar(16) NOT NULL CHECK (
        residence_type in ('apartment', 'villa', 'hotel-apartment', 'ecotourism')
        ),
    province varchar(50) NOT NULL,
    city_id int,
    area float NOT NULL CHECK (area > 0),
    residence_address text NOT NULL,
    first_picture_link varchar(100),
    confirmed boolean NOT NULL DEFAULT False,
    country_side boolean NOT NULL DEFAULT False,
    establishment_from timestamp NOT NULL,
    establishment_to timestamp not NULL,
    cancellation_politic varchar(100),
    cancellation_cost int NOT NULL CHECK (cancellation_cost >= 0),

    PRIMARY KEY (lat, long),
    FOREIGN KEY (city_id) REFERENCES city(city_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (host_id) REFERENCES host(national_code) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS picture
(
    link VARCHAR(100) PRIMARY KEY,
    residence_id int,
    FOREIGN KEY (residence_id) REFERENCES residence(residence_id) ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE residence ADD FOREIGN KEY (first_picture_link) REFERENCES picture(link) ON DELETE CASCADE ON UPDATE CASCADE;

CREATE TABLE IF NOT EXISTS not_rentable_ranges
(
    range_from timestamp NOT NULL,
    range_to timestamp NOT NULL,
    residence_id serial UNIQUE,
    PRIMARY KEY(range_from, range_to, residence_id),
    FOREIGN KEY (residence_id) REFERENCES residence(residence_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS facility
(
    facility_id serial PRIMARY KEY,
    facility_name varchar(50),
    caption text
);

CREATE TABLE IF NOT EXISTS residence_facility
(
    residence_facility_id serial PRIMARY KEY,
    facility_id int,
    residence_id serial UNIQUE,
    FOREIGN KEY (facility_id) REFERENCES facility(facility_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (residence_id) REFERENCES residence(residence_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS bed
(
    bed_id serial PRIMARY KEY,
    bed_name varchar(50)
);

CREATE TABLE IF NOT EXISTS residence_bed
(
    residence_bed_id serial PRIMARY KEY,
    bed_id int,
    count int,
    residence_id int,
    FOREIGN KEY (bed_id) REFERENCES bed(bed_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (residence_id) REFERENCES residence(residence_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS price_change
(
    change_from varchar(20) not NULL,
    change_to varchar(20) NOT NULL,
    change_type varchar(8) NOT NULL CHECK(change_type in ('increase', 'discount')),
    change_percentage int NOT NULL CHECK (change_percentage > 0),
    residence_id serial UNIQUE,
    PRIMARY KEY (change_from, change_to, change_type, change_percentage),
    FOREIGN KEY (residence_id) REFERENCES residence(residence_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS guest
(
    national_code varchar(10) PRIMARY KEY,
    first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL,
    phone_number varchar(12) NOT NULL UNIQUE CHECK (length(phone_number) = 12 ),
    balance int NOT NULL DEFAULT 0
);


CREATE TABLE IF NOT EXISTS rent
(
    rent_id serial UNIQUE,
    rent_from timestamp not NULL, --Anita: ino taghir bedim be tarikh khali???
    rent_to timestamp NOT NULL,
    residence_id serial UNIQUE,
    guest_id varchar(10),
    -- confirmed boolean NOT NULL DEFAULT False,
    status varchar(9) NOT NULL CHECK(status in ('rejected', 'confirmed', 'pending')), --Anita: ino ezafe kardam.
    total_cost int NOT NULL,
    guest_count int NOT NULL,
    canceled boolean DEFAULT False,
    cancellation_caption varchar(100),
    cancellation_forgiven_percentage_money int,
    PRIMARY KEY (rent_from, rent_to),
    FOREIGN KEY (residence_id) REFERENCES residence(residence_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (guest_id) REFERENCES guest(national_code) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS complaint
(
    id int PRIMARY KEY,
    confirmed boolean NOT NULL DEFAULT False,
    caption varchar(50),
    complaint_type varchar(50),
    rent_id serial UNIQUE,
    FOREIGN KEY (rent_id) REFERENCES rent(rent_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS damage
(
    id int PRIMARY KEY,
    confirmed boolean NOT NULL DEFAULT False,
    caption varchar(50),
    rent_id serial UNIQUE,
    FOREIGN KEY (rent_id) REFERENCES rent(rent_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS comment
(
    id int PRIMARY KEY,
	sent_time timestamp,
    rating int not NULL,
    commenter_type varchar(50) not NULL CHECK (commenter_type in ('host', 'guest')),
    caption varchar(50),
    rent_id serial UNIQUE,
    residence_id serial,
    FOREIGN KEY (residence_id) REFERENCES residence(residence_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (rent_id) REFERENCES rent(rent_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS message
(
    sent_time timestamp PRIMARY KEY,
    content text not NULL,
    seen boolean NOT NULL DEFAULT False,
    guest_id varchar(10),
    host_id varchar(10),
    sender varchar(5) NOT NULL CHECK(sender in ('host', 'guest')),
    FOREIGN KEY (guest_id) REFERENCES guest(national_code) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (host_id) REFERENCES host(national_code) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS earning
(
	earning_id int PRIMARY KEY,
	balance int NOT NULL DEFAULT 0,
	balance_year int NOT NULL DEFAULT 2023,
	host_id varchar(10),
	FOREIGN KEY (host_id) REFERENCES host(national_code) ON DELETE CASCADE ON UPDATE CASCADE
);


-- 1
-- =======================

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
 
-- AND rent.rent_from < y AND rent.rent_to > x

ORDER BY (SELECT AVG(comment.rating) FROM residence res
INNER JOIN comment ON res.residence_id = comment.residence_id
WHERE res.residence_id = r.residence_id) DESC

LIMIT 20; --FETCH FIRST 20 ROW ONLY;

-- 2
-- =======================

SELECT r.residence_id, r.residence_type, r.first_picture_link, host.national_code , host.first_name , host.last_name
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
 
-- AND rent.rent_from < y AND rent.rent_to > x

ORDER BY (SELECT AVG(comment.rating) FROM residence res
INNER JOIN comment ON res.residence_id = comment.residence_id
WHERE res.residence_id = r.residence_id) DESC

OFFSET 20 ROWS
FETCH FIRST 20 ROW ONLY; 

--3
--======================

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

--4
--======================
--1st west south coordinate --> (x1 , y1)
--2nd east north coordinate --> (x2 , y2)
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


--5
--=====================
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

ORDER BY r.price ASC

LIMIT 20;



-- 6
--======================
SELECT host.national_code, m.content, m.sent_time
FROM message AS m 
INNER JOIN host on host.national_code = m.host_id
-- WHERE message.guest_id = <guest_id>
ORDER BY m.sent_time;

--7
-- ======================
SELECT host.national_code, m.content, m.sent_time
FROM message AS m
INNER JOIN host on host.national_code = m.host_id
-- WHERE message.guest_id = <guest_id>
-- AND message.host_id = <host_id>
ORDER BY m.sent_time DESC;

-- 8
-- ======================
SELECT rent.guest_id, g.first_name, g.last_name, rent.guest_count, rent.rent_from, rent.rent_to
FROM guest AS g
INNER JOIN rent ON rent.guest_id = g.national_code
WHERE rent.status = 'pending';

-- 9
-- ======================
SELECT residence.residence_id, residence.city_id , rent.total_cost, rent.rent_from, rent.rent_to
FROM guest AS g
INNER JOIN rent ON g.national_code = rent.guest_id
INNER JOIN residence ON rent.residence_id = residence.residence_id
-- WHERE rent.confirmed = True
WHERE rent.status = 'confirmed' --Anita: ino chon rent taghir dade boodm taghir dadm.
AND rent.canceled = False
-- AND g.national_code = <guest_id>
ORDER BY rent.rent_from DESC;
-- ====================

-- 10
-- =======================
SELECT guest.national_code , guest.first_name , guest.last_name , c.caption , c.rating , c.sent_time
FROM comment AS c
INNER JOIN rent ON c.rent_id = rent.rent_id
INNER JOIN guest ON rent.guest_id = guest.national_code -- Anita: in lazeme??
WHERE commenter_type = 'guest'
-- AND rent.residence_id = <residence_id>
ORDER BY c.sent_time ASC;
-- ======================

-- 11
-- =======================
SELECT h.first_name, h.last_name, earning.balance
FROM host AS h
INNER JOIN earning ON h.national_code = earning.host_id
WHERE earning.balance_year = 2022
ORDER BY earning.balance DESC
LIMIT 20;




-- Trigger:
CREATE Function check_availability() 
    RETURNS TRIGGER 
AS $check_availability$
BEGIN
    IF (SELECT count(*) FROM rent WHERE rent.rent_from = new.rent_from) <> 0  --Anita: rahe behtar hatman hast. aya ba timstamp kar mikone??
    THEN 
    RAISE EXCEPTION 'This accommodation is already reserved for this day.'
    ELSE
    RETURN new;
    END IF;
END;
$check_availability$

CREATE TRIGGER check_availability
    BEFORE INSERT OR UPDATE
    ON rent
    FOR EACH ROW
    EXECUTE PROCEDURE check_availability()
