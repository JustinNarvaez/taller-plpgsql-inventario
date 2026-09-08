-- =====================================================
-- PARTE 3 - Función 2: Validar disponibilidad
-- =====================================================

-- Verifica que el producto exista y que el stock alcance para la
-- cantidad solicitada. Devuelve TRUE si ambas condiciones se
-- cumplen; si alguna falla, lanza una excepción.
-- La existencia del producto la valida fn_consultar_stock, que ya
-- lanza su propia excepción.

CREATE OR REPLACE FUNCTION fn_validar_disponibilidad(
    p_id_producto INT,
    p_cantidad    INT
)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
    v_stock INT;
BEGIN
    -- Validación de la cantidad recibida.
    IF p_cantidad <= 0 THEN
        RAISE EXCEPTION 'La cantidad solicitada debe ser mayor que cero (se recibió %)',
            p_cantidad;
    END IF;

    -- Si el producto no existe, la ejecución se detiene aquí.
    v_stock := fn_consultar_stock(p_id_producto);

    -- Validación del stock disponible.
    IF v_stock < p_cantidad THEN
        RAISE EXCEPTION 'Stock insuficiente para el producto %: disponible %, solicitado %',
            p_id_producto, v_stock, p_cantidad;
    END IF;

    RETURN TRUE;
END;
$$;


-- Pruebas
SELECT fn_validar_disponibilidad(1, 5) AS es_valido;  -- stock suficiente
-- SELECT fn_validar_disponibilidad(1, 50);           -- stock insuficiente: debe fallar
-- SELECT fn_validar_disponibilidad(999, 1);          -- producto inexistente: debe fallar
