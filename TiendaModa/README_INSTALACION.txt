TIENDA MODA - VERSIÓN NODE.JS + MYSQL

REQUISITOS:
1. Node.js instalado.
2. MySQL Community Server instalado y encendido.
3. MySQL Workbench o MySQL Command Line Client para importar la base de datos.
4. VS Code.

PASOS:
1. Abre MySQL Workbench.
2. Ejecuta el archivo: database/tienda_moda_node.sql
   Esto crea la base de datos tienda_moda_node, tablas y productos.
3. En la carpeta del proyecto, copia .env.example y renómbralo a .env
4. Revisa los datos de conexión:
   DB_HOST=localhost
   DB_USER=root
   DB_PASSWORD=TU_CONTRASEÑA_DE_MYSQL
   DB_NAME=tienda_moda_node
5. Abre terminal en VS Code y ejecuta:
   npm install
6. Luego ejecuta:
   npm start
7. Abre en navegador:
   http://localhost:3000

CUENTA ADMIN:
Correo: admin@tagmoda.com
Contraseña: admin123

PANEL ADMIN:
http://localhost:3000/paginas/Admin.html

QUÉ CUMPLE PARA LA RÚBRICA:
- Conexión real a MySQL.
- Productos dependen de la base de datos.
- Inserción de productos con formulario.
- Modificación de productos con formulario.
- Borrado de productos.
- Validación básica de datos.
- Comentarios guardados en base de datos.
- Login y registro de usuarios.
- Carrito guardado en base de datos por sesión/usuario.
- Uso de variables, arreglos, funciones y estructuras de control en Node.js y JavaScript.
