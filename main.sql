
CREATE TABLE host
(
    national_code varchar(10) PRIMARY KEY,
    first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL,
    balance INT NOT NULL DEFAULT 0,
    confirmed bit NOT NULL DEFAULT 0,
    pic_link varchar(100),
    CHECK (length(national_code) = 10 )
);

CREATE TABLE residence
(
    residence_id serial,
    host_id INT,
    lat FLOAT NOT NULL,
    long FLOAT NOT NULL,
    price int NOT NULL CHECK (price > 0),
    capacity int NOT NULL,
    room_count int NOT NULL CHECK (price > 0),
    residence_type varchar(16) NOT NULL CHECK (
        residence_type in ('aplartment', 'villa', 'hotel-appartment', 'ecotourism')
        ),
    province VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    area FLOAT NOT NULL CHECK (area > 0),
    residence_address text NOT NULL,
    first_picture_link VARCHAR(100),
    confirmed bit NOT NULL DEFAULT 0,
    country_side bit NOT NULL DEFAULT 0,
    establishment_from date NOT NULL,
    establishment_to date not NULL,
    bed_type VARCHAR(50) NOT NULL,
    bed_count INT NOT NULL CHECK (bed_count >= 0) DEFAULT 0,
    cancellation_politic VARCHAR(100),
    -- not sure at all
    cancellation_cost INT NOT NULL CHECK (cancellation_cost >= 0),

    PRIMARY KEY (lat, long),
    FOREIGN KEY (host_id) REFERENCES host(national_code),
);

CREATE TABLE picture
(
    link VARCHAR(100) PRIMARY KEY,
    residence_id serial,
    FOREIGN KEY (residence_id) REFERENCES residence(residence_id)
);

ALTER TABLE residence ADD FOREIGN KEY (first_picture_link) REFERENCES picture(link);

CREATE TABLE not_rentable_ranges
(
    range_from DATE NOT NULL,
    range_to DATE NOT NULL,
    residence_id serial,
    PRIMARY KEY(range_from, range_to, residence_id),
    FOREIGN KEY (residence_id) REFERENCES residence(residence_id)
);

CREATE TABLE facility
(
    facility_name VARCHAR(50) PRIMARY KEY,
    caption text,
    residence_id serial UNIQUE,
    FOREIGN KEY (residence_id) REFERENCES residence(residence_id),
);

CREATE TABLE price_change
(
    change_from DATE not NULL,
    change_to DATE NOT NULL,
    change_type VARCHAR(8) NOT NULL CHECK(change_type in ('increase', 'discount')),
    change_percentage INT NOT NULL CHECK (change_percentage > 0),
    residence_id serial UNIQUE,
    PRIMARY KEY (change_from, change_to, change_type, change_percentage),
    FOREIGN KEY (residence_id) REFERENCES residence(residence_id),
);

CREATE TABLE guest
(
    national_code VARCHAR(10) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    -- check phone number length
    phone_number VARCHAR(11) NOT NULL UNIQUE,
    balance INT NOT NULL CHECK
    (balance > 0),
);

CREATE TABLE rent
(
    rent_id serial,
    rent_from DATE not NULL,
    rent_to DATE NOT NULL,
    residence_id serial,
    guest_id VARCHAR(10),
    confirmed bit NOT NULL DEFAULT 0,
    total_cost INT NOT NULL,
    guest_count INT NOT NULL,
    cancellation_caption VARCHAR(100),
    cancellation_forgiven_percentage_money INT,
    PRIMARY KEY (rent_from, rent_to),
    FOREIGN KEY (residence_id) REFERENCES residence(residence_id),
    FOREIGN KEY (guest_id) REFERENCES guest(national_code),
);

CREATE TABLE complaint
(
    id int PRIMARY KEY,
    confirmed bit NOT NULL DEFAULT 0,
    caption VARCHAR(50),
    complaint_type VARCHAR(50),
    residence_id serial,
    FOREIGN KEY (residence_id) REFERENCES residence(residence_id),
);

CREATE TABLE damage
(
    id int PRIMARY KEY,
    confirmed bit NOT NULL DEFAULT 0,
    caption VARCHAR(50),
    residence_id serial,
    FOREIGN KEY (residence_id) REFERENCES residence(residence_id),
);

CREATE TABLE comment
(
    id int PRIMARY KEY,
    rating int not NULL,
    commenter_type VARCHAR(50) NULL,
    caption VARCHAR(50),
    residence_id serial,
    FOREIGN KEY (residence_id) REFERENCES residence(residence_id),
);

CREATE TABLE message
(
    sent_time date PRIMARY KEY,
    content text not NULL,
    seen bit NOT NULL DEFAULT 0,
    guest_id int,
    host_id int,
    sender VARCHAR(5) NOT NULL CHECK(sender in ('host', 'guest')),
    FOREIGN KEY (guest_id) REFERENCES guest(national_code),
    FOREIGN KEY (host_id) REFERENCES host(national_code),
);

