# Boardrooms-Team5-C
An App that provides a way for simplify board rooms scheduling

🏢 Boardrooms Booking App
A modern iOS application designed for corporate employees to discover and book meeting rooms or creative spaces. The app features a seamless user experience with real-time availability tracking powered by a cloud-based backend.

✨ Key Features
Secure Authentication: Employees can log in using their unique job number and password.

Dynamic Room Discovery: Browse all available boardrooms with detailed info including floor level, seating capacity, and facilities.

Real-time Availability: A 14-day calendar view that checks room status against existing bookings via the API.

Complete Booking Management (CRUD):

Create: Book a room for a specific date.

Read: View personal upcoming bookings on the home screen and a dedicated "My Booking" page.

Update: Modify the date of an existing booking.

Delete: Cancel bookings using an intuitive swipe-to-delete action.

Robust Error Handling: Real-time detection of internet connection status to alert users when they are offline.

Keyboard Management: Optimized layout that ignores safe area keyboard edges to prevent UI jumping.

🛠 Tech Stack
SwiftUI: For building a responsive and declarative user interface.

MVVM Architecture: Ensures a clean separation of concerns between the data logic and the UI.

Airtable API: Used as a serverless backend to store employee records, boardroom details, and booking logs.

Combine & Async/Await: For modern, non-blocking network requests and data binding.

📂 Project Structure
Models: Data structures mapping to Airtable's JSON responses (e.g., BoardroomRecord, BookingRecord).

ViewModels: Handles API communication, data filtering, and business logic (e.g., MainViewModel, MyBookingViewModel).

Views: Modular SwiftUI views including LoginView, MainView, Available, and MyBookingView.

🚀 Setup & Installation
Clone this repository.

Open BoardroomsBooking.xcodeproj in Xcode 15+.

Ensure your API Token and Base URL are correctly configured in the ViewModel files.

Build and run on a simulator or physical device running iOS 16.0+.
