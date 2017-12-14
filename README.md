# csmpi - fetch and retrieve data from cloud storage

There's this amazing R package called [s3mpi](https://github.com/robertzk/s3mpi/), that makes it
easy to read and write serialized R objects to Amazon's AWS Simple Storage Service (S3). This
package is a natural generalization of s3mpi - designed with support for multiple cloud
backends and multiple storage formats in mind.


## Installation and Use

This package is not available on CRAN. To install this package, use devtools:
```r
if (!require(devtools)) { install.packages("devtools") }
devtools::install_github("abelcastilloavant/csmpi")
```

This package is still under development. Right now, the only available cloud interface is AWS S3 via
`s3cmd`, and reading/writing files RDS files. There are two wrappers for this - `s3cmdread` and
`s3cmdstore`:
```r
library(csmpi)
s3cmdstore(iris, "temp/experimenting_with_csmpi", "s3:/path/to/my/s3bucket")

# later, from another R session
library(csmpi)
iris2 <- s3cmdread("temp/experimenting_with_csmpi", "s3:/path/to/my/s3bucket")
identical(iris, iris2)
# [1] TRUE

```


## Mechanics

### Interfaces

The two operations supported by this package are:
1. Take an object in an R session, write it to disk, and push the written file to the cloud; and
2. Download a file from the cloud to disk, and read it into an R session.

These operations require specific knowledge of the cloud solution being used, and of the format in
which the objects are written to disk. For instance, today we might be using AWS S3 to store R
objects as serialized objects - but tomorrow we may need to store objects in JSON format for
consumption by an application in another language.

In this package, "interfaces" encapsulate this knowledge - they understand the details of how to
interact with the cloud and the files in disk. We have two kinds of interfaces:
* Cloud interfaces: these have `get` and `put` methods to interact with data from the cloud, and
* Disk interfaces: these have `read` and `write` methods to interact with data on disk.


### Caching

In order to avoid re-reading data from the cloud, we use caching in the read operation. We offer
cacing in-session and on-disk, which can be toggled by setting the options `csmpi.use_session_cache`
and `csmpi.use_disk_cache`, respectively, to `TRUE`.

In-session caching uses [least-recently-used in-memory caching](https://github.com/kirillseva/cacher)
to store data in memory. On-disk caching writes data to disk, to a folder specified by the option
`csmpi.disk_cache_dir`.

The write operation writes to the disk cache if the option `csmpi.use_disk_cache` is set to `TRUE`.

## Future developments

This package is a generalization of [s3mpi](https://github.com/robertzk/s3mpi/) - it is
still under development, but the first development milestone is to replicate the functionality of
"s3mpi".


## License

This project is licensed under the MIT License:

Copyright (c) 2017 Abel Castillo

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
