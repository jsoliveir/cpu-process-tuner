
Function Get-ProcessRules{
    param([Parameter(Mandatory=$false)] $Path = (Join-Path (Get-Location).Path  "rules"))
    $rules =  ((
        Get-ChildItem `
            -Filter *.yml `
            -Path $Path
    ) | Get-Content | ConvertFrom-Yaml).rules

    foreach($r in $rules){

        [CpuCore]$affinity = $r.affinity | ForEach-Object {
            if($_){ [CpuCore]"Core$_"  }
            else {[CpuCore]255}
        }

        $priority = [CpuPriority]$r.priority

        $r | Add-Member -Force -Type NoteProperty `
            -Name affinity -Value $affinity
        $r | Add-Member -Force -Type NoteProperty `
            -Name priority -Value $priority
    }
    
    return $rules
}