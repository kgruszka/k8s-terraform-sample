#!/bin/bash
INSTANCE=$1
echo "{ \
  \"CN\": \"system:node:${INSTANCE}\", \
  \"key\": { \
    \"algo\": \"rsa\", \
    \"size\": 2048 \
  }, \
  \"names\": [ \
    { \
      \"C\": \"US\", \
      \"L\": \"Portland\", \
      \"O\": \"system:nodes\", \
      \"OU\": \"Kubernetes The Hard Way\", \
      \"ST\": \"Oregon\" \
    } \
  ] \
} \
"