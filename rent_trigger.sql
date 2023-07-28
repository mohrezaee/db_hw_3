
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
