@echo off

REM Check if the network exists
docker network ls | findstr /r "\<mysql-network\>" >nul

REM If the network does not exist, create it
if %errorlevel% neq 0 (
    echo Network "mysql-network" does not exist. Creating network...
    docker network create mysql-network
) else (
    echo Network "mysql-network" already exists.
)

REM Check if MySQL container exists and remove it
docker ps -a | findstr /r "\<mysql\>" >nul
if %errorlevel% equ 0 (
    echo Removing existing MySQL container...
    docker rm -f mysql
)

REM Run MySQL container
echo Running new MySQL container...
docker run --name mysql --network mysql-network -v mysql_data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=coolmbo@1999K -p 3305:3306 -d mysql:8.0

REM Check if phpMyAdmin container exists and remove it
docker ps -a | findstr /r "\<phpmyadmin\>" >nul
if %errorlevel% equ 0 (
    echo Removing existing phpMyAdmin container...
    docker rm -f phpmyadmin
)

REM Run phpMyAdmin container
echo Running new phpMyAdmin container...
docker run --name phpmyadmin --network mysql-network -d -e PMA_HOST=mysql -p 8080:80 phpmyadmin


echo MySQL and phpMyAdmin containers are up and running.
echo Access phpMyAdmin at http://localhost:8080

pause
