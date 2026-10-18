# Testes do banco das salas

Testam o `schema.sql` num Postgres local, sem tocar no Supabase de verdade.

```bash
P="psql -h <socket-ou-host> -p <porta> -U postgres"
$P -c "drop database if exists pac" -c "create database pac"
$P -d pac -f supabase/testes/simular_supabase.sql
$P -d pac -v ON_ERROR_STOP=1 -f supabase/schema.sql   # roda duas vezes: precisa passar nas duas
$P -d pac -v ON_ERROR_STOP=1 -f supabase/schema.sql
$P -d pac -f supabase/testes/cenarios_de_acesso.sql
```

Confira que toda linha comentada com "deve falhar" termina em `ERROR` (ou em 0 linhas afetadas) e que as demais funcionam. Cenários cobertos: cadastro sem perfil, autopromoção, estado forçado, edição por não curador, visibilidade de propostas, reações antes e depois da Sentença, reação em nome de outra pessoa, leitura de reações alheias, Storage, candidatura e aprovação, limite de propostas, apagar conta e ocultação do autor das salas.
