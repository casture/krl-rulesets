ruleset track_trips {

  meta {
    name "Track Trips"
    description <<
2nd Ruleset for Reactive Pico lab
>>
    author "Micah Weatherhead"
    logging on
  }

  rule process_trip {
    select when car new_trip
    pre {
      mileage = event:attr("mileage")
    }
    {
      send_directive("trip") with
        trip_length = mileage
    }
  }
}
