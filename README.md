# Aspen

Aspen is a social media application built using Flutter.

The project is currently under active development and new features are being added gradually.

## Features

* User Authentication
* Google OAuth Sign-In
* JWT-based Login Flow
* Feed Loading
* Create and View Posts
* Like Posts
* Comment on Posts
* Push Notifications (Firebase Cloud Messaging)
* Account/Profile Details Screen
* Image Selection and Upload Support

## Tech Stack

### Frontend

* Flutter
* Riverpod
* Dio
* Firebase Cloud Messaging (FCM)
* Google Sign-In
* Flutter Secure Storage

### Backend

* Spring Boot (Java)
* JWT Authentication
* PostgreSQL

## Current Status

This project is currently in development.

Implemented:

* Authentication System
* Feed Screen
* Like and Comment Functionality
* Push Notifications
* Profile Details Screen

## Getting Started

1. Clone the repository

```bash
git clone <repository-url>
```

2. Install dependencies

```bash
flutter pub get
```

3. Add your Firebase configuration

Place your own `google-services.json` file inside:

```text
android/app/google-services.json
```

4. Run the application

```bash
flutter run
```

## Note

This repository contains only the frontend implementation. The backend is maintained separately.

