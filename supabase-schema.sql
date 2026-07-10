-- Ejecutá este script completo en Supabase: Panel del proyecto > SQL Editor > New query > pegar y RUN

-- Tabla de reservas
create table if not exists bookings (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  phone text not null,
  service_id text not null,
  service_name text not null,
  price integer not null,
  date date not null,
  time text not null,
  status text not null default 'confirmado',
  created_at timestamptz not null default now()
);

-- Evita que dos personas reserven el mismo horario el mismo día
create unique index if not exists bookings_date_time_unique
  on bookings (date, time)
  where status <> 'cancelado';

-- Tabla de configuración del admin (una sola fila, id = 1)
create table if not exists admin_config (
  id integer primary key default 1,
  password text not null default 'barber2026',
  platform_url text not null default '',
  constraint single_row check (id = 1)
);

insert into admin_config (id, password, platform_url)
values (1, 'barber2026', '')
on conflict (id) do nothing;

-- Seguridad a nivel de fila: habilitada, con acceso público de lectura/escritura
-- (simple y suficiente para este proyecto de un solo local; la clave del panel
-- sigue siendo la que protege el acceso al panel del barbero)
alter table bookings enable row level security;
alter table admin_config enable row level security;

create policy "public read bookings" on bookings for select using (true);
create policy "public insert bookings" on bookings for insert with check (true);
create policy "public update bookings" on bookings for update using (true);
create policy "public delete bookings" on bookings for delete using (true);

create policy "public read admin_config" on admin_config for select using (true);
create policy "public update admin_config" on admin_config for update using (true);
