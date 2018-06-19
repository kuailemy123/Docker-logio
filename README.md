### logio
---
[logio](https://github.com/NarrativeScience/Log.io)是提供在浏览器中的实时日志监控程序, 由node.js + socket.io提供支持。


### 变量
---
- LOGIO_SERVICE  启动的服务, harvester or server 。

### 版本
---
- 0.3.4 (docker tags: 0.3.4, latest) : logio 版本为0.3.4

### 配置文件
`harvester.conf`
```
exports.config = {
  nodeName: "application_server",
  logStreams: {
    apache: [
      "/var/log/apache2/access.log",
      "/var/log/apache2/error.log"
    ]
  },
  server: {
    host: '0.0.0.0',
    port: 28777
  }
}
```
`web_server.conf`
```bash
exports.config = {
  host: '0.0.0.0',
  port: 28778,

  /* 
  // Enable HTTP Basic Authentication
  auth: {
    user: "admin",
    pass: "1234"
  },
  */

  /* 
  // Enable HTTPS/SSL
  ssl: {
    key: '/path/to/privatekey.pem',
    cert: '/path/to/certificate.pem'
  },
  */

  /*
  // Restrict access to websocket (socket.io)
  // Uses socket.io 'origins' syntax
  restrictSocket: '*:*',
  */

  /*
  // Restrict access to http server (express)
  restrictHTTP: [
    "192.168.29.39",
    "10.0.*"
  ]
  */

}
```

`log_server.conf`

```bash
exports.config = {
  host: '0.0.0.0',
  port: 28777
}
```

### 使用
---
```bash
docker network create --subnet=172.70.0.0/16 --gateway=172.70.0.1 --driver bridge logio
docker run -tid --network logio --name logio_harvester --restart=always -v /logio_conf:/root/.log.io -v /var/log:/var/log -e LOGIO_SERVICE=harvester lework/logio:0.3.4
docker run -tid --network logio --name logio_server --restart=always  -p 28778:28778 -v /logio_conf:/root/.log.io lework/logio:0.3.4
```

docker-compose
```bash
version: '2'
services:
  logio_server:
    container_name: logio_server
    hostname: logio_server
    image: lework/logio:0.3.4
    network_mode: test
    volumes:
      - "/logio_conf:/root/.log.io"
    ports:
      - "28778:28778"
    restart: always

  logio_harvester:
    container_name: logio_harvester
    hostname: ogio_harvester
    image: lework/logio:0.3.4
    network_mode: test
    volumes:
      - "/logio_conf:/root/.log.io"
      - "/var/log:/var/log"
    depends_on:
      - logio_server
    environment:
      - LOGIO_SERVICE=harvester
    restart: always
```