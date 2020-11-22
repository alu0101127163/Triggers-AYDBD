CREATE DEFINER = CURRENT_USER TRIGGER `Catastro`.`Piso_Persona_BEFORE_INSERT` BEFORE INSERT ON `Piso_Persona` FOR EACH ROW
BEGIN
SET @vive = (SELECT COUNT(Portal) FROM Piso_Persona WHERE DNI = NEW.DNI);
SET @vive1 = (SELECT COUNT(Numero) FROM Vivienda_Unifamiliar WHERE DNI = NEW.DNI);
IF (@vive > 0 OR @vive1 > 0) THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Esta persona no puede vivir en dos vivienda a la vez';
END IF;
END