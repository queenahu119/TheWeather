# TheWeather

Display current weather information of Sydney, Melbourne and Brisbane with OpenWeatherMap API.

## features

* MVVM in Swift
* Use OpenWeatherMap API
* Auto layout programmatically
* Show the loading animation


### Screenshots
<img src="https://github.com/queenahu119/TheWeather/blob/master/images/mainImage.jpg" width="250">

<img src="https://github.com/queenahu119/TheWeather/blob/master/images/detailImage.jpg" width="250">

## Getting Started


### CocoaPods


Install the pods and open the .xcworkspace file to see the project in Xcode.

```
$ cd project-name
$ pod install
$ open project-name.xcworkspace
```

### Setting APIKey on OpenWeatherMap 

[https://openweathermap.org/current](https://openweathermap.org/current)

Create new Constants.swift file

```
struct WeatherClient {
    static let AppID = "YOUR_APP_ID"
}
```


## Runtime Requirements

 * Swift 4.1