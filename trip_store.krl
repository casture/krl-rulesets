ruleset trip_store {
  meta {
    name "Trip Store"
    description <<
3rd Ruleset for Reactive Pico lab
>>
    author "Micah Weatherhead"
    logging on
    sharing on
    provides trips, long_trips, short_trips
  }
  
  global {
    trips = function() {
      ent:trips
    }
    long_trips = function() {
      ent:long_trips
    }
    short_trips = function() {
      short_trips = ent:trips.filter(function(t){
        index = ent:long_trips
          .map(function(lt){lt{"timestamp"}})
          .index(t{"timestamp"});
        index == -1
      });
      short_trips
    }
  }

  rule collect_trips {
    select when explicit trip_processed
    pre {
      mileage = event:attr("mileage");
      timestamp = time:now();
    }
    noop();
    always {
      set ent:trips ent:trips
          .defaultsTo([])
          .append([{
            "mileage": mileage,
            "timestamp": timestamp 
          }]);
    }
  }

  rule collect_long_trips {
    select when explicit found_long_trip
    pre {
      mileage = event:attr("mileage").klog("Mileage: ");
      timestamp = time:now();
    }
    noop();
    always {
      set ent:long_trips ent:long_trips
          .defaultsTo([])
          .append([{
            "mileage": mileage,
            "timestamp": timestamp 
          }]);
    }
  }
  
  rule clear_trips {
    select when car trip_reset
    noop();
    always {
      clear ent:trips;
      clear ent:long_trips;
    }
  }
}
