#!/bin/bash
#
# Helper script to create a pull secret with one or more registry servers.
#
if [ $# -ne 1 ]; then
  echo "Usage: ${0} <pull-secret-name>"
  exit 1
fi

pull_secret="${1}"
config_json='{"auths":{}}'

while :
do
  default="registry.redhat.io"
  echo
  reg_server=$(read -p "Registry server - $default: " server; echo $server)
  reg_server=${reg_server:-$default}

  default="$(whoami)"
  reg_username=$(read -p "Registry username - $default: " username; echo $username)
  reg_username=${reg_username:-$default}

  reg_password=$(read -s -p "Registry password: " pwd; echo $pwd)
  stty echoe; echo

  default="${reg_username}"
  [[ ! "${default}" =~ "@" ]] && default="${default}@redhat.com"

  reg_email=$(read -p "Registry user e-mail - $default: " email; echo $email)
  reg_email=${reg_email:-$default}

  config_json=`echo ${config_json} | jq ".auths += {\"${reg_server}\":{\"username\":\"${reg_username}\",\"password\":\"${reg_password}\",\"email\":\"${reg_email}\"}}"`

  echo
  another=$(read -p "Add another registry server (y/n)?" ans; echo $ans)
  if [ ! "${another}" = "y" ]; then
    break
  fi
done

config_json_file="$(mktemp)"
echo -n "${config_json}" > "${config_json_file}"
echo
echo "Creating pull secret ${pull_secret} ..."
oc delete secret/${pull_secret} --ignore-not-found=true
oc create secret generic ${pull_secret} \
  --from-file=.dockerconfigjson="${config_json_file}" \
  --type=kubernetes.io/dockerconfigjson
rm -f "${config_json_file}"

