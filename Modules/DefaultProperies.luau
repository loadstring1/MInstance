local sub=string.sub
local lower=string.lower
local insert=table.insert

local ReflectionService=game:GetService("ReflectionService")
local security=SecurityCapabilities.fromCurrent()

local IsApiInitialized = false
local Classes = {}
local DefaultProperties = {}

DefaultProperties.InitializeApiDump = function()
	for _, Class in ReflectionService:GetClasses({Security=security}) do
		if Class.Permits.New==nil then continue end

		if typeof(Classes[Class.Name])~="table" then Classes[Class.Name]={} end
		for _,Property in ReflectionService:GetPropertiesOfClass(Class.Name,{Security=security}) do
			local NameFirstLetter = sub(Property.Name,1, 1)
			if Property.Permits.Write==nil or NameFirstLetter==lower(NameFirstLetter) then continue end
			insert(Classes[Class.Name],Property.Name)
		end
	end

	IsApiInitialized = true
	
	return true
end

DefaultProperties.IsApiInitialized = function()
	return IsApiInitialized
end

DefaultProperties.GetPropertiesOfClass = function(ClassName)
	return Classes[ClassName]
end

return DefaultProperties