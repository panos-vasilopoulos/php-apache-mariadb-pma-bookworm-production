# About

This GitHub repository offers a containerized and optimized Apache web server setup for PHP applications, including MariaDB and phpMyAdmin for database management, and enhances performance and security while simplifying deployment and administration tasks. 

## Images and space required

Upon building, three services (containers) will be deployed based on the following images:
- php:8.4-apache-bookworm (Customized): 621MB
- mariadb: 336MB
- phpmyadmin/phpmyadmin: 571MB

Total available space required (without your application): 1.53GB


# PHP extensions installed

The following packages and PHP extensions are included in the customized webserver image:

### Packages
- lsb-release
- libfreetype6-dev
- libjpeg62-turbo-dev
- libpng-dev
- libzip-dev
- zlib1g-dev
- libcurl4-openssl-dev
- curl
- gnupg2
- libxml2-dev
- libonig-dev
- libssl-dev

### Extensions
- mysqli
- pdo_mysql
- gd
- exif
- zip
- bcmath
- opcache


# Directories structure and functionality

The following is an overview of the directory structure and functionality of the PHP-Apache-MariaDB-PMA-Bookworm production setup.

## Directories structure

```plaintext
php-apache-mariadb-pma-bookworm-production/
├── .env.example
├── .gitignore
├── docker-compose.yml
├── Dockerfile
├── README.md
└── app/
    ├── .htaccess
    ├── php.ini
    ├── webapp.conf
    └── public/
        ├── index.php
        ├── assets/
        │   ├── css/
        │   │   └── main.css
        │   ├── images/
        │   │   └── photo.jpg
        │   ├── js/
        │   │   └── main.js
        │   └── videos/
        │       └── video.mp4
        └── errors/
            ├── 400.php
            ├── 401.php
            ├── 403.php
            ├── 404.php
            ├── 408.php
            ├── 500.php
            └── 503.php
```

## Root `/` directory

- `.env.example`: Example environment variables file to be used as a template.
- `.gitignore`: Specifies files and directories to be ignored by Git.
- `docker-compose.yml`: Docker Compose configuration file for setting up the services.
- `Dockerfile`: Dockerfile for building the custom PHP-Apache Docker image.
- `README.md`: Project documentation file.

## `app/` directory

Contains application-specific configuration and public files.

- `.htaccess`: Apache configuration file for URL rewriting, caching, and security settings.
- `php.ini`: Custom PHP configuration file.
- `webapp.conf`: Apache virtual host configuration file.

## `app/public/` directory

Contains the publicly accessible files for the web application.

- `index.php`: Main entry point for the PHP application.
- `assets/`: Directory for static assets.
  - `css/`: Directory for CSS files.
    - `main.css`: Main CSS file for styling.
  - `images/`: Directory for image files.
    - `photo.jpg`: Example image file.
  - `js/`: Directory for JavaScript files.
    - `main.js`: Main JavaScript file.
  - `videos/`: Directory for video files.
    - `video.mp4`: Example video file.
- `errors/`: Directory for custom error pages.
  - `400.php`: Custom error page for HTTP 400 errors.
  - `401.php`: Custom error page for HTTP 401 errors.
  - `403.php`: Custom error page for HTTP 403 errors.
  - `404.php`: Custom error page for HTTP 404 errors.
  - `408.php`: Custom error page for HTTP 408 errors.
  - `500.php`: Custom error page for HTTP 500 errors.
  - `503.php`: Custom error page for HTTP 503 errors.

## Docker configuration

- `docker-compose.yml`: Defines the services for the web application, including:
  - `web`: PHP-Apache service.
  - `db`: MariaDB service.
  - `phpmyadmin`: phpMyAdmin service.
- `Dockerfile`: Builds the custom PHP-Apache Docker image with necessary extensions and configurations.

## Environment variables .env

- `SITE_URL`: The URL of the site.
- `MYSQL_DB_CONNECTION`: Database connection type (e.g., `mysqli` or `pdo_mysql`).
- `MYSQL_DATABASE`: Name of the database.
- `MYSQL_ROOT_PASSWORD`: Root password for the database.
- `MYSQL_USER`: Database user.
- `MYSQL_PASSWORD`: Password for the database user.


# How to use this repository

## Clone, build, compose, and start the services (containers)

1. **Clone the repository**:
    ```sh
    git clone https://github.com/panos-vasilopoulos/php-apache-mariadb-pma-bookworm-production.git
    cd php-apache-mariadb-pma-bookworm-production
    ```

2. **Copy and configure the environment variables**:
    ```sh
    cp .env.example .env
    ```
    Edit the `.env` file to configure your environment variables.

3. **Move/Copy/Edit your application inside the public directory**:
    ```sh
    mv /path/to/your/application/* app/public/
    ```
    or
    ```sh
    cp -r /path/to/your/application/* app/public/
    ```
    Ensure that your application's entry point is `index.php` inside the `app/public/` directory.

4. **Build the PHP Apache image**:
    ```sh
    docker build --no-cache -t myaerolab/php-8-4-apache-bookworm-production:latest .
    ```

5. **Compose and start the services (containers)**:
    - If you have Compose v1 (Deprecated. Consider migrating to v2: https://docs.docker.com/compose/releases/migrate/)
    <br>

    ```sh
    docker-compose up --build
    ```
    - If you have Compose v2 (Current)
    <br>

    ```sh
    docker compose up --build
    ```

6. **Access your website/application and database management tool**:
    - Open your web browser and navigate to `http://localhost:8180` to access the web application.
    - Open your web browser and navigate to `http://localhost:8182` to access the PhpMyAdmin application using the credentials defined in the `.env` file.

7. **Stop the services (containers) (if needed)**:
    - If you have Compose v1 (Deprecated. Consider migrating to v2: https://docs.docker.com/compose/releases/migrate/)
    <br>

    ```sh
    docker-compose down
    ```
    - If you have Compose v2 (Current)
    <br>

    ```sh
    docker compose down
    ```

## Stop, remove, rebuild, compose, and restart the services (containers)

1. **Stop the services (containers) and remove non-consistent volumes**:
    - If you have Compose v1 (Deprecated. Consider migrating to v2: https://docs.docker.com/compose/releases/migrate/)
    <br>

    ```sh
    docker-compose down --rmi all --volumes --remove-orphans
    ```
    - If you have Compose v2 (Current)
    <br>

    ```sh
    docker compose down --rmi all --volumes --remove-orphans
    ```

2. **Remove the PHP Apache image (if needed)**:
    ```sh
    docker image list
    ```
    Find in the list the IMAGE ID that corresponds to the myaerolab/php-8-4-apache-bookworm-production image and copy it in the placeholder below:
    ```sh
    docker image remove [IMAGE ID]
    ```

3. **Rebuild the PHP Apache image (if needed)**:
    ```sh
    docker build --no-cache -t myaerolab/php-8-4-apache-bookworm-production:latest .
    ```

4. **If you rebuilded the PHP Apache image or even made changes to the docker-compose file then compose again and start the services (containers)**:
    - If you have Compose v1 (Deprecated. Consider migrating to v2: https://docs.docker.com/compose/releases/migrate/)
    <br>

    ```sh
    docker-compose up --build
    ```
    - If you have Compose v2 (Current)
    <br>

    ```sh
    docker compose up --build
    ```
