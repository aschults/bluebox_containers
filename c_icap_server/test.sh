docker build -t myicap . || exit
docker stop icap1
docker rm icap1
#docker run  --name=icap1 -ti -e CLAMD_HOST=bigbox -p 11344:1344 --entrypoint=sh myicap
docker run  --name=icap1 -ti -e CLAMD_HOST=bigbox -p 11344:1344 myicap

