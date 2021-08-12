## dev-container

Work inside linux container running on windows laptop:
```
docker build -t my-image .
docker run --name my-container -t -d -v C:\Users\rajesh.gupta\Work\shared:/home/rajesh/shared my-image
docker exec -it my-container bash
```
