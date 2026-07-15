-- Quintal Escola — Listas auxiliares (Turmas+Professor, Períodos, Formas de Pagamento)
-- Rode no SQL Editor do Supabase DEPOIS do schema.sql.
-- Gerenciáveis pela tela "Configurações" do app (adicionar/editar/remover).

create table if not exists public.turmas (
  id          uuid primary key default gen_random_uuid(),
  nome        text not null unique,
  professor   text,
  ordem       integer not null default 0,
  created_at  timestamptz not null default now()
);

create table if not exists public.periodos (
  id          uuid primary key default gen_random_uuid(),
  nome        text not null unique,
  ordem       integer not null default 0,
  created_at  timestamptz not null default now()
);

create table if not exists public.formas_pagamento (
  id          uuid primary key default gen_random_uuid(),
  nome        text not null unique,
  ordem       integer not null default 0,
  created_at  timestamptz not null default now()
);

alter table public.turmas enable row level security;
alter table public.periodos enable row level security;
alter table public.formas_pagamento enable row level security;

drop policy if exists "turmas_all_authenticated" on public.turmas;
create policy "turmas_all_authenticated" on public.turmas
  for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

drop policy if exists "periodos_all_authenticated" on public.periodos;
create policy "periodos_all_authenticated" on public.periodos
  for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

drop policy if exists "formas_pagamento_all_authenticated" on public.formas_pagamento;
create policy "formas_pagamento_all_authenticated" on public.formas_pagamento
  for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

-- Carga inicial com os valores que já existiam fixos no sistema.
-- O campo "professor" das turmas fica em branco — preencha pela tela de
-- Configurações do app (não temos como saber hoje qual professor(a) está
-- em cada turma).
insert into public.turmas (nome, ordem) values
  ('Mini Maternal', 0),
  ('Maternal', 1),
  ('Infantil I', 2),
  ('Infantil II', 3),
  ('Pré', 4)
on conflict (nome) do nothing;

insert into public.periodos (nome, ordem) values
  ('Integral', 0),
  ('Matutino', 1),
  ('Vespertino', 2),
  ('Intermediário', 3)
on conflict (nome) do nothing;

insert into public.formas_pagamento (nome, ordem) values
  ('PIX', 0),
  ('Boleto', 1)
on conflict (nome) do nothing;
