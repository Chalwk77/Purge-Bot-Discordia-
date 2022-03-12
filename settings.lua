-- Purge Bot settings file (v1.0)
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

return {

    discord_server_id = '508458848559038465',

    -- Command prefix:
    prefix = "!",

    commands = {
        'purge',

        --
        -- todo: other commands
        --
    },

    token = function()
        local token = ''
        local file = io.open('./Auth.data')
        if (file) then
            token = file:read()
            file:close()
        end
        return token
    end
}