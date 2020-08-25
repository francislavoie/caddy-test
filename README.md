### Test

The whole dir tree with caddy file is in github:

```sh
git clone https://github.com/J-Siu/caddy-test.git
cd caddy-test
caddy run -adapter caddyfile -config caddyfile
```

### Want to do

```sh
www
├── blog
│   ├── blogdir
│   │   └── index.html
│   ├── blogfile
│   ├── dir2dir
│   │   └── index.html
│   ├── dir2file
│   ├── file2dir
│   │   └── index.html
│   └── file2file
├── dir
│   └── index.html
├── dir2dir
│   └── index.html
├── dir2file
│   └── index.html
├── file
├── file2dir
└── file2file
```

I want:

Request|Redirect
---|---
if /X(file/dir) does not exist|if /blog/X(file/dir) exist

Base on above dir tree, following should happen

Request|Redirect
---|---
http://localhost:1314/dir | no redirect (does not exit in /blog)
http://localhost:1314/dir2dir | no redirect (exist at /)
http://localhost:1314/dir2file | no redirect (exist at /)
http://localhost:1314/file | no redirect (does not exit in /blog)
http://localhost:1314/file2dir | no redirect (exist at /)
http://localhost:1314/file2file | no redirect (exist at /)
http://localhost:1314/blogdir | http://localhost:1314/blog/blogdir
http://localhost:1314/blogfile | http://localhost:1314/blog/blogfile

### Method 1

caddyfile

```apache
{
	admin off
	auto_https disable_redirects
	http_port 1314
}

http://http://localhost:1314 {
	file_server
	root * {env.PWD}/www

	 --- Method 1
	@post {
		file /blog/{path}index.html /blog/{path}/index.html
		not file {path} {path}/
		path_regexp post ^/([^/]+)/?$
	}
	redir @post /blog/{re.post.1}/
}
```

Result:

Test#|Request|Expected|Actual
---|---|---|---
M1T1|http://localhost:1314/dir | no redirect (does not exit in /blog)|no redirect
M1T2|http://localhost:1314/dir2dir | no redirect (exist at /)|http://localhost:1314/blog/dir2dir/
M1T3|http://localhost:1314/dir2file | no redirect (exist at /)|no redirect
M1T4|http://localhost:1314/file | no redirect (does not exit in /blog)|no redirect
M1T5|http://localhost:1314/file2dir | no redirect (exist at /)|no redirect
M1T6|http://localhost:1314/file2file | no redirect (exist at /)|no redirect
M1T7|http://localhost:1314/blogdir | http://localhost:1314/blog/blogdir | http://localhost:1314/blog/blogdir
M1T8|http://localhost:1314/blogfile |error 404(no /blog/blogfile/index.html) | error 404

### Method 2

caddyfile

```apache
{
	admin off
	auto_https disable_redirects
	http_port 1314
}

http://http://localhost:1314 {
	file_server
	root * {env.PWD}/www

	# --- Method 2
	@post {
		file /blog/{path} /blog/{path}/
		not file {path} {path}/
		path_regexp post ^/([^/]+)/?$
	}
	redir @post /blog/{re.post.1}/
}
```

Result:

Test#|Request|Expected|Actual
---|---|---|---
M2T1|http://localhost:1314/dir | no redirect (does not exist in /blog)|no redirect
M2T2|http://localhost:1314/dir2dir | no redirect (exist at /)|no redirect
M2T3|http://localhost:1314/dir2file | no redirect (exist at /)|http://localhost:1314/blog/dir2file
M2T4|http://localhost:1314/file | no redirect (does not exist in /blog)|no redirect
M2T5|http://localhost:1314/file2dir | no redirect (exist at /)|no redirect
M2T6|http://localhost:1314/file2file | no redirect (exist at /)|no redirect
M2T7|http://localhost:1314/blogdir | http://localhost:1314/blog/blogdir |no redirect
M2T8|http://localhost:1314/blogfile |http://localhost:1314/blog/blogfile|http://localhost:1314/blog/blogfile

### Method 3

caddyfile

```apache
{
	admin off
	auto_https disable_redirects
	http_port 1314
}

http://http://localhost:1314 {
	file_server
	root * {env.PWD}/www

	# --- Method 3
	@post {
		file /blog/{path} /blog/{path}/index.html
		not file {path} {path}/index.html
		path_regexp post ^/([^/]+)/?$
	}
	redir @post /blog/{re.post.1}/
}
```

Result:

Test#|Request|Expected|Actual
---|---|---|---
M3T1|http://localhost:1314/dir | no redirect (does not exit in /blog)|no redirect
M3T2|http://localhost:1314/dir2dir | no redirect (exist at /)|no redirect
M3T3|http://localhost:1314/dir2file | no redirect (exist at /)|no redirect
M3T4|http://localhost:1314/file | no redirect (does not exit in /blog)|no redirect
M3T5|http://localhost:1314/file2dir | no redirect (exist at /)|no redirect
M3T6|http://localhost:1314/file2file | no redirect (exist at /)|no redirect
M3T7|http://localhost:1314/blogdir | http://localhost:1314/blog/blogdir | http://localhost:1314/blog/blogdir
M3T8|http://localhost:1314/blogfile | http://localhost:1314/blog/blogfile |
M3T9|http://localhost:1314/dir/ | no redirect (does not exit in /blog)|no redirect
M3Ta|http://localhost:1314/dir2dir/ | no redirect (exist at /)|no redirect
M3Tb|http://localhost:1314/dir2file/ | no redirect (exist at /)|no redirect
M3Tc|http://localhost:1314/file/ | no redirect (does not exit in /blog)|no redirect
M3Td|http://localhost:1314/file2dir/ | no redirect (exist at /)|no redirect
M3Te|http://localhost:1314/file2file/ | no redirect (exist at /)|no redirect
M3Tf|http://localhost:1314/blogdir/ | http://localhost:1314/blog/blogdir |
M3Tg|http://localhost:1314/blogfile/ | http://localhost:1314/blog/blogfile |
M3Th|http://localhost:1314/css | no redirect (exist at /)|no redirect
M3Ti|http://localhost:1314/css/ | no redirect (exist at /)|no redirect

### Method 4

caddyfile

```apache
{
	admin off
	auto_https disable_redirects
	http_port 1314
}

http://http://localhost:1314 {
	file_server
	root * {env.PWD}/www

	# --- Method 3
	@post {
		file /blog/{path} /blog/{path}/
		not file {path} {path}/.*
		path_regexp post ^/([^/]+)/?$
	}
	redir @post /blog/{re.post.1}/
}
```

Result:

Test#|Request|Expected|Actual
---|---|---|---
M4T1|http://localhost:1314/dir | no redirect (does not exit in /blog)|no redirect
M4T2|http://localhost:1314/dir2dir | no redirect (exist at /)|no redirect
M4T3|http://localhost:1314/dir2file | no redirect (exist at /)|no redirect
M4T4|http://localhost:1314/file | no redirect (does not exit in /blog)|no redirect
M4T5|http://localhost:1314/file2dir | no redirect (exist at /)|no redirect
M4T6|http://localhost:1314/file2file | no redirect (exist at /)|no redirect
M4T7|http://localhost:1314/blogdir | http://localhost:1314/blog/blogdir | no redirect (404)
M4T8|http://localhost:1314/blogfile | http://localhost:1314/blog/blogfile | http://localhost:1314/blog/blogfile

### Issue

Why:

Method 1 test M1T2 failed?

Method 2 test M2T3, M2T7 failed?