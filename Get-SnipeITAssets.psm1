function Get-SnipeITAssets {
    param(
        [Parameter(Mandatory = $true)]
        [securestring] $Credential,
        [Parameter(Mandatory = $true)]
        [string] $BaseUrl
    )

    # Get bearer token from credential parameter. 
    $bearerToken = $Credential | ConvertFrom-SecureString -AsPlainText

    $headers = @{
        Accept        = "application/json"
        Authorization = "Bearer $bearerToken"
    }

    try {
        # Get initial response to determine total number of assets
        $response = Invoke-RestMethod -Uri "$BaseUrl/api/v1/hardware?status=Deployed&limit=2" -Method GET -Headers $headers -ErrorAction Stop
        Write-Debug "Total Asset Response $($response.total)"
        $response.total = [int] $response.total
        if (-not ($response.total -is [int])) {
            throw "Invalid response from API. 'total' property is not a number."
        }

        for ($pagination = New-Object -TypeName PSObject -Property @{ total = $response.total; index = 0; offset = 0 }; $pagination.offset -lt $pagination.total) {
            $response = Invoke-RestMethod -Uri "$BaseUrl/api/v1/hardware?status=Deployed&offset=$($pagination.offset)" -Method GET -Headers $headers
            $pagination.total = $response.total
            $result += $response.rows
            $pagination.offset = $pagination.offset + 500
            Write-Debug "$($pagination.offset) Assets Collected"
            Start-Sleep 3
        }

    } catch {
        Write-Error "Failed to retrieve assets: $($_.Exception.Message)"
        return $null 
    }
    return $result
}