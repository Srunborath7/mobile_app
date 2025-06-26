📁 Full project structure

⚙ How to run the backend (Node.js + MySQL)

📱 How to run the frontend (Flutter)

🧪 How to test the API with Postman

📝 Troubleshooting

✅ Final README.md (copy & save as README.md)
markdown
Copy
Edit
# 📱 Flutter + 🟩 Node.js + 🐬 MySQL Full Stack Project

This is a full-stack mobile app using:

- **Flutter** – Frontend mobile application
- **Node.js + Express** – REST API backend
- **MySQL** – Database
- **Postman** – API testing

---

## 📁 Project Structure

project-root/
├── flutter_app/ # Flutter mobile frontend
│ ├── lib/
│ │ ├── connection.dart # API base URL
│ │ └── login_page.dart # Login screen
│ └── pubspec.yaml
│
├── node-rest-api/ # Node.js backend
│ ├── index.js # Main API server
│ ├── db.js # MySQL database config
│ ├── .env # Environment variables
│ └── package.json
│
└── flutter_api.postman_collection.json # Postman API collection

yaml
Copy
Edit

---

## ✅ How to Run This Project

### 🔧 1. Setup MySQL Database

1. Install [MySQL](https://dev.mysql.com/downloads/) or [XAMPP](https://www.apachefriends.org/index.html)
2. Open phpMyAdmin or MySQL CLI
3. Create the database and table:

```sql
CREATE DATABASE flutter_db;

USE flutter_db;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL UNIQUE,
  password VARCHAR(100) NOT NULL
);
🟩 2. Run Node.js Backend
Open terminal and navigate to the backend:

bash
Copy
Edit
cd node-rest-api
Install dependencies:

bash
Copy
Edit
npm install
Create .env file:

env
Copy
Edit
PORT=3000
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=
DB_NAME=flutter_db
Start the backend server:

bash
Copy
Edit
npm start
The server runs at: http://localhost:3000/

📱 3. Run Flutter Frontend
Open a new terminal and go to:

bash
Copy
Edit
cd flutter_app
Install Flutter packages:

bash
Copy
Edit
flutter pub get
Set your API URL in lib/connection.dart:

dart
Copy
Edit
const String baseUrl = 'http://10.0.2.2:3000/api'; // For Android emulator
// OR use your PC IP address if using real device
Launch app:

bash
Copy
Edit
flutter run
🧪 4. Test API with Postman
Open Postman

Import flutter_api.postman_collection.json

Test these endpoints:

Method	Endpoint	Description
POST	/api/register	Register user
POST	/api/login	Login user
GET	/api/users	Fetch all users

⚠️ Troubleshooting
❌ Can't connect to backend from Flutter?
Use http://10.0.2.2:3000/ for Android Emulator

Use local IP address (e.g. http://192.168.1.x:3000/) for real device

Make sure both phone/emulator and backend are on the same WiFi/network

❌ CORS error from backend?
Ensure in index.js:

js
Copy
Edit
const cors = require('cors');
app.use(cors());
📄 License
MIT License. Feel free to use, modify, and share.

👤 Author
Borath Srun

yaml
Copy
Edit

---

Let me know if you'd like:
- A Khmer version 🇰🇭
- A `.zip` file with all code
- This converted into a PDF

I’m ready to help!
