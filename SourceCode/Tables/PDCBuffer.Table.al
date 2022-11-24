table 50017 "PDC Buffer"
{
    DrillDownPageID = 50089;
    LookupPageID = 50089;

    fields
    {
        field(1; "PDC Document No"; Code[20])
        {
            NotBlank = true;
        }
        field(2; "Contract No."; Code[20])
        {
            TableRelation = "Service Contract Header"."Contract No.";
        }
        field(3; "Customer No."; Code[20])
        {
            TableRelation = Customer;
        }
        field(4; "Customer Name"; Text[50])
        {
        }
        field(5; "Old Cheque Ref."; Code[20])
        {
        }
        field(6; "Old Cheque Amount"; Decimal)
        {
        }
        field(7; "Line No."; Integer)
        {
        }
        field(8; "Payment Method"; Option)
        {
            OptionCaption = ' ,Cheque,Bank,Cash,PDC';
            OptionMembers = " ",Cheque,Bank,Cash,PDC;
        }
        field(9; "New Cheque No."; Code[20])
        {
        }
        field(10; "New Cheque Date"; Date)
        {
        }
        field(11; Amount; Decimal)
        {
        }
        field(12; "Bal. Account Type"; Option)
        {
            OptionCaption = ' ,Customer,Vendor,G/L Account,Bank';
            OptionMembers = " ",Customer,Vendor,"G/L Account",Bank;

            trigger OnValidate()
            begin
                VALIDATE("Bal. Account No.", '');
            end;
        }
        field(13; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                           Blocked = CONST(false))
            ELSE
            IF ("Bal. Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Bal. Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Bal. Account Type" = CONST(Bank)) "Bank Account";
        }
    }

    keys
    {
        key(Key1; "PDC Document No", "Contract No.", "Old Cheque Ref.", "Old Cheque Amount", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure CreateCheckReplEntry()
    var
        PostDatedCheckLine: Record 50098;
        PostDatedCheckLine1: Record 50098;
        PostDatedCheckLastLine: Record 50098;
        LineNo: Integer;
        PaymentMethod: Record 289;
        PDCBuffer: Record 50017;
    begin
        // Old PDC Reference
        PostDatedCheckLine.RESET;
        PostDatedCheckLine.SETRANGE("Document No.", "PDC Document No");
        PostDatedCheckLine.SETRANGE("Check No.", "Old Cheque Ref.");
        PostDatedCheckLine.SETRANGE(Amount, "Old Cheque Amount");
        IF PostDatedCheckLine.FINDFIRST THEN;
        // Old PDC Reference
        // Find Last Line No
        PostDatedCheckLastLine.SETRANGE("Contract No.", "Contract No.");
        IF PostDatedCheckLastLine.FINDLAST THEN
            LineNo := PostDatedCheckLastLine."Line Number"
        ELSE
            LineNo := 10000;
        // Last Line No
        // Create New Replacement Line
        PDCBuffer.RESET;
        PDCBuffer.SETRANGE("PDC Document No", "PDC Document No");
        PDCBuffer.SETRANGE("Contract No.", "Contract No.");
        PDCBuffer.SETRANGE("Old Cheque Ref.", "Old Cheque Ref.");
        PDCBuffer.SETRANGE("Old Cheque Amount", "Old Cheque Amount");
        IF PDCBuffer.FINDSET THEN
            REPEAT
                PostDatedCheckLine1.INIT;
                PostDatedCheckLine1."Batch Name" := 'PDC';
                PostDatedCheckLine1."Line Number" := LineNo + 10000;
                PostDatedCheckLine1.VALIDATE("Document No.");
                PostDatedCheckLine1.VALIDATE("Contract No.", PDCBuffer."Contract No.");
                PostDatedCheckLine1."Check No." := PDCBuffer."New Cheque No.";
                PostDatedCheckLine1."Check Date" := PDCBuffer."New Cheque Date";
                PostDatedCheckLine1."Contract Due Date" := PDCBuffer."New Cheque Date";
                PostDatedCheckLine1."Account Type" := PostDatedCheckLine."Account Type";
                PostDatedCheckLine1.VALIDATE("Account No.", PostDatedCheckLine."Account No.");
                PostDatedCheckLine1.VALIDATE(Amount, PDCBuffer.Amount);
                PostDatedCheckLine1."Customer No." := PostDatedCheckLine."Customer No.";
                PostDatedCheckLine1."Customer Name" := PostDatedCheckLine."Customer Name";
                PostDatedCheckLine1."Payment Method" := PDCBuffer."Payment Method";
                PostDatedCheckLine1."Bal. Account Type" := PDCBuffer."Bal. Account Type";
                PostDatedCheckLine1."Bank Account" := PDCBuffer."Bal. Account No.";
                PostDatedCheckLine1."Dimension Set ID" := PostDatedCheckLine."Dimension Set ID";
                PostDatedCheckLine1.INSERT;
                LineNo := PostDatedCheckLine1."Line Number";
            UNTIL PDCBuffer.NEXT = 0;
        // Delete Buffer Entries
        PDCBuffer.RESET;
        PDCBuffer.SETRANGE("PDC Document No", "PDC Document No");
        PDCBuffer.SETRANGE("Contract No.", "Contract No.");
        PDCBuffer.SETRANGE("Old Cheque Ref.", "Old Cheque Ref.");
        PDCBuffer.SETRANGE("Old Cheque Amount", "Old Cheque Amount");
        IF PDCBuffer.FINDFIRST THEN
            PDCBuffer.DELETEALL;
        // Delete Buffer Entries
    end;
}

