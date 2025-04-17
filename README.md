🔍 Project Overview
RecycLens — See Waste Differently — is an innovative smart and sustainable e-waste management solution developed by Team Bit Blazers for Hack GenX. The project leverages Artificial Intelligence (AI) to educate users about e-waste, classify electronic items smartly, and promote responsible recycling practices.
RecycLens is built as a mobile-based platform where users can scan their electronic devices using AR to identify them, understand their recyclability, and contribute to a circular economy. Additionally, a marketplace allows users to resell old but working electronics, giving them a second life and reducing overall e-waste.

🎯 Key Features
AI-based classification of electronic items.
Learn about e-waste.
Marketplace for resale of functional electronics.
User-friendly web dashboard for recycling centers and admins.
Community-driven issue reporting for illegal e-waste dumping.

💰 Income Model
RecycLens follows a sustainable and scalable income model that supports environmental impact and operational efficiency:
1. Commission from Marketplace Sales
A small percentage is charged on each successful sale of old electronics through the platform.
2. Subscription Plans for Recycling Centers
Premium features like detailed analytics, priority listings, and pickup scheduling are offered to recycling centers on a monthly/yearly subscription.
3. Advertisement Revenue
Green tech brands and electronics refurbishers can advertise on the app and dashboard in a non-intrusive manner.
4. Corporate Tie-ups & CSR Sponsorships
Collaborate with corporates for CSR initiatives related to e-waste management and sustainability education.
5. Data Insights and Reports
Sell anonymized data insights to environmental agencies and researchers for better policy-making and tracking of e-waste trends.
___________________________________________________________________________________________________________________________________________________________________
🧱 Technology Stack
RecycLens integrates modern technologies across platforms to deliver a seamless and intelligent e-waste management experience.
📱 Mobile Application (for Common Users)
Flutter: Cross-platform mobile app development for Android and iOS.
Firebase Authentication: User login and Gmail-based verification.
Cloud Firestore: Real-time NoSQL database for storing user data, recycling records, and marketplace listings.
AI-Based Deep Learning Model: For classifying electronic waste using camera input.
AR Integration: To visualize and identify devices interactively.

<<<<<<< HEAD
Key Features:
Mobile-based Interface for intuitive e-waste scanning
AI-Powered Device Classification to identify recyclables and resellables
E-Waste Marketplace for users to sell functional electronics
Recycling Center Portal to manage pick-up requests, reward distribution, and analytics
Community Interaction and issue reporting features to increase public participation


=======
💻 Web Platform (for Admin, Recycling Center & Disposing Center)
HTML, CSS, JavaScript: Responsive and interactive web development.
Firebase Hosting & Firestore: Backend support for managing data, rewards, and user reports.
Admin Panel: For managing users, community posts, recycling stats, and reported issues.

🧠 Artificial Intelligence
Custom Deep Learning Model: Built for smart classification of electronic devices based on image input.
Model Training: Performed using custom dataset with future integration into the mobile app for real-time predictions.

🔐 Authentication & Communication
Gmail Verification via Firebase: Secure and trusted user verification for sign-up/login processes.
____________________________________________________________________________________________________________________________________________________________________
⚙️ Setup Instructions
Follow the steps below to run the RecycLens project locally.

📲 Frontend (Mobile App – Flutter)
Prerequisites
Android Studio (required for SDK and emulator support)
Flutter SDK installed
Proper environment variables set for Flutter
Steps to Set Up
Install Flutter SDK and set up the environment.

Open Android Studio or VS Code.

Clone the repository:
bash
Copy
Edit
git clone https://github.com/Tejas-Pokale/bitblazers_hackgenx

Navigate to the project directory:
bash
Copy
Edit
cd recyclens

Get the Flutter dependencies:
bash
Copy
Edit
flutter pub get

Run the app:
bash
Copy
Edit
flutter run
The app should now be running on your connected device or emulator.

☁️ Backend (Firebase)
Firebase Authentication: Configured with Email/Password sign-in.
Cloud Firestore: Used as the real-time backend database for users, devices, marketplace, and recycling data.
Firebase configuration (google-services.json) must be added to the android/app directory.
Note: Make sure to connect the app with your own Firebase project if running locally. Set up Firebase through the Firebase Console, enable Email/Password Authentication, and configure Firestore rules as needed.
__________________________________________________________________________________________________________________________________________________________________
🧠 AI Model
The core of RecycLens's smart classification system is powered by a custom deep learning model trained to identify various types of electronic waste from images.
The model is built and trained using Google Colab for easy experimentation and deployment.
It is designed to classify devices efficiently using a lightweight architecture suitable for mobile integration.
Access the model 1 code here: https://colab.research.google.com/drive/14312wLGFHaycxcOEq3R8iCGwBqYTmGYh?usp=sharing
Access the dataset, that was used to train model 1 here: https://drive.google.com/drive/folders/1d6ob3NWsM0TWFdmaUFVcDEUAezeawBec?usp=sharing
Access the dataset, that was used to train model 2 here: https://drive.google.com/drive/folders/1fteeDVtBcqr7DKAx1NDDnQ-AxYxP3NfS?usp=sharing
Note: The model will be integrated into the mobile app for real-time image classification in future updates.
Note: The code for training model 2 is made available in the "recyclens_app" folder and the file is named as 'model_2_code.pynb'.
___________________________________________________________________________________________________________________________________________________________________
>>>>>>> 8d2c584bbeaeaa8a453fcc8dada983a9e4d6c63c
