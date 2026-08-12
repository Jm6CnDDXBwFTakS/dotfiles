Function Start-Charlie() {
    $Host.UI.RawUI.WindowTitle = "charlie.ps1"

    Start-ThreadJob -ScriptBlock ${Function:StartAlphaImpl} -StreamingHost $Host > $Null
    Start-ThreadJob -ScriptBlock ${Function:StartNovemberImpl} -StreamingHost $Host > $Null

    Get-Job | Wait-Job
}

Function StartNovemberImpl() {
    $Private:configPath = Join-Path -Path $Env:XDG_CONFIG_HOME -ChildPath "charlie\config.ps1"

    While ($True) {
        . $Private:configPath
        While ( -Not $Global:CharlieConfig.IsEnableNovember) {
            Write-Host -NoNewLine "N" -ForegroundColor Red
            While ( -Not $Global:CharlieConfig.IsEnableNovember) {
                Start-Sleep -Seconds 30
                . $Private:configPath
            }
        }

        Write-Host -NoNewLine "n" -ForegroundColor Green 

        $Private:unitCount = (Get-Random -Minimum 1 -Maximum 145000)
        $Private:isNaturalTwenty = ((Get-Random -Minimum 1 -Maximum 20) -Eq 20)
        If ($Private:isNaturalTwenty) {
            $Private:unitCount = (Get-Random -Minimum 1 -Maximum 350000)
        }

        $Private:unitArray = [String[]]::new($Private:unitCount)
        For ($i = 0; $i -Lt $Private:unitCount; $i++) {
            $Private:unitArray[$i] = (New-Guid)
        }

        $Private:nowUtc = (Get-Date).ToUniversalTime()
        $Private:todayUtcString = $Private:nowUtc.ToString("yyyy-MM-dd", [System.Globalization.DateTimeFormatInfo]::InvariantInfo)
        $Private:outputDir = Join-Path $Global:CharlieConfig.NovemberRootOutputDir "$Private:todayUtcString/"
        New-Item -Type Directory -Force $Private:outputDir > $Null

        $Private:newGuid = (New-Guid)
        $Private:filename = "$Private:newGuid.dat"
        $Private:outputPath = Join-Path $Private:outputDir $Private:filename

        [System.IO.File]::WriteAllLines($Private:outputPath, $Private:unitArray) > $Null

        $Private:interval = (Get-Random -Minimum 180000 -Maximum 900000)
        Start-Sleep -Milliseconds $Private:interval > $Null
    }
}

Function StartAlphaImpl() {
    $Private:FLAG_CONTINUOUS       = [uint32]"0x80000000"
    $Private:FLAG_SYSTEM_REQUIRED  = [uint32]"0x00000001"
    $Private:FLAG_DISPLAY_REQUIRED = [uint32]"0x00000002"

    $Private:setThreadExecutionStateMethod = @"
[DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Auto)]
public static extern void SetThreadExecutionState(uint flags);
"@

    $Private:kernel32 = Add-Type `
        -MemberDefinition $Private:setThreadExecutionStateMethod `
        -Name 'Kernel32_SetThreadExecutionStateMethod' `
        -Namespace 'Kernel32_SetThreadExecutionStateMethod' `
        -PassThru

    Add-Type -AssemblyName "System.Windows.Forms" > $Null

    $Private:configPath = Join-Path -Path $Env:XDG_CONFIG_HOME -ChildPath "charlie\config.ps1"

    While ($True) {
        . $Private:configPath
        While ( -Not $Global:CharlieConfig.IsEnableAlpha) {
            Write-Host -NoNewLine "A" -ForegroundColor Red
            While ( -Not $Global:CharlieConfig.IsEnableAlpha) {
                Start-Sleep -Seconds 30 > $Null
                . $Private:configPath
            }
        }

        Write-Host -NoNewLine "a" -ForegroundColor Green

        $Private:interval001 = (Get-Random -Minimum 250 -Maximum 135000)
        $Private:interval002 = (Get-Random -Minimum 250 -Maximum 135000)

        [System.Windows.Forms.SendKeys]::SendWait("{NUMLOCK}")
        Start-Sleep -Milliseconds $Private:interval001 > $Null
        $Private:kernel32::SetThreadExecutionState($FLAG_SYSTEM_REQUIRED -bor $FLAG_DISPLAY_REQUIRED -bor $FLAG_CONTINUOUS)
        Start-Sleep -Milliseconds $Private:interval002 > $Null
    }
}

Export-ModuleMember -Function "*-*"
