# Work Config
alias utc-date='date -u +%Y%m%d%H%M'
alias postgres-proxy-beta="/usr/local/bin/cloud_sql_proxy -instances=beta-243321:us-central1:postgres-beta-1=tcp:2345 -credential_file=$BETACREDS"
alias postgres-proxy-prod="/usr/local/bin/cloud_sql_proxy -instances=prod-238418:us-central1:postgres-prod-1=tcp:3456 -credential_file=$PRODCREDS"
alias kube-proxy-beta='kubectl config use-context gke_beta-243321_us-central1_beta-autopilot-cluster && kubectl proxy'
alias kube-proxy-prod='kubectl config use-context gke_prod-238418_us-central1-f_prod-kubernetes-cluster-1 && kubectl proxy'
alias utc-date='date -u +%Y%m%d%H%M'

## dev env
export COG_BASE_DIR=/home/kardia/WorkCode/
cog-pull(){
  local services=($@) 
  if [ -z $services ]; then
    services=(kafka postgres redis keycloak)
  fi
  for service in "${services[@]}"; do
    docker-compose -f "$COG_BASE_DIR/tools/$service/docker-compose.yml" pull &;
  done
  wait
}
cog-down(){
  local services=($@) 
  if [ -z $services ]; then
    services=(kafka postgres redis keycloak)
  fi
  for service in "${services[@]}"; do
    docker-compose -f "$COG_BASE_DIR/tools/$service/docker-compose.yml" down &;
  done
  wait
}
cog-up(){
  local services=($@) 
  if [ -z $services ]; then
    services=(kafka postgres redis keycloak)
  fi
  for service in "${services[@]}"; do
    docker-compose -f "$COG_BASE_DIR/tools/$service/docker-compose.yml" pull && \
      docker-compose -f "$COG_BASE_DIR/tools/$service/docker-compose.yml" up -d &;
  done
  wait
}
beta-db(){
pgcli -p 2345 -h postgres-beta -u cognitops -d ${1:-"postgres"}
}
prod-db(){
pgcli -p 3456 -h postgres-prod -u cognitops -d ${1:-"postgres"}
}
