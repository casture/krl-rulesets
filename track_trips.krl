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
    noop();
    fired {
      raise explicit event 'trip_processed'
        attributes event:attrs()
    }
  }
  
  rule find_long_trips {
    select when explicit trip_processed
    pre {
      mileage = event:attr("mileage").defaultsTo(15, "dumbzzzzzz").klog("Mileage: ");
    }
    { 
      send_directive("find_trip") with
        long_trip_length = mileage
    }
    fired {
      log "Long trip limit: "+long_trip;
      raise explicit event 'found_long_trip' 
        with trip = mileage
        if (mileage > long_trip);
    }
  }
  
  rule found_long_trip {
    select when explicit found_long_trip
    pre {
      x = trip.klog("Long trip: ")
    }
  }
}

