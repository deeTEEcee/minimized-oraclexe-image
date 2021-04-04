FROM oracle/database:18.4.0-xe as oraclexe
FROM oraclelinux:7-slim

ENV ORACLE_BASE /opt/oracle
ENV ORACLE_HOME ${ORACLE_BASE}/product/18c/dbhomeXE
ENV LD_LIBRARY_PATH=${ORACLE_HOME}/lib 
ENV ORACLE_SID=XE
ENV NLS_CHARACTERSET=UTF8
ENV SGA_TARGET=1536M
ENV PATH="$PATH:$ORACLE_HOME/bin"

RUN yum install -y oracle-database-preinstall-18c strace && \
  rm -rf /var/cache/yum

USER oracle
WORKDIR ${ORACLE_HOME}

COPY --chown=oracle:oinstall \
  createUserAndTS.sh healthCheck.sh $ORACLE_HOME

# Main oracle executables
COPY --from=oraclexe --chown=oracle:oinstall \
  ${ORACLE_HOME}/bin/oracle \
  ${ORACLE_HOME}/bin/lsnrctl \
  ${ORACLE_HOME}/bin/tnslsnr \
  ${ORACLE_HOME}/bin/sqlldr \
  ${ORACLE_HOME}/bin/sqlplus \
  bin/

#TODO: do something lighter than preinstall
#TODO# move audit and dbs (rooh)
RUN chmod a+x $ORACLE_HOME/createUserAndTS.sh && \
  chmod a+x $ORACLE_HOME/healthCheck.sh && \
  mkdir -p bin sqlplus/mesg rdbms/mesg oracore/zoneinfo \
    rdbms/audit dbs log rdbms/log rdbms/xml oracore/mesg \
    ldap/mesg network/mesg nls/data && \
  chown -R oracle:oinstall ${ORACLE_BASE} ${ORACLE_HOME} && \
  echo -e 'db_name=XE' >> ${ORACLE_HOME}/dbs/initXE.ora && \
  echo -e 'SHARED_POOL_SIZE=400M' >> ${ORACLE_HOME}/dbs/initXE.ora
  # echo -e 'alias "sqlplus=cd ${ORACLE_BASE}/diag/rdbms/*/${ORACLE_SID}/trace"' > ~/.bashrc && \


################################################################################################################
# sqlplus
################################################################################################################
COPY --from=oraclexe --chown=oracle:oinstall \
  ${ORACLE_HOME}/lib/libsqlplus.so \
  ${ORACLE_HOME}/lib/libclntsh.so.18.1 \
  ${ORACLE_HOME}/lib/libclntshcore.so.18.1 \
  ${ORACLE_HOME}/lib/libmql1.so \
  ${ORACLE_HOME}/lib/libipc1.so \
  ${ORACLE_HOME}/lib/libnnz18.so \
  ${ORACLE_HOME}/lib/libons.so \
  lib/
COPY --from=oraclexe --chown=oracle:oinstall \
  ${ORACLE_HOME}/sqlplus/mesg/sp1us.msb \
  ${ORACLE_HOME}/sqlplus/mesg/sp2us.msb \
  sqlplus/mesg/
COPY --from=oraclexe --chown=oracle:oinstall \
  ${ORACLE_HOME}/rdbms/mesg/ocius.msb \
  ${ORACLE_HOME}/rdbms/mesg/oraus.msb \
  ${ORACLE_HOME}/rdbms/mesg/ulus.msb \
  ${ORACLE_HOME}/rdbms/mesg/diaus.msb \
  rdbms/mesg/
COPY --from=oraclexe --chown=oracle:oinstall \
  ${ORACLE_HOME}/oracore/zoneinfo/*.dat \
  oracore/zoneinfo/

################################################################################################################
# oracle core
################################################################################################################
#RUN strip --remove-section=.comment ${ORACLE_HOME}/bin/oracle
COPY --from=oraclexe --chown=oracle:oinstall\
  ${ORACLE_HOME}/lib/libodm18.so\
  ${ORACLE_HOME}/lib/libofs.so\
  ${ORACLE_HOME}/lib/libcell18.so\
  ${ORACLE_HOME}/lib/libskgxp18.so\
  ${ORACLE_HOME}/lib/libskjcx18.so\
  ${ORACLE_HOME}/lib/libclsra18.so\
  ${ORACLE_HOME}/lib/libdbcfg18.so\
  ${ORACLE_HOME}/lib/libhasgen18.so\
  ${ORACLE_HOME}/lib/libskgxn2.so\
  ${ORACLE_HOME}/lib/libocr18.so\
  ${ORACLE_HOME}/lib/libocrb18.so\
  ${ORACLE_HOME}/lib/libocrutl18.so\
  ${ORACLE_HOME}/lib/libmkl_rt.so\
  ${ORACLE_HOME}/lib/libasmclntsh18.so\
  lib/
COPY --from=oraclexe --chown=oracle:oinstall\
  ${ORACLE_HOME}/oracore/mesg/lrmus.msb\
  oracore/mesg
#RUN echo -e 'sga_target=1536M' >> ${ORACLE_HOME}/dbs/initXE.ora

################################################################################################################
# oracle rdbms
################################################################################################################
COPY --from=oraclexe --chown=oracle:oinstall\
  ${ORACLE_HOME}/ldap/mesg/ldapus.msb\
  ldap/mesg/
COPY --from=oraclexe --chown=oracle:oinstall\
  ${ORACLE_HOME}/network/mesg/tnsus.msb\
  network/mesg
COPY --from=oraclexe --chown=oracle:oinstall\
  ${ORACLE_HOME}/nls/data\
  nls/data
COPY --from=oraclexe --chown=oracle:oinstall\
  ${ORACLE_HOME}/rdbms/admin/sql.bsq \
  ${ORACLE_HOME}/rdbms/admin/dcore.bsq \
  ${ORACLE_HOME}/rdbms/admin/dsqlddl.bsq \
  ${ORACLE_HOME}/rdbms/admin/dmanage.bsq \
  ${ORACLE_HOME}/rdbms/admin/dplsql.bsq \
  ${ORACLE_HOME}/rdbms/admin/dtxnspc.bsq \
  ${ORACLE_HOME}/rdbms/admin/dfmap.bsq \
  ${ORACLE_HOME}/rdbms/admin/denv.bsq \
  ${ORACLE_HOME}/rdbms/admin/drac.bsq \
  ${ORACLE_HOME}/rdbms/admin/dsec.bsq \
  ${ORACLE_HOME}/rdbms/admin/doptim.bsq \
  ${ORACLE_HOME}/rdbms/admin/dobj.bsq \
  ${ORACLE_HOME}/rdbms/admin/djava.bsq \
  ${ORACLE_HOME}/rdbms/admin/dpart.bsq \
  ${ORACLE_HOME}/rdbms/admin/drep.bsq \
  ${ORACLE_HOME}/rdbms/admin/daw.bsq \
  ${ORACLE_HOME}/rdbms/admin/dsummgt.bsq \
  ${ORACLE_HOME}/rdbms/admin/dtools.bsq \
  ${ORACLE_HOME}/rdbms/admin/dexttab.bsq \
  ${ORACLE_HOME}/rdbms/admin/ddm.bsq \
  ${ORACLE_HOME}/rdbms/admin/dlmnr.bsq \
  ${ORACLE_HOME}/rdbms/admin/ddst.bsq \
  ${ORACLE_HOME}/rdbms/admin/dfba.bsq \
  ${ORACLE_HOME}/rdbms/admin/dpstdy.bsq \
  ${ORACLE_HOME}/rdbms/admin/drupg.bsq \
  ${ORACLE_HOME}/rdbms/admin/dtlog.bsq \
  ${ORACLE_HOME}/rdbms/admin/dmisc.bsq \
  ${ORACLE_HOME}/rdbms/admin/dhcs.bsq \
  rdbms/admin/

################################################################################################################
# oracle catalog
################################################################################################################
# simpler to take all files, that's only 20MB more than the required ones
COPY --from=oraclexe --chown=oracle:oinstall\
  ${ORACLE_HOME}/rdbms/admin/*.sql\
  ${ORACLE_HOME}/rdbms/admin/*.plb\
  rdbms/admin/

################################################################################################################
# oracle catproc
################################################################################################################
# prvt_emx.register_files(TRUE) needs rdbms/xml
COPY --from=oraclexe --chown=oracle:oinstall\
  ${ORACLE_HOME}/rdbms/xml\
  rdbms/xml

RUN echo -e 'whenever sqlerror exit failure;\n startup nomount;\n create database CHARACTER SET UTF8;\ncreate spfile from pfile;' | sqlplus / as sysdba && \
  echo -e 'startup;\n set echo on termout off\n spool /var/tmp/catalog.lst\n @?/rdbms/admin/catalog' | sqlplus / as sysdba && \
  echo -e 'startup;\n set echo on termout off\n spool /var/tmp/catproc.lst\n @?/rdbms/admin/catproc' | sqlplus / as sysdba && \
  $ORACLE_HOME/createUserAndTS.sh


################################################################################################################
# listener
#TODO# if we add an external volume, need to move all ?/dbs to it at start (and symlink). clonedb may help to have onlyy sparse files
################################################################################################################
# entrypoint
CMD echo -e "sga_target=${SGA_TARGET}" >> ${ORACLE_HOME}/dbs/initXE.ora; ${ORACLE_HOME}/bin/lsnrctl start ; echo create spfile from pfile\; | ${ORACLE_HOME}/bin/sqlplus / as sysdba ;echo startup | ${ORACLE_HOME}/bin/sqlplus / as sysdba ; ${ORACLE_HOME}/bin/lsnrctl status ; tail -f $ORACLE_BASE/diag/rdbms/*/*/trace/alert*.log
HEALTHCHECK --interval=2s  --timeout=1s --retries=20 CMD $ORACLE_HOME/healthCheck.sh
EXPOSE 1521
