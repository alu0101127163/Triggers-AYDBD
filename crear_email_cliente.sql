CREATE DEFINER = CURRENT_USER TRIGGER `viveros`.`Cliente_BEFORE_INSERT` BEFORE INSERT ON `Cliente` FOR EACH ROW
BEGIN
DECLARE email_ VARCHAR(45);
	IF NEW.Email IS NULL THEN
		CALL crear_email(NEW.Nombre,NEW.Apellido,'ull.es',email_);
		SET NEW.Email = email_;
	END IF;
END