#!/bin/bash

# secconds passed since first commit (default 1 year)
FIRST_COMMIT_SINCE=${FIRST_COMMIT_SINCE:-31536000}
# seconds passed since last commit (default 0 / now)
LAST_COMMIT_SINCE=${LAST_COMMIT_SINCE:-0}

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

CURRENT_TIME=$(date +%s)

# time stamp to use for every commit (will be modified in loop)
FAKE_TIME_STAMP=$(($CURRENT_TIME - $FIRST_COMMIT_SINCE))
# max time for last commit (condition in loop)
LAST_COMMIT_TIME=$(($CURRENT_TIME - $LAST_COMMIT_SINCE))


git init

while [ $FAKE_TIME_STAMP -lt $LAST_COMMIT_TIME ]
do
  FAKE_TIME="$(date -u -d @${FAKE_TIME_STAMP})"
  COMMIT_MSG_LINE=$(shuf -i 1-471 -n 1)
  COMMIT_MESSAGE="$(sed ${COMMIT_MSG_LINE}'!d' commit-messages.txt)"

  echo "$FAKE_TIME" > last.commit
  git add last.commit

  faketime "${FAKE_TIME}" git commit -m "$COMMIT_MESSAGE" --author 'Fake Author <fake@repository.net>'

  # next commit between MIN_SHIFT and MAX_SHIFT
  TIME_SHIFT=$(shuf -i $MIN_SHIFT-$MAX_SHIFT -n 1)
  FAKE_TIME_STAMP=$(($FAKE_TIME_STAMP + $TIME_SHIFT))

  # modify MIN_SHIFT and MAX_SHIFT
  TEMP_MIN_SHIFT=$(echo | awk "{printf \"%.0f\n\",($MIN_SHIFT $MIN_MOD_LINEAR) * $MIN_MOD_FACTOR}" )
  TEMP_MAX_SHIFT=$(echo | awk "{printf \"%.0f\n\",($MAX_SHIFT $MAX_MOD_LINEAR) * $MAX_MOD_FACTOR}" )

  if [ $TEMP_MIN_SHIFT -gt 0 ] && [ $TEMP_MIN_SHIFT -lt $TEMP_MAX_SHIFT ]; then
    MIN_SHIFT=$TEMP_MIN_SHIFT
  fi

  if [ $TEMP_MAX_SHIFT -gt 0 ] && [ $TEMP_MAX_SHIFT -gt $TEMP_MIN_SHIFT ]; then
    MAX_SHIFT=$TEMP_MAX_SHIFT
  fi
done
