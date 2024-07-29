#!/bin/bash
# Script de inicio personalizado

# Aplicar configuraciones del sistema
sysctl -p

# Incluir configuraciones de sitios disponibles
for site in /usr/local/apache2/sites-available/*; do
    ln -s "$site" /usr/local/apache2/sites-enabled/
done

# Iniciar el servicio Apache en primer plano
httpd-foreground
