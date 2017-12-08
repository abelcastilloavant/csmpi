## csmpi - fetch and retrieve data from cloud storage

There's this amazing R package called [s3mpi](https://github.com/robertzk/s3mpi/), that makes it
easy to read and write serialized R objects to Amazon's AWS Simple Storage Service (S3). After using
it for a while, it became apparent that the idea of using cloud storage to save R objects could be
generalized, both in terms of the cloud storage service used, and the format in which data is stored

The goal of this package is to serve as a generalization of `s3mpi` in exactly these two directions.
To accomplish this, we introduce a layer of abstraction to the code path through which it becomes
easy to swap out cloud storage services or data storage formats.

This package is still under development.

### License

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
