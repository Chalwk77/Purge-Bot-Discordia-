-- Purge Bot Ban Command file (v1.0)
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

    name = 'ban',
    alias = 'banuser',
    reason = "Undefined",
    description = 'Ban a user',
    help = 'Syntax: $prefix$cmd (user) (reason [optional])',
    permission = function(member, msg)
        if (not member:hasPermission('banMembers')) then
            msg:delete()
            member:reply {
                embed = {
                    title = 'Perms Error',
                    description = 'You need "banMembers" perm to use this command.',
                    color = 0x000000
                }
            }
            return false
        end
        return true
    end,

    run = function(args, msg, _, Command)

        local member = msg.member
        if (not Command.permission(member, msg)) then
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
            member:send('Banning <@!' .. user.id .. '>, for ' .. reason)
            user:send('<@!' .. user.id .. '>, ' .. reason)
            user:ban()
            return
        end
        member:send('Invalid User ID')
    end
}