CREATE DEFINER = CURRENT_USER TRIGGER `Catastro`.`Vivienda_Unifamiliar_BEFORE_INSERT` BEFORE INSERT ON `Vivienda_Unifamiliar` FOR EACH ROW
BEGIN
SET @vive = (SELECT COUNT(Portal) FROM Piso_Persona WHERE DNI = NEW.DNI);
SET @vive1 = (SELECT COUNT(Numero) FROM Vivienda_Unifamiliar WHERE DNI = NEW.DNI);
IF (@vive > 0 OR @vive1 > 0) THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Esta persona no puede vivir en dos viviendas a la vez';
END IF;
END