#!/usr/bin/env python

from datetime import datetime
import string
import riak

# initialize riak client
client = riak.RiakClient(pb_port=8087, protocol='pbc')

marleen = {'user_name': 'marleenmgr',
           'full_name': 'Marleen Manager',
           'email': 'marleen.manager@riak.com'}

# create new bucket
myBucket = client.bucket('nbd_riak')

# save record to the buket
record = myBucket.new(marleen["email"], data=marleen).store()
# record.store()
print(f"Rekord inicjalnie zapisany w bazie:\n key: {record.key}, value: {record.data}")

# fetch and print saved record
record_fetched = myBucket.get(record.key)
print(f"Rekord pobrany z bazy po inicjalnym zapisie:\n {record_fetched.data}")

# update record - capitalize username
data = record_fetched.data
data["user_name"] = record_fetched.data["user_name"].upper()
record_fetched.data = data
record_fetched.store()

# fetch record and print after update
record_fetched_after_update = myBucket.get(record.key)
print(f"Rekord pobrany z bazy po aktualizacji pola user_name:\n {record_fetched_after_update.data}")

# remove record with given key
key = record_fetched_after_update.key
myBucket.delete(key)

# get data after record for given key was deleted
print(f"Wartosc pola 'data' po usunieciu rekordu dla klucza:\n {myBucket.get(record_fetched_after_update.key).data}")
