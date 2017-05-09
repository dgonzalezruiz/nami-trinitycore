FROM bitnami/minideb-extras:jessie-r13

RUN install_packages build-essential libtool make cmake cmake-data openssl libmysqlclient-dev libmysql++-dev libssl-dev libreadline6-dev zlib1g-dev libbz2-dev libboost1.55-dev libboost-thread1.55-dev libboost-filesystem1.55-dev libboost-system1.55-dev libboost-program-options1.55-dev libboost-iostreams1.55-dev wget software-properties-common git p7zip patch 

RUN bitnami-pkg unpack mysql-client-10.1.22-3 --checksum 9e881a7c404f658c93abd665ecd1372f61a591d784e6456c64c0129358a7ff1a

VOLUME ["/var/trinitycore/etc"]

ADD rootfs /

#TEMPORARY & DIRTY PATCH
RUN cp -a /root/.nami/components/com.bitnami.mysql-client/lib /trinitycore-nami/

RUN nami unpack /trinitycore-nami

ADD https://github.com/dgonzalezruiz/docker-trinitycore/releases/download/Assets-986d830ae7b4/data-986d830ae7b4.tar.gz /tmp/assets.tar.gz

RUN tar xzf /tmp/assets.tar.gz -C /var/trinitycore/

ENV PATH=/opt/bitnami/mysql/bin:$PATH \
    TRINITYCORE_USER="trinity" \
    TRINITYCORE_PASSWORD="trinity" \
    TRINITYCORE_REALMLIST="127.0.0.1" \ 
    MARIADB_HOST="mariadb" \
    MARIADB_PORT="3306" \
    MARIADB_ROOT_USER="root" \
    MARIADB_ROOT_PASSWORD="" \
    TRINITYCORE_DATABASE_USER=$MARIADB_ROOT_USER \
    TRINITYCORE_DATABASE_PASSWORD=$MARIADB_ROOT_PASSWORD \
    ALLOW_EMPTY_PASSWORD="yes"

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["/run.sh"]
