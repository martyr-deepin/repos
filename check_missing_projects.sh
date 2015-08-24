#!/bin/bash

# requires: curl, jq

local_projects=$(repo list --name | sort)
remove_projects=$(curl -X GET 'https://cr.deepin.io/projects/?d' 2>/dev/null | sed 1d | jq -r .[].id | sort)
diff <(echo "${local_projects}") <(echo "${remove_projects}")
