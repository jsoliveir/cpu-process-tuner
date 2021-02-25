
Function Set-ProcessRules{
    [CmdletBinding()]
    param([Parameter(Mandatory = $true, ValueFromPipeline = $true)] $Rules,
          [Parameter(Mandatory = $false)] $ProcessName,
          [Parameter(Mandatory = $false)] $ProcessId
    )

    BEGIN{
        $global:PTUN_EFFECTIVE_RULES = @{}        
        if($ProcessId){
            $global:PTUN_PROCESSES =  @(Get-Process -Id $ProcessId);
        }elseif($ProcessName){
            $global:PTUN_PROCESSES =  @(Get-Process -Name $ProcessName);
        }else{
            $global:PTUN_PROCESSES =  @(Get-Process);
        }
        $global:PTUN_PROCESSES = $global:PTUN_PROCESSES | Select-Object Id,Name,Path
    }
       

    PROCESS {
        Write-Host -ForegroundColor DarkGray `
            $Rules.selector.PadRight(22).Substring(0,20) `
            "$($Rules.priority)".PadRight(6) "->" `
            $Rules.affinity
        $global:PTUN_PROCESSES | Where-Object Path -imatch ".*$($Rules.selector).*" | Foreach-Object {
            if([System.IO.Path]::GetFileName($_.Path)) {
                $key = [System.IO.Path]::GetFileNameWithoutExtension($_.Path)
                $global:PTUN_EFFECTIVE_RULES[$key] = ([PSCustomObject]@{
                        Affinity   = $Rules.affinity
                        Priority   = $Rules.priority
                })
            }
        }
    }
    
    
    END {
        foreach($r in @($global:PTUN_EFFECTIVE_RULES.Keys)){
            foreach($process in Get-Process -ProcessName $r -ErrorAction SilentlyContinue ){
                try{
                    $process.ProcessorAffinity = `
                        [int]$global:PTUN_EFFECTIVE_RULES[$process.ProcessName].Affinity
                    $process.PriorityClass = `
                        [string]$global:PTUN_EFFECTIVE_RULES[$process.ProcessName].Priority

                    if($VerbosePreference){
                        Write-Host -ForegroundColor Green "$($process)" "OK."
                    }
                }catch{
                    if($VerbosePreference){
                        Write-Host -ForegroundColor Red "$($process)" "FAIL : " $_.Exception.Message
                    }
                }
            }
        }
    }
}
