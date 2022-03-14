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

local Command = {
    duration = 60,
    name = 'timeout',
    reason = 'Undefined',
    description = 'Timeout a user',
    permission_node = 'administrator',
    help = 'Syntax: $prefix$cmd (user) (duration) (reason [optional])'
}

function Command:Run(args, msg)

    local user = args[2]
    local member = msg.member
    local duration = args[3] or self.duration
    local reason = args[4] or self.reason

    if (HasPermission(member, msg, self.permission_node)) then

        if (not user or not reason or not duration) then
            member:send('Invalid user, reason or duration.\n' .. self.help)
            return
        elseif (not duration:match('%d+')) then
            member:send('Invalid duration.\n' .. self.help)
            return
        end

        local success = pcall(function(self)
            user = user:gsub('[<@!>]', '')
            user = self.server:getMember(user)
        end)

        if (success and user) then
            member:send('Timing out <@!' .. user.id .. '>, for ' .. reason)
            user:send('You were timed out for ' .. reason)
            user:timeoutFor(duration * 60)
            return
        end
        member:send('Invalid User ID (or something went wrong)')
    end
end