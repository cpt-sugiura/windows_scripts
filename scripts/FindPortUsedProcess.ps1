<#
.SYNOPSIS
    指定されたポート番号を使用しているプロセスを確認します。

.DESCRIPTION
    このスクリプトは、指定されたポート番号を使用しているプロセスや、そのプロセスの実行ファイル名、
    プロセスID、およびそのプロセスがサービスであるかどうかを確認するために使用されます。

.PARAMETER port
    ポート番号を指定してください (0-65535)

.EXAMPLE
    .\FindPortUsedProcess.ps1 8080

    8080ポートを使用しているプロセスの情報を表示します。
#>
Param (
    [Parameter(Mandatory=$true, Position=0, HelpMessage="ポート番号を指定してください")]
    [ValidateScript({
        # $port が '--help' または '/?' かどうかを確認する
        if ($_ -eq '--help' -or $_ -eq '/?') {
            return $true
        }

        # 数値に変換し、0 から 65535 の範囲にあるかどうかを確認する
        $port = [UInt16]$_
        if ($port -ge 0 -and $port -le 65535) {
            return $true
        }

        # 範囲外の場合はエラーをスローする
        throw "不正なポート番号: $_"
    })]
    [string]$port
)

# ヘルプを表示する
if ($port -eq '--help' -or $port -eq '/?'-or $port -eq '!?') {
    Get-Help $MyInvocation.InvocationName -Examples
    return
}

# 指定されたポート番号を使用しているかどうかを確認する
# 使用されていないポートについていきなりプロセスIDを取得しようとするとエラーになるので、先に使用の有無を確認する
$isUsedPort = (Get-NetTCPConnection | Where-Object LocalPort -eq $port)
if ($isUsedPort -eq $null) {
    Write-Host "$port ポートは使用されていません"
    Exit 0
}

# 指定されたポート番号を使用しているプロセスIDを取得する
$pidL = (Get-NetTCPConnection -LocalPort $port).OwningProcess
if ($pidL -eq $null) {
    Write-Host "$port ポートを使用しているプロセスはありません"
    Exit 0
}

# プロセス実行ファイルの名前を取得する
$processName = (Get-Process -Id $pidL).Path

Write-Host "プロセスID: $pidL"
Write-Host "プロセス名: $processName"

# プロセスがサービスであるかどうかを確認する
$service = Get-WmiObject -Class Win32_Service | Where-Object { $_.PathName -eq $processName }

if ($service -ne $null) {
    Write-Host "サービス名: $( $service.Name )"
} else {
    Write-Host "サービスではありません"
}
