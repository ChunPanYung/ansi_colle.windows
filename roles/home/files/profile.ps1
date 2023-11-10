function Prompt {
    $curdir = $ExecutionContext.SessionState.Path.CurrentLocation.Path

    Write-Host "PS " -ForegroundColor Blue -NoNewline
    Write-Host $curdir -ForegroundColor White -NoNewline
    Write-Host ">" -ForegroundColor Blue -NoNewline
    return " "
}
