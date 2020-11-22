# Triggers-AYDBD
## Oscar Hernandez Diaz

#### crear_email
```sql
CREATE PROCEDURE crear_email (IN nombre VARCHAR(45), IN apellido VARCHAR(45), IN dominio VARCHAR(45), OUT email VARCHAR(45))
BEGIN
	SET email = CONCAT(nombre,apellido,'@',dominio);
END;
```
Para realizar el procedimiento de crear_email le pasamos como parametros el nombre y apellido del cliente, el dominio y aparte la variable email, que es donde la vamos a guardar. Simplemente usamos la funcion CONCAT() donde nos concatena las cadenas, en este caso los parametros obtenidos y lo guardamos en la variable email.
Esta variable email va a ser devuelta por el que llama a la funcion.

#### trigger_crear_email_before_insert
```sql
CREATE DEFINER = CURRENT_USER TRIGGER `viveros`.`Cliente_BEFORE_INSERT` BEFORE INSERT ON `Cliente` FOR EACH ROW
BEGIN
DECLARE email_ VARCHAR(45);
	IF NEW.Email IS NULL THEN
		CALL crear_email(NEW.Nombre,NEW.Apellido,'ull.es',email_);
		SET NEW.Email = email_;
	END IF;
END
```
Hemos introducido este trigger en la tabla cliente, ya que cada vez que se inserte un nuevo cliente comprobamos si no ha introducido un email, si es el caso llamamos al procedimiento crear_email y guardamos en el email del cliente el email que nos devilvio esta fuincion, en el caso de que el cliente haya introducido uno simplemente no realizamos nada.

#### Trigger para comprobar que la misma persona no viva en dos vivienda a la vez
```sql
CREATE DEFINER = CURRENT_USER TRIGGER `Catastro`.`Piso_Persona_BEFORE_INSERT` BEFORE INSERT ON `Piso_Persona` FOR EACH ROW
BEGIN
SET @vive = (SELECT COUNT(Portal) FROM Piso_Persona WHERE DNI = NEW.DNI);
SET @vive1 = (SELECT COUNT(Numero) FROM Vivienda_Unifamiliar WHERE DNI = NEW.DNI);
IF (@vive > 0 OR @vive1 > 0) THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Esta persona no puede vivir en dos vivienda a la vez';
END IF;
END
```
Para comprobar que la misma persona no viva en dos viviendas a la vez, introducimos este trigger tanto en la talba de vivienda_unifamiliar como en piso_persona, basicamente son las tablas donde guardamos el numero, el portal, etc, de cada persona. Por tanto, buscamos tanto en la tabla piso_persona como en la de vivienda_unifamiliar si dicha persona esta; desde que este en una de las dos, lo cual significa que el cliete ya tiene una vivienda aparte de la que esta introduciendo, mandamos un mensaje de error diciendo que esta persona no puede vivir en dos vivienda a la vez.

#### Trigger para calcular el stock
```sql
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
```
Introducimos este trigger en la talba producto_pedido, ya que cuando se quiera hacer un pedido hay que comprobar el stock que tenemos en la base de datos.
Por lo que buscamos en al tabla productos el stock de dicho prodcuto y se lo restamos con la cantidad pedida. SI el resultado es menor que 0 mandamos un error diciendo que no existe suficiente stock para este producto, sino actualizamos el valor del stock en la tabla productos.




