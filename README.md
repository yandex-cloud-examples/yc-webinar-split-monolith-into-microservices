# Как перейти от монолитной архитектуре к микросервисной при помощи Yandex API Gateway и Yandex Cloud Functions

Структура проекта:  

    .
    ├── demo                    # Демонстарция работы 
    │   ├── migrate.sh          # Фиксация канареечного релиза
    │   ├── rollback.sh         # Откат канареечного релиза
    │   └── shoot.sh            # 100 последовательных обращений к ресурсу 
    ├── deploy                  # Развертывание инфраструктуры
    │   ├── microservices       # Развертывание 2х микросервисов: Posts и Users
    │   │   └── ...
    │   ├── monolith            # Развертывание инраструктуры монолита
    │   │   └── ...
    │   └── registry            # Развертывание Container registry и публикация образа монолита
    │       └── ...
    ├── microservices
    │   ├── post                # Микросервис Posts
    │   │   └── ...
    │   └── user                # Микросервис Users (отвечат 502 на любой запрос)
    │       └── ...
    ├── monolith                # Монолитное приложение с 2 сервисами: Posts и Users
    │   └── ...
    └── README.md    

## Инструкция по запуску примера
### 0. Настройте инструменты
Установите и настройте следующие инструменты: [YC CLI](https://cloud.yandex.ru/docs/cli/quickstart#install), [Terraform](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-quickstart#install-terraform), [Docker](https://cloud.yandex.ru/blog/posts/2022/03/docker-containers)
### 1. Подготовьте образ монолитного приложения
Проинициализируйте terraform:
```shell
cd deploy/registry/ ; ./init.sh
```
Создайте Container registry:
```shell
cd deploy/registry/ ; ./tf.sh apply
```
Сконфигурируйте Docker:
```shell
cd deploy/registry/ ; ./docker_configure.sh apply
```
Соберите образ и загрузите его в созданный реестр:
```shell
cd deploy/registry/ ; ./push_image.sh apply
```
### 2. Разверните монолитное приложение
Проинициализируйте terraform:
```shell
cd deploy/monolith/ ; ./init.sh
```
Разверните инфраструктуру:
```shell
cd deploy/monolith/ ; ./tf.sh apply
```
Проверьте результат, обратитесь к балансировщику:
```shell
cd demo/ ; ./shoot.sh
```
### 3. Разверните микросервисы
Запакуйте исходный код микросервисов в архив:
```shell
cd deploy/microservices/resources/ ; ./build.sh
```
Проинициализируйте terraform:
```shell
cd deploy/microservices/ ; ./init.sh
```
Разверните инфраструктуру:
```shell
cd deploy/microservices/ ; ./tf.sh apply
```
Проверьте результат, обратитесь к ресурсу `/api/posts` API Gateway:
```shell
cd demo/ ; ./shoot.sh
```
Зафиксируйте канареечный релиз:
```shell
cd demo/ ; ./migrate.sh
```
### 4. (Опционально) Выкатите сломанный релиз и откатите его
Для этого замените API Gateway в спецификации на закомментирвоанный шлюз. Примените изменения: 
```shell
cd deploy/microservices/ ; ./tf.sh apply
```
Убедитесь, что новый сервис возвращает код 502, обратившись к `/api/users?id=1` API Gateway:
```shell
cd demo/ ; ./shoot.sh
```
Откатите канареечный релиз:
```shell
cd demo/ ; ./rollback.sh
```