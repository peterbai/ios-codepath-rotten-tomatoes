## Rotten Tomatoes

This is a movies app displaying box office movies and top DVD rentals using the [Rotten Tomatoes API](http://developer.rottentomatoes.com/docs/read/JSON).

Time spent: 15 hours

### Features

#### Required

- [x] User can view a list of movies. Poster images load asynchronously.
- [x] User can view movie details by tapping on a cell.
- [x] User sees loading state while waiting for the API.
- [x] User sees error message when there is a network error.
- [x] User can pull to refresh the movie list.

#### Optional

- [x] Add a tab bar for Box Office and DVD.
- [x] Add a search bar.
- [x] All images fade in.
- [x] For the larger poster, load the low-res first and switch to high-res when complete.
- [x] Customize the highlight and selection effect of the cell.
- [x] Customize the navigation bar.
- [ ] Implement segmented control to switch between list view and grid view.


### Walkthrough
![Video Walkthrough](gif/basic-and-required-01.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).

Credits
---------
* [Rotten Tomatoes API](http://developer.rottentomatoes.com/docs/read/JSON)
* [AFNetworking](https://github.com/AFNetworking/AFNetworking)
* [SVProgressHUD](https://github.com/TransitApp/SVProgressHUD)
* [FontAwesome+iOS](https://github.com/alexdrone/ios-fontawesome)
* [ODRefreshControl](https://github.com/Sephiroth87/ODRefreshControl)