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
the CLI tool `s3cmd`, and reading/writing files RDS files. There are two wrappers for this - `s3cmdread`
and `s3cmdstore`:
```r
library(csmpi)
s3cmd_store(iris, "temp/experimenting_with_csmpi", "s3:/path/to/my/s3bucket")

# later, from another R session
library(csmpi)
iris2 <- s3cmd_read("temp/experimenting_with_csmpi", "s3:/path/to/my/s3bucket")
identical(iris, iris2)
# [1] TRUE

```

### Hooks

If you're trying to store non-native R objects, or you need certain things to happen when you read
or write your R object, you can add read and write hooks to your object before storing it.

To do so, add a list to the attribute `csmpi.hooks` of your object before writing it. This list
should have a `read` function and a `write` function.

This feature is analogous with `s3mpi::s3normalize`, which is thoroughly documented
[here](https://github.com/robertzk/s3mpi/blob/master/R/s3normalize.R).


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
* Cloud interfaces: these have `get`, `put`, and `exists` methods to interact with data from the cloud, and
* Disk interfaces: these have `read` and `write` methods to interact with data on disk.

#### Using custom interfaces
To create a new interface for interactions with the cloud and for storage formats, use the initializing
functions for the classes `CloudInterface` and `DiskInterface`, respectively:
```r
new_cloud_interface <- csmpi::CloudInterface$new(new_get_fn, new_put_fn, new_exists_fn)
new_disk_interface  <- csmpi::DiskInterface$new(new_read_fn, new_write_fn)
csmpi::write(iris, "key_to_new_object", new_cloud_interface, new_disk_interface)
iris2 <- csmpi::read("key_to_new_object", new_cloud_interface, new_disk_interface)
identical(iris, iris2)
# Hopefully `TRUE`!
```

### Caching

In order to avoid re-reading data from the cloud, we use caching in the read operation. We offer
cacing in-session and on-disk, which can be toggled by setting the options `csmpi.use_session_cache`
and `csmpi.use_disk_cache`, respectively, to `TRUE`.

In-session caching uses [least-recently-used in-memory caching](https://github.com/kirillseva/cacher)
to store data in memory. Note that this uses an R package that is not available on CRAN - if you do
not have `cacher` installed, in-session caching will be disabled.

On-disk caching writes data to disk, to a folder specified by the option
`csmpi.disk_cache_dir`.

The write operation writes to the disk cache if the option `csmpi.use_disk_cache` is set to `TRUE`.
If a file already exists in disk cache, the write operation will overwrite the disk cache only if the
option `csmpi.overwrite_disk_cache` is set to `TRUE`.


### Retry logic

Sometimes network issues create intermittent errors when interacting with the cloud. To deal with
this, we use [retry logic](https:://github.com/peterhurford/handlr), specifically around steps in
the read and write process that interact with the cloud.

You can specify the number of retries to use, and the amount of time to sleep between retries, with
the options `csmpi.num_retries` and `csmpi.sleep_time`, respectively.


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


## Acknowledgements

This project draws heavily on ideas from [s3mpi](https://github.com/robertzk/s3mpi/),
thanks to Robert Krzyzanowski, Peter Hurford and Kirill Sevastyanenko for their work on that
package.
