# set -eo pipefail
#
# leases_to_jsons() {
#     cat /var/db/dhcpd_leases | gsed -r 's/(\w+)=(.*)/"\1": "\2",/' | gsed -E -n 'H; x; s:,(\s*\n\s*}):\1:; P; ${x; p}' | gsed '1 d' | jq .
# }
# LEASES_JSONS=$(leases_to_jsons)
# PARSED_JSONS=$(echo "${LEASES_JSONS}" | jq '. | {"name": .name, "ip": .ip_address}')
# echo ${PARSED_JSONS}
# for JSON in ${PARSED_JSONS}; do
#     echo ${JSON}
#     hostile set "$(echo "${JSON}" | jq '.name')" "$(echo "${JSON}" | jq '.ip')"
# done
