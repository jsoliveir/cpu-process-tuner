Function New-ProcessRulesFile {
    param([Parameter(Mandatory=$false)] $Path = "rules")
    
    if($Path -notlike "*.y*ml" ){  $Path = "$Path.yml" } 
    
    New-Item "$Path" -Force
    "rules:"                    | Set-Content "./$Path"
    "  - selector: notepad"     | Add-Content "./$Path"
    "    affinity: [ 0, 1 ]"    | Add-Content "./$Path"
    "    priority: Normal"      | Add-Content "./$Path"
}
