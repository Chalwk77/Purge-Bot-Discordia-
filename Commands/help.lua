-- Purge Bot Help Command file (v1.0)
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

    name = 'purgehelp',
    alias = 'purgehelpme',
    description = 'Show command descriptions',
    help = 'Syntax: $prefix$cmd',

    permission = function(member, msg)
        if (not member:hasPermission('manageMembers')) then
            msg:delete()
            member:send {
                embed = {
                    title = 'Perms Error',
                    description = 'You need "manageMembers" perm to use this command.',
                    color = 0x000000
                }
            }
            return false
        end
        return true
    end,

    run = function(_, msg, Command, Commands)
        local member = msg.member
        if (not Command.permission(member, msg)) then
            return
        end
        local help = ""
        for _, v in pairs(Commands) do
            help = help .. 'Command: ' .. v.name ..
                    '\nDescription: ' .. v.description ..
                    '\n' .. v.help .. '\n\n'
        end
        msg.member:send(help)
    end
}