$DotfilesLocation = "$Home\dotfiles"
 
New-Item -ItemType SymbolicLink -Path "$Home/AppData/Local/nvim" -Target "$Home/dotfiles/.config/nvim"
echo "created nvim config symlink"

"$PROFILE = 'C:\Users\kolacampbell\dotfiles\.config\powershell\profile.ps1'
. $PROFILE" | Out-File -FilePath "$HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" -Encoding UTF8
echo "updated powershell profile"

if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Output "Git is not installed. Installing now..."
    Invoke-WebRequest https://github.com/git-for-windows/git/releases/download/v2.30.2.windows.2/Git-2.30.2-64-bit.exe -OutFile git.exe
    Start-Process -FilePath .\git.exe -ArgumentList '/VERYSILENT /DIR=C:\Git' -Wait
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";C:\Git\cmd"
    [System.Environment]::SetEnvironmentVariable("PATH", $env:PATH, "Machine")
    Write-Output "Git installed successfully."
} else {
    Write-Output "Git is already installed."
}

git clone https://github.com/wbthomason/packer.nvim "$env:LOCALAPPDATA\nvim-data\site\pack\packer\start\packer.nvim"
echo "installed packer nvim"


[Environment]::SetEnvironmentVariable("WEZTERM_CONFIG_FILE", "$DotfilesLocation\.config\wezterm\westerm.lua", "Machine")
