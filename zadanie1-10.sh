#!/usr/bin/env bash

BUCKET=s21976

#       Usuwamy wszystkie kleucze z backetu
curl http://localhost:8098/buckets/$BUCKET/keys?keys=true \
  | jq -r '.keys | to_entries[] | "\(.value)"' \
  | xargs -I '{}' curl -XDELETE -i -v http://localhost:8098/buckets/$BUCKET/keys/'{}'

curl http://localhost:8098/buckets/$BUCKET/keys?keys=true

# 1.	Umieść w bazie (nazwa bucketa ma być Twoim numerem indeksu poprzedzonym literą „s”) 5 wartości,
#       gdzie każda z nich ma być dokumentem json mającym 4 pola co najmniej dwóch różnych typów. 
records=( '{ "sex" : "Male",  "first_name" : "Adam", "email" : "adam@gmail.com", "age": 77}' \
'{ "sex" : "Female",  "first_name" : "Agata", "email" : "agata@gmail.com", "age": 21}' \
'{ "sex" : "Female",  "first_name" : "Aneta", "email" : "aneta@gmail.com", "age": 33}' \
'{ "sex" : "Male",  "first_name" : "Andrzej", "email" : "andrzej@gmail.com", "age": 44}' \
'{ "sex" : "Male",  "first_name" : "Artur", "email" : "artur@gmail.com", "age": 12}')

output_file="rozwiazanie1.txt"
echo "" > $output_file

for i in "${!records[@]}"
do
    curl -XPOST -i -H -vvv "Content-Type: application/json" \
        -d "${records[i]}" \
        http://localhost:8098/buckets/$BUCKET/keys/$i >> rozwiazanie1.txt
done

curl -v http://127.0.0.1:8098/buckets/$BUCKET/keys?keys=true

curl -v http://127.0.0.1:8098/buckets/$BUCKET/keys/1

echo ""


# 2.	Pobierz z bazy jedną z dodanych przez Ciebie wartości. 
curl -i http://127.0.0.1:8098/buckets/$BUCKET/keys/2 > rozwiazanie2.txt

# 3.	Zmodyfikuj jedną z wartości – dodając dodatkowe pole do dokumentu. 
key=1
new_data=$( curl http://127.0.0.1:8098/buckets/$BUCKET/keys/$key 2>/dev/null | jq -c '. + {"hobby": ["jogging", "swimming"]}' )
curl -XPOST -i -H "Content-Type: application/json" \
        -d "$new_data" \
        http://localhost:8098/buckets/$BUCKET/keys/$key > rozwiazanie3.txt

curl http://127.0.0.1:8098/buckets/$BUCKET/keys/$key

# 4.	Zmodyfikuj jedną z wartości – usuwając jedną pole z wybranego dokumentu.
key=0
new_data=$( curl http://127.0.0.1:8098/buckets/$BUCKET/keys/$key 2>/dev/null | jq -c 'del(.first_name)' )
curl -XPOST -i -H "Content-Type: application/json" \
        -d "$new_data" \
        http://localhost:8098/buckets/$BUCKET/keys/$key > rozwiazanie4.txt

curl http://127.0.0.1:8098/buckets/$BUCKET/keys/$key

# 5.	Zmodyfikuj jedną z wartości – zmieniając wartość jednego z pól.
key=3
new_data=$( curl http://127.0.0.1:8098/buckets/$BUCKET/keys/$key 2>/dev/null | jq -c '.first_name="Karol"' )
curl -XPOST -i -H "Content-Type: application/json" \
        -d "$new_data" \
        http://localhost:8098/buckets/$BUCKET/keys/$key > rozwiazanie5.txt

curl http://127.0.0.1:8098/buckets/$BUCKET/keys/$key

# 6.	Usuń jeden z dokumentów z bazy. 
key=4
curl -XDELETE -i -H "Content-Type: application/json" \
        http://localhost:8098/buckets/$BUCKET/keys/$key > rozwiazanie6.txt


# 7.	Spróbuj pobrać z bazy wartość, która nie istnieje w tej bazie. 
curl http://127.0.0.1:8098/buckets/$BUCKET/keys/$key > rozwiazanie7.txt

# 8.	Dodaj do bazy 1 dokument json (zawierający 1 pole), ale nie specyfikuj klucza.
location=$( curl -XPOST -i -H "Content-Type: application/json" \
        -d "hello world" \
        http://localhost:8098/buckets/$BUCKET/keys | tee rozwiazanie8.txt | grep Location | grep -o '[^ ]*$' | xargs )

# 9.	Pobierz z bazy element z zadania 8.
url="http://localhost:8098/${location%$'\r'}"
curl $url -i -H "Content-Type: application/json" | tee rozwiazanie9.txt

# 10.	Usuń z bazy element z zadania 8. 
curl -XDELETE -i -H "Content-Type: application/json" \
        $url > rozwiazanie10.txt
