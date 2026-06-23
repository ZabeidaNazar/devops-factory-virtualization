Set up environment
1. Install VirtualBox: https://www.virtualbox.org/wiki/Linux_Downloads
2. Install Vagrant: https://developer.hashicorp.com/vagrant/install#linux
3. Change directory to `task4/`
4. Set environment variable and run:
    ```shell
    MYSQL_USERNAME=<YOUR_USERNAME> MYSQL_PASSWORD=<YOUR_PASSWORD> vagrant up
    ```
    - MYSQL_USERNAME - database username
    - MYSQL_PASSWORD - database password
5. To access the web page go to: http://localhost:8080/
6. Query the database:
    - Run `vagrand ssh web` to login into the web server
    1. First variant
    - Set environment variable and run:
        ```shell
        MYSQL_USERNAME=<YOUR_USERNAME> MYSQL_PASSWORD=<YOUR_PASSWORD> ./db_query.sh
        ```
    2. Second variant:
    - Copy .env/example to .env and set variable
    - Run `./db_query.sh`
7. To verify monitoring metrics go to the Prometheus page: http://localhost:9090/targets
