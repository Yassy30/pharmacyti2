# pharmaciyti - Mobile Medicine Delivery App

Pharmaciyti is a mobile application that serves as a bridge between **pharmacies**, **customers**, **delivery personnel**, and **administrators**. It facilitates the online ordering and delivery of medications, ensuring faster and more efficient access to pharmacy services.

---

## 🚀 Features by Role

### 👤 Client
- View list of **open pharmacies**
- Complete profile management
- Place orders by:
  - Selecting medications
  - Uploading a prescription (image)
- View order history

### 🧑‍⚕️ Pharmacy
- Manage received **orders**
- Update profile and pharmacy details

### 🛵 Livreur (Delivery Person)
- View and update **profile**
- See real-time assigned **orders**
- Access **invoices** for completed deliveries
- Update order **status** (picked, delivered, etc.)

### 🛠️ Admin
- Validate **pharmacy account requests**
- View list of **pharmacies**
- Monitor **orders per pharmacy**
- Track **orders delivered by each delivery person**

---

## 🧱 Tech Stack

- **Flutter** (Frontend)
- **Supabase** (Backend: Auth, Database, Storage, Realtime)

---

## 📁 Project Structure
lib/
│
├── main.dart                        # Entry point of the app
├── start_wrapper.dart               # Handles onboarding/auth redirection
│
├── onboarding/                     # Onboarding screens
│   ├── onboarding_screen_1.dart
│   ├── onboarding_screen_2.dart
│   ├── onboarding_screen_3.dart
│   └── onboarding_wrapper.dart
│
├── auth/                           # Authentication (login/signup)
│   ├── login_page.dart
│   ├── signup_page.dart
│   └── auth_service.dart           # Supabase auth logic
│
├── client/                         # Client interface
│   ├── home_page.dart
│   ├── pharmacies_page.dart
│   ├── order_page.dart
│   ├── prescription_upload.dart
│   └── history_page.dart
│
├── livreur/                        # Livreur (delivery person) interface
│   ├── profile_page.dart
│   ├── orders_page.dart
│   └── invoice_page.dart
│
├── pharmacie/                      # Pharmacie interface
│   ├── orders_page.dart
│   └── profile_page.dart
│
├── admin/                          # Admin interface
│   ├── verify_pharmacies_page.dart
│   ├── pharmacies_list_page.dart
│   ├── orders_by_pharmacy_page.dart
│   └── orders_by_livreur_page.dart
│
├── core/                           # Shared logic and resources
│   ├── models/                     # Data models (User, Order, etc.)
│   ├── services/                   # Supabase services (DB, storage)
│   ├── utils/                      # Helpers and constants
│   └── widgets/                    # Reusable UI components
│
└── router/                         # App routing logic
    └── app_router.dart


📌 Contributors
🎨 Designed by: Fatima Bichouarine
💻 Developed by: Yasmina Jabrouni - Oumaima Mouine
🏫 Final Year Project (PFE) – Mobile App Development

📬 Contact
For more info or collaboration:
📧 yasminajabrouni@gmail.com

