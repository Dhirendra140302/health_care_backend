# Healthcare Management System

A full-stack healthcare management system built with Spring Boot and React that connects patients, doctors, and administrators for seamless appointment management and medical consultations.

## 🎯 Quick Start

### Backend
```bash
cd health-care
./mvnw spring-boot:run
# Runs on http://localhost:8086
```

### Frontend
```bash
cd healthcare-frontend
npm install  # First time only
npm start
# Runs on http://localhost:3000
```

## 📚 Documentation

### 🎤 **For Interviews** → Start Here!
**[DOCUMENTATION_INDEX.md](DOCUMENTATION_INDEX.md)** - Complete guide to all documentation

This project includes **7 comprehensive documentation files** designed for technical interviews:

1. **[PROJECT_DOCUMENTATION.md](PROJECT_DOCUMENTATION.md)** - Complete technical documentation
2. **[INTERVIEW_QUICK_REFERENCE.md](INTERVIEW_QUICK_REFERENCE.md)** - Quick reference cheat sheet
3. **[PRESENTATION_GUIDE.md](PRESENTATION_GUIDE.md)** - Presentation script & talking points
4. **[ARCHITECTURE_DIAGRAMS.md](ARCHITECTURE_DIAGRAMS.md)** - Visual architecture diagrams
5. **[SYSTEM_FLOWCHARTS.md](SYSTEM_FLOWCHARTS.md)** - Detailed process flowcharts
6. **[API_DOCUMENTATION.md](API_DOCUMENTATION.md)** - Complete API reference
7. **[VISUAL_SUMMARY.md](VISUAL_SUMMARY.md)** - One-page visual overview

### Quick Links
- **[README_INTERVIEW.md](README_INTERVIEW.md)** - How to use all documentation
- **[COMPLETE_SYSTEM_STATUS.md](COMPLETE_SYSTEM_STATUS.md)** - Current system status
- **[DESIGN_SUMMARY.md](DESIGN_SUMMARY.md)** - UI/UX design details

## ✨ Features

### Patient Features
- Register and login
- Browse doctors by specialization
- Book appointments with date/time picker
- View appointment history
- Access video consultation links
- View medical consultation records

### Doctor Features
- Register with license and specialization
- View all assigned appointments
- Filter by status (Scheduled/Completed/Cancelled)
- Mark appointments complete
- Create consultation records
- Cancel appointments

### Admin Features
- View all system users
- View all doctors with specializations
- Monitor all appointments system-wide
- System oversight and management

## 🛠 Tech Stack

**Backend**: Spring Boot 3.2.5, Spring Security, JWT, MySQL, JPA/Hibernate, JavaMail  
**Frontend**: React 18, Material-UI, Bootstrap, Axios, React Router  
**Database**: MySQL 8.0

## 🔐 Security
- JWT token authentication (24-hour expiration)
- BCrypt password hashing
- Role-based access control
- CORS configuration
- Input validation
- SQL injection prevention

## 🎯 Test Accounts

| Role | Email | Password |
|------|-------|----------|
| Patient | alice@test.com | password123 |
| Doctor | doctor@test.com | password123 |
| Admin | admin@test.com | password123 |

## 📡 API Endpoints
21+ REST endpoints across authentication, users, doctors, appointments, and consultations.  
See [API_DOCUMENTATION.md](API_DOCUMENTATION.md) for complete reference.

## 🚀 Status
✅ **Production Ready** - All features working, fully documented, ready for deployment
