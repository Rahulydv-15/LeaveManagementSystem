public class EditLeaveIFrameController {
    public String inputValue { get; set; }
    public Leave__c newLeave { get; set; }
    
    public void setInputValue() {
        inputValue = ApexPages.currentPage().getParameters().get('selectedLeaveId');
        newLeave=[Select Id, Name,Start_Date__c,End_Date__c,Reason__c,Manager_Email__c,Status__c,Email__c from Leave__c where Id=:inputValue];
    }
    public PageReference submitLeaveRequest(){
        newLeave.Status__c='Pending';
        // Insert the new leave request
        update newLeave;
        PageReference vsp2Page = Page.LeaveRequest;
        return vsp2Page;
    }
}