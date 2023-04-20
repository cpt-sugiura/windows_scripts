<#
.SYNOPSIS
    �X�P�W���[������Ă���^�X�N���ꗗ�\�����܂�
#>

# �^�X�N�����s�\������Ń\�[�g
$tasks = Get-ScheduledTask | ForEach-Object {
    $task = $_
    $taskTrigger = $task.Triggers | Where-Object { $_.Enabled -eq $true } | Sort-Object -Property StartBoundary | Select-Object -First 1
    if ($taskTrigger)
    {
        $taskInfo = [PSCustomObject]@{
            TaskName = $task.TaskName
            TaskDescription = $task.Description
            ScheduledTime = $taskTrigger.StartBoundary
        }
        $taskInfo
    }
} | Sort-Object -Property ScheduledTime

# �^�X�N���Ɛ����Ǝ��s�\�������\��
$tasks | Format-Table -Property TaskName, ScheduledTime, TaskDescription
