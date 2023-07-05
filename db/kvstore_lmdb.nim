import lmdb
import eth/db/kvstore
import os, strutils, sequtils
import chronicles

type
  LMDBStoreRef* = ref object of RootObj
    store*: LMDBTxn
    dbi*: Dbi

proc get*(db: LMDBStoreRef, key: openArray[byte], onData: kvstore.DataProc): KvResult[bool] =
    var data = db.store.get(db.dbi, $key)
    info "lmdb", data=data
    onData(data.toOpenArrayByte(0, data.len - 1))
    ok(true)

proc find*(db: LMDBStoreRef, prefix: openArray[byte], onFind: kvstore.KeyValueProc): KvResult[void] =
    raiseAssert "Unimplemented"

proc put*(db: LMDBStoreRef, key, value: openArray[byte]): KvResult[void] =
    echo "key:", key, " value:", value
    db.store.put(db.dbi, $key, $value)
    db.store.commit()
    ok()

proc del*(db: LMDBStoreRef, key: openArray[byte]): KvResult[bool] =
    var data = db.store.get(db.dbi, $key)
    db.store.del(db.dbi, $key, data)
    db.store.commit()
    ok(true)

proc contains*(db: LMDBStoreRef, key: openArray[byte]): KvResult[bool] =
    echo "contains:", key
    var data = db.store.get(db.dbi, $key)
    if data.len > 0:
        ok(true)
    else:
        ok(false)


proc clear*(db: LMDBStoreRef): KvResult[bool] =
    db.store.emptyDb(db.dbi)
    db.store.commit()
    ok(true)

proc close*(db: LMDBStoreRef) =
    db.store.deleteAndCloseDb(db.dbi)

proc init*(T: type LMDBStoreRef, path:string): KvResult[T] =
    var store = newLMDBEnv(getCurrentDir() / ".lmdb")
    let txn = store.newTxn()
    let dbi = txn.dbiOpen("", 0)
    ok(T(store: txn, dbi: dbi))