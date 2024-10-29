# simple-snipe-it-export
Create bearer credentials with Read-Host or save it as an xml secure string to call it more often.

```
$credential = Read-Host "Enter your snipe-it bearer token" -AsSecureString
```
```
Read-Host "Enter your snipe-it bearer token" -AsSecureString | Export-Clixml snipeBearer.xml
$credential = Import-Clixml .\snipeBearer.xml
```

Call the function to get the assets an save them as a variable or pipe them directly as needed

```
$assets = Get-SnipeITAssets -Credential $credential -BaseUrl "https://yoursnipeiturl.com"
```

# Example of processing the results for cleaner output along with CSV

```
$assets | Select-Object -Property asset_tag, serial -ExpandProperty assigned_to | 
    Where-Object email -ne $null | 
    Export-Csv export.csv
```