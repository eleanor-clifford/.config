#!/usr/bin/env lua5.2
-- load the http socket module
http = require("socket.http")
-- load the json module
json = require("json")

api_url = "http://api.openweathermap.org/data/2.5/weather?"

-- http://openweathermap.org/help/city_list.txt , http://openweathermap.org/find
cityid = "2648300"

-- metric or imperial
cf = "metric"

-- get an open weather map api key: http://openweathermap.org/appid
apikey = ""

-- measure is °C if metric and °F if imperial
measure = "°" .. (cf == "metric" and "C" or "F")
wind_units = (cf == "metric" and "kph" or "mph")

-- Unicode weather symbols to use
icons = {
    ["01"] = "☀",--☀️☀️
    ["02"] = "🌤",
    ["03"] = "🌥",
    ["04"] = "☁",
    ["09"] = "🌧",
    ["10"] = "🌦",
    ["11"] = "🌩",
    ["13"] = "🌨",
    ["50"] = "🌫"
}

currenttime = os.date("!%Y%m%d%H%M%S")

file_exists = function(name)
    f = io.open(name, "r")
    if f ~= nil then
        f:close()
        return true
    else
        return false
    end
end

if file_exists("weather.json") then
    cache = io.open("weather.json", "r")
    data = json.decode(cache:read())
    cache:close()
    timepassed = os.difftime(currenttime, data.timestamp)
else
    timepassed = 6000
end

makecache = function(s)
    cache = io.open("weather.json", "w+")
    s.timestamp = currenttime
    save = json.encode(s)
    cache:write(save)
    cache:close()
end

if timepassed < 3600 then
    response = data
else
    weather = http.request(("%sid=%s&units=%s&APPID=%s"):format(api_url, cityid, cf, apikey))
    if weather then
        response = json.decode(weather)
        makecache(response)
    else
        response = data
    end
end

math.round = function(n)
    return math.floor(n + 0.5)
end

degrees_to_direction = function(d)
    val = math.floor(d / 22.5 + 0.5)
    directions = {
        [00] = "N",
        [01] = "NNE",
        [02] = "NE",
        [03] = "ENE",
        [04] = "E",
        [05] = "ESE",
        [06] = "SE",
        [07] = "SSE",
        [08] = "S",
        [09] = "SSW",
        [10] = "SW",
        [11] = "WSW",
        [12] = "W",
        [13] = "WNW",
        [14] = "NW",
        [15] = "NNW"
    }
    return directions[val % 16]
end

temp = response.main.temp
min = response.main.temp_min
max = response.main.temp_max
conditions = response.weather[1].description
icon2 = response.weather[1].id
icon = response.weather[1].icon:sub(1, 2)
humidity = response.main.humidity
wind = response.wind.speed
deg = degrees_to_direction(response.wind.deg)
sunrise = os.date("%H:%M %p", response.sys.sunrise)
sunset = os.date("%H:%M %p", response.sys.sunset)

conky_text =
    [[
  ${font Symbola:size=36}%s${voffset -10}${font size=10}${color5}             %s${font}${voffset 0}%s${color}${alignr} %s

High: ${color5}%s%s${color}        Low: ${color5}%s%s${color} ${alignr}Humidity: ${color5}%s%%${color}

${alignc}${font Symbola:size=20}🎏${font} ${alignc}${color5}%s${color} | ${color5}%s${color}
]]
io.write(
    (conky_text):format(
        icons[icon],
        math.round(temp),
        measure,
        conditions,
        math.round(max),
        measure,
        math.round(min),
        measure,
        humidity,
        math.round(wind),
        deg,
        sunrise,
        sunset
    )
)
