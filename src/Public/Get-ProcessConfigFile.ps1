Function Get-ProcessConfigFile {
    $File = "rules.yml"
    $Path = (Get-Location).Path

    while (Test-Path $Path -IsValid){
        if(!(Test-Path (Join-Path $Path $File))){
            $Path = Split-Path $Path
        } else{
            return (Join-Path $Path $File)
        }

        if(!$Path) { break }
    }

    if((Test-Path (Join-Path $HOME $File))){
        return (Join-Path $HOME $File)
    }
    
    return (Join-Path (Get-Location).Path $File)
}