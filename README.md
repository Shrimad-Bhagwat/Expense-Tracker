# 📊 Expense-Tracker

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white) ![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)

Welcome to Expense-Tracker, a Flutter project designed to help you keep track of your expenses. This application allows you to add expenses with the following details:

📝 Title
💵 Amount
🗓️ Date
🗂️ Category

The main page features a bar graph representation of your expenses, along with support for both light and dark themes based on the system theme. Below the graph, you'll find a list of expenses with their respective details and icons for easy management.

## Project Screenshots

<p align="center">

<img src="https://github.com/Shrimad-Bhagwat/Expense-Tracker/assets/51125208/9fb19bb3-4058-4ba9-af73-308d06c9ece4" width=30%>
<img src="https://github.com/Shrimad-Bhagwat/Expense-Tracker/assets/51125208/fda9c726-7b45-4d02-9db5-515278fd878f" width=30%>
<img src="https://github.com/Shrimad-Bhagwat/Expense-Tracker/assets/51125208/b36b1b80-1fde-4179-9d02-61185bc55eb2" width=30%>

</p>

<p align="center">
  <img src="https://github.com/Shrimad-Bhagwat/Expense-Tracker/assets/51125208/439b6f32-e0a8-4149-a4c1-4badf33e2df4" alt="Home Light" width="75%"/>

</p>


## 🚀 Getting Started

Follow these steps to set up and run the Expense-Tracker project on your local machine:

1. **Clone the Repository**
   ```bash
   git clone https://github.com/your-username/Expense-Tracker.git
    ```
2. **Navigate to the Project Directory**
   ``` 
   cd Expense-Tracker
   ```
3. **Install Dependencies**
   ``` 
   flutter pub get
   ```
3. **Run the Application**
   ``` 
   flutter run
   ```

## 📥 Adding Expense

To add an expense, follow these steps within the app:

1. Open the app on your device/emulator.
2. Navigate to the "Add Expense" screen.
3. Fill in the required details:
    📝 Title
    💵 Amount
    🗓️ Date
    🗂️ Category
4. Tap the "Save" button.

## ✅ Managing Expenses

- To delete an expense, simply swipe it in any direction. You can also undo this action if needed.


## 📱 Responsiveness

The app is designed to be responsive for different screen sizes and orientations, ensuring a consistent user experience across devices.

## 📁 Project Structure

Here's a brief overview of the project's structure:

- `lib/`: Contains the main Dart code files.
  - `models/`: Contains data models used in the application.
    - `expense.dart`: Model for an expense.
  - `widgets/`: Contains reusable widgets used across screens.
    - `chart/`: Contains widgets related to the expense chart.
      - `chart.dart`: Widget for displaying the expense chart.
      - `chart_bar.dart`: Widget for individual bars in the chart.
    - `expense_list/`: Contains widgets related to the expense list.
      - `expenses.dart`: Widget for displaying the list of expenses.
      - `new_expense.dart`: Widget for adding a new expense.
  - `main.dart`: Entry point of the application.
