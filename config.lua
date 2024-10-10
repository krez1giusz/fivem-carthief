DL = {
    CarPositions = {
        {x = -1200.7843017578, y = -3040.0458984375, z = 13.944437980652, h = 136.3896484375},
        {x = -1118.2739257812, y = -3087.6811523438, z = 13.944437980652, h = 62.145832061768},
        {x = -1115.6492919922, y = -3273.4809570312, z = 13.944437980652, h = 356.85409545898},
        {x = -1437.6137695312, y = -3193.9147949219, z = 13.944437980652, h = 245.99998474121},
    },
    CarList = {"schafter3", "zentorno", "kuruma", "kuruma2"},
    MaxActiveJobs = 2, -- maksymalna liczba zleceń w jednym momencie,
    ResetTime = 15000, -- 15 * (60 * 1000),
    Alert = {
        JobName = 'police', 
        minPD = 0, -- if 0 min pd disabled, if >0 pd enabled and cant start car thief
        LastImpulseTime = 10000, -- 10* (60 * 1000) -- Czas ostatniego impulsu 
        PDStop = 10000, -- Czas po jakim GPS znika dla lspd
    },
    DropOff = { x = -1347.1958007812, y = -3169.5029296875, z = 13.944821357727, radius = 45.0},
    Reward = {
        Money = true,
        MoneyAmount = math.random(5000,6000),
        Items = true,
        Item = {
            Min = 1,
            Max = 3,
        },
        ItemPool = {
            "bread", "water", "alcohol", "cigarettes",
        }
    },
    Colors = {
        { id = 0, name = "Czarny"},
        { id = 111, name = "Biały"},
        { id = 4, name = "Srebrny"},
        { id = 13, name = "Szary"},
        { id = 27, name = "Czerwony"},
        { id = 88, name = "Żółty"},
        { id = 92, name = "Limonkowy"},
        { id = 50, name = "Zielony"},
        { id = 68, name = "Turkosowy"},
        { id = 64, name = "Niebieski"},
        { id = 142, name = "Fioletowy"},
    }
    
}