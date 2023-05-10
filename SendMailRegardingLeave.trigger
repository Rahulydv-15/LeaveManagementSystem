trigger SendMailRegardingLeave on Leave__c (after update) {
    List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
    for(Leave__c leave : Trigger.new){
        if(leave.Email__c != null){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new String[] {leave.Email__c}); // use the account's email address as the recipient
            email.setSubject('Leave : ' + leave.Status__c);
            email.setPlainTextBody('Information About Your Leave Request:\n\nName: ' + leave.Name + 
                                   '\nManager: ' + leave.Manager_Email__c +'\nStart Date: '+leave.Start_Date__c+'\nEnd Date: '
                                  +leave.End_Date__c);
            emails.add(email);
            System.debug('Email queued for sending.');
        }
    }
    if(!emails.isEmpty()){
        Messaging.sendEmail(emails);
        System.debug('Email(s) sent successfully.');
    }
}