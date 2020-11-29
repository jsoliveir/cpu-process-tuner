
Function Set-ProcessRules{
    [CmdletBinding()]
    param([Parameter(Mandatory = $true, ValueFromPipeline = $true)] $Rule,
          [Parameter(Mandatory = $false)] $ProcessName
    )

    BEGIN{
        Write-Host -ForegroundColor Magenta "Loading rules ..."
        if($ProcessName){
            $global:PROCESSES =  @((Get-Process $ProcessName).Path);
        }else{
            $global:PROCESSES =  @((Get-Process).Path);
        }
        $global:PROCESSES =  $global:PROCESSES | Where-Object Path  -notMatch "powershell|pwsh"

        $global:EFFECTIVE_RULES = @{}
    }
       
    PROCESS {
        Write-Host -ForegroundColor DarkGray `
            $Rule.Selector.PadRight(22).Substring(0,20) `
            "$($Rule.CpuPriority)".PadRight(6) "->" `
            $Rule.CpuAffinity


        $global:PROCESSES | Where-Object Path -match $Rule.Selector | Foreach-Object {
            if([System.IO.Path]::GetFileName($_)) {
                $global:EFFECTIVE_RULES[[System.IO.Path]::GetFileNameWithoutExtension($_)] = ([PSCustomObject]@{
                        Affinity   = $Rule.CpuAffinity
                        Priority   = $Rule.CpuPriority
                })
            }
        }
    }
    
    END {
        foreach($r in @($global:EFFECTIVE_RULES.Keys)){
            foreach($process in Get-Process -ProcessName $r){
                try{
                    $process.ProcessorAffinity = [int]$global:EFFECTIVE_RULES[$process.ProcessName].Affinity
                    $process.PriorityClass = [string]$global:EFFECTIVE_RULES[$process.ProcessName].Priority
                    if($VerbosePreference){
                        Write-Host -ForegroundColor Green "$($process.ProcessName)".PadRight(20) " OK."
                    }
                }catch{
                    if($VerbosePreference){
                        Write-Host -ForegroundColor Red  "$($process.ProcessName)".PadRight(20) "FAIL : " $_.Exception.Message
                    }
                }
            }
        }
    }
}
