If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    Exit	
  }

  
#define hash tables with setting names
$accounts = @{
'Access work or school' =	'workplace'
'Email & app accounts' =	'emailandaccounts'
'Other Users' =	'otherusers'
'Family' = 'family-group'
'Set up a kiosk' =	'assignedaccess'
'Sign-in options' =	'signinoptions'
'Sync your settings' =	'sync'
'Windows Hello setup' =	'signinoptions-launchfaceenrollment'
'Your info'	= 'yourinfo'
}
$Apps = @{
  'Apps & Features' = 'appsfeatures'
    'Apps for websites' = 'appsforwebsites'
    'Default apps' = 'defaultapps'
    'Default browser settings' = 'defaultbrowsersettings'
    'Manage optional features' = 'optionalfeatures'
    'Offline Maps' = 'maps'
    'Download Maps' = 'maps-downloadmaps'
    'Startup apps' = 'startupapps'
    'Video playback' = 'videoplayback'
}
$Devices = @{
  'AutoPlay' = 'autoplay'
    'Bluetooth' = 'bluetooth'
    'Connected Devices' = 'connecteddevices'
    'Camera settings' = 'camera'
    'Mouse & touchpad' = 'mousetouchpad'
    'Pen & Windows Ink' = 'pen'
    'Printers & scanners' = 'printers'
    'Touch' = 'devices-touch'
    'Touchpad' = 'devices-touchpad'
    'Text Suggestions' = 'devicestyping-hwkbtextsuggestions'
    'Typing' = 'typing'
    'USB' = 'usb'
    'Wheel' = 'wheel'
    'Your phone' = 'mobile-devices'
}
$Easeofaccess = @{
  'Audio' = 'easeofaccess-audio'
    'Closed captions' = 'easeofaccess-closedcaptioning'
    'Color filters' = 'easeofaccess-colorfilter'
    'Adaptive color link' = 'easeofaccess-colorfilter-adaptivecolorlink'
    'Blue light link' = 'easeofaccess-colorfilter-bluelightlink'
    'Display' = 'easeofaccess-display'
    'Eye control' = 'easeofaccess-eyecontrol'
    'Fonts' = 'fonts'
    'High contrast' = 'easeofaccess-highcontrast'
    'Keyboard' = 'easeofaccess-keyboard'
    'Magnifier' = 'easeofaccess-magnifier'
    'Mouse' = 'easeofaccess-mouse'
    'Mouse pointer & touch' = 'easeofaccess-mousepointer'
    'Narrator' = 'easeofaccess-narrator'
    'Narrator autostart' = 'easeofaccess-narrator-isautostartenabled'
    'Speech' = 'easeofaccess-speechrecognition'
    'Text cursor' = 'easeofaccess-cursor'
    'Visual Effects' = 'easeofaccess-visualeffects'
}
$Gaming = @{
  'Game bar' = 'gaming-gamebar'
    'Game DVR' = 'gaming-gamedvr'
    'Game Mode' = 'gaming-gamemode'
    'Playing a game full screen' = 'quietmomentsgame'
}
$Networkandinternet = @{
  'Network & internet' = 'network-status'
    'Advanced settings' = 'network-advancedsettings'
    'Airplane mode' = 'network-airplanemode'
    'Proximity' = 'proximity'
    'Cellular & SIM' = 'network-cellular'
    'Dial-up' = 'network-dialup'
    'DirectAccess' = 'network-directaccess'
    'Ethernet' = 'network-ethernet'
    'Manage known networks' = 'network-wifisettings'
    'Mobile hotspot' = 'network-mobilehotspot'
    'Proxy' = 'network-proxy'
    'VPN' = 'network-vpn'
    'Wi-Fi' = 'network-wifi'
    'Wi-Fi provisioning' = 'wifi-provisioning'
}
$Personalization = @{
  'Background' = 'personalization-background'
    'Choose which folders appear on Start' = 'personalization-start-places'
    'Colors' = 'personalization-colors'
    'Additional colors' = 'colors'
    'Customize Copilot key on keyboard' = 'personalization-textinput-copilot-hardwarekey'
    'Dynamic Lighting' = 'personalization-lighting'
    'Lock screen' = 'lockscreen'
    'Personalization (category)' = 'personalization'
    'Start' = 'personalization-start'
    'Taskbar' = 'taskbar'
    'Text input' = 'personalization-textinput'
    'Touch Keyboard' = 'personalization-touchkeyboard'
    'Themes' = 'themes'
}
$Phone = @{
  'Your phone' = 'mobile-devices'
    'Add phone' = 'mobile-devices-addphone'
    'Device Usage' = 'deviceusage'
}
$Privacy = @{
  'Account info' = 'privacy-accountinfo'
    'Activity history' = 'privacy-activityhistory'
    'App diagnostics' = 'privacy-appdiagnostics'
    'Automatic file downloads' = 'privacy-automaticfiledownloads'
    'Background Apps' = 'privacy-backgroundapps'
    'Calendar' = 'privacy-calendar'
    'Call history' = 'privacy-callhistory'
    'Camera' = 'privacy-webcam'
    'Contacts' = 'privacy-contacts'
    'Documents' = 'privacy-documents'
    'Downloads folder' = 'privacy-downloadsfolder'
    'Email' = 'privacy-email'
    'Feedback & diagnostics' = 'privacy-feedback'
    'File system' = 'privacy-broadfilesystemaccess'
    'General' = 'privacy-general'
    'Graphics capture programmatic' = 'privacy-graphicscaptureprogrammatic'
    'Graphics capture without border' = 'privacy-graphicscapturewithoutborder'
    'Inking & typing' = 'privacy-speechtyping'
    'Location' = 'privacy-location'
    'Messaging' = 'privacy-messaging'
    'Microphone' = 'privacy-microphone'
    'Motion' = 'privacy-motion'
    'Music Library' = 'privacy-musiclibrary'
    'Notifications' = 'privacy-notifications'
    'Other devices' = 'privacy-customdevices'
    'Phone calls' = 'privacy-phonecalls'
    'Pictures' = 'privacy-pictures'
    'Radios' = 'privacy-radios'
    'Speech' = 'privacy-speech'
    'Tasks' = 'privacy-tasks'
    'Videos' = 'privacy-videos'
    'Voice activation' = 'privacy-voiceactivation'
}
$Search = @{
  'Search' = 'search'
  'Search more details' = 'search-moredetails'
  'Search Permissions' = 'search-permissions'
}
$Sound = @{
  'Volume mixer' = 'apps-volume'
    'Sound' = 'sound'
    'Sound devices' = 'sound-devices'
    'Default microphone' = 'sound-defaultinputproperties'
    'Default audio output' = 'sound-defaultoutputproperties'
}
$System = @{
'About' = 'about'
'Advanced display settings' = 'display-advanced'
'Battery Saver' = 'batterysaver'
'Battery Saver settings' = 'batterysaver-settings'
'Battery use' = 'batterysaver-usagedetails'
'Clipboard' = 'clipboard'
'Display' = 'display'
'Default Save Locations' = 'savelocations'
'Screen rotation' = 'screenrotation'
'Duplicating my display' = 'quietmomentspresentation'
'During these hours' = 'quietmomentsscheduled'
'Encryption' = 'deviceencryption'
'Energy recommendations' = 'energyrecommendations'
'Focus assist' = 'quiethours'
'Graphics Settings' = 'display-advancedgraphics'
'Graphics Default Settings' = 'display-advancedgraphics-default'
'Multitasking' = 'multitasking'
'Multitasking SG Update' = 'multitasking-sgupdate'
'Night light settings' = 'nightlight'
'Projecting to this PC' = 'project'
'Shared experiences' = 'crossdevice'
'Taskbar' = 'taskbar'
'Notifications & actions' = 'notifications'
'Remote Desktop' = 'remotedesktop'
'Power & sleep' = 'powersleep'
'Presence sensing' = 'presence'
'Storage' = 'storagesense'
'Storage Sense' = 'storagepolicies'
'Storage recommendations' = 'storagerecommendations'
'Disks & volumes' = 'disksandvolumes'
}
$Timeandlanguage = @{
'Date & time' = 'dateandtime'
'Region' =	'regionformatting'
'Language' =	'keyboard'
'Add display language' =	'regionlanguage-adddisplaylanguage'
'Language options' =	'regionlanguage-languageoptions'
'Set display language' =	'regionlanguage-setdisplaylanguage'
'Speech' =	'speech'
}
$Updateandsecurity = @{
  'Activation' = 'activation'
  'Backup' = 'backup' 
  'Delivery Optimization' =	'delivery-optimization'
  'Find My Device' = 'findmydevice'
  'For developers' = 'developers'
  'Recovery' = 'recovery'
  'Launch Security Key Enrollment' = 'signinoptions-launchsecuritykeyenrollment'
  'Troubleshoot' = 'troubleshoot'
  'Windows Security' = 'windowsdefender'
  'Windows Insider Program' =	'windowsinsider'
  'Windows Update' = 'windowsupdate'
  'Windows Update-Active hours' =	'windowsupdate-activehours'
  'Windows Update-Advanced options' =	'windowsupdate-options'
  'Windows Update-Optional updates' =	'windowsupdate-optionalupdates'
  'Windows Update-Restart options' = 'windowsupdate-restartoptions'
  'Windows Update-Seeker on demand' =	'windowsupdate-seekerondemand'
  'Windows Update-View update history' = 'windowsupdate-history'
}

$homePage = @{
  'Home' = 'home'
}

$Global:regKey = 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer'
 
 $Global:pages = @{
  'Accounts' = $accounts;
  'Apps' = $apps;
  'Devices' = $Devices;
  'Ease of Access' = $Easeofaccess;
  'Gaming' = $Gaming;
  'Network and Internet' = $Networkandinternet;
  'Personalization' = $Personalization;
  'Phone' = $Phone;
  'Privacy' = $Privacy;
  'Search' = $Search;
  'Sound' = $Sound;
  'System' = $System;
  'Time and Language' = $Timeandlanguage;
  'Update and Security' = $Updateandsecurity
  'Home' = $homePage
}


Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

# Create the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Hide Pages in Settings"
$form.Width = 600
$form.Height = 400
$form.BackColor = [System.Drawing.Color]::FromArgb(20, 20, 20) 

# Create the TreeView
$treeView = New-Object System.Windows.Forms.TreeView
$treeView.CheckBoxes = $true
$treeView.Dock = [System.Windows.Forms.DockStyle]::Fill
$treeView.BackColor = [System.Drawing.Color]::FromArgb(20, 20, 20) 
$treeView.ForeColor = [System.Drawing.Color]::White 
$form.Controls.Add($treeView)

# Populate the TreeView
foreach ($page in $pages.Keys) {
    $Global:pageNode = $treeView.Nodes.Add($page)
    $pageNode.Checked = $false
    $pageNode.ForeColor = [System.Drawing.Color]::White 

    $hashTable = $pages[$page]
    foreach ($key in $hashTable.Keys) {
        $Global:childNode = $pageNode.Nodes.Add($key)
        $childNode.Tag = $hashTable[$key]
        $childNode.Checked = $false
        $childNode.ForeColor = [System.Drawing.Color]::White 
    }
}

$treeView.add_AfterCheck({
  param($sender, $e)
  
  if ($e.Node.Nodes.Count -gt 0 -and $e.Node.Checked) {
      foreach ($childNode in $e.Node.Nodes) {
          $childNode.Checked = $true
      }
  }
  elseif ($e.Node.Nodes.Count -gt 0 -and -not $e.Node.Checked) {
      foreach ($childNode in $e.Node.Nodes) {
          $childNode.Checked = $false
      }
  }
})


$saveButton = New-Object System.Windows.Forms.Button
$saveButton.Size = New-Object Drawing.Size(300,40)
$saveButton.Text = "Save Settings"
$saveButton.ForeColor = 'White'
$saveButton.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
$saveButton.Dock = [System.Windows.Forms.DockStyle]::Bottom
$form.Controls.Add($saveButton)

$resetbutton = New-Object System.Windows.Forms.Button
$resetbutton.Size = New-Object Drawing.Size(300,40)
$resetbutton.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
$resetbutton.Text = "Reset"
$resetbutton.ForeColor = 'White'
$resetbutton.Dock = [System.Windows.Forms.DockStyle]::Bottom
$form.Controls.Add($resetbutton)

$resetbutton.add_Click({
  Write-Host 'Resetting Settings...' -ForegroundColor Red
  Reg.exe delete $regKey /v "SettingsPageVisibility" /f *>$null
  #uncheck all options
  foreach ($pageNode in $treeView.Nodes) {
    $pageNode.Checked = $false
    foreach ($childNode in $pageNode.Nodes) {
        $childNode.Checked = $false
    }
}
})


$saveButton.add_Click({
$keyPropString = "hide:"
$pageNode = $treeView.Nodes
    foreach ($childNode in $pageNode.Nodes) {
      # Check if the child node is checked
      if ($childNode.Checked) {
          Write-Host "Hiding $($childNode.Tag)" -ForegroundColor Green
          $keyPropString += "$($childNode.Tag);"
      }
  }
  #apply key
    Reg.exe add $regKey /v "SettingsPageVisibility" /t REG_SZ /d $keyPropString /f >$null
})


$form.ShowDialog() | Out-Null 
