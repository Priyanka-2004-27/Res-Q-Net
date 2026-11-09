# 🛠️ ResQNet — Complete Error Solutions & Troubleshooting Manual

This guide provides permanent, tested solutions for every possible error you might encounter while setting up or running the **ResQNet** project on Windows.

---

## 🛑 Error 1: PowerShell Script Execution Policy Error (`npm.ps1 cannot be loaded`)
* **Solution 1 (1-Click Fix):** Double-click `fix_powershell_execution_policy.bat`.
* **Solution 2:** Open PowerShell as Administrator and run:
  ```powershell
  Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
  ```

---

## 🛑 Error 2: MongoDB Connection Error / `mongod not recognized`
* **Status in ResQNet:** You **DO NOT** need to install MongoDB to run this project!
  The backend includes a High-Speed In-Memory Data Store that automatically initializes seed data when MongoDB is not running locally.
* **To connect real MongoDB (Optional):**
  Add your MongoDB Atlas URI in `backend/.env`:
  ```env
  MONGO_URI=mongodb+srv://admin:yourpassword@cluster0.mongodb.net/resqnet
  ```
  Test your connection by running: `node backend/test_db.js`.

---

## 🛑 Error 3: Port Conflict (`listen EADDRINUSE: :::5000` or `:::3000`)
* **1-Click Fix:** Double-click `stop_servers.bat` to automatically kill lingering processes on ports 5000 and 3000.

---

## 🚀 How to Run the App (1-Click)
Double-click `start_all.bat`.
Then open `http://localhost:3000` in your web browser.
