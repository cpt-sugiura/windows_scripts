<#
.SYNOPSIS
    スケジュールされているタスクを一覧表示します
#>

# タスクを実行予定日時でソート
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

# タスク名と説明と実行予定日時を表示
$tasks | Format-Table -Property TaskName, ScheduledTime, TaskDescription
