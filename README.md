# Boardrooms-Team5-C
An App that provides a way for simplify board rooms scheduling

🏢 Boardrooms Booking App - iOS Challenge
A modern SwiftUI application built as part of an 11-day development challenge. The app allows users to manage boardroom bookings through a cloud-based API, focusing on a seamless user experience and robust data synchronization.

🗓 Challenge Overview
Duration: 11 Days (Dec 23, 2026 – Jan 6, 2026).

Goal: To build a fully functional iOS app using SwiftUI that integrates with a provided API to handle comprehensive CRUD operations.

Work Dynamics: Developed in a group of 3 learners, with each member focusing on specific CRUD operations to ensure a collaborative and efficient development process.

✨ CRUD Operations & API Integration
The app is fully integrated with the Airtable API to handle all data persistence.

Create (POST): Users can select a boardroom and a specific date to generate a new booking. This sends a request to the /bookings endpoint, saving the employee_id, boardroom_id, and date.

Read (GET):

Boardrooms: Fetches all available rooms, including their names, floors, seating capacity, and facilities.

Bookings: Retrieves booking records. The app uses filterByFormula to ensure users only see their own bookings based on their unique employee_id.

Update (PATCH): Users can modify their existing bookings. This operation updates the specific record on the API with a new date.

Delete (DELETE): Users can cancel a booking using an intuitive swipe-to-delete action, which removes the record from the API database.

🛠 Extra Development Practices
MVVM Architecture: Follows a clean separation of concerns, making the code maintainable and scalable.

Error Handling (Offline Support): Implemented specialized error handling to detect if the user is offline. The app alerts the user with a specific message and icon if the internet connection is lost during login or booking.

Secure Storage: Uses UserDefaults to securely store the userEmployeeID and userJobNumber after a successful login, ensuring data consistency across the app.

Adaptive UI: Optimized layouts to ignore safe area keyboard edges, ensuring the UI remains stable when entering data.

📂 Deliverables
Fully Functional App: Built with SwiftUI, implementing all features described above.

API Integration: Complete synchronization for all Create, Read, Update, and Delete actions.

Source Code: Hosted on GitHub with a clean, logical commit history.

🛠 Technical Requirements
Environment: Xcode 15+.

Language: Swift (SwiftUI).

Backend: Airtable API.
