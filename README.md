# Web panel
Консольная панель управления веб-сервером.

## About Web panel

Web panel - это личный проект, созданный для реализации дипломного проекта бакалавра.
Написана на Bash.
Основные сервисы - Apache, Nginx. MySQL, ProFTPD.
Для хранения служебной информации используется БД MySQL.


## Requirements

  + CentOS 7
  + Доступ root по ssh

## Installing

`$ wget https://raw.githubusercontent.com/velgi/web_panel/master/install.sh`  
`$ /bin/bash install.sh`  

## Functional

  + Поддерживает все базовые функции для организации работы веб-сервера, такие как: создание/редактирование/удаление пользователя, FTP-пользователя, сайта, БД, установка SSL-сертификатов (существующего или генерация самоподписанного)
  + Разделение на 3 уровня доступа 
    + user
    + admin (получает возможность управлять своими пользователями)
    + root (получает возможность управлять всеми пользователями всех администраторов и администраторами)
  + Поддержка нескольких версий PHP (в режиме CGI)
  + Логгирование панели (в /usr/local/panel/log)
    
## Detail

  + Безопасность самой панели, хоть и сравнительно слабая, реализуется при помощи sudoers, тщательно подобраных прав на исполнаемые файлы и написания куска кода, выполняющего проверку пользователя (в файле bin/check_user) ;
  + Увы, часть функций так и не была протестированна (однако, уверен, что 80% работает) ;
  + Часть функций, таких как установка SSL Lets Encrypt и настройка автоматического бэкапирования так и не была реализована, хоть и планировалась;
  + К сожалению, общая безопасность сервера также не подвергалась дополнительной настроке, скорее даже наоборот (например, остановлен IPtables)
  
