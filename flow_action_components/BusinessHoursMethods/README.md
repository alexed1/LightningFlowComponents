# Business Hours


also see https://unofficialsf.com/from-renato-oliveira-new-business-hours-actions/


Exposes the methods from the Business Hours class in Apex to the flow.

## Add hours

Adds an interval of time from a start Datetime traversing business hours only. Returns the result Datetime in the local time zone.

### Signature

|Parameter|Name|Note|
|---|---|---|
|businessHoursId|Business Hours ID|The business hours ID.|
|startDate|Start Date/time||
|intervalSeconds|Interval (in seconds)||

### Returns

A date/time value with the added seconds.

## Add hours (GMT)

Adds an interval of milliseconds from a start Datetime traversing business hours only. Returns the result Datetime in GMT.

### Signature

|Parameter|Name|Note|
|---|---|---|
|businessHoursId|Business Hours ID|The business hours ID.|
|startDate|Start Date/time||
|intervalSeconds|Interval (in seconds)||

### Returns

A date/time value with the added seconds in GMT.

## Diff

Returns the difference in milliseconds between a start and end Datetime based on a specific set of business hours.

### Signature

|Parameter|Name|Note|
|---|---|---|
|businessHoursId|Business Hours ID|The business hours ID.|
|startDate|Start Date/time||
|endDate|End Date/time||

### Returns

Returns the number of seconds between the two date/time parameters.

## Is Within

Returns true if the specified target date occurs within business hours. Holidays are included in the calculation.

### Signature

|Parameter|Name|Note|
|---|---|---|
|businessHoursId|Business Hours ID|The business hours ID.|
|startDate|Start Date/time|The date to verify.|

### Returns

A boolean value (true/false)

## Next Start Date

Starting from the specified target date, returns the next date when business hours are open. If the specified target date falls within business hours, this target date is returned.

### Signature

|Parameter|Name|Note|
|---|---|---|
|businessHoursId|Business Hours ID|The business hours ID.|
|startDate|Start Date/time|The date used as a start date to obtain the next date.|

### Returns

Returns the next date when business hours are open.
