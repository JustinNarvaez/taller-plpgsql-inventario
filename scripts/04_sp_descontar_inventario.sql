-- =====================================================
-- PARTE 4 - Procedimiento: Descontar inventario
-- =====================================================

-- Valida la disponibilidad y, si todo está en orden, descuenta la
-- cantidad del stock. Es un procedimiento y no una función porque
-- su propósito es ejecutar una acción, no devolver un valor.
-- Se invoca con CALL.

CREATE OR REPLACE PROCEDURE sp_descontar_inventario(
    p_id_producto INT,
    p_cantidad    INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_stock_nuevo INT;
BEGIN
    -- PERFORM llama a la función sin usar el valor que devuelve.
    -- Si la validación falla, se salta al bloque EXCEPTION y el
    -- UPDATE nunca se ejecuta.
    PERFORM fn_validar_disponibilidad(p_id_producto, p_cantidad);

    -- RETURNING captura el stock ya actualizado.
    UPDATE productos
    SET    stock = stock - p_cantidad
    WHERE  id_producto = p_id_producto
    RETURNING stock INTO v_stock_nuevo;

    -- Mensaje de confirmación.
    RAISE NOTICE 'Descuento aplicado. Producto %: se descontaron % unidades, nuevo stock = %',
        p_id_producto, p_cantidad, v_stock_nuevo;

EXCEPTION
    -- Manejo de errores. El bloque actúa como subtransacción: si
    -- algo falla, los cambios hechos aquí se deshacen.
    WHEN OTHERS THEN
        RAISE NOTICE 'No se pudo descontar el inventario: %', SQLERRM;
        RAISE;   -- relanza el error para que el llamador se entere
END;
$$;


-- Pruebas
SELECT id_producto, nombre, stock FROM productos ORDER BY id_producto;
CALL sp_descontar_inventario(1, 3);
SELECT id_producto, nombre, stock FROM productos WHERE id_producto = 1;

-- CALL sp_descontar_inventario(2, 100);   -- stock insuficiente: debe fallar
-- CALL sp_descontar_inventario(999, 1);   -- producto inexistente: debe fallar
