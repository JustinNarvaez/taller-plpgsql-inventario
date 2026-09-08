-- =====================================================
-- PARTE 1 - Modelo de datos
-- TechStore - Control básico de inventario (PostgreSQL)
-- =====================================================

-- Permite reejecutar el script desde cero.
DROP TABLE IF EXISTS productos CASCADE;

CREATE TABLE productos (
    id_producto SERIAL PRIMARY KEY,                 -- identificador autoincremental
    nombre      VARCHAR(50) NOT NULL,               -- nombre obligatorio
    precio      NUMERIC(10,2) NOT NULL              -- tipo exacto para valores monetarios
        CONSTRAINT chk_precio_positivo CHECK (precio > 0),
    stock       INT NOT NULL DEFAULT 0              -- unidades disponibles en bodega
        CONSTRAINT chk_stock_no_negativo CHECK (stock >= 0)
);

-- El NOT NULL acompaña a cada CHECK porque un valor NULL no hace
-- fallar la restricción: la condición queda en estado desconocido.

-- Datos de prueba.
INSERT INTO productos (nombre, precio, stock) VALUES
    ('Teclado mecánico RGB',  250000.00, 10),
    ('Mouse inalámbrico',      85000.00,  3),
    ('Monitor 24 pulgadas',   750000.00,  5),
    ('Diadema gamer',         180000.00,  0);

-- Verificación.
SELECT id_producto, nombre, precio, stock
FROM productos
ORDER BY id_producto;
