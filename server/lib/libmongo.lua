local fish = require "fish"

local bson = require "bson"
local driver = require "mongo.driver"

local mongodb_handle = fish.localname(".mongodb")
assert(mongodb_handle ~= nil,string.format("mongodb service not exist"))

local mongodb = {}

local collection_meta = {}

local db_meta = {
	__index = function (self, key)
		assert(self.database ~= nil)
		self.collection = setmetatable({ database = self.database,collection = key},{__index = collection_meta})
		return self.collection
	end,
	__tostring = function (self)
		return "[mongodb : " .. self.database .. "]"
	end
}

function mongodb.new(name)
	local db = {
		database = name,
		copydb = mongodb.copydb,
		dropdb = mongodb.dropdb,
	}
	return setmetatable(db,db_meta)
end

function mongodb.listdb()
	return fish.call(mongodb_handle,"runCommand",{database = "admin",args = {"listDatabases", 1}})
end

function mongodb:copydb(to)
	return fish.call(mongodb_handle,"runCommand",{database = "admin",args = {"copydb",1,"fromdb",self.database,"todb",to}})
end

function mongodb:dropdb()
	return fish.call(mongodb_handle,"runCommand",{database = self.database,args = {"dropDatabase",1}})
end

function collection_meta:insert(doc)
	fish.send(mongodb_handle,"insert",{database = self.database,collection = self.collection,doc = doc})
end

function collection_meta:insertBatch(docs)
	fish.send(mongodb_handle,"insertBatch",{database = self.database,collection = self.collection,docs = docs})
end

function collection_meta:update(selector,updator,upsert,multi)
	local selector = driver.malloc_doc(bson.encode(selector))
	local updator = driver.malloc_doc(bson.encode(updator))
	fish.send(mongodb_handle,"update",{database = self.database,collection = self.collection,selector = selector,update = updator,upsert = upsert,multi = multi})
end

function collection_meta:delete(selector, single)
	fish.send(mongodb_handle,"delete",{database = self.database,collection = self.collection,selector = selector,single = single})
end

function collection_meta:drop()
	return fish.call(mongodb_handle,"drop",{database = self.database,collection = self.collection})
end

function collection_meta:findOne(query, selector)
	local doc_ptr = fish.call(mongodb_handle,"findOne",{database = self.database,collection = self.collection,query = query,selector = selector})
	if doc_ptr ~= nil then
		local doc = bson.decode(doc_ptr)
		doc._id = nil
		driver.free_doc(doc_ptr)
		return doc
	end
end

function collection_meta:findAll(query,selector,limit, skip)
	local r = fish.call(mongodb_handle,"findAll",{database = self.database,collection = self.collection,query = query,selector= selector,limit = limit,skip = skip})
	if r ~= nil then
		local list = {}
		for _,doc_ptr in pairs(r) do
			local doc = bson.decode(doc_ptr)
			doc._id = nil
			table.insert(list,doc)
			driver.free_doc(doc_ptr)
		end
		return list
	end
end


function collection_meta:createIndex(keys,unique)
	local option = {unique = false}
	if unique then
		option.unique = unique
	end
	return fish.call(mongodb_handle,"createIndex",{database = self.database,collection = self.collection,keys = keys,option = option})
end


return mongodb
