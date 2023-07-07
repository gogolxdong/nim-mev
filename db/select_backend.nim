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
  nimbus_db_backend* {.strdefine.} = "lmdb"
  dbBackend* = lmdb

import lmdb as database_backend

type
  ChainDB* = ref object of RootObj
    kv*: KvStoreRef
    # db*: LMDBStoreRef

proc get*(db: ChainDB, key: openArray[byte]): seq[byte] =
  var res: seq[byte]
  proc onData(data: openArray[byte]) = 
    res = @data

  echo "select_backend get:", key
  if db.kv.get(key, onData).expect("working database"):
    return res

proc put*(db: ChainDB, key, value: openArray[byte]) =
  db.kv.put(key, value).expect("working database")

proc contains*(db: ChainDB, key: openArray[byte]): bool =
  echo "select_backend contains"
  db.kv.contains(key).expect("working database")

proc del*(db: ChainDB, key: openArray[byte]): bool =
  echo "select_backend del"
  db.kv.del(key).expect("working database")

proc newChainDB*(path = getCurrentDir() / ".lmdb"): ChainDB =
  echo "newChainDB"
  var lmdbStoreRef = LMDBStoreRef.init(path).get()
  ChainDB(kv: kvStore lmdbStoreRef)

export database_backend
