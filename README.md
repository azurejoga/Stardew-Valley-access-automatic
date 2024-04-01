### Automation of Mod Installation for Accessibility in Stardew Valley for the blind and visually impaired

This script is a mod installation automation tool to add accessibility to the Stardew Valley game. In addition to configuring accessibility mods, the script also installs [SMAPI](smapi.io) (Stardew Modding API), an essential mod loader to ensure correct functioning of mods in the game. It simplifies the entire installation process, allowing visually impaired players to fully enjoy the gaming experience.
## What does the script do?
1. download and extract SMAPI, if you have already downloaded it, just run the .bat, you can skip this installation step.
2. Configure the mods folder. Asks the user what the mod folder is for installing [stardew-access](https://github.com/khanshoaib3/stardew-access) and [project fluent](https://github.com/projectfluent) Alternatively : if the folder does not open, use alt + tabe to find the window and set the folder.
3. Download, extract, and move all the necessary mods to the Stardew Valley mods folder you chose.
4. Run the game after installing.
5. Create desktop shortcut and enable achievements

## Important...
After you install the game on Steam, run it at least once so that all changes take effect later after running the script. You need to run the game at least once, otherwise it won't work.

### Main Features

- **Automated Accessibility Mod Installation**: The script automatically downloads and installs mods needed to improve accessibility in Stardew Valley, such as Project Fluent and Stardew Access, which offer specific features for the visually impaired, such as reader compatibility NVDA screen, sound radar and much more!.

- **SMAPI Installation**: The script also installs SMAPI, a tool that allows you to load and manage third-party mods in Stardew Valley. SMAPI is essential to ensure that mods work correctly and do not conflict with each other.

- **Ease of Use**: With a few simple executions, the script configures the game environment with the necessary mods and SMAPI, without the need for complex manual intervention by the user.

- **Compatibility and Customization**: The script is designed to be flexible and compatible with different system configurations. It allows users to choose the installation directory for mods and offers the possibility to customize the installation as desired.

### How to use
There are two ways to use the script
* You can download the source code from github below or use a command that will do the entire process for you, more details below.

#### Execution

# important 2.
If you download the script from the repository, you cannot run the script by clicking: run with powershell in file explorer as the script policy is not enabled to support script execution.
To enable script execution, do the following.
1. open powershell and type the following command to enable the policy
```
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted -Force;
```
if the terminal output is blank/empty, it is working

# instalation metodes
1. **Downloading the Source Code from GitHub**:
   - Download the source code from this repository [here](https://codeload.github.com/azurejoga/Stardew-Valley-access-automatic/zip/refs/heads/main).
   - Navigate to the directory where the `stardew-languages.ps1` file was downloaded.
   - Run the script by clicking on the `stardew-languages.ps1` file with the applications key on your keyboard and running with PowerShell or through PowerShell with the command `.\stardew-languages.ps1`.

2.**Running the Script without needing to download**
   - Open PowerShell.
   - Run the following command:

     ```powershell
```
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted -Force ; Invoke-Expression (Invoke-WebRequest -Uri "https://github.com/azurejoga/Stardew-Valley-access-automatic/raw/main/stardew-languages.ps1" -UseBasicParsing).Content
```

   This will automatically download and run the script without having to download it from github itself.

#### Observation:
- Make sure you have an internet connection while running the script as it downloads mods directly from online repositories.

### Contributions

Contributions are welcome! If you have ideas for improvements or fixes, feel free to open an issue or submit a pull request to this repository.

### Thanks

This script was created with the intention of making installing mods and SMAPI in Stardew Valley more accessible for the visually impaired. We thank the community for their contributions and feedback that helped improve this project.

### License

This project is licensed under the [MIT License](https://github.com/azurejoga/Stardew-Valley-access-automatic/blob/main/LICENSE). Feel free to use and modify it as needed.