Formatter = {}
Formatter.scales = {"K", "M", "B", "T", "P", "E", "Z", "Y"}

function Formatter.Format(number)
    local index = math.floor(math.log(math.abs(number), 1000))
    local prefix = Formatter.scales[index] 
    local formattedNumber 

    if prefix then
        formattedNumber = string.format("%".. "#" .. "." .. 1 .. "f",  number / 10 ^ (index * 3))
        if removeTrailingZeros then
            formattedNumber = string.gsub(formattedNumber, "%.?0*$", "")
        end
    else 
        prefix = ""
        formattedNumber = Formatter.formatExceptions(number)
    end

    return formattedNumber .. prefix
end

function Formatter.UnFormat(Prenumber)
    local prefix, number = Prenumber:sub(-1), Prenumber:sub(1, -2)

    if number == "∞" or Prenumber == "∞" then
        return math.huge
    end

    number = tonumber(number, 10)

    if not prefix then return Prenumber end

    local index = indexOf(Formatter.scales, prefix)
    if not index then return Prenumber end

    number = number * (math.pow(1000, index))

    return number 
end

hook.Add("DarkRPFinishedLoading", "moneyformat+_init", function (arguments)
    local function attachCurrency(str)
        local config = GAMEMODE.Config
        return config.currencyLeft and config.currency .. str or str .. config.currency
    end

    function DarkRP.formatMoney(number)
        return attachCurrency(Formatter.Format(number))
    end
end)

local function isNaN(arg)
    return arg ~= arg
end
local function isInf(arg)
   return arg == -math.huge or arg == math.huge
end
function indexOf(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return nil
end

function Formatter.formatExceptions(number)
    number = number or 0
    if isInf(number) then
        return "∞"
    elseif isNaN(number) then
        return "NaN"
    else
        return string.format("%g", number)
    end
end