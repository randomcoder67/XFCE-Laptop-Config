#!/usr/bin/env python3

weatherSymbols = {
	"Clear night": "",
	"Sunny day": "",
	"Partly cloudy (night)": "  ",
	"Sunny intervals": "",
	"Mist": "",
	"Fog": "FOG",
	"Cloudy": "",
	"Overcast": " ",
	"Light shower (night)": "",
	"Light shower (day)": "",
	"Drizzle": "DRIZ",
	"Light rain": "",
	"Heavy shower (night)": " ",
	"Heavy shower (day)": " ",
	"Heavy rain": "",
	"Sleet shower (night)": " ",
	"Sleet shower (day)": " ",
	"Sleet": "",
	"Hail shower (night)": "HAIL ",
	"Hail shower (day)": "HAIL ",
	"Hail": "HAIL",
	"Light snow shower (night)": " ",
	"Light snow shower (day)": " ",
	"Light snow": "",
	"Heavy snow shower (night)": " ",
	"Heavy snow shower (day)": " ",
	"Heavy snow": "",
	"Thunder shower (night)": " ",
	"Thunder shower (day)": " ",
	"Thunder": ""
}

weatherColors = {
	"colorYellow": ["Sunny day", "Sunny intervals", "Clear night"],
	"colorWhite": ["Cloudy", "Overcast", "Partly cloudy (night)"],
	"colorMagenta": ["Light snow shower (night)", "Light snow shower (day)", "Heavy snow shower (night)", "Heavy snow shower (day)", "Light snow", "Heavy snow", "Sleet shower (night)", "Sleet shower (day)", "Sleet"],
	"colorRed": ["Thunder", "Thunder shower (night)", "Thunder shower (day)", "Fog"],
	"colorGreen": [],
	"colorBlue": ["Light shower (night)", "Light shower (day)", "Light rain", "Drizzle", "Mist", "Heavy shower (night)", "Heavy shower (day)", "Heavy rain", "Hail shower (night)", "Hail shower (day)", "Hail"],
	"colorCyan": []
}

windDirection = {
	"S": "",
	"W": "",
	"N": "",
	"E": "",
	"SW": " ",
	"NW": " ",
	"SE": " ",
	"NE": " ",
	"SSW": "",
	"WNW": "",
	"WSW": "",
	"NNW": "",
	"SSE": "",
	"ESE": "",
	"ENE": "",
	"NNE": ""
}
	
rowLabels = ["Time", "Weather Symbol", "Change of Precipitation", "Temperature (°C)", "Feels like temperature (°C)", "Wind direction and speed", "Wind gust", "Visibility", "Humidity", "UV"]
