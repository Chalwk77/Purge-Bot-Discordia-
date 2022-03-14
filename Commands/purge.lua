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

local Command = {
    name = 'purge',
    permission_node = 'administrator',
    description = 'Purge user messages in defined time frame',
    help = 'Syntax: $prefix$cmd (user) (time n) [-y, -d, -hr, -min, -sec]'
}

function Command:Run(args, msg)

    local member = msg.member
    if (HasPermission(member, msg, self.permission_node)) then

        local user, time_frame, flag = args[2], args[3], args[4]
        if (not user or not time_frame or not flag) then
            member:send('Invalid user, time frame or flag.\n' .. self.help)
            return
        elseif (not time_frame:match('%d+')) then
            member:send('Invalid time frame.')
            return
        end
        time_frame = tonumber(time_frame)

        user = user:gsub('[<@!>]', '')
        flag = (flag:match '-y'
                or flag:match '-d'
                or flag:match '-hr'
                or flag:match '-min'
                or flag:match '-sec')

        if (flag == '-y') then
            time_frame = time_frame * (60 * 60 * 24 * 365) -- years
        elseif (flag == '-d') then
            time_frame = time_frame * (60 * 60 * 24) -- days
        elseif (flag == '-hr') then
            time_frame = time_frame * (60 * 60) -- hours
        elseif (flag == '-min') then
            time_frame = time_frame * 60 -- minutes
        elseif (flag == '-sec') then
            time_frame = time_frame -- seconds
        else
            member:send('Invalid flag.\n' .. self.help)
            return
        end

        local inform = true
        local messages_found
        local current_timestamp = msg.timestamp
        local messages = msg.channel:getMessages()
        if (messages) then
            for _, Message in pairs(messages) do

                local author = Message.author
                local creation_timestamp = Message.timestamp
                local validated = (author.id == user and not author.bot)

                if (validated and get_creation_time(current_timestamp, creation_timestamp) <= time_frame) then
                    messages_found = Message:delete()
                    if (inform) then
                        inform = false
                        member:send('Deleting messages for ' .. author.username)
                    end
                end
            end
        elseif (not messages_found) then
            member:send('No messages found for <@!' .. user .. '>, or none within the defined time frame.')
        else
            member:send('Something went wrong! Please try again later.')
        end
    end
end

return Command