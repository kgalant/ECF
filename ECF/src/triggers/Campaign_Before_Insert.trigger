/**
* 
*/
trigger Campaign_Before_Insert on Campaign (before insert) {
	System.debug(loggingLevel.INFO, 'Start på trigger');
}