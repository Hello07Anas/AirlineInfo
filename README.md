# Airline Information App

This project is a sample iOS application developed to display information about various airlines. The app demonstrates key functionalities including data fetching, list management, and data persistence.

## Video Demonstration

https://github.com/user-attachments/assets/559c5166-2917-4558-ad73-848182139554


## Features

### 1. Airline List Screen
- **Data Retrieval**: Retrieves a list of airlines from a JSON endpoint.
- **Display**: Each airline is displayed with its logo and name.
- **Toggle View**:
  - View the complete list of airlines.
  - View a list of user-marked favorite airlines.
- **Offline Support**: Favorite airlines are stored locally using CoreData, enabling offline access.

### 2. Airline Details Screen
- **Detailed Information**: Shows the airline's logo, name, website, and phone number.
- **External Actions**:
  - Open the airline’s website in an external browser.
  - Open a dialer with the airline’s phone number prefilled (simulated for iOS).
- **Favorite Management**: Allows users to mark or unmark airlines as favorites, with persistence across app launches.

## Technologies Used

- **Language**: Swift
- **Architecture**: Model-View-Controller (MVC)
- **Data Persistence**: CoreData
- **Image Loading**: SDWebImage for efficient image loading and caching.
- **Networking**: URLSession is used to fetch data from the JSON endpoint.

## Getting Started

To run the project locally:

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
