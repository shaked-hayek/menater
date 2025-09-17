# Menater System Setup

This guide explains how to install and run the Menater system on a new Windows computer.



## Clone the Repository

Clone the main repo **with submodules**:

```powershell
git clone --recurse-submodules <main_repo_url>
```

## 1. Install Core Software

1. **VMware Workstation / Player**  
   - Install [VMware Workstation Pro/Player](https://www.vmware.com/products/workstation-pro.html).  
   - Place your ArcGIS VM files (`.vmx`, `.vmdk`, etc.) under:  
     ```
     C:\VMs\Windows Server 2022 - ArcGIS\
     ```
	- Make sure the vmxPath in powershell scripts matches the VM path, if changed. 

2. **Python**  
   - Install [Python 3.x](https://www.python.org/downloads/windows/).  
   - Check *Add Python to PATH* during install.  
   - Verify with:
     ```powershell
     python --version
     ```

3. **Node.js**  
   - Install [Node.js (LTS)](https://nodejs.org/).  
   - Verify with:
     ```powershell
     node -v
     npm -v
     ```

4. **MongoDB**  
   - Install [MongoDB Community Server](https://www.mongodb.com/try/download/community).  
   - Choose **Install as a Windows Service**.  
   - Verify with:
     ```powershell
     mongosh
     ```

5. **Google Chrome**  
   - Install [Chrome](https://www.google.com/chrome/).  
   - Needed for launching with `--ignore-certificate-errors`

6. **Git (optional)**  
   - Install [Git for Windows](https://git-scm.com/download/win).  

---

## 2. Project Setup

### Folder Structure
    menater/
    ├── app/
    │   ├── menater-server/
    │   │   ├── app.py
    │   │   └── requirements.txt
    │   └── menater-app/
    ├── README.md
    ├── scripts/
    |   └── map_reset.ps1
    ├── run_menater.ps1
    └── stop_all.ps1

### Python Setup
   ```powershell
   cd baseFolder\menater\menater-server
   python -m venv venv
   .\venv\Scripts\activate
   pip install -r requirements.txt
   ```

### React Setup
   ```powershell
   cd baseFolder\menater\menater-app
   npm install
   ```
   Optional:
   ```powershell
   npm run build
   ```


## 3. Running the System
Run:
```powershell
.\run_menater.ps1
```
This will:
   - Start the ArcGIS VM (via VMware).
   - Ensure MongoDB is running.
   - Start Flask (minimized).
   - Start React (minimized).
   - Open Chrome at https://localhost:3000 ignoring certificate warnings.


Stop everything with:
```powershell
.\stop_all.ps1
```

If the ArcGIS VM map is broken, reset to the latest working snapshot:
```powershell
.\menater\map_reset.ps1
```

## 4. Troubleshooting
   - If PowerShell blocks running scripts:
      ```powershell
      Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
      ```
   - If Chrome doesn’t open, update $chromePath inside start_all.ps1.
   - If MongoDB isn’t running as a service, adjust start_all.ps1 to launch mongod.exe directly.
	
