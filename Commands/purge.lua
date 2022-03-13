-- Purge Bot Purge Command file (v1.0)
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

local get_creation_time = require('Utilities.GetMessageTime')

return {

    name = 'purge',
    permission_node = 'administrator',
    description = 'Purge user messages in defined time frame',
    help = 'Syntax: $prefix$cmd (user) (time n) [-y, -d, -hr, -min, -sec]',

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

        local member = msg.member
        local user, time_frame, flag = args[2], args[3], args[4]
        if (not Command.permission(member, msg, Command.permission_node)) then
            return
        elseif (not user or not time_frame or not flag) then
            member:send('Invalid user, time frame or flag.\n' .. Command.help)
            return
        elseif (not time_frame:match('%d+')) then
            member:send('Invalid time frame.')
            return
        end

        user = user:gsub('[<@!>]', '')
        flag = (flag:match '-y'
                or flag:match '-d'
                or flag:match '-hr'
                or flag:match '-min'
                or flag:match '-sec')

        if (flag == '-y') then
            time_frame = time_frame * (60 * 60 * 24 * 365) --years
        elseif (flag == '-d') then
            time_frame = time_frame * (60 * 60 * 24) -- days
        elseif (flag == '-hr') then
            time_frame = time_frame * (60 * 60) -- hours
        elseif (flag == '-min') then
            time_frame = time_frame * 60 -- minutes
        elseif (flag == '-sec') then
            time_frame = time_frame -- seconds
        else
            member:send('Invalid flag.\n' .. Command.help)
            return
        end

        local inform = true
        local messages_found
        local messages = msg.channel:getMessages()
        for _, Message in pairs(messages) do
            local validated = (Message.author.id == user and not Message.author.bot)
            if (validated and get_creation_time(Message) <= time_frame) then
                messages_found = Message:delete()
                if (inform) then
                    inform = false
                    msg:delete() -- delete admin command
                    member:send('Deleting messages for ' .. Message.author.username)
                end
            end
        end

        if (not messages_found) then
            member:send('No messages for <@!' .. user .. '> found in that time frame')
        end
    end
}