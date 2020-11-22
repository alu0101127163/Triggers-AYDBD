CREATE DEFINER = CURRENT_USER TRIGGER `viveros`.`Producto_pedido_BEFORE_INSERT` BEFORE INSERT ON `Producto_pedido` FOR EACH ROW
BEGIN
SET @stock_ = (SELECT Stock FROM Productos WHERE CodBarras = NEW.CodProducto);
SET @stock_ = (@stock_ - NEW.Cantidad);
IF @stock_ < 0 THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay stocj de este producto';
ELSE 
	UPDATE Productos SET Stock = @stock_ WHERE CodBarras = NEW.CodProducto;
    END IF;
END