#!/bin/bash

# requires: awk, curl, jq

# %2F -> /
decodeurl() {
  env LANG=C awk -niord '{printf RT?$0chr("0x"substr(RT,2)):$0}' RS=%..
}

local_projects=$(repo list --name | sort)
remove_projects=$(curl -X GET 'https://cr.deepin.io/projects/?d' 2>/dev/null | sed 1d | jq -r .[].id | sort | sed '/All-Users/d' | decodeurl)
diff <(echo "${local_projects}") <(echo "${remove_projects}")
