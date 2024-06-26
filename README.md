# My windows dotfiles (currently using PowerShell & batch script)

<div align=center>
<table>
  <tr>
    <td align=center colspan=6>Table of Contents</td>
  </tr>
  <tr><td>

  [<kbd> <br> Changelog <br><br> </kbd>](CHANGELOG.md)</td><td>
  [<kbd> <br> Apps install script <br><br> </kbd>](#app-install-script)</td><td>
  [<kbd> <br> Requirements <br><br> </kbd>](#requirements)</td><td>
  [<kbd> <br> App list (outdated) <br><br> </kbd>](#app-list-outdated)</td><td>
  [<kbd> <br> Hotkey script (outdated) <br><br> </kbd>](#hotkey-script-outdated)</td><td>
  [<kbd> <br> Hotkey list <br><br> </kbd>](#hotkey-list)</td>

  </td></tr>
</table>
</div>

***This repo is currently being refactored***

## See [Changelog](CHANGELOG.md)

***

## To do list

- [ ] use `gsudo` to isolate elivatation on certain script blocks ()
- [x] add env PATH (spotify, etc..)
- [x] get ideas from [ChrisTitusTech&#39;s powershell-profile](https://github.com/ChrisTitusTech/powershell-profile/)
- [x] (experimental) use winget installed package list and automate from there (including the [App list (outdated)](#app-list-outdated) below).
- [x] add useful powershell modules (PSFzf, WinGetCommandNotFound, etc...)
- [x] add terminal icons
- [ ] fix spicetify current_theme error
- [ ] replace AHK script with python
- [ ] add GlazeWM
- [ ] refactor README layout
- [ ] install & run the script will powershell 7

***

## Clone the repo

using `git`

```shell
git clone https://github.com/devckvargas/dotfiles-windows.git
```

using `github cli`

```shell
gh repo clone devckvargas/dotfiles-windows
```

***

## App install script

Usage:

```shell
.\install_apps.ps1
```

### Requirements

- **Internet connection**
- **PowerShell**
- **Admin rights**

### App list (outdated)

<table>
<!--? Choco Apps -->
  <tr>
    <td align=center><code>Chocolatey</code></td>
    <td align=center colspan=2><code>Winget</code></td>
  </tr>
  <td>
    <table>
      <tr><td>Winget-CLI</td></tr>
      <tr><td>Eartrumpet (Volume Control)</td></tr>
      <tr><td>Traffic-Monitor (Network Speed monitor)</td></tr>
      <tr><td>.NET Runtimes</td></tr>
      <tr><td>Visual C++ Runtimes</td></tr>
      <tr><td>winfetch</td></tr>
      <tr><td>Open Audio Library (openal)</td></tr>
      <tr><td>Spicetify-Marketplace</td></tr>
      <tr><td align=center><b>Fonts</b></td></tr>
      <tr><td>JetBrainsMono Nerd Font</td></tr>
      <tr><td>Arimo Nerd Font</td></tr>
      <tr><td>Meslo Nerd Font</td></tr>
    </table>
  </td>
<!--? Winget Dev Apps -->
  <td>
    <table>
      <tr><td align=center><b>Dev Apps</b></td></tr>
      <tr><td>Git</td></tr>
      <tr><td>Github CLI</td></tr>
      <tr><td>Github Desktop</td></tr>
      <tr><td>Terminal</td></tr>
      <tr><td>NodeJS</td></tr>
      <tr><td>Powershell</td></tr>
      <tr><td>Java (JDK18)</td></tr>
      <tr><td>VSCode</td></tr>
      <tr><td>Figma</td></tr>
      <tr><td>ImageMagick</td></tr>
      <tr><td>Responsively App</td></tr>
      <tr><td>Visual C++ Redist Runtimes 2015-2022</td></tr>
      <tr><td>Microsoft XNA Framework Redist (Refresh)</td></tr>
    </table>
  </td>
<!--? Winget Apps -->
  <td>
    <table>
      <tr><td align=center><b>Apps</b></td></tr>
      <tr><td>7-Zip</td></tr>
      <tr><td>Afterburner</td></tr>
      <tr><td>AltSnap</td></tr>
      <tr><td>Anydesk</td></tr>
      <tr><td>AutoHotKey</td></tr>
      <tr><td>Capcut</td></tr>
      <tr><td>Caprine(Facebook Messenger)</td></tr>
      <tr><td>Canva</td></tr>
      <tr><td>CPU-Z</td></tr>
      <tr><td>Discord</td></tr>
      <tr><td>f.lux</td></tr>
      <tr><td>Free Download Manager</td></tr>
      <tr><td>GPU-Z</td></tr>
      <tr><td>Handbrake</td></tr>
      <tr><td>K-lite mega codec pack</td></tr>
      <tr><td>Microsoft To Do</td></tr>
      <tr><td>Facebook Messenger(MS Store)</td></tr>
      <tr><td>Megasync</td></tr>
      <tr><td>NextDNS Desktop</td></tr>
      <tr><td>Nilesoft Shell</td></tr>
      <tr><td>NVCleanstall</td></tr>
      <tr><td>OBS Studio</td></tr>
      <tr><td>Powertoys</td></tr>
      <tr><td>ShareX</td></tr>
      <tr><td>Speedtest-CLI</td></tr>
      <tr><td>Spicetify</td></tr>
      <tr><td>Spotify</td></tr>
      <tr><td>SuperF4</td></tr>
      <tr><td>TickTick</td></tr>
      <tr><td>Telegram</td></tr>
      <tr><td>VLC media player</td></tr>
      <tr><td>WinRAR</td></tr>
      <tr><td>WingetUI</td></tr>
    </table>
  </td>
</table>
<br><br>

***

### Restore settings script
>
> [!NOTE]
> The user will be prompted at the end of the install script

Or manually run it using

```shell
.\install_script.ps1
```

***

## Hotkey script (outdated)

Requirements

- **AutoHotKey(AHK)**
- **Admin rights**

### Hotkey list

<table>
  <td>
    <table>
      <th style="text-align: center;" colspan="2">Apps hotkey</th>
      <tr>
        <th>Keybind</th>
        <th>Description</th>
      </tr>
      <tr>
        <td><kbd>Super</kbd>+<kbd>B</kbd>
        <td>launch browser (msedge)</td></td>
      </tr>
      <tr>
        <td><kbd>Super</kbd>+<kbd>C</kbd>
        <td>launch code editor (vscode)</td></td>
      </tr>
      <tr>
        <td><kbd>Super</kbd>+<kbd>Enter</kbd>
        <td>launch terminal</td></td>
      </tr>
      <tr>
        <td><kbd>Super</kbd>+<kbd>NumpadEnter</kbd>
        <td>launch terminal</td></td>
      </tr>
    </table>
  </td>
</table>

<table>
  <td>
    <table>
      <th style="text-align: center;" colspan="2">Window hotkey</th>
      <tr>
        <th>Keybind</th>
        <th>Desciption</th>
      </tr>
      <tr>
        <td><kbd>Super</kbd>+<kbd>Q</kbd></td>
        <td>close active window</td>
      </tr>
        <td><kbd>Ctrl</kbd>+<kbd>Q</kbd></td>
        <td>close active window</td>
      </tr>
        <td><kbd>Super</kbd>+<kbd>F</kbd></td>
        <td>maximize active window</td>
      </tr>
        <td><kbd>Super</kbd>+<kbd>PgUp</kbd></td>
        <td>maximize active window</td>
      </tr>
        <td><kbd>Super</kbd>+<kbd>PgDn</kbd></td>
        <td>minimize active window</td>
      </tr>
    </table>
  </td>
</table>
