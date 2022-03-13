-- Purge Bot Timeout Command file (v1.0)
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

    duration = 60,
    name = 'timeout',
    reason = 'Undefined',
    permission_node = 'administrator',
    help = 'Syntax: $prefix$cmd (user) (duration) (reason [optional])',
    description = 'Timeout a user',

    permission = function(member, msg, perm)
        if (not member:hasPermission(perm)) then
            msg:delete()
            member:send {
                embed = {
                    title = 'Perms Error',
                    description = 'You need "' .. perm .. '" perm to use this command.',
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
        local duration = args[3] or Command.duration
        local reason = args[4] or Command.reason

        if (not Command.permission(member, msg, Command.permission_node)) then
            return
        elseif (not user or not reason or not duration) then
            member:send('Invalid user, reason or duration.\n' .. Command.help)
            return
        elseif (not duration:match('%d+')) then
            member:send('Invalid duration.\n' .. Command.help)
            return
        end

        local success = pcall(function()
            user = user:gsub('[<@!>]', '')
            user = Command.server:getMember(user)
        end)

        if (success and user) then
            member:send('Timing out <@!' .. user.id .. '>, for ' .. reason)
            user:send('You were timed out for ' .. reason)
            user:timeoutFor(duration * 60)
            return
        end
        member:send('Invalid User ID')
    end
}