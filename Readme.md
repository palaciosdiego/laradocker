# For Mac OS with M1 chip
Dockerfile 
add '--platform=linux/x86_64' at first or replace this line like this:
FROM --platform=linux/x86_64 php:7.3-fpm-alpine

docker-compose.yml
Mysql 5.7 doesn't work
Only 8 has support for M1
change image to this:
image: mysql/mysql-server:8.0.23

Or use mac_m1 branch

# General config before use
Put the path from your laravel project in the volumes section of services: nginx and php (2 places) docker-compose.yml 

Clone the laravel project inside this project

Add the folder to volumes on nginx and php containers:
volumes:
  - ./project_name/:/var/www/html

Nginx port
If 80 is not free to use, change it for: 81

Mysql port
If 3306 is not free to use, change it for 4306

PHP port
If 9000 is not free to use, change it for 9001

Chose the name of your DB
MYSQL_DATABASE: db_name

# Build app
docker-compose build

# Start app running in background
docker-compose up -d

# Install dependencies
docker-compose exec php composer install


# Login into mysql container
docker exec -it container_id_here /bin/sh  
mysql -u root -p
secret

# Change auth type to root
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'secret'

# Grant all privileges to homestead user
GRANT ALL PRIVILEGES ON *.* TO 'homestead'@'%' WITH GRANT OPTION;
exit

# Log in as homestead
mysql -u homestead -p
secret

# Change auth type
ALTER USER 'homestead'@'%' IDENTIFIED WITH mysql_native_password BY 'secret';

# To use migrate an php artisan
docker-compose exec php php artisan migrate --seed

# Vibrant seeds
docker-compose exec php php artisan db:seed --class="\Vibrant\Users\Seeders\DatabaseSeeder" 

# Checkout
http://localhost/backend/home

# Backup
docker exec CONTAINER /usr/bin/mysqldump -u root --password=root -r DATABASE | Set-Content backup.sql
or
docker exec CONTAINER /usr/bin/mysqldump -u root --password=root DATABASE > backup.sql

# Restore
cat backup.sql | docker exec -i CONTAINER /usr/bin/mysql -u root --password=root DATABASE

### Lando
cat yuhuadmin-local.sql| docker exec -i yuhuadmin_database_1 /opt/bitnami/mysql/bin/mysql -u laravel --password=laravel yuhuadmin

# Util info
COMPOSER_MEMORY_LIMIT=-1 composer <command>
#If you want to run composer with different php version
 php8,0 /usr/local/bin/composer 

Display route:list readable
 sail artisan r:l --compact
 sail artisan route:list --columns=method,name,uri,action  





