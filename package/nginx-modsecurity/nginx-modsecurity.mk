################################################################################
#
# nginx-modsecurity
#
################################################################################

NGINX_MODSECURITY_VERSION = 1.0.4
NGINX_MODSECURITY_SOURCE = modsecurity-nginx-v$(NGINX_MODSECURITY_VERSION).tar.gz
NGINX_MODSECURITY_SITE = https://github.com/owasp-modsecurity/ModSecurity-nginx/releases/download/v$(NGINX_MODSECURITY_VERSION)
NGINX_MODSECURITY_LICENSE = Apache-2.0
NGINX_MODSECURITY_LICENSE_FILES = LICENSE
NGINX_MODSECURITY_DEPENDENCIES = libmodsecurity

$(eval $(generic-package))
