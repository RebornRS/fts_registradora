local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

ftsC = {}
Tunnel.bindInterface("fts_registradora", ftsC)

local roubando = false
local segundos = 0

tempos = {}
CreateThread(function()
    while true do
        Wait(1000)
        for k, v in pairs(tempos) do 
            if v > 0 then 
                tempos[k] = v - 1 
            end 
        end
    end
end)

function ftsC.CheckRoubo(id,x,y,z,h)
    local source = source
    local user_id = vRP.getUserId(source)
    local policiais = vRP.getUsersByPermission("policia.permissao")
    local Notificar = math.random(30,100)
    if user_id then
        if #policiais >= -1 then  
            if Proibido() then
                if roubando == false then
                    if tempos[id] == 0 or not tempos[id] then
                        tempos[id] = math.random(120,200)
                        segundos = 10
                        roubando = true
                        if Notificar >= 70 then
                            TriggerClientEvent("Notify", source, "importante","Roube o máximo que puder, soubemos que policiais foram notificados!!!.")
                        end
                        AlertarPMs(policiais,x,y,z)
                        Roubo(segundos,h)
                        return true
                    else
                        TriggerClientEvent("Notify",source,"importante","Esta caixa registradora já foi roubada, aguarde " ..tempos[id].. " segundos para rouba-lo novamente.")
                    end
                else
                    TriggerClientEvent("Notify",source,"importante","Você já tem um roubo em andamento!")
                end
            else
                TriggerClientEvent("Notify",source,"negado","Você tem uma profissão legal, não faça isto!")
            end
        else
            TriggerClientEvent("Notify",source,"negado","Não tem policiais suficientes em PTR, minimo 2")
        end
    end
end

function AlertarPMs(pms,x,y,z)
    for k,v in pairs(pms) do 
        local PoliciaNotify = vRP.getUserSource(v) 
        TriggerClientEvent("fts:AdicionarCDS",PoliciaNotify,x,y,z)
        TriggerClientEvent("Notify",PoliciaNotify,"importante","Houve um roubo em uma loja e o alarme foi ativado, vá até o local!")
    end
end

function Roubo(segundos,h)

    local source = source
    local user_id = vRP.getUserId(source)

    SetEntityHeading(source,h)
    vRPclient.playAnim(source, false,{{"mp_take_money_mg", "stand_cash_in_bag_loop"}}, true)
    TriggerClientEvent("cancelando",source,true)

    while segundos > 0 do
        Wait(1000)
        vRP.giveInventoryItem(user_id,"dinheirosujo",math.random(70,400))
        segundos = segundos -1
    end

    roubando = false
    vRPclient.stopAnim(source, false)
    TriggerClientEvent("cancelando",source,false)
end

function Proibido()

    local source = source
    local user_id = vRP.getUserId(source)

    return not vRP.hasPermission(user_id,"policia.permissao") or vRP.hasPermission(user_id,"paisanapolicia.permissao") or vRP.hasPermission(user_id,"paramedico.permissao") or vRP.hasPermission(user_id,"paisanaparamedico.permissao") or vRP.hasPermission(user_id,"juiza.permissao") or vRP.hasPermission(user_id,"promotor.permissao") or vRP.hasPermission(user_id,"advogado.permissao")
end