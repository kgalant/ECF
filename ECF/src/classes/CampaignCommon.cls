/**
*  Common utilities for all Campaign triggers/service classes
*/


public class CampaignCommon {
	
	static final String PROGRAMME = 'Programme';
	static final String PROGRAMMEEVENT = 'Programme Event';
	
	static map<Id,Campaign> campaigns = new map<Id,Campaign>();
	
	static map<Id,String> campaignRecordTypesById = new map<Id,String>();
	static map<String,Id> campaignRecordTypesByName = new map<String,Id>();
	
	private static void initCampaigns() {
		if (campaigns.size() < 1) {
			campaigns = new map<Id,Campaign>([
				
				SELECT 	Cycle__c, 
						Name, 
						Id, 
						ParentId, 
						RecordTypeId,
						(SELECT Id, Name FROM Campaign.ChildCampaigns), 
						(SELECT contactID FROM Campaign.CampaignMembers) 
				FROM Campaign 
				
				]);
		}
	}
	
	private static void initRecordTypes() {
		if (campaignRecordTypesById.size() < 1 || campaignRecordTypesByName.size() < 1) {
			Schema.DescribeSObjectResult r = Campaign.SObjectType.getDescribe();
			map<String,Schema.RecordTypeInfo> typesByName = r.getRecordTypeInfosByName();
			
			// get Programme
			
			Schema.RecordTypeInfo rt = typesByName.get(PROGRAMME);
			
			campaignRecordTypesById.put(rt.GetRecordTypeID(), rt.getName());
			campaignRecordTypesByName.put(rt.getName(), rt.GetRecordTypeID());
			
			// get Programme, ProgrammeEvent
			
			rt = typesByName.get(PROGRAMMEEVENT); 
			
			campaignRecordTypesById.put(rt.GetRecordTypeID(), rt.getName());
			campaignRecordTypesByName.put(rt.getName(), rt.GetRecordTypeID());
		}
	}
	
	public static boolean isCampaignTopLevel(Id campaignId) {
		// init campaign array if needed
		initCampaigns();
		
		Campaign c = campaigns.get(campaignId);
		if (c == null)
			return false;
		else if (c.ParentId == null)
			return true;	
		else
			return false;
	}
	
	public static String getCampaignRecordType(Id campaignId) {
		initCampaigns();
		initRecordTypes();
		
		String retval = null;
		
		try {
			retVal = campaignRecordTypesById.get(campaigns.get(campaignId).RecordTypeId);
		}
		catch (NullPointerException e) {
			// we assume a NPE means that either the campaign doesn't exist
			System.debug(LoggingLevel.DEBUG, '@@ tried to get a recordtype for campaign: ' + campaignId + ': ' + campaigns.get(campaignId) + ' but failed with a NPE');			
		}
		return retVal;
	}
	
	public static boolean isCampaignProgramme(Id campaignId) {
		if (getCampaignRecordType(campaignId) == PROGRAMME)
			return true;
		else
			return false;
	}
	public static boolean isCampaignProgrammeEvent(Id campaignId) {
		if (getCampaignRecordType(campaignId) == PROGRAMMEEVENT)
			return true;
		else
			return false;
	}
	
	public static boolean hasChildEvents(Id campaignId) {
		Campaign c = campaigns.get(campaignId);
		
		boolean hasChildEvents = false;
		
		for (Campaign cc : c.ChildCampaigns) {
			if (isCampaignProgrammeEvent(cc.Id)) {
				hasChildEvents = true;
				break;
			}
		}
		return hasChildEvents;
	}
}