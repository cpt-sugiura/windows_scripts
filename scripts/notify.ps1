# �������󂯎��
$notificationTitle = $args[0]
$notificationMessage = $args[1]

# NotifyIcon�I�u�W�F�N�g���쐬
Add-Type -AssemblyName System.Windows.Forms
$notification = New-Object System.Windows.Forms.NotifyIcon

# �A�C�R����ݒ�
$notification.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon((Get-Command powershell).Path)

# �o���[�� �`�b�v�̓��e��ݒ�
$notification.BalloonTipTitle = $notificationTitle
$notification.BalloonTipText = $notificationMessage
$notification.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info

# �o���[�� �`�b�v��\�����Ēʒm���s��
$notification.Visible = $true
# 5000�~���b�\��
$notification.ShowBalloonTip(5000)
