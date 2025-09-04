# Soil Health Monitoring App

A Flutter-based mobile application that measures and tracks soil health readings (temperature & moisture).  
The app connects to sensors (via Bluetooth), stores readings in Firebase Firestore, and allows each user to view their personal soil health history.  
Currently the application deals with mock data but it is perfectly set up to scale up for actual bluetooth connectivity.

## Installation

1. Clone the repository

```bash
  git clone https://github.com/your-username/soil-health-app.git
  cd soil-health-app
```

2. Install Dependencies

```bash
  flutter pub get
```

3. Firebase Setup

```bash
  flutterfire configure
```

4. Run the app

```bash
  flutter run
```
