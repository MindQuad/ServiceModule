page 50058 "Emp Expiry Doc List"
{
    AutoSplitKey = true;
    Caption = 'Employee Expiry Documents';
    DataCaptionFields = "Employee No.";
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = 5216;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Confidential Code"; Rec."Confidential Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a code to define the type of confidential information.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies a description of the confidential information.';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                }
                field("Document No"; Rec."Document No")
                {
                    ApplicationArea = All;
                }
                field("Document Name"; Rec."Document Name")
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                }
                field("Issue Date"; Rec."Issue Date")
                {
                    ApplicationArea = All;
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                }
                field(Link; Rec.Link)
                {
                    ApplicationArea = All;
                    ExtendedDatatype = URL;
                }
                field("No. of Days"; Rec."No. of Days")
                {
                    ApplicationArea = All;
                }
                field("Reminder Date"; Rec."Actual Date")
                {
                    ApplicationArea = All;
                    Caption = 'Reminder Date';
                }
            }
        }
    }

    actions
    {
    }
}

