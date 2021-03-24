#!/bin/bash
### Copied from https://github.com/oracle/docker-images/blob/main/OracleDatabase/SingleInstance/dockerfiles/18.4.0/runOracle.sh
# This file should be placed in a location owned by the user.
# If needed:
# * Add this script to the image.
# * Add /docker-entrypoint-initdb.d/(setup/startup) files.


# Script to loop through a migration setup similar to docker-entrypoint-initdb.d that other database images also use.
function runUserScripts {

  SCRIPTS_ROOT="$1";

  # Check whether parameter has been passed on
  if [ -z "$SCRIPTS_ROOT" ]; then
    echo "$0: No SCRIPTS_ROOT passed on, no scripts will be run";
    exit 1;
  fi;

  # Execute custom provided files (only if directory exists and has files in it)
  if [ -d "$SCRIPTS_ROOT" ] && [ -n "$(ls -A $SCRIPTS_ROOT)" ]; then

    echo "";
    echo "Executing user defined scripts"

    for f in $SCRIPTS_ROOT/*; do
        case "$f" in
            *.sh)     echo "$0: running $f"; . "$f" ;;
            *.sql)    echo "$0: running $f"; echo "exit" | $ORACLE_HOME/bin/sqlplus / as sysdba @$f; echo ;;
            *)        echo "$0: ignoring $f" ;;
        esac
        echo "";
    done

    echo "DONE: Executing user defined scripts"
    echo "";

  fi;

}

runUserScripts /docker-entrypoint-initdb.d/setup
runUserScripts /docker-entrypoint-initdb.d/startup
