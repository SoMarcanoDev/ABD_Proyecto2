## Integrantes
- Valeria Ciccolella
- Nicole Llerena
- Sofia Marcano

## Pasos para crear la bd
- Crear la carpeta `C:\SQLData` (No se si seria mejor crearlo dentro de la instalación de sql server como en el lab?)
- Ejecutar el script sql `create_bd.sql`, este script crea la base de datos, los files groups y un esquema
- Ejecutar el script sql `create_tables.sql`, este script genera la estructura base de las tablas de la base de datos segun el modelo relacional
- Ejecutar el script sql `create_indexes.sql`, este script crea los indices que empleara la base de datos
- Ejecutar el script sql `create_views.sql`, este script crea las vistas de la base de datos
- Ejecutar el script sql `create_functions.sql`, este script crea la función para calcular la base comisionable según los filtros del plan
- Ejecutar el script sql `create_procedures.sql`, este script crea los procedimientos para calcular comisiones y registrar pagos
- Ejecutar el script sql `create_triggers.sql`, este script crea los triggers solicitados en el enunciado y otros triggers que aplican reglas del negocio.
- Ejecutar el script sql `create_roles.sql`, este script crea el usuario dueño del esquema sin login, los roles y sus permisos
- Ejecutar el script sql `populate_triggers.sql`, este inserta 10 registros por tabla de la base de datos con valores coherentes y respetando las restricciones de cada valor o columna.
- TO BE CONTINUED


## Preguntas
- La cuota de ventas de un vendedor es distinta a la comisión por venta?
- Los productos deben registrar un precio unitario para el calculo del subtotal por producto en la factura? o ese subtotal es introducido a mano al momento de crear la factura?
- La relación de supervisor vendedor pide guardar la fecha desde la que es válida el porcentaje de reconocimiento para el supervisor, esto significa que debe ser guardar un historial de esta relación en caso de que cambie el supervisor de un vendedor o el porcentaje de reconocimiento?
- Los reportes que genera y revisa el departamento de finanzas se guarda dentro de la base de datos?
- Es la comisión que nace de la factura (donde se guarda el porcentaje de participación de cada vendedor según su rol) distinta al cálculo de comisión que se hace a partir del periodo?
- El cálculo de la comisión referido al periodo se hace como acumulativo de todas las ventas en las que participan vendedores y supervisores en un periodo? o se hace por cada venta individual?
- Que deberían guardar los filtros como tal? creamos banderas a nuestro criterio?