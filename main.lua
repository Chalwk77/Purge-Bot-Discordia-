-- Purge Bot Entry point file (v1.0)
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

_G.commands = {}
_G.HasPermission = function(member, msg, node)
    if (not member:hasPermission(node)) then
        msg:delete()
        member:send {
            embed = {
                title = 'Perms Error',
                description = 'You need "' .. node .. '" perm to use this command.',
                color = 0x000000
            }
        }
        return false
    end
    return true
end

Discord:on('ready', function()
    local server = Discord:getGuild(settings.discord_server_id)
    if (server) then

        local mt = { __index = Discord, server = server }

        Discord:info('READY ' .. ' Bot Version: ' .. settings.bot_version)
        for _, file in pairs(settings.commands) do
            local command = require('./Commands/' .. file)

            commands[command.name] = command
            commands[command.name].help = command.help:gsub('$prefix', settings.prefix):gsub('$cmd', command.name)
            setmetatable(commands[command.name], mt)
        end
    end
end)

local function CMDSplit(Str)
    local args = { }
    for arg in Str:gmatch("([^%s]+)") do
        args[#args + 1] = arg:lower()
    end
    return args
end

Discord:on('messageCreate', function(msg)

    local member = msg.member
    local args = CMDSplit(msg.content)

    if (not msg.author or msg.author.id == Discord.user.id or msg.author.bot) then
        return
    elseif (#args > 0) then

        if (args[1]:sub(1, 1) ~= settings.prefix) then
            return false
        end

        local success, err = pcall(function()
            args[1] = args[1]:gsub(settings.prefix, '')
            local cmd = commands[args[1]]
            if (cmd) then
                cmd:Run(args, msg)
            end
        end)

        if (not success) then
            Discord:warning(err)
            member:send('Something went wrong, please try again later')
        end
    end
end)

Discord:run('Bot ' .. settings.token())
Discord:setGame('Purging messages since circa 2022')