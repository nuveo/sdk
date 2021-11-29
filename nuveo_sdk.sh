#!/bin/bash

function _get_jwt() {
  response=$(curl -w "\n%{http_code}" --silent --location \
  --request POST 'https://auth.apis.nuveo.ai/v2/token' \
  --data-raw "{
      \"ClientID\": \"${CLIENT_ID}\",
      \"ClientSecret\": \"${CLIENT_SECRET}\"
      }")

  HTTP_STATUS=$(tail -n1 <<< "$response")
  HTTP_CONTENT=$(sed '$ d' <<< "$response") 
}

function get_jwt() {
  _get_jwt
  while [ "${HTTP_STATUS}" == "401" ]; do
    sleep 3
    echo "Retrying get jwt..."
    _get_jwt
  done

  if [ "$HTTP_STATUS" -ne 200 ]; then
    echo "Error: ${HTTP_STATUS} - ${HTTP_CONTENT}"
    exit 1
  fi
}

get_jwt

echo "${HTTP_STATUS}"
echo "${HTTP_CONTENT}"

