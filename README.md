# Quintal Escola — Cadastro de Alunos

Aplicação estática (HTML/JS puro) para cadastro e gestão de alunos, com dados
armazenados no [Supabase](https://supabase.com) e publicação no
[Netlify](https://netlify.com).

## Estrutura

```
index.html            → aplicação completa (front-end estático)
netlify.toml           → configuração de deploy no Netlify
supabase/schema.sql     → estrutura da tabela `alunos` + segurança (RLS)
supabase/seed_alunos.sql → carga inicial com os 232 registros já existentes
```

Este repositório é **privado** porque `supabase/seed_alunos.sql` contém dados
pessoais reais de alunos e responsáveis (CPF, telefone, e-mail, endereço).
Não torne o repositório público sem remover esse arquivo do histórico do git.

## 1. Configurar o Supabase

Estes passos usam o **SQL Editor** do painel do Supabase
(`Database` → `SQL Editor` → `New query`):

1. Rode todo o conteúdo de `supabase/schema.sql`.
2. Rode todo o conteúdo de `supabase/seed_alunos.sql` (carrega os 232 alunos).
3. Em `Authentication → Users → Add user`, crie um usuário (e-mail + senha)
   para cada pessoa da equipe que vai acessar o sistema. É esse login que
   protege os dados — sem ele, ninguém consegue ler ou editar a tabela
   `alunos` (a RLS criada no passo 1 exige usuário autenticado).
4. Em `Settings → API`, copie:
   - **Project URL**
   - **anon / public key**

## 2. Ligar o app ao Supabase

Abra `index.html` e preencha as duas constantes no início do `<script>`:

```js
const SUPA_URL  = 'https://xxxxxxxxxxxx.supabase.co';
const SUPA_KEY  = 'sua-anon-key-aqui';
```

A `anon key` é pública por design (é o que o Supabase espera que fique no
front-end) — quem protege os dados é a Row Level Security (RLS) configurada
em `schema.sql`, não o sigilo dessa chave. **Nunca** coloque a `service_role
key` aqui.

Depois de preencher, faça commit e push — ver seção 4.

## 3. Publicar no Netlify

No painel do Netlify:

1. **Add new site → Import an existing project**.
2. Escolha este repositório GitHub (`quintalescolacadalunos`).
3. Build command: deixe em branco. Publish directory: `.`
   (o `netlify.toml` já traz essa configuração pronta).
4. Deploy. A partir daí, todo `git push` na branch conectada gera um novo
   deploy automaticamente.

## 4. Fluxo de atualização via Claude Code

Para pedir melhorias no HTML e/ou no banco:

- Mudanças de interface/comportamento → editar `index.html`.
- Mudanças de estrutura de dados → editar/criar um novo arquivo `.sql` em
  `supabase/` e rodá-lo no SQL Editor do Supabase (o Claude Code não tem
  acesso direto ao seu projeto Supabase — só ao código deste repositório).
- Depois de cada mudança: commit + push para a branch de trabalho. O Netlify
  publica automaticamente.

## Segurança

- O app exige login (Supabase Auth) antes de mostrar qualquer dado.
- A tabela `alunos` tem Row Level Security habilitada: só usuários
  autenticados conseguem ler, inserir, editar ou apagar registros.
- Nenhum dado de aluno fica embutido no `index.html` — tudo vem do Supabase
  em tempo de execução, depois do login.
