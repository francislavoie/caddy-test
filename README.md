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

	# --- Method 1
	#@post {
	#	file /blog/{path}index.html /blog/{path}/index.html
	#	not file {path} {path}/
	#	path_regexp post ^/([^/]+)/?$
	#}
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

### Issue

Why:

Method 1 test M1T2 failed?

Method 2 test M2T3, M2T8 failed?