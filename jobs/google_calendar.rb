# encoding: UTF-8
require 'google/apis/calendar_v3'
require 'date'
require 'time'
require 'digest/md5'
require 'googleauth'
require 'json'
require_relative '../api_keys'

# Update these to match your own apps credentials

scope = 'https://www.googleapis.com/auth/calendar.readonly'

authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
	json_key_io: File.open('/home/hatf0/dev/tv_dashboard/key.json'),
	scope: scope)

# Start the scheduler
Calendar = Google::Apis::CalendarV3
SCHEDULER.every '15m', :first_in => 4 do |job|

  # Request a token for our service account
  authorizer.fetch_access_token!

  # Get the calendar API

  # Start and end dates
  now = DateTime.now
  c = Calendar::CalendarService.new
  c.authorization = authorizer
  result = c.list_events($calendarID,
		time_min: now.rfc3339,
		order_by: 'startTime',
		single_events: true,
		max_results: 6)

  send_event('googlecal', { events: result })

end
