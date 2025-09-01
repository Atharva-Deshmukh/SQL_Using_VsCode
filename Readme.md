# MySQL Setup and Usage in VS Code

This guide explains how to connect **VS Code** to a **MySQL Server**, configure the required extension, and run SQL queries directly from VS Code.

---

## 📌 Prerequisites

- [MySQL Server](https://dev.mysql.com/downloads/mysql/) installed on your system  
- [Visual Studio Code](https://code.visualstudio.com/) installed  
- A MySQL user account with username/password  

---

## ⚡ Step 1: Install VS Code Extension

1. Open VS Code
2. Go to the Extensions tab (`Ctrl+Shift+X` / `Cmd+Shift+X` on Mac)
3. Search for **MySQL** or install:  
   👉 **"SQLTools"** and **"SQLTools MySQL/MariaDB"** driver  
4. Reload VS Code after installation

---

## ⚡ Step 2: Configure Connection

1. Press `Ctrl+Shift+P` and search for **SQLTools: Add New Connection**  
2. Select **MySQL/MariaDB**  
3. Fill in your database details:  
   - **Server**: `localhost` (or your MySQL host)  
   - **Port**: `3306` (default MySQL port)  
   - **User**: `AdminUser` (or your username)  
   - **Password**: (enter your password)  
   - **Database**: e.g., `vs_code_db`  

Example configuration:

```json
{
  "connections": [
    {
      "name": "Local MySQL",
      "driver": "MySQL",
      "server": "localhost",
      "port": 3306,
      "username": "root",
      "password": "your_password",
      "database": "vs_code_db"
    }
  ]
}

```

## ⚡ Step 3: RUN SQL query Now

1. Create SQL file and code something there
2. Select All >> Right click >> Run selected query option 
