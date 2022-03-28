#!/usr/bin/env bash
if [[ -e "${HOME}/.sr_core_devtool_path.sh" ]]; then
  source "${HOME}/.sr_core_devtool_path.sh"
else
  echo .sr_core_devtool_path.sh not found
fi

# SR_CORE_DEVTOOL_PATH="/path/to/..."
MODE_AJP="ajp"
MODE_AJP_NG="ng"

mode=$1
if [[ $mode = $MODE_AJP ]]; then
  echo Switching to ajp_proxy...
  docker stop ajp-proxy-angular
  cd $SR_CORE_DEVTOOL_PATH
  docker-compose up -d
elif [[ $mode = $MODE_AJP_NG ]]; then
  echo Switching to ajp-proxy-angular...
  docker stop ajp_proxy
  docker run --rm -it -d --name ajp-proxy-angular -p 443:443 ajp-proxy-angular
else
  echo 'Usage: `./swajp.sh ajp` or `./swajp.sh ng`'
fi
