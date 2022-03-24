GF_HOST=http://localhost:3000
# Export
curl -s "${GF_HOST}/api/datasources" -u admin:grafana|jq -c -M '.[]'|split -l 1 - datasource/

# Import
for i in path/to/export/datasource/*; do \
    curl -X "POST" "${GF_HOST}/datasources" \
    -H "Content-Type: application/json" \
    --user admin:grafana \
    --data-binary @$i
done