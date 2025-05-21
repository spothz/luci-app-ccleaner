include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-ccleaner
PKG_VERSION:=1.0
PKG_RELEASE:=1

LUCI_TITLE:=Cache Cleaner LuCI App
LUCI_DEPENDS:=+luci-compat +cron

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/luci.mk

define Package/luci-app-ccleaner
  SECTION:=luci
  CATEGORY:=LuCI
  TITLE:=$(LUCI_TITLE)
  DEPENDS:=$(LUCI_DEPENDS)
  PKGARCH:=all
endef

define Package/luci-app-ccleaner/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DATA) ./luasrc/controller/cachecleaner.lua $(1)/usr/lib/lua/luci/controller/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi
	$(INSTALL_DATA) ./luasrc/model/cbi/cachecleaner.lua $(1)/usr/lib/lua/luci/model/cbi/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./root/etc/init.d/cachecleaner $(1)/etc/init.d/cachecleaner
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./root/usr/bin/clear_cache.sh $(1)/usr/bin/clear_cache.sh
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) ./root/etc/config/cachecleaner $(1)/etc/config/cachecleaner
endef

$(eval $(call BuildPackage,luci-app-ccleaner))

