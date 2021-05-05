#!/bin/bash
apt-get install jq -y

timeout=600
wait_interval=5
domain="$1"
subdomain="$2"

if [[ "$domain" != *\.  ]]
then
    # if domain doesnt end with a dot (.) add a dot otherwise aws cli will not find the domain recorcd in route53
    domain="$domain."
fi

for (( c=0 ; c<$timeout ; c=c+$wait_interval ))	
do
    status=$(aws route53 list-resource-record-sets --hosted-zone-id "$3" --query "ResourceRecordSets[?Name == '$subdomain.$domain']|[?Type == 'A']" | jq 'any')
    if [[ "$status" == "true" ]]
    then
        # domain exists, waiting
        let remaining=$timeout-$c
        echo "Domain $subdomain.$domain exists, sleeping for $wait_interval. Remaining timeout is $remaining seconds."
        unset status  # reset the $status var

        sleep $wait_interval

    else
        # url not exists, exit loop
        echo "Domain $subdomain.$domain doesnt exist, exiting wait loop."
        break
    fi
done
