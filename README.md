# gcp-proxyfarm-startup

## Motivação

Criar um Farm de instancias com binário GCP Proxy da Google para receber conexões e redirecionar para o GCP SQL.

## Limitações

GCP SQL aguenta somente 4mil conexões no máximo, mesmo trocando a familia das instâncias.