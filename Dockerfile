# Utilizar una imagen base oficial de Apache
FROM httpd:2.4

# Mantener el contenedor liviano eliminando archivos temporales
RUN apt-get update && apt-get install -y \
    vim \
    curl \
    wget \
    procps \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Ajustar parámetros del kernel
RUN echo "net.core.somaxconn = 65535" >> /etc/sysctl.conf && \
    echo "net.ipv4.tcp_tw_reuse = 1" >> /etc/sysctl.conf && \
    echo "net.ipv4.ip_local_port_range = 1024 65535" >> /etc/sysctl.conf && \
    echo "net.ipv4.tcp_max_syn_backlog = 4096" >> /etc/sysctl.conf && \
    echo "net.ipv4.tcp_max_tw_buckets = 1440000" >> /etc/sysctl.conf

# Configurar límites de recursos
RUN echo "* soft nofile 65536" >> /etc/security/limits.conf && \
    echo "* hard nofile 65536" >> /etc/security/limits.conf && \
    echo "root soft nofile 65536" >> /etc/security/limits.conf && \
    echo "root hard nofile 65536" >> /etc/security/limits.conf

# Copiar archivos de configuración personalizada
COPY ./config/my-httpd.conf /usr/local/apache2/conf/httpd.conf
COPY ./config/extra/my-httpd-vhosts.conf /usr/local/apache2/conf/extra/httpd-vhosts.conf

# Crear directorios para los sitios web
RUN mkdir -p /usr/local/apache2/sites-available /usr/local/apache2/sites-enabled

# Copiar scripts de inicio personalizados
COPY ./scripts/startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh

# Establecer el directorio de trabajo
WORKDIR /usr/local/apache2

# Exponer el puerto 80 para el tráfico web
EXPOSE 80

# Comando por defecto al iniciar el contenedor
CMD ["startup.sh"]
