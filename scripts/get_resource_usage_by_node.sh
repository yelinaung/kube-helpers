#!/usr/bin/env bash

. PWD/helpers/table_printer.sh

NODE_NAME=$1
TEMP=$(kubectl get po --all-namespaces --field-selector spec.nodeName="$NODE_NAME" --no-headers -o custom-columns="name:.metadata.name, namespace:.metadata.namespace")
export IFS=$'\n'
echo "Pod Name, CPU, Memory" >> temp
for line in $TEMP
do
    POD=$(echo "$line" | awk '{print $1}')
    NAMESPACE=$(echo "$line" | awk '{print $2}')
    (kubectl top po "$POD" -n "$NAMESPACE" --no-headers | sed -r 's/\s+/,/g' | sed 's/.$//') >> temp
done

printTable ',' "$(cat temp)"
rm temp