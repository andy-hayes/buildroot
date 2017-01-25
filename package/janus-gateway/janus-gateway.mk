################################################################################
#
# janus-gateway
#
################################################################################

JANUS_GATEWAY_VERSION = v0.2.1
JANUS_GATEWAY_SITE = $(call github,meetecho,janus-gateway,$(JANUS_GATEWAY_VERSION))
JANUS_GATEWAY_LICENSE = GPLv3
JANUS_GATEWAY_LICENSE_FILES = COPYING

# ding-libs provides the ini_config library
JANUS_GATEWAY_DEPENDENCIES = host-pkgconf jansson libnice \
	libsrtp host-gengetopt libglib2 openssl 

# Straight out of the repository, no ./configure, and we also patch
# configure.ac.
JANUS_GATEWAY_AUTORECONF = YES

define JANUS_GATEWAY_M4
	mkdir -p $(@D)/m4
endef
JANUS_GATEWAY_POST_PATCH_HOOKS += JANUS_GATEWAY_M4

JANUS_GATEWAY_CONF_OPTS = \
	--disable-data-channels \
	--disable-rabbitmq

ifeq ($(BR2_PACKAGE_JANUS_AUDIO_BRIDGE),y)
JANUS_GATEWAY_DEPENDENCIES += opus
JANUS_GATEWAY_CONF_OPTS += --enable-plugin-audiobridge
else
JANUS_GATEWAY_CONF_OPTS += --disable-plugin-audiobridge
endif

ifeq ($(BR2_PACKAGE_JANUS_ECHO_TEST),y)
JANUS_GATEWAY_CONF_OPTS += --enable-plugin-echotest
else
JANUS_GATEWAY_CONF_OPTS += --disable-plugin-echotest
endif

ifeq ($(BR2_PACKAGE_JANUS_RECORDPLAY),y)
JANUS_GATEWAY_CONF_OPTS += --enable-plugin-recordplay
else
JANUS_GATEWAY_CONF_OPTS += --disable-plugin-recordplay
endif

ifeq ($(BR2_PACKAGE_JANUS_SIP_GATEWAY),y)
JANUS_GATEWAY_DEPENDENCIES += sofia-sip
JANUS_GATEWAY_CONF_OPTS += --enable-plugin-sip
else
JANUS_GATEWAY_CONF_OPTS += --disable-plugin-sip
endif

ifeq ($(BR2_PACKAGE_LIBWEBSOCKETS),y)
JANUS_GATEWAY_DEPENDENCIES += libwebsockets
JANUS_GATEWAY_CONF_OPTS += --enable-websockets
else
JANUS_GATEWAY_CONF_OPTS += --disable-websockets
endif

ifeq ($(BR2_PACKAGE_LIBOGG),y)
JANUS_GATEWAY_DEPENDENCIES += libogg
JANUS_GATEWAY_CONF_OPTS += --enable-plugin-voicemail
else
JANUS_GATEWAY_CONF_OPTS += --disable-plugin-voicemail
endif

# Parallel build broken
JANUS_GATEWAY_MAKE = $(MAKE1)

$(eval $(autotools-package))
