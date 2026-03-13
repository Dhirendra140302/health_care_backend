# 🏥 Health Care Backend System

A **Spring Boot REST API** for managing a healthcare system including **patients, doctors, appointments, consultations, authentication, and notifications**.

This project demonstrates **Java backend development skills, REST API design, JWT security, database management, and layered architecture**.

---

# 🚀 Tech Stack

* **Java 17**
* **Spring Boot**
* **Spring Security**
* **JWT Authentication**
* **Spring Data JPA**
* **MySQL / H2 Database**
* **Maven**
* **REST API**
* **Thymeleaf (Email Templates)**

---

# 📁 Project Structure

```
src/main/java/com/example/dat
│
├── appointment
│   ├── controller
│   ├── dto
│   ├── entity
│   ├── repo
│   └── service
│
├── consultation
│
├── doctor
│
├── patient
│
├── notification
│
├── users
│
├── role
│
├── security
│
├── exceptions
│
└── config
```

---

# ⚙️ Features

✔ User Registration & Login
✔ JWT Authentication & Authorization
✔ Role Based Access (Admin, Doctor, Patient)
✔ Doctor Management
✔ Patient Management
✔ Appointment Booking System
✔ Consultation Records
✔ Notification System
✔ Password Reset System
✔ Global Exception Handling

---

# 🔐 Security

* JWT Token Authentication
* Spring Security Filter Chain
* Custom Authentication Entry Point
* Role Based Access Control

---

# 📡 API Modules

### 👤 User Module

* Register User
* Login User
* Update Password
* Reset Password

### 🧑‍⚕️ Doctor Module

* Add Doctor
* Update Doctor
* View Doctors

### 🧑 Patient Module

* Add Patient
* Update Patient
* View Patient Details

### 📅 Appointment Module

* Book Appointment
* Cancel Appointment
* View Appointment History

### 📋 Consultation Module

* Add Consultation
* View Consultation Details

---

# 🗄 Database Entities

* User
* Role
* Doctor
* Patient
* Appointment
* Consultation
* Notification
* PasswordResetCode

---

# ▶ How to Run the Project

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/Dhirendra140302/health_care_backend.git
```

### 2️⃣ Navigate to Project

```bash
cd health_care_backend
```

### 3️⃣ Run the Application

```bash
mvn spring-boot:run
```

Application will start on:

```
http://localhost:8080
```

---

# 🧪 Testing APIs

You can test APIs using:

* Postman
* Curl
* Swagger (if added)

---

# 📷 Architecture

Client (Postman / Frontend)
⬇
Controller Layer
⬇
Service Layer
⬇
Repository Layer
⬇
Database

---

# 👨‍💻 Author

**Dhirendra Yadav**

GitHub:
https://github.com/Dhirendra140302
