# This dockerfile builds off of 18.4.0-xe-min and adds migration + health check that was copied from the original.
FROM oracle/database:18.4.0-xe-min 
ENV CHECK_DB_FILE="checkDBStatusModified.sh"
COPY --chown=oracle:oinstall \
    $CHECK_DB_FILE \
    runOracleModified.sh \
    ./

# Insert your needed data migrations into the data folder. This could be `.sh` or `.sql` files.
# You might also need to learn about the `sqlldr` command and `ctl` files to handle loading csv data.
# https://github.com/oracle/docker-images/tree/main/OracleDatabase/SingleInstance may or may not have examples to help.
COPY ./data $ORACLE_BASE/scripts/startup

RUN chmod 755 $ORACLE_HOME/$CHECK_DB_FILE
RUN chmod 755 $ORACLE_HOME/runOracleModified.sh

# entrypoint: listener + db
CMD exec ./runOracleModified.sh
HEALTHCHECK --interval=2s  --timeout=1s --retries=20 CMD $ORACLE_HOME/healthCheck.sh
EXPOSE 1521
