<!-- TOC -->

- [Caddy](#caddy)
  - [CaddyCommand](#caddycommand)
- [Curl](#curl)
  - [Result](#result)
  - [Curl Command](#curl-command)
  - [Curl Output](#curl-output)
- [Browser](#browser)
- [Combine Result](#combine-result)

<!-- /TOC -->

### Caddy

https://github.com/caddyserver/caddy/actions/runs/223247096

#### CaddyCommand

Caddy:

```sh
$ ./caddy version
(devel)
$ ./caddy run -adapter caddyfile -config caddyfile-M2
```

### Curl

#### Result

Test#|Request|Expected|Actual
---|---|---|---
M2T1|http://localhost:1314/dir | no redir (not exit in /blog)|no redir
M2T2|http://localhost:1314/dir2dir | no redir (exist at /)|no redir
M2T3|http://localhost:1314/dir2file | no redir (exist at /)|no redir
M2T4|http://localhost:1314/file | no redir (not exit in /blog)|no redir
M2T5|http://localhost:1314/file2dir | no redir (exist at /)|no redir
M2T6|http://localhost:1314/file2file | no redir (exist at /)|no redir
M2T7|http://localhost:1314/blogdir | redir  /blog/blogdir/ | redirect to /blog/blogdir/
M2T8|http://localhost:1314/blogfile | redir /blog/blogfile | 404 redir /blog/blogfile/

Test#|Request|Expected|Actual
---|---|---|---
M2T9|http://localhost:1314/dir/ | no redir (not exit in /blog)|no redir
M2Ta|http://localhost:1314/dir2dir/ | no redir (exist at /)|no redir
M2Tb|http://localhost:1314/dir2file/ | no redir (exist at /)|no redir
M2Tc|http://localhost:1314/file/ | no redir (not exit in /blog)|404
M2Td|http://localhost:1314/file2dir/ | no redir (exist at /)|404
M2Te|http://localhost:1314/file2file/ | no redir (exist at /)|404
M2Tf|http://localhost:1314/blogdir/ | redir /blog/blogdir/ | redir /blog/blogdir/
M2Tg|http://localhost:1314/blogfile/ | redir /blog/blogfile | 404 redir /blog/blogfile/

#### Curl Command

```sh
./curl.sh 2
```

#### Curl Output

Output:

```sh
===
M2 Testing without trailing /
===
M2T1 REQ:http://localhost:1314/dir expected redir:no
> GET /dir HTTP/1.1
< HTTP/1.1 308 Permanent Redirect
< Location: /dir/
> GET /dir/ HTTP/1.1
< HTTP/1.1 200 OK
This is /dir/index.html* Closing connection 0
---
M2T2 REQ:http://localhost:1314/dir2dir expected redir:no
> GET /dir2dir HTTP/1.1
< HTTP/1.1 308 Permanent Redirect
< Location: /dir2dir/
> GET /dir2dir/ HTTP/1.1
< HTTP/1.1 200 OK
This is /dir2dir/index.html* Closing connection 0
---
M2T3 REQ:http://localhost:1314/dir2file expected redir:no
> GET /dir2file HTTP/1.1
< HTTP/1.1 308 Permanent Redirect
< Location: /dir2file/
> GET /dir2file/ HTTP/1.1
< HTTP/1.1 200 OK
This is /dir2file/index.html* Closing connection 0
---
M2T4 REQ:http://localhost:1314/file expected redir:no
> GET /file HTTP/1.1
< HTTP/1.1 200 OK
This is /file* Closing connection 0
---
M2T5 REQ:http://localhost:1314/file2dir expected redir:no
> GET /file2dir HTTP/1.1
< HTTP/1.1 200 OK
This is /file2dir* Closing connection 0
---
M2T6 REQ:http://localhost:1314/file2file expected redir:no
> GET /file2file HTTP/1.1
< HTTP/1.1 200 OK
This is /file2file* Closing connection 0
---
M2T7 REQ:http://localhost:1314/blogdir expected redir:yes
> GET /blogdir HTTP/1.1
< HTTP/1.1 302 Found
< Location: /blog/blogdir/
> GET /blog/blogdir/ HTTP/1.1
< HTTP/1.1 200 OK
This is /blog/blogdir/index.html* Closing connection 0
---
M2T8 REQ:http://localhost:1314/blogfile expected redir:yes
> GET /blogfile HTTP/1.1
< HTTP/1.1 302 Found
< Location: /blog/blogfile/
> GET /blog/blogfile/ HTTP/1.1
< HTTP/1.1 404 Not Found
---
===
M2 Testing with trailing /
===
M2T9 REQ:http://localhost:1314/dir/ expected redir:no
> GET /dir/ HTTP/1.1
< HTTP/1.1 200 OK
This is /dir/index.html* Closing connection 0
---
M2Ta REQ:http://localhost:1314/dir2dir/ expected redir:no
> GET /dir2dir/ HTTP/1.1
< HTTP/1.1 200 OK
This is /dir2dir/index.html* Closing connection 0
---
M2Tb REQ:http://localhost:1314/dir2file/ expected redir:no
> GET /dir2file/ HTTP/1.1
< HTTP/1.1 200 OK
This is /dir2file/index.html* Closing connection 0
---
M2Tc REQ:http://localhost:1314/file/ expected redir:no
> GET /file/ HTTP/1.1
< HTTP/1.1 404 Not Found
---
M2Td REQ:http://localhost:1314/file2dir/ expected redir:no
> GET /file2dir/ HTTP/1.1
< HTTP/1.1 404 Not Found
---
M2Te REQ:http://localhost:1314/file2file/ expected redir:no
> GET /file2file/ HTTP/1.1
< HTTP/1.1 404 Not Found
---
M2Tf REQ:http://localhost:1314/blogdir/ expected redir:no
> GET /blogdir/ HTTP/1.1
< HTTP/1.1 302 Found
< Location: /blog/blogdir/
> GET /blog/blogdir/ HTTP/1.1
< HTTP/1.1 200 OK
This is /blog/blogdir/index.html* Closing connection 0
---
M2Tg REQ:http://localhost:1314/blogfile/ expected redir:no
> GET /blogfile/ HTTP/1.1
< HTTP/1.1 302 Found
< Location: /blog/blogfile/
> GET /blog/blogfile/ HTTP/1.1
< HTTP/1.1 404 Not Found
---
```

### Browser

Test#|Request|Expected|Actual
---|---|---|---
M2T1|http://localhost:1314/dir | no redir (not exit in /blog)|no redir
M2T2|http://localhost:1314/dir2dir | no redir (exist at /)|no redir
M2T3|http://localhost:1314/dir2file | no redir (exist at /)|no redir
M2T4|http://localhost:1314/file | no redir (not exit in /blog)|no redir
M2T5|http://localhost:1314/file2dir | no redir (exist at /)|no redir
M2T6|http://localhost:1314/file2file | no redir (exist at /)|no redir
M2T7|http://localhost:1314/blogdir | redir  /blog/blogdir/ | redirect to /blog/blogdir/
M2T8|http://localhost:1314/blogfile | redir /blog/blogfile | redir /blog/blogfile

Test#|Request|Expected|Actual
---|---|---|---
M2T9|http://localhost:1314/dir/ | no redir (not exit in /blog)|no redir
M2Ta|http://localhost:1314/dir2dir/ | no redir (exist at /)|no redir
M2Tb|http://localhost:1314/dir2file/ | no redir (exist at /)|no redir
M2Tc|http://localhost:1314/file/ | no redir (not exit in /blog)|no redir
M2Td|http://localhost:1314/file2dir/ | no redir (exist at /)|no redir
M2Te|http://localhost:1314/file2file/ | no redir (exist at /)|no redir
M2Tf|http://localhost:1314/blogdir/ | redir /blog/blogdir/ | redir /blog/blogdir/
M2Tg|http://localhost:1314/blogfile/ | redir /blog/blogfile | redir /blog/blogfile

### Combine Result

 Request | Test# | Browser no trailing / | Curl no trailing / | Test# | Browser \w trailing / | Curl \w trailing /
---|---|---|---|---|---|---
 http://localhost:1314/dir | M2T1 | no redir | no redir | M2T9 | no redir | no redir
 http://localhost:1314/dir2dir | M2T2 | no redir | no redir | M2Ta | no redir | no redir
 http://localhost:1314/dir2file | M2T3 | no redir | no redir | M2Tb | no redir | no redir
 http://localhost:1314/file | M2T4 | no redir | no redir | M2Tc | no redir |404
 http://localhost:1314/file2dir | M2T5 | no redir | no redir | M2Td | no redir |404
 http://localhost:1314/file2file | M2T6 | no redir | no redir | M2Te | no redir |404
 http://localhost:1314/blogdir | M2T7 | redirect to /blog/blogdir/ | redirect to /blog/blogdir/ | M2Tf | redir /blog/blogdir/ | redir /blog/blogdir/
 http://localhost:1314/blogfile | M2T8 | redir /blog/blogfile | 404 redir /blog/blogfile/ | M2Tg | redir /blog/blogfile | 404 redir /blog/blogfile/