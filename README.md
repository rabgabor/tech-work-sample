# Work sample - iOS Application developer

## Developer comments

- In order to run the app, provide a Config.plist file similar to the provided ConfigExample.plist file. Here, provide your API key for the "apiKey". The app can be built by default, but please note that it requires iOS 13.1 to run.
- The app supports dark mode and has adaptive layout. It has no buttons apart from the UIAlerts. It fetches the location and the weather based on the location every five minutes when the app is in foreground. When sent to foreground from background or location authorization is given, the timer restarts.
- I spent 8 hours doing the assignment.

## Assignment

- Build a simple one-view conroller app that shows the weather at your current location.
- This assignment is to be performed at home and is broken down into two steps. The second step is a follow-up interview will be performed separately.
- Budget: 8-12 hours 

## Requirements
- Show the weather for your current location
- Use data from provided API (see API DOCS)
- We expect your app be fully responsive for both landscape and portrait mode.
- There is no need to consider optimized design for iPad screens.
- Thoughts taken into overall architecture and patterns you use choose are important.


## Assets
You can find some icon assets at [https://github.com/erikflowers/weather-icons](https://github.com/erikflowers/weather-icons) that you can use if you please. You are more than welcome to use other assets that you feel are better fitted for your solution. We do not expect you to be a designer, but since application development on Daresay most often includes visual interfaces we expect you to be well aware of your platforms design guidelines and conventions.

## Expectations

###### User experience
The feature of the app is simple but we expect you to deliver a solution with an acceptable user experience based on the time budget. 
We do not expect you to put too much time of your budget on visual designs and user experience, but we would like to see some of your thoughts and considerations.

###### Code
We expect that the code is of high quality and under source control. Expect the solution to be continuously worked on by other developers and should therefore be easy to understand, adjust and extend. True beauty starts on the inside!

## Delivery
- Fork the repository, code in your fork and make a pull request when done. Also send us an e-mail to let us know when you are done!
- Please leave a note that how much time you spent on together with your delivery.
- Provide a readme with instructions to how to build and run it, if needed.

### Good luck!

---


# API DOCS

## Base url
http://worksample-api.herokuapp.com


http://worksample-api.herokuapp.com is a simple wrapper of some of the endpoints provided on http://openweathermap.org/.

## Available Endpoints and Documentation
- http://worksample-api.herokuapp.com/weather [documentation](http://openweathermap.org/current)
- http://worksample-api.herokuapp.com/forecast [documentation](http://openweathermap.org/forecast5)
- http://worksample-api.herokuapp.com/forecast/daily [documentation](http://openweathermap.org/forecast16)

We always respond in JSON and metrics.
We also don’t support these features of the OpenWeatherMap API:

- Bulk downloading
- Search Accuracy (like/accuracy)
- Limitation of result
- Units format
- Multilingual support
- Callback functions for javascript.
​

## You can use these parameters

#### API key (mandatory)
The API-key is required for all API calls. It should have been sent to you together with the instructions asking you to do the work sample.

#### By city name:
City name and country code divided by comma, use ISO 3166 country codes.

`?q={city name},{country code}`

`?q={city name}`
​
#### By city id:
List of city ID:s can be downloaded [here](http://bulk.openweathermap.org/sample/)

`?id={id}`
​
#### By geographic coordinates:
Coordinates of the location of your interest

`?lat={lat}&lon={lon}`
​
#### By Zip Code
`?zip={zip code},{country code}`

##An example request:

[http://worksample-api.herokuapp.com/weather?q=Stockholm,SE&key={API_KEY}](http://worksample-api.herokuapp.com/weather?q=Stockholm,SE&key={API_KEY})
