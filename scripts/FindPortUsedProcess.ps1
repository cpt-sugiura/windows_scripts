<#
.SYNOPSIS
    �w�肳�ꂽ�|�[�g�ԍ����g�p���Ă���v���Z�X���m�F���܂��B

.DESCRIPTION
    ���̃X�N���v�g�́A�w�肳�ꂽ�|�[�g�ԍ����g�p���Ă���v���Z�X��A���̃v���Z�X�̎��s�t�@�C�����A
    �v���Z�XID�A����т��̃v���Z�X���T�[�r�X�ł��邩�ǂ������m�F���邽�߂Ɏg�p����܂��B

.PARAMETER port
    �|�[�g�ԍ����w�肵�Ă������� (0-65535)

.EXAMPLE
    .\FindPortUsedProcess.ps1 8080

    8080�|�[�g���g�p���Ă���v���Z�X�̏���\�����܂��B
#>
Param (
    [Parameter(Mandatory=$true, Position=0, HelpMessage="�|�[�g�ԍ����w�肵�Ă�������")]
    [ValidateScript({
        # $port �� '--help' �܂��� '/?' ���ǂ������m�F����
        if ($_ -eq '--help' -or $_ -eq '/?') {
            return $true
        }

        # ���l�ɕϊ����A0 ���� 65535 �͈̔͂ɂ��邩�ǂ������m�F����
        $port = [UInt16]$_
        if ($port -ge 0 -and $port -le 65535) {
            return $true
        }

        # �͈͊O�̏ꍇ�̓G���[���X���[����
        throw "�s���ȃ|�[�g�ԍ�: $_"
    })]
    [string]$port
)

# �w���v��\������
if ($port -eq '--help' -or $port -eq '/?'-or $port -eq '!?') {
    Get-Help $MyInvocation.InvocationName -Examples
    return
}

# �w�肳�ꂽ�|�[�g�ԍ����g�p���Ă��邩�ǂ������m�F����
# �g�p����Ă��Ȃ��|�[�g�ɂ��Ă����Ȃ�v���Z�XID���擾���悤�Ƃ���ƃG���[�ɂȂ�̂ŁA��Ɏg�p�̗L�����m�F����
$isUsedPort = (Get-NetTCPConnection | Where-Object LocalPort -eq $port)
if ($isUsedPort -eq $null) {
    Write-Host "$port �|�[�g�͎g�p����Ă��܂���"
    Exit 0
}

# �w�肳�ꂽ�|�[�g�ԍ����g�p���Ă���v���Z�XID���擾����
$pidL = (Get-NetTCPConnection -LocalPort $port).OwningProcess
if ($pidL -eq $null) {
    Write-Host "$port �|�[�g���g�p���Ă���v���Z�X�͂���܂���"
    Exit 0
}

# �v���Z�X���s�t�@�C���̖��O���擾����
$processName = (Get-Process -Id $pidL).Path

Write-Host "�v���Z�XID: $pidL"
Write-Host "�v���Z�X��: $processName"

# �v���Z�X���T�[�r�X�ł��邩�ǂ������m�F����
$service = Get-WmiObject -Class Win32_Service | Where-Object { $_.PathName -eq $processName }

if ($service -ne $null) {
    Write-Host "�T�[�r�X��: $( $service.Name )"
} else {
    Write-Host "�T�[�r�X�ł͂���܂���"
}
