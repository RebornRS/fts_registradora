local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

ftsC = Tunnel.getInterface("fts_registradora")

local Blips = {}

CreateThread(function()
    while true do
        sleep = 1000
        for k,v in pairs(Lojinhas) do 
            local ped = PlayerPedId()
            local pCDS = GetEntityCoords(ped)
            local cds = vector3(v.x,v.y,v.z)
            local distance = #(pCDS - cds)
            if distance <= 2 then
                sleep = 4
                DrawMarker(29,v.x,v.y,v.z-0.1,0,0,0,0.0,0,0,1.1,0.5,1.1,50,205,50,255,0,0,0,1)
                if distance <= 0.5 then
                    sleep = 4
                    drawText2D("PRESSIONE  ~r~E~w~  PARA ~r~ROUBAR~w~ A CAIXA REGISTRADORA",4,0.5,0.93,0.50,255,255,255,180)
                    if IsControlJustPressed(0,38) then
                        ftsC.CheckRoubo(k,v.x,v.y,v.z,v.h)
                    end
                end
            end
        end
        Wait(sleep)
    end
end)

RegisterNetEvent("fts:AdicionarCDS")
AddEventHandler("fts:AdicionarCDS",function(x,y,z)
    Blips = AddBlipForCoord(x,y,z)
    SetBlipSprite(Blips, 110)
    SetBlipColour(Blips, 1)
    AddTextEntry('Chamar:Policia', 'Ocorrência policial')
    BeginTextCommandSetBlipName('Chamar:Policia')
    EndTextCommandSetBlipName(Blips)
    Wait(50000)
    RemoveBlip(Blips)
end)

function drawText2D(text,font,x,y,scale,r,g,b,a)    
    SetTextFont(font)    
    SetTextScale(scale,scale)    
    SetTextColour(r,g,b,a)    
    SetTextOutline()    
    SetTextCentre(1)    
    SetTextEntry('STRING')    
    AddTextComponentString(text)    
    DrawText(x,y)
end