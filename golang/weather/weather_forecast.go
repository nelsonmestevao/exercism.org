// Package weather has the ability to check the current weather.
package weather

// CurrentCondition is the current weather condition.
var CurrentCondition string
// CurrentLocation is the city.
var CurrentLocation string

// Forecast returns the weather situation for the current city.
func Forecast(city, condition string) string {
	CurrentLocation, CurrentCondition = city, condition
	return CurrentLocation + " - current weather condition: " + CurrentCondition
}
