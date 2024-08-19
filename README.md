# lbs-exporter


**0.10.9 / 2024-08-15**

**[ADD] 增加对Upstream后端状态的监控**

- HELP lbs_upstream_status upstream server status up/1 down/0.
- TYPE lbs_upstream_status gauge
- lbs_upstream_status{backend="10.1.1.1:9093",upstream="x.com_node"} 1

- HELP lbs_upstream_fallCounts check upstream server fall counts.
- TYPE lbs_upstream_fallCounts gauge
- lbs_upstream_fallCounts{backend="10.1.1.1:9093",upstream="x.com_node"} 121


> lbs-exporter is powered by [Kod](https://github.com/go-kod/kod), which is a dependency injection framework for Go.  
> It is designed to be simple and easy to use, and to provide a consistent way to manage dependencies across your application.

Simple server that scrapes LBS [vts](https://github.com/vozlt/nginx-module-vts) stats and exports them via HTTP for Prometheus consumption

## Dependency

* [nginx-module-vts](https://github.com/vozlt/nginx-module-vts)
* [Prometheus](https://prometheus.io/)
* [Golang](https://golang.org/)


### build binary

``` shell
make
```

### build docker image
``` shell
make docker
```


## Run

### run binary
``` shell
nohup /bin/lbs_exporter --lbs.scrape_uri http://10.66.14.164:81/status/format/json --lbs.check_uri http://10.66.14.164:81/check_status?format=json
```


## Environment variables

This image is configurable using different env variables

--lbs.scrape_uri  (vts mod url)
--lbs.check_uri   (check_status mod url)

Variable name | Default     | Description
------------- | ----------- | --------------
METRICS_ENDPOINT | /metrics  | Metrics endpoint exportation URI
METRICS_ADDR | :9913 | Metrics exportation address:port
METRICS_NS | lbs | Prometheus metrics Namespaces


**Metrics details**

lbs   data         | Name                            | Exposed informations     
------------------ | ------------------------------- | ------------------------
 **Info**          | `{NAMESPACE}_server_info`       | hostName, lbsVersion, uptimeSec |
 **Connections**   | `{NAMESPACE}_server_connections`| status [active, reading, writing, waiting, accepted, handled]

**Metrics output example**

``` txt
# Server Info
lbs_server_info{hostName="localhost", lbsVersion="1.11.1"} 9527
# Server Connections
lbs_server_connections{status="accepted"} 70606
```

### Server zones

**Metrics details**

lbs   data         | Name                            | Exposed informations     
------------------ | ------------------------------- | ------------------------
 **Requests**      | `{NAMESPACE}_server_requests`    | code [2xx, 3xx, 4xx, 5xx, total], host _(or domain name)_
 **Bytes**         | `{NAMESPACE}_server_bytes`       | direction [in, out], host _(or domain name)_
 **Cache**         | `{NAMESPACE}_server_cache`       | status [bypass, expired, hit, miss, revalidated, scarce, stale, updating], host _(or domain name)_

**Metrics output example**

``` txt
# Server Requests
lbs_server_requests{code="1xx",host="test.domain.com"} 0

# Server Bytes
lbs_server_bytes{direction="in",host="test.domain.com"} 21

# Server Cache
lbs_server_cache{host="test.domain.com",status="bypass"} 2
```

### Filter zones

**Metrics details**

lbs   data         | Name                              | Exposed informations
------------------ | --------------------------------- | ------------------------
 **Requests**      | `{NAMESPACE}_filter_requests`     | code [2xx, 3xx, 4xx, 5xx and total], filter, filter name
 **Bytes**         | `{NAMESPACE}_filter_bytes`        | direction [in, out], filter, filter name
 **Response time** | `{NAMESPACE}_filter_responseMsec` | filter, filter name

**Metrics output example**

``` txt
# Filter Requests
lbs_upstream_requests{code="1xx", filter="country", filterName="BY"} 0

# Filter Bytes
lbs_upstream_bytes{direction="in", filter="country", filterName="BY"} 0

# Filter Response time
lbs_upstream_responseMsec{filter="country", filterName="BY"} 99
```


### Upstreams

**Metrics details**

lbs   data         | Name                                | Exposed informations
------------------ | ----------------------------------- | ------------------------
 **Requests**      | `{NAMESPACE}_upstream_requests`     | code [2xx, 3xx, 4xx, 5xx and total], upstream _(or upstream name)_
 **Bytes**         | `{NAMESPACE}_upstream_bytes`        | direction [in, out], upstream _(or upstream name)_
 **Response time** | `{NAMESPACE}_upstream_responseMsec` | backend (or server), in_bytes, out_bytes, upstream _(or upstream name)_

**Metrics output example**

``` txt
# Upstream Requests
lbs_upstream_requests{code="1xx",upstream="XXX-XXXXX-3000"} 0

# Upstream Bytes
lbs_upstream_bytes{direction="in",upstream="XXX-XXXXX-3000"} 0

# Upstream Response time
lbs_upstream_responseMsec{backend="10.2.15.10:3000",upstream="XXX-XXXXX-3000"} 99
```
