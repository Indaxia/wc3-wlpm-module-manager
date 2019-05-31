-- project: Warcraft 3 Lua Package Manager 1.0
-- author: ScorpioT1000 / scorpiot1000@yandex.ru / github.com/indaxia

local wlpmModules = {}

function wlpmDeclareModule(name, dependenciesOrContext, context)
  local theModule = {
    loaded = false,
    dependencies = {},
    context = nil,
    exports = {},
    exportDefault = nil
  }
  if (type(context) == "function") then
    theModule.context = context
    if (type(dependenciesOrContext) == "table") then
      theModule.dependencies = dependenciesOrContext
    end
  elseif (type(dependenciesOrContext) == "function") then
    theModule.context = dependenciesOrContext
  else  
    print("WLPM Error: wrong module declaration: '" .. name .. "'. Module requires context function callback.")
    return
  end
  wlpmModules[name] = theModule
end

function wlpmLoadModule(name, depth)
  local theModule = wlpmModules[name]
  if (type(depth) == 'number') then
    if (depth > 512) then
      print("WLPM Error: dependency loop detected for the module '" .. name .. "'")
      return
    end
    depth = depth + 1
  else
    local depth = 0
  end
  if (type(theModule) ~= "table") then
    print("WLPM Error: module '" .. name .. "' not exists or not yet loaded. Call importWM at your initialization section")
    return
  elseif (not theModule.loaded) then
    for _, dependency in ipairs(theModule.dependencies) do
      wlpmLoadModule(dependency, depth)
    end
    
    local cb_import = function(moduleOrWhatToImport, moduleToImport) -- import default or import special
      if (type(moduleToImport) ~= "string") then
        return wlpmImportModule(moduleOrWhatToImport)
      end
      return wlpmImportModule(moduleToImport, moduleOrWhatToImport)
    end
    local cb_export = function(whatToExport, singleValue) -- export object or key and value
      if (type(whatToExport) == "table") then
        for k,v in pairs(whatToExport) do theModule.exports[k] = v end -- merges exports
      elseif (type(whatToExport) == "string") then
        theModule.exports[whatToExport] = singleValue
      else
        print("WLPM Error: wrong export syntax in module '" .. name .. "'. Use export() with a single object arg or key-value args")
        return
      end
    end
    local cb_exportDefault = function(defaultExport) -- export default
      if (defaultExport == nil) then
        print("WLPM Error: wrong default export syntax in module '" .. name .. "'. Use exportDefault() with an argument")
        return
      end
      theModule.exportDefault = defaultExport
    end
    
    theModule.context(cb_import, cb_export, cb_exportDefault)
    theModule.loaded = true
  end
  
  return theModule
end

function wlpmImportModule(name, whatToImport)
  theModule = wlpmLoadModule(name)
  if (type(whatToImport) == "string") then
    if(theModule.exports[whatToImport] == nil) then
      print("WLPM Error: name '" .. whatToImport .. "' was never exported by the module '" .. name .. "'")
      return
    end
    return theModule.exports[whatToImport]
  end
  return theModule.exportDefault
end

function wlpmLoadAllModules()
  for name,theModule in pairs(wlpmModules) do wlpmLoadModule(name) end
end

WM = wlpmDeclareModule
importWM = wlpmImportModule
loadAllWMs = wlpmLoadAllModules -- call to disable lazy loading mechanics
