ruleset trip_store {
  meta {
    name "Trip Store"
    description <<
3rd Ruleset for Reactive Pico lab
>>
    author "Micah Weatherhead"
    logging on
  }

  rule collect_trips {
    select when explicit trip_processed
    pre {
      mileage = event:attr("mileage");
      timestamp = event:attr("timestamp").klog("Timestamp: ");
    }
    noop();
    always {
      set ent:processed_trips [] 
        if not ent:processed_trips.length eq 0;
      set ent:processed_trips.append({
        "mileage": mileage,
        "timestamp": timestamp 
      });
    }
  }

}
