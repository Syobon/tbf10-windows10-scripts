#アセンブリ読み込み
Add-Type -Assembly Microsoft.VisualBasic
Add-Type -Assembly System.Windows.Forms
#変数初期化
$input_hostname = $null
#変数代入
$DirectoryName = "hoge.local"
#ユーザ名のみ　ドメインFQDN不要です。
$DomainJoinUser = "hoge"
$DomainJoinPassword = ConvertTo-SecureString -AsPlainText -Force "Hogeh0ge"
#sysprep応答ファイルで追加したLocalAccounts
$username = "setupuser"
$password = "Passw0rd!"

#ipv6無効化
Get-NetAdapterBinding | ? {$_.DisplayName -match 'ipv6'} | Set-NetAdapterBinding -Enabled $false

#PC名入力
do {
    do {
        $input_hostname = [Microsoft.VisualBasic.Interaction]::InputBox("このコンピュータの名前を入力してください", "PC名の入力")
        #入力されたホスト名が空白かチェック
        $hostname_check = [String]::IsNullOrEmpty($input_hostname)
        if($hostname_check -eq "True") {
            [System.Windows.Forms.MessageBox]::Show("コンピュータ名が入力されていません。再度入力してください", "コンピュータ名が不正です", "OK", "Error","button1")
        }
    } while ($hostname_check -eq "True")
    #PC名確定確認
    $hostname_confirm = [System.Windows.Forms.MessageBox]::Show("コンピュータ名は" + $input_hostname + "でよいですか？", "コンピュータ名の確認", "YesNo", "Information","button1")
} while ($hostname_confirm -eq "No")

#ホスト名変更（Reboot pending）
Rename-Computer -NewName $input_hostname

#AD参加
$Credential = New-Object System.Management.Automation.PSCredential $DomainJoinUser, $DomainJoinPassword
Add-Computer -DomainName $DirectoryName -Credential $Credential -Force -Options JoinWithNewName,AccountCreate

#後片付け
Remove-Item C:\work -Recurse
Restart-Computer -Force