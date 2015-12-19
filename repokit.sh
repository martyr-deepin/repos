#!/bin/bash

LC_ALL=C
set -e

appfile="${0}"
appname="$(basename $0)"

###* Helper
msg() {
  local mesg=${1}; shift
  printf "${GREEN}==>${ALL_OFF}${BOLD} ${mesg}${ALL_OFF}\n" "${@}" >&2
}

msg2() {
  local mesg=${1}; shift
  printf "${BLUE}  ->${ALL_OFF}${BOLD} ${mesg}${ALL_OFF}\n" "${@}" >&2
}

warning() {
  local mesg=${1}; shift
  printf "${YELLOW}==> $(gettext "WARNING:")${ALL_OFF}${BOLD} ${mesg}${ALL_OFF}\n" "${@}" >&2
}

setup_color_message() {
  unset ALL_OFF BOLD BLUE GREEN RED YELLOW
  if [[ -t 2 && $USE_COLOR != "n" ]]; then
      # prefer terminal safe colored and bold text when tput is supported
      if tput setaf 0 &>/dev/null; then
        ALL_OFF="$(tput sgr0)"
        BOLD="$(tput bold)"
        BLUE="${BOLD}$(tput setaf 4)"
        GREEN="${BOLD}$(tput setaf 2)"
        RED="${BOLD}$(tput setaf 1)"
        YELLOW="${BOLD}$(tput setaf 3)"
      else
        ALL_OFF="\e[0m"
        BOLD="\e[1m"
        BLUE="${BOLD}\e[34m"
        GREEN="${BOLD}\e[32m"
        RED="${BOLD}\e[31m"
        YELLOW="${BOLD}\e[33m"
      fi
  fi
}
setup_color_message

get_self_funcs() {
  grep -o "^${1}.*()" "${appfile}" | sed "s/^\(.*\)()/\1/" | sort
}

get_opt_funcs() {
  get_self_funcs "opt_" | sed 's/opt_/     /g'
}

usage() {
  echo "Usage: ${appname} [OPTION] OPERATION"
  echo "Options:"
  echo "    -p, --push, push to remote git repository"
  echo "    -h, --help, show usage"
  echo "Operations:"
  get_opt_funcs
}

get_prj_latest_commit() {
  repo forall "$1" -c "git log --pretty=format:'%h' --abbrev-commit -1"
}

get_prj_desc() {
  repo forall "$1" -c "git log --pretty=format:'%s (%cr) <%an>' --abbrev-commit -1 $2"
}

###* Operations
usage_opt_show_prj_with_no_tag() {
  echo "Usage: ${appname} show_prj_with_no_tag"
}
opt_show_prj_with_no_tag() {
  # repo forall -c '[ -z "$(git tag)" ] && echo ${REPO_PROJECT}'
  repo forall -c '[ -z "$(git describe --long --tags 2>/dev/null)" ] && echo ${REPO_PROJECT}'
}

usage_opt_show_prj_latest_commit_with_no_tag() {
  echo "Usage: ${appname} show_prj_latest_commit_with_no_tag"
}
opt_show_prj_latest_commit_with_no_tag() {
  repo forall -c 'if [ ! -z "$(git describe --long --tags 2>/dev/null)" ]; then
    if git describe --long --tags 2>/dev/null | grep -q -v "\-0\-" ; then
      echo ${REPO_PROJECT} "$(git describe --long --tags)"
    fi
  fi
  '
}

usage_opt_new_tag_for_prj() {
  echo "Usage: new_tag_for_prj <prj> <newtag> [commit]"
  echo "Example: ${appname} new_tag_for_prj go-gir-generator 0.9.1"
  echo "Example: ${appname} -m 'Version %s' new_tag_for_prj go-gir-generator 0.9.1"
}
opt_new_tag_for_prj() {
  local prj="$1"; shift
  local newtag="$1"; shift
  if [ "$1" ]; then
      local commit="$1"; shift
  fi
  local tagmsg="$(printf "${arg_tagmsgfmt}" ${newtag})"

  local relcommit
  local islatest
  local latestcommit="$(get_prj_latest_commit ${prj})"
  if [ "${commit}" ]; then
    relcommit="${commit}"
  else
    relcommit="${latestcommit}"
  fi
  if [ "${relcommit}" = "${latestcommit}" ]; then
    islatest=t
  fi

  local desc="$(get_prj_desc ${prj} ${relcommit})"
  if [ "${islatest}" ]; then
    msg "${prj} -> ${newtag} [latest ${relcommit}]: ${desc}"
  else
    msg "${prj} -> ${newtag} [${relcommit}]: ${desc}"
  fi

  local cmd="git tag -am \"${tagmsg}\" ${newtag} ${relcommit}; git push ${REPO_REMOTE} ${newtag}"
  if [ "${arg_push}" ]; then
    repo forall "${prj}" -c "${cmd}"
  else
    msg2 "repo forall ${prj} -c ${cmd}"
  fi
}

usage_opt_multi_new_tag_for_prjs() {
  echo "Usage: multi_new_tag_for_prjs <file|-> [-m <tagmsgfmt>]"
  echo "Example: ${appname} multi_new_tag_for_prjs file"
  echo "Example: echo \"go-gir-generator 0.9.1\" | ${appname} multi_new_tag_for_prjs"
  echo "Example: echo \"go-gir-generator 0.9.1 6e53a3b\" | ${appname} multi_new_tag_for_prjs"
}
opt_multi_new_tag_for_prjs() {
  if [ $# -gt 0 ]; then
    cat "$1" | do_opt_multi_new_tag_for_prjs
  else
    do_opt_multi_new_tag_for_prjs
  fi
}
do_opt_multi_new_tag_for_prjs() {
  while read line; do
    local prj=$(echo "${line}" | awk '{print $1}')
    local newtag=$(echo "${line}" | awk '{print $2}')
    local commit=$(echo "${line}" | awk '{print $3}')
    opt_new_tag_for_prj "${prj}" "${newtag}" "${commit}"
  done
}

###* Main
arg_usage=
arg_opt=
arg_push=
arg_tagmsgfmt="Version %s"

while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) arg_usage=t; shift; break;;
    -p|--push) arg_push=1; shift;;
    -m|--tagmsgfmt) arg_tagmsgfmt="$2"; shift; shift;;
    *) arg_opt="$1"; shift; break;;
  esac
done

if [ "${arg_usage}" ]; then
    if [ "${arg_opt}" ]; then
        usage_opt_"${arg_opt}"
    else
      usage
    fi
    exit
fi

if [ "${arg_opt}" ]; then
    opt_"${arg_opt}" "${@}"
    exit
fi

usage
