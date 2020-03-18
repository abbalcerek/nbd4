# zadania do wykladu 4 - riak

## riak setup

baza danych uruchomiona za pomoca pliku docker-compose.yml przygotowanego przez firme `basho`

```bash
docker-compose up
```

## roziwazania

1) http api

    1) `zadanie1-10.sh` - rozwiazania do zadan

    2) W rorzwiazaniach wykorzystywany jest curl, bash i tool do przetwarzania json-a w terminalu `jq`.

    3) Zalozylem, ze traktujemy riak jako kv store a nie baze dokumnetowa jako, ze to byla tresc zadania. Co za tym idzie nie wartosci przy modyfikacji zostaja calkowicie zastempowane i nie ma wprowadzonego schematu do bucketow. 

2) python driver
    
    1) `zadanie11/rozwiazanie.py` - rozwiazanie zadania 11

    2) `zadanie11/README.md` - setup srodowiska python-a



