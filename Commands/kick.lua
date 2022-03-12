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
    reason = 'Undefined',
    help = 'Syntax: $prefix$cmd (user) (reason [optional])',
    description = 'Kick a user',

    permission = function(member, msg)
        if (not member:hasPermission('kickMembers')) then
            msg:delete()
            member:send {
                embed = {
                    title = 'Perms Error',
                    description = 'You need "kickMembers" perm to use this command.',
                    color = 0x000000
                }
            }
            return false
        end
        return true
    end,

    run = function(args, msg, Command)

        local user = args[2]
        local member = msg.member
        local reason = args[3] or Command.reason

        if (not Command.permission(member, msg)) then
            return
        elseif (not user or not reason) then
            member:send('Invalid user or reason.\n' .. Command.help)
            return
        end

        local success = pcall(function()
            user = user:gsub('[<@!>]', '')
            user = Command.server:getMember(user)
        end)

        if (success and user) then
            member:send('Kicking <@!' .. user.id .. '>, for ' .. reason)
            user:send('You were kicked for ' .. reason)
            user:kick()
            return
        end
        member:send('Invalid User ID')
    end
}