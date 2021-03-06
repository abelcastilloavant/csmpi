# Version 0.1.0
- Added support for AWS S3 via `aws` with the `awscli` cloud interface.

# Version 0.0.12
- Fixed bugs in `agnostic_read` and `agnostic_write` functions.
- Better parameter handling for s3cmd.

# Version 0.0.11
- Renamed s3cmd wrapper functions.
- Added storage formats for writing tables/CSV's, json objects, and plaintext.

# Version 0.0.10
- Changed the name of a function to `csmpi_custom_exists` to avoid name conflicts with base
  functions.

# Version 0.0.9
- Added documentation, exported functions and class definitions.

# Version 0.0.8
- Allow use of read/write hooks stored in object attribute `csmpi.hooks`. In particular, this allows
  users to read/write non-native R objects to the cloud by clever use of hooks.

# Version 0.0.7
- Implementation of agnostic `csmpi_exists`, as well as s3cmd-specific `s3cmdexists`.

# Version 0.0.6
- Created versions of agnostic read and write functions that take in interface objects instead of
  relying on the default ones provided by the package.

# Version 0.0.5
- Added retry logic to interactions with cloud interface.

# Version 0.0.4
- Implemented on-disk caching in `read_from_cloud_storage`.
- `s3cmdread` and `s3cmdstore` now use an option to determine a default path.

# Version 0.0.3
- Implemented in-session LRU caching in `read_from_cloud_storage`.

# Version 0.0.2
- Implemented interface classes for cloud storage and disk writing formats.
- Implemented agnostic reading and writing pipelines `read_from_cloud_storage` and
  `write_to_cloud_storage`.
- Added `s3cmd` cloud interface.
- Added `RDS` disk interface.
- Added user-friendly wrappers `s3cmdread` and `s3cmdstore`, to read/write objects using `s3cmd` in
  `RDS` format.

# Version 0.0.1
- Created package.
