# eXchangr

## Authors

* Lucas Alves Sobrinho
* Lucas Viana Barbosa

## Purpose
The main idea of our app is to provide a platform for free stuff exchange. The 
user will be able to register items and exchange them for other people's items.

## Features
* User registration
* User authentication
* User items managing:
	* Item registration (including pictures upload)
	* Item editing
	* Syncronization with server
* Items browsing based on the user's current location
	* Ability to exchange or ignore an item
	* Ability to see item's owner contact
	* Only items within a limited radius around the user's location will be 
	  shown

## Control Flow
* The user will be prompted with the login screen. If the user is already 
  registered, the user will fill a login and password field in order to be 
  authenticated and will be headed to the main screen of the app. 
* Otherwise, the user will click the Register button and a registration screen 
  will be showed, allowing the user to sign up.
* After authentication, the user will be able register items by taking some 
  pictures of an object and writing a brief description about it. The user can 
  put at most 5 items for free or pay to be able to put more items. 
* After finishing the registration process, a set of items from other people 
  will be presented to the user, one per time. 
* We'll establish a minimum search radius distance to begin with, based on the 
  user's location. 
* If there is a very small number of items in range (let's say, 5 or 10), the 
  server will gradually increase the user area of search until there are enough
  items to choose (i.e. 50).
* The user will be able to see the item's pictures/descriptions and must have 
  to decide between Exchange or Ignore. 
* If the user Ignores the item, then the next item will be presented. 
* If the user chooses to Exchange and the owner of that object also chooses 
  Exchange with the user's object, both of them will be able to see each other 
  contact information and then concretize the exchange. 

## Implementation

### Model

* User
* Item
* Picture
* Location

### View

* PileOfItemsView
* SideMenuView
* ItemTableView

### Controller

* LoginViewController
* UserRegistrationViewController
* BrowserViewController
* ItemAdditionViewController
* ItemEdittingViewController
* ContactInfoViewController
* AccountConfigurationViewController
