CREATE DATABASE IF NOT EXISTS tienda_moda_node CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE tienda_moda_node;


DROP TABLE IF EXISTS carrito;
DROP TABLE IF EXISTS comentarios;
DROP TABLE IF EXISTS producto_tallas;
DROP TABLE IF EXISTS producto_imagenes;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS categorias;
DROP TABLE IF EXISTS usuarios;

CREATE TABLE usuarios (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  correo VARCHAR(120) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  rol ENUM('cliente','admin') NOT NULL DEFAULT 'cliente',
  creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categorias (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(80) NOT NULL UNIQUE,
  slug VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE productos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  slug VARCHAR(120) NOT NULL UNIQUE,
  nombre VARCHAR(120) NOT NULL,
  descripcion TEXT NOT NULL,
  precio DECIMAL(10,2) NOT NULL,
  categoria_id INT NOT NULL,
  etiqueta ENUM('tendencia','hombre','mujer','oferta','nuevo','accesorio') DEFAULT 'nuevo',
  activo TINYINT(1) DEFAULT 1,
  creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (categoria_id) REFERENCES categorias(id)
);

CREATE TABLE producto_imagenes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  producto_id INT NOT NULL,
  url VARCHAR(255) NOT NULL,
  orden INT DEFAULT 1,
  FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE
);

CREATE TABLE producto_tallas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  producto_id INT NOT NULL,
  talla VARCHAR(50) NOT NULL,
  stock INT DEFAULT 10,
  FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE
);

CREATE TABLE comentarios (
  id INT AUTO_INCREMENT PRIMARY KEY,
  producto_id INT NOT NULL,
  usuario_id INT NULL,
  nombre VARCHAR(100) NOT NULL,
  comentario TEXT NOT NULL,
  calificacion INT NOT NULL,
  creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE,
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE SET NULL
);

CREATE TABLE carrito (
  id INT AUTO_INCREMENT PRIMARY KEY,
  session_id VARCHAR(128) NULL,
  usuario_id INT NULL,
  producto_id INT NOT NULL,
  talla VARCHAR(50) NULL,
  cantidad INT NOT NULL DEFAULT 1,
  creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
  FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE
);

INSERT INTO categorias(nombre,slug) VALUES ('Tendencias','tendencias');
INSERT INTO categorias(nombre,slug) VALUES ('Hombre','hombre');
INSERT INTO categorias(nombre,slug) VALUES ('Mujer','mujer');
INSERT INTO categorias(nombre,slug) VALUES ('Ofertas','ofertas');
INSERT INTO categorias(nombre,slug) VALUES ('Personalizados','personalizados');
INSERT INTO categorias(nombre,slug) VALUES ('Nuevo','nuevo');
INSERT INTO usuarios(nombre,correo,password_hash,rol) VALUES ('Administrador','admin@tagmoda.com','$2a$10$S7QYzB3LuV1vPPNjEycsme2b/qw8O./dSIUWPI5qnjvfwkdYvFq0K','admin'); -- password: admin123
INSERT INTO productos(slug,nombre,descripcion,precio,categoria_id,etiqueta,activo) VALUES ('chaqueta-negra','Chaqueta Negra','Haz que cualquier outfit se vea más elegante, moderno y con actitud. Inspirada en el estilo urbano y rebelde, esta chaqueta tipo biker combina diseño clásico con acabados premium que destacan al instante; su color negro intenso y los detalles metálicos crean un look versátil perfecto para salir, conducir, tomar fotos o simplemente destacar en cualquier lugar.',799.99,(SELECT id FROM categorias WHERE nombre='Tendencias'),'tendencia',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='chaqueta-negra'),'IMG/ChaquetaO.jpg',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='chaqueta-negra'),'IMG/ChaquetaN.jpg',2);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='chaqueta-negra'),'IMG/ChaquetaN1.jpg',3);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='chaqueta-negra'),'S',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='chaqueta-negra'),'M',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='chaqueta-negra'),'L',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='chaqueta-negra'),'XL',10);
INSERT INTO productos(slug,nombre,descripcion,precio,categoria_id,etiqueta,activo) VALUES ('camiseta-blanca','Camiseta Blanca','La prenda esencial que nunca falla. Minimalista, moderna y fácil de combinar, esta playera básica ofrece un ajuste cómodo y un estilo limpio perfecto para cualquier ocasión; su diseño versátil la convierte en la opción ideal para usar sola o acompañar cualquier outfit urbano, casual o elegante.',249.99,(SELECT id FROM categorias WHERE nombre='Tendencias'),'tendencia',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='camiseta-blanca'),'IMG/CamisetaB.jpg',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='camiseta-blanca'),'IMG/CamisetaB1.jpg',2);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='camiseta-blanca'),'IMG/CamisetaB2.jpg',3);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='camiseta-blanca'),'S',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='camiseta-blanca'),'M',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='camiseta-blanca'),'L',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='camiseta-blanca'),'XL',10);
INSERT INTO productos(slug,nombre,descripcion,precio,categoria_id,etiqueta,activo) VALUES ('jeans-clasicos','Jeans Clásicos','El equilibrio perfecto entre comodidad y estilo urbano. Estos jeans mezclan un diseño moderno con un acabado denim premium que resalta cualquier outfit; su ajuste versátil y detalles desgastados crean un look casual, auténtico y fácil de combinar para el día a día o cualquier ocasión.',549.99,(SELECT id FROM categorias WHERE nombre='Tendencias'),'tendencia',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='jeans-clasicos'),'IMG/JeansC.jpg',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='jeans-clasicos'),'IMG/JeansC1.jpg',2);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='jeans-clasicos'),'IMG/JeansC2.jpg',3);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='jeans-clasicos'),'28',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='jeans-clasicos'),'30',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='jeans-clasicos'),'32',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='jeans-clasicos'),'34',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='jeans-clasicos'),'36',10);
INSERT INTO productos(slug,nombre,descripcion,precio,categoria_id,etiqueta,activo) VALUES ('vestido-elegante','Vestido Elegante','Vestido elegante color vino diseñado para resaltar la figura con un estilo sofisticado y moderno. Su diseño de dos piezas combina un top sin mangas de corte ajustado con una falda de cintura alta que estiliza la silueta y aporta un toque exclusivo. El acabado entallado se complementa con un delicado volante asimétrico que añade movimiento, feminidad y elegancia en cada paso. Ideal para fiestas, cenas, eventos especiales, graduaciones o cualquier ocasión donde quieras destacar con una apariencia refinada, moderna y llena de personalidad. Su intenso tono borgoña transmite lujo, confianza y distinción, convirtiéndolo en una prenda perfecta para lucir espectacular tanto de día como de noche.',899.99,(SELECT id FROM categorias WHERE nombre='Tendencias'),'tendencia',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='vestido-elegante'),'IMG/VestidoElegante.png',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='vestido-elegante'),'IMG/VestidoElegante1.jpg',2);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='vestido-elegante'),'IMG/VestidoElegante2.jpg',3);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='vestido-elegante'),'S',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='vestido-elegante'),'M',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='vestido-elegante'),'L',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='vestido-elegante'),'XL',10);
INSERT INTO productos(slug,nombre,descripcion,precio,categoria_id,etiqueta,activo) VALUES ('sudadera','Sudadera','Sudadera premium color verde oscuro con diseño urbano y moderno, confeccionada para brindar comodidad, estilo y versatilidad en cualquier ocasión. Su corte relajado ofrece un ajuste cómodo ideal para el uso diario, mientras que la capucha amplia y los acabados de alta calidad aportan un look contemporáneo y auténtico. Destaca por su llamativo estampado gráfico en la parte posterior que añade personalidad y carácter a la prenda, convirtiéndola en una opción perfecta para quienes buscan destacar con un estilo streetwear actual. Fácil de combinar con jeans, joggers o pantalones casuales, esta sudadera es ideal para complementar cualquier outfit urbano durante todo el año.',649.99,(SELECT id FROM categorias WHERE nombre='Tendencias'),'tendencia',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='sudadera'),'IMG/Sudadera.png',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='sudadera'),'IMG/Sudadera1.jpg',2);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='sudadera'),'IMG/Sudadera2.jpg',3);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='sudadera'),'S',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='sudadera'),'M',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='sudadera'),'L',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='sudadera'),'XL',10);
INSERT INTO productos(slug,nombre,descripcion,precio,categoria_id,etiqueta,activo) VALUES ('zapatillas-urbanas','Zapatillas Urbanas','Tenis casuales color negro con diseño clásico y versátil, ideales para complementar cualquier outfit urbano o casual. Fabricados con materiales ligeros y cómodos, ofrecen un ajuste seguro gracias a sus agujetas resistentes y una suela de goma flexible que brinda estabilidad y confort durante todo el día. Su combinación de negro con detalles en blanco crea un estilo atemporal que nunca pasa de moda, permitiendo combinarlos fácilmente con jeans, joggers, shorts o prendas deportivas. Perfectos para el uso diario, caminatas, salidas casuales o actividades cotidianas, estos tenis destacan por su comodidad, durabilidad y diseño moderno inspirado en el estilo streetwear.',1199.99,(SELECT id FROM categorias WHERE nombre='Tendencias'),'tendencia',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='zapatillas-urbanas'),'IMG/Zapatillas.jpg',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='zapatillas-urbanas'),'IMG/Zapatillas1.jpg',2);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='zapatillas-urbanas'),'25',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='zapatillas-urbanas'),'26',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='zapatillas-urbanas'),'27',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='zapatillas-urbanas'),'28',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='zapatillas-urbanas'),'29',10);
INSERT INTO productos(slug,nombre,descripcion,precio,categoria_id,etiqueta,activo) VALUES ('ropa-dos-piezas-elegante','Ropa Dos piezas Elegante','Conjunto elegante de dos piezas en tono beige que combina estilo, comodidad y sofisticación. El top corto con tirantes y lazos decorativos aporta un toque femenino y moderno, mientras que el pantalón de cintura alta con detalles de botones estiliza la figura y realza cualquier outfit. Ideal para reuniones, salidas especiales, eventos casuales o cualquier ocasión donde quieras lucir un look elegante, fresco y lleno de personalidad.',949.99,(SELECT id FROM categorias WHERE nombre='Mujer'),'mujer',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='ropa-dos-piezas-elegante'),'IMG/ropa.jpg',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='ropa-dos-piezas-elegante'),'IMG/ropa1.jpg',2);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='ropa-dos-piezas-elegante'),'IMG/ropa2.jpg',3);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='ropa-dos-piezas-elegante'),'S',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='ropa-dos-piezas-elegante'),'M',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='ropa-dos-piezas-elegante'),'L',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='ropa-dos-piezas-elegante'),'XL',10);
INSERT INTO productos(slug,nombre,descripcion,precio,categoria_id,etiqueta,activo) VALUES ('jeans-de-mezclilla','Jeans de Mezclilla','Jeans de mezclilla azul claro con diseño moderno y ajuste favorecedor que combina comodidad y estilo para el uso diario. Su corte versátil realza la silueta de forma natural, mientras que el acabado en denim suave brinda libertad de movimiento y una excelente adaptación al cuerpo. Perfectos para crear looks casuales, urbanos o semiformales, estos jeans son una prenda esencial que combina fácilmente con playeras, blusas, sudaderas o chaquetas para cualquier ocasión.',599.99,(SELECT id FROM categorias WHERE nombre='Mujer'),'mujer',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='jeans-de-mezclilla'),'IMG/jeans-mezclilla.jpg',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='jeans-de-mezclilla'),'IMG/jeans-mezclilla2.jpg',2);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='jeans-de-mezclilla'),'IMG/jeans-mezclilla3.jpg',3);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='jeans-de-mezclilla'),'28',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='jeans-de-mezclilla'),'30',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='jeans-de-mezclilla'),'32',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='jeans-de-mezclilla'),'34',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='jeans-de-mezclilla'),'36',10);
INSERT INTO productos(slug,nombre,descripcion,precio,categoria_id,etiqueta,activo) VALUES ('camisa-vaquera','Camisa Vaquera','Conjunto vaquero estilo western diseñado para destacar con una combinación perfecta de elegancia, actitud y tendencia. Su diseño en mezclilla azul incluye una chaqueta ajustada y short a juego que realzan la silueta, mientras que los detalles metálicos y el cinturón decorativo aportan un toque auténtico y llamativo. Ideal para eventos, fiestas, conciertos, sesiones de fotos o cualquier ocasión donde quieras lucir un look moderno, femenino y lleno de personalidad con inspiración vaquera contemporánea.',449.99,(SELECT id FROM categorias WHERE nombre='Mujer'),'mujer',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='camisa-vaquera'),'IMG/camisa-vaquera.jpg',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='camisa-vaquera'),'IMG/camisa-vaquera-2.jpg',2);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='camisa-vaquera'),'IMG/camisa-vaquera-3.jpg',3);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='camisa-vaquera'),'S',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='camisa-vaquera'),'M',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='camisa-vaquera'),'L',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='camisa-vaquera'),'XL',10);
INSERT INTO productos(slug,nombre,descripcion,precio,categoria_id,etiqueta,activo) VALUES ('traje-blanco','Traje Blanco','Conjunto ejecutivo color blanco diseñado para proyectar elegancia, confianza y sofisticación en cualquier ocasión. Su blazer de corte moderno combinado con pantalón de pierna amplia crea una silueta estilizada y refinada, mientras que los detalles clásicos aportan un toque profesional y atemporal. Ideal para reuniones, eventos, celebraciones o looks de oficina con estilo, este conjunto destaca por su versatilidad, comodidad y apariencia impecable que transmite presencia y buen gusto en cada momento.',1499.99,(SELECT id FROM categorias WHERE nombre='Mujer'),'mujer',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='traje-blanco'),'IMG/traje-blanco.jpg',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='traje-blanco'),'IMG/traje-blanco-2.jpg',2);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='traje-blanco'),'IMG/traje-blanco-3.jpg',3);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='traje-blanco'),'S',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='traje-blanco'),'M',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='traje-blanco'),'L',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='traje-blanco'),'XL',10);
INSERT INTO productos(slug,nombre,descripcion,precio,categoria_id,etiqueta,activo) VALUES ('blusa-encaje','Blusa Encaje','Blusa elegante color azul cielo confeccionada con un diseño ligero y femenino que aporta frescura y sofisticación a cualquier outfit. Sus delicados detalles de encaje en mangas y terminaciones realzan su estilo romántico, mientras que el corte cómodo y versátil permite combinarla fácilmente con jeans, faldas o pantalones de vestir. Ideal para reuniones, salidas casuales, eventos especiales o para lucir un look moderno y elegante en cualquier ocasión.',399.99,(SELECT id FROM categorias WHERE nombre='Mujer'),'mujer',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='blusa-encaje'),'IMG/blusa-encaje.jpg',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='blusa-encaje'),'IMG/blusa-encaje-2.jpg',2);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='blusa-encaje'),'S',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='blusa-encaje'),'M',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='blusa-encaje'),'L',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='blusa-encaje'),'XL',10);
INSERT INTO productos(slug,nombre,descripcion,precio,categoria_id,etiqueta,activo) VALUES ('falda-denim','Falda Denim','Falda de mezclilla azul con diseño juvenil y moderno que aporta un estilo fresco y versátil para cualquier ocasión. Su corte de cintura alta ayuda a estilizar la figura, mientras que el vuelo ligero añade movimiento y un toque femenino al look. Fabricada en denim cómodo y resistente, es perfecta para combinar con blusas, tops o playeras y crear outfits casuales, urbanos o de temporada con un estilo relajado y atractivo.',429.99,(SELECT id FROM categorias WHERE nombre='Mujer'),'mujer',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='falda-denim'),'IMG/falda-denim.jpg',1);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='falda-denim'),'S',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='falda-denim'),'M',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='falda-denim'),'L',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='falda-denim'),'XL',10);
INSERT INTO productos(slug,nombre,descripcion,precio,categoria_id,etiqueta,activo) VALUES ('camiseta-de-verano','Camiseta de verano','Playera premium color negro con diseño minimalista y moderno, confeccionada para ofrecer comodidad, estilo y versatilidad en cualquier ocasión. Su corte ajustado realza la figura mientras que el estampado frontal aporta un toque distintivo y elegante sin perder la esencia urbana. Fabricada con materiales suaves y resistentes, es ideal para combinar con jeans, joggers o prendas deportivas, convirtiéndose en una opción perfecta para quienes buscan un look casual, moderno y lleno de personalidad.',279.99,(SELECT id FROM categorias WHERE nombre='Hombre'),'hombre',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='camiseta-de-verano'),'IMG/camiseta-verano.png',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='camiseta-de-verano'),'IMG/camiseta-verano-2.jpg',2);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='camiseta-de-verano'),'S',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='camiseta-de-verano'),'M',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='camiseta-de-verano'),'L',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='camiseta-de-verano'),'XL',10);
INSERT INTO productos(slug,nombre,descripcion,precio,categoria_id,etiqueta,activo) VALUES ('pantalon-cargo','Pantalón cargo','Chaqueta estilo varsity en tonos verde y negro diseñada para quienes buscan un look urbano, moderno y lleno de actitud. Su combinación de colores, detalles bordados y acabado deportivo aportan un estilo auténtico inspirado en la moda universitaria y streetwear. Con un ajuste cómodo y materiales resistentes, es perfecta para complementar outfits casuales con jeans, cargos o joggers, convirtiéndose en una prenda versátil ideal para el día a día, salidas con amigos o cualquier ocasión donde quieras destacar con personalidad y estilo.',699.99,(SELECT id FROM categorias WHERE nombre='Hombre'),'hombre',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='pantalon-cargo'),'IMG/pantalon-cargo.jpg',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='pantalon-cargo'),'IMG/pantalon-cargo-2.jpg',2);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='pantalon-cargo'),'IMG/pantalon-cargo-3.jpg',3);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='pantalon-cargo'),'28',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='pantalon-cargo'),'30',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='pantalon-cargo'),'32',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='pantalon-cargo'),'34',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='pantalon-cargo'),'36',10);
INSERT INTO productos(slug,nombre,descripcion,precio,categoria_id,etiqueta,activo) VALUES ('conjunto-de-ropa','Conjunto de ropa','Conjunto casual para hombre que combina comodidad, estilo y versatilidad en un diseño moderno y fácil de llevar. La playera negra de corte relajado aporta un aspecto minimalista y elegante, mientras que el short blanco crea un contraste atractivo que destaca en cualquier ocasión. Ideal para salidas casuales, vacaciones, paseos al aire libre o reuniones informales, este conjunto ofrece un look fresco, urbano y contemporáneo que se adapta perfectamente al día a día sin perder estilo.',799.99,(SELECT id FROM categorias WHERE nombre='Hombre'),'hombre',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='conjunto-de-ropa'),'IMG/conjunto-ropa.jpg',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='conjunto-de-ropa'),'IMG/conjunto-ropa-2.jpg',2);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='conjunto-de-ropa'),'IMG/conjunto-ropa-3.jpg',3);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='conjunto-de-ropa'),'S',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='conjunto-de-ropa'),'M',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='conjunto-de-ropa'),'L',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='conjunto-de-ropa'),'XL',10);
INSERT INTO productos(slug,nombre,descripcion,precio,categoria_id,etiqueta,activo) VALUES ('camisa-sin-mangas','Camisa sin mangas','Camiseta sin mangas color negro diseñada para brindar máxima comodidad, frescura y libertad de movimiento en cualquier actividad. Su corte moderno y ligero la convierte en una prenda ideal para entrenamientos, actividades al aire libre o para complementar un look urbano y relajado. Fabricada con materiales suaves y transpirables, ofrece un ajuste cómodo que se adapta al cuerpo sin limitar el movimiento. Su diseño minimalista y versátil permite combinarla fácilmente con jeans, shorts o ropa deportiva para crear un estilo casual, moderno y lleno de personalidad.',329.99,(SELECT id FROM categorias WHERE nombre='Hombre'),'hombre',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='camisa-sin-mangas'),'IMG/camisa-sin-mangas.jpg',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='camisa-sin-mangas'),'IMG/camisa-sin-mangas-2.jpg',2);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='camisa-sin-mangas'),'S',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='camisa-sin-mangas'),'M',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='camisa-sin-mangas'),'L',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='camisa-sin-mangas'),'XL',10);
INSERT INTO productos(slug,nombre,descripcion,precio,categoria_id,etiqueta,activo) VALUES ('pantalon-con-cordon','Pantalón con cordón','Pantalón cargo de mezclilla gris con diseño urbano y moderno, ideal para quienes buscan comodidad sin perder estilo. Sus amplios bolsillos laterales aportan funcionalidad y un aspecto streetwear auténtico, mientras que el ajuste relajado y los puños elásticos brindan mayor comodidad y libertad de movimiento. Fabricado con denim resistente de acabado desgastado, es perfecto para combinar con playeras, sudaderas o chaquetas y crear looks casuales, modernos y llenos de personalidad para cualquier ocasión.',549.99,(SELECT id FROM categorias WHERE nombre='Hombre'),'hombre',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='pantalon-con-cordon'),'IMG/pantalon-cordon.jpg',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='pantalon-con-cordon'),'IMG/pantalon-cordon-2.jpg',2);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='pantalon-con-cordon'),'IMG/pantalon-cordon-3.jpg',3);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='pantalon-con-cordon'),'28',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='pantalon-con-cordon'),'30',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='pantalon-con-cordon'),'32',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='pantalon-con-cordon'),'34',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='pantalon-con-cordon'),'36',10);
INSERT INTO productos(slug,nombre,descripcion,precio,categoria_id,etiqueta,activo) VALUES ('camisa-informal','Camisa informal','Camisa informal color amarillo pastel diseñada para ofrecer frescura, comodidad y un estilo relajado con un toque elegante. Su confección ligera y transpirable la convierte en una prenda ideal para climas cálidos, mientras que los bolsillos frontales y el corte moderno aportan funcionalidad y versatilidad. Perfecta para combinar con pantalones de lino, jeans o bermudas, esta camisa es la elección ideal para reuniones casuales, vacaciones, salidas al aire libre o cualquier ocasión donde quieras lucir un look fresco, sofisticado y lleno de personalidad.',379.99,(SELECT id FROM categorias WHERE nombre='Hombre'),'hombre',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='camisa-informal'),'IMG/camisa-informal.jpg',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='camisa-informal'),'IMG/camisa-informal-2.jpg',2);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='camisa-informal'),'IMG/camisa-informal-3.jpg',3);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='camisa-informal'),'S',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='camisa-informal'),'M',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='camisa-informal'),'L',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='camisa-informal'),'XL',10);
INSERT INTO productos(slug,nombre,descripcion,precio,categoria_id,etiqueta,activo) VALUES ('conjunto-de-bebe','Conjunto de Bebé','Conjunto para bebé diseñado para combinar ternura, comodidad y estilo en una sola prenda. Incluye un body de manga larga con acabado suave y un overol decorado con delicados estampados florales y un elegante lazo frontal que aporta un toque encantador. Su diseño cómodo permite libertad de movimiento mientras mantiene a la pequeña cómoda durante todo el día. Ideal para sesiones de fotos, reuniones familiares, paseos o celebraciones especiales, este conjunto destaca por sus colores delicados y su apariencia adorable que roba todas las miradas.',499.99,(SELECT id FROM categorias WHERE nombre='Ofertas'),'oferta',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='conjunto-de-bebe'),'IMG/conjunto-bebe.jpg',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='conjunto-de-bebe'),'IMG/conjunto-bebe-2.jpg',2);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='conjunto-de-bebe'),'IMG/conjunto-bebe-3.jpg',3);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='conjunto-de-bebe'),'0-3 meses',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='conjunto-de-bebe'),'3-6 meses',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='conjunto-de-bebe'),'6-12 meses',10);
INSERT INTO productos(slug,nombre,descripcion,precio,categoria_id,etiqueta,activo) VALUES ('pantalon-tactico-azul','Pantalón Táctico Azul','Pantalón cargo táctico color azul marino diseñado para ofrecer resistencia, comodidad y funcionalidad en cualquier actividad. Cuenta con múltiples bolsillos de gran capacidad que permiten llevar tus objetos esenciales de forma práctica y segura, mientras que su corte ergonómico brinda libertad de movimiento y un ajuste cómodo durante todo el día. Fabricado con materiales duraderos y de alta calidad, es ideal para trabajo, actividades al aire libre, senderismo, uso táctico o para complementar un look urbano con estilo moderno y robusto.',849.99,(SELECT id FROM categorias WHERE nombre='Ofertas'),'oferta',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='pantalon-tactico-azul'),'IMG/pantalon-tactico.jpg',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='pantalon-tactico-azul'),'IMG/pantalon-tactico-2.jpg',2);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='pantalon-tactico-azul'),'IMG/pantalon-tactico-3.jpg',3);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='pantalon-tactico-azul'),'28',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='pantalon-tactico-azul'),'30',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='pantalon-tactico-azul'),'32',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='pantalon-tactico-azul'),'34',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='pantalon-tactico-azul'),'36',10);
INSERT INTO productos(slug,nombre,descripcion,precio,categoria_id,etiqueta,activo) VALUES ('sombrero','Sombrero','Sombrero de ala ancha color beige diseñado para complementar cualquier outfit con un toque elegante, moderno y sofisticado. Su diseño ligero y cómodo brinda protección contra el sol mientras aporta un estilo versátil ideal para vacaciones, paseos, eventos al aire libre o looks casuales de temporada. El detalle de la banda negra crea un contraste atractivo que realza su apariencia clásica y refinada, convirtiéndolo en el accesorio perfecto para destacar con personalidad y buen gusto en cualquier ocasión.',299.99,(SELECT id FROM categorias WHERE nombre='Ofertas'),'oferta',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='sombrero'),'IMG/Sombrero.jpg',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='sombrero'),'IMG/sombrero-2.jpg',2);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='sombrero'),'IMG/sombrero-3.jpg',3);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='sombrero'),'Pequeño',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='sombrero'),'Mediano',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='sombrero'),'Grande',10);
INSERT INTO productos(slug,nombre,descripcion,precio,categoria_id,etiqueta,activo) VALUES ('kit-8-pares-calcetines','Kit 8 Pares Calcetines','Calcetines deportivos premium diseñados para brindar comodidad, soporte y durabilidad durante todo el día. Fabricados con tejido suave y transpirable, ayudan a mantener los pies frescos y cómodos mientras ofrecen un ajuste seguro que se adapta perfectamente al movimiento. Su diseño reforzado en zonas clave proporciona mayor resistencia al desgaste y una amortiguación adicional para una experiencia más confortable. Ideales para uso diario, actividades deportivas, caminatas o jornadas de trabajo, estos calcetines combinan funcionalidad, calidad y estilo en cada paso.',249.99,(SELECT id FROM categorias WHERE nombre='Ofertas'),'oferta',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='kit-8-pares-calcetines'),'IMG/calcetines.jpg',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='kit-8-pares-calcetines'),'IMG/calcetines-2.jpg',2);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='kit-8-pares-calcetines'),'IMG/calcetines-3.jpg',3);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='kit-8-pares-calcetines'),'Unitalla',10);
INSERT INTO productos(slug,nombre,descripcion,precio,categoria_id,etiqueta,activo) VALUES ('gorra-de-beisbol','Gorra de Béisbol','Gorra de mezclilla estilo vintage diseñada para destacar con un look auténtico, moderno y lleno de personalidad. Su acabado desgastado y los detalles bordados de alta calidad le aportan un carácter único inspirado en la moda urbana contemporánea. Fabricada con materiales resistentes y cómodos, ofrece un ajuste seguro para el uso diario mientras complementa fácilmente cualquier outfit casual o streetwear. Ideal para quienes buscan un accesorio versátil que combine estilo, comodidad y una apariencia llamativa en cualquier ocasión.',349.99,(SELECT id FROM categorias WHERE nombre='Ofertas'),'oferta',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='gorra-de-beisbol'),'IMG/gorra-beisbol.jpg',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='gorra-de-beisbol'),'IMG/gorra-beisbol-2.jpg',2);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='gorra-de-beisbol'),'IMG/gorra-beisbol-3.jpg',3);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='gorra-de-beisbol'),'Pequeño',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='gorra-de-beisbol'),'Mediano',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='gorra-de-beisbol'),'Grande',10);
INSERT INTO productos(slug,nombre,descripcion,precio,categoria_id,etiqueta,activo) VALUES ('gorro-sombrero-tony-chooper','Gorro Sombrero Tony Chooper','Gorro de felpa inspirado en el estilo anime, diseñado para destacar por su apariencia divertida, tierna y llamativa. Fabricado con materiales suaves y acolchados que brindan una sensación cómoda al usarlo, cuenta con detalles característicos que lo convierten en el accesorio perfecto para fanáticos del anime, cosplay o coleccionistas. Ideal para complementar disfraces, sesiones de fotos, eventos temáticos o simplemente para añadir un toque único y original a cualquier colección. Su diseño adorable y color vibrante lo hacen destacar en cualquier ocasión.',399.99,(SELECT id FROM categorias WHERE nombre='Ofertas'),'oferta',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='gorro-sombrero-tony-chooper'),'IMG/gorro-tony.jpg',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='gorro-sombrero-tony-chooper'),'IMG/gorro-tony-2.jpg',2);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='gorro-sombrero-tony-chooper'),'IMG/gorro-tony-3.jpg',3);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='gorro-sombrero-tony-chooper'),'Pequeño',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='gorro-sombrero-tony-chooper'),'Mediano',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='gorro-sombrero-tony-chooper'),'Grande',10);
INSERT INTO productos(slug,nombre,descripcion,precio,categoria_id,etiqueta,activo) VALUES ('bluza','Bluza','Bluza personalizada para mamá diseñada para expresar amor, cariño y momentos inolvidables de una forma única y especial. Su diseño combina fotografías memorables con mensajes emotivos que la convierten en un regalo perfecto para el Día de las Madres, cumpleaños, aniversarios o cualquier ocasión significativa. Confeccionada en tela suave y cómoda para uso diario, esta playera permite llevar los recuerdos más importantes siempre cerca, creando una prenda llena de sentimiento, estilo y valor emocional.',369.99,(SELECT id FROM categorias WHERE nombre='Nuevo'),'nuevo',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='bluza'),'IMG/bluza.jpg',1);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='bluza'),'S',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='bluza'),'M',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='bluza'),'L',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='bluza'),'XL',10);
INSERT INTO productos(slug,nombre,descripcion,precio,categoria_id,etiqueta,activo) VALUES ('playera','Playera','Playera personalizada color gris diseñada para convertir cualquier idea, frase, logo o diseño en una prenda única y original. Confeccionada con tela suave y cómoda para el uso diario, ofrece un ajuste versátil que se adapta a diferentes estilos y ocasiones. Ideal para negocios, eventos, regalos, equipos de trabajo, celebraciones especiales o proyectos creativos, esta playera brinda el espacio perfecto para expresar tu personalidad y crear diseños exclusivos con un acabado moderno y llamativo.',279.99,(SELECT id FROM categorias WHERE nombre='Nuevo'),'nuevo',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='playera'),'IMG/Playera.jpg',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='playera'),'IMG/playera-2.jpg',2);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='playera'),'IMG/playera-3.jpg',3);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='playera'),'S',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='playera'),'M',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='playera'),'L',10);
INSERT INTO producto_tallas(producto_id,talla,stock) VALUES ((SELECT id FROM productos WHERE slug='playera'),'XL',10);
INSERT INTO productos(slug,nombre,descripcion,precio,categoria_id,etiqueta,activo) VALUES ('poster','Poster','Póster decorativo de estilo vintage inspirado en los parques nacionales de Canadá, diseñado para aportar personalidad, elegancia y un toque aventurero a cualquier espacio. Su ilustración detallada de montañas y paisajes naturales, combinada con tipografía clásica en blanco y negro, crea una pieza visual atractiva ideal para amantes de los viajes, la naturaleza y la exploración. Perfecto para decorar salas, oficinas, habitaciones, estudios o espacios creativos, este póster combina diseño artístico y temática natural para transformar cualquier ambiente con un estilo moderno y sofisticado.',199.99,(SELECT id FROM categorias WHERE nombre='Personalizados'),'accesorio',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='poster'),'IMG/posters.jpg',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='poster'),'IMG/posters-2.jpg',2);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='poster'),'IMG/posters-3.jpg',3);
INSERT INTO productos(slug,nombre,descripcion,precio,categoria_id,etiqueta,activo) VALUES ('tazas','Tazas','Taza personalizada de cerámica diseñada para convertir mensajes, frases o diseños especiales en un recuerdo único y significativo. Fabricada con materiales resistentes y de alta calidad, ofrece un acabado brillante que resalta los colores y detalles de cada impresión. Ideal para regalar en cumpleaños, aniversarios, celebraciones especiales o para uso diario, esta taza combina funcionalidad y estilo, permitiendo disfrutar de tus bebidas favoritas mientras expresas tu personalidad o compartes un mensaje lleno de significado.',229.99,(SELECT id FROM categorias WHERE nombre='Personalizados'),'accesorio',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='tazas'),'IMG/tazas.jpg',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='tazas'),'IMG/tazas-2.jpg',2);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='tazas'),'IMG/tazas-3.jpg',3);
INSERT INTO productos(slug,nombre,descripcion,precio,categoria_id,etiqueta,activo) VALUES ('termos','Termos','Termo personalizado de acero inoxidable diseñado para mantener tus bebidas a la temperatura ideal durante más tiempo mientras refleja tu estilo único. Su acabado moderno y elegante permite agregar nombres, frases o diseños personalizados para crear un accesorio exclusivo y funcional. Fabricado con materiales resistentes y duraderos, cuenta con tapa segura para evitar derrames y facilitar su uso diario. Ideal para café, té, agua o bebidas frías, es perfecto para la oficina, viajes, gimnasio, escuela o como un regalo especial para cualquier ocasión.',399.99,(SELECT id FROM categorias WHERE nombre='Personalizados'),'accesorio',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='termos'),'IMG/termos.jpg',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='termos'),'IMG/termos-2.jpg',2);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='termos'),'IMG/termos-3.jpg',3);
INSERT INTO productos(slug,nombre,descripcion,precio,categoria_id,etiqueta,activo) VALUES ('llavero','llavero','Llavero personalizado de acero inoxidable diseñado para conservar tus recuerdos más especiales en un accesorio elegante y duradero. Permite personalizar ambas caras con fotografías, nombres, fechas, frases o mensajes significativos, convirtiéndolo en un regalo único para parejas, amigos o familiares. Su acabado resistente y diseño compacto lo hacen ideal para llevar diariamente en llaves, mochilas o bolsos, manteniendo siempre cerca esos momentos inolvidables que merecen ser recordados.',149.99,(SELECT id FROM categorias WHERE nombre='Personalizados'),'accesorio',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='llavero'),'IMG/llavero.jpg',1);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='llavero'),'IMG/llavero-2.jpg',2);
INSERT INTO producto_imagenes(producto_id,url,orden) VALUES ((SELECT id FROM productos WHERE slug='llavero'),'IMG/llavero-3.jpg',3);