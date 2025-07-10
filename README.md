# 📱 Mobile App with Flutter & Node.js REST API & MySQL Full Stack App
---
📁 Full Project Structure
⚙ How to Run the Backend (Node.js + MySQL)

📱 How to Run the Flutter Frontend

🧪 How to Test API with Postman

📝 Troubleshooting

👤 Author

✅ Final README.md (Production Quality)

This project is a complete mobile application using:

- **Flutter** (Frontend)
- **Node.js + Express** (Backend REST API)
- **MySQL** (Database)
- **Postman** (API testing)

---

## 📁 Project Structure

```plaintext
project-root/
│
├── flutter_app/                  # 📱 Flutter frontend
│   ├── lib/
│   │   ├── connection.dart       # 🔗 API base URL
│   │   └── login_page.dart       # 🔐 Login screen
│   │
│   └── pubspec.yaml              # 📦 Flutter dependencies & config
│
├── node-rest-api/               # 🌐 Node.js backend
│   ├── index.js                 # 🚀 API server entry point
│   ├── db.js                    # 🗄️  MySQL connection config
│   ├── .env                     # 🔐 Environment variables
│   └── package.json             # 📦 Node project dependencies
│
└── flutter_api.postman_collection.json   # 📬 Postman collection for API testing
```

sql
Copy
Edit

---

## ⚙ Backend Setup (Node.js + MySQL)

### 1. Create MySQL Database

Use phpMyAdmin or MySQL CLI to create the database and user table:

```sql
CREATE DATABASE flutter_db;

USE flutter_db;

```
2. Configure and Run Node.js Server
bash
Copy
Edit
cd node-rest-api
npm install
Create a .env file inside node-rest-api/:

ini
Copy
Edit
PORT=3000
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=
DB_NAME=flutter_db
Start the server:

bash
Copy
Edit
npm start
Server will run at: http://localhost:3000/

📱 Flutter App Setup
bash
Copy
Edit
cd flutter_app
flutter pub get
Update lib/connection.dart:

dart
Copy
Edit
const String baseUrl = 'http://10.0.2.2:3000/api'; // Android Emulator
// Or use your local IP address for real device testing
Run the app:

bash
Copy
Edit
flutter run
🧪 API Testing with Postman
Open Postman

Import flutter_api.postman_collection.json

Use the following endpoints:

Method	Endpoint	Description
POST	/api/register	Register a user
POST	/api/login	Login a user
GET	/api/users	List all users

📝 Troubleshooting
Flutter can’t connect to backend?

Use 10.0.2.2 for Android Emulator

Use your IP address for real devices

Ensure server and phone are on the same WiFi

CORS error from Node.js?

Add to index.js:

js
Copy
Edit
const cors = require('cors');
app.use(cors());
👤 Author
Borath Srun

This README.md is production-quality. Let me know if you want a Khmer version 🇰🇭 or a downloadable .pdf.

vbnet
Copy
Edit

---

### ✅ Next Steps (Optional Help for You):
- Want a `.zip` of this structure and code?
- Need a registration page in Flutter?
- Want to publish this project on GitHub with instructions?

Let me know and I’ll help step-by-step.
