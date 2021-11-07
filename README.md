# CI-CD-pipeline-for-python-application

## Features
- Pythonapp (built by Lukasz Wojdyla)
- Docker file to containerize the python app
- Terraform orchestration:
   - Building the container for the python app and pushing to aws ecs.
   - Creating the needed resources to run the app on aws ecs.
   - Service discovery for the Python app, redis requirement.
   - Building a CI/CD pipeline with CodeCommit, CodeBuild and Codepipeline


![image](https://user-images.githubusercontent.com/62175920/140663263-e6db5d11-fe8a-4096-81a7-5435337aaa40.png)
