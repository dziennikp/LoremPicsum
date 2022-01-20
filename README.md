# Lorem Picsum 
Simple UIKit based app for displaying grid of pictures from https://picsum.photos.

Available from iOS 13+.

## Instalation

Install Sourcery (https://github.com/krzysztofzablocki/Sourcery)

Open LoremPicsum.xcodeproj and:  
* cmd+r to run project
* cmd+u to run unit tests

## Architecture overview

Architecture design is variation over Clean Architecure / Layered Archictecture with UIKit.  
Code is splited into `Shared` and `Features` folders. Goal is to have all of features decoupled of each other and have an app that is easy to modularize.

Data flow:

View (Display) <-> ViewModel (Business logic, Navigation) <- Repository (Loading data from providers) <- Data provider (APIClient, CoreData etc.)

View is decoupled from ViewModel so we can easily switch between View frameworks, for example UIKit and SwiftUI

## Steps to improve

* Add Snapshot testing (https://github.com/pointfreeco/swift-snapshot-testing)
* Add UI tests
* Add dependency injection system (https://github.com/hmlongco/Resolver)
* Improve UI -> animations on interaction, support dark mode 
* Improve details view -> Add scroll view to support zooming
* Add better navigation handling -> for such small project pure navigation controller is fine but adding more features will make it hard to maintain. Prefferable approaches Coordinator + Router
* Setup Fastlane
* Improve LaunchScreen
* Improve caching
* Restore Swiftformat
  
