-- =====================================================
-- PARTE 5 - Pruebas obligatorias
-- =====================================================
-- Ejecutar cada bloque por separado. Los casos 2 y 3 terminan en
-- error, y el error interrumpe el resto del script.


-- -----------------------------------------------------
-- Estado inicial conocido
-- -----------------------------------------------------
UPDATE productos SET stock = 10 WHERE id_producto = 1;
UPDATE productos SET stock = 3  WHERE id_producto = 2;
UPDATE productos SET stock = 5  WHERE id_producto = 3;
UPDATE productos SET stock = 0  WHERE id_producto = 4;

SELECT id_producto, nombre, stock FROM productos ORDER BY id_producto;


-- -----------------------------------------------------
-- Caso 1 - Stock suficiente
-- Producto 1 tiene 10 unidades, se piden 3. Debe quedar en 7.
-- -----------------------------------------------------
SELECT id_producto, nombre, stock FROM productos WHERE id_producto = 1;
CALL sp_descontar_inventario(1, 3);
SELECT id_producto, nombre, stock FROM productos WHERE id_producto = 1;


-- -----------------------------------------------------
-- Caso 2 - Stock insuficiente
-- Producto 2 tiene 3 unidades, se piden 100. El stock no cambia.
-- -----------------------------------------------------
SELECT id_producto, nombre, stock FROM productos WHERE id_producto = 2;
CALL sp_descontar_inventario(2, 100);
SELECT id_producto, nombre, stock FROM productos WHERE id_producto = 2;


-- -----------------------------------------------------
-- Caso 3 - Producto inexistente
-- El producto 999 no existe. La tabla no cambia.
-- -----------------------------------------------------
SELECT id_producto, nombre, stock FROM productos ORDER BY id_producto;
CALL sp_descontar_inventario(999, 1);
SELECT id_producto, nombre, stock FROM productos ORDER BY id_producto;
