################################################################################
#
# mhz
#
################################################################################

MHZ_VERSION = 303f17ec8278ae734cf97b2548c60367a411ea3b
MHZ_SITE = https://github.com/wtarreau/mhz.git
MHZ_SITE_METHOD = git

define MHZ_BUILD_CMDS
	$(MAKE) -C $(@D) CC=$(TARGET_CC)
endef

define MHZ_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/mhz \
		$(TARGET_DIR)/usr/bin/mhz
endef

$(eval $(generic-package))
