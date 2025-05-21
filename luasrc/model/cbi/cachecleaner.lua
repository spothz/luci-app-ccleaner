local m = Map("cachecleaner", "Cache Cleaner")

local s = m:section(TypedSection, "settings", "Service Control")
s.anonymous = true

local enable = s:option(Flag, "enabled", "Enable Cache Cleaner Service")
enable.rmempty = false

function enable.write(self, section, value)
    Flag.write(self, section, value)
    if value == "1" then
        os.execute("/etc/init.d/cachecleaner enable")
        os.execute("/etc/init.d/cachecleaner start")
    else
        os.execute("/etc/init.d/cachecleaner stop")
        os.execute("/etc/init.d/cachecleaner disable")
    end
end

local btn_clear = s:option(Button, "_clear_cache", "Clear Cache Now")
btn_clear.inputstyle = "apply"
function btn_clear.write()
    os.execute("sync && echo 3 > /proc/sys/vm/drop_caches")
end

local sch = m:section(TypedSection, "schedule", "Schedule")
sch.anonymous = true

local interval = sch:option(ListValue, "interval", "Clear Cache Interval")
interval:value("daily", "Once a day")
interval:value("weekly", "Once a week")
interval:value("monthly", "Once a month")
interval.default = "daily"

function interval.write(self, section, value)
    self.map:set(section, "interval", value)
    local cron_cmd = "/usr/bin/clear_cache.sh"
    local cron_line = ""

    if value == "daily" then
        cron_line = "0 3 * * * " .. cron_cmd
    elseif value == "weekly" then
        cron_line = "0 3 * * 0 " .. cron_cmd
    elseif value == "monthly" then
        cron_line = "0 3 1 * * " .. cron_cmd
    else
        cron_line = ""
    end

    -- Обновить cron
    os.execute("crontab -l | grep -v '/usr/bin/clear_cache.sh' | crontab -")
    if cron_line ~= "" then
        os.execute("(crontab -l; echo '" .. cron_line .. "') | crontab -")
    end
end

return m
