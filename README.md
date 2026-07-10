# J. Barber — Plataforma de reservas

## Qué es esto

Una app de reservas para barbería con:
- Sitio público de reservas (catálogo, calendario, horarios)
- Panel del barbero (agenda diaria, reporte financiero, ajustes)
- Aviso al barbero por WhatsApp
- Códigos QR (uno para clientes, otro directo al panel)

Los datos (reservas y contraseña del panel) se guardan en **Supabase**, así que
funcionan igual sin importar quién entre o desde qué dispositivo.

---

## Paso 1 — Crear el proyecto en Supabase (gratis)

1. Entrá a https://supabase.com y creá una cuenta / proyecto nuevo (plan Free).
2. Cuando el proyecto esté listo, andá a **SQL Editor** (menú izquierdo) → **New query**.
3. Abrí el archivo `supabase-schema.sql` de esta carpeta, copiá todo su contenido,
   pegalo ahí y tocá **Run**. Esto crea las tablas `bookings` y `admin_config`.
4. Andá a **Project Settings → API**. Vas a necesitar dos datos de ahí:
   - **Project URL** (algo como `https://xxxxx.supabase.co`)
   - **anon public key** (una clave larga)

---

## Paso 2 — Configurar las variables de entorno

1. Duplicá el archivo `.env.example` y renombralo a `.env`.
2. Pegá ahí tu Project URL y tu anon key:
   ```
   VITE_SUPABASE_URL=https://xxxxx.supabase.co
   VITE_SUPABASE_ANON_KEY=tu-clave-larga
   ```
3. Este archivo `.env` es solo para probar en tu computadora — **no se sube a
   Netlify automáticamente**. En Netlify vas a cargar las mismas dos variables
   por separado (paso 4).

---

## Paso 3 — Subir el proyecto a Netlify

Como no tenés tokens para desplegar por línea de comandos, usá el método sin
terminal (arrastrar y soltar no sirve acá porque este proyecto necesita un
paso de build; hay que conectarlo por Git):

1. Subí esta carpeta a un repositorio en GitHub (podés arrastrar los archivos
   directo en la web de GitHub si no usás git desde la terminal: "Add file" →
   "Upload files").
2. En Netlify: **Add new site → Import an existing project → GitHub** →
   elegí el repositorio.
3. Netlify va a detectar solo el comando de build (`npm run build`) y la
   carpeta `dist` gracias al archivo `netlify.toml` incluido. No hace falta
   tocar nada ahí.

---

## Paso 4 — Cargar las variables de entorno en Netlify

1. En el sitio ya creado en Netlify: **Site configuration → Environment
   variables → Add a variable**.
2. Agregá las mismas dos del paso 2:
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_ANON_KEY`
3. Volvé a **Deploys** y tocá **Trigger deploy → Deploy site** para que
   Netlify vuelva a construir el sitio con esas variables ya cargadas.

---

## Paso 5 — Actualizar los códigos QR

Una vez publicado vas a tener una URL real, por ejemplo
`https://jbarber.netlify.app/`.

1. Entrá a tu sitio → botón **Barbero** → contraseña `barber2026`.
2. Andá a la pestaña **Compartir**.
3. Pegá tu URL real de Netlify en el campo "Link de la plataforma" y tocá
   **Guardar**.
4. Los dos QR (el de clientes y el del panel) se regeneran solos apuntando
   a la dirección correcta. Descargalos e imprimilos.

No olvides cambiar la contraseña por defecto desde **Ajustes** apenas
entres por primera vez.

---

## Notas

- El botón de WhatsApp usa el número `+56 9 3592 9811`. Para cambiarlo,
  editá la constante `BARBER_WHATSAPP` en `src/App.jsx`.
- La contraseña del panel se guarda en la tabla `admin_config` de Supabase,
  en texto plano — suficiente para este proyecto de un solo local, pero
  tenelo en cuenta si más adelante lo hacés multi-sucursal o con más gente
  con acceso a la base de datos.
