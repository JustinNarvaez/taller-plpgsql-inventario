-- =====================================================
-- PARTE 2 - Función 1: Consultar stock
-- =====================================================

-- Recibe el id de un producto y devuelve su stock actual.
-- Si el producto no existe, lanza una excepción en lugar de
-- devolver NULL.

CREATE OR REPLACE FUNCTION fn_consultar_stock(p_id_producto INT)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    v_stock INT;
BEGIN
    -- Guarda el resultado de la consulta en la variable.
    SELECT stock
    INTO   v_stock
    FROM   productos
    WHERE  id_producto = p_id_producto;

    -- SELECT INTO no falla si no encuentra la fila, por eso se
    -- revisa FOUND de forma explícita.
    IF NOT FOUND THEN
        RAISE EXCEPTION 'El producto con id % no existe', p_id_producto;
    END IF;

    RETURN v_stock;
END;
$$;


-- Pruebas
SELECT fn_consultar_stock(1) AS stock_actual;   -- producto existente
-- SELECT fn_consultar_stock(999);              -- producto inexistente: debe fallar
