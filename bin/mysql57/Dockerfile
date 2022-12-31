# Author: Paul Lee
# Company: Lyquix

FROM mysql:5.7.40

RUN apt-get -y install sed

RUN sed -i 's/#table_open_cache/table_open_cache/' /etc/mysql/mysql.conf.d/mysqld.cnf && \
    sed -i 's/#slow_query_log/slow_query_log/' /etc/mysql/mysql.conf.d/mysqld.cnf && \
    sed -i 's/#slow_query_log_file/slow_query_log_file/' /etc/mysql/mysql.conf.d/mysqld.cnf && \
    sed -i 's/#long_query_time = 2/long_query_time = 1/' /etc/mysql/mysql.conf.d/mysqld.cnf

RUN service mysql restart

EXPOSE 3306