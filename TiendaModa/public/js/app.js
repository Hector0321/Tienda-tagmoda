document.addEventListener('DOMContentLoaded', () => {
  const enPagina = location.pathname.includes('/paginas/');
  const base = enPagina ? '../' : '';
  const productoUrl = enPagina ? 'Producto.html' : 'paginas/Producto.html';
  const carritoUrl = enPagina ? 'Carrito.html' : 'paginas/Carrito.html';

  const textoEtiqueta = {tendencia:'Tendencia',hombre:'Hombre',mujer:'Mujer',oferta:'Oferta',nuevo:'Nuevo',accesorio:'Accesorio'};
  function rutaImg(src){ if(!src) return base+'IMG/etiquetaprecio.png'; if(src.startsWith('http') || src.startsWith('data:')) return src; return base + src.replace(/^\.\.\//,''); }
  async function api(url, opciones={}){ const r=await fetch(url,{headers:{'Content-Type':'application/json'},...opciones}); if(!r.ok) throw await r.json().catch(()=>({error:'Error'})); return r.json(); }
  function precio(n){ return '$' + Number(n).toFixed(2) + ' MXN'; }

  // Modo oscuro
  const toggleBtn = document.createElement('button');
  toggleBtn.innerHTML = localStorage.getItem('modo') === 'oscuro' ? '☀️' : '🌙';
  toggleBtn.className = 'modo-btn';
  document.body.appendChild(toggleBtn);
  if(localStorage.getItem('modo') === 'oscuro') document.body.classList.add('dark-mode');
  toggleBtn.addEventListener('click',()=>{document.body.classList.toggle('dark-mode'); const oscuro=document.body.classList.contains('dark-mode'); localStorage.setItem('modo',oscuro?'oscuro':'claro'); toggleBtn.innerHTML=oscuro?'☀️':'🌙';});

  function crearBuscador(){
    const main=document.querySelector('main') || document.body;
    if(document.querySelector('.buscador-tienda')) return;
    const box=document.createElement('div'); box.className='buscador-tienda';
    box.innerHTML=`<input id="buscador-productos" type="search" placeholder="Buscar productos..."><button id="btn-buscar">Buscar</button>`;
    main.insertBefore(box, main.firstChild);
    document.getElementById('btn-buscar').addEventListener('click',()=>cargarProductos({q:document.getElementById('buscador-productos').value}));
    document.getElementById('buscador-productos').addEventListener('keyup',e=>{ if(e.key==='Enter') cargarProductos({q:e.target.value}); });
  }

  function cardProducto(p){
    const div=document.createElement('div'); div.className='producto'; div.dataset.id=p.slug; div.dataset.etiqueta=p.etiqueta;
    div.innerHTML=`<span class="tag ${p.etiqueta}">${textoEtiqueta[p.etiqueta] || 'Nuevo'}</span><img src="${rutaImg(p.imagen)}" alt="${p.nombre}"><h3>${p.nombre}</h3><p>${precio(p.precio)}</p><button class="ver-producto">Ver producto</button><button class="agregar-directo">Añadir al carrito</button>`;
    div.querySelector('.ver-producto').addEventListener('click',()=>location.href=`${productoUrl}?id=${encodeURIComponent(p.slug)}`);
    div.querySelector('img').addEventListener('click',()=>location.href=`${productoUrl}?id=${encodeURIComponent(p.slug)}`);
    div.querySelector('.agregar-directo').addEventListener('click',async()=>{ await api('/api/carrito',{method:'POST',body:JSON.stringify({producto_id:p.id,talla:p.tallas?.[0] || null,cantidad:1})}); alert('Producto agregado al carrito'); });
    return div;
  }

  async function cargarProductos(filtros={}){
    const contenedores=[...document.querySelectorAll('.productos')];
    if(!contenedores.length) return;
    let categoria='';
    const path=location.pathname.toLowerCase();
    if(path.includes('hombre')) categoria='hombre';
    if(path.includes('mujer')) categoria='mujer';
    if(path.includes('ofertas')) categoria='ofertas';
    if(path.includes('personalizados')) categoria='personalizados';
    const params=new URLSearchParams();
    if(categoria) params.set('categoria',categoria);
    if(filtros.q) params.set('q',filtros.q);
    const productos=await api('/api/productos?'+params.toString());
    // index: separa tendencias en las dos secciones; páginas: usa todo.
    if(!categoria && contenedores.length>1 && !filtros.q){
      const destacados=productos.filter(p=>['tendencia','nuevo'].includes(p.etiqueta)).slice(0,3);
      const tendencias=productos.filter(p=>p.etiqueta==='tendencia').slice(3,6);
      contenedores[0].innerHTML=''; destacados.forEach(p=>contenedores[0].appendChild(cardProducto(p)));
      contenedores[1].innerHTML=''; (tendencias.length?tendencias:productos.slice(3,6)).forEach(p=>contenedores[1].appendChild(cardProducto(p)));
    } else {
      const target=contenedores[0]; target.innerHTML=''; productos.forEach(p=>target.appendChild(cardProducto(p)));
    }
  }

  async function cargarDetalle(){
    const det=document.getElementById('detalle-producto'); if(!det) return;
    const slug=new URLSearchParams(location.search).get('id');
    if(!slug){ det.innerHTML='<h2>Producto no encontrado</h2>'; return; }
    const p=await api('/api/productos/'+encodeURIComponent(slug));
    const imagenes=p.imagenes?.length ? p.imagenes : [p.imagen];
    const tallas=p.tallas || [];
    det.innerHTML=`<article class="detalle-producto"><div><img id="imagen-principal" class="detalle-img" src="${rutaImg(imagenes[0])}" alt="${p.nombre}"><div class="miniaturas"></div></div><div class="detalle-info">
    <div class="titulo-producto">
        <span class="tag tag-detalle ${p.etiqueta}">
            ${textoEtiqueta[p.etiqueta] || 'Nuevo'}
        </span>
        <h1>${p.nombre}</h1>
    </div><p class="precio-detalle">${precio(p.precio)}</p><p>${p.descripcion}</p><div id="zona-tallas"></div><button id="btn-comprar">Comprar ahora</button><button id="btn-agregar">Agregar a carrito</button></div></article><section class="comentarios-producto"><h2>Reseñas del producto</h2><form id="form-comentario"><select name="calificacion"><option value="5">★★★★★ 5</option><option value="4">★★★★ 4</option><option value="3">★★★ 3</option><option value="2">★★ 2</option><option value="1">★ 1</option></select><textarea name="comentario" placeholder="Escribe tu reseña" required></textarea><button>Publicar reseña</button></form><div id="lista-comentarios"></div></section>`;
    const mini=document.querySelector('.miniaturas'); imagenes.forEach(img=>{ const im=document.createElement('img'); im.src=rutaImg(img); im.className='miniatura'; im.onclick=()=>document.getElementById('imagen-principal').src=rutaImg(img); mini.appendChild(im); });
    if(tallas.length){ document.getElementById('zona-tallas').innerHTML='<label>Selecciona talla/tamaño:</label><select id="select-talla">'+tallas.map(t=>`<option value="${t}">${t}</option>`).join('')+'</select>'; }
    async function agregar(){ await api('/api/carrito',{method:'POST',body:JSON.stringify({producto_id:p.id,talla:document.getElementById('select-talla')?.value || null,cantidad:1})}); alert('Producto agregado al carrito'); }
    document.getElementById('btn-agregar').onclick=agregar; document.getElementById('btn-comprar').onclick=async()=>{ await agregar(); location.href=carritoUrl; };
    document.getElementById('form-comentario').onsubmit=async e=>{ e.preventDefault(); const fd=new FormData(e.target); await api('/api/comentarios/'+encodeURIComponent(slug),{method:'POST',body:JSON.stringify(Object.fromEntries(fd))}); e.target.reset(); cargarComentarios(slug); };
    cargarComentarios(slug);
  }
  async function cargarComentarios(slug){
    const box=document.getElementById('lista-comentarios'); if(!box) return;
    const comentarios=await api('/api/comentarios/'+encodeURIComponent(slug));
    box.innerHTML = comentarios.length ? comentarios.map(c=>`<div class="comentario"><strong>${c.nombre}</strong> <span>${'★'.repeat(c.calificacion)}</span><p>${c.comentario}</p><small>${new Date(c.creado_en).toLocaleString()}</small></div>`).join('') : '<p>Aún no hay reseñas. Sé el primero en comentar.</p>';
  }

  async function cargarCarrito(){
    const lista=document.getElementById('lista-carrito'); if(!lista) return;
    const items=await api('/api/carrito'); let total=0;
    lista.innerHTML='';
    if(!items.length) lista.innerHTML='<p>Tu carrito está vacío.</p>';
    items.forEach(it=>{ total += Number(it.precio)*it.cantidad; const row=document.createElement('div'); row.className='item-carrito'; row.innerHTML=`<img src="${rutaImg(it.imagen)}"><div><h3>${it.nombre}</h3><p>${it.precioTexto}</p><p>Talla/Tamaño: ${it.talla || 'No aplica'} · Cantidad: ${it.cantidad}</p></div><button>Eliminar</button>`; row.querySelector('button').onclick=async()=>{await api('/api/carrito/'+it.id,{method:'DELETE'}); cargarCarrito();}; lista.appendChild(row); });
    const totalEl=document.getElementById('total-carrito'); if(totalEl) totalEl.textContent=precio(total);
    const vaciar=document.getElementById('vaciar-carrito'); if(vaciar) vaciar.onclick=async()=>{await api('/api/carrito',{method:'DELETE'}); cargarCarrito();};
  }

  async function cuenta(){
    const cont=document.getElementById('cuenta-app'); if(!cont) return;
    const ses=await api('/api/sesion');
    if(ses.usuario){ cont.innerHTML=`<h2>Mi cuenta</h2><p>Sesión iniciada como <b>${ses.usuario.nombre}</b> (${ses.usuario.rol})</p>${ses.usuario.rol==='admin'?'<p><a href="Admin.html"><button>Panel administrador</button></a></p>':''}<button id="logout">Cerrar sesión</button>`; document.getElementById('logout').onclick=async()=>{await api('/api/logout',{method:'POST'}); location.reload();}; return; }
    cont.innerHTML=`<h2>Iniciar sesión</h2><form id="login"><input name="correo" type="email" placeholder="Correo" required><input name="password" type="password" placeholder="Contraseña" required><button>Entrar</button></form><h2>Crear cuenta</h2><form id="registro"><input name="nombre" placeholder="Nombre" required><input name="correo" type="email" placeholder="Correo" required><input name="password" type="password" placeholder="Contraseña mínimo 6" required><button>Registrarme</button></form><p class="admin-info">
    Administrador:<br>
    Correo: hectoralbertoarjonaalcocer@gmail.com<br>
    Contraseña: root123
</p>`;
    document.getElementById('login').onsubmit=async e=>{ e.preventDefault(); try{await api('/api/login',{method:'POST',body:JSON.stringify(Object.fromEntries(new FormData(e.target)))}); location.reload();}catch(err){alert(err.error||'Error');} };
    document.getElementById('registro').onsubmit=async e=>{ e.preventDefault(); try{await api('/api/registro',{method:'POST',body:JSON.stringify(Object.fromEntries(new FormData(e.target)))}); alert('Cuenta creada. Ahora inicia sesión.');}catch(err){alert(err.error||'Error');} };
  }

  async function admin(){
    const app=document.getElementById('admin-app'); if(!app) return;
    const cats=await api('/api/categorias');
    const productos=await api('/api/productos');
    app.innerHTML=`<h2>Panel administrador</h2><p>Desde aquí insertas, modificas y borras productos en MySQL.</p><form id="form-producto"><input type="hidden" name="id"><input name="nombre" placeholder="Nombre del producto" required><input name="precio" type="number" step="0.01" placeholder="Precio" required><select name="categoria_id">${cats.map(c=>`<option value="${c.id}">${c.nombre}</option>`).join('')}</select><select name="etiqueta"><option value="nuevo">Nuevo</option><option value="tendencia">Tendencia</option><option value="hombre">Hombre</option><option value="mujer">Mujer</option><option value="oferta">Oferta</option><option value="accesorio">Accesorio</option></select><textarea name="descripcion" placeholder="Descripción" required></textarea><textarea name="imagenes" placeholder="Rutas de imágenes, una por línea. Ej: IMG/playera.jpg"></textarea><input name="tallas" placeholder="Tallas separadas por coma. Ej: S,M,L,XL"><label><input type="checkbox" name="activo" checked> Activo</label><button>Guardar producto</button></form><h2>Productos registrados</h2><div class="tabla-responsive"><table><thead><tr><th>ID</th><th>Producto</th><th>Precio</th><th>Categoría</th><th>Acciones</th></tr></thead><tbody>${productos.map(p=>`<tr><td>${p.id}</td><td>${p.nombre}</td><td>${precio(p.precio)}</td><td>${p.categoria}</td><td><button class="editar" data-id="${p.id}">Editar</button><button class="eliminar" data-id="${p.id}">Eliminar</button></td></tr>`).join('')}</tbody></table></div>`;
    document.getElementById('form-producto').onsubmit=async e=>{ e.preventDefault(); const fd=Object.fromEntries(new FormData(e.target)); fd.activo=fd.activo==='on'; fd.imagenes=fd.imagenes.split('\n').map(x=>x.trim()).filter(Boolean); fd.tallas=fd.tallas.split(',').map(x=>x.trim()).filter(Boolean); try{ if(fd.id) await api('/api/productos/'+fd.id,{method:'PUT',body:JSON.stringify(fd)}); else await api('/api/productos',{method:'POST',body:JSON.stringify(fd)}); alert('Guardado'); location.reload(); }catch(err){ alert((err.errores||[err.error||'Error']).join('\n')); } };
    app.querySelectorAll('.eliminar').forEach(b=>b.onclick=async()=>{ if(confirm('¿Eliminar producto?')){ await api('/api/productos/'+b.dataset.id,{method:'DELETE'}); location.reload(); }});
    app.querySelectorAll('.editar').forEach(b=>b.onclick=async()=>{ const p=productos.find(x=>x.id==b.dataset.id); const f=document.getElementById('form-producto'); f.id.value=p.id; f.nombre.value=p.nombre; f.precio.value=p.precio; f.categoria_id.value=cats.find(c=>c.nombre===p.categoria)?.id || cats[0].id; f.etiqueta.value=p.etiqueta; f.descripcion.value=p.descripcion; f.imagenes.value=p.imagenes.join('\n'); f.tallas.value=p.tallas.join(','); window.scrollTo({top:0,behavior:'smooth'}); });
  }

  if(!location.pathname.toLowerCase().includes('producto')){
    crearBuscador();
}
  cargarProductos().catch(()=>{});
  cargarDetalle().catch(e=>console.error(e));
  cargarCarrito().catch(e=>console.error(e));
  cuenta().catch(e=>console.error(e));
  admin().catch(e=>console.error(e));
});
