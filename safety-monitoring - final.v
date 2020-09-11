`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2019 10:04:48 AM
// Design Name: 
// Module Name: weatherMatic3000
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module weatherMatic3000(input manualTrigger, output noEmergency, output AuthorityContacted, output confirmedEmergency, 
input isSystemTest, input carbonSensor, input isPowerOff,input loudNoise, input localAlert,output nonSpecificEmergency, 
input isRaining, input reportedMedicalEmergency, input unwantedPersonDetected, output warnStudents,output isFire, 
output isStorm, output isMedicalEmergency, output lockdownNeeded, output heightenedSecurity, 
output needEvacuation, input isAllClear, output allClear);

//Set all the outputs as registers to use later.
reg confirmedEmergency, AuthorityContacted, nonSpecificEmergency, isMedicalEmergency, 
warnStudents, isFire, isStorm, allClear, heightenedSecurity, noEmergency, needEvacuation, lockdownNeeded;

//Begin the logic loop
always @(isSystemTest or manualTrigger or isRaining or reportedMedicalEmergency or carbonSensor
 or isPowerOff or loudNoise or localAlert or isMedicalEmergency or isAllClear or unwantedPersonDetected)
    begin
     noEmergency<=1;
     allClear <=0;
     confirmedEmergency <= 0;
     AuthorityContacted <= 0;
     nonSpecificEmergency <=0;
     isMedicalEmergency <=0;
     warnStudents <= 0;
     isFire <=0;
     isStorm <=0;
     heightenedSecurity <=0;
     needEvacuation <=0;
     lockdownNeeded <=0;
        //When the Manual Trigger or Power Off is detected, change state of emergency from none to an unidentified emergency
        if(manualTrigger ==1 || isPowerOff ==1 ||loudNoise ==1)
            begin
            noEmergency <= 0;
            nonSpecificEmergency <= 1;
            //When carbonSensor is activated and an unidentified emergency is activated, 
            //system detects fire and sends various output states 
            if(carbonSensor ==1)
                begin
                nonSpecificEmergency <=0;
                confirmedEmergency <=1;
                isFire <=1;
                //when not a system test
                if(isSystemTest==0)
                    begin
                    warnStudents <=1;
                    AuthorityContacted <=1;
                    needEvacuation <=1;
                    //when the all clear is given
                    if(isAllClear==1)
                        begin  
                        confirmedEmergency <=0;
                        isFire <=0;
                        warnStudents <=0;
                        AuthorityContacted <=0;
                        needEvacuation <=0;
                        allClear <=1;
                        noEmergency <=1;
                        end
                    end
                //when a system test
                else
                    begin
                    allClear <= 1;
                    confirmedEmergency <=0;
                    isFire <= 0;
                    noEmergency <=1;
                    end
                end
            //System detects a storm
            else if (isRaining ==1)
                begin 
                nonSpecificEmergency <= 0;
                confirmedEmergency <=1;
                isStorm <= 1;
                if(isSystemTest==0)
                    begin
                    warnStudents <=1;
                    AuthorityContacted <=1;
                    needEvacuation <=1;
                    //when the all clear is given
                    if(isAllClear==1)
                        begin  
                        confirmedEmergency <=0;
                        isStorm <=0;
                        warnStudents <=0;
                        AuthorityContacted <=0;
                        needEvacuation <=0;
                        allClear <=1;
                        noEmergency <=1;
                        end
                    end
                //when a system test
                else
                    begin
                    allClear <= 1;
                    confirmedEmergency <=0;
                    isStorm <= 0;
                    noEmergency <=1;
                    end
                end
            end
        //Go to a state of caution with a local alert out
        if (localAlert ==1)
            begin
            noEmergency <= 0;
            heightenedSecurity <= 1;
            //If a loud noise or unwantedPersonDetected with heightenedSecurity, 
	    //go to lockdownNeeded and contact authorities
            if(loudNoise == 1 || unwantedPersonDetected ==1)
                begin
                lockdownNeeded <= 1;
                nonSpecificEmergency <=0;
                confirmedEmergency <=1;
                warnStudents <=1;
                AuthorityContacted <=1;
                end
            if(isAllClear==1)
                begin
                noEmergency <=1;
                 lockdownNeeded <= 0;
                heightenedSecurity <= 0;
                confirmedEmergency <= 0;
                warnStudents <=0;
                AuthorityContacted <=0;
                allClear <= 1;
                end
            end
        //When there is a reported medical emergency, contact authorities and wait for all clear
        if(reportedMedicalEmergency ==1)
            begin 
            noEmergency <=0;
            confirmedEmergency <=1;
            isMedicalEmergency <=1;
            AuthorityContacted <=1;
            if(isAllClear==1)
                    begin
                    noEmergency <=1;
                    confirmedEmergency <= 0;
                    isMedicalEmergency <=0;
                    AuthorityContacted <=0;
                    allClear <= 1;
                    end
            end

    end

endmodule