/**
* 
*/
trigger Campaign_Before_Insert on Campaign (before insert) {
	System.debug(loggingLevel.INFO, 'Entering Trigger: Campaign_Before_Insert');

	// Extract Record Type definitions for filtering
	Schema.DescribeSObjectResult r = Campaign.SObjectType.getDescribe();
	Map<String,Schema.RecordTypeInfo> typesByName = r.getRecordTypeInfosByName();
	
	Schema.RecordTypeInfo rt = typesByName.get('Programme');
	
	List<Campaign> programmes = new List<Campaign>();
	
	// Iterate over each Campaign object 
	for (Campaign c : Trigger.new) {
		System.debug('Examining Campaign: ' + c.Name);
		// Filter on Record Type Programme only
		System.debug('Record Type Id = ' + c.RecordTypeId);
		if (c.RecordTypeId != null && c.RecordTypeId == rt.getRecordTypeId()) {
			// Record is a Programme
			System.debug('Campaign is of type Programme');
			programmes.add(c);
		}
	}
	
	if(programmes.size() > 0) {
		System.debug(programmes.size() + ' Programme records sent to service');
		// TO-DO: Do something
	}
	System.debug(loggingLevel.INFO, 'Exiting Trigger: Campaign_Before_Insert');
}