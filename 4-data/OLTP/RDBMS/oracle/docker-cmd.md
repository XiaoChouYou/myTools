
```shell
docker run -d  \
  --name test-oracle  \
  --privileged  \
  -v $(pwd)/oradata:/u01/app/oracle  \
  -p 8080:8080  \
  -p 1521:1521  \
  absolutapps/oracle-12c-ee
```

```shell
docker exec  -u oracle -it test-oracle   /bin/sh
```

```shell
$ORACLE_HOME/bin/sqlplus / as sysdba
```

```sql
--- 修改密码：
alter user system identified by oracle;
alter user sys identified by sys;
ALTER PROFILE DEFAULT LIMIT PASSWORD_LIFE_TIME UNLIMITED;
--- 创建用户
create user test identified by test;
grant connect,resource,dba to test;

```