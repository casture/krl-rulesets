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
      long_trip = 1000;
      mileage = events:attrs("mileage").defaultsTo(10, "could not get event").klog("Mileage: ");
    }
    always {
      raise explicit event 'found_long_trip' 
        with trip = mileage
        if (mileage > long_trip);
    }
  }
}

