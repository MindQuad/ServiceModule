tableextension 50101 "Employee Ledger Entry Ext" extends "Employee Ledger Entry"
{
    fields
    {
        field(50000; Adjustment; Boolean)
        {
            Caption = 'Adjustment';
        }
        field(50001; "BAS Adjustment"; Boolean)
        {
            Caption = 'BAS Adjustment';
        }
        field(50002; "Adjustment Applies-to"; Code[20])
        {
            Caption = 'Adjustment Applies-to';
        }
        field(50003; "Pre Adjmt. Reason Code"; Code[10])
        {
            Caption = 'Pre Adjmt. Reason Code';
            TableRelation = "Reason Code";
        }
        field(50004; "Financially Voided Cheque"; Boolean)
        {
            Caption = 'Financially Voided Cheque';
        }
        field(50005; "EFT Register No."; Integer)
        {
            BlankZero = true;
            Caption = 'EFT Register No.';
            TableRelation = "EFT Register";
        }
        field(50006; "EFT Amount Transferred"; Decimal)
        {
            Caption = 'EFT Amount Transferred';
        }
        field(50007; "EFT Bank Account No."; Code[10])
        {
            Caption = 'EFT Bank Account No.';
        }
        field(50008; "Rem. Amt for WHT"; Decimal)
        {
            Caption = 'Rem. Amt for WHT';
        }
        field(50009; "Rem. Amt"; Decimal)
        {
            Caption = 'Rem. Amt';
        }
        field(50010; "HR Order No."; Code[20])
        {
            Caption = 'HR Order No.';
            Editable = false;
        }
        field(50011; "HR Order Date"; Date)
        {
            Caption = 'HR Order Date';
            Editable = false;
        }
        field(50012; "Element Code"; Code[20])
        {
            Caption = 'Element Code';
            TableRelation = "Payroll Element";
        }
        field(50013; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(50014; "Calendar Code"; Code[10])
        {
            Caption = 'Calendar Code';
            TableRelation = "Payroll Calendar";
        }
        field(50015; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = "Labor Contract" WHERE("Employee No." = FIELD("Employee No."));
        }
        field(50016; "Position No."; Code[20])
        {
            Caption = 'Position No.';
            TableRelation = Position;
        }
        field(50017; "Wage Period From"; Code[10])
        {
            Caption = 'Wage Period From';
            TableRelation = "Payroll Period";
        }
        field(50018; "Wage Period To"; Code[10])
        {
            Caption = 'Wage Period To';
            Editable = false;
            TableRelation = "Payroll Period";
        }
        field(50019; "Time Activity Code"; Code[10])
        {
            Caption = 'Time Activity Code';
            TableRelation = "Time Activity";
        }
        field(50020; "Posting Group"; Code[20])
        {
            Caption = 'Posting Group';
            TableRelation = "Payroll Posting Group";
        }
        field(50021; "Payroll Calc Group"; Code[10])
        {
            Caption = 'Payroll Calc Group';
            TableRelation = "Payroll Calc Group";
        }
        field(50022; "AE Period From"; Code[10])
        {
            Caption = 'AE Period From';
            TableRelation = "Payroll Period";
        }
        field(50023; "AE Period To"; Code[10])
        {
            Caption = 'AE Period To';
            TableRelation = "Payroll Period";
        }
        field(50024; "Payment Percent"; Decimal)
        {
            Caption = 'Payment Percent';
        }
        field(50025; "Days Not Paid"; Decimal)
        {
            Caption = 'Days Not Paid';
        }
        field(50026; "Relative Person No."; Code[20])
        {
            Caption = 'Relative Person No.';
        }
        field(50027; "External Document Date"; Date)
        {
            Caption = 'External Document Date';
        }
        field(50028; "External Document Issued By"; Text[50])
        {
            Caption = 'External Document Issued By';
        }
        field(50029; "Entry Type"; Option)
        {
            OptionCaption = ' ,Initial Entry,Application,Unrealized Loss,Unrealized Gain,Realized Loss,Realized Gain,Payment Discount,Payment Discount (VAT Excl.),Payment Discount (VAT Adjustment),Appln. Rounding,Correction of Remaining Amount';
            OptionMembers = " ","Initial Entry",Application,"Unrealized Loss","Unrealized Gain","Realized Loss","Realized Gain","Payment Discount","Payment Discount (VAT Excl.)","Payment Discount (VAT Adjustment)","Appln. Rounding","Correction of Remaining Amount";
        }
        field(50030; "Payroll Parameter"; Code[10])
        {
            TableRelation = "Payroll Element";
        }
        field(50031; "Pay Type"; Option)
        {
            OptionCaption = ' ,Basic Salary,Housing,Transport,Re-imbursement,Deduction,Claim,Over Time,Loan,Advance,Leave Salary Accr,Allowance,Air Passage Accr,Bonus Accr,Gratuity Accr,Leave Salary,Gratuity,Air Passage,Bonus,National Pension Accr,Pension Payment,Commission,Others,Payment';
            OptionMembers = " ","Basic Salary",Housing,Transport,"Re-imbursement",Deduction,Claim,"Over Time",Loan,Advance,"Leave Salary Accr",Allowance,"Air Passage Accr","Bonus Accr","Gratuity Accr","Leave Salary",Gratuity,"Air Passage",Bonus,"National Pension Accr","Pension Payment",Commission,Others,Payment;
        }
        field(50032; "Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,Employee';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset",Employee;
        }
        field(50033; "Account No."; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Account Type" = CONST(Employee)) Employee;
        }
        field(50034; "Emp. Absence Reg. Entry No."; Code[20])
        {
            TableRelation = "Posted Leave Registrations"."Entry No." WHERE("Entry No." = FIELD("Emp. Absence Reg. Entry No."));
        }
        field(50035; "Accrual Entry Type"; Option)
        {
            OptionCaption = ' ,Leave Salary,Gratuity,Travel,Bonus';
            OptionMembers = " ","Leave Salary",Gratuity,Travel,Bonus;
        }
    }

    keys
    {
        key(NewKey; "Element Code") { }
    }
    var
        myInt: Integer;
}