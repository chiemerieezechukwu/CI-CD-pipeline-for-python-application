
#docker build -t ${var.image_name}:${var.image_tag} app
#aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 314053136453.dkr.ecr.eu-central-1.amazonaws.com
#docker build -t asmt-1-cmba-ecr .
#docker tag asmt-1-cmba-ecr:latest 314053136453.dkr.ecr.eu-central-1.amazonaws.com/asmt-1-cmba-ecr:latest
#docker push 314053136453.dkr.ecr.eu-central-1.amazonaws.com/asmt-1-cmba-ecr:latest