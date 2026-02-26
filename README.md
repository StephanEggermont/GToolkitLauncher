# Launcher and version manager for Glamorous Toolkit

GToolkitLauncher lets you keep several versions of Glamorous Toolkit around, and run each of them with ease. A bit like `pyenv` for python, or [rustup](https://rust-lang.github.io/rustup/) for Rust.  

## Installation

For Linux, MacOS (install-gtoolkit.sh) and Windows (install-gtoolkit.ps1) there are install scripts that
download the latest version of Glamorous Toolkit and install GToolkitLauncher in it. 
There is a detailed description of what the scripts do in INSTALL-EXPLAINED.MD.
On Windows, by default you are not allowed to run the script, that needs you to first run 

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## For an existing Glamorous Toolkit
Install Glamorous Toolkit. On the 'start page', in _Local Knowledge Base_ choose 'Add new page'. Call it something like `Environment Setup`. Add a `Pharo` block, and copy this in:

```st
Metacello new
	repository: 'github://StephanEggermont/GToolkitLauncher:main/src';
	baseline: 'GToolkitLauncher';
	load
```

Then add another `Pharo` block. Copy the line below, to load the rest of the installation instructions inside the Glamorous toolkit environment:

```st
BaselineOfGToolkitLauncher loadLepiter
```

At the bottom of your `Environment Setup` page, you will now see `Documents/lepiter/default`. Lepiter is the name of the documentation software. Click on there, to select 
<img width="1274" height="823" alt="Screenshot of the glamorous toolkit environment, a menu opens from the bottom of the screen showing the GToolkitLauncher documentation as one of the options." src="https://github.com/user-attachments/assets/c0394599-5c48-4fd5-88e7-622eaf0339e7" />

After clicking on this, the documentation will show up in the 'Pages' view on the left, as part of the history of contents.

<img width="795" height="515" alt="Screenshot, link to GToolkitLauncher page appears in a table of contents on the left. " src="https://github.com/user-attachments/assets/ba6d7c59-c905-4594-b3ef-6f4f0d8b5fb8" />

Open the GToolkitLauncher page to continue your Glamorous Toolkit journey.
