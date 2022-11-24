page 50119 "Court Case Details"
{
    PageType = Card;
    SourceTable = 50014;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Document No."; Rec."Case No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Tenant Contract No."; Rec."Tenant Contract No.")
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
                    trigger OnValidate()
                    begin
                        RecCust.RESET;
                        RecCust.SETRANGE(RecCust."No.", Rec."Tenant No.");
                        IF RecCust.FINDFIRST THEN
                            Rec."Tenant Name" := RecCust.Name;
                    end;
                }
                field("Tenant Name"; Rec."Tenant Name")
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
            }
        }
        area(factboxes)
        {
            systempart(RecordsLinks; Links)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Related)
            {
                action("Create &Interact")
                {
                    AccessByPermission = TableData 5062 = R;
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Create &Interact';
                    Image = CreateInteraction;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Create an interaction with a specified contact.';

                    trigger OnAction()
                    begin
                        Rec.CreateInteraction;
                    end;
                }
                action("Interaction Log E&ntries")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Interaction Log E&ntries';
                    Image = InteractionLog;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Interaction Log Entries";
                    RunPageLink = "Court Case No." = FIELD("Case No.");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View interaction log entries for the salesperson/purchaser.';
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Creation Date" := WORKDATE;
    end;

    var
        RecCust: Record 18;
}

