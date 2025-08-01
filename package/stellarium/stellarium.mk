################################################################################
#
# stellarium
#
################################################################################

STELLARIUM_VERSION = 25.2
STELLARIUM_SOURCE = stellarium-$(STELLARIUM_VERSION).tar.xz
STELLARIUM_SITE = https://github.com/Stellarium/stellarium/releases/download/v$(STELLARIUM_VERSION)
STELLARIUM_LICENSE = GPL-2.0+
STELLARIUM_LICENSE_FILES = COPYING
STELLARIUM_DEPENDENCIES = \
	qt5base \
	qt5charts \
	qt5location \
	qt5multimedia \
	zlib
STELLARIUM_CONF_OPTS = \
	-DENABLE_MEDIA=ON \
	-DENABLE_NLS=OFF \
	-DENABLE_SHOWMYSKY=OFF \
	-DENABLE_QTWEBENGINE=OFF \
	-DENABLE_QT6=OFF \
	-DENABLE_XLSX=OFF \
	-DUSE_PLUGIN_TELESCOPECONTROL=OFF \
	-DUSE_SYSTEM_ZLIB=ON

ifeq ($(BR2_PACKAGE_QT5SCRIPT),y)
STELLARIUM_DEPENDENCIES += qt5script
STELLARIUM_CONF_OPTS += -DENABLE_SCRIPTING=ON
else
STELLARIUM_CONF_OPTS += -DENABLE_SCRIPTING=OFF
endif

ifeq ($(BR2_PACKAGE_QT5SERIALPORT),y)
STELLARIUM_DEPENDENCIES += qt5serialport
ifeq ($(BR2_PACKAGE_GPSD),y)
STELLARIUM_DEPENDENCIES += gpsd
endif
STELLARIUM_CONF_OPTS += -DENABLE_GPS=ON
else
STELLARIUM_CONF_OPTS += -DENABLE_GPS=OFF
endif

$(eval $(cmake-package))
