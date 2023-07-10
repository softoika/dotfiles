#!/usr/bin/env bash

json=$(pbpaste | sed 's/\\n  /\n    /g' | sed 's/"  at/"\n    at/' | sed 's/\\n"/\n  "/')
echo -e "\`\`\`json5\n${json}\n\`\`\`" | pbcopy
