
local Players = game:GetService("Players") --  1
local LocalPlayer = Players.LocalPlayer 
local TweenService = game:GetService("TweenService")--  2
local UserInputService = game:GetService("UserInputService") --  3
local StarterGui = game:GetService("StarterGui") --  4
local VirtualInputManager = game:GetService("VirtualInputManager") --  5
local BlockPlayersUIActive = false --  6
local BlockPlayersScreenGui = nil --  7
local function toggleBlockPlayersUI(Value) --  8
    BlockPlayersUIActive = Value --  9
    if Value then --  10
        local DEFAULT_SETTINGS = { --  11
            position = { --  12
                X_Scale = 0.5, --  13
                X_Offset = -170, --  14
                Y_Scale = 0.5, --  15
                Y_Offset = -230 --  16
            } --  17
        } --  18
        local currentSettings = { --  19
            position = DEFAULT_SETTINGS.position --  20
        } --  21
        local function saveSettings() --  22
            local success, err = pcall(function() --  23
                if not isfolder("!LXCKRHub") then --  24
                    makefolder("!LXCKRHub") --  25
                end --  26
                local json = game:GetService("HttpService"):JSONEncode(currentSettings) --  27
                writefile("!LXCKRHub/BlockPlayersUISettings.json", json) --  28
            end) --  29
        end --  30
        local function loadSettings() --  31
            local success, result = pcall(function() --  32
                if isfolder("!LXCKRHub") and isfile("!LXCKRHub/BlockPlayersUISettings.json") then --  33
                    local json = readfile("!LXCKRHub/BlockPlayersUISettings.json") --  34
                    return game:GetService("HttpService"):JSONDecode(json) --  35
                end --  36
                return nil --  37
            end) --  38
            if success and result then --  39
                if result.position then --  40
                    currentSettings.position = result.position --  41
                end --  42
                return true --  43
            end --  44
            return false --  45
        end --  46
        loadSettings() --  47
        local COLORS = { --  48
            background = Color3.fromRGB(15, 15, 18), --  49
            surface = Color3.fromRGB(22, 22, 26), --  50
            surface_hover = Color3.fromRGB(28, 28, 33), --  51
            border = Color3.fromRGB(40, 40, 48), --  52
            text_primary = Color3.fromRGB(245, 245, 250), --  53
            text_secondary = Color3.fromRGB(165, 165, 175), --  54
            text_muted = Color3.fromRGB(115, 115, 125), --  55
            accent = Color3.fromRGB(88, 101, 242), --  56
            accent_hover = Color3.fromRGB(108, 121, 255), --  57
            accent_dark = Color3.fromRGB(71, 82, 196), --  58
            danger = Color3.fromRGB(237, 66, 69), --  59
            danger_hover = Color3.fromRGB(255, 89, 92), --  60
            success = Color3.fromRGB(32, 186, 78), --  61
            warning = Color3.fromRGB(250, 166, 26), --  62
        } --  63
        local playerBlockedStatus = {} --  64
        local FRAME_WIDTH = 340 --  65
        local HEADER_HEIGHT = 56 --  66
        local ITEM_HEIGHT = 64 --  67
        local ITEM_PADDING = 8 --  68
        local MAX_VISIBLE_ITEMS = 6 --  69
        local PADDING = 16 --  70
        local function getViewportCenter() --  71
            local viewportSize = workspace.CurrentCamera.ViewportSize --  72
            return viewportSize.X / 2, (viewportSize.Y / 2) + 25 --  73
        end --  74
        local function clickInstant() --  75
            local centerX, centerY = getViewportCenter() --  76
            VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1) --  77
            VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1) --  78
        end --  79
        local function blockStable(targetPlayer) --  80
            if targetPlayer == LocalPlayer then return false end --  81
            local success = pcall(function() --  82
                StarterGui:SetCore("PromptBlockPlayer", targetPlayer) --  83
            end) --  84
            if success then --  85
                task.wait(0.1) --  86
                clickInstant() --  87
                task.wait(0.2) --  88
                return true --  89
            end --  90
            return false --  91
        end --  92
        BlockPlayersScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui) --  93
        BlockPlayersScreenGui.Name = "!LXCKRBlockUI" --  94
        BlockPlayersScreenGui.ResetOnSpawn = false --  95
        BlockPlayersScreenGui.IgnoreGuiInset = true --  96
        BlockPlayersScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling --  97
        local mainFrame = Instance.new("Frame", BlockPlayersScreenGui) --  98
        mainFrame.Size = UDim2.new(0, FRAME_WIDTH, 0, 460) --  99
        mainFrame.Position = UDim2.new( --  100
            currentSettings.position.X_Scale, --  101
            currentSettings.position.X_Offset, --  102
            currentSettings.position.Y_Scale, --  103
            currentSettings.position.Y_Offset --  104
        ) --  105
        mainFrame.BackgroundColor3 = COLORS.background --  106
        mainFrame.Active = true --  107
        mainFrame.BorderSizePixel = 0 --  108
        local mainCorner = Instance.new("UICorner", mainFrame) --  109
        mainCorner.CornerRadius = UDim.new(0, 12) --  110
        local mainStroke = Instance.new("UIStroke", mainFrame) --  111
        mainStroke.Color = Color3.fromRGB(170, 120, 255)
        mainStroke.Thickness = 2.5 --  113
        mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border 
        local mainGradient = Instance.new("UIGradient")
        mainGradient.Parent = mainStroke
        mainGradient.Color = ColorSequence.new(
            Color3.fromRGB(170, 120, 255),
            Color3.fromRGB(0 , 0, 0)
        )
        local gradientTweenInfo = TweenInfo.new(
            2,
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.InOut,
            -1,
            false,
            0
        )

        TweenService:Create(mainGradient, gradientTweenInfo, {Rotation = 360}):Play()
        --  114
        local header = Instance.new("Frame", mainFrame) --  115
        header.Size = UDim2.new(1, 0, 0, HEADER_HEIGHT) --  116
        header.Position = UDim2.new(0, 0, 0, 0) --  117
        header.BackgroundColor3 = COLORS.surface --  118
        header.BorderSizePixel = 0 --  119
        header.Active = true --  120
        local headerCorner = Instance.new("UICorner", header) --  121
        headerCorner.CornerRadius = UDim.new(0, 12) --  122
        local headerBorder = Instance.new("Frame", header) --  123
        headerBorder.Size = UDim2.new(1, 0, 0, 12) --  124
        headerBorder.Position = UDim2.new(0, 0, 1, -12) --  125
        headerBorder.BackgroundColor3 = COLORS.surface --  126
        headerBorder.BorderSizePixel = 0 --  127
        local title = Instance.new("TextLabel", header) --  128
        title.Size = UDim2.new(1, -90, 1, 0) --  129
        title.Position = UDim2.new(0, PADDING, 0, 0) --  130
        title.BackgroundTransparency = 1 --  131
        title.Text = " !LXKCR Block Players" --  132
        title.Font = Enum.Font.GothamBold --  133
        title.TextColor3 = COLORS.text_primary --  134
        title.TextXAlignment = Enum.TextXAlignment.Left --  135
        title.TextSize = 20 --  136
        local playerCount = Instance.new("TextLabel", mainFrame) --  137
        playerCount.Size = UDim2.new(1, -2*PADDING, 0, 36) --  138
        playerCount.Position = UDim2.new(0, PADDING, 0, HEADER_HEIGHT + 8) --  139
        playerCount.BackgroundTransparency = 1 --  140
        playerCount.Text = "0 players online" --  141
        playerCount.Font = Enum.Font.Gotham --  142
        playerCount.TextColor3 = COLORS.text_secondary --  143
        playerCount.TextXAlignment = Enum.TextXAlignment.Left --  144
        playerCount.TextSize = 12 --  145
        local listYPosition = HEADER_HEIGHT + 48 --  146
        local listFrame = Instance.new("ScrollingFrame", mainFrame) --  147
        listFrame.Size = UDim2.new(1, -2*PADDING, 0, 0) --  148
        listFrame.Position = UDim2.new(0, PADDING, 0, listYPosition) --  149
        listFrame.BackgroundColor3 = COLORS.surface --  150
        listFrame.BorderSizePixel = 0 --  151
        listFrame.CanvasSize = UDim2.new(0, 0, 0, 0) --  152
        listFrame.ScrollBarThickness = 4 --  153
        listFrame.ScrollBarImageColor3 = COLORS.accent --  154
        listFrame.ScrollBarImageTransparency = 0.3 --  155
        local listCorner = Instance.new("UICorner", listFrame) --  156
        listCorner.CornerRadius = UDim.new(0, 10) --  157
        local listLayout = Instance.new("UIListLayout", listFrame) --  158
        listLayout.FillDirection = Enum.FillDirection.Vertical --  159
        listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center --  160
        listLayout.VerticalAlignment = Enum.VerticalAlignment.Top --  161
        listLayout.Padding = UDim.new(0, ITEM_PADDING) --  162
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder --  163
        local listPadding = Instance.new("UIPadding", listFrame) --  164
        listPadding.PaddingTop = UDim.new(0, 10) --  165
        listPadding.PaddingBottom = UDim.new(0, 10) --  166
        listPadding.PaddingLeft = UDim.new(0, 10) --  167
        listPadding.PaddingRight = UDim.new(0, 10) --  168
        local blockAllBtn = Instance.new("TextButton", mainFrame) --  169
        blockAllBtn.Size = UDim2.new(1, -2*PADDING, 0, 46) --  170
        blockAllBtn.Position = UDim2.new(0, PADDING, 1, -46 - PADDING) --  171
        blockAllBtn.BackgroundColor3 = Color3.fromRGB(0 , 0, 0) --  172
        blockAllBtn.Text = "Block All Players" --  173
        blockAllBtn.TextColor3 = COLORS.text_primary --  174
        blockAllBtn.Font = Enum.Font.GothamBold --  175
        blockAllBtn.TextSize = 14 --  176
        blockAllBtn.BorderSizePixel = 0 --  177
        blockAllBtn.AutoButtonColor = false --  178
        local Stroke = Instance.new("UIStroke", blockAllBtn) --  111
        Stroke.Color = Color3.fromRGB(170, 120, 255)
        Stroke.Thickness = 1.5 --  113
        Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border 
        local Gradient = Instance.new("UIGradient")
        Gradient.Parent = Stroke
        Gradient.Color = ColorSequence.new(
            Color3.fromRGB(200, 40, 40),
            Color3.fromRGB(0 , 0, 0)
        )
        local gradientTweenInfo2 = TweenInfo.new(
            2,
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.InOut,
            -1,
            false,
            0
        )
          TweenService:Create(Gradient, gradientTweenInfo2, {Rotation = 360}):Play()
        local btnCorner = Instance.new("UICorner", blockAllBtn) --  179
        btnCorner.CornerRadius = UDim.new(0, 10) --  180
        blockAllBtn.MouseEnter:Connect(function() --  181
            if blockAllBtn.Active then --  182
                blockAllBtn.BackgroundColor3 = Color3.fromRGB(0 , 1, 0) --  183
            end --  184
        end) --  185
        blockAllBtn.MouseLeave:Connect(function() --  186
            if blockAllBtn.Active then --  187
                blockAllBtn.BackgroundColor3 = Color3.fromRGB(0 , 0, 0)  --  188
            end --  189
        end) --  190
        local function blockAllPlayers() --  191
            blockAllBtn.Text = "Blocking players..."
            Gradient.Color = ColorSequence.new(Color3.fromRGB(40, 200, 80), Color3.fromRGB(0, 0, 0))
		    Stroke.Color = Color3.fromRGB(40, 200, 80)--  192 --  193
            blockAllBtn.Active = false --  194
            task.spawn(function() --  195
                local blockedCount = 0 --  196
                local playerList = Players:GetPlayers() --  197
                local totalPlayers = 0 --  198
                for _, p in ipairs(playerList) do --  199
                    if p ~= LocalPlayer then --  200
                        totalPlayers = totalPlayers + 1 --  201
                    end --  202
                end --  203
                for _, targetPlayer in ipairs(playerList) do --  204
                    if targetPlayer ~= LocalPlayer then --  205
                        local success = blockStable(targetPlayer) --  206
                        if success then --  207
                            blockedCount = blockedCount + 1 --  208
                            playerBlockedStatus[targetPlayer.UserId] = os.time() --  209
                            blockAllBtn.Text = "Blocking... " .. blockedCount .. "/" .. totalPlayers --  210
                        end --  211
                        task.wait(0.05) --  212
                    end --  213
                end --  214
                blockAllBtn.Text = "✓ Blocked " .. blockedCount .. " players" --  215 --  216
                Gradient.Color = ColorSequence.new(Color3.fromRGB(200, 40, 40), Color3.fromRGB(0, 0, 0))
		        Stroke.Color = Color3.fromRGB(200, 40, 40)
                task.wait(2.5) --  217
                blockAllBtn.Text = "Block All Players" --  218 --  219
                blockAllBtn.Active = true --  220
            end) --  221
        end --  222
        blockAllBtn.MouseButton1Click:Connect(blockAllPlayers) --  223
        local function updatePlayerList() --  224
            for _, item in ipairs(listFrame:GetChildren()) do --  225
                if item:IsA("Frame") then --  226
                    item:Destroy() --  227
                end --  228
            end --  229
            local pCount = 0 --  230
            local currentTime = os.time() --  231
            for _, targetPlayer in ipairs(Players:GetPlayers()) do --  232
                if targetPlayer ~= LocalPlayer then --  233
                    pCount = pCount + 1 --  234
                    local entry = Instance.new("Frame") --  235
                    entry.Size = UDim2.new(1, -20, 0, ITEM_HEIGHT) --  236
                    entry.BackgroundColor3 = COLORS.background --  237
                    entry.BorderSizePixel = 0 --  238
                    entry.Parent = listFrame --  239
                    local entryCorner = Instance.new("UICorner", entry) --  240
                    entryCorner.CornerRadius = UDim.new(0, 8) --  241
                    local entryStroke = Instance.new("UIStroke", entry) --  242
                    entryStroke.Color = COLORS.border --  243
                    entryStroke.Thickness = 1 --  244
                    entryStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border --  245
                    entryStroke.Transparency = 0.5 --  246
                    local avatar = Instance.new("ImageLabel", entry) --  247
                    avatar.Size = UDim2.new(0, 44, 0, 44) --  248
                    avatar.Position = UDim2.new(0, 10, 0.5, -22) --  249
                    avatar.BackgroundColor3 = COLORS.surface --  250
                    avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. targetPlayer.UserId .. "&w=150&h=150" --  251
                    avatar.BorderSizePixel = 0 --  252
                    local avatarCorner = Instance.new("UICorner", avatar) --  253
                    avatarCorner.CornerRadius = UDim.new(1, 0) --  254
                    local avatarStroke = Instance.new("UIStroke", avatar) --  255
                    avatarStroke.Color = COLORS.border --  256
                    avatarStroke.Thickness = 2 --  257
                    avatarStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border --  258
                    local nameLabel = Instance.new("TextLabel", entry) --  259
                    nameLabel.Size = UDim2.new(0, 160, 0, 20) --  260
                    nameLabel.Position = UDim2.new(0, 62, 0, 14) --  261
                    nameLabel.BackgroundTransparency = 1 --  262
                    nameLabel.Text = targetPlayer.DisplayName --  263
                    nameLabel.Font = Enum.Font.GothamBold --  264
                    nameLabel.TextColor3 = COLORS.text_primary --  265
                    nameLabel.TextXAlignment = Enum.TextXAlignment.Left --  266
                    nameLabel.TextSize = 13 --  267
                    nameLabel.TextTruncate = Enum.TextTruncate.AtEnd --  268
                    local usernameLabel = Instance.new("TextLabel", entry) --  269
                    usernameLabel.Size = UDim2.new(0, 160, 0, 16) --  270
                    usernameLabel.Position = UDim2.new(0, 62, 0, 32) --  271
                    usernameLabel.BackgroundTransparency = 1 --  272
                    usernameLabel.Text = "@" .. targetPlayer.Name --  273
                    usernameLabel.Font = Enum.Font.Gotham --  274
                    usernameLabel.TextColor3 = COLORS.text_muted --  275
                    usernameLabel.TextXAlignment = Enum.TextXAlignment.Left --  276
                    usernameLabel.TextSize = 11 --  277
                    usernameLabel.TextTruncate = Enum.TextTruncate.AtEnd --  278
                    local blockBtn = Instance.new("TextButton", entry) --  279
                    blockBtn.Size = UDim2.new(0, 72, 0, 32) --  280
                    blockBtn.Position = UDim2.new(1, -82, 0.5, -16) --  281
                    blockBtn.BackgroundColor3 = COLORS.danger --  282
                    blockBtn.Text = "Block" --  283
                    blockBtn.TextColor3 = COLORS.text_primary --  284
                    blockBtn.Font = Enum.Font.GothamBold --  285
                    blockBtn.TextSize = 12 --  286
                    blockBtn.BorderSizePixel = 0 --  287
                    blockBtn.AutoButtonColor = false --  288
                    local blockBtnCorner = Instance.new("UICorner", blockBtn) --  289
                    blockBtnCorner.CornerRadius = UDim.new(0, 6) --  290
                    local blockedTime = playerBlockedStatus[targetPlayer.UserId] --  291
                    if blockedTime and (currentTime - blockedTime) < 5 then --  292
                        blockBtn.Text = "✓" --  293
                        blockBtn.BackgroundColor3 = COLORS.success --  294
                        blockBtn.Active = false --  295
                    else --  296
                        playerBlockedStatus[targetPlayer.UserId] = nil --  297
                    end --  298
                    blockBtn.MouseEnter:Connect(function() --  299
                        if blockBtn.Active and blockBtn.Text == "Block" then --  300
                            blockBtn.BackgroundColor3 = COLORS.danger_hover --  301
                        end --  302
                    end) --  303
                    blockBtn.MouseLeave:Connect(function() --  304
                        if blockBtn.Active and blockBtn.Text == "Block" then --  305
                            blockBtn.BackgroundColor3 = COLORS.danger --  306
                        end --  307
                    end) --  308
                    blockBtn.MouseButton1Click:Connect(function() --  309
                        if not blockBtn.Active or blockBtn.Text ~= "Block" then return end --  310
                        blockBtn.Text = "..." --  311
                        blockBtn.BackgroundColor3 = COLORS.warning --  312
                        local success = blockStable(targetPlayer) --  313
                        if success then --  314
                            blockBtn.Text = "✓" --  315
                            blockBtn.BackgroundColor3 = COLORS.success --  316
                            blockBtn.Active = false --  317
                            playerBlockedStatus[targetPlayer.UserId] = os.time() --  318
                            task.delay(5, function() --  319
                                if playerBlockedStatus[targetPlayer.UserId] then --  320
                                    playerBlockedStatus[targetPlayer.UserId] = nil --  321
                                end --  322
                            end) --  323
                        else --  324
                            blockBtn.Text = "Block" --  325
                            blockBtn.BackgroundColor3 = COLORS.danger --  326
                        end --  327
                    end) --  328
                end --  329
            end --  330
            playerCount.Text = pCount .. " player" .. (pCount == 1 and "" or "s") .. " online" --  331
            local totalItemHeight = pCount * (ITEM_HEIGHT + ITEM_PADDING) + 20 --  332
            local listHeight = math.min(totalItemHeight, MAX_VISIBLE_ITEMS * (ITEM_HEIGHT + ITEM_PADDING)) --  333
            listFrame.Size = UDim2.new(1, -2*PADDING, 0, listHeight) --  334
            listFrame.CanvasSize = UDim2.new(0, 0, 0, totalItemHeight) --  335
            local newFrameHeight = listYPosition + listHeight + 46 + PADDING * 2 --  336
            mainFrame.Size = UDim2.new(0, FRAME_WIDTH, 0, newFrameHeight) --  337
            blockAllBtn.Position = UDim2.new(0, PADDING, 1, -46 - PADDING) --  338
        end --  339
        local playerAddedConnection = Players.PlayerAdded:Connect(function(newPlayer) --  340
            if BlockPlayersUIActive and BlockPlayersScreenGui and BlockPlayersScreenGui.Parent then --  341
                task.wait(0.5) --  342
                updatePlayerList() --  343
            end --  344
        end) --  345
        local playerRemovingConnection = Players.PlayerRemoving:Connect(function(leavingPlayer) --  346
            if BlockPlayersUIActive and BlockPlayersScreenGui and BlockPlayersScreenGui.Parent then --  347
                task.wait(0.2) --  348
                updatePlayerList() --  349
            end --  350
        end) --  351
        task.spawn(function() --  352
            while task.wait(5) do --  353
                if BlockPlayersUIActive and BlockPlayersScreenGui and BlockPlayersScreenGui.Parent then --  354
                    updatePlayerList() --  355
                else --  356
                    if playerAddedConnection then --  357
                        playerAddedConnection:Disconnect() --  358
                    end --  359
                    if playerRemovingConnection then --  360
                        playerRemovingConnection:Disconnect() --  361
                    end --  362
                    break --  363
                end --  364
            end --  365
        end) --  366
        local dragging = false --  367
        local dragInput --  368
        local dragStart --  369
        local startPos --  370
        local function update(input) --  371
            local delta = input.Position - dragStart --  372
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) --  373
        end --  374
        header.InputBegan:Connect(function(input) --  375
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then --  376
                dragging = true --  377
                dragStart = input.Position --  378
                startPos = mainFrame.Position --  379
                input.Changed:Connect(function() --  380
                    if input.UserInputState == Enum.UserInputState.End then --  381
                        dragging = false --  382
                        currentSettings.position = { --  383
                            X_Scale = mainFrame.Position.X.Scale, --  384
                            X_Offset = mainFrame.Position.X.Offset, --  385
                            Y_Scale = mainFrame.Position.Y.Scale, --  386
                            Y_Offset = mainFrame.Position.Y.Offset --  387
                        } --  388
                        saveSettings() --  389
                    end --  390
                end) --  391
            end --  392
        end) --  393
        header.InputChanged:Connect(function(input) --  394
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then --  395
                dragInput = input --  396
            end --  397
        end) --  398
        UserInputService.InputChanged:Connect(function(input) --  399
            if input == dragInput and dragging then --  400
                update(input) --  401
            end --  402
        end) --  403
        updatePlayerList() --  404
        print("Block Players UI Enabled!") --  405
    else --  406
        if BlockPlayersScreenGui then --  407
            BlockPlayersScreenGui:Destroy() --  408
            BlockPlayersScreenGui = nil --  409
        end --  410
        print("Block Players UI Disabled!") --  411
    end --  412
end --  413
toggleBlockPlayersUI(true) 
