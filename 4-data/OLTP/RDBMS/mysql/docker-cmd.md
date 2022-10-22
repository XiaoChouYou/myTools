```shell
docker run   \
--restart=always  \
--name mysql  \
-v /data/app/mysql8/cnf:/etc/mysql  \
-v /data/app/mysql8/data:/var/lib/mysql  \
-v /data/app/mysql8/log:/var/log  \
-v /data/app/mysql8/mysql-files:/var/lib/mysql-files  \
-p 13306:3306  \
-e MYSQL_ROOT_PASSWORD=123456  \
-d mysql:8.0.22 
```
