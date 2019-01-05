$calendarID = '' # Calendar ID. This should be an email or 'primary'.
$last_fm_api_key = '' # last.fm API Key. You can get this pretty easily.
$weather_api_key = '' # OpenWeatherMap API Key
$airnow_api_key = '' # AirNow.gov api key

# As well, you'll want to create a new service/project in the Google Cloud Engine
# and enable the Google Calendar API, then create new credentials for a service account
# and give it owner access to the project. Put the credentials (in JSON format)
# in the root directory, and name it key.json. This will enable the widget to properly
# access the events that only your account has access to.
