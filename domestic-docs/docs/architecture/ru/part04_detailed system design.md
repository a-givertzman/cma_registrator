# Архитектура - Описание элементов



## API-Сервер

- Хранение данных 
- Структурированный доступ
- Защита данных

```mermaid
flowchart TD
    Client1("Клиент регистратора 1")
    Client_("...")
    Client2("Клиент регистратора 2")
    ApiServer[["API Сервер"]]
    DB[("База данных")]

    Client1 <--->|TCP| ApiServer
    Client_ <--->|TCP| ApiServer
    Client2 <--->|TCP| ApiServer
    DB <-->|TCP| ApiServer
```
Схема 1. Структурная схема модуля API-Сервер


## CMA-Сервер

- Периодический опрос ПЛК с фиксированной частотой
- Отслеживание событий и аварий
- Сохранение истории событий и аварий в БД

```mermaid
flowchart TD
    Clients("Клиенты")
    TcpServer("TCP Сервер")
    PLC1("PLC 1")
    PLC_("...")
    PLCN("PLC N")
    Poll("Опрос ПЛК")
    EventsAlarms("События и аварии")
    ApiServer[("API Сервер")]
    CmaRecorder[("CMA-регистратор")]
    Switch@{ shape: das, label: "Менеджер сообщений" }

    TcpServer <--> |Link<sup>1</sup>| Switch
    CmaRecorder <--> |Link<sup>1</sup>| Switch
    Clients <-->|TCP| TcpServer
    EventsAlarms <-->|Link<sup>1</sup>| Switch
    Poll <-->|Link<sup>1</sup>| Switch
    EventsAlarms <---|Link<sup>1</sup>| ApiServer
    PLC1 <-->|TCP| Poll
    PLC_ <-->|TCP| Poll
    PLC3 <-->|TCP| Poll

```
    `Link` - Механизм асинхронного взимодествия между модулями и потоками приложения посредствам передачи сообщений.
Схема 2. Структурная схема модуля CMA-Сервер


## CMA-Регистратор
- Сбор нужных данных с CMA-Server'a и из БД
- Подсчет параметров в реальном времени
- Сохранение результатов вычислений в БД

## Клиент регистратора

- Домен - сущности системы
- Инфраструктура - внешние взаимодествия
- Презентация - визуализация информации, взаимодействие с пользователем

```mermaid
flowchart
    User(("Пользователь"))
    subgraph Front["Фронтенд"]
        Views("Презентация")
        Infrastructure("Инфраструктура")
        Domain(((Домен)))
    end

    subgraph Back["Бэкенд"]
        ApiServer("API Сервер")
        CmaServer("CMA-Сервер")
    end

    User <--> Front
    Infrastructure <--> ApiServer
    Infrastructure <--> CmaServer
```
Схема 3. Структурная схема клиентского модуля
