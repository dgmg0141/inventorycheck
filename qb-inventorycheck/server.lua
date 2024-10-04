local QBCore = exports['qb-core']:GetCoreObject()

-- 権限チェック関数
local function hasPermission(source)
    local Player = QBCore.Functions.GetPlayer(source)
    return Player.PlayerData.group == "admin"
end

-- プレイヤーのインベントリ内のアイテム情報を取得し表示する関数
local function showPlayerInventory(source, targetPlayer)
    local Player = QBCore.Functions.GetPlayer(targetPlayer)
    
    if Player then
        local inventory = Player.PlayerData.items
        local itemList = "インベントリ内のアイテム:\n"
        for _, item in pairs(inventory) do
            if item.amount and item.amount > 0 then
                itemList = itemList .. string.format("- %s: (%d)\n", item.label, item.amount)
            end
        end
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 255, 0},
            multiline = true,
            args = {"システム", itemList}
        })
    else
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            args = {"システム", "指定されたプレイヤーのインベントリ情報を取得できませんでした。"}
        })
    end
    
    -- デバッグ情報の出力
    --print("Inventory data type:", type(inventory))
    --print("Inventory data:")
    --print(json.encode(inventory, {indent = true}))
end

-- コマンドを登録して関数を呼び出せるようにする
QBCore.Commands.Add('checkinv', '指定したプレイヤーのインベントリを確認します', {{name = 'playerid/name', help = 'プレイヤーIDまたは名前'}}, false, function(source, args)
    if not hasPermission(source) then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            args = {"システム", "このコマンドを使用する権限がありません。"}
        })
        return
    end

    local targetPlayer
    if not args[1] then
        targetPlayer = source
    else
        local target = tonumber(args[1])
        if target then
            targetPlayer = target
        else
            local players = QBCore.Functions.GetPlayers()
            for _, v in ipairs(players) do
                local ply = QBCore.Functions.GetPlayer(v)
                if ply and (ply.PlayerData.charinfo.phone == args[1] or ply.PlayerData.charinfo.firstname .. " " .. ply.PlayerData.charinfo.lastname == args[1]) then
                    targetPlayer = ply.PlayerData.source
                    break
                end
            end
        end
    end

    if targetPlayer then
        showPlayerInventory(source, targetPlayer)
    else
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            args = {"システム", "指定されたプレイヤーが見つかりません。"}
        })
    end
end, 'admin')

-- プレイヤー検索の効率化
local function findPlayer(identifier)
    local players = QBCore.Functions.GetPlayers()
    for _, v in ipairs(players) do
        local ply = QBCore.Functions.GetPlayer(v)
        if ply and (ply.PlayerData.charinfo.phone == identifier or 
                    ply.PlayerData.charinfo.firstname .. " " .. ply.PlayerData.charinfo.lastname == identifier) then
            return ply.PlayerData.source
        end
    end
    return nil
end