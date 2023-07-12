import strutils, eth/db/kvstore
import os
import ./kvstore_lmdb
import chronicles

export kvstore

type DbBackend* = enum
  none,
  sqlite,
  rocksdb,
  lmdb

const
  nimbus_db_backend* {.strdefine.} = "rocksdb"
  dbBackend* = rocksdb

when dbBackend == sqlite:
  import eth/db/kvstore_sqlite3 as database_backend
elif dbBackend == rocksdb:
  import ./kvstore_rocksdb as database_backend

type
  ChainDB* = ref object of RootObj
    kv*: KvStoreRef
    when dbBackend == rocksdb:
      rdb*: RocksStoreRef
      
proc get*(db: ChainDB, key: openArray[byte]): seq[byte] =
  var res: seq[byte]
  proc onData(data: openArray[byte]) = 
    res = @data

  if db.kv.get(key, onData).expect("working database"):
    return res

proc put*(db: ChainDB, key, value: openArray[byte]) =
  db.kv.put(key, value).expect("working database")

proc contains*(db: ChainDB, key: openArray[byte]): bool =
  db.kv.contains(key).expect("working database")

proc del*(db: ChainDB, key: openArray[byte]): bool =
  db.kv.del(key).expect("working database")

when dbBackend == sqlite:
  proc newChainDB*(path: string): ChainDB =
    let db = SqStoreRef.init(path, "nimmev").expect("working database")
    ChainDB(kv: kvStore db.openKvStore().expect("working database"))
elif dbBackend == rocksdb:
  proc newChainDB*(path: string): ChainDB =
    let rdb = RocksStoreRef.init(path, "nimmev").tryGet()
    ChainDB(kv: kvStore rdb, rdb: rdb)
elif dbBackend == lmdb:
  # TODO This implementation has several issues on restricted platforms, possibly
  #      due to mmap restrictions - see:
  #      https://github.com/status-im/nim-beacon-chain/issues/732
  #      https://github.com/status-im/nim-beacon-chain/issues/688
  # It also has other issues, including exception safety:
  #      https://github.com/status-im/nim-beacon-chain/pull/809

  {.error: "lmdb deprecated, needs reimplementing".}
elif dbBackend == none:
  discard

export database_backend
