/**
 * Main service class for the Campaign object.
 */
public with sharing class CampaignService {
	
	/**
	 * Add existing members of the Programme to the new Program Event.
	 */
	public static List<CampaignMember> addMembersToProgramEvents(List<Campaign> events) {
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
	
		List<CampaignMember> newMembersForProgramEvents  = new List<CampaignMember>();
		
		for (Campaign c : events) {
			Campaign parent = programmes.get(c.ParentId);
			System.debug('Found parent ' + parent + ' for event ' + c);
			List<CampaignMember> members = parent.CampaignMembers;
			for (CampaignMember m : members) {
				System.debug('Cloning ' + m);
				CampaignMember n = m.clone(false, true);
				n.CampaignId = c.Id;
				newMembersForProgramEvents.add(n);
				System.debug('New CampaignMember added ' + n);
			}
			
		}
	
		if ( newMembersForProgramEvents.size() > 0) {
			// Insert the new members created for the new events
			insert(newMembersForProgramEvents);
			System.debug('Inserted ' + newMembersForProgramEvents.size() + ' into the database');
		}
		System.debug('Returning ' + newMembersForProgramEvents.size() + ' new member records');
		return newMembersForProgramEvents;
	}
}