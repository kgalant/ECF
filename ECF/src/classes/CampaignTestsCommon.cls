/*
** Class with common utility functionality for test classes
*/


@isTest
public class CampaignTestsCommon {
	
	static map<String, Communities__c> branches = new map<String,Communities__c>();
	
	public static boolean checkCampaignMemberOnCampaign (Id campaignId, Id contactId) {
		CampaignMember[] campaignMembers = getCampaignMembers(campaignId);
		boolean memberFound = false;
		for (CampaignMember cm : campaignMembers) {
			if (cm.ContactId == contactId) {
				memberFound = true;
				break;
			}
		}
		return memberFound;
	}
	
	public static CampaignMember[] getCampaignMembers(Id campaignId) {
		
		Campaign[] campaigns = [SELECT Id, Name, (SELECT contactID FROM Campaign.CampaignMembers) 
					FROM Campaign WHERE ID = :campaignId];
		return campaigns[0].CampaignMembers;					
	}
	
	public static String getBranchCustomIdByName (String branchName) {
		if (branches.size() < 1) {
			Communities__c[] brs = [SELECT Branch_ID__c, Name, ID FROM Communities__c];
			
			for (Communities__c b : brs) {
				branches.put(b.Name, b);
			}
		}
		String retVal = null;
		Communities__c b = branches.get(branchName);
		if (b != null) 
			retVal = b.Branch_ID__c;
		
		return retVal;
	}
}