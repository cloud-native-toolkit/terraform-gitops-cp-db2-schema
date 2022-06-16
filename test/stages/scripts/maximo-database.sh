#!/usr/bin/sh

DATABASE_NAME="${1:-BLUDB}"

db2 connect to "${DATABASE_NAME}"
db2 update db cfg for "${DATABASE_NAME}" using dft_table_org row
db2 update db cfg for "${DATABASE_NAME}" using LOGARCHMETH1 off
db2 update db cfg for "${DATABASE_NAME}" using SELF_TUNING_MEM ON
db2 update db cfg for "${DATABASE_NAME}" using APPGROUP_MEM_SZ 16384 DEFERRED
db2 update db cfg for "${DATABASE_NAME}" using APPLHEAPSZ 2048 AUTOMATIC DEFERRED
db2 update db cfg for "${DATABASE_NAME}" using AUTO_MAINT ON DEFERRED
db2 update db cfg for "${DATABASE_NAME}" using AUTO_TBL_MAINT ON DEFERRED
db2 update db cfg for "${DATABASE_NAME}" using AUTO_RUNSTATS ON DEFERRED
db2 update db cfg for "${DATABASE_NAME}" using AUTO_REORG ON DEFERRED
db2 update db cfg for "${DATABASE_NAME}" using AUTO_DB_BACKUP ON DEFERRED
db2 update db cfg for "${DATABASE_NAME}" using CATALOGCACHE_SZ 800 DEFERRED
db2 update db cfg for "${DATABASE_NAME}" using CHNGPGS_THRESH 40 DEFERRED
db2 update db cfg for "${DATABASE_NAME}" using DBHEAP AUTOMATIC
db2 update db cfg for "${DATABASE_NAME}" using LOCKLIST AUTOMATIC DEFERRED
db2 update db cfg for "${DATABASE_NAME}" using LOGBUFSZ 1024 DEFERRED
db2 update db cfg for "${DATABASE_NAME}" using LOCKTIMEOUT 300 DEFERRED
db2 update db cfg for "${DATABASE_NAME}" using LOGPRIMARY 20 DEFERRED
db2 update db cfg for "${DATABASE_NAME}" using LOGSECOND 100 DEFERRED
db2 update db cfg for "${DATABASE_NAME}" using LOGFILSIZ 8192 DEFERRED
db2 update db cfg for "${DATABASE_NAME}" using SOFTMAX 1000 DEFERRED
db2 update db cfg for "${DATABASE_NAME}" using MAXFILOP 61440 DEFERRED
db2 update db cfg for "${DATABASE_NAME}" using PCKCACHESZ AUTOMATIC DEFERRED
db2 update db cfg for "${DATABASE_NAME}" using STAT_HEAP_SZ AUTOMATIC DEFERRED
db2 update db cfg for "${DATABASE_NAME}" using STMTHEAP AUTOMATIC DEFERRED
db2 update db cfg for "${DATABASE_NAME}" using UTIL_HEAP_SZ 10000 DEFERRED
db2 update db cfg for "${DATABASE_NAME}" using DATABASE_MEMORY AUTOMATIC DEFERRED
db2 update db cfg for "${DATABASE_NAME}" using AUTO_STMT_STATS OFF DEFERRED
db2 update db cfg for "${DATABASE_NAME}" using STMT_CONC LITERALS DEFERRED
db2 update alert cfg for database on "${DATABASE_NAME}" using db.db_backup_req SET THRESHOLDSCHECKED YES
db2 update alert cfg for database on "${DATABASE_NAME}" using db.tb_reorg_req SET THRESHOLDSCHECKED YES
db2 update alert cfg for database on "${DATABASE_NAME}" using db.tb_runstats_req SET THRESHOLDSCHECKED YES
db2 update dbm cfg using PRIV_MEM_THRESH 32767 DEFERRED
db2 update dbm cfg using KEEPFENCED NO DEFERRED
db2 update dbm cfg using NUMDB 2 DEFERRED
db2 update dbm cfg using RQRIOBLK 65535 DEFERRED
db2 update dbm cfg using HEALTH_MON OFF DEFERRED
db2 update dbm cfg using AGENT_STACK_SZ 1000 DEFERRED
db2 update dbm cfg using MON_HEAP_SZ AUTOMATIC DEFERRED
db2 update db cfg using DDL_CONSTRAINT_DEF YES
db2set DB2_SKIPINSERTED=ON
db2set DB2_INLIST_TO_NLJN=YES
db2set DB2_MINIMIZE_LISTPREFETCH=Y
db2set DB2_EVALUNCOMMITTED=YES
db2set DB2_FMP_COMM_HEAPSZ=65536
db2set DB2_SKIPDELETED=ON
db2set DB2_USE_ALTERNATE_PAGE_CLEANING=ON
db2 CREATE BUFFERPOOL MAXBUFPOOL IMMEDIATE SIZE 4096 AUTOMATIC PAGESIZE 32 K
db2 CREATE REGULAR TABLESPACE MAXDATA PAGESIZE 32 K MANAGED BY AUTOMATIC STORAGE INITIALSIZE 5000 M BUFFERPOOL MAXBUFPOOL
db2 CREATE TEMPORARY TABLESPACE MAXTEMP PAGESIZE 32 K MANAGED BY AUTOMATIC STORAGE BUFFERPOOL MAXBUFPOOL
db2 CREATE REGULAR TABLESPACE MAXINDEX PAGESIZE 32 K MANAGED BY AUTOMATIC STORAGE INITIALSIZE 5000 M BUFFERPOOL MAXBUFPOOL
db2 CREATE SCHEMA MAXIMO AUTHORIZATION MAXIMO
db2 GRANT DBADM,CREATETAB,BINDADD,CONNECT,CREATE_NOT_FENCED_ROUTINE,IMPLICIT_SCHEMA,LOAD,CREATE_EXTERNAL_ROUTINE,QUIESCE_CONNECT,SECADM ON DATABASE TO USER MAXIMO
db2 GRANT USE OF TABLESPACE MAXDATA TO USER MAXIMO
db2 GRANT CREATEIN,DROPIN,ALTERIN ON SCHEMA MAXIMO TO USER MAXIMO

db2 connect reset
db2 terminate
db2 force applications all
db2 deactivate db "${DATABASE_NAME}"
db2stop
db2start
db2 activate db "${DATABASE_NAME}"

db2 get db cfg for "${DATABASE_NAME}" | grep -i org
db2 get db cfg for "${DATABASE_NAME}" | grep LOGARCHMETH