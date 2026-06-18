const express = require('express');
const session = require('express-session');
const bcrypt = require('bcryptjs');
const path = require('path');
const pool = require('./db');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json({limit:'3mb'}));
app.use(express.urlencoded({extended:true}));
app.use(session({
  secret: process.env.SESSION_SECRET || 'tagmoda_dev_secret',
  resave: false,
  saveUninitialized: true,
  cookie: { httpOnly: true, maxAge: 1000 * 60 * 60 * 24 }
}));
app.use(express.static(path.join(__dirname, 'public')));

function requireAdmin(req,res,next){
  if(req.session.usuario && req.session.usuario.rol === 'admin') return next();
  return res.status(403).json({error:'Solo administrador'});
}
function requireLogin(req,res,next){
  if(req.session.usuario) return next();
  return res.status(401).json({error:'Inicia sesión'});
}
function validarProducto(body){
  const errores=[];
  if(!body.nombre || body.nombre.trim().length < 3) errores.push('El nombre debe tener mínimo 3 caracteres.');
  if(!body.descripcion || body.descripcion.trim().length < 10) errores.push('La descripción debe tener mínimo 10 caracteres.');
  if(!body.precio || Number(body.precio) <= 0) errores.push('El precio debe ser mayor a 0.');
  if(!body.categoria_id) errores.push('Selecciona una categoría.');
  return errores;
}
async function armarProductos(rows){
  if(rows.length === 0) return [];
  const ids = rows.map(r => r.id);
  const [imgs] = await pool.query('SELECT producto_id,url FROM producto_imagenes WHERE producto_id IN (?) ORDER BY orden,id',[ids]);
  const [tallas] = await pool.query('SELECT producto_id,talla,stock FROM producto_tallas WHERE producto_id IN (?) ORDER BY id',[ids]);
  return rows.map(p => ({
    ...p,
    precioTexto: `$${Number(p.precio).toFixed(2)} MXN`,
    imagenes: imgs.filter(i=>i.producto_id===p.id).map(i=>i.url),
    imagen: (imgs.find(i=>i.producto_id===p.id)||{}).url || 'IMG/etiquetaprecio.png',
    tallas: tallas.filter(t=>t.producto_id===p.id).map(t=>t.talla)
  }));
}

app.get('/api/sesion', (req,res)=> res.json({usuario:req.session.usuario || null}));
app.post('/api/registro', async (req,res)=>{
  const {nombre,correo,password} = req.body;
  if(!nombre || !correo || !password || password.length < 6) return res.status(400).json({error:'Datos incompletos o contraseña muy corta.'});
  try{
    const hash = await bcrypt.hash(password, 10);
    await pool.query('INSERT INTO usuarios(nombre,correo,password_hash,rol) VALUES (?,?,?,?)',[nombre,correo,hash,'cliente']);
    res.json({ok:true});
  }catch(e){ res.status(400).json({error:'No se pudo registrar. Tal vez el correo ya existe.'}); }
});
app.post('/api/login', async (req,res)=>{
  const {correo,password}=req.body;
  const [rows] = await pool.query('SELECT * FROM usuarios WHERE correo=?',[correo]);
  if(rows.length===0) return res.status(401).json({error:'Correo o contraseña incorrectos.'});
  const user=rows[0];
  const ok=await bcrypt.compare(password, user.password_hash);
  if(!ok) return res.status(401).json({error:'Correo o contraseña incorrectos.'});
  req.session.usuario={id:user.id,nombre:user.nombre,correo:user.correo,rol:user.rol};
  res.json({ok:true,usuario:req.session.usuario});
});
app.post('/api/logout',(req,res)=> req.session.destroy(()=>res.json({ok:true})));

app.get('/api/categorias', async (req,res)=>{
  const [rows]=await pool.query('SELECT * FROM categorias ORDER BY nombre');
  res.json(rows);
});
app.get('/api/productos', async (req,res)=>{
  const {categoria, q, etiqueta} = req.query;
  let sql = `SELECT p.*, c.nombre categoria, c.slug categoria_slug FROM productos p JOIN categorias c ON c.id=p.categoria_id WHERE p.activo=1`;
  const params=[];
  if(categoria){ sql += ' AND c.slug=?'; params.push(categoria); }
  if(etiqueta){ sql += ' AND p.etiqueta=?'; params.push(etiqueta); }
  if(q){ sql += ' AND (p.nombre LIKE ? OR p.descripcion LIKE ?)'; params.push(`%${q}%`,`%${q}%`); }
  sql += ' ORDER BY p.id DESC';
  const [rows] = await pool.query(sql, params);
  res.json(await armarProductos(rows));
});
app.get('/api/productos/:slug', async (req,res)=>{
  const [rows]=await pool.query(`SELECT p.*, c.nombre categoria, c.slug categoria_slug FROM productos p JOIN categorias c ON c.id=p.categoria_id WHERE p.slug=? AND p.activo=1`,[req.params.slug]);
  if(rows.length===0) return res.status(404).json({error:'Producto no encontrado'});
  const producto=(await armarProductos(rows))[0];
  res.json(producto);
});
app.post('/api/productos', requireAdmin, async (req,res)=>{
  const errores=validarProducto(req.body);
  if(errores.length) return res.status(400).json({errores});
  const {slug,nombre,descripcion,precio,categoria_id,etiqueta='nuevo',activo=1}=req.body;
  const imagenes = Array.isArray(req.body.imagenes) ? req.body.imagenes : String(req.body.imagenes||'').split('\n').filter(Boolean);
  const tallas = Array.isArray(req.body.tallas) ? req.body.tallas : String(req.body.tallas||'').split(',').map(x=>x.trim()).filter(Boolean);
  const conn=await pool.getConnection();
  try{
    await conn.beginTransaction();
    const slugFinal = (slug || nombre).toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g,'').replace(/[^a-z0-9]+/g,'-').replace(/^-|-$/g,'');
    const [r]=await conn.query('INSERT INTO productos(slug,nombre,descripcion,precio,categoria_id,etiqueta,activo) VALUES (?,?,?,?,?,?,?)',[slugFinal,nombre,descripcion,precio,categoria_id,etiqueta,activo?1:0]);
    for(let i=0;i<imagenes.length;i++) await conn.query('INSERT INTO producto_imagenes(producto_id,url,orden) VALUES (?,?,?)',[r.insertId,imagenes[i],i+1]);
    for(const t of tallas) await conn.query('INSERT INTO producto_tallas(producto_id,talla,stock) VALUES (?,?,10)',[r.insertId,t]);
    await conn.commit(); res.json({ok:true,id:r.insertId});
  }catch(e){ await conn.rollback(); res.status(400).json({error:'No se pudo guardar el producto. Revisa que el slug no esté repetido.'}); }
  finally{ conn.release(); }
});
app.put('/api/productos/:id', requireAdmin, async (req,res)=>{
  const errores=validarProducto(req.body);
  if(errores.length) return res.status(400).json({errores});
  const id=req.params.id;
  const {nombre,descripcion,precio,categoria_id,etiqueta='nuevo',activo=1}=req.body;
  const imagenes = Array.isArray(req.body.imagenes) ? req.body.imagenes : String(req.body.imagenes||'').split('\n').filter(Boolean);
  const tallas = Array.isArray(req.body.tallas) ? req.body.tallas : String(req.body.tallas||'').split(',').map(x=>x.trim()).filter(Boolean);
  const conn=await pool.getConnection();
  try{
    await conn.beginTransaction();
    await conn.query('UPDATE productos SET nombre=?,descripcion=?,precio=?,categoria_id=?,etiqueta=?,activo=? WHERE id=?',[nombre,descripcion,precio,categoria_id,etiqueta,activo?1:0,id]);
    await conn.query('DELETE FROM producto_imagenes WHERE producto_id=?',[id]);
    await conn.query('DELETE FROM producto_tallas WHERE producto_id=?',[id]);
    for(let i=0;i<imagenes.length;i++) await conn.query('INSERT INTO producto_imagenes(producto_id,url,orden) VALUES (?,?,?)',[id,imagenes[i],i+1]);
    for(const t of tallas) await conn.query('INSERT INTO producto_tallas(producto_id,talla,stock) VALUES (?,?,10)',[id,t]);
    await conn.commit(); res.json({ok:true});
  }catch(e){ await conn.rollback(); res.status(400).json({error:'No se pudo actualizar.'}); }
  finally{ conn.release(); }
});
app.delete('/api/productos/:id', requireAdmin, async (req,res)=>{
  await pool.query('DELETE FROM productos WHERE id=?',[req.params.id]);
  res.json({ok:true});
});

app.get('/api/comentarios/:slug', async (req,res)=>{
  const [p]=await pool.query('SELECT id FROM productos WHERE slug=?',[req.params.slug]);
  if(!p.length) return res.json([]);
  const [rows]=await pool.query('SELECT * FROM comentarios WHERE producto_id=? ORDER BY creado_en DESC',[p[0].id]);
  res.json(rows);
});
app.post('/api/comentarios/:slug', async (req,res)=>{
  const {nombre,comentario,calificacion}=req.body;
  if(!comentario || comentario.length<5) return res.status(400).json({error:'Escribe un comentario más completo.'});
  const cal=Number(calificacion||5);
  if(cal<1 || cal>5) return res.status(400).json({error:'La calificación debe ser de 1 a 5.'});
  const [p]=await pool.query('SELECT id FROM productos WHERE slug=?',[req.params.slug]);
  if(!p.length) return res.status(404).json({error:'Producto no encontrado'});
  await pool.query('INSERT INTO comentarios(producto_id,usuario_id,nombre,comentario,calificacion) VALUES (?,?,?,?,?)',[p[0].id, req.session.usuario?.id || null, req.session.usuario?.nombre || nombre || 'Cliente', comentario, cal]);
  res.json({ok:true});
});

app.get('/api/carrito', async (req,res)=>{
  const usuario_id=req.session.usuario?.id || null;
  const session_id=req.sessionID;
  const [rows]=await pool.query(`SELECT ca.*, p.slug,p.nombre,p.precio, (SELECT url FROM producto_imagenes WHERE producto_id=p.id ORDER BY orden,id LIMIT 1) imagen FROM carrito ca JOIN productos p ON p.id=ca.producto_id WHERE (ca.usuario_id=? OR ca.session_id=?)`,[usuario_id,session_id]);
  res.json(rows.map(x=>({...x, precioTexto:`$${Number(x.precio).toFixed(2)} MXN`}))); 
});
app.post('/api/carrito', async (req,res)=>{
  const {producto_id,talla,cantidad=1}=req.body;
  const usuario_id=req.session.usuario?.id || null;
  const session_id=req.sessionID;
  if(!producto_id) return res.status(400).json({error:'Falta producto'});
  const [exist]=await pool.query('SELECT id,cantidad FROM carrito WHERE producto_id=? AND IFNULL(talla,"")=IFNULL(?,"") AND (usuario_id=? OR session_id=?)',[producto_id,talla||null,usuario_id,session_id]);
  if(exist.length) await pool.query('UPDATE carrito SET cantidad=cantidad+? WHERE id=?',[cantidad,exist[0].id]);
  else await pool.query('INSERT INTO carrito(session_id,usuario_id,producto_id,talla,cantidad) VALUES (?,?,?,?,?)',[session_id,usuario_id,producto_id,talla||null,cantidad]);
  res.json({ok:true});
});
app.delete('/api/carrito/:id', async (req,res)=>{
  await pool.query('DELETE FROM carrito WHERE id=? AND (usuario_id=? OR session_id=?)',[req.params.id, req.session.usuario?.id || null, req.sessionID]);
  res.json({ok:true});
});
app.delete('/api/carrito', async (req,res)=>{
  await pool.query('DELETE FROM carrito WHERE usuario_id=? OR session_id=?',[req.session.usuario?.id || null, req.sessionID]);
  res.json({ok:true});
});

app.listen(PORT, ()=> console.log(`Tag Moda corriendo en http://localhost:${PORT}`));
