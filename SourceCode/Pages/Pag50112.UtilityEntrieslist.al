page 50112 "Utility Entries list"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Utility Entries";
    Caption = 'Utility Entries';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                ShowCaption = false;

                field("Utility Date"; Rec."Utility Date")
                {
                    ToolTip = 'Specifies the value of the Utility Date field.';
                    ApplicationArea = All;
                    Caption = 'Utility Date';
                }
                field("Utility Code "; Rec."Utility Code")
                {
                    ToolTip = 'Specifies the value of the Utility Code  field.';
                    ApplicationArea = All;
                    Caption = 'Utility Code';
                }
                field("Unit Code"; Rec."Unit Code")
                {
                    ToolTip = 'Specifies the value of the Unit Code field.';
                    ApplicationArea = All;
                    Caption = 'Unit Code';
                }
                field("Meter Reading"; Rec."Meter Reading")
                {
                    ToolTip = 'Specifies the value of the Meter Reading field.';
                    ApplicationArea = All;
                    Caption = 'Meter Reading';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                    ApplicationArea = All;
                    Caption = 'Amount';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer No. field.';
                }
                field("Service Invoice No."; Rec."Service Invoice No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Service Invoice No. field.';
                }
                field("Posted Service Invoice No."; Rec."Posted Service Invoice No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posted Service Invoice No. field.';
                }
                field("Error Message"; Rec."Error Message")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Error Message field.';
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ImportUtilityEntries)
            {
                ApplicationArea = All;
                Caption = 'Import Utility Entries';

                trigger OnAction()
                begin
                    UtilityEntriesManagement.ImportUtilityEntriesFromCSVUsingCSVBuffer();
                end;
            }
            action(ProcessUtilityEntries)
            {
                ApplicationArea = All;
                Caption = 'Process Utility Entries';

                trigger OnAction()
                begin
                    UtilityEntriesManagement.ProcessUtilityEntries();
                end;
            }
        }
    }
    var
        UtilityEntriesManagement: Codeunit "Utility Entries Management";
}