# curl-multipart
Multipart configurable parallel downloader in Shell using cURL

**ARGUMENTS:**

* The first and no named parameter is the URL.
* -p or --parts is a number of parts, or default 10.
* -o or --output is the name of output file, or default is the name of your desired file.

**EXAMPLE:**

```
./curl-multipart.sh http://blabla.com/file.zip -p=8 -o=downloaded.zip
```

## Author
Diego Pereira - [diegodsp](https://github.com/diegodsp/)
