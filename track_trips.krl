ruleset track_trips {

  meta {
    name "Track Trips"
    description <<
2nd Ruleset for Reactive Pico lab
>>
    author "Micah Weatherhead"
    logging on
  }
  
  global {
    long_trip = 1000;
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
    fired {
      raise explicit event 'trip_processed'
        attributes event:attrs()
    }
  }
  
  rule find_long_trips {
    select when explicit trip_processed
    pre {
      mileage = event:attr("mileage").defaultsTo(10, "could not get event").klog("Mileage: ");
    }
    { noop() }
    always {
      raise explicit event 'found_long_trip' 
        with trip = mileage
    }
  }
}

