tableextension 50021 tableextension50021 extends Job
{
    fields
    {
        field(5055; "Opportunity No."; Code[20])
        {
            Caption = 'Opportunity No.';
            TableRelation = Opportunity;
        }
        field(50000; "Payment Plan Code"; Code[20])
        {
            TableRelation = "Payment Plan"."Payment Plan Code" WHERE("Service Item No." = FILTER(''));
        }
        field(50001; "Contract No."; Code[20])
        {
            TableRelation = "Service Header"."No.";
        }
        field(50002; Consultant; Text[50])
        {
        }
        field(50003; PMC; Code[20])
        {
        }
        field(50004; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Estimation,Order';
            OptionMembers = Estimation,"Order";
        }
        field(50005; Stage; Option)
        {
            Caption = 'Stage';
            InitValue = Planning;
            OptionCaption = 'Planning,Quote,Approved,Pending,Closed,Cancelled,Invoicing';
            OptionMembers = Planning,Quote,Approved,Pending,Closed,Cancelled,Invoicing;

            trigger OnValidate()
            var
                JobPlanningLine: Record 1003;
            begin
                /*
                
                IF xRec.Status <> Status THEN BEGIN
                  IF Status = Status::Completed THEN BEGIN
                    VALIDATE(Complete,TRUE);
                    GET("No.");
                    Status := Status::Completed;
                    Complete := TRUE;
                    MODIFY;
                  END;
                  IF xRec.Status = xRec.Status::Completed THEN BEGIN
                    IF DIALOG.CONFIRM(StatusChangeQst) THEN
                      VALIDATE(Complete,FALSE)
                    ELSE
                      Status := xRec.Status;
                  END;
                  JobPlanningLine.SETCURRENTKEY("Job No.");
                  JobPlanningLine.SETRANGE("Job No.","No.");
                  JobPlanningLine.MODIFYALL(Status,Status);
                
                  MODIFY;
                END;
                */

            end;
        }
    }
}

