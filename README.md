## Yelp
Yelp Demo iOS App


This is a read only Yelp  demo app. 
The idea was to get introduced to auto layouts, designing filters, and use of custom delegates to pass data between view controllers.

Time Spent : 10 hours

Completed user Stories

- [ ] Search results page
   - [*] Required : Table rows should be dynamic height according to the content height
   - [*] Required : Custom cells should have the proper Auto Layout constraints
   - [*] Required : Search bar should be in the navigation bar (doesn't have to expand to show location like the real Yelp app does).
   - [*] Optional : Infinite scroll for restaurant results
   - [ ] Optional : Implement map view of restaurant results
- [ ] Filter page. Unfortunately, not all the filters are supported in the Yelp API.
   - [*] Required : The filters you should actually have are: category, sort (best match, distance, highest rated), radius (meters), deals (on/off).
   - [*] Required : The filters table should be organized into sections as in the mock.
   - [*] Required : You can use the default UISwitch for on/off states. Optional: implement a custom switch
   - [*] Required : Clicking on the "Search" button should dismiss the filters page and trigger the search w/ the new filter settings.
   - [*] Required : Display some of the available Yelp categories (choose any 3-4 that you want).
   - [ ] Optional : Radius filter should expand as in the real Yelp app
   - [ ] Optional : Categories should show a subset of the full list with a "See All" row to expand. Category list is here: http://www.yelp.com/developers/documentation/category_list (Links to an external site.)
- [ ] Optional : Implement the restaurant detail page.
