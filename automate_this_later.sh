######################## Outside the vagrant vm ########################

# https://github.com/oracle/vagrant-boxes
cd "$HOME/VirtualBox VMs"
vagrant box add --name ol76 http://yum.oracle.com/boxes/oraclelinux/ol76/ol76.box
vagrant box list
vagrant box remove ubuntu/trusty64
vagrant box remove mirth/centos-7.1
vagrant box list
# Initialize an instance
vagrant init ol76
vagrant up
vagrant up --debug
vagrant version
# Uninstall vagrant 1.8.6
sudo rm -rf /opt/vagrant
sudo rm -f /usr/local/bin/vagrant
sudo pkgutil --forget com.vagrant.vagrant
# Install vagrant 2.2.5
vagrant version

vagrant box add --name ol76 http://yum.oracle.com/boxes/oraclelinux/ol76/ol76.box
# Initialize an instance
rm Vagrantfile
vagrant init ol76
vagrant up
vagrant ssh

######################## Inside the vagrant vm ########################

sudo su -
# get up to date
yum upgrade -y
# Oracle preinstall and openssl
yum install -y bc oracle-database-server-12cR2-preinstall openssl
# fix locale warning
yum reinstall -y glibc-common
echo LANG=en_US.utf-8 >> /etc/environment
echo LC_ALL=en_US.utf-8 >> /etc/environment
# Set the timezone
tzselect
SYSTEM_TIMEZONE=America/Los_Angeles
sudo timedatectl set-timezone $SYSTEM_TIMEZONE
# Exit root
exit
cd /vagrant
for file in /vagrant/p13390677_112040_Linux-x86-64_{3..7}of7.zip; do ls -la "${file}"; done
for file in /vagrant/p13390677_112040_Linux-x86-64_{3..7}of7.zip; do rm -f "${file}"; done
mkdir -p /orcl_home/app/stage/oracle_11.2.0.4
chown -R oracle:oinstall /orcl_home/app/stage/oracle_11.2.0.4
cp /vagrant/oracle_11.2.0.4/p13390677_112040_Linux-x86-64_[12]of7.zip /orcl_home/app/stage/oracle_11.2.0.4/
chown -R oracle:oinstall /orcl_home/app/stage/oracle_11.2.0.4
# Become oracle
sudo su - oracle
cd /orcl_home/app/stage/oracle_11.2.0.4
unzip p13390677_112040_Linux-x86-64_1of7.zip
unzip p13390677_112040_Linux-x86-64_2of7.zip
exit
# Become root
mkdir -p /orcl_home/app/oraInventory
chown -R oracle:oinstall /orcl_home
# Become oracle
sudo su - oracle
cp /orcl_home/app/stage/database/response/db_install.rsp /orcl_home/app/stage/oracle_11.2.0.4/db_install.rsp
diff /orcl_home/app/stage/database/response/db_install.rsp /orcl_home/app/stage/oracle_11.2.0.4/db_install.rsp
29c29
< oracle.install.option=
---
> oracle.install.option=INSTALL_DB_SWONLY
37c37
< ORACLE_HOSTNAME=
---
> ORACLE_HOSTNAME=localhost.localdomain
42c42
< UNIX_GROUP_NAME=
---
> UNIX_GROUP_NAME=oinstall
49c49
< INVENTORY_LOCATION=
---
> INVENTORY_LOCATION=/orcl_home/app/oraInventory
91c91
< ORACLE_HOME=
---
> ORACLE_HOME=/orcl_home/app/oracle/product/11.2.0.4/dbhome_2
96c96
< ORACLE_BASE=
---
> ORACLE_BASE=/orcl_home/app/oracle
107c107
< oracle.install.db.InstallEdition=
---
> oracle.install.db.InstallEdition=EE
154c154
< oracle.install.db.DBA_GROUP=
---
> oracle.install.db.DBA_GROUP=oinstall
160c160
< oracle.install.db.OPER_GROUP=
---
> oracle.install.db.OPER_GROUP=oinstall
388c388
< SECURITY_UPDATES_VIA_MYORACLESUPPORT=
---
> SECURITY_UPDATES_VIA_MYORACLESUPPORT=false
400c400
< DECLINE_SECURITY_UPDATES=
---
> DECLINE_SECURITY_UPDATES=true
cd /orcl_home/app/stage/database
./runInstaller -silent -ignorePrereq -ignoreSysPrereqs -showProgress -responseFile /orcl_home/app/stage/oracle_11.2.0.4/db_install.rsp
# Exit oracle
exit
# As root run
/orcl_home/app/oraInventory/orainstRoot.sh
/orcl_home/app/oracle/product/11.2.0.4/dbhome_2/root.sh
# Become oracle
sudo su - oracle
cat >> ~/.bashrc <<EOF
export ORACLE_BASE=/orcl_home/app/oracle
export ORACLE_HOME=$ORACLE_BASE/product/11.2.0.4/dbhome_2
EOF
cat ~/.bashrc
env | grep ORAC

diff /orcl_home/app/stage/database/response/dbca.rsp /orcl_home/app/stage/oracle_11.2.0.4/dbca.rsp
78c78
< GDBNAME = "orcl11g.us.oracle.com"
---
> GDBNAME = "oradb"
170c170
< SID = "orcl11g"
---
> SID = "oradb"
211c211
< #SYSPASSWORD = "password"
---
> SYSPASSWORD = "password"
221c221
< #SYSTEMPASSWORD = "password"
---
> SYSTEMPASSWORD = "password"
252c252
< #SYSMANPASSWORD = "password"
---
> SYSMANPASSWORD = "password"
262c262
< #DBSNMPPASSWORD = "password"
---
> DBSNMPPASSWORD = "password"
418c418
< #CHARACTERSET = "US7ASCII"
---
> CHARACTERSET = "US7ASCII"
428c428
< #NATIONALCHARACTERSET= "UTF8"
---
> NATIONALCHARACTERSET= "AL16UTF16"
589c589
< #SYSDBAPASSWORD = "password"
---
> SYSDBAPASSWORD = "password"
623c623
< #SYSDBAUSERNAME = "sys"
---
> SYSDBAUSERNAME = "sys"
$ORACLE_HOME/bin/dbca -silent -responseFile /orcl_home/app/stage/oracle_11.2.0.4/dbca.rsp

ps -ef | grep pmon
oracle     896     1  0 14:52 ?        00:00:00 ora_pmon_oradb
oracle     968 32482  0 14:55 pts/1    00:00:00 grep --color=auto pmon

. oraenv
ORACLE_SID = [oracle] ? oradb

sqlplus / as sysdba
SQL> !cat /etc/oratab
SQL> shutdown immediate
SQL> exit

adrci
adrci> show alert
adrci> exit


######################## Take VM snapshot       ########################
# Exit oracle user
exit
# Become root
su -
shutdown -h now
######################## Outside the vagrant vm ########################
# Take VM snapshot
vagrant snapshot list
vagrant snapshot save "1. Oracle 11 before 18c upgrade"
vagrant up
vagrant ssh
########################################################################


######################## Inside the vagrant vm ########################
# Become root
su
yum install -y oracle-database-preinstall-18c
yum update -y
# Start the Oracle 18.0.0 installation
export ORACLE_BASE=/orcl_home/app/oracle
export ORACLE_HOME=$ORACLE_BASE/product/18.0.0/dbhome_1
export SOFTWARE_DIR=/orcl_home/app/stage
export ORA_INVENTORY=/orcl_home/app/oraInventory
mkdir -p $ORACLE_HOME
cd $ORACLE_HOME
unzip -oq $SOFTWARE_DIR/LINUX.X64_180000_db_home.zip
./runInstaller -ignorePrereq -waitforcompletion -silent          \
    -responseFile ${ORACLE_HOME}/install/response/db_install.rsp \
    oracle.install.option=INSTALL_DB_SWONLY                      \
    ORACLE_HOSTNAME=${ORACLE_HOSTNAME}                           \
    UNIX_GROUP_NAME=oinstall                                     \
    INVENTORY_LOCATION=${ORA_INVENTORY}                          \
    SELECTED_LANGUAGES=en,en_GB                                  \
    ORACLE_HOME=${ORACLE_HOME}                                   \
    ORACLE_BASE=${ORACLE_BASE}                                   \
    oracle.install.db.InstallEdition=EE                          \
    oracle.install.db.OSDBA_GROUP=dba                            \
    oracle.install.db.OSBACKUPDBA_GROUP=dba                      \
    oracle.install.db.OSDGDBA_GROUP=dba                          \
    oracle.install.db.OSKMDBA_GROUP=dba                          \
    oracle.install.db.OSRACDBA_GROUP=dba                         \
    SECURITY_UPDATES_VIA_MYORACLESUPPORT=false                   \
    DECLINE_SECURITY_UPDATES=true

# Exit oracle user
exit
# Become root
su -
# as root
/orcl_home/app/oracle/product/18.0.0/dbhome_1/root.sh


######################## Take VM snapshot       ########################
shutdown -h now
######################## Outside the vagrant vm ########################
# Take VM snapshot
vagrant snapshot list
vagrant snapshot save "2. Oracle 11 while 18c files ready"
vagrant up
vagrant ssh
########################################################################


######################## Inside the vagrant vm ########################
sudo su - oracle
# 11.2.0.4 ORACLE_HOME=/orcl_home/app/oracle/product/11.2.0.4/dbhome_2
# 18.0.0   ORACLE_HOME=/orcl_home/app/oracle/product/18.0.0/dbhome_1

sqlplus / as sysdba
SQL> !cat /etc/oratab
SQL> shutdown immediate
SQL> exit


# Copy spfile, and password files to new home and update the home and hostname if needed
cd /orcl_home/app/oracle/product/11.2.0.4/dbhome_2/dbs
cp init.ora        /orcl_home/app/oracle/product/18.0.0/dbhome_1/dbs/
cp spfileoradb.ora /orcl_home/app/oracle/product/18.0.0/dbhome_1/dbs/
cp orapworadb      /orcl_home/app/oracle/product/18.0.0/dbhome_1/dbs/

# Copy tnsnames.ora, sqlnet.ora, listener.ora to new home
cd /orcl_home/app/oracle/product/11.2.0.4/dbhome_2/network/admin
cp listener.ora /orcl_home/app/oracle/product/18.0.0/dbhome_1/network/admin/
cp sqlnet.ora   /orcl_home/app/oracle/product/18.0.0/dbhome_1/network/admin/
cp tnsnames.ora /orcl_home/app/oracle/product/18.0.0/dbhome_1/network/admin/

# Remove hidden(_), obsolete, deprecated params
# 
# WHICH ONES?

# update COMPATIBLE param to minimum value of 11.2.0
export ORACLE_HOME=$ORACLE_BASE/product/11.2.0.4/dbhome_2
cd $ORACLE_HOME
. oraenv
ORACLE_SID = [oracle] ? oradb

$ORACLE_HOME/bin/sqlplus / as sysdba
SQL> startup
SQL> shutdown immediate
SQL> exit


export ORACLE_HOME=$ORACLE_BASE/product/18.0.0/dbhome_1
$ORACLE_HOME/bin/sqlplus / as sysdba
SQL> !cat /etc/oratab
SQL> startup nomount
SQL> SELECT name, value FROM v$parameter WHERE name = 'compatible';
SQL> ALTER SYSTEM SET COMPATIBLE = '11.2.0.4.0' SCOPE=SPFILE;
SQL> shutdown immediate
SQL> exit


###################################################################
# I had to reinstall OPatch since I hosed my install by mystake
###################################################################
# # Install OPatch_11.2.0.3.21_for_11.x
# export ORACLE_HOME=$ORACLE_BASE/product/11.2.0.4/dbhome_2
# cd $ORACLE_HOME
# # Upgrade OPatch
# rm -rf $ORACLE_HOME/OPatch
# # unzip /orcl_home/app/stage/OPatch_11.2.0.3.21_for_11.x/p6880880_112000_Linux-x86-64.zip
# unzip /vagrant/oracle_patches/OPatch_11.2.0.3.21_for_11.x/p6880880_112000_Linux-x86-64.zip
# $ORACLE_HOME/OPatch/opatch lsinventory

###################################################################
# I had to reinstall OPatch since I hosed my install by mystake
###################################################################
# # Install OPatch_12.2.0.1.17_for_18.x
# export ORACLE_HOME=$ORACLE_BASE/product/18.0.0/dbhome_1
# cd $ORACLE_HOME
# # Upgrade OPatch
# rm -rf $ORACLE_HOME/OPatch
# # unzip /orcl_home/app/stage/OPatch_12.2.0.1.17_for_18.x/p6880880_122010_Linux-x86-64.zip
# unzip /vagrant/oracle_patches/OPatch_12.2.0.1.17_for_18.x/p6880880_122010_Linux-x86-64.zip
# $ORACLE_HOME/OPatch/opatch lsinventory


# Apply 29213893 on 18c ORACLE_HOME to avoid ORA-01422 error (DocID 2525596.1)
# Verify binaries are on Patch description:  "Database Release Update : 18.3.0.0.180717 (28090523)"
# apply patch
export ORACLE_HOME=$ORACLE_BASE/product/18.0.0/dbhome_1
cd $ORACLE_HOME
# Copy and unzip the PATCH ZIP FILE
# unzip /orcl_home/app/stage/p29213893_183000DBRU_Generic.zip
unzip /vagrant/oracle_patches/p29213893_183000DBRU_Generic.zip
cd 29213893
# Check for conflict against ORACLE_HOME
$ORACLE_HOME/OPatch/opatch prereq CheckConflictAgainstOHWithDetail -ph ./
# Check for active executables
$ORACLE_HOME/OPatch/opatch prereq CheckActiveFilesAndExecutables -ph ./
# Apply the patch:
$ORACLE_HOME/OPatch/opatch apply
# Check the inventory, whether the patch has been updated or not
$ORACLE_HOME/OPatch/opatch lsinventory
cd ..
rm -rf 29213893

# Patches to apply before upgrading Oracle GI and DB to 18c or downgrading to previous release (Doc ID 2414935.1)
# NA for our system
# Timezone patch - opatch apply
cd $ORACLE_HOME
# Copy and unzip the PATCH ZIP FILE
# unzip /orcl_home/app/stage/p28125601_183000DBRU_Linux-x86-64.zip
unzip /vagrant/oracle_patches/p28125601_183000DBRU_Linux-x86-64.zip
cd 28125601
# Apply the patch:
$ORACLE_HOME/OPatch/opatch apply
cd ..
rm -rf 28125601

cd $ORACLE_HOME
# Copy and unzip the PATCH ZIP FILE
unzip /vagrant/oracle_patches/p28127287_180000_Generic.zip
cd 28127287
# Apply the patch:
$ORACLE_HOME/OPatch/opatch apply
cd ..
rm -rf 28127287

######################## Preupgrade HFusion ########################

export ORACLE_HOME=$ORACLE_BASE/product/18.0.0/dbhome_1
cd $ORACLE_HOME/rdbms/admin
unzip -o /vagrant/oracle_patches/preupgrade_181_cbuild_7_lf.zip

export ORACLE_HOME=$ORACLE_BASE/product/11.2.0.4/dbhome_2
cd $ORACLE_HOME
cp /vagrant/oracle_patches/dbupgdiag.sql .

# Script to Collect DB Upgrade/Migrate Diagnostic Information (dbupgdiag.sql) (Doc ID 556610.1)
# run dbupgdiag.sql
. oraenv
ORACLE_SID = [oradb] ? oradb

$ORACLE_HOME/bin/sqlplus / as sysdba
SQL> startup
ORA-00845: MEMORY_TARGET not supported on this system
SQL> exit

# Fix error ORA-00845: MEMORY_TARGET not supported on this system
# Exit oracle user
exit
# Become root
su -
mount -t tmpfs shmfs -o size=2048m /dev/shm
exit
sudo su - oracle

. oraenv
ORACLE_SID = [oradb] ? oradb

cd $ORACLE_HOME
$ORACLE_HOME/bin/sqlplus / as sysdba
SQL> startup
SQL> alter session set nls_language='American';
SQL> @dbupgdiag.sql
Enter location for Spooled output:
Enter value for 1: /tmp
SQL> exit

# Check to see if there are any issues with the log
less /tmp/db_upg_diag_oradb_30_Sep_2019_0547.log


######################## Take VM snapshot       ########################
# Exit oracle user
exit
# Become root
su -
shutdown -h now
######################## Outside the vagrant vm ########################
vagrant snapshot list
vagrant snapshot save "3. Oracle 11 dbupgdiag.sql ran."
vagrant up
vagrant ssh
########################################################################


######################## Inside the vagrant vm ########################
sudo su - oracle
export ORACLE_SID=oradb
export ORACLE_HOME=$ORACLE_BASE/product/11.2.0.4/dbhome_2
. oraenv
ORACLE_SID = [oradb] ? oradb
ORACLE_HOME = /orcl_home/app/oracle/product/11.2.0.4/dbhome_2
$ORACLE_HOME/bin/sqlplus / as sysdba
SQL> startup
SQL> exit

# run preupgrade.jar in 11.2.0.4 home
# review results and fix the 'BEFORE UPGRADE' actions
# $Earlier_release_Oracle_home/jdk/bin/java -jar $New_release_Oracle_home/rdbms/admin/preupgrade.jar FILE TEXT DIR output_dir
#$ORACLE_HOME/jdk/bin/java -jar $ORACLE_BASE/product/18.0.0/dbhome_1/rdbms/admin/preupgrade.jar TERMINAL TEXT
$ORACLE_HOME/jdk/bin/java -jar $ORACLE_BASE/product/18.0.0/dbhome_1/rdbms/admin/preupgrade.jar FILE TEXT
less /orcl_home/app/oracle/cfgtoollogs/oradb/preupgrade/preupgrade.log


######################## Take VM snapshot       ########################
# Exit oracle user
exit
# Become root
su -
shutdown -h now
######################## Outside the vagrant vm ########################
vagrant snapshot list
vagrant snapshot save "4. Oracle 11 preupgrade.jar ran."
vagrant up
vagrant ssh
########################################################################

# Become root
su -
df -kh /dev/shm
# Filesystem      Size  Used Avail Use% Mounted on
# tmpfs           863M  210M  654M  25% /dev/shm
umount tmpfs
mount -t tmpfs shmfs -o size=2048m /dev/shm
df -kh /dev/shm
# Filesystem      Size  Used Avail Use% Mounted on
# shmfs           2.0G     0  2.0G   0% /dev/shm
cat >> /etc/fstab <<'EOF'
tmpfs                   /dev/shm                tmpfs   size=2048m      0 0
EOF
exit


sudo su - oracle
export ORACLE_SID=oradb
export ORACLE_HOME=$ORACLE_BASE/product/11.2.0.4/dbhome_2
. oraenv
ORACLE_SID = [oradb] ? oradb
ORACLE_HOME = /orcl_home/app/oracle/product/11.2.0.4/dbhome_2
$ORACLE_HOME/bin/sqlplus / as sysdba
SQL> shutdown immediate
SQL> exit


export ORACLE_SID=oradb
export ORACLE_HOME=$ORACLE_BASE/product/11.2.0.4/dbhome_2
. oraenv
ORACLE_SID = [oradb] ? oradb
ORACLE_HOME = /orcl_home/app/oracle/product/11.2.0.4/dbhome_2
$ORACLE_HOME/bin/sqlplus / as sysdba
SQL> startup
SQL> show parameter target;
SQL> show parameter memory_max_target;
SQL> show parameter memory_target;
SQL> create pfile from spfile;
SQL> ALTER SYSTEM SET MEMORY_MAX_TARGET=2048m SCOPE=SPFILE;
SQL> shutdown immediate
SQL> startup
SQL> show parameter target;
SQL> show parameter memory_max_target;
SQL> show parameter memory_target;
SQL> ALTER SYSTEM SET MEMORY_TARGET=1400m SCOPE=BOTH;
SQL> shutdown immediate
SQL> exit


######################## Take VM snapshot       ########################
# Exit oracle user
exit
# Become root
su -
shutdown -h now
######################## Outside the vagrant vm ########################
vagrant snapshot list
vagrant snapshot save "5. Oracle 11 resized tmpfs, oracle memory_max_target and memory_target."
vagrant up
vagrant ssh
########################################################################


sudo su - oracle
export ORACLE_SID=oradb
export ORACLE_HOME=$ORACLE_BASE/product/11.2.0.4/dbhome_2
. oraenv
ORACLE_SID = [oradb] ? oradb
ORACLE_HOME = /orcl_home/app/oracle/product/11.2.0.4/dbhome_2
$ORACLE_HOME/bin/sqlplus / as sysdba
SQL> startup
SQL> exit

$ORACLE_HOME/jdk/bin/java -jar $ORACLE_BASE/product/18.0.0/dbhome_1/rdbms/admin/preupgrade.jar FILE TEXT
less /orcl_home/app/oracle/cfgtoollogs/oradb/preupgrade/preupgrade.log

$ORACLE_HOME/bin/sqlplus / as sysdba
SQL> show parameter processes;
SQL> create pfile from spfile;
SQL> ALTER SYSTEM SET PROCESSES=300 SCOPE=SPFILE;
SQL> shutdown immediate
SQL> startup
SQL> show parameter processes;
SQL> exit

$ORACLE_HOME/jdk/bin/java -jar $ORACLE_BASE/product/18.0.0/dbhome_1/rdbms/admin/preupgrade.jar FILE TEXT
less /orcl_home/app/oracle/cfgtoollogs/oradb/preupgrade/preupgrade.log
# clear; cat /orcl_home/app/oracle/cfgtoollogs/oradb/preupgrade/preupgrade_fixups.sql
# clear; cat /orcl_home/app/oracle/cfgtoollogs/oradb/preupgrade/postupgrade_fixups.sql

cp $ORACLE_BASE/product/18.0.0/dbhome_1/rdbms/admin/emremove.sql $ORACLE_BASE/product/11.2.0.4/dbhome_2/
export ORACLE_UNQNAME=oradb
emctl stop dbconsole

cd $ORACLE_HOME
$ORACLE_HOME/bin/sqlplus / as sysdba
SQL> SET ECHO ON;
SQL> SET SERVEROUTPUT ON;
SQL> @emremove.sql
SQL> @/orcl_home/app/oracle/product/11.2.0.4/dbhome_2/olap/admin/catnoamd.sql
SQL> exit

# Download Oracle Application Express 5.1.3 - English language only from
# https://www.oracle.com/tools/downloads/apex-v51-downloads.html
su -
cp /vagrant/oracle_application_express/apex_5.1.3_en.zip /orcl_home/app/stage/
chown -R oracle:oinstall /orcl_home/app/stage/apex_5.1.3_en.zip
# Become oracle
sudo su - oracle
cd /orcl_home/app/stage/
# https://www.oracle.com/database/technologies/upgrade-apex-within-database-11g-xe.html
unzip apex_5.1.3_en.zip
cd apex
export ORACLE_SID=oradb
export ORACLE_HOME=$ORACLE_BASE/product/11.2.0.4/dbhome_2
. oraenv
ORACLE_SID = [oradb] ? oradb
ORACLE_HOME = /orcl_home/app/oracle/product/11.2.0.4/dbhome_2
$ORACLE_HOME/bin/sqlplus / as sysdba
SQL> -- Install Application Express:
SQL> @apexins SYSAUX SYSAUX TEMP /i/
Disconnected

$ORACLE_HOME/bin/sqlplus / as sysdba
SQL> -- Log back into SQL*Plus (as above) and configure the Embedded PL/SQL Gateway (EPG):
SQL> @apex_epg_config.sql APEX_HOME
...
declare
*
ERROR at line 1:
ORA-22288: file or LOB operation FILEOPEN failed
No such file or directory
ORA-06512: at "SYS.XMLTYPE", line 296
ORA-06512: at line 16
...
SQL> -- Upgrade Application Express password:
SQL> @apxchpwd
SQL> -- Set password to Ap3x!!
SQL> exit

cd $ORACLE_HOME
$ORACLE_HOME/bin/sqlplus / as sysdba
SQL> EXECUTE DBMS_STATS.GATHER_DICTIONARY_STATS;
SQL> SELECT OWNER,
      TRIGGER_NAME FROM DBA_TRIGGERS WHERE TRIM(BASE_OBJECT_TYPE)='DATABASE'
      AND OWNER NOT IN (SELECT GRANTEE FROM DBA_SYS_PRIVS WHERE
      PRIVILEGE='ADMINISTER DATABASE TRIGGER');
SQL> -- no rows selected
SQL> -- if we had a result set, we would grant privileges as follows
SQL> -- grant administer database trigger to userName;
SQL> execute dbms_stats.gather_fixed_objects_stats;
SQL> @/orcl_home/app/oracle/cfgtoollogs/oradb/preupgrade/preupgrade_fixups.sql
SQL> exit

######################## Take VM snapshot       ########################
# Exit oracle user
exit
# Become root
su -
shutdown -h now
######################## Outside the vagrant vm ########################
vagrant snapshot list
vagrant snapshot save "6. Oracle 11 ran recommended actions before upgrade."
vagrant up
vagrant ssh
########################################################################

sudo su - oracle
export ORACLE_SID=oradb
export ORACLE_HOME=$ORACLE_BASE/product/11.2.0.4/dbhome_2
cd /orcl_home/app/stage/apex
. oraenv
ORACLE_SID = [oradb] ? oradb
ORACLE_HOME = /orcl_home/app/oracle/product/11.2.0.4/dbhome_2
$ORACLE_HOME/bin/sqlplus / as sysdba
SQL> startup
SQL> -- Remove Application Express
SQL> @apxremov.sql
SQL> exit

$ORACLE_HOME/jdk/bin/java -jar $ORACLE_BASE/product/18.0.0/dbhome_1/rdbms/admin/preupgrade.jar FILE TEXT
less /orcl_home/app/oracle/cfgtoollogs/oradb/preupgrade/preupgrade.log

$ORACLE_HOME/bin/sqlplus / as sysdba
SQL> SET SERVEROUTPUT ON;
SQL> EXECUTE DBMS_PREUP.INVALID_OBJECTS;
SQL> -- https://docs.oracle.com/cd/E14373_01/install.32/e13366/trouble.htm#HTMIG270
SQL> DROP USER APEX_030200 CASCADE;
SQL> shutdown immediate
SQL> startup
SQL> exit

$ORACLE_HOME/jdk/bin/java -jar $ORACLE_BASE/product/18.0.0/dbhome_1/rdbms/admin/preupgrade.jar FILE TEXT
less /orcl_home/app/oracle/cfgtoollogs/oradb/preupgrade/preupgrade.log

$ORACLE_HOME/bin/sqlplus / as sysdba
SQL> SET SERVEROUTPUT ON;
SQL> EXECUTE DBMS_PREUP.INVALID_OBJECTS;
SQL> 
SQL> @$ORACLE_HOME/rdbms/admin/utlrp.sql
SQL> 
SQL> SET SERVEROUTPUT ON;
SQL> EXECUTE DBMS_PREUP.INVALID_OBJECTS;
SQL> -- Invalid trigger FLOWS_FILES.WWV_BIU_FLOW_FILE_OBJECTS
SQL> 
SQL> SET SERVEROUTPUT ON;
SQL> BEGIN
SQL>    DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform, 'SQLTERMINATOR', true);
SQL>    DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform, 'PRETTY', true);
SQL> END;
SQL> /
SQL> SELECT DBMS_METADATA.GET_DDL('TRIGGER', 'WWV_BIU_FLOW_FILE_OBJECTS', 'FLOWS_FILES') Text FROM SYS.DUAL;
SQL> ALTER TRIGGER FLOWS_FILES.wwv_biu_flow_file_objects DISABLE;
SQL> DROP TRIGGER FLOWS_FILES.wwv_biu_flow_file_objects;
SQL> exit

$ORACLE_HOME/jdk/bin/java -jar $ORACLE_BASE/product/18.0.0/dbhome_1/rdbms/admin/preupgrade.jar FILE TEXT
less /orcl_home/app/oracle/cfgtoollogs/oradb/preupgrade/preupgrade.log

$ORACLE_HOME/bin/sqlplus / as sysdba
SQL> SET SERVEROUTPUT ON;
SQL> EXECUTE DBMS_PREUP.INVALID_OBJECTS;
SQL> 
SQL> DROP PACKAGE BODY SYS.WWV_DBMS_SQL;
SQL> 
SQL> SET SERVEROUTPUT ON;
SQL> EXECUTE DBMS_PREUP.INVALID_OBJECTS;
SQL> exit

$ORACLE_HOME/jdk/bin/java -jar $ORACLE_BASE/product/18.0.0/dbhome_1/rdbms/admin/preupgrade.jar FILE TEXT
less /orcl_home/app/oracle/cfgtoollogs/oradb/preupgrade/preupgrade.log

$ORACLE_HOME/bin/sqlplus / as sysdba
SQL> @/orcl_home/app/oracle/cfgtoollogs/oradb/preupgrade/preupgrade_fixups.sql
SQL> shutdown immediate
SQL> startup
SQL> purge dba_recyclebin;
SQL> 
SQL> SELECT o.name FROM sys.obj$ o, sys.user$ u, sys.sum$ s WHERE o.type# = 42 AND bitand(s.mflags, 8) =8;
SQL> SELECT * FROM v$backup WHERE status != 'NOT ACTIVE'; 
SQL> execute dbms_stats.gather_dictionary_stats;
SQL> execute dbms_stats.gather_fixed_objects_stats;
SQL> exit


# Upgrade!
$ORACLE_HOME/bin/sqlplus / as sysdba
SQL> alter system checkpoint;
SQL> alter system switch logfile; --7x
SQL> shutdown immediate
SQL> exit

cd /orcl_home/app/oracle/product/11.2.0.4/dbhome_2/dbs
cp init.ora        /orcl_home/app/oracle/product/18.0.0/dbhome_1/dbs/
cp spfileoradb.ora /orcl_home/app/oracle/product/18.0.0/dbhome_1/dbs/
cp orapworadb      /orcl_home/app/oracle/product/18.0.0/dbhome_1/dbs/

cd /orcl_home/app/oracle/product/11.2.0.4/dbhome_2/network/admin
cp listener.ora /orcl_home/app/oracle/product/18.0.0/dbhome_1/network/admin/
cp sqlnet.ora   /orcl_home/app/oracle/product/18.0.0/dbhome_1/network/admin/
cp tnsnames.ora /orcl_home/app/oracle/product/18.0.0/dbhome_1/network/admin/

export ORACLE_BASE=/orcl_home/app/oracle
export ORACLE_HOME=$ORACLE_BASE/product/18.0.0/dbhome_1
export SOFTWARE_DIR=/orcl_home/app/stage
export ORA_INVENTORY=/orcl_home/app/oraInventory

# Upgrade mode
$ORACLE_HOME/bin/sqlplus / as sysdba
SQL> startup upgrade
SQL> exit
cd $ORACLE_HOME/bin
./dbupgrade

$ORACLE_HOME/bin/sqlplus / as sysdba
SQL> startup
SQL> @/orcl_home/app/oracle/cfgtoollogs/oradb/preupgrade/postupgrade_fixups.sql
SQL> exit
SQL> 
SQL> -- https://oracle-base.com/articles/misc/update-database-time-zone-file
SQL> select  version FROM v$timezone_file;
SQL> --    VERSION
SQL> -- ----------
SQL> --         14
SQL> 
SQL> select TZ_VERSION from registry$database;
SQL> -- TZ_VERSION
SQL> -- ----------
SQL> --         14
SQL> 
SQL> SELECT DBMS_DST.get_latest_timezone_version
SQL> FROM   dual;
SQL> -- GET_LATEST_TIMEZONE_VERSION
SQL> -- ---------------------------
SQL> --              32
SQL> 
SQL> -- Use the BEGIN_PREPARE procedure, passing in the file version you want to upgrade to. 
SQL> -- In this case we are selecting the latest version.
SQL> DECLARE
SQL>   l_tz_version PLS_INTEGER;
SQL> BEGIN
SQL>   l_tz_version := DBMS_DST.get_latest_timezone_version;
SQL> 
SQL>   DBMS_OUTPUT.put_line('l_tz_version=' || l_tz_version);
SQL>   DBMS_DST.begin_prepare(l_tz_version);
SQL> END;
SQL> /
SQL> -- We can now check the upgrade we are going to attempt. 
SQL> -- Notice the DST_SECONDARY_TT_VERSION column is now populated.
SQL> COLUMN property_name FORMAT A30
SQL> COLUMN property_value FORMAT A20
SQL> 
SQL> SELECT property_name, property_value
SQL> FROM   database_properties
SQL> WHERE  property_name LIKE 'DST_%'
SQL> ORDER BY property_name;
SQL> 
SQL> PROPERTY_NAME              PROPERTY_VALUE
SQL> ------------------------------ --------------------
SQL> DST_PRIMARY_TT_VERSION         14
SQL> DST_SECONDARY_TT_VERSION       32
SQL> DST_UPGRADE_STATE          PREPARE
SQL>
SQL> -- Empty the default tables that hold the affected tables list and errors.
SQL> TRUNCATE TABLE sys.dst$affected_tables;
SQL> TRUNCATE TABLE sys.dst$error_table;
SQL> 
SQL> -- Find tables affected by the upgrade. 
SQL> -- Depending on your use of TIMESTAMP WITH TIME ZONE columns, you might not have any.
SQL> EXEC DBMS_DST.find_affected_tables;
SQL> 
SQL> -- Check the results of the call.
SQL> SELECT * FROM sys.dst$affected_tables;
SQL> SELECT * FROM sys.dst$error_table;
SQL> 
SQL> -- When you have identified the affected tables and determined you 
SQL> -- are happy to continue, you can end the prepare phase.
SQL> EXEC DBMS_DST.end_prepare;
SQL> 
SQL> -- Put the database into upgrade mode.
SQL> SHUTDOWN IMMEDIATE;
SQL> STARTUP UPGRADE;
SQL> 
SQL> -- Begin the upgrade to the latest version.
SQL> SET SERVEROUTPUT ON
SQL> DECLARE
SQL>   l_tz_version PLS_INTEGER;
SQL> BEGIN
SQL>   SELECT DBMS_DST.get_latest_timezone_version
SQL>   INTO   l_tz_version
SQL>   FROM   dual;
SQL> 
SQL>   DBMS_OUTPUT.put_line('l_tz_version=' || l_tz_version);
SQL>   DBMS_DST.begin_upgrade(l_tz_version);
SQL> END;
SQL> /
SQL> 
SQL> -- Restart the database.
SQL> SHUTDOWN IMMEDIATE;
SQL> STARTUP;
SQL> 
SQL> -- Do the upgrade of the database file zone file.
SQL> SET SERVEROUTPUT ON
SQL> DECLARE
SQL>   l_failures   PLS_INTEGER;
SQL> BEGIN
SQL>   DBMS_DST.upgrade_database(l_failures);
SQL>   DBMS_OUTPUT.put_line('DBMS_DST.upgrade_database : l_failures=' || l_failures);
SQL>   DBMS_DST.end_upgrade(l_failures);
SQL>   DBMS_OUTPUT.put_line('DBMS_DST.end_upgrade : l_failures=' || l_failures);
SQL> END;
SQL> /
SQL> 
SQL> -- The {CDB|DBA|ALL|USER}_TSTZ_TABLES views display the tables that are processed 
SQL> -- by the time zone file upgrade, and their current upgrade status. The following 
SQL> -- examples show how they could be used for a CDB an non-CDB database.
SQL> -- CDB
SQL> COLUMN owner FORMAT A30
SQL> COLUMN table_name FORMAT A30
SQL> 
SQL> SELECT con_id,
SQL>        owner,
SQL>        table_name,
SQL>        upgrade_in_progress
SQL> FROM   cdb_tstz_tables
SQL> ORDER BY 1,2,3;
SQL> 
SQL> -- Non-CDB
SQL> COLUMN owner FORMAT A30
SQL> COLUMN table_name FORMAT A30
SQL> 
SQL> SELECT owner,
SQL>        table_name,
SQL>        upgrade_in_progress
SQL> FROM   dba_tstz_tables
SQL> ORDER BY 1,2;
SQL> 
SQL> -- Once the upgrade is complete, check the time zone file version being used.
SQL> SELECT * FROM v$timezone_file;
SQL> 
SQL> COLUMN property_name FORMAT A30
SQL> COLUMN property_value FORMAT A20
SQL> 
SQL> SELECT property_name, property_value
SQL> FROM   database_properties
SQL> WHERE  property_name LIKE 'DST_%'
SQL> ORDER BY property_name;
SQL> -- Done
SQL> 
SQL> shutdown immediate
SQL> exit


######################## Take VM snapshot       ########################
# Exit oracle user
exit
# Become root
su -
shutdown -h now
######################## Outside the vagrant vm ########################
vagrant snapshot list
vagrant snapshot delete "7. Oracle 18 post upgrade database TZ file using the DBMS_DST package."
vagrant snapshot save "7. Oracle 18 post upgrade database TZ file using the DBMS_DST package."
vagrant up
vagrant ssh
########################################################################


export ORACLE_BASE=/orcl_home/app/oracle
export ORACLE_HOME=$ORACLE_BASE/product/18.0.0/dbhome_1
export SOFTWARE_DIR=/orcl_home/app/stage
export ORA_INVENTORY=/orcl_home/app/oraInventory

# Upgrade mode
$ORACLE_HOME/bin/sqlplus / as sysdba
SQL> startup
SQL> exit

# .bash_profile is executed for login shells, while .bashrc is executed for interactive non-login shells.
# To check if you are in a login shell
# shopt -q login_shell && echo 'Login shell' || echo 'Not login shell'
sed -i 's/11.2.0.4\/dbhome_2/18.0.0\/dbhome_1/g' $HOME/.bash_profile
# Become vagrant
exit
sudo sed -i 's/11.2.0.4\/dbhome_2/18.0.0\/dbhome_1/g' /etc/oratab
# Become oracle
su - oracle

sed -i '/# User specific aliases and functions/ a \
export ORACLE_BASE=\/orcl_home\/app\/oracle\
export ORACLE_HOME=$ORACLE_BASE\/product\/18.0.0\/dbhome_1\
export ORACLE_SID=oradb\
export ORAENV_ASK=NO\
. \$ORACLE_HOME/bin/oraenv\
' $HOME/.bash_profile

sed -i 's/^PATH=\$PATH:\$HOME\/.local\/bin:\$HOME\/bin$/PATH=\$PATH:\$HOME\/.local\/bin:\$HOME\/bin:\$ORACLE_HOME\/bin/g' $HOME/.bash_profile

rm -rf $ORACLE_BASE/product/11.2.0.4
exit
su - oracle

# In a new Terminal window
vagrant ssh
sudo su - oracle
# No need to run oradev since it is run from $HOME/.bash_profile
# . oraenv
# Read preupgrade.log
less /orcl_home/app/oracle/cfgtoollogs/oradb/preupgrade/preupgrade.log

# In another window
sudo su - oracle
$ORACLE_HOME/bin/sqlplus / as sysdba
SQL> EXECUTE DBMS_STATS.GATHER_DICTIONARY_STATS;
SQL> EXECUTE DBMS_STATS.GATHER_FIXED_OBJECTS_STATS;
SQL> @/orcl_home/app/oracle/cfgtoollogs/oradb/preupgrade/postupgrade_fixups.sql
SQL> exit

# Uninstall OWB (Oracle Warehouse Builder)