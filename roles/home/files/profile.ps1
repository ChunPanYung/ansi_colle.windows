function Prompt {
    $curdir = $ExecutionContext.SessionState.Path.CurrentLocation.Path

    Write-Host "PS " -ForegroundColor Blue -NoNewline
    Write-Host $curdir -ForegroundColor White -NoNewline
    Write-Host ">" -ForegroundColor Blue -NoNewline
    return " "
}

# pip powershell completion start
if ((Test-Path Function:\TabExpansion) -and -not `
    (Test-Path Function:\_pip_completeBackup)) {
    Rename-Item Function:\TabExpansion _pip_completeBackup
}
function TabExpansion($line, $lastWord) {
    $lastBlock = [regex]::Split($line, '[|;]')[-1].TrimStart()
    if ($lastBlock.StartsWith("$Env:LOCALAPPDATA\Programs\Python\Python311\python.exe -m pip ")) {
        $Env:COMP_WORDS=$lastBlock
        $Env:COMP_CWORD=$lastBlock.Split().Length - 1
        $Env:PIP_AUTO_COMPLETE=1
        (& $Env:LOCALAPPDATA\Programs\Python\Python311\python.exe -m pip).Split()
        Remove-Item Env:COMP_WORDS
        Remove-Item Env:COMP_CWORD
        Remove-Item Env:PIP_AUTO_COMPLETE
    }
    elseif (Test-Path Function:\_pip_completeBackup) {
        # Fall back on existing tab expansion
        _pip_completeBackup $line $lastWord
    }
}
# pip powershell completion end

# Function
function pip { python -m pip $args }
