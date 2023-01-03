# Author: Paul Lee
# Company: Lyquix

FROM mysql:5.7.40

RUN sed -i 's/\[mysqld\]/\[mysqld\]\nkey_buffer_size = 16M/' /etc/my.cnf; \
    sed -i 's/\[mysqld\]/\[mysqld\]\nmax_allowed_packet = 16M/' /etc/my.cnf; \
    sed -i 's/\[mysqld\]/\[mysqld\]\nthread_stack = 192K/' /etc/my.cnf; \
    sed -i 's/\[mysqld\]/\[mysqld\]\nthread_cache_size = 8/' /etc/my.cnf; \
    sed -i 's/\[mysqld\]/\[mysqld\]\ntable_open_cache = 64/' /etc/my.cnf; \
    sed -i 's/\[mysqld\]/\[mysqld\]\nslow_query_log_file = \/var\/log\/mysql\/mysql-slow.log/' /etc/my.cnf; \
    sed -i 's/\[mysqld\]/\[mysqld\]\nlong_query_time = 1/' /etc/my.cnf
