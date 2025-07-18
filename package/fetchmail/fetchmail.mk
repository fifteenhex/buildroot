################################################################################
#
# fetchmail
#
################################################################################

FETCHMAIL_VERSION_MAJOR = 6.5
FETCHMAIL_VERSION = $(FETCHMAIL_VERSION_MAJOR).4
FETCHMAIL_SOURCE = fetchmail-$(FETCHMAIL_VERSION).tar.xz
FETCHMAIL_SITE = https://downloads.sourceforge.net/project/fetchmail/branch_$(FETCHMAIL_VERSION_MAJOR)
FETCHMAIL_LICENSE = GPL-2.0; some exceptions are mentioned in COPYING
FETCHMAIL_LICENSE_FILES = COPYING
FETCHMAIL_CPE_ID_VENDOR = fetchmail
FETCHMAIL_SELINUX_MODULES = fetchmail mta

FETCHMAIL_CONF_OPTS = \
	--with-ssl=$(STAGING_DIR)/usr

FETCHMAIL_DEPENDENCIES = \
	ca-certificates \
	host-pkgconf \
	openssl \
	$(TARGET_NLS_DEPENDENCIES)

$(eval $(autotools-package))
