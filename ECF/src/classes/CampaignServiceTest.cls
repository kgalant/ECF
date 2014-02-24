/**
 * Unit test class for the CampaignService.
 */
@isTest
class CampaignServiceTest {

	// Test exsisting member of a Programme is added to a new event
	@isTest static void testAddMembersToProgramEvent() {
		Campaign programme = CampaignTestDataFactory.createProgramme();
		Campaign event = CampaignTestDataFactory.createProgramEvent(programme);
		CampaignService.addMembersToProgramEvent(programme, event);  
		
		System.assert(false);
	} 
	
}