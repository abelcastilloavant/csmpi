session_cache <- cacher::LRUcache(getOption("csmpi.session_cache_size", 10))

session_cache_key <- function(key, cloud_name, storage_format) {
  digest::digest(list(key = key, cloud_name = cloud_name, storage_format = storage_format))
}

`in_session_cache?` <- function(key, cloud_name, storage_format) {
  session_cache$exists(session_cache_key(key, cloud_name, storage_format))
}

read_from_session_cache <- function(key, cloud_name, storage_format) {
  session_cache$get(session_cache_key(key, cloud_name, storage_format))
}

write_to_session_cache <- function(obj, key, cloud_name, storage_format) {
  session_cache$set(session_cache_key(key, cloud_name, storage_format), obj)
}
