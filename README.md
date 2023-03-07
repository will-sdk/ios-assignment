## iOS Mobile assignment
# City Search App

 City Search App is a sample application that demonstrates the use of Clean Architecture, MVVM, and RxSwift in an iOS app. The UI is built using SnapKit, and the search logic uses binary search. The app also includes unit tests to ensure its functionality.

# Overview

The app displays a list of items and allows the user to search for items using a binary search algorithm. The app is built using the following technologies:

* Swift 5
* Clean Architecture
* MVVM
* RxSwift
* SnapKit

# Architecture

![1_N3ypUNMUGv87qUL57JyqJA](https://user-images.githubusercontent.com/75713253/223375791-307ef1c4-42fd-45ae-9f86-80a0b0117e92.png)

The app uses Clean Architecture to ensure that the system is modular, testable, and scalable. The architecture is divided into the following layers:

* Presentation Layer: Contains the user interface and the view models that bind the user interface to the use cases.
* Domain Layer: Contains the use cases and the entities that represent the business logic of the application.
* Data Layer: Contains the repositories that provide access to the data sources.

# Design Patterns
The app uses MVVM to separate the concerns of the user interface and make it easier to maintain and modify. The MVVM pattern separates the following concerns:

* Model: The data and the business logic of the application.
* View: The user interface.
* ViewModel: The mediator between the model and the view.

The app also uses RxSwift to handle asynchronous events in the system. RxSwift provides a reactive programming paradigm that allows app to work with asynchronous data streams in a more concise and declarative manner.

The UI is built using SnapKit, which is a DSL for Autolayout in Swift.

# Search Logic
The app originally used the default filter method to search for items in the list. However, which can result in slow performance for large lists. To improve the performance of the search feature, So I switched to using a binary search algorithm, in this case, faster than before (around 0.0001-0.0003 seconds per search).

| typing search | debounce search |
| -------- | ----- |
|![3search](https://user-images.githubusercontent.com/75713253/223376377-1735551e-b368-4df2-90f3-0251e27fa29d.gif) | ![debouce search](https://user-images.githubusercontent.com/75713253/223376450-68bec7a4-0ab7-4132-94a6-2cb2debbf172.gif) |

# Unit Tests
The app includes unit tests to ensure its functionality. The tests cover the use cases, and viewmodel in the app. This ensures that the app is working as expected and makes it easier to catch bugs and issues.

# Conclusion
Using Clean Architecture, MVVM, and RxSwift with SnapKit for the UI and binary search for the search logic can result in a highly scalable, maintainable, and testable software architecture. By separating the concerns of the user interface and using reactive programming and efficient search algorithms, create high-quality, and maintainable applications that are easier to maintain and extend over time.

