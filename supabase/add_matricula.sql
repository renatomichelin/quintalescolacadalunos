-- Quintal Escola — Adiciona campo "Matrícula" ao cadastro de alunos
-- Rode no SQL Editor do Supabase. Pode rodar quantas vezes quiser
-- (o "if not exists" evita erro se a coluna já existir).

alter table public.alunos add column if not exists matricula text;
