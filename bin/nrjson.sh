#!/usr/bin/env bash

json=$(pbpaste | sed 's/[\x80]n  at/\n    at/g'  | sed 's/"  at/\n    at/' | sed 's/)[\x80]n"/)\n  "/')
echo -e "\`\`\`json5\n${json}\n\`\`\`" | pbcopy
