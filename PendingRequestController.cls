public class PendingRequestController {
    public String managerEmail { get; set; }
    public List<Leave__c> pendingLeaveRequests { get; set; }
    public Boolean displayLeaveRequests { get; set; }
    public Boolean showOtpBox { get; set; }
    public Id selectedLeaveId { get; set; }
    public String OTP { get; set; }
    public String enteredOtp { get; set; }
    
    public void validateOTP() {
        if (enteredOtp == OTP) {
            showRequests();
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid OTP'));
        }
    }
    
    public void generateOTP() {
        Integer min = 100000; // Minimum 6-digit number
        Integer max = 999999; // Maximum 6-digit number

        // Generate a random number within the specified range
        Integer randomNumber = Math.round(Math.random() * (max - min)) + min;

        OTP = String.valueOf(randomNumber);
        showOtpBox = true;

        // Send the OTP to the manager's email
        try {
            if (managerEmail == null || !Pattern.matches('[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}', managerEmail)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid email format'));
                return;
            }

            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new String[] { managerEmail });
            email.setSubject('OTP for Login To Leave Portal');
            email.setPlainTextBody('Your OTP for the Leave Portal is: ' + OTP);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'OTP sent to ' + managerEmail));
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Failed to send OTP: ' + ex.getMessage()));
        }
    }

    public void showRequests() {
        system.debug('Called');
        displayLeaveRequests = false;
        if (managerEmail != null && managerEmail != '') {
            pendingLeaveRequests = [
                SELECT Id, Name, Start_Date__c, End_Date__c, Reason__c, Manager_Email__c 
                FROM Leave__c 
                WHERE Status__c = 'Pending' AND Manager_Email__c = :managerEmail
            ];
            System.debug(pendingLeaveRequests);
            displayLeaveRequests = true;
        }
    }

    public void approveLeave() {
        try {
            if (selectedLeaveId != null) {
                Leave__c leave = [SELECT Id, Status__c FROM Leave__c WHERE Id = :selectedLeaveId];
                leave.Status__c = 'Approved';
                update leave;
            }
            showRequests();
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Failed to approve leave: ' + ex.getMessage()));
        }
    }

    public void rejectLeave() {
        try {
            if (selectedLeaveId != null) {
                Leave__c leave = [SELECT Id, Status__c FROM Leave__c WHERE Id = :selectedLeaveId];
                leave.Status__c = 'Rejected';
                update leave;
            }
            showRequests();
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Failed to reject leave: ' + ex.getMessage()));
        }
    }
}