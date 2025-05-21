module("luci.controller.cachecleaner", package.seeall)

function index()
    entry({"admin", "system", "cachecleaner"}, cbi("cachecleaner"), _("Cache Cleaner"), 90).dependent = true
    entry({"admin", "system", "cachecleaner", "clear"}, call("action_clear_cache"))
    entry({"admin", "system", "cachecleaner", "toggle"}, call("action_toggle_service"))
end

local sys = require "luci.sys"
local luci = require "luci.http"

function action_clear_cache()
    sys.call("sync && echo 3 > /proc/sys/vm/drop_caches")
    luci.redirect(luci.dispatcher.build_url("admin", "system", "cachecleaner"))
end

function action_toggle_service()
    local enabled = sys.exec("/etc/init.d/cachecleaner enabled")
    if enabled and enabled:match("enabled") then
        sys.call("/etc/init.d/cachecleaner disable")
        sys.call("/etc/init.d/cachecleaner stop")
    else
        sys.call("/etc/init.d/cachecleaner enable")
        sys.call("/etc/init.d/cachecleaner start")
    end
    luci.redirect(luci.dispatcher.build_url("admin", "system", "cachecleaner"))
end
