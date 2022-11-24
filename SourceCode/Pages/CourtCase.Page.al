page 50085 "Court Case"
{
    Caption = 'Court Case Entries';
    CardPageID = "Court Case Details";
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
                field("Customer Balance"; Rec."Customer Balance")
                {
                    ApplicationArea = All;
                }
                field(Link; Rec.Link)
                {
                    ApplicationArea = All;
                }
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = All;
                }
                field("PDC No."; Rec."PDC No.")
                {
                    ApplicationArea = All;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = All;
                }
                field("Apply to ID"; Rec."Apply to ID")
                {
                    ApplicationArea = All;
                }
                field(Apply; Rec.Apply)
                {
                    ApplicationArea = All;
                }
                field("Apply to Doc No."; Rec."Apply to Doc No.")
                {
                    ApplicationArea = All;
                }
                field("Applied Amount"; Rec."Applied Amount")
                {
                    ApplicationArea = All;
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
            systempart(RecordLinks; Links)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Apply Entries")
            {
                ApplicationArea = All;
                Caption = 'Apply Entries';
                Image = Apply;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.TESTFIELD("Customer Balance");
                    //Custledger.AddDocNo(Rec."Case No.", Rec."Tenant No.");
                    Custledger.RUN;
                end;
            }
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
                    //CreateInteraction;
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

    var
        Custledger: Page 50086;
}

