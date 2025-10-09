--v1.2
return function(shared)
    local modules = shared.modules
    local theme = shared.theme
    local mainUi = shared.mainUi

    local lib = modules['UiLibrary.lua'](shared)

    repeat
        task.wait()
    until shared.ready

    local ui = lib.new(mainUi)

    -- local sections = {
    --     ui:newSection('About'),
    --     ui:newSection('Universal'),
    --     ui:newSection('Settings'),
    -- }

    -- ui:open(sections[1])

    -- sections[1]:newLabel('<b>What is this?</b>\n This is a test.',{
    --     RichText = true
    -- })

    -- sections[3]:newButton('Something broken?','Relaunch EHS',function()
    --     print('UHH this doesnt work yet..')
    -- end)
end
