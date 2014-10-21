FROM debian:wheezy

# Variables d'environnement
ENV DEBIAN_FRONTEND noninteractive
ENV INITRD No

# Dependencies
RUN apt-get update --fix-missing
RUN apt-get install -y apt-utils debconf-utils dialog locales
RUN apt-get update
RUN apt-get install -y apache2 php5 php5-gd php5-mysql mysql-server wget unzip supervisor

# Piwik
RUN rm -R /var/www
RUN cd /var/ && wget http://builds.piwik.org/piwik.zip
RUN cd /var/ && unzip piwik.zip && rm piwik.zip
RUN mv /var/piwik /var/www
RUN chown -R www-data:www-data /var/www
RUN chmod -R 0755 /var/www/tmp

# Supervisor
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80
CMD ["/usr/bin/supervisord"]
