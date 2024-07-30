<#
 * FileName: Microsoft.PowerShell_profile.ps1
 * Author: Bingoner
 * Email: fanhongbin00@gmail.com
 * Date: 2024, July. 30
 * Copyright: No copyright. You can use this code for anything with no warranty.
#>


#------------------------------- Import Modules BEGIN -------------------------------
# 引入 posh-git
Import-Module posh-git
# 引入 Zlocation（z）
Import-Module Zlocation

# 引入 oh-my-posh
oh-my-posh init pwsh | Invoke-Expression
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/bubblesextra.omp.json" | Invoke-Expression
# oh-my-posh init pwsh --config "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/powerlevel10k_modern.omp.json" | Invoke-Expression


# 设置 PowerShell 主题
# Set-PoshPrompt -Theme slim
# atomic
# paradox
# slim
# night-owl
# bubblesline

# 设置Dir Colors
Import-Module DirColors
Import-Module npm-completion
Import-Module DockerCompletion
Import-Module Terminal-Icons


#------------------------------- Import Modules END   -------------------------------

# #------------------------------- Set oh-my-posh -------------------------------------
# [ScriptBlock]$Prompt = {
#     $lastCommandSuccess = $?
#     $realLASTEXITCODE = $global:LASTEXITCODE
#     $errorCode = 0
#     if ($lastCommandSuccess -eq $false) {
#         #native app exit code
#         if ($realLASTEXITCODE -is [int]) {
#             $errorCode = $realLASTEXITCODE
#         }
#         else {
#             $errorCode = 1
#         }
#     }
#     $startInfo = New-Object System.Diagnostics.ProcessStartInfo
#     $startInfo.FileName = "C:\Users\98309\scoop\apps\oh-my-posh\current\oh-my-posh.exe"
#     $cleanPWD = $PWD.ProviderPath.TrimEnd("\")
#     $startInfo.Arguments = "-config=""C:\Users\98309\scoop\apps\oh-my-posh\current\themes\jandedobbeleer.omp.json"" -error=$errorCode -pwd=""$cleanPWD"""
#     $startInfo.Environment["TERM"] = "xterm-256color"
#     $startInfo.CreateNoWindow = $true
#     $startInfo.StandardOutputEncoding = [System.Text.Encoding]::UTF8
#     $startInfo.RedirectStandardOutput = $true
#     $startInfo.UseShellExecute = $false
#     if ($PWD.Provider.Name -eq 'FileSystem') {
#       $startInfo.WorkingDirectory = $PWD.ProviderPath
#     }
#     $process = New-Object System.Diagnostics.Process
#     $process.StartInfo = $startInfo
#     $process.Start() | Out-Null
#     $standardOut = $process.StandardOutput.ReadToEnd()
#     $process.WaitForExit()
#     $standardOut
#     $global:LASTEXITCODE = $realLASTEXITCODE
#     #remove temp variables
#     Remove-Variable realLASTEXITCODE -Confirm:$false
#     Remove-Variable lastCommandSuccess -Confirm:$false
# }
# Set-Item -Path Function:prompt -Value $Prompt -Force
# #-------------------------------- Set oh-my-posh END ---------------------------------



#-------------------------------  Set Hot-keys BEGIN  -------------------------------

Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView

# Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'
# 设置 Tab 键补全
# Set-PSReadlineKeyHandler -Key Tab -Function Complete

# 设置 Ctrl+d 为菜单补全和 Intellisense
Set-PSReadLineKeyHandler -Key "Tab" -Function MenuComplete

# 设置 Ctrl+d 为退出 PowerShell
Set-PSReadlineKeyHandler -Key "Ctrl+d" -Function ViExit

# 设置 Ctrl+z 为撤销
Set-PSReadLineKeyHandler -Key "Ctrl+z" -Function Undo

# # 设置向上键为后向搜索历史记录
# Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward

# # 设置向下键为前向搜索历史纪录
# Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
#-------------------------------  Set Hot-keys END    -------------------------------





#-------------------------------    Functions BEGIN   -------------------------------
# Python 直接执行
$env:PATHEXT += ";.py"

# 更新 pip 的方法
function Update-Packages {
    # update pip
    Write-Host "Step 1: 更新 pip" -ForegroundColor Magenta -BackgroundColor Cyan
    $a = pip list --outdated
    $num_package = $a.Length - 2
    for ($i = 0; $i -lt $num_package; $i++) {
        $tmp = ($a[2 + $i].Split(" "))[0]
        pip install -U $tmp
    }

    # update TeX Live
    $CurrentYear = Get-Date -Format yyyy
    Write-Host "Step 2: 更新 TeX Live" $CurrentYear -ForegroundColor Magenta -BackgroundColor Cyan
    tlmgr update --self
    tlmgr update --all
}


function which ($command) {
    Get-Command -Name $command -ErrorAction SilentlyContinue |
        Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}
#-------------------------------    Functions END     -------------------------------





#-------------------------------   Set Alias Begin    -------------------------------
# 1. 编译函数 make
function MakeThings {
    nmake.exe $args -nologo
}
Set-Alias -Name make -Value MakeThings

# 2. 更新系统 os-update
Set-Alias -Name os-update -Value Update-Packages

# 3. 查看目录 ls & ll
function ListDirectory {
    (Get-ChildItem).Name
    Write-Host("")
}
Set-Alias -Name ls -Value Get-ChildItem
Set-Alias -Name ll -Value ListDirectory
Set-Alias -Name vim nvim
#-------------------------------    Set Alias END     -------------------------------



#-------------------------------   Set Network BEGIN    -------------------------------
# 1. 获取所有 Network Interface
function Get-AllNic {
	Get-NetAdapter | Sort-Object -Property MacAddress
}
Set-Alias -Name getnic -Value Get-AllNic

# 2. 获取 IPv4 关键路由
function Get-IPv4Routes {
	Get-NetRoute -AddressFamily IPv4 | Where-Object -FilterScript {$_.NextHop -ne '0.0.0.0'}
}
Set-Alias -Name getip -Value Get-IPv4Routes

# 3. 获取 IPv6 关键路由
function Get-IPv6Routes {
	Get-NetRoute -AddressFamily IPv6 | Where-Object -FilterScript {$_.NextHop -ne '::'}
}
Set-Alias -Name getip6 -Value Get-IPv6Routes
#-------------------------------    Set Network END     -------------------------------
