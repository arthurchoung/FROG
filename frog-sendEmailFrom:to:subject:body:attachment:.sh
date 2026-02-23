#!/bin/bash

if [ "$#" -lt 4 ]; then
    echo "specify from, to, subject, body, attachment"
    exit 1
fi

RESULT=$( frog-generateEmailFrom:to:subject:body:attachment:.py "$@" )

if [ "x$RESULT" == "x" ]; then
    frog alert "unable to generate email"
    exit 1
fi

( cat <<EOF
$RESULT
EOF
) | msmtp --tls-certcheck=off "$2"

EXITCODE=$?
if [ $EXITCODE -ne 0 ]; then
    frog alert "unable to send email"
    exit 1
fi

frog alert "email probably sent, but you never know with email"

