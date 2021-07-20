
Function Set-ProcessRules{
    [CmdletBinding()]
    param([Parameter(Mandatory = $true, ValueFromPipeline = $true)] $Rules)

    
    BEGIN{
        # cache the processes
        $global:PTUN_EFFECTIVE_RULES = @{}        
        $global:PTUN_PROCESSES = (Get-Process) | Select-Object Id,Name,Path
        Write-Host "`n$(Get-Date)"
        Write-Host -ForegroundColor darkgray "Run Get-ProcessRules to see the configured processes list"
        Write-Host -ForegroundColor yellow "`nOpened Processes:"
    }


    PROCESS {
        # generate an array with the reules for the given processes
        # if the rules get overlapped the overrides will happen in memory only
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
        # apply the rules to the running processes
        foreach($r in @($global:PTUN_EFFECTIVE_RULES.Keys)){
            try{             
                foreach($process in Get-Process -ProcessName $r -ErrorAction SilentlyContinue ){
                    #set the cpu affinity
                    $process.ProcessorAffinity = `
                        [int]$global:PTUN_EFFECTIVE_RULES[$process.ProcessName].Affinity

                    #set the cpu priority
                    $process.PriorityClass = `
                        [string]$global:PTUN_EFFECTIVE_RULES[$process.ProcessName].Priority
                }

                Write-Host -ForegroundColor cyan "$($process.Name)".PadRight(20) `
                "Priority: $($global:PTUN_EFFECTIVE_RULES[$process.ProcessName].Priority)".PadRight(30) `
                "Affinity: $($global:PTUN_EFFECTIVE_RULES[$process.ProcessName].Affinity)".PadRight(40) `
                "Status: OK."

            }catch{
                Write-Host -ForegroundColor red "$($process.Name)".PadRight(20) `
                "Priority: $($global:PTUN_EFFECTIVE_RULES[$process.ProcessName].Priority)".PadRight(20)  `
                "Affinity: $($global:PTUN_EFFECTIVE_RULES[$process.ProcessName].Affinity)".PadRight(40) `
                "Status: Failed.`n $($_.Exception.Message)"
            }finally{
                Write-Host -ForegroundColor Darkgray `
                "".PadRight(104,'-')
            }
        }
    }
}
