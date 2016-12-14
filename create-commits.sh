#!/bin/bash

# default start Sun, 01 May 2016 00:00:00 GMT
FIRST_COMMIT=${FIRST_COMMIT:-1462060800}
# default end Mon, 31 Oct 2016 23:59:59 GMT
LAST_COMMIT=${LAST_COMMIT:-1477958399}

# minimum seconds till next commit (default 10)
MIN_SHIFT=${MIN_SHIFT:-10}
# maximum seconds till next commit (default 1 day)
MAX_SHIFT=${MAX_SHIFT:-86400}
# linear modifier for MIN_SHIFT (operator [+,-] must be appended; default '+0')
MIN_MOD_LINEAR=${MIN_MOD_LINEAR:-'+0'}
# factor modifier for MIN_SHIFT (default 1)
MIN_MOD_FACTOR=${MIN_MOD_FACTOR:-1}
# linear modifier for MAX_SHIFT (operator [+,-] must be appended; default '+0')
MAX_MOD_LINEAR=${MAX_MOD_LINEAR:-'+0'}
# factor modifier for MAX_SHIFT (default 1)
MAX_MOD_FACTOR=${MAX_MOD_FACTOR:-1}
# how much will be added to the minimum path commit selector
PATH_MOD_LINEAR=${PATH_MOD_LINEAR:-0}
# by which the minimum path commit selector will multiplied
PATH_MOD_FACTOR=${PATH_MOD_FACTOR:-1}

CURRENT_TIME=$(date +%s)
PATH_MIN=1

# time stamp to use for every commit (will be modified in loop)
FAKE_TIME_STAMP=$FIRST_COMMIT

mkdir "/tmp/$CURRENT_TIME"
cd "/tmp/$CURRENT_TIME"

git init

cp -a /workspace/* .
git add .

while [ $FAKE_TIME_STAMP -lt $LAST_COMMIT ]
do
  FAKE_TIME="$(date -u -d @${FAKE_TIME_STAMP})"
  COMMIT_MSG_LINE=$(shuf -i 1-471 -n 1)
  COMMIT_MESSAGE="$(sed ${COMMIT_MSG_LINE}'!d' /usr/local/bin/commit-messages.txt)"

  echo "$FAKE_TIME" > last.commit

  if [ ! -z $1 ]
  then
    echo $PATH_MIN
    COMMIT_TO_PATH=$(shuf -i ${PATH_MIN}-10000 -n 1)
    while IFS='' read -r line || [[ -n "$line" ]]
    do
      arrIN=(${line//;/ })
      if [ ${arrIN[1]} -gt $COMMIT_TO_PATH ]
      then
        echo "$FAKE_TIME" > "${arrIN[0]}/last.commit"
      fi
    done < "$1"
  fi

  git add .

  faketime "${FAKE_TIME}" git commit -m "$COMMIT_MESSAGE" --author 'Fake Author <fake@repository.net>'

  # next commit between MIN_SHIFT and MAX_SHIFT
  TIME_SHIFT=$(shuf -i $MIN_SHIFT-$MAX_SHIFT -n 1)
  FAKE_TIME_STAMP=$(($FAKE_TIME_STAMP + $TIME_SHIFT))

  # modify MIN_SHIFT and MAX_SHIFT
  TEMP_MIN_SHIFT=$(echo | awk "{printf \"%.0f\n\",($MIN_SHIFT $MIN_MOD_LINEAR) * $MIN_MOD_FACTOR}" )
  TEMP_MAX_SHIFT=$(echo | awk "{printf \"%.0f\n\",($MAX_SHIFT $MAX_MOD_LINEAR) * $MAX_MOD_FACTOR}" )
  TEMP_PATH_MIN=$(echo | awk "{printf \"%.0f\n\",($PATH_MIN + $PATH_MOD_LINEAR) * $PATH_MOD_FACTOR}" )

  if [ $TEMP_MIN_SHIFT -gt 0 ] && [ $TEMP_MIN_SHIFT -lt $TEMP_MAX_SHIFT ]; then
    MIN_SHIFT=$TEMP_MIN_SHIFT
  fi

  if [ $TEMP_MAX_SHIFT -gt 0 ] && [ $TEMP_MAX_SHIFT -gt $TEMP_MIN_SHIFT ]; then
    MAX_SHIFT=$TEMP_MAX_SHIFT
  fi

  if [ $TEMP_PATH_MIN -lt 10000 ]; then
    PATH_MIN=$TEMP_PATH_MIN
  fi
done

echo "New repository created in /tmp/$CURRENT_TIME"
