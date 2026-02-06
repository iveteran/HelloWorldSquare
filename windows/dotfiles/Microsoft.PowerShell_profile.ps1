Set-PSReadlineOption -EditMode vi
Set-PSReadLineOption -ViModeIndicator Cursor
Import-Module PSCompletions

Remove-Item alias:ls
function ls { eza --icons $args }
function ll { eza --icons -l $args }

oh-my-posh init pwsh --config "https://github.com/JanDeDobbeleer/oh-my-posh/blob/main/themes/1_shell.omp.json" | Invoke-Expression
