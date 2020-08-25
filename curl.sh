#!/usr/bin/env bash

SERVER=http://localhost:1314
M=$1

# $1 TEST #
# $2 URI
# EXPECTED_REDIR yes/no
CURL() {

	TEST=$1
	URI=$2
	EXPECTED_REDIR=$3

	URL=${SERVER}${URI}

	echo M${M}T${TEST} REQ:${URL} expected redir:${EXPECTED_REDIR}

	curl  -vsL ${URL} 2>&1 | grep -e ^\>\ GET -e ^\<\ HTTP -e ^\<\ Location -e ^\\w.*

	echo ---
}

echo ===
echo M${M} Testing without trailing /
echo ===
CURL 1 /dir no
CURL 2 /dir2dir no
CURL 3 /dir2file no
CURL 4 /file no
CURL 5 /file2dir no
CURL 6 /file2file no
CURL 7 /blogdir yes
CURL 8 /blogfile yes

echo ===
echo M${M} Testing with trailing /
echo ===
CURL 9 /dir/ no
CURL a /dir2dir/ no
CURL b /dir2file/ no
CURL c /file/ no
CURL d /file2dir/ no
CURL e /file2file/ no
CURL f /blogdir/ no
CURL g /blogfile/ no