Stop and remove all containers - docker stop $(docker ps -q) && docker rm $(docker ps -aq)
Stop and remove all images - docker rmi $(docker images -q)
Remove all volumes - docker volume rm $(docker volume ls -q)
# Remove all volumes except - mezbauddincom_postgres_data & mezbauddincom_static_volume

docker stop $(docker ps -q) && docker rm $(docker ps -aq) && docker rmi $(docker images -q) && docker volume rm $(docker volume ls -q | grep -v 'mezbauddincom_postgres_data\|mezbauddincom_static_volume')

docker-compose -f ./docker-compose.prod.yml up -d --build
docker-compose -f ./docker-compose.prod.yml up --build
docker stop $(docker ps -q) && docker rm $(docker ps -aq) && docker rmi $(docker images -q)


export PYTHON_KEYRING_BACKEND=keyring.backends.null.Keyring



