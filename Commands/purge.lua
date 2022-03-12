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

local time = os.time
local creation_time = require('Utilities.GetMessageTimeStamp')

return {

    name = 'purge',
    description = 'Purge user messages in defined time frame',
    help = 'Syntax: $prefix$cmd (user) (time n) [-y, -d, -hr, -min, -sec]',

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

    run = function(args, msg, Command)

        local member = msg.member
        local user, time_frame, flag = args[2], args[3], args[4]
        if (not Command.permission(member, msg)) then
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
            time_frame = time() - time_frame / (60 * 60 * 24 * 365)
        elseif (flag == '-d') then
            time_frame = time_frame / (60 * 60 * 24)
        elseif (flag == '-hr') then
            time_frame = time() - (time_frame * 60)
        elseif (flag == '-min') then
            time_frame = time() - 60
        elseif (flag == '-sec') then
            time_frame = time() - time_frame
        else
            member:send('Invalid flag.\n' .. Command.help)
            return
        end

        local channel = Command.client:getChannel(msg.channel.id)
        local messages = channel:getMessages()

        local messages_found
        for MessageID, _ in pairs(messages) do
            local message = channel:getMessage(MessageID)
            local validated = (message.author.id == user and not message.author.bot)
            if (validated and creation_time(message) < tonumber(time_frame)) then
                messages_found = message:delete()
            end
        end

        if (not messages_found) then
            member:send('No messages for <@!' .. user .. '> found in that time frame')
        else
            member:send('Deleting messages for <@!' .. user .. '>')
        end

        msg:delete()
    end
}