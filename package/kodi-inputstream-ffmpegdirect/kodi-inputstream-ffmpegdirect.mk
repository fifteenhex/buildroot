################################################################################
#
# kodi-inputstream-ffmpegdirect
#
################################################################################

KODI_INPUTSTREAM_FFMPEGDIRECT_VERSION = 21.3.8-Omega
KODI_INPUTSTREAM_FFMPEGDIRECT_SITE = $(call github,xbmc,inputstream.ffmpegdirect,$(KODI_INPUTSTREAM_FFMPEGDIRECT_VERSION))
KODI_INPUTSTREAM_FFMPEGDIRECT_LICENSE = GPL-2.0+
KODI_INPUTSTREAM_FFMPEGDIRECT_LICENSE_FILES = LICENSE.md
KODI_INPUTSTREAM_FFMPEGDIRECT_DEPENDENCIES = bzip2 ffmpeg kodi
KODI_INPUTSTREAM_FFMPEGDIRECT_CONF_OPTS = \
	-DFFMPEG_PATH=$(STAGING_DIR)/usr

$(eval $(cmake-package))
