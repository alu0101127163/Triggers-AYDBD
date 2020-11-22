# Triggers-AYDBD
## Oscar Hernandez Diaz

#### Crear_email
```sql
CREATE PROCEDURE crear_email (IN nombre VARCHAR(45), IN apellido VARCHAR(45), IN dominio VARCHAR(45), OUT email VARCHAR(45))
BEGIN
	SET email = CONCAT(nombre,apellido,'@',dominio);
END;
```
