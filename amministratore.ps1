Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.DirectoryServices.AccountManagement

# Variabili di controllo
$global:authSuccess = $false
$script:attempts = 0
$script:maxAttempts = 3

# Crea la finestra principale
$form = New-Object System.Windows.Forms.Form
$form.Text = "Controllo account utente - Richiesta da: Sistema"
$form.Size = New-Object System.Drawing.Size(520, 280)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.MinimizeBox = $false
$form.BackColor = [System.Drawing.Color]::White
$form.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("C:\Windows\System32\user32.dll")
$form.KeyPreview = $true
$form.ControlBox = $false
$form.TopMost = $true
$form.ShowInTaskbar = $true

# === BLOCCA TUTTE LE VIE DI CHIUSURA ===

# 1. Blocca ALT+F4
$form.Add_KeyDown({
    if ($_.Alt -and $_.KeyCode -eq "F4") {
        $_.SuppressKeyPress = $true
        [System.Windows.Forms.MessageBox]::Show(
            "❌ NON PUOI CHIUDERE QUESTA FINESTRA!`n`nDevi inserire le credenziali amministrative per continuare.",
            "Accesso Obbligatorio",
            "OK",
            "Error"
        )
    }
})

# 2. Blocca la chiusura con la X (già rimosso ControlBox)
$form.Add_FormClosing({
    $_.Cancel = $true
    [System.Windows.Forms.MessageBox]::Show(
        "❌ NON PUOI CHIUDERE QUESTA FINESTRA!`n`nL'autenticazione è OBBLIGATORIA per continuare.",
        "Accesso Obbligatorio",
        "OK",
        "Error"
    )
})

# 3. Blocca la chiusura con il tasto ESC (previene la chiusura del dialog)
$form.CancelButton = $null  # Rimuove il pulsante di cancellazione predefinito

# Pannello superiore (blu come UAC)
$topPanel = New-Object System.Windows.Forms.Panel
$topPanel.Size = New-Object System.Drawing.Size(520, 70)
$topPanel.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 215)
$topPanel.Location = New-Object System.Drawing.Point(0, 0)
$form.Controls.Add($topPanel)

# Icona scudo
$shieldIcon = New-Object System.Windows.Forms.PictureBox
$shieldIcon.Size = New-Object System.Drawing.Size(52, 52)
$shieldIcon.Location = New-Object System.Drawing.Point(18, 10)
$shieldIcon.SizeMode = "StretchImage"
try {
    $shieldIcon.Image = [System.Drawing.Icon]::ExtractAssociatedIcon("C:\Windows\System32\imageres.dll").ToBitmap()
} catch {
    $shieldIcon.BackColor = [System.Drawing.Color]::Transparent
}
$topPanel.Controls.Add($shieldIcon)

# Titolo
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "AUTENTICAZIONE OBBLIGATORIA"
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$titleLabel.ForeColor = [System.Drawing.Color]::White
$titleLabel.Location = New-Object System.Drawing.Point(85, 14)
$titleLabel.AutoSize = $true
$topPanel.Controls.Add($titleLabel)

# Sottotitolo
$subTitleLabel = New-Object System.Windows.Forms.Label
$subTitleLabel.Text = "Inserisci le credenziali di un amministratore per continuare"
$subTitleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$subTitleLabel.ForeColor = [System.Drawing.Color]::FromArgb(220, 220, 220)
$subTitleLabel.Location = New-Object System.Drawing.Point(85, 40)
$subTitleLabel.AutoSize = $true
$topPanel.Controls.Add($subTitleLabel)

# Separatore
$separator = New-Object System.Windows.Forms.Label
$separator.Text = ""
$separator.BorderStyle = "Fixed3D"
$separator.Location = New-Object System.Drawing.Point(0, 70)
$separator.Size = New-Object System.Drawing.Size(520, 2)
$form.Controls.Add($separator)

# Etichetta nome utente
$userLabel = New-Object System.Windows.Forms.Label
$userLabel.Text = "Nome utente:"
$userLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$userLabel.Location = New-Object System.Drawing.Point(25, 95)
$userLabel.AutoSize = $true
$form.Controls.Add($userLabel)

# Campo nome utente
$userBox = New-Object System.Windows.Forms.TextBox
$userBox.Text = [System.Environment]::UserName
$userBox.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$userBox.Location = New-Object System.Drawing.Point(140, 92)
$userBox.Size = New-Object System.Drawing.Size(345, 23)
$userBox.ReadOnly = $false
$userBox.BackColor = [System.Drawing.Color]::White
$userBox.TabIndex = 0
$form.Controls.Add($userBox)

# Etichetta password
$passLabel = New-Object System.Windows.Forms.Label
$passLabel.Text = "Password:"
$passLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$passLabel.Location = New-Object System.Drawing.Point(25, 130)
$passLabel.AutoSize = $true
$form.Controls.Add($passLabel)

# Campo password
$passBox = New-Object System.Windows.Forms.TextBox
$passBox.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$passBox.Location = New-Object System.Drawing.Point(140, 127)
$passBox.Size = New-Object System.Drawing.Size(345, 23)
$passBox.PasswordChar = "●"
$passBox.TabIndex = 1
$form.Controls.Add($passBox)

# Checkbox "Mostra password"
$showPassCheck = New-Object System.Windows.Forms.CheckBox
$showPassCheck.Text = "Mostra password"
$showPassCheck.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$showPassCheck.Location = New-Object System.Drawing.Point(140, 156)
$showPassCheck.AutoSize = $true
$showPassCheck.TabIndex = 2
$showPassCheck.Add_CheckedChanged({
    if ($showPassCheck.Checked) {
        $passBox.PasswordChar = $null
    } else {
        $passBox.PasswordChar = "●"
    }
})
$form.Controls.Add($showPassCheck)

# Label tentativi
$attemptsLabel = New-Object System.Windows.Forms.Label
$attemptsLabel.Text = "Tentativo 0 di $script:maxAttempts"
$attemptsLabel.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$attemptsLabel.ForeColor = [System.Drawing.Color]::Gray
$attemptsLabel.Location = New-Object System.Drawing.Point(140, 178)
$attemptsLabel.AutoSize = $true
$form.Controls.Add($attemptsLabel)

# Solo pulsante OK (NESSUN pulsante Annulla)
$okButton = New-Object System.Windows.Forms.Button
$okButton.Text = "VERIFICA CREDENZIALI"
$okButton.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$okButton.Size = New-Object System.Drawing.Size(180, 40)
$okButton.Location = New-Object System.Drawing.Point(305, 200)
$okButton.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 215)
$okButton.ForeColor = [System.Drawing.Color]::White
$okButton.FlatStyle = "Flat"
$okButton.TabIndex = 3
$okButton.Add_MouseEnter({
    $okButton.BackColor = [System.Drawing.Color]::FromArgb(0, 100, 195)
})
$okButton.Add_MouseLeave({
    $okButton.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 215)
})
$form.Controls.Add($okButton)

# Gestisci il tasto Enter
$form.AcceptButton = $okButton

# Focus iniziale
$form.Add_Shown({
    $passBox.Focus()
})

# Funzione di autenticazione
function Test-Authentication {
    param($username, $password)
    
    $script:attempts++
    $attemptsLabel.Text = "Tentativo $script:attempts di $script:maxAttempts"
    
    try {
        $context = New-Object System.DirectoryServices.AccountManagement.PrincipalContext(
            [System.DirectoryServices.AccountManagement.ContextType]::Machine
        )
        
        if ($context.ValidateCredentials($username, $password)) {
            # CREDENZIALI VALIDE!
            $global:authSuccess = $true
            [System.Windows.Forms.MessageBox]::Show(
                "✅ AUTENTICAZIONE RIUSCITA!`n`nAccesso consentito a: $username",
                "Benvenuto",
                "OK",
                "Information"
            )
            $form.DialogResult = [System.Windows.Forms.DialogResult]::OK
            $form.Close()
            return $true
        } else {
            # CREDENZIALI NON VALIDE
            if ($script:attempts -ge $script:maxAttempts) {
                [System.Windows.Forms.MessageBox]::Show(
                    "❌ TROPPI TENTATIVI FALLITI ($script:maxAttempts)!`n`nIl sistema si bloccherà per 30 secondi per motivi di sicurezza.",
                    "ACCESSO NEGATO",
                    "OK",
                    "Error"
                )
                # Blocca il sistema per 30 secondi
                $okButton.Enabled = $false
                $okButton.Text = "SISTEMA BLOCCATO - ATTENDERE..."
                $okButton.BackColor = [System.Drawing.Color]::Red
                
                for ($i = 30; $i -ge 1; $i--) {
                    $attemptsLabel.Text = "Sistema bloccato - $i secondi rimanenti..."
                    [System.Windows.Forms.Application]::DoEvents()
                    Start-Sleep -Seconds 1
                }
                
                # Reset
                $script:attempts = 0
                $okButton.Enabled = $true
                $okButton.Text = "VERIFICA CREDENZIALI"
                $okButton.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 215)
                $attemptsLabel.Text = "Tentativo 0 di $script:maxAttempts"
                [System.Windows.Forms.MessageBox]::Show(
                    "⏱️ Sistema sbloccato. Puoi riprovare.",
                    "Riprova",
                    "OK",
                    "Information"
                )
                $passBox.Text = ""
                $passBox.Focus()
            } else {
                [System.Windows.Forms.MessageBox]::Show(
                    "❌ CREDENZIALI NON VALIDE!`n`nRimangono $($script:maxAttempts - $script:attempts) tentativi.",
                    "Errore",
                    "OK",
                    "Warning"
                )
                $passBox.Text = ""
                $passBox.Focus()
            }
            return $false
        }
    } catch {
        [System.Windows.Forms.MessageBox]::Show(
            "⚠️ Errore: $_",
            "Errore di sistema",
            "OK",
            "Error"
        )
        return $false
    }
}

# Evento click OK
$okButton.Add_Click({
    if ([string]::IsNullOrWhiteSpace($passBox.Text)) {
        [System.Windows.Forms.MessageBox]::Show(
            "⚠️ DEVI INSERIRE LA PASSWORD!`n`nL'autenticazione è OBBLIGATORIA.",
            "Password Richiesta",
            "OK",
            "Warning"
        )
        $passBox.Focus()
        return
    }
    
    # Disabilita il pulsante durante la verifica
    $okButton.Enabled = $false
    $okButton.Text = "VERIFICA IN CORSO..."
    
    # Esegui autenticazione
    $result = Test-Authentication -username $userBox.Text -password $passBox.Text
    
    # Riabilita il pulsante (se non è stato chiuso)
    if ($okButton.Enabled -eq $false) {
        $okButton.Enabled = $true
        $okButton.Text = "VERIFICA CREDENZIALI"
    }
})

# === BLOCCA ANCHE LA CHIUSURA DALLA FINESTRA DI DIALOGO ===

# Sovrascrivi il metodo Dispose per evitare chiusure accidentali
$form.Add_Disposed({
    if (-not $global:authSuccess) {
        # Se la finestra viene chiusa senza successo, riapri una nuova
        Write-Host "Tentativo di chiusura non autorizzato!" -ForegroundColor Red
        [System.Windows.Forms.MessageBox]::Show(
            "NON PUOI CHIUDERE QUESTA FINESTRA!`n`nRiavvio del processo di autenticazione...",
            "ACCESSO OBBLIGATORIO",
            "OK",
            "Error"
        )
        # Riapri la finestra
        & $MyInvocation.MyCommand.Path
    }
})

# Mostra la finestra - BLOCCANTE
$result = $form.ShowDialog()

# Se l'autenticazione ha avuto successo
if ($global:authSuccess) {
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "✅ AUTENTICAZIONE COMPLETATA!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "Utente: $($userBox.Text)" -ForegroundColor Yellow
    Write-Host "========================================`n" -ForegroundColor Cyan
    
    # === QUI INSERISCI IL TUO CODICE CHE RICHIEDE PRIVILEGI ===
    Write-Host "Esecuzione del programma con privilegi amministrativi..." -ForegroundColor Green
    
    # Esempio: Esegui qualcosa con privilegi admin
    # Start-Process -FilePath "C:\Windows\System32\cmd.exe" -Verb RunAs
    
    Write-Host "`nProgramma eseguito con successo!" -ForegroundColor Green
    
} else {
    # Se la finestra è stata chiusa in qualche modo (non dovrebbe succedere)
    Write-Host "`n========================================" -ForegroundColor Red
    Write-Host "❌ AUTENTICAZIONE FALLITA" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "Il programma non può continuare senza autenticazione!" -ForegroundColor Yellow
    Write-Host "========================================`n" -ForegroundColor Red
}

# Pausa
Read-Host "`nPremi INVIO per terminare"