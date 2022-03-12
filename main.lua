-- Purge Bot configuration file (v1.0)
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

local settings = require('settings')
local Discordia = require('discordia')
local Discord = Discordia.Client()

local commands = {}

local function RunCommand(msg, args)

    local prefix = args[1]:sub(1, settings.prefix:len())
    args[1] = args[1]:gsub(prefix, '')

    for _, v in pairs(commands) do
        if (v.name:lower() == args[1] or v.alias:lower() == args[1]) then
            v.run(args, msg, Discord, v, commands)
            break
        end
    end
end

local function CMDSplit(Str)
    local args = { }
    for arg in Str:gmatch("([^%s]+)") do
        args[#args + 1] = arg:lower()
    end
    return args
end

Discord:on('ready', function()
    server = Discord:getGuild(settings.discord_server_id)
    if (server) then

        for _, file in pairs(settings.commands) do
            local command = require('./Commands/' .. file)
            commands[#commands + 1] = {
                server = server,
                run = command.run,
                name = command.name,
                help = command.help,
                alias = command.alias,
                roles = command.roles,
                reason = command.reason,
                prefix = settings.prefix,
                duration = command.duration,
                permission = command.permission,
                description = command.description
            }
        end
    end
end)

Discord:on('messageCreate', function(msg)

    local member = msg.member
    if (not msg.author or msg.author.id == Discord.user.id or msg.author.bot) then
        return
    end

    local args = CMDSplit(msg.content)
    if (#args > 0) then
        
        if (args[1]:sub(1, 1) ~= settings.prefix) then
            return false
        end

        local success, err = pcall(function()
            RunCommand(msg, args)
        end)

        if (not success) then
            Discord:warning(err)
            member:send('Something went wrong, please try again later')
        end
    end
end)

Discord:run('Bot ' .. settings.token())
Discord:setGame('Purging messages since circa 2022')