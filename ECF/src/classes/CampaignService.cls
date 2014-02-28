/**
 * Main service class for the Campaign object.
 */
public with sharing class CampaignService {
	
	static String CAMPAIGN_TYPE = 'Programme Event';
	public static Id CAMPAIGN_FILTER_ID = null;
	
	static {
		// Extract Record Type definitions for filtering
		Schema.DescribeSObjectResult r = Campaign.SObjectType.getDescribe();
		Map<String,Schema.RecordTypeInfo> typesByName = r.getRecordTypeInfosByName();
	
		// Set the Id of the Record Type used for filtering
		CAMPAIGN_FILTER_ID = typesByName.get(CAMPAIGN_TYPE).getRecordTypeId();
	}
	
	/**
	 * Add existing members of the Programme to the new Program Event.
	 */
	public static List<CampaignMember> addMembersToProgramEvents(List<Campaign> events) {
		// List of the new CampaignMembers attached to events
		List<CampaignMember> newMembersForProgramEvents  = new List<CampaignMember>();
		
		// Loop through the events list if any are submitted
		if (events != null && events.size() > 0) {
			// Get the parent Programmes for all Program Events
			Map<Id, Campaign> programmes = getParentProgrammes(events);
			
			// Loop through all Programme Events, look up the parent Programme
			// matching the event record's parent id, extract the members for
			// the parent and assign them to the new event
			for (Campaign c : events) {
				// Filter out any unwanted Campaign types
				if (isProgrammeEvent(c)) {
					Campaign parent = programmes.get(c.ParentId);
					System.debug('Found parent ' + parent + ' for event ' + c);
					List<CampaignMember> members = parent.CampaignMembers;
					for (CampaignMember m : members) {
						newMembersForProgramEvents.add(createMemberForEvent(c, m));
					}			
				}
			}	
		}
	
		// Insert the new members created for the new events if any were collected
		if ( newMembersForProgramEvents.size() > 0) {			
			insert(newMembersForProgramEvents);
			System.debug('Inserted ' + newMembersForProgramEvents.size() + ' into the database');
		}
		System.debug('Returning ' + newMembersForProgramEvents.size() + ' new member records');
		return newMembersForProgramEvents;
	}
	
	/**
	 * Creates a map of parent Programme records for the Programme Events indexed by the 
	 * Id of parent Programme.
	 */
	 static Map<Id, Campaign> getParentProgrammes(List<Campaign> events) {
	 	// Create an array of parent programme ids
		List<Id> parentIds = new List<Id>();
		for (Campaign c : events) {
			parentIds.add(c.ParentId);
		}
		System.debug('Fetching members for Programmes ' + parentIds);
	
		// Query all parent campaigns for members
		Map<Id, Campaign> programmes = new Map<Id, Campaign>(
			[SELECT Id, Name, (SELECT ID, contactid FROM Campaign.CampaignMembers) FROM Campaign WHERE Id IN :parentIds]
		);
		System.debug('Map of parent Programmes ' + programmes);
		return programmes;
	 }
	 
	 /**
	  * Creates a new CampaignMember for the Programme Event as a copy of the
	  * original member.
	  */
	 static CampaignMember createMemberForEvent(Campaign event, CampaignMember originalMember) {
	 	System.debug('Cloning ' + originalMember);
		CampaignMember newMember = originalMember.clone(false, true);
		newMember.CampaignId = originalMember.Id;
		return newMember; 	
	 }
	 
	 /**
	  * Checks if a Campaign frecord is a Programme Event type
	  */
	 public static boolean isProgrammeEvent(Campaign campaign) {
		return (campaign.RecordTypeId != null && campaign.RecordTypeId == CAMPAIGN_FILTER_ID);	 	
	 }
}