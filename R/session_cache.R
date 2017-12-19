session_cache <- cacher::LRUcache(getOption("csmpi.session_cache_size", 10))

get_session_cache_key <- function(key, cloud_name, storage_format) {
  digest::digest(list(key = key, cloud_name = cloud_name, storage_format = storage_format))
}

`in_session_cache?` <- function(session_cache_key) {
  session_cache$exists(session_cache_key)
}

read_from_session_cache <- function(session_cache_key) {
  session_cache$get(session_cache_key)
}

write_to_session_cache <- function(obj, session_cache_key) {
  session_cache$set(session_cache_key, obj)
}
