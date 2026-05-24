# userOnboarding_v3
$newUsers = Import-Csv -Path C:\Logs\newusers.csv

if (-not $cred) {
  $cred = Get-Credential -Message "Enter credentials with permissions to create AD users"
}

foreach ($user in $newUsers) {

  # Common variables that need adjustments to fit your environment
  $SecurePassword = ConvertTo-SecureString "P@ssword1" -AsPlainText -Force
  $ouPath = "OU=staging users,DC=lab,DC=local"
  $domain = "@lab.local"
  $homeDirectory = "\\DC01\Shares\Home\$($user.SamAccountName)" # <-- home directory path, adjust as needed

  # CSV Values combined
  $fullName = "$($user.GivenName) $($user.SurName)"
  $upn = "$($user.SamAccountName)$domain"

  $userParams = @{
    Name                  = $fullName
    GivenName             = $user.GivenName
    SurName               = $user.SurName
    SamAccountName        = $user.SamAccountName
    UserPrincipalName     = $upn
    AccountPassword       = $SecurePassword
    ChangePasswordAtLogon = $true 
    Enabled               = $true
    Path                  = $ouPath
    Credential            = $cred

    # Home Folder Settings
    HomeDrive             = "H:"
    HomeDirectory         = $homeDirectory 

    # Shell feedback
    PassThru              = $true
  }
  
  New-ADUser @userParams
}

<#
CSV Format:
GivenName,SurName,SamAccountName
#>
