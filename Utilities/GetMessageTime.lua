-- Purge Bot GetMessageTime file (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

--[[
    This file is part of Purge Bot.

    Purge Bot is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Purge Bot is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with Purge Bot. If not, see <http://www.gnu.org/licenses/>.
]]

local time = os.time
local date = os.date
local diff = os.difftime

local now_pattern = '%Y-%m-%dT%H:%M:%S'
local pattern = '(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+)'

return function(msg)

    local creation_timestamp = msg.timestamp
    local cy, cm, cd, chr, cmin, csec = creation_timestamp:match(pattern)
    local creation_reference = time { year = cy, month = cm, day = cd, hour = chr, min = cmin, sec = csec }

    local time_now = date(now_pattern, time())
    local y, m, d, hr, min, sec = time_now:match(pattern)
    local now_reference = time { year = y, month = m, day = d, hour = hr, min = min, sec = sec }

    return diff(now_reference, creation_reference)
end