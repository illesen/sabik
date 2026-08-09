script_name("{e6953e}FinkoVozka for Family {ffffff}by yargoff")
script_version("1.2b")
script_author('yargoff')

------------------------------------------- CONNECT LIBNARY ---------------------------------------
local ev = require('lib.samp.events')
local font_flag = require('moonloader').font_flag
local imgui = require('mimgui')
local encoding = require('encoding')
local faicons = require('fAwesome6')
encoding.default = 'CP1251'
local u8 = encoding.UTF8
---------------------------------------------------------------------------------------------------

local tag = '{c99732}[FinkoVozka Family]{ffffff}'
local base_color = 0xd67d1e

local function message(text)
    if not text or text == '' then
        return
    end
    sampAddChatMessage(':u1f69b: '..tag..' '..text, base_color)
end
local function test_message(text)
    if not text or text == '' then
        return
    end
    sampAddChatMessage(':u1f69b: {ff0000}[DEBUG MESSAGE] ' .. tag .. ' ' .. text, 0xff0000)
end

-------------------------------------------- JSON SETTINGS ---------------------------------------
function json(filePath)
    local filePath = getWorkingDirectory()..'\\config\\'..(filePath:find('(.+).json') and filePath or filePath..'.json')
    local class = {}
    if not doesDirectoryExist(getWorkingDirectory()..'\\config') then
        createDirectory(getWorkingDirectory()..'\\config')
    end
    
    function class:Save(tbl)
        if tbl then
            local F = io.open(filePath, 'w')
            F:write(encodeJson(tbl) or {})
            F:close()
            return true, 'ok'
        end
        return false, 'table = nil'
    end

    function class:Load(defaultTable)
        if not doesFileExist(filePath) then
            class:Save(defaultTable or {})
        end
        local F = io.open(filePath, 'r+')
        local TABLE = decodeJson(F:read() or {})
        F:close()
        for def_k, def_v in next, defaultTable do
            if TABLE[def_k] == nil then
                TABLE[def_k] = def_v
            end
        end
        return TABLE
    end

    return class
end

local name_file = 'FinkoVozkaFamily.json'
local settings = json(name_file):Load({
    render = false,
    second_window = false,          -- Окошко статистики mbiz
    FamFinka = {},
    min_money = 0,
    max_dist_render = 1200,
    autoTakeCar = false,
    autodelivery = false,           -- Автосдача финки
    autobias = false,               -- Автовзятие финки
    font = 'Arial',
    size_Text = 10,
    debugmessage_finka = false,
    version = '', checkversion = 0,
    total_metod = false,
})
local function save_settings()
    json(name_file):Save(settings)
end
settings.FamFinka = settings.FamFinka or {}
--------------------------------------------------------------------------------------------------
local update_log = {
    '1. Минорные изменения из-за обновления на АРЗ',
}

local coordfamzone = {
{1245.0756835938,2521.9340820313,10.820300102234,"1"},
{1377.6423339844,2558.0581054688,10.820300102234,"2"},
{1530.2253417969,2540.5412597656,10.820300102234,"3"},
{1639.9075927734,2546.1875,10.820300102234,"4"},
{1775.1242675781,2569.1574707031,10.820300102234,"5"},
{1904.3698730469,2568.2907714844,10.820300102234,"6"},
{1971.3125,2495.2446289063,11.178199768066,"7"},
{2106.4838867188,2513.3659667969,10.820300102234,"8"},
{2271.8493652344,2529.7958984375,10.820300102234,"9"},
{2367.0739746094,2548.3286132813,10.820300102234,"10"},
{2484.4758300781,2509.4750976563,21.880100250244,"11"},
{2593.3864746094,2480.0715332031,10.820300102234,"12"},
{1305.4190673828,2354.8278808594,10.820300102234,"13"},
{1409.4361572266,2343.1748046875,10.820300102234,"14"},
{1504.3748779297,2363.6315917969,10.820300102234,"15"},
{1676.8702392578,2358.7233886719,10.820300102234,"16"},
{1747.8605957031,2350.5095214844,10.828100204468,"17"},
{1888.0512695313,2395.5412597656,11.178199768066,"18"},
{2014.9621582031,2380.1115722656,10.820300102234,"19"},
{2177.2053222656,2379.6142578125,10.820300102234,"20"},
{2277.7419433594,2342.3488769531,10.820300102234,"21"},
{2364.416015625,2382.9560546875,10.820300102234,"22"},
{2517.7490234375,2334.6147460938,10.820300102234,"23"},
{2637.3259277344,2352.0290527344,10.820300102234,"24"},
{1306.310546875,2222.9750976563,11.023400306702,"25"},
{1365.8634033203,2223.091796875,11.023400306702,"26"},
{1480.2552490234,2213.4929199219,11.023400306702,"27"},
{1664.3426513672,2206.482421875,10.820300102234,"28"},
{1751.6616210938,2203.1511230469,10.820300102234,"29"},
{1937.7974853516,2307.3674316406,10.820300102234,"30"},
{2043.9991455078,2292.8840332031,10.820300102234,"31"},
{2162.3725585938,2231.2775878906,10.820300102234,"32"},
{2236.9599609375,2235.9892578125,10.820300102234,"33"},
{2348.4553222656,2261.7629394531,8.1478004455566,"34"},
{2517.3776855469,2265.0732421875,10.820300102234,"35"},
{2601.7788085938,2213.2136230469,10.820300102234,"36"},
{1313.3201904297,2085.3244628906,10.812700271606,"37"},
{1417.4935302734,2091.9184570313,11.016699790955,"38"},
{1480.8618164063,2110.0280761719,11.023400306702,"39"},
{1663.1033935547,2134.3303222656,10.820300102234,"40"},
{1770.0413818359,2105.4792480469,10.823499679565,"41"},
{1843.9016113281,2095.9645996094,10.820300102234,"42"},
{2042.1423339844,2122.7888183594,10.820300102234,"43"},
{2108.1848144531,2149.5966796875,10.820300102234,"44"},
{2252.3701171875,2161.8852539063,10.820300102234,"45"},
{2369.4704589844,2120.921875,10.840000152588,"46"},
{2557.61328125,2101.4113769531,10.815400123596,"47"},
{2601.9670410156,2091.9614257813,10.821499824524,"48"},
{1329.1450195313,1958.2725830078,10.820300102234,"49"},
{1392.7108154297,2006.2274169922,10.820300102234,"50"},
{1562.0900878906,2002.5571289063,10.820300102234,"51"},
{1685.8216552734,2004.8166503906,10.820300102234,"52"},
{1752.1873779297,2026.8989257813,10.820300102234,"53"},
{1922.1884765625,2020.9283447266,10.8125,"54"},
{2030.7192382813,2046.1719970703,11.057900428772,"55"},
{2169.1945800781,1970.6434326172,10.820300102234,"56"},
{2218.4987792969,2007.9858398438,10.820300102234,"57"},
{2408.4133300781,2016.1817626953,10.820300102234,"58"},
{2529.2534179688,2024.2392578125,11.182499885559,"59"},
{2665.9111328125,2012.4017333984,10.828100204468,"60"},
{1342.7017822266,1885.0229492188,10.820300102234,"61"},
{1442.5372314453,1888.0239257813,10.820300102234,"62"},
{1508.3708496094,1882.8322753906,10.820300102234,"63"},
{1674.5596923828,1827.0759277344,10.820300102234,"64"},
{1743.4559326172,1852.9748535156,10.820300102234,"65"},
{1933.6622314453,1815.3081054688,12.714400291443,"66"},
{2017.4661865234,1899.4197998047,12.328900337219,"67"},
{2162.7263183594,1904.8946533203,10.8125,"68"},
{2281.6350097656,1868.4516601563,10.820300102234,"69"},
{2354.1635742188,1882.8624267578,10.671899795532,"70"},
{2542.3120117188,1847.2442626953,11.023400306702,"71"},
{2638.5900878906,1841.4537353516,11.023400306702,"72"},
{1308.0769042969,1671.5762939453,10.820300102234,"73"},
{1367.5679931641,1687.7359619141,10.820300102234,"74"},
{1563.3303222656,1680.4539794922,10.820300102234,"75"},
{1681.0587158203,1722.6944580078,10.820300102234,"76"},
{1728.9741210938,1724.0864257813,10.817700386047,"77"},
{1899.6354980469,1726.0500488281,10.820300102234,"78"},
{2046.8638916016,1731.6120605469,10.820300102234,"79"},
{2177.0681152344,1718.3779296875,11.046899795532,"80"},
{2307.9201660156,1647.8637695313,11.046899795532,"81"},
{2342.1613769531,1703.7764892578,10.820300102234,"82"},
{2470.1550292969,1722.8751220703,10.820300102234,"83"},
{2634.6145019531,1716.7078857422,11.023400306702,"84"},
{1303.9273681641,1606.5357666016,10.820300102234,"85"},
{1367.7915039063,1579.7379150391,10.820300102234,"86"},
{1503.580078125,1575.1273193359,10.820300102234,"87"},
{1672.4946289063,1566.4660644531,10.770400047302,"88"},
{1734.6130371094,1561.921875,10.820300102234,"89"},
{1893.1798095703,1596.4073486328,10.539999961853,"90"},
{2037.33984375,1600.7545166016,10.820300102234,"91"},
{2125.4631347656,1573.1697998047,10.820300102234,"92"},
{2298.0554199219,1570.1790771484,11.046899795532,"93"},
{2371.81640625,1602.7303466797,10.820300102234,"94"},
{2499.5319824219,1622.8746337891,10.820300102234,"95"},
{2594.7348632813,1618.5783691406,10.820300102234,"96"},
{1278.9794921875,1503.9267578125,10.820300102234,"97"},
{1367.4929199219,1441.5504150391,10.820300102234,"98"},
{1502.8361816406,1447.7661132813,10.834500312805,"99"},
{1598.1248779297,1450.4155273438,10.828100204468,"100"},
{1725.6114501953,1442.6324462891,10.802800178528,"101"},
{1907.3165283203,1444.6495361328,10.820300102234,"102"},
{1968.7984619141,1401.6138916016,9.2578001022339,"103"},
{2178.9772949219,1450.9591064453,10.820300102234,"104"},
{2233.1694335938,1448.7192382813,11.054699897766,"105"},
{2377.0412597656,1430.5694580078,10.820300102234,"106"},
{2453.6455078125,1419.0955810547,10.906299591064,"107"},
{2622.0524902344,1459.3699951172,10.830300331116,"108"},
{1290.8389892578,1257.9187011719,10.820300102234,"109"},
{1367.5250244141,1292.6046142578,10.820300102234,"110"},
{1502.9479980469,1311.8677978516,10.861100196838,"111"},
{1670.1267089844,1327.2960205078,10.754599571228,"112"},
{1741.2958984375,1284.0961914063,10.836899757385,"113"},
{1867.4093017578,1284.5666503906,10.820300102234,"114"},
{1975.2985839844,1264.1256103516,10.820300102234,"115"},
{2177.0881347656,1292.0786132813,10.820300102234,"116"},
{2238.3557128906,1293.4400634766,10.820300102234,"117"},
{2418.2495117188,1299.7308349609,10.820300102234,"118"},
{2492.4313964844,1324.771484375,10.820300102234,"119"},
{2610.7712402344,1292.6728515625,10.820300102234,"120"},
{1321.9283447266,1153.0766601563,10.820300102234,"121"},
{1377.576171875,1151.1947021484,10.820300102234,"122"},
{1541.9670410156,1120.6960449219,10.820300102234,"123"},
{1672.7612304688,1177.8402099609,10.820300102234,"124"},
{1752.515625,1145.7247314453,10.820300102234,"125"},
{1896.6508789063,1164.8088378906,10.820300102234,"126"},
{2007.8129882813,1173.3646240234,10.820300102234,"127"},
{2114.001953125,1139.8425292969,10.820300102234,"128"},
{2294.390625,1181.3239746094,10.820300102234,"129"},
{2361.6262207031,1166.3442382813,10.820300102234,"130"},
{2516.8037109375,1179.4337158203,10.822199821472,"131"},
{2597.9477539063,1170.8250732422,10.820300102234,"132"},
{1302.7882080078,1068.4019775391,10.820300102234,"133"},
{1429.8806152344,1044.9764404297,10.812999725342,"134"},
{1557.8602294922,1007.290222168,10.8125,"135"},
{1635.0251464844,1038.6553955078,10.820300102234,"136"},
{1732.0224609375,1049.0081787109,10.820300102234,"137"},
{1858.4586181641,1035.2294921875,10.820300102234,"138"},
{1991.0180664063,987.59619140625,10.812700271606,"139"},
{2187.6662597656,1003.1644287109,10.820300102234,"140"},
{2299.1203613281,1050.9929199219,10.820300102234,"141"},
{2386.8171386719,1041.3935546875,10.820300102234,"142"},
{2461.2087402344,1004.2971801758,10.820300102234,"143"},
{2592.4650878906,1082.7576904297,10.820300102234,"144"},
{1315.1932373047,914.74407958984,9.8990001678467,"145"},
{1405.9516601563,935.28430175781,10.820300102234,"146"},
{1540.9268798828,922.62548828125,10.820300102234,"147"},
{1672.8619384766,915.90570068359,10.717599868774,"148"},
{1749.5225830078,913.5908203125,10.712100028992,"149"},
{1882.4613037109,921.20330810547,10.820300102234,"150"},
{2012.3764648438,921.1904296875,10.820300102234,"151"},
{2176.9326171875,924.87652587891,11.099499702454,"152"},
{2267.7587890625,938.92437744141,10.822099685669,"153"},
{2391.5363769531,958.33392333984,10.820300102234,"154"},
{2513.5170898438,962.17291259766,10.820300102234,"155"},
{2688.3374023438,909.18029785156,10.691200256348,"156"}
}
---------------------------------------- LOCAL SETTINGS ------------------------------------------
local render_fin = imgui.new.bool(settings.render)
local min_money = imgui.new.int(settings.min_money)
local max_dist_render = imgui.new.int(settings.max_dist_render)
local autodelivery = imgui.new.bool(settings.autodelivery)
local autobias = imgui.new.bool(settings.autobias)
local debugmessage_finka = imgui.new.bool(settings.debugmessage_finka)
local total_metod = imgui.new.bool(settings.total_metod)
local autoTakeCar = imgui.new.bool(settings.autoTakeCar)
local size_text = imgui.new.int(settings.size_Text)
local font = renderCreateFont(settings.font, settings.size_Text, font_flag.BORDER)  -- шрифт

local renderWindow = imgui.new.bool(false)
local secondWindow = imgui.new.bool(settings.second_window)
--------------------------------------------------------------------------------------------------
imgui.OnInitialize(function()
    imgui.GetIO().IniFilename = nil
    theme()

    local config = imgui.ImFontConfig()
    config.MergeMode = true
    config.PixelSnapH = true
    iconRanges = imgui.new.ImWchar[3](faicons.min_range, faicons.max_range, 0)
    imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(faicons.get_font_data_base85('solid'), 14, config, iconRanges)
end)

local resX, resY = getScreenResolution()
local currentFirstX, currentFirstY = resX / 2, resY / 2 -- Позиция первого окна
-- Начальное смещение второго окна относительно первого
local relativeOffsetX2, relativeOffsetY2 = -940, -65
local targetX2 = currentFirstX + relativeOffsetX2
local targetY2 = currentFirstY + relativeOffsetY2

local newFrame = imgui.OnFrame(
    function() return renderWindow[0] end,
    function(player)
        local sizeX, sizeY = 325, 315
        imgui.SetNextWindowPos(imgui.ImVec2(currentFirstX, currentFirstY), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(sizeX, sizeY), imgui.Cond.FirstUseEver)
        if imgui.Begin(faicons('truck')..' FinkoVozka for Family '..faicons('truck'), renderWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoResize) then
            if imgui.BeginTabBar('Tabs') then -- задаём начало вкладок
                if imgui.BeginTabItem(faicons('house')..u8' Основная вкладка') then -- первая вкладка
                
                    if settings.checkversion == 0 then
                        imgui.OpenPopup('Change Log##updatemessage')
                    end
                    if imgui.BeginPopupModal(u8"Change Log##updatemessage", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar) then
                        --imgui.SetWindowSize(imgui.ImVec2(150, 200))
                        imgui.Text(u8('Нововведения / Изменения в скрипте. ver: ' .. thisScript().version))
                        for i, v in pairs(update_log) do
                            imgui.Text(u8(v))
                        end
                        if imgui.Button(u8'Закрыть') then
                            settings.checkversion = 1
                            save_settings()
                            imgui.CloseCurrentPopup()
                        end
                        imgui.EndPopup()
                    end
                
                    if imgui.Button(u8'Перезагрузить скрипт') then
                        thisScript():reload()
                    end
                    if imgui.Checkbox(faicons('share')..u8' Рендер финки', render_fin) then
                        settings.render = render_fin[0]
                        save_settings()
                    end
                    if imgui.Checkbox(faicons('truck_container')..u8' Автовзятие машины', autoTakeCar) then
                        settings.autoTakeCar = autoTakeCar[0]
                        save_settings()
                    end
                    if imgui.Checkbox(faicons('book')..u8' Статистика', secondWindow) then
                        settings.second_window = secondWindow[0]
                        save_settings()
                    end
                    imgui.Separator()
                    if imgui.Checkbox(faicons('hand_fist')..u8 ' Автовзятие финки', autobias) then
                        settings.autobias = autobias[0]
                        save_settings()
                    end
                    if imgui.Checkbox(faicons('hand_holding')..u8' Автосдача финки', autodelivery) then
                        settings.autodelivery = autodelivery[0]
                        save_settings()
                    end
                    imgui.Text(faicons('globe_stand')..u8' Максимальное расстояние рендера:')
                    if imgui.SliderInt(u8'##Максимальное расстояние рендера', max_dist_render, 0, 3600) then
                        settings.max_dist_render = max_dist_render[0]
                        save_settings()
                    end
                    imgui.Text(faicons('money_bill')..u8' Минимальное кол-во денег для рендера:')
                    if imgui.SliderInt(u8'##Минимальное кол-во денег для рендера', min_money, 0, 5000000) then
                        settings.min_money = min_money[0]
                        save_settings()
                    end
                    imgui.EndTabItem() -- конец вкладки
                end
                if imgui.BeginTabItem(faicons('eye')..u8' Визуал') then -- вторая вкладка
                    imgui.PushItemWidth(150)
                    local font = {
                        'Arial', 'Impact', 'Segoe Print', 'Times New Roman', 'OpenGostA'
                    }
                    imgui.CenterText('Шрифт текста у рендера')
                    imgui.Text(u8('Сейчас выбран: '..settings.font))
                    for _, v in pairs(font) do

                        if imgui.Button(u8(v)) then
                            settings.font = v
                            save_settings()

                            thisScript():reload()
                        end
                        
                    end
                    imgui.Separator()
                    if imgui.SliderInt(u8'Размер шрифта [По умол. - 10]', size_text, 0, 20) then
                        settings.size_Text = size_text[0]
                        save_settings()
                    end
                    if imgui.Button(u8'Обновить размер текста') then
                        thisScript():reload()
                    end
                    imgui.Separator()
                    imgui.PopItemWidth()
                    imgui.EndTabItem() -- конец вкладки
                end
                if imgui.BeginTabItem(faicons('gears')..u8' Настройки') then -- вторая вкладка
                    if imgui.Checkbox(u8'Отладочные сообщения', debugmessage_finka) then
                        settings.debugmessage_finka = debugmessage_finka[0]
                        save_settings()
                    end
                    if imgui.Checkbox(u8'Закрывать все диалоги во время обновления', total_metod) then
                        settings.total_metod = total_metod[0]
                        save_settings()
                    end
                    imgui.EndTabItem() -- конец вкладки
                end
                imgui.EndTabBar() -- конец всех вкладок
            end
            imgui.End()
        end
    end
)
local newFrame = imgui.OnFrame(
    function() return secondWindow[0] end,
    function(player)
        local size, res = imgui.ImVec2(290, 250), imgui.ImVec2(getScreenResolution())
        imgui.SetNextWindowSize(size, imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2(targetX2, targetY2), imgui.Cond.FirstUseEver)
        player.HideCursor = true
        if imgui.Begin(u8'Список территорий', secondWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then

            -- Заголовок таблицы
            -- Ширина колонок
            local w = {
                first = 115,
                second = 75,
                third = 85,
            }
            imgui.Columns(3)
            imgui.CenterColumnText(faicons('briefcase_blank') .. (u8' ID территории')) imgui.SetColumnWidth(-1, w.first)
            imgui.NextColumn()

            imgui.CenterColumnText(faicons('id_badge') .. (u8' Монеты')) imgui.SetColumnWidth(-1, w.second)
            imgui.NextColumn()

            imgui.CenterColumnText(faicons('badge_dollar')) imgui.SetColumnWidth(-1, w.third)
            imgui.NextColumn()

            imgui.Columns(1)
            imgui.Separator() -- Конец таблицы №1

            -- Отображение данных бизнесов
            if not settings.FamFinka or #settings.FamFinka == 0 then
                imgui.TextWrapped(u8'Нет данных из таблицы settings.FamFinka, подгрузите информацию')
            else
                for i, infoBizMafia in ipairs(settings.FamFinka) do
                    imgui.Columns(3)

                    -- ID территории
                    imgui.CenterColumnText(u8(tostring(infoBizMafia.id)))
                    if imgui.IsItemClicked() then
                        sampSendChat('/findfamzone ' .. infoBizMafia.id)
                    end
                    imgui.SetColumnWidth(-1, w.first)

                    imgui.NextColumn() -- Монет на территории
                    imgui.CenterColumnText(tostring(infoBizMafia.monety) .. u8(' шт.')) 
                    imgui.SetColumnWidth(-1, w.second)

                    imgui.NextColumn() -- Деньги
                    imgui.CenterColumnText(formatNumberWithDots(infoBizMafia.cash))
                    imgui.SetColumnWidth(-1, w.third)

                    imgui.Columns(1)
                    imgui.Separator()
                end
            end

            imgui.End()
        end
    end)
function imgui.CenterColumnText(text)
    imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
    imgui.Text(text)
end
function imgui.CenterText(text)
    imgui.SetCursorPosX(imgui.GetWindowWidth()/2-imgui.CalcTextSize(u8(text)).x/2)
    imgui.Text(u8(text))
end

function main()
    while not isSampAvailable() do wait(0) end

    if settings.version ~= thisScript().version then
        settings.version = thisScript().version
        settings.checkversion = 0
        save_settings()
    end

    message('Скрипт загружен!')

    sampRegisterChatCommand('famfinka', function()
        renderWindow[0] = not renderWindow[0]
    end)

    buildCoordCache()
    while true do
        wait(0)

        if settings.render then
            drawFamFinkaOnScreen()
        end

    end
end

coordById = {}

function buildCoordCache()
    coordById = {}

    for _, v in ipairs(coordfamzone) do
        coordById[tonumber(v[4])] = {
            x = v[1],
            y = v[2],
            z = v[3]
        }
    end
end

local function isInFOV(screenX, screenY, margin) -- РЕНДЕР БИЗНЕСОВ ПО FOV
    margin = margin or 0.25 -- 0.25 = 25% экрана от центра

    local sw, sh = getScreenResolution()

    local cx = sw / 2
    local cy = sh / 2

    local dx = math.abs(screenX - cx) / sw
    local dy = math.abs(screenY - cy) / sh

    return dx < margin and dy < margin
end

function drawFamFinkaOnScreen()
    if not settings.render then return end

    local px, py, pz = getCharCoordinates(PLAYER_PED)
    if not px then return end

    local minMoney = settings.min_money or 0
    local maxDist = settings.max_dist_render or 200
    local maxDistSq = maxDist * maxDist

    for _, terra in ipairs(settings.FamFinka or {}) do

        local money = terra.cash

        if money >= minMoney then
            
            local coord = coordById[tonumber(terra.id)]
            if coord then
                
                local dx = coord.x - px
                local dy = coord.y - py
                local dz = coord.z - pz

                local distSq = dx*dx + dy*dy + dz*dz

                if distSq <= maxDistSq then

                    local ok, sx, sy = convert3DCoordsToScreenEx(coord.x, coord.y, coord.z, true, true)

                    if ok then

                        if not isInFOV(sx, sy, 0.45) then
                            goto continue
                        end

                        local dist = math.sqrt(distSq)

                        renderFontDrawTextAlign(
                            font,
                            ('[TERRA №{ff0000}%s{ffffff}]'):format(terra.id),
                            sx, sy,
                            0xFFFFFFFF,
                            2
                        )

                        renderFontDrawTextAlign(
                            font,
                            string.format('{e6b24c}%.0f м {ffffff}| {20E10E}%s', dist, formatNumberWithDots(money)),
                            sx, sy + 20,
                            0xFFFFFFFF,
                            2
                        )
                    end
                end
            end
        end

        ::continue::
    end
end

local fam_processing = false
local fam_session = 0
local fam_cache = ""
local function getNextIndex(text)
    local i = 0
    for line in text:gmatch("[^\r\n]+") do
        if line:find("Следующая страница", 1, true) then
            return i
        end
        i = i + 1
    end
    return -1
end
function ev.onShowDialog(id, st, tit, b1, b2, text)
    if tit:match('{BFBBBA}Сбор ресурсов') then
        if settings.autobias then
            sampSendDialogResponse(id, 1, 1, nil)
            return false
        end
    end

    if tit:match('{BFBBBA}Склад / паркинг') then
        if settings.autodelivery then
            sampSendDialogResponse(id, 1, 1, '')
            return false
        end
    end

    if tit:match('{BFBBBA}Куда установить метку?') then
        if fam_processing then
            fam_cache = text
            return false
        end

        fam_processing = true
        fam_session = fam_session + 1

        local mySession = fam_session
        settings.FamFinka = {}

        lua_thread.create(function()

            local function parse(t)
                for line in t:gmatch("[^\r\n]+") do
                    local id_terra, monety, cash = line:match("{.*}Территория №(%d+)%s+{.*}(%d+)шт%s+{.*}:CASH:([%d%.]+)")

                    local cashnotdots = 0
                    if cash then
                        cashnotdots = tonumber((cash:gsub("%.", ""))) or 0
                    end

                    if id_terra then
                        if settings.debugmessage_finka then
                            test_message(
                                'ID Территории: ' .. id_terra ..
                                ' | Монет: ' .. monety ..
                                ' | Денег :CASH: ' .. formatNumberWithDots(cashnotdots)
                            )
                        end

                        table.insert(settings.FamFinka, {
                            id = tonumber(id_terra),
                            monety = tonumber(monety) or 0,
                            cash = cashnotdots,
                        })
                    end
                end
            end

            local function hasNext(t)
                return t:find("Следующая страница", 1, true)
            end

            local function clickNext(t)
                local idx = getNextIndex(t)
                if idx ~= -1 then
                    sampSendDialogResponse(id, 1, idx, "")
                    return true
                end
                return false
            end

            parse(text)
            fam_cache = text

            while true do
                wait(30)

                if mySession ~= fam_session then return end

                if not hasNext(fam_cache) then
                    break
                end

                if not clickNext(fam_cache) then
                    break
                end

                wait(100)

                local newText = fam_cache

                if newText == "" or newText == text then
                    break
                end

                text = newText
                parse(text)
            end

            save_settings()
            fam_processing = false
        end)

        return false
    end

    if tit:match('{BFBBBA}Выберите тип автопарка') then
        if settings.autoTakeCar then
            sampSendDialogResponse(id, 1, 1, '')
            sampCloseCurrentDialogWithButton(0)
            return false
        end
    end

    if tit:match('{BFBBBA}Инкассаторские грузовики') then
        if settings.autoTakeCar then

            local index, line = sampGetDialogLineByText(text, "%{31B404%}%[%d+%] Ford Transit	%{31B404%}%[ в наличии %]", false, st)

            if index ~= -1 then
                message('Беру свободную машину! Удачной перевозки финки!')
                sampSendDialogResponse(id, 1, index, "")
                sampCloseCurrentDialogWithButton(0)
            else
                message('Свободной машины нету! Попробуйте попозже...')
                sampCloseCurrentDialogWithButton(0)
            end
            return false
        end
    end

end

function formatNumberWithDots(num) -- чтобы были точки в числах
    local formatted = tostring(math.floor(num))
    local result = ""
    local counter = 0

    -- Проходим по символам справа налево
    for i = #formatted, 1, -1 do
        counter = counter + 1
        result = formatted:sub(i, i) .. result

        -- Добавляем точку каждые 3 цифры (кроме самой левой группы)
        if counter == 3 and i > 1 then
            result = "." .. result
            counter = 0
        end
    end

    return result
end

function renderFontDrawTextAlign(font, text, x, y, color, align) -- Центрование 3D текст
    if not align or align == 1 then -- слева
        renderFontDrawText(font, text, x, y, color)
    end
    if align == 2 then -- по центру
        renderFontDrawText(font, text, x - renderGetFontDrawTextLength(font, text) / 2, y, color)
    end
    if align == 3 then -- справа
        renderFontDrawText(font, text, x - renderGetFontDrawTextLength(font, text), y, color)
    end
end

addEventHandler('onReceivePacket', function (id, bs)
    if id == 220 then
        raknetBitStreamIgnoreBits(bs, 8)
        if (raknetBitStreamReadInt8(bs) == 17) then
            raknetBitStreamIgnoreBits(bs, 32)
            local length = raknetBitStreamReadInt16(bs)
            local encoded = raknetBitStreamReadInt8(bs)
            local str = (encoded ~= 0) and raknetBitStreamDecodeString(bs, length + encoded) or raknetBitStreamReadString(bs, length)

            if settings.autodelivery and str:match('interactionSidebar",{"title": "Склад / паркинг"') then
                honk()
            end

            if settings.autobias and str:match('interactionSidebar",{"title": "Забрать ресурсы"') then
                honk()
            end

            if settings.autoTakeCar and str:match('interactionSidebar",{"title": "Семейный автопарк"') then
                local data = samp_create_sync_data('player')
                data.keysData = data.keysData + 1024
                data.send()
            end

        end
    end
end)

function honk()
    if not isCharInAnyCar(PLAYER_PED) then return end
    local data = allocateMemory(67)
    sampStorePlayerIncarData(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)), data)
    setStructElement(data, 6, 2, 2, true)
    sampSendIncarData(data)
    freeMemory(data)
end

function sampGetDialogLineByText(text, search, plain, st)
    plain = not (plain == false)
    local i = st == 5 and -1 or 0 -- фикс заголовка

    for line in text:gmatch('[^\r\n]+') do
        if line:find(search, 1, plain) then
            return i, line -- возвращаем индекс и саму строку
        end
        i = i + 1
    end

    return -1, nil
end

function samp_create_sync_data(sync_type, copy_from_player)
    local ffi = require 'ffi'
    local sampfuncs = require 'sampfuncs'
    -- from SAMP.Lua
    local raknet = require 'samp.raknet'
    require 'samp.synchronization'

    copy_from_player = copy_from_player or true
    local sync_traits = {
        player = {'PlayerSyncData', raknet.PACKET.PLAYER_SYNC, sampStorePlayerOnfootData},
        vehicle = {'VehicleSyncData', raknet.PACKET.VEHICLE_SYNC, sampStorePlayerIncarData},
        passenger = {'PassengerSyncData', raknet.PACKET.PASSENGER_SYNC, sampStorePlayerPassengerData},
        aim = {'AimSyncData', raknet.PACKET.AIM_SYNC, sampStorePlayerAimData},
        trailer = {'TrailerSyncData', raknet.PACKET.TRAILER_SYNC, sampStorePlayerTrailerData},
        unoccupied = {'UnoccupiedSyncData', raknet.PACKET.UNOCCUPIED_SYNC, nil},
        bullet = {'BulletSyncData', raknet.PACKET.BULLET_SYNC, nil},
        spectator = {'SpectatorSyncData', raknet.PACKET.SPECTATOR_SYNC, nil}
    }
    local sync_info = sync_traits[sync_type]
    local data_type = 'struct ' .. sync_info[1]
    local data = ffi.new(data_type, {})
    local raw_data_ptr = tonumber(ffi.cast('uintptr_t', ffi.new(data_type .. '*', data)))
    -- copy player's sync data to the allocated memory
    if copy_from_player then
        local copy_func = sync_info[3]
        if copy_func then
            local _, player_id
            if copy_from_player == true then
                _, player_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
            else
                player_id = tonumber(copy_from_player)
            end
            copy_func(player_id, raw_data_ptr)
        end
    end
    -- function to send packet
    local func_send = function()
        local bs = raknetNewBitStream()
        raknetBitStreamWriteInt8(bs, sync_info[2])
        raknetBitStreamWriteBuffer(bs, raw_data_ptr, ffi.sizeof(data))
        raknetSendBitStreamEx(bs, sampfuncs.HIGH_PRIORITY, sampfuncs.UNRELIABLE_SEQUENCED, 1)
        raknetDeleteBitStream(bs)
    end
    -- metatable to access sync data and 'send' function
    local mt = {
        __index = function(t, index)
            return data[index]
        end,
        __newindex = function(t, index, value)
            data[index] = value
        end
    }
    return setmetatable({send = func_send}, mt)
end

function theme() -- Стиль mimgui
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    local ImVec2 = imgui.ImVec2

    style.WindowPadding = imgui.ImVec2(8, 8)
    style.WindowRounding = 6
    style.ChildRounding = 5
    style.FramePadding = imgui.ImVec2(5, 3)
    style.FrameRounding = 3.0
    style.ItemSpacing = imgui.ImVec2(5, 4)
    style.ItemInnerSpacing = imgui.ImVec2(4, 4)
    style.IndentSpacing = 21
    style.ScrollbarSize = 10.0
    style.ScrollbarRounding = 13
    style.GrabMinSize = 8
    style.GrabRounding = 1
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)

    colors[clr.Text]                   = ImVec4(0.95, 0.96, 0.98, 1.00);
    colors[clr.TextDisabled]           = ImVec4(0.29, 0.29, 0.29, 1.00);
    colors[clr.WindowBg]               = ImVec4(0.14, 0.14, 0.14, 1.00);
    colors[clr.ChildBg]                = ImVec4(0.12, 0.12, 0.12, 1.00);
    colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94);
    colors[clr.Border]                 = ImVec4(0.14, 0.14, 0.14, 1.00);
    colors[clr.BorderShadow]           = ImVec4(1.00, 1.00, 1.00, 0.10);
    colors[clr.FrameBg]                = ImVec4(0.22, 0.22, 0.22, 1.00);
    colors[clr.FrameBgHovered]         = ImVec4(0.18, 0.18, 0.18, 1.00);
    colors[clr.FrameBgActive]          = ImVec4(0.09, 0.12, 0.14, 1.00);
    colors[clr.TitleBg]                = ImVec4(0.14, 0.14, 0.14, 0.81);
    colors[clr.TitleBgActive]          = ImVec4(0.14, 0.14, 0.14, 1.00);
    colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51);
    colors[clr.MenuBarBg]              = ImVec4(0.20, 0.20, 0.20, 1.00);
    colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.39);
    colors[clr.ScrollbarGrab]          = ImVec4(0.36, 0.36, 0.36, 1.00);
    colors[clr.ScrollbarGrabHovered]   = ImVec4(0.18, 0.22, 0.25, 1.00);
    colors[clr.ScrollbarGrabActive]    = ImVec4(0.24, 0.24, 0.24, 1.00);
    colors[clr.CheckMark]              = ImVec4(1.00, 0.28, 0.28, 1.00);
    colors[clr.SliderGrab]             = ImVec4(1.00, 0.28, 0.28, 1.00);
    colors[clr.SliderGrabActive]       = ImVec4(1.00, 0.28, 0.28, 1.00);
    colors[clr.Button]                 = ImVec4(0.76, 0.16, 0.16, 1.00);
    colors[clr.ButtonHovered]          = ImVec4(1.00, 0.39, 0.39, 1.00);
    colors[clr.ButtonActive]           = ImVec4(1.00, 0.21, 0.21, 1.00);
    colors[clr.Header]                 = ImVec4(1.00, 0.28, 0.28, 1.00);
    colors[clr.HeaderHovered]          = ImVec4(1.00, 0.39, 0.39, 1.00);
    colors[clr.HeaderActive]           = ImVec4(1.00, 0.21, 0.21, 1.00);
    colors[clr.ResizeGrip]             = ImVec4(1.00, 0.28, 0.28, 1.00);
    colors[clr.ResizeGripHovered]      = ImVec4(1.00, 0.39, 0.39, 1.00);
    colors[clr.ResizeGripActive]       = ImVec4(1.00, 0.19, 0.19, 1.00);
    colors[clr.Tab]                    = ImVec4(0.09, 0.09, 0.09, 1.00);
    colors[clr.TabHovered]             = ImVec4(0.58, 0.23, 0.23, 1.00);
    colors[clr.TabActive]              = ImVec4(0.76, 0.16, 0.16, 1.00);
    colors[clr.Button]                 = ImVec4(0.40, 0.39, 0.38, 0.16);
    colors[clr.ButtonHovered]          = ImVec4(0.40, 0.39, 0.38, 0.39);
    colors[clr.ButtonActive]           = ImVec4(0.40, 0.39, 0.38, 1.00);
    colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00);
    colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00);
    colors[clr.PlotHistogram]          = ImVec4(1.00, 0.21, 0.21, 1.00);
    colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.18, 0.18, 1.00);
    colors[clr.TextSelectedBg]         = ImVec4(1.00, 0.32, 0.32, 1.00);
    colors[clr.ModalWindowDimBg]   = ImVec4(0.26, 0.26, 0.26, 0.60);
end