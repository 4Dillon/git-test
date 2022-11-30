set -ex

VERSION=$TAG
cd ${WORKSPACE}/devopsproject

whoami
aws ecr get-login-password --region ap-south-1 | sudo docker login --username AWS --password-stdin "044967670847.dkr.ecr.ap-south-1.amazonaws.com"

sudo docker build -t nginx-application .

sudo docker tag nginx-application:latest 044967670847.dkr.ecr.ap-south-1.amazonaws.com/nginx-application:$VERSION

sudo docker push 044967670847.dkr.ecr.ap-south-1.amazonaws.com/nginx-application:$VERSION

DOCKER_IMAGE="044967670847.dkr.ecr.ap-south-1.amazonaws.com/nginx-application:$VERSION"

sed -i "s@devops_image@$DOCKER_IMAGE@g" nginx_deployment.yaml

cat nginx_deployment.yaml


aws eks update-kubeconfig --name mycluster --region ap-south-1 --profile

kubectl apply -f nginx_deployment.yaml

kubectl expose deployment nginx-deployment --type=LoadBalancer --name=nginx-service
