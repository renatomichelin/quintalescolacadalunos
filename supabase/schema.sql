-- Quintal Escola — Cadastro de Alunos
-- Schema da tabela principal + segurança (RLS)
-- Rode este arquivo primeiro no SQL Editor do Supabase (Database > SQL Editor > New query)

create extension if not exists pgcrypto;

create table if not exists public.alunos (
  id          uuid primary key default gen_random_uuid(),
  nome        text not null,
  ra          text,
  numero      text,
  status      text not null default 'Ativo',
  periodo     text,
  nasc        date,
  turma       text,
  professor   text,
  inicio      date,
  termino     date,
  pagto       text,
  vcto        integer,
  valor       numeric(10,2) default 0,
  obs         text,
  resp1       text,
  cpf         text,
  "end"       text,
  cep         text,
  email1      text,
  fone_res1   text,
  fone        text,
  resp2       text,
  email2      text,
  fone_res2   text,
  fone2       text,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create index if not exists alunos_nome_idx   on public.alunos (nome);
create index if not exists alunos_status_idx on public.alunos (status);

-- mantém updated_at sempre atualizado
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists trg_alunos_updated_at on public.alunos;
create trigger trg_alunos_updated_at
before update on public.alunos
for each row execute function public.set_updated_at();

-- ══════════════════════════════════════════════════════════
-- SEGURANÇA (RLS)
-- O app usa a "anon key" (pública) no HTML. Sem RLS, qualquer
-- pessoa com a URL do site conseguiria ler/editar/apagar os
-- dados (CPF, telefone, endereço) de todos os alunos.
-- Com RLS habilitado, só usuários autenticados (login feito
-- pela tela do app via Supabase Auth) podem acessar a tabela.
-- ══════════════════════════════════════════════════════════
alter table public.alunos enable row level security;

drop policy if exists "alunos_select_authenticated" on public.alunos;
create policy "alunos_select_authenticated" on public.alunos
  for select using (auth.role() = 'authenticated');

drop policy if exists "alunos_insert_authenticated" on public.alunos;
create policy "alunos_insert_authenticated" on public.alunos
  for insert with check (auth.role() = 'authenticated');

drop policy if exists "alunos_update_authenticated" on public.alunos;
create policy "alunos_update_authenticated" on public.alunos
  for update using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

drop policy if exists "alunos_delete_authenticated" on public.alunos;
create policy "alunos_delete_authenticated" on public.alunos
  for delete using (auth.role() = 'authenticated');
