```shell
docker run   \
--restart=always  \
--name test-mysql  \
-v /data/app/mysql5.7/cnf:/etc/mysql  \
-v /data/app/mysql5.7/data:/var/lib/mysql  \
-v /data/app/mysql5.7/log:/var/log  \
-v /data/app/mysql5.7/mysql-files:/var/lib/mysql-files  \
-p 13306:3306  \
-e MYSQL_ROOT_PASSWORD=123456  \
-d mysql:5.7
```

```sql
create database test;
GRANT ALL ON *.* TO 'test'@'127.0.0.1' IDENTIFIED BY '123456';
GRANT ALL ON *.* TO 'test'@'localhost' IDENTIFIED BY '123456';
GRANT ALL ON *.* TO 'test'@'%' IDENTIFIED BY '123456';
```