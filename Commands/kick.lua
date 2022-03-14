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

local Command = {
    name = 'kick',
    reason = 'Undefined',
    permission_node = 'administrator',
    help = 'Syntax: $prefix$cmd (user) (reason [optional])',
    description = 'Kick a user'
}

function Command:Run(args, msg)

    local user = args[2]
    local member = msg.member
    local reason = args[3] or self.reason

    if (not HasPermission(member, msg, self.permission_node)) then
        return
    elseif (not user or not reason) then
        member:send('Invalid user or reason.\n' .. self.help)
        return
    end

    local success = pcall(function(self)
        user = user:gsub('[<@!>]', '')
        user = self.server:getMember(user)
    end)

    if (success and user) then
        member:send('Kicking <@!' .. user.id .. '>, for ' .. reason)
        user:send('You were kicked for ' .. reason)
        user:kick()
        return
    end
    member:send('Invalid User ID')
end