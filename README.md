# Prometheus Monitoring Stack

Este repositório contém um stack completo de monitoramento com Prometheus e Grafana, incluindo exporters para monitoramento do host e containers Docker.

## 📋 Estrutura do Projeto

```
prometheus-public/
├── docker-compose.yml          # Stack principal (Prometheus + Grafana)
├── Dockerfile                  # Dockerfile customizado do Prometheus
├── prometheus.yml              # Configuração do Prometheus (template)
├── exporters/
│   └── docker-compose.yml     # Exporters (Node Exporter + cAdvisor)
└── README.md
```

## 🚀 Componentes

### Stack Principal

- **Prometheus**: Coleta e armazenamento de métricas
- **Grafana**: Visualização e dashboards

### Exporters

- **Node Exporter**: Monitora métricas do sistema host (CPU, memória, disco, rede)
- **cAdvisor**: Monitora containers Docker (uso de recursos, performance)

## 📦 Pré-requisitos

- Docker
- Docker Compose

## 🛠️ Como Usar

### 1. Iniciar os Exporters

Primeiro, inicie os exporters que coletam as métricas:

```bash
cd exporters
docker-compose up -d
```

Isso iniciará:

- **Node Exporter** na porta `9100`
- **cAdvisor** na porta `8080`

### 2. Iniciar o Stack Principal

Volte para o diretório raiz e inicie o Prometheus e Grafana:

```bash
cd ..
docker-compose up -d
```

Isso iniciará:

- **Prometheus** na porta `9090`
- **Grafana** na porta `3000`

### 3. Acessar as Interfaces

#### Prometheus

- URL: http://localhost:9090
- Use para consultar métricas diretamente e verificar targets

#### Grafana

- URL: http://localhost:3000
- **Usuário**: `admin`
- **Senha**: `admin`

## ⚙️ Configuração

### Variável de Ambiente

O stack usa a variável `HOST_EXPORTERS` para definir onde encontrar os exporters:

```bash
# Usar host Docker interno (padrão)
HOST_EXPORTERS=host.docker.internal

# Ou especificar um IP específico
HOST_EXPORTERS=192.168.1.100
```

### Targets Configurados

O Prometheus está configurado para coletar métricas de:

1. **Host System** (`exporter-host`):
   - Target: `host.docker.internal:9100`
   - Métricas do sistema operacional

2. **Docker Containers** (`exporter-containers`):
   - Target: `host.docker.internal:8080`
   - Métricas dos containers

## 📊 Verificação

### 1. Verificar Exporters

```bash
# Node Exporter
curl http://localhost:9100/metrics

# cAdvisor
curl http://localhost:8080/metrics
```

### 2. Verificar Targets no Prometheus

1. Acesse http://localhost:9090
2. Vá para **Status** → **Targets**
3. Verifique se ambos os targets estão **UP**

### 3. Configurar Grafana

1. Acesse http://localhost:3000
2. Adicione o Prometheus como data source:
   - URL: `http://prometheus:9090`
3. Importe dashboards para visualizar as métricas

## 🔧 Comandos Úteis

```bash
# Iniciar tudo
cd exporters && docker-compose up -d
cd .. && docker-compose up -d

# Parar tudo
docker-compose down
cd exporters && docker-compose down

# Ver logs
docker-compose logs -f prometheus
docker-compose logs -f grafana

# Reiniciar um serviço específico
docker-compose restart prometheus
```

## 📈 Dashboards Recomendados

Para o Grafana, recomendo importar estes dashboards:

- **Node Exporter Full**: ID `1860`
- **Docker Container & Host Metrics**: ID `10619`
- **cAdvisor exporter**: ID `14282`

## 🔍 Troubleshooting

### Targets DOWN
- Verifique se os exporters estão rodando: `docker ps`
- Verifique a conectividade de rede entre containers
- Confirme se `host.docker.internal` está resolvendo corretamente

### Grafana não conecta ao Prometheus
- Verifique se ambos estão na mesma rede Docker (`metrics`)
- Use `http://prometheus:9090` como URL do data source

### Métricas não aparecem
- Verifique se os volumes estão montados corretamente nos exporters
- Confirme se o cAdvisor tem acesso ao socket do Docker

## 📝 Personalização

### Adicionar Novos Targets

Edite `prometheus.yml` para adicionar novos jobs:

```yaml
scrape_configs:
  - job_name: 'my-app'
    static_configs:
      - targets: ['app:8080']
```

### Configurar Alertas

Adicione regras de alerta no `prometheus.yml` ou crie arquivos separados de regras.

## 🔐 Segurança

⚠️ **Atenção**: Este setup é para desenvolvimento/teste. Para produção:

- Altere as senhas padrão do Grafana
- Configure autenticação adequada
- Use volumes nomeados para persistência
- Configure backup dos dados
- Implemente TLS/SSL

## 📄 Licença

Este projeto está sob a licença MIT.