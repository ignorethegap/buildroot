WPEFRAMEWORK_VERSION = 568bd30764e23b102c55ba4ec8162de97ddcc85d
WPEFRAMEWORK_SITE_METHOD = git
WPEFRAMEWORK_SITE = git@github.com:WebPlatformForEmbedded/WPEFramework.git
WPEFRAMEWORK_INSTALL_STAGING = YES
WPEFRAMEWORK_DEPENDENCIES = zlib

WPEFRAMEWORK_CONF_OPTS += -DBUILD_REFERENCE=$(shell $(GIT) rev-parse HEAD)
WPEFRAMEWORK_CONF_OPTS += -DINSTALL_HEADERS_TO_TARGET=ON -DWPEFRAMEWORK_TEST_APPS=ON -DWPEFRAMEWORK_TEST_LOADER=ON

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_DEBUG),y)
# TODO: This recently stopped working, for now pass debug flags explicitly.
#WPEFRAMEWORK_CONF_OPTS += -DCMAKE_BUILD_TYPE=Debug
WPEFRAMEWORK_CONF_OPTS += -DCMAKE_CXX_FLAGS='-g -Og'
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_VIRTUALINPUT),y)		
WPEFRAMEWORK_CONF_OPTS += -DWPEFRAMEWORK_VIRTUALINPUT=ON		
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_TEST_CYCLICINSPECTOR),y)
WPEFRAMEWORK_CONF_OPTS += -DWPEFRAMEWORK_TEST_CYCLICINSPECTOR=ON
endif

define WPEFRAMEWORK_POST_TARGET_INITD
    mkdir -p $(TARGET_DIR)/etc/init.d
    $(INSTALL) -D -m 0755 package/WPEFramework/S80WPEFramework $(TARGET_DIR)/etc/init.d
    mkdir -p $(TARGET_DIR)/etc/WPEFramework
    rm -rf $(TARGET_DIR)/usr/share/WPEFramework/cmake
endef

ifneq ($(BR2_PACKAGE_WPEFRAMEWORK_DISABLE_INITD),y)
WPEFRAMEWORK_POST_INSTALL_TARGET_HOOKS += WPEFRAMEWORK_POST_TARGET_INITD
endif

$(eval $(cmake-package))

include package/WPEFramework/*/*.mk
