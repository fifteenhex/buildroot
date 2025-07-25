################################################################################
#
# ufs-utils
#
################################################################################

UFS_UTILS_VERSION = 7.14.12
UFS_UTILS_SITE = $(call github,SanDisk-Open-Source,ufs-utils,v$(UFS_UTILS_VERSION))
UFS_UTILS_LICENSE = GPL-2.0
UFS_UTILS_LICENSE_FILES = COPYING

define UFS_UTILS_BUILD_CMDS
	$(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS) CFLAGS="$(TARGET_CFLAGS) -D_GNU_SOURCE"
endef

define UFS_UTILS_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(@D)/ufs-utils $(TARGET_DIR)/usr/bin/ufs-utils
endef

$(eval $(generic-package))
