## Download Link: https://www.roblox.com/library/6909680501/EZ-Pathfinding-Pro

EZ Pathfinding Pro is a simple pathfinding module created for use in roblox games. It incorporates OOP and demonstrates good formatting, readability, and reliability. Extensions can be added by submitting a request with your extension in the lua sourse format.

# Why should I use this module?
This module allows for easy customizability and is flexible for many uses. It allows pathfinding to be efficiently used in a quick, simple manner.

# Why should I choose this instead of other pathfinding modules?
Not only does this module incorporate OOP, but it features many additional benefits that are related to pathfinding. With these features, you can practically create a whole AI API in a minute. The module is highly efficient and gets the job done. 

# How frequent do new versions come out/when should I change my version of the module?
Normally, updates that come to the module don't affect existing code. If this was the case, a new module would be made from scratch. Additional features however may come out over time. It is up to you on whether you switch to newer versions. All it takes it deleting the module and inserting the newer version into your game. Sometimes, updates make using the module more practical. In this case, you should switch versions to enhance your experience with this resource.

Example Test Code (Lua):

local WorkSpace = game:GetService("Workspace")
local module = require(WorkSpace:FindFirstChild("MainModule"))

local path = module.new(script.Parent, WorkSpace.Part)

path.Move()

Please read the license before distributing extensions/using this in your games.
