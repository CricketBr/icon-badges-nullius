if not cb then cb = {} end
if not cb.ibg then cb.ibg = {} end


local b -- for breakpoints
b = 0

-- get the settings file, we know which settings are ours


local lsettings = require('settings-table-file')
local lbigtablecsv = require('bigtable-csv-file-nullius')
-- convert the csv file to a lua structure
local lbigtable = cb.ibg.csv_to_lua(lbigtablecsv)

-- you can make the lua structure without making csv first,
-- but I found the csv file much easier to work with,
-- especially when there are 100s of items and/or fluids,
-- and the badgegroups keep changing

--



cb.ibg.do_badges(lsettings, lbigtable)
-- This will do barrels automatically
-- Don't worry about fluids that don't have barrels. do_badges checks for them.

-------------------------------------------------------------------------------------------
-- Start of Nullius-only code

local l_boxed = {}

for i, v in ipairs(lbigtable) do                                 --
    if v.type == "item" then
        local n1 = string.gsub(v.name, "nullius", "nullius-box") -- if n1 = v.name then nullius wasn't in v.name
        local n2 = "nullius-box-" .. v.name

        if n1 ~= v.name then -- nullius in the name
            if data.raw.item[n1] then
                table.insert(l_boxed, 0, { name = n1, type = 'item', badge = v.badge, badgegroup = v.badgegroup })
                -- log('cb nullius groups added ' .. n1)
            end
        elseif data.raw.item[n2] then -- nullius is in the name
            table.insert(l_boxed, 0, { name = n2, type = 'item', badge = v.badge, badgegroup = v.badgegroup })
            -- log('cb nullius groups added ' .. n2)
        end
    end
end

cb.ibg.do_badges(lsettings, l_boxed)
b=0

-- end of nullius-only code
-------------------------------------------------------------------------------------------