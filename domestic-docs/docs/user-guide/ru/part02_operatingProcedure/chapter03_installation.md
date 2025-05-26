## Установка программы на целевое устройство (панельный компьютер)

### 1.

Создать пользователя `scada`

### 2.

Добавить пользователя `scada` в группу `sudo`:
```sh
su -
usermod -aG sudo scada
```
**Перезагрузить компьютер после выполнения команд.**

### 3.
Установить PostgreSQL нужной версии, если это еще не было сделано. Пример:
```sh
sudo apt install postgresql-15
```

### 4.
Распаковать предоставленный архив `craneware-registrator.tar`:
```sh
cd <путь к директории с архивом `craneware-registrator.tar`>
mkdir craneware-registrator
tar -xf craneware-registrator.tar -C ./craneware-registrator
```

### 5.

Установить deb-пакеты, получившиеся в результате распаковки архива:
```sh
cd craneware-registrator
sudo apt install ./api-server_X.X.XX_amd64.deb
sudo apt install ./cma-server_X.X.XX_amd64.deb
sudo apt install ./cma-registrator_X.X.XX_amd64.deb
sudo apt install ./cma-history_X.X.XX_amd64.deb
```

### 6.

Установленную программу можно запустить либо выполнив команду в терминале (из любой директории):

```bash
cma-registrator
```
либо воспользовавшись средствами установленной в системе среды рабочего стола (Desktop Environment, например `GNOME` или `XFCE`), выполнив поиск в меню приложений по названию программы: `cma-registrator`.

## Деинсталляция программы

Для удаления приложения выполнить команды в терминале:

```bash
sudo apt remove cma-history
sudo apt remove cma-registrator
sudo apt remove cma-server
sudo apt remove api-server
```
