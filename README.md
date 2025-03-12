# About

This GitHub repository offers a containerized and optimized Apache web server setup for PHP applications, including MariaDB and phpMyAdmin for database management, and enhances performance and security while simplifying deployment and administration tasks. 

## Images and Space Required

Upon building, three services (containers) will be deployed based on the following images:
- php:8.4-apache-bookworm (Customized): 621MB
- mariadb: 336MB
- phpmyadmin/phpmyadmin: 571MB

Total available space required (without your application): 1.53GB


# PHP Extensions Installed

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


# Directories Structure and Functionality

The following is an overview of the directory structure and functionality of the PHP-Apache-MariaDB-PMA-Bookworm production setup.

## Directories Structure

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

## Root Directory

- `.env.example`: Example environment variables file to be used as a template.
- `.gitignore`: Specifies files and directories to be ignored by Git.
- `docker-compose.yml`: Docker Compose configuration file for setting up the services.
- `Dockerfile`: Dockerfile for building the custom PHP-Apache Docker image.
- `README.md`: Project documentation file.

## `app/` Directory

Contains application-specific configuration and public files.

- `.htaccess`: Apache configuration file for URL rewriting, caching, and security settings.
- `php.ini`: Custom PHP configuration file.
- `webapp.conf`: Apache virtual host configuration file.

## `public/` Directory

Contains the publicly accessible files for the web application.

- `index.php`: Main entry point for the PHP application (Currently phpinfo()).
- `assets/`: Directory for static assets.
  - `css/`: Directory for CSS files (Currently without content).
    - `main.css`: Main CSS file for styling.
  - `images/`: Directory for image files.
    - `photo.jpg`: Example image file.
  - `js/`: Directory for JavaScript files.
    - `main.js`: Main JavaScript file (Currently without content).
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

## Docker Configuration

- `docker-compose.yml`: Defines the services for the web application, including:
  - `web`: PHP-Apache service.
  - `db`: MariaDB service.
  - `phpmyadmin`: phpMyAdmin service.
- `Dockerfile`: Builds the custom PHP-Apache Docker image with necessary extensions and configurations.

## Environment Variables

- `SITE_URL`: The URL of the site.
- `MYSQL_DB_CONNECTION`: Database connection type (e.g., `mysqli` or `pdo_mysql`).
- `MYSQL_DATABASE`: Name of the database.
- `MYSQL_ROOT_PASSWORD`: Root password for the database.
- `MYSQL_USER`: Database user.
- `MYSQL_PASSWORD`: Password for the database user.


# How to Use this Repository

## Clone, Compose, and Start the Services (Containers)

1. **Clone the Repository**:
    ```sh
    git clone https://github.com/panos-vasilopoulos/php-apache-mariadb-pma-bookworm-production.git
    cd php-apache-mariadb-pma-bookworm-production
    ```

2. **Copy and Configure Environment Variables**:
    ```sh
    cp .env.example .env
    ```
    Edit the `.env` file to configure your environment variables.

3. **Move/Copy your Application Inside the Public Directory**:
    ```sh
    mv /path/to/your/application/* app/public/
    ```
    or
    ```sh
    cp -r /path/to/your/application/* app/public/
    ```
    Ensure that your application's entry point is `index.php` inside the `app/public/` directory.

4. **Compose and Start the Services (Containers)**:
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

5. **Access your Website/Application and Database Management Tool**:
    - Open your web browser and navigate to `http://localhost:8180` to access the web application.
    - Open your web browser and navigate to `http://localhost:8182` to access the PhpMyAdmin application using the credentials defined in the `.env` file.

6. **Stop the Services (Containers)**:
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

## Stop, Remove and Rebuild the Services (Containers)

1. **Remove the Services (Containers)**:
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

2. **Rebuild the PHP Apache Stack (if needed)**:
    ```sh
    docker build --no-cache -t myaerolab/php-8-4-apache-bookworm-production:latest .
    ```

3. **If you Rebuilded the PHP Apache Stack then Compose again and Start the Services (Containers)**:
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
