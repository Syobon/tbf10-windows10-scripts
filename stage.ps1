#�A�Z���u���ǂݍ���
Add-Type -Assembly Microsoft.VisualBasic
Add-Type -Assembly System.Windows.Forms
#�ϐ�������
$input_hostname = $null
#�ϐ����
$DirectoryName = "hoge.local"
#���[�U���̂݁@�h���C��FQDN�s�v�ł��B
$DomainJoinUser = "hoge"
$DomainJoinPassword = ConvertTo-SecureString -AsPlainText -Force "Hogeh0ge"
#sysprep�����t�@�C���Œǉ�����LocalAccounts
$username = "setupuser"
$password = "Passw0rd!"

#ipv6������
Get-NetAdapterBinding | ? {$_.DisplayName -match 'ipv6'} | Set-NetAdapterBinding -Enabled $false

#PC������
do {
    do {
        $input_hostname = [Microsoft.VisualBasic.Interaction]::InputBox("���̃R���s���[�^�̖��O����͂��Ă�������", "PC���̓���")
        #���͂��ꂽ�z�X�g�����󔒂��`�F�b�N
        $hostname_check = [String]::IsNullOrEmpty($input_hostname)
        if($hostname_check -eq "True") {
            [System.Windows.Forms.MessageBox]::Show("�R���s���[�^�������͂���Ă��܂���B�ēx���͂��Ă�������", "�R���s���[�^�����s���ł�", "OK", "Error","button1")
        }
    } while ($hostname_check -eq "True")
    #PC���m��m�F
    $hostname_confirm = [System.Windows.Forms.MessageBox]::Show("�R���s���[�^����" + $input_hostname + "�ł悢�ł����H", "�R���s���[�^���̊m�F", "YesNo", "Information","button1")
} while ($hostname_confirm -eq "No")

#�z�X�g���ύX�iReboot pending�j
Rename-Computer -NewName $input_hostname

#AD�Q��
$Credential = New-Object System.Management.Automation.PSCredential $DomainJoinUser, $DomainJoinPassword
Add-Computer -DomainName $DirectoryName -Credential $Credential -Force -Options JoinWithNewName,AccountCreate

#��Еt��
Remove-Item C:\work -Recurse
Restart-Computer -Force