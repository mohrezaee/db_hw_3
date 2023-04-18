
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
    not_rentable date,
    -- could have more than one value, & , should be an interval
    price int NOT NULL,
    capacity int NOT NULL,
    rooms_count int NOT NULL,
    pictures_links varchar(50),
    -- wtf: links of images, could be more than one
    residence_type varchar(50) NOT NULL,
    -- could be enum(domain)
    province VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    area FLOAT NOT NULL,
    residence_address text NOT NULL,
    first_picture_link varchar(50),
    confirmed bit NOT NULL DEFAULT 0,
    establishment_interval date,
    -- should be interval
    bed_type VARCHAR(50) NOT NULL,
    -- could be enum
    bed_count INT NOT NULL,
    cancellation_politic VARCHAR(100),
    -- not sure at all
    cancellation_cost INT NOT NULL,

    PRIMARY KEY (lat, long),
    FOREIGN KEY (host_id) REFERENCES host(national_code)
);

CREATE TABLE not_rentable_ranges
(
    range_from DATE NOT NULL,
    range_to DATE NOT NULL,
    residence_id serial,
    PRIMARY KEY(range_from, range_to),
    FOREIGN KEY (residence_id) REFERENCES residence(residence_id)
);

CREATE TABLE facility
(
    facility_name VARCHAR(50) PRIMARY KEY,
    residence_id serial UNIQUE,
    FOREIGN KEY (residence_id) REFERENCES residence(residence_id),
);

CREATE TABLE price_change
(
    change_from DATE not NULL,
    change_to DATE NOT NULL,
    change_type VARCHAR(50) NOT NULL,
    -- could be enum
    change_percentage INT NOT NULL,
    residence_id serial UNIQUE,
    PRIMARY KEY (change_from, change_to, change_type, change_percentage),
    FOREIGN KEY (residence_id) REFERENCES residence(residence_id),
);

CREATE TABLE passenger
(
    national_code INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(11) NOT NULL UNIQUE,
    -- constraint for phone number format
    balance INT NOT NULL,
);

CREATE TABLE rent
(
    rent_id serial UNIQUE,
    rent_from DATE not NULL,
    rent_to DATE NOT NULL,
    rent_type VARCHAR(50) NOT NULL,
    -- could be enum
    rent_percentage INT NOT NULL,
    residence_id serial UNIQUE,
    passenger_id int,
    confirmed bit NOT NULL DEFAULT 0,
    total_cost INT NOT NULL,
    passengers_count INT NOT NULL,
    cancellation_caption VARCHAR(50),
    cancellation_forgiven_percentage_money INT,
    PRIMARY KEY (rent_from, rent_to),
    FOREIGN KEY (residence_id) REFERENCES residence(residence_id),
    FOREIGN KEY (passenger_id) REFERENCES passenger(national_code),
);

CREATE TABLE complaint
(
    id int PRIMARY KEY,
    confirmed bit NOT NULL DEFAULT 0,
    caption VARCHAR(50),
    complaint_type VARCHAR(50),
    residence_id serial UNIQUE,
    FOREIGN KEY (residence_id) REFERENCES residence(residence_id),
);

CREATE TABLE damage
(
    id int PRIMARY KEY,
    confirmed bit NOT NULL DEFAULT 0,
    caption VARCHAR(50),
    residence_id serial UNIQUE,
    FOREIGN KEY (residence_id) REFERENCES residence(residence_id),
);

CREATE TABLE comment
(
    id int PRIMARY KEY,
    rating int not NULL,
    commenter_type VARCHAR(50) NULL,
    caption VARCHAR(50),
    residence_id serial UNIQUE,
    FOREIGN KEY (residence_id) REFERENCES residence(residence_id),
);

CREATE TABLE message
(
    sent_time date PRIMARY KEY,
    content text not NULL,
    seen bit NOT NULL DEFAULT 0,
    passenger_id int,
    host_id int,
    sender VARCHAR(20) NOT NULL,
    -- host or passernger
    FOREIGN KEY (passenger_id) REFERENCES passenger(national_code),
    FOREIGN KEY (host_id) REFERENCES host(national_code),
);

