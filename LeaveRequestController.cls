public class LeaveRequestController {
    public Leave__c newLeave { get; set; }
    public String Email {get; set; }
    public List<Leave__c> leaves { get; set; }
    public Boolean displayLeaves {get; set;}
    public Id selectedLeaveId { get; set; }
    public LeaveRequestController() {
        newLeave = new Leave__c();
    }
    public void showLeave(){
        displayLeaves=false;
        system.debug('callllasa');
        if(Email!=null && Email!=''){
            system.debug('callll');
            displayLeaves=true;
            leaves=[Select Id, Name,Start_Date__c,End_Date__c,Reason__c,Manager_Email__c,Status__c from Leave__c where Email__c=:Email];
        }
    }
    public void submitLeaveRequest() {
        
        newLeave.Status__c='Pending';
        // Insert the new leave request
        insert newLeave;
        
        // Show success message
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Leave request submitted successfully.'));
        
        // Reset the new leave request object
        newLeave = new Leave__c();
    }
    public PageReference goToVsp2() {
        
        PageReference vsp2Page = Page.EditLeaveIFrame; // Replace 'vsp2' with the name of your vsp2 page
        vsp2Page.getParameters().put('selectedLeaveId', selectedLeaveId);
        system.debug('I an called'+selectedLeaveId);
        
        return vsp2Page;
    }
}