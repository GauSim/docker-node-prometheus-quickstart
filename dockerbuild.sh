
appName="prometheus-test";

timestamp=$(awk 'BEGIN {srand(); print srand()}');
gitRev="$(git rev-parse HEAD)";
appVersion="1.0.0";
imageTag="$appVersion-$gitRev-$timestamp";
imageNameWithTag="$appName:$imageTag";
port="3000";
portMapping="$port:$port";

# stop if running
(docker stop $appName || :) && echo "ok stopped $appName";

# remove all images with /$appName/
(docker rmi $(docker images | awk '$1 ~ /'$appName'/ { print $3 }') -f || :) && echo "ok removed images";

# build & tag
docker build "./server" -t $imageNameWithTag -t "$appName:latest";

# echo container build result
echo "=== help =========================================================================";
echo "[run with logs] => $ docker run --rm --name $appName -p $portMapping $appName";
echo "[run in background] => $ docker run --rm --name $appName -d -p $portMapping $imageNameWithTag";
echo "[bash into] => $ docker run --rm --name $appName -d -p $portMapping $imageNameWithTag && docker exec -it $appName sh";
echo "====================================================================================";