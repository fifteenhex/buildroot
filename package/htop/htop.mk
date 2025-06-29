################################################################################
#
# htop
#
################################################################################

HTOP_VERSION = 3.4.1
HTOP_SOURCE = htop-$(HTOP_VERSION).tar.xz
HTOP_SITE = https://github.com/htop-dev/htop/releases/download/$(HTOP_VERSION)
HTOP_DEPENDENCIES = ncurses
# Prevent htop build system from searching the host paths
HTOP_CONF_ENV = HTOP_NCURSES_CONFIG_SCRIPT=$(STAGING_DIR)/usr/bin/$(NCURSES_CONFIG_SCRIPTS)
HTOP_LICENSE = GPL-2.0+
HTOP_LICENSE_FILES = COPYING

# ac_cv_prog_cc_c99 is required for BR2_USE_WCHAR=n because the C99 test
# provided by autoconf relies on wchar_t.
HTOP_CONF_ENV += ac_cv_prog_cc_c99=-std=gnu99

# --enable-static has a non-standard semantic in htop, and causes the
# main binary to be linked statically, not just the production of
# static libraries. This causes issues with BR2_SHARED_STATIC_LIBS as
# htop is linked statically, but pkg-config returns results relevant
# for a shared library build. Since htop is only building an
# application, let's disable this bogus behavior.
ifeq ($(BR2_SHARED_STATIC_LIBS),y)
HTOP_CONF_OPTS += --disable-static
endif

ifeq ($(BR2_PACKAGE_HWLOC),y)
HTOP_CONF_OPTS += --enable-hwloc
HTOP_DEPENDENCIES += hwloc
else
HTOP_CONF_OPTS += --disable-hwloc
endif

ifeq ($(BR2_PACKAGE_LIBCAP),y)
HTOP_CONF_OPTS += --enable-capabilities
HTOP_DEPENDENCIES += libcap
else
HTOP_CONF_OPTS += --disable-capabilities
endif

ifeq ($(BR2_PACKAGE_LM_SENSORS),y)
HTOP_CONF_OPTS += --enable-sensors
HTOP_DEPENDENCIES += lm-sensors
else
HTOP_CONF_OPTS += --disable-sensors
endif

ifeq ($(BR2_PACKAGE_NCURSES_WCHAR),y)
HTOP_CONF_OPTS += --enable-unicode
else
HTOP_CONF_OPTS += --disable-unicode
endif

$(eval $(autotools-package))
