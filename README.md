# Mini Job Board App — Flutter Assignment

## Overview

You are building a mobile app that allows candidates to browse jobs and apply. The focus is on functionality, UI/UX, offline-first behavior, and handling real-world edge cases.

This assignment is designed to give you freedom to make architectural and design decisions. We are not looking for exact specifications, but we care about reasoning, trade-offs, and code quality.

---

## Timeline

You have 48 hours from the time you receive this README.

---

## Requirements

### 1. Authentication

* Candidate can sign up/login (local storage only; no backend needed).
* Auth state must persist across app restarts.

### 2. Job Listing

* Display a list of jobs fetched from a local JSON file (or mock API).
* Each job should show: title, company, short description, status (open/closed).
* Tapping a job opens a detail screen.
* Focus on user experience: readability, spacing, navigation, layout clarity.

### 3. Applications & CV Parsing

* Candidate can apply to a job by uploading a PDF CV.
* Automatically extract basic fields from the PDF: name, email, phone.
* Store applications locally (SQLite or Hive).
* Applications created offline should queue and sync when the device goes online.

### 4. UI & UX

* Must have at least two screens: Job List/Detail and Candidate Applications.
* Implement a simple filter (e.g., keyword search on job titles).
* Pay attention to user flows, visual hierarchy, and responsiveness.

### 5. Testing

* Write meaningful tests covering critical app features: authentication, job listing, job application, offline queue, CV parsing.
* Focus on quality, thoughtfulness, and reasoning.
* Additional tests beyond the requirement are considered positively.


---

## Intentional Ambiguities / Edge Cases

* **Double Applications**: The spec does not specify behavior if a candidate applies twice to the same job. Make a reasonable assumption and document it in the README.
* **CV Parsing**: PDFs may have missing or malformed fields. Decide how to handle incomplete data and document your approach.
* **Other Assumptions**: If anything is unclear, make a reasonable decision and explain it in your README. This is part of the evaluation.

---

## Deliverables

* **Git repository**

  * All work must be committed to the repository created for you.
  * Include your code, tests, and any assets required to run the app.
* **README in the repository including**:

  * Setup and running instructions.
  * Decisions and trade-offs you made (especially around UI/UX, CV parsing, offline behavior).
  * Any improvements you would make with more time.

Optional but appreciated:

* UI polish (animations, UX refinements).
* Additional tests.

---

## Setup Instructions

Clone your GitHub Classroom repository:

```bash
git clone <your-repo-url>
cd mini-job-board-flutter
```

Install dependencies:

```bash
flutter pub get
```

Run the app in debug mode to verify setup:

```bash
flutter run
```

---

## Testing Instructions

To ensure the app works correctly, follow these steps to build, sideload, and test the app on a Pixel 9 emulator. Each step must be thoroughly tested and verified before submission. If any step fails during evaluation, the submission will be immediately rejected.

### 1. Set up the Pixel 9 emulator

* Open Android Studio and go to Device Manager.
* Create a new virtual device with the Pixel 9 configuration (API level 35, Android 15 recommended).
* Start the emulator and ensure it boots correctly.

### 2. Build the APK

Run the following command to build a release APK:

```bash
flutter build apk --release
```

Verify that the APK is generated at:
`build/app/outputs/flutter-apk/app-release.apk`

If the build fails, debug and fix the issue before proceeding.

### 3. Sideload the APK to the emulator

* Ensure the Pixel 9 emulator is running.
* Install the APK using ADB:

  ```bash
  adb install build/app/outputs/flutter-apk/app-release.apk
  ```
* Verify that the app installs successfully.
* Check the emulator’s app drawer for the app icon.

If the installation fails, investigate and resolve the issue (e.g., ensure the emulator has sufficient storage, correct ABI compatibility).

### 4. Test the app

* Launch the app on the Pixel 9 emulator.
* Test all critical features:

  * Authentication (signup/login persistence)
  * Job listing (loading from JSON, navigation to detail screen)
  * Job application (PDF upload, field extraction, offline queue)
  * Filtering
* Simulate offline behavior by disabling the emulator’s network (via Android Studio’s emulator settings) and verify that applications queue correctly.
* Test edge cases, such as double applications and malformed PDFs, as documented in your README.
* Ensure the app is responsive and visually clear on the Pixel 9’s screen size.

### 5. Run automated tests

Execute the test suite:

```bash
flutter test
```

Ensure all tests pass. If any test fails, debug and fix before submission.

---

## Important

Before submitting, verify each step on your own Pixel 9 emulator. Any failure during evaluation (build errors, installation issues, or app crashes) will result in immediate rejection. Document any emulator-specific setup steps or configurations in your README.













