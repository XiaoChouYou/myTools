
```shell
docker run -d   \
-p 20443:443  \
-p 20080:80  \
-p 20222:222   \
--name gitlab   \
--restart  always   \
-v /date/app/gitlab/config:/etc/gitlab  \
-v /date/app/gitlab/logs:/var/log/gitlab  \
-v /date/app/gitlab/data:/var/opt/gitlab  \
twang2218/gitlab-ce-zh 
```