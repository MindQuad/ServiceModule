PageExtension 50184 pageextension50184 extends "Source Code Setup"
{
    layout
    {
        addafter("Cash Flow Worksheet")
        {
            field("Expense Source Code"; Rec."Expense Source Code")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Cost Accounting")
        {
            group(Payroll)
            {
                Caption = 'Payroll';
                field("Vacation Order"; Rec."Vacation Order")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the source code for the vacation order.';
                }
                field("Sick Leave Order"; Rec."Sick Leave Order")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the source code for the sick leave order.';
                }
                field("Travel Order"; Rec."Travel Order")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the source code for the travel order.';
                }
                field("Other Absence Order"; Rec."Other Absence Order")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the source code for the other absence orders.';
                }
                field("Payroll Calculation"; Rec."Payroll Calculation")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the source code for the advance payroll calculation.';
                }
                field("Compress Payroll Journal"; Rec."Compress Payroll Journal")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the source code for the compress payroll journal.';
                }
                field("Employee Journal"; Rec."Employee Journal")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the source code for the employee journal.';
                }
            }
        }
    }
}

