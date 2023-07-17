
-- // CanaryEngine

--[=[
	The parent of all classes.

	@class CanaryEngine
]=]
local CanaryEngine = { }

--[=[
	The runtime property contains settings that are set during runtime, and the current context of the server/client.

	@prop Runtime {RuntimeSettings: RuntimeSettings, RuntimeContext: RuntimeContext}

	@readonly
	@within CanaryEngine
]=]

--[=[
	Toggles developer mode.

	@prop DeveloperMode boolean

	@private
	@within CanaryEngine
]=]

--[=[
	The libraries property contains useful libraries like Benchmark or Serialize.

	@prop Libraries {Utility: Utility, Benchmark: Benchmark, Statistics: Statistics, Serialize: Serialize}

	@readonly
	@within CanaryEngine
]=]

--[=[
	CanaryEngine's server-sided interface.
	
	@server
	@class CanaryEngineServer
]=]
local CanaryEngineServer = { }

--[=[
	A reference to the Media folder on the Server, also gives access to replicated media.

	@prop Media {Server: Folder, Replicated: Folder}
	@readonly

	@within CanaryEngineServer
]=]

--[=[
	A reference to the Packages folder on the Server, also gives access to replicated Packages.

	@prop Packages {Server: Folder, Replicated: Folder}
	@readonly

	@within CanaryEngineServer
]=]

--[=[
	CanaryEngine's client-sided interface.
	
	@client
	@class CanaryEngineClient
]=]
local CanaryEngineClient = { }

--[=[
	A simple reference to the [Players.LocalPlayer].

	@prop Player Player
	@readonly

	@within CanaryEngineClient
]=]

--[=[
	A simple reference to the [Player.PlayerGui], useful for automatic typing and API simplicity.

	@prop PlayerGui StarterGui
	@readonly

	@within CanaryEngineClient
]=]

--[=[
	A simple reference to the player's [Backpack], useful for automatic typing and API simplicity.

	@prop PlayerBackpack StarterPack
	@readonly

	@within CanaryEngineClient
]=]

--[=[
	Local objects of the player.

	@prop LocalObjects dictionary
	@readonly
	@deprecated v2 -- Use PlayerBackpack and PlayerGui instead.

	@within CanaryEngineClient
]=]

--[=[
	A reference to the Media folder on the client, also gives access to replicated media.

	@prop Media {Client: Folder, Replicated: Folder}
	@readonly

	@within CanaryEngineClient
]=]

--[=[
	A reference to the Packages folder on the client, also gives access to replicated Packages.

	@prop Packages {Client: Folder, Replicated: Folder}
	@readonly

	@within CanaryEngineClient
]=]

--[=[
	A package's client-sided interface.
	
	@client
	@class CanaryPackageClient
]=]
local CanaryPackageClient = { }

--[=[
	A package's server-sided interface.
	
	@server
	@class CanaryPackageServer
]=]
local CanaryPackageServer = { }

-- // Types

--[=[
	A script connection, similar to an [RBXScriptConnection]

	@field Disconnect (self: ScriptConnection) -> ()
	@field Connected boolean

	@interface ScriptConnection
	@within CanaryEngine
	@private
]=]
type ScriptConnection = {
	Disconnect: (self: ScriptConnection) -> (),
	Connected: boolean,
}


--[=[
	A script signal, similar to an [RBXScriptSignal]

	@field Connect (self: ScriptSignalBasic<T>?, func: (data: {T}) -> ()) -> (ScriptConnection)
	@field Wait (self: ScriptSignalBasic<T>?) -> ({T})
	@field Once (self: ScriptSignalBasic<T>?, func: (data: {T}) -> ()) -> (ScriptConnection)
	
	@field Fire (self: ScriptSignal<T>?, data: ({T} | T)?) -> ()
	@field DisconnectAll (self: ScriptSignal<T>?) -> ()
	
	@field Name string

	@interface ScriptSignal
	@within CanaryEngine
	@private
]=]
type ScriptSignal<T> = {
	Connect: (self: ScriptSignal<T>?, func: (data: {T}) -> ()) -> (ScriptConnection),
	Wait: (self: ScriptSignal<T>?) -> ({T}),
	Once: (self: ScriptSignal<T>?, func: (data: {T}) -> ()) -> (ScriptConnection),
	
	Fire: (self: ScriptSignal<T>?, data: ({T} | T)?) -> (),
	DisconnectAll: (self: ScriptSignal<T>?) -> (),
	
	Name: string,
}

--[=[
	A ClientNetworkController is basically a mixed version of a [RemoteEvent] and [RemoteFunction]. It has better features and is more performant.

	@field Connect (self: ClientNetworkController<T>?, func: (data: {T}) -> ()) -> (ScriptConnection)
	@field Once (self: ClientNetworkController<T>?, func: (data: {T}) -> ()) -> (ScriptConnection)
	@field Wait (self: ClientNetworkController<T>?) -> ({T})
	
	@field Fire (self: ClientNetworkController<T>?, data: ({T} | T)?) -> ()
	@field InvokeAsync (self: ClientNetworkController<T>?, data: ({T} | T)?) -> ({T})
	
	@field Name string

	@interface ClientNetworkController
	@within CanaryEngine
]=]
export type ClientNetworkController<T, U> = {
	Connect: (self: ClientNetworkController<T, U>?, func: (data: {T}) -> ()) -> (ScriptConnection),
	Wait: (self: ClientNetworkController<T, U>?) -> ({T}),
	Once: (self: ClientNetworkController<T, U>?, func: (data: {T}) -> ()) -> (ScriptConnection),
	
	Fire: (self: ClientNetworkController<T, U>?, data: ({T} | T)?) -> (),
	InvokeAsync: (self: ClientNetworkController<T, U>?, data: ({T} | T)) -> ({U}),
	
	DisconnectAll: (self: ServerNetworkController<T, U>?) -> (),
	Name: string,
}

--[=[
	A ServerNetworkController is basically a mixed version of a [RemoteEvent] and [RemoteFunction]. It has better features and is more performant, though this is the server-sided API.

	@field Connect (self: ServerNetworkController<T>?, func: (sender: Player, data: {T}) -> ()) -> (ScriptConnection)
	@field Once (self: ServerNetworkController<T>?, func: (sender: Player, data: {T}) -> ()) -> (ScriptConnection)
	@field Wait (self: ServerNetworkController<T>?) -> (Player, {T})
	
	@field Fire (self: ServerNetworkController<T>?, recipient: Player | {Player}, data: ({T} | T)?) -> ()
	@field OnInvoke (self: ServerNetworkController<T>?, callback: (sender: Player, data: {T}) -> ()) -> ()
	
	@field Name string

	@interface ServerNetworkController
	@within CanaryEngine
]=]
export type ServerNetworkController<T, U> = {
	Connect: (self: ServerNetworkController<T, U>?, func: (sender: Player, data: {T}) -> ()) -> (ScriptConnection),
	Wait: (self: ServerNetworkController<T, U>?) -> (Player, {T}),
	Once: (self: ServerNetworkController<T, U>?, func: (sender: Player, data: {T}) -> ()) -> (ScriptConnection),
	
	Fire: (self: ServerNetworkController<T, U>?, recipient: Player | {Player}, data: ({T} | T)?) -> (),
	OnInvoke: (self: ServerNetworkController<T, U>?, callback: (sender: Player, data: {T}) -> ({U} | U)) -> (),
	
	DisconnectAll: (self: ServerNetworkController<T, U>?) -> (),
	Name: string,
}

-- // Variables

local MarketplaceService = game:GetService("MarketplaceService")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerService = game:GetService("Players")

if not ReplicatedStorage:FindFirstChild("CanaryEngineFramework") then
	error("CanaryEngine must be parented to DataModel.ReplicatedStorage")
end

local CanaryEngineFramework = ReplicatedStorage:WaitForChild("CanaryEngineFramework")

local Vendor = CanaryEngineFramework.CanaryEngine.Vendor
local Data = Vendor.Data
local Libraries = Vendor.Libraries
local Network = Vendor.Network
local IsDeveloperMode = CanaryEngineFramework:GetAttribute("DeveloperMode")

local Debugger = require(script.Debugger)
local Runtime = require(script.Runtime) -- Get the RuntimeSettings, which are settings that are set during runtime

local RuntimeContext = Runtime.Context
local RuntimeSettings = Runtime.Settings

--

local Signal = require(Libraries.SignalController)
local Utility = require(Libraries.Utility)
local Benchmark = require(Libraries.Benchmark)
local Statistics = require(Libraries.Statistics)
local Serialize = require(Data.BlueSerializer)
local NetworkController = require(Network.NetworkController)

CanaryEngine.RuntimeCreatedSignals = { }
CanaryEngine.RuntimeCreatedNetworkControllers = { }

CanaryEngine.Runtime = table.freeze({
	RuntimeSettings = RuntimeSettings,
	RuntimeContext = RuntimeContext,
})

CanaryEngine.Libraries = table.freeze({
	Utility = Utility,
	Benchmark = Benchmark,
	Statistics = Statistics,
	Serialize = Serialize,
})

CanaryEngine.DeveloperMode = IsDeveloperMode

-- // Functions

--[=[
	Gets the server-sided interface of CanaryEngine
	
	@server
	@return EngineServer?
]=]
function CanaryEngine.GetEngineServer()
	if RuntimeContext.Server then
		local EngineServer = ServerStorage:WaitForChild("EngineServer")
		local EngineReplicated = ReplicatedStorage:WaitForChild("EngineReplicated")

		CanaryEngineServer.Packages = {
			Server = require(EngineServer[".intellisense"]),
			Replicated = require(EngineReplicated[".intellisense"]),
		}

		CanaryEngineServer.Matchmaking = require(Network.MatchmakingService)
		CanaryEngineServer.Moderation = nil
		CanaryEngineServer.Data = require(Data.EasyProfile)

		CanaryEngineServer.Media = {
			Server = EngineServer.Media,
			Replicated = EngineReplicated.Media,
		}

		return CanaryEngineServer
	else
		Debugger.error("Failed to fetch 'EngineServer', context must be server")
		return nil
	end
end

--[=[
	Gets the client-sided interface of CanaryEngine
	
	@yields
	@client
	@return EngineClient?
]=]
function CanaryEngine.GetEngineClient()
	if not RuntimeContext.Client then
		Debugger.error("Failed to fetch 'EngineClient', Context must be client.")
		return nil
	end

	local EngineClient = ReplicatedStorage:WaitForChild("EngineClient")
	local EngineReplicated = ReplicatedStorage:WaitForChild("EngineReplicated")

	local Player = PlayerService.LocalPlayer

	CanaryEngineClient.Packages = {
		Client = require(EngineClient[".intellisense"]),
		Replicated = require(EngineReplicated[".intellisense"]),
	}

	CanaryEngineClient.Media = {
		Client = EngineClient.Media,
		Replicated = EngineReplicated.Media,
	}

	CanaryEngineClient.Player = Player

	CanaryEngineClient.PlayerGui = Player:WaitForChild("PlayerGui")
	CanaryEngineClient.PlayerBackpack = Player:WaitForChild("Backpack")

	return CanaryEngineClient
end

--[=[
	Gets the server-sided interface of CanaryEngine, for use in packages
	
	@server
	@return PackageServer?
]=]
function CanaryEngine.GetPackageServer()
	local EngineServer = ReplicatedStorage:WaitForChild("EngineServer")
	local EngineReplicated = ReplicatedStorage:WaitForChild("EngineReplicated")

	if not RuntimeContext.Server then
		Debugger.error("Failed to fetch 'PackageServer', Context must be server.")
		return nil
	end

	CanaryPackageServer.Matchmaking = require(Network.MatchmakingService)
	CanaryPackageServer.Moderation = nil
	CanaryPackageServer.Data = require(Data.EasyProfile)

	CanaryPackageServer.Media = {
		Server = EngineServer.Media,
		Replicated = EngineReplicated.Media,
	}

	return CanaryPackageServer
end

--[=[
	Gets the client-sided interface of CanaryEngine, for use in packages
	
	@client
	@return PackageClient?
]=]
function CanaryEngine.GetPackageClient()
	if not RuntimeContext.Client then
		Debugger.error("Failed to fetch 'PackageClient', Context must be client.")
		return nil
	end

	local EngineClient = ReplicatedStorage:WaitForChild("EngineServer")
	local EngineReplicated = ReplicatedStorage:WaitForChild("EngineReplicated")

	local Player = PlayerService.LocalPlayer

	CanaryEngineClient.Player = Player
	CanaryEngineClient.PlayerGui = Player:WaitForChild("PlayerGui")
	CanaryEngineClient.PlayerBackpack = Player:WaitForChild("Backpack")

	CanaryPackageClient.Media = {
		Client = EngineClient.Media,
		Replicated = EngineReplicated.Media,
	}

	return CanaryPackageClient
end

--[=[
	Creates a new network controller on the client, with the name of `controllerName`

	:::tip

	You can set the data type of a network controller after it being made like the following:

	```lua
	local NetworkController: CanaryEngine.ClientNetworkController<boolean, boolean> = EngineClient.CreateNetworkController("MyNewNetworkController") -- assuming you are sending over and recieving a boolean
	```
	:::
	
	@param controllerName string -- The name of the controller
	@return ClientNetworkController<any>
]=]
function CanaryEngineClient.CreateNetworkController(controllerName: string): ClientNetworkController<any, any>
	if not CanaryEngine.RuntimeCreatedNetworkControllers[controllerName] then
		local NewNetworkController = NetworkController.NewClientController(controllerName)

		CanaryEngine.RuntimeCreatedNetworkControllers[controllerName] = NewNetworkController
	end

	return CanaryEngine.RuntimeCreatedNetworkControllers[controllerName]
end

--[=[
	Creates a new network controller on the server, with the name of `controllerName`

	:::tip

	You can set the data type of a network controller after it being made like the following:

	```lua
	local NetworkController: CanaryEngine.ServerNetworkController<number, number> = EngineServer.CreateNetworkController("MyNewNetworkController") -- assuming you are sending over and recieving a number
	```

	:::
	
	@param controllerName string -- The name of the controller
	@return ServerNetworkController<any>
]=]
function CanaryEngineServer.CreateNetworkController(controllerName: string): ServerNetworkController<any, any>
	if not CanaryEngine.RuntimeCreatedNetworkControllers[controllerName] then
		local NewNetworkController = NetworkController.NewServerController(controllerName)
		
		CanaryEngine.RuntimeCreatedNetworkControllers[controllerName] = NewNetworkController
	end
	
	return CanaryEngine.RuntimeCreatedNetworkControllers[controllerName]
end

--[=[
	Creates a new signal that is then given a reference in the signals table.
	
	@param signalName string -- The name of the signal
	@return ScriptSignal<any>
]=]
function CanaryEngine.CreateSignal(signalName: string): ScriptSignal<any>
	if not CanaryEngine.RuntimeCreatedSignals[signalName] then
		local NewSignal = Signal.NewController(signalName)
		
		CanaryEngine.RuntimeCreatedSignals[signalName] = NewSignal
	end
	
	return CanaryEngine.RuntimeCreatedSignals[signalName]
end

--[=[
	Checks the latest version of the provided package, and returns the latest version if you gave version permissions.
	
	:::caution

	If you come across the error "package must have a valid 'VersionNumber'", that means the description of your asset does not contain the current version of your asset. This is required to compare versions.

	:::

	@yields
	@server

	@param package Instance -- The package to check the version of, must have the required attributes.
	@param warnIfNotLatestVersion boolean? -- An optional setting to warn the user if the provided package is not up-to-date, defaults to true.
	@param respectDebugger boolean? -- An optional setting to respect the debugger when warning the user, only applies when `warnIfNotLatestVersion` is true.
	
	@return number?
]=]
function CanaryEngine.GetLatestPackageVersionAsync(package: Instance, warnIfNotLatestVersion: boolean?, respectDebugger: boolean?): number?
	Utility.assertmulti(
		{package:GetAttribute("PackageId") ~= nil, "package must have a valid 'packageId'"},
		{package:GetAttribute("VersionNumber") ~= nil, "package must have a valid 'VersionNumber'"},
		{package:GetAttribute("packageId") ~= 0, "Cannot have a packageId of zero."},
		{package:GetAttribute("CheckLatestVersion") ~= nil, "package must include 'CheckLatestVersion' setting."}
	)

	if not package:GetAttribute("CheckLatestVersion") then
		return nil
	end

	warnIfNotLatestVersion = Utility.nilparam(warnIfNotLatestVersion, true)
	respectDebugger = Utility.nilparam(respectDebugger, true)

	if not RuntimeContext.Server then
		return
	end

	local MarketplaceInfo
	local Success, Error = pcall(function()
		MarketplaceInfo = MarketplaceService:GetProductInfo(package:GetAttribute("PackageId"))
	end)

	if not Success and Error then
		warn(`Could not fetch version: {Error}`)
		return nil
	end

	local FetchedVersion = string.match(MarketplaceInfo.Description, "Version: %d+") or string.match(MarketplaceInfo.Description, "v%d+")

	if not FetchedVersion then
		error("Asset description must have 'Version: (number) or 'v(number)'")
	end

	local SplitFetchedVersion = tonumber(string.split(FetchedVersion, " ")[2])

	if SplitFetchedVersion < package:GetAttribute("VersionNumber") then
		error("Package version cannot be greater than live package version.")
	end

	if SplitFetchedVersion ~= package:GetAttribute("VersionNumber") then
		if warnIfNotLatestVersion then
			if respectDebugger then
				Debugger.warn(`Package '{MarketplaceInfo.Name}' is not up-to-date. Available version: {SplitFetchedVersion}`)
				return SplitFetchedVersion
			end
			warn(`Package '{MarketplaceInfo.Name}' is not up-to-date. Available version: {SplitFetchedVersion}`)
		end
		return SplitFetchedVersion
	end

	Debugger.print(`Package '{MarketplaceInfo.Name}' is up-to-date.`)

	return SplitFetchedVersion
end

-- // Actions

return CanaryEngine