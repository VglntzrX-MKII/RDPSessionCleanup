# 💻 RDP Session Cleanup Script

## 📝 Overview

This **Windows Batch script** (`.bat`) is designed to automatically **log out (terminate)** disconnected Remote Desktop Protocol (**RDP**) user sessions on a Windows server (e.g., a Remote Desktop Session Host or similar environment).

It helps to free up system resources, manage license consumption, and keep the server running efficiently by preventing an accumulation of inactive sessions.

## ✨ Features

* **Automatic Cleanup:** Identifies and logs out all sessions in a **Disconnected** (`Disc`) state.
* **Logging:** Creates detailed logs for script execution and a separate log for successfully terminated sessions.
* **Elevated Privilege Check:** Verifies for **Administrator privileges** before execution and exits with an error if they are missing.
* **Fallback Method:** Attempts `logoff` first, and if that fails, falls back to using `rwinsta` (Reset Session) to terminate the session.
* **Services Session Exclusion:** Skips logging out **Session ID 0** (typically the Services session).

---

## 🚀 How to Use

1.  **Save the Script:** Save the provided code as a `.bat` file (e.g., `rdp_cleanup.bat`).
2.  **Run with Administrator Privileges:** The script **must be run with Administrator privileges**.
    * **Manual Run:** Right-click the `.bat` file and select "**Run as administrator**."
    * **Scheduled Task:** The recommended method is to set up a Windows **Scheduled Task** to run the script automatically (e.g., nightly, or every few hours) using an administrative account.

---

## ⚙️ Requirements

* **Operating System:** Windows Server (or a Windows desktop OS with Remote Desktop Services/Terminal Services tools enabled).
* **Permissions:** The user running the script **must have administrative privileges**. The commands `query session`, `net session`, `logoff`, and `rwinsta` require elevated access.

---

## 📁 Logging

The script automatically creates a `C:\RDPLogs` directory if it doesn't exist and writes two log files:

| Log File | Path | Purpose |
| :--- | :--- | :--- |
| **`run.log`** | `C:\RDPLogs\run.log` | Records the output of every script execution, including found sessions, errors, successes, and the final summary. |
| **`disconnect.log`**| `C:\RDPLogs\disconnect.log` | A concise list of sessions that were successfully logged out, including the date, time, Session ID, and User. |

---

## ⚠️ Important Note

* **Administrator Access:** Running the script without elevated privileges will result in an `ERROR: This script requires administrator privileges.` message and the script will exit.
* **Forceful Termination:** The script forcefully logs off sessions. Ensure that users are properly instructed to log off their sessions rather than just disconnecting, as this script does **not** provide warnings before termination.