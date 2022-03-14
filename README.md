# Purge-Bot (v1.0)

**Description:**<br/>
> A Discord Bot framework built using the Discordia API and Luvit runtime environment.

#### Commands:

Command | Description
------------ | ------------
**>purge (user) (time n) [-y, -mo, -wk, -d, -hr, -min, -sec]** | Purge messages within defined time frame.<br/>Required Permission: **administrator**
**>timeout (user) (duration) (reason [optional])** | Timeout a user.<br/>Required Permission: **administrator**
**>kick (user) (reason [optional])** | Kick a user.<br/>Required Permission: **administrator**
**>ban (user) (reason [optional])** | Ban a user.<br/>Required Permission: **administrator**
**>purgehelp** | Show command descriptions and syntax.<br/>Required Permission: **administrator**

# Installation:

Prerequisites:
**Setup requires that you have Administrative or _Manage Server_ permissions on the Discord server.**

A quick note for Linux users:
You will be required to install the **Luvit Runtime Environment**.
Follow [these instructions](https://luvit.io/install.html) to learn how.

-----

1. Register an application on the [Discord Developer Portal](https://Discordapp.com/developers/applications/) and obtain
   a **bot token**. A Discord bot token is a short phrase (represented as a jumble of letters and numbers) that acts as
   a key to controlling a Discord Bot.

2. Create a file called Auth.data.
3. Place in root folder (./Purge Bot)
4. Put your bot token inside the *./Purge Bot/Auth.data* file and **never** share your Discord bot token with anyone.

There are many tutorials online to help you learn how to create a Discord Application, however, as a general guide,
follow these steps:

5. Click **New Application**

- Provide a name for your bot and click create.
- Click the **Bot** tab then click the blue *Add Bot* button (click "*yes, do it!*", when prompted).
- Copy your token and paste it into the aforementioned Auth.data file located inside the Discord Bot folder.

6. Now click the OAuth2 tab and check the BOT scope. Under bot permissions -> general permissions, check **
   Administrator**. Copy and paste the URL that gets generated into a web browser and hit enter.

7. You will be prompted to add the bot to a Discord server, select one, click continue and authorize.

**You have now successfully added the Discord Application to your Discord server.**

____

### **IMPORTANT**

**Further configuration is required.**<br/>
This bot is NOT plug-and-play. See *Purge Bot/settings.lua* for full configuration.

**Launching the Discord Bot**<br/>
Open Command Prompt/Terminal and CD into the Discord Bot folder. Type *luvit main*.

If you need help installing on Linux (or Windows, for that matter), DM me on Discord:<br/>
_Chalwk#9284_

____
