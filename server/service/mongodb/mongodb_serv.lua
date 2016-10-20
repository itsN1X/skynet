local fish = require "fish"
local mongo = require "mongo"
local bson = require "bson"
local collections = require "mongodb.mongodb_collection"


local _M = {}

local client

function _M.start(host,port)
	client = mongo.client({host = host , port = port})
end

function _M.stop()
	client:disconnect()
end

local function getCollection(database,collection)
	local db = client:getDB(database)
	if collections.exist(collection) == false then
		error(string.format("collection:%s not register",collection))
	end
	return db:getCollection(collection)
end

fish.register_message("createIndex",function (source,args)
	local c = getCollection(args.database,args.collection)
	local result = c:createIndex(args.keys, args.option)
	fish.ret(result)
end)

fish.register_message("findOne",function (source,args)
	local c = getCollection(args.database,args.collection)
	local result = c:findOne(args.query,args.selector)
	fish.ret(result)
end)

fish.register_message("findAll",function (source,args)
	local c = getCollection(args.database,args.collection)
	local result = {}
	local cursor = c:find(args.query, args.selector)
	if args.skip ~= nil then
		cursor:skip(args.skip)
	end
	if args.limit ~= nil then
		cursor:limit(args.limit)
	end
	while cursor:hasNext() do
		local document = cursor:next()
		table.insert(result,document)
	end	
	cursor:close()
	if #result == 0 then
		fish.ret(nil)
	else
		fish.ret(result)
	end
end)

fish.register_message("update",function (source,args)
	local c = getCollection(args.database,args.collection)
	c:update(args.selector,args.update,args.upsert,args.multi)
end)

fish.register_message("insert",function (source,args)
	local c = getCollection(args.database,args.collection)
	c:insert(args.doc)
end)

fish.register_message("insertBatch",function (source,args)
	local c = getCollection(args.database,args.collection)
	c:batch_insert(args.docs)
end)

fish.register_message("delete",function (source,args)
	local c = getCollection(args.database,args.collection)
	c:delete(args.selector, args.single)
end)

fish.register_message("drop",function (source,args)
	local db = client:getDB(args.database)
	local r = db:runCommand("drop",args.collection)
	fish.ret(r)
end)

fish.register_message("runCommand",function (source,args)
	local db = client:getDB(args.database)
	local result = db:runCommand(table.unpack(args.args))
	fish.ret(result)
end)


return _M