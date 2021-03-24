#!/bin/bash
echo $ORACLE_HOME
$ORACLE_HOME/bin/sqlplus / as sysdba << EOF

startup

CREATE USER superuser
  IDENTIFIED BY oracle
  DEFAULT TABLESPACE SYSTEM
  TEMPORARY TABLESPACE SYSTEM
  PROFILE DEFAULT
  ACCOUNT UNLOCK;

-- 1 Role for system
GRANT DBA TO superuser;
ALTER USER superuser DEFAULT ROLE ALL;

-- 2 System Privileges for system
GRANT CREATE SESSION TO superuser;
GRANT UNLIMITED TABLESPACE TO superuser;

CREATE TABLESPACE app_data DATAFILE
  '/opt/oracle/product/18c/dbhomeXE/dbs/daten1.dbf' SIZE 10M AUTOEXTEND ON NEXT 100M MAXSIZE UNLIMITED;
CREATE TEMPORARY TABLESPACE TEMP TEMPFILE
  '/opt/oracle/product/18c/dbhomeXE/dbs/temp.dbf' SIZE 10M AUTOEXTEND ON NEXT 100M MAXSIZE UNLIMITED;


exec dbms_service.create_service('XE','XE');
exec dbms_service.start_service('XE');

CREATE OR REPLACE TRIGGER SYS.ROLE_TRIGGER AFTER STARTUP ON DATABASE
begin
      dbms_service.start_service('XE');
end;
/
exit;
EOF
