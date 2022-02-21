# Work Config
alias utc-date='date -u +%Y%m%d%H%M'
alias postgres-proxy-beta="GOOGLE_APPLICATION_CREDENTIALS='' /usr/local/bin/cloud_sql_proxy -instances=beta-243321:us-central1:postgres-beta-1=tcp:2345"
alias postgres-proxy-prod="GOOGLE_APPLICATION_CREDENTIALS='' /usr/local/bin/cloud_sql_proxy -instances=prod-238418:us-central1:postgres-prod-1=tcp:3456"
alias kube-proxy-beta='kubectl config use-context gke_beta-243321_us-central1_beta-autopilot-cluster && kubectl proxy'
alias kube-proxy-prod='kubectl config use-context gke_prod-238418_us-central1-f_prod-kubernetes-cluster-1 && kubectl proxy'
alias utc-date='date -u +%Y%m%d%H%M'

## dev env
export COG_BASE_DIR=~'/WorkCode'
typeset -A COMPOSE_MAP=(
        ["kafka"]="$COG_BASE_DIR/tools/kafka/local-docker/docker-compose.yml"
  ["kafka-multi"]="$COG_BASE_DIR/tools/kafka/local-docker-multi-cluster/docker-compose.yml"
     ["postgres"]="$COG_BASE_DIR/tools/postgres/docker-compose.yml"
        ["redis"]="$COG_BASE_DIR/tools/redis/docker-compose.yml"
     ["keycloak"]="$COG_BASE_DIR/tools/keycloak/docker-compose.yml"
  )
cog-pull(){
  local services=($@)
  if [ -z $services ]; then
    services=(kafka postgres redis keycloak)
  fi
  for service in "${services[@]}"; do
    ( /usr/bin/docker-compose -f "${COMPOSE_MAP[$service]}" pull & );
  done
  wait
}
cog-down(){
  local services=($@)
  if [ -z $services ]; then
    services=(kafka postgres redis keycloak)
  fi
  for service in "${services[@]}"; do
    ( /usr/bin/docker-compose -f "${COMPOSE_MAP[$service]}" down & );
  done
  wait
}
cog-up(){
  local services=($@)
  if [ -z $services ]; then
    services=(kafka postgres redis keycloak)
  fi
  for service in "${services[@]}"; do
    ( /usr/bin/docker-compose -f "${COMPOSE_MAP[$service]}" pull &&
        /usr/bin/docker-compose -f "${COMPOSE_MAP[$service]}" up -d & );
  done
  wait
}
beta-db(){
  pgcli -p 2345 -h postgres-beta -u cognitops -d ${1:-"postgres"}
}
prod-db(){
  pgcli -p 3456 -h postgres-prod -u cognitops -d ${1:-"postgres"}
}
