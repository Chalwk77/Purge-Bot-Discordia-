-- Purge Bot Kick Command file (v1.0)
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

    name = 'kick',
    alias = 'kickuser',
    reason = "Undefined",
    help = 'Syntax: $prefix$cmd (user) (reason [optional])',
    roles = { '508481976714657792' },
    description = 'Kick a user',

    permission = function(roles, member)
        for _, v in pairs(roles) do
            if (member:hasRole(v)) then
                return true
            end
        end
        return false
    end,

    run = function(args, msg, _, Command)

        local member = msg.member
        if (not Command.permission(Command.roles, member, msg)) then
            member:send('**Insufficient Permission**')
            msg:delete()
            return
        end

        local user = args[2]
        local reason = args[3] or Command.reason

        if (not user or not reason) then
            member:send('Invalid user or reason\n' .. Command.help:gsub('$cmd', Command.name))
            return
        end

        local success = pcall(function()
            user = user:gsub('[<@!>]', '')
            user = Command.server:getMember(user)
        end)

        if (success and user) then
            member:send('Kicking <@!' .. user.id .. '>, for ' .. reason)
            user:send('<@!' .. user.id .. '>, ' .. reason)
            user:kick()
            return
        end
        member:send('Invalid User ID')
    end
}