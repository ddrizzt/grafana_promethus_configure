KEY="xxxxxx"
GFHOST="http://localhost:3000"

GRAFANA_DASHBOARDS_FOLDER="dashboards"
echo "Exporting Grafana dashboards from $GFHOST"
mkdir -p "${GRAFANA_DASHBOARDS_FOLDER}"
for dash in $(curl -k -H "Authorization: Bearer ${KEY}" "${GFHOST}/api/search?query=&" | jq -r '.[] | select(.type == "dash-db") | .uid'); do
  curl -k -H "Authorization: Bearer ${KEY}" "${GFHOST}/api/dashboards/uid/$dash" | jq -r . >${GRAFANA_DASHBOARDS_FOLDER}/${dash}.json
  slug=$(cat ${GRAFANA_DASHBOARDS_FOLDER}/${dash}.json | jq -r '.meta.slug')
  folder=$(cat ${GRAFANA_DASHBOARDS_FOLDER}/${dash}.json | jq -r '.meta.folderTitle')
  mkdir -p "${GRAFANA_DASHBOARDS_FOLDER}/${folder}"
  mv ${GRAFANA_DASHBOARDS_FOLDER}/${dash}.json "${GRAFANA_DASHBOARDS_FOLDER}/${folder}/${slug}.json"
done

