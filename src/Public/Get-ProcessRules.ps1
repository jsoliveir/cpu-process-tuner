
Function Get-ProcessRules{
    param([Parameter(Mandatory=$false)] $Path = (Get-Location).Path)
    $rules =  (
        Get-ChildItem `
            -Filter *.json `
            -Path $Path `
            -Recurse 
    ) | Get-Content | ConvertFrom-Json

    foreach($r in $rules){

        [cores]$affinity = $r.CpuAffinity | ForEach-Object {
            if($_){ [cores]"Core$_"  }
            else {[cores]255}
        }

        $priority = [priority]$r.CpuPriority

       

        $r | Add-Member -Force -Type NoteProperty `
            -Name CpuAffinity -Value $affinity
        $r | Add-Member -Force -Type NoteProperty `
            -Name CpuPriority -Value $priority
    }
    
    return $rules
}