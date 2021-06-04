EZ Pathfinding Pro is a simple pathfinding module created for use in roblox games. It incorporates OOP and demonstrates good formatting, readability, and reliability. Extensions can be added by submitting a request with your extension in the lua sourse format.

Example Test Code (Lua):

local WorkSpace = game:GetService("Workspace")
local module = require(WorkSpace:FindFirstChild("MainModule"))

local path = module.new(script.Parent, WorkSpace.Part)

path.Move()

Please read the license before distributing extensions/using this in your games.
