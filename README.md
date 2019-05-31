Warcraft 3 Lua Module Manager (like ES6)

Provides functions to create and use [ES6-style modules](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/export#Using_the_default_export) in Warcraft 3 lua code. WM means Warcraft Module.

## How to install
- Copy [wlpm-module-manager.lua](wlpm-module-manager.lua) to your top Custom Code section or top of the war3map.lua
- OR use [WLPM](https://github.com/Indaxia/WLPM), this is built-in there
- OR download [Demo map](wlpm-mm-demo1.w3x)

## Example Usage


```lua
WM("myMainModule", function(import, export, exportDefault) -- declare your main module
    local greeting = import "helloModule" -- use default export value
    local anotherGreeting = import("welcome", "helloModule") -- use custom export value
    local coffee = import "coffeeModule"
    local anotherCoffee = import("cappuccino", "coffeeModule")
    
    print (greeting)
    print (anotherGreeting)
    print (coffee)
    print (anotherCoffee)
end)

WM("coffeeModule", function(import, export, exportDefault) -- declare your module
    exportDefault "Espresso!" -- declare default export value
    export("cappuccino", "Your cappuccino, sir!") -- declare custom export value
end)

WM("helloModule", function(import, export, exportDefault) -- declare your module
    exportDefault "Hello!" -- declare default export value 
    export("welcome", "Welcome!") -- declare custom export value
end)

-- call your main import from triggers on MAP INITIALIZATION or anywhere
importWM("myMainModule") 
```

Result:
```
Hello!
Welcome!
Espresso!
Your cappuccino, sir!
```

## Advanced Usage

```lua
-- advanced export
WM("coffeeModule", function(import, export, exportDefault) -- declare your module
    exportDefault "Espresso!" -- declare default export value
    export { -- declare multiple custom export values
      "cappuccino" = "Your cappuccino, sir!",
      "macciato" = "One nonfat macchiato",
      "someFunction" = (function() return "something" end)
    }
end)

-- initialize modules before call and (or) without getting values
WM("myMainModule", {"helloModule","coffeeModule"}, function(import, export, exportDefault) 
    
end)

-- load all modules instantly
loadAllWMs()

```

ScorpioT1000 / 2019 
