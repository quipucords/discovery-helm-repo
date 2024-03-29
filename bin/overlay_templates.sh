#!/bin/bash
#
# overlay template files from current directory to target
# Used yq binary for merging yaml files.
#
if [ $# -ne 2 ]; then
  echo "Usage: overlay_templates.sh overlay_directory target_directory" >&2
  exit 1
fi
if [ -z "$(which yq)" ]; then
  echo "Missing required yq command." >&2
  exit 
fi
overlay_dir="${1}"
target_dir="${2}"
if [ ! -d "${overlay_dir}" ]; then
  echo "Missing overlay directory ${overlay_dir}" >&2
  exit 1 
fi
cd "${overlay_dir}"
find . -type f -print | \
while read yaml_file
do
  if [ ! -f "${target_dir}/${yaml_file}" ]; then
    echo "Missing target file ${target_dir}/${yaml_file}" >&2
    exit 1
  fi
  if [ "$(basename ${yaml_file})" == "values.yaml" ]; then
    echo "Overlaying ${yaml_file} ..."
    mergedf=$(mktemp)
    yq eval-all '. as $item ireduce ({}; . *+ $item)' "${target_dir}/${yaml_file}" "${yaml_file}" > ${mergedf}
    if [ $? -ne 0 ]; then
      rm -f ${mergedf}
      exit $?
    fi
    cp ${mergedf} "${target_dir}/${yaml_file}"
    rm -f ${mergedf}
  else
    echo "Copying ${yaml_file} ..."
    cp "${yaml_file}" "${target_dir}/${yaml_file}"
  fi
done
exit 0
