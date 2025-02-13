# How to move from monolithic to microservice architecture with Yandex API Gateway and Yandex Cloud Functions

Project structure:  

    .
    ├── demo                    # Demonstration 
    │   ├── migrate.sh          # Canary release lock
    │   ├── rollback.sh         # Canary release rollback
    │   └── shoot.sh            # 100 consecutive requests to the resource 
    ├── deploy                  # Infrastructure deployment
    │   ├── microservices       # Deploying two microservices: Posts and Users
    │   │   └── ...
    │   ├── monolith            # Deploying infrastructure for the monolith
    │   │   └── ...
    │   └── registry            # Deploying _Container registry_ and publishing monolith image
    │       └── ...
    ├── microservices
    │   ├── post                # Posts microservice
    │   │   └── ...
    │   └── user                # Users microservice (returns 502 for any request)
    │       └── ...
    ├── monolith                # Monolithic app with two microservices: Posts and Users
    │   └── ...
    └── README.md    

## Running the example
### 0. Configure the tools
Install and configure the following tools: [YC CLI](https://cloud.yandex.ru/docs/cli/quickstart#install), [Terraform](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-quickstart#install-terraform), and [Docker](https://cloud.yandex.ru/blog/posts/2022/03/docker-containers).
### 1. Prepare the image of your monolithic app
Initialize Terraform:
```shell
cd deploy/registry/ ; ./init.sh
```
Create a container registry:
```shell
cd deploy/registry/ ; ./tf.sh apply
```
Configure Docker:
```shell
cd deploy/registry/ ; ./docker_configure.sh apply
```
Build the image and push it to the created registry:
```shell
cd deploy/registry/ ; ./push_image.sh apply
```
### 2. Deploy the monolithic app
Initialize Terraform:
```shell
cd deploy/monolith/ ; ./init.sh
```
Deploy the infrastructure:
```shell
cd deploy/monolith/ ; ./tf.sh apply
```
Access the load balancer to check the result:
```shell
cd demo/ ; ./shoot.sh
```
### 3. Deploy the microservices
Archive the source code of the microservices:
```shell
cd deploy/microservices/resources/ ; ./build.sh
```
Initialize Terraform:
```shell
cd deploy/microservices/ ; ./init.sh
```
Deploy the infrastructure:
```shell
cd deploy/microservices/ ; ./tf.sh apply
```
Access the `/api/posts` API gateway to check the result:
```shell
cd demo/ ; ./shoot.sh
```
Lock the canary release:
```shell
cd demo/ ; ./migrate.sh
```
### 4. Optionally, roll out a broken release and roll it back.
To do this, replace the API gateway in the specification with a commented out gateway. Apply the changes: 
```shell
cd deploy/microservices/ ; ./tf.sh apply
```
Access the `/api/users?id=1` API gateway to make sure your new service returns the 502 status code:
```shell
cd demo/ ; ./shoot.sh
```
Roll back the canary release:
```shell
cd demo/ ; ./rollback.sh
```
