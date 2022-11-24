page 50120 "Court Case Entries"
{
    PageType = List;
    SourceTable = 50014;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Case No."; Rec."Case No.")
                {
                    ApplicationArea = All;
                }
                field("PDC No."; Rec."PDC No.")
                {
                    ApplicationArea = All;
                }
                field("Building No."; Rec."Building No.")
                {
                    ApplicationArea = All;
                }
                field("Unit No."; Rec."Unit No.")
                {
                    ApplicationArea = All;
                }
                field("Tenant No."; Rec."Tenant No.")
                {
                    ApplicationArea = All;
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                }
                field("Tenant Contract No."; Rec."Tenant Contract No.")
                {
                    ApplicationArea = All;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = All;
                }
                field("Request Start Date"; Rec."Request Start Date")
                {
                    ApplicationArea = All;
                }
                field("Case Status"; Rec."Case Status")
                {
                    ApplicationArea = All;
                }
                field("Case Document No."; Rec."Case Document No.")
                {
                    ApplicationArea = All;
                }
                field(Remark; Rec.Remark)
                {
                    ApplicationArea = All;
                }
                field("Cust Bal as claimed in court"; Rec."Customer Balance")
                {
                    ApplicationArea = All;
                    Caption = 'Cust Bal as claimed in court';
                }
                field("Apply to ID"; Rec."Apply to ID")
                {
                    ApplicationArea = All;
                }
                field("Applied Amount"; Rec."Applied Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Balancing Amount"; Rec."Balancing Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Recordlinks; Links)
            {
                Visible = true;
            }
        }
    }

    actions
    {
    }
}

