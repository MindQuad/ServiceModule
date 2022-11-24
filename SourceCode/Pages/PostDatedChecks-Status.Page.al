Page 50016 "Post Dated Checks - Status"
{
    AutoSplitKey = true;
    Caption = 'Post Dated Checks - Status';
    DelayedInsert = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Document;
    SaveValues = true;
    SourceTable = "Post Dated Check Line";
    SourceTableView = sorting("Line Number")
                      where("Account Type" = filter(" " | Customer | "G/L Account"));

    layout
    {
        area(content)
        {
            group(Options)
            {
                Caption = 'Options';
                field(DateFilter; DateFilter)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Date Filter';

                    trigger OnValidate()
                    begin
                        DateFilterOnAfterValidate;
                    end;
                }
                field(CustomerNo; CustomerNo)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Clear(CustomerList);
                        CustomerList.LookupMode(true);
                        if not (CustomerList.RunModal = Action::LookupOK) then
                            exit(false);

                        Text := CustomerList.GetSelectionFilter;
                        exit(true);

                        UpdateCustomer;
                        Rec.SetFilter("Check Date", Rec.GetFilter("Date Filter"));
                        if not Rec.FindFirst then
                            UpdateBalance;
                    end;

                    trigger OnValidate()
                    begin
                        CustomerNoOnAfterValidate;
                    end;
                }
                field(ContractFilter; ContractFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Contract Filter';
                    TableRelation = "Service Contract Header"."Contract No." where("Contract Type" = const(Contract));

                    trigger OnValidate()
                    begin
                        ContractNoOnAfterValidate; //WIN325
                    end;
                }
                field(StatusFilter; StatusFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Status Filter';

                    trigger OnValidate()
                    begin
                        StatusOnAfterValidate; //WIN325
                    end;
                }
            }
            repeater(Control1500007)
            {
                field(AccountType; Rec."Account Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Select the type of account that the entry on the journal line will be posted to.';
                }
                field(AccountNo; Rec."Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Select the number of the account that the entry on the journal line will be posted to.';
                }
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the document no. for this post-dated check journal.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the description for the post-dated check journal line.';
                }
                field(BankAccount; Rec."Bank Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the bank account No. where you want to bank the post-dated check.';
                    Visible = false;
                }
                field(CheckDate; Rec."Check Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date of the post-dated check when it is supposed to be banked.';
                }
                field(CheckNo; Rec."Check No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the check No. for the post-dated check.';
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the currency code of the post-dated check.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Amount of the post-dated check.';
                }
                field(AmountLCY; Rec."Amount (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies this is an auto-generated field which calculates the LCY amount.';
                }
                field(DateReceived; Rec."Date Received")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date when we received the post-dated check.';
                }
                field(ReplacementCheck; Rec."Replacement Check")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies this is an indicator field that this check is a replacement for any earlier unusable check.';
                }
                field(AppliestoDocType; Rec."Applies-to Doc. Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies this field is used if the journal line will be applied to an already-posted document.';
                }
                field(AppliestoDocNo; Rec."Applies-to Doc. No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies this field is used if the journal line will be applied to an already-posted document.';
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the comment for the transaction for your reference.';
                }
                field(BatchName; Rec."Batch Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a default batch.';
                }
                field(ContractNo; Rec."Contract No.")
                {
                    ApplicationArea = Basic;
                }
                field(BuildingNo; Rec."Building No.")
                {
                    ApplicationArea = Basic;
                }
                field(UnitNo; Rec."Unit No.")
                {
                    ApplicationArea = Basic;
                }
                field(UnpostedServiceInvoiceNo; Rec."Unposted Service Invoice No.")
                {
                    ApplicationArea = Basic;
                }
                field(ReceiptExchangeRate; Rec."Receipt Exchange Rate")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field(ReversalReasonCode; Rec."Reversal Reason Code")
                {
                    ApplicationArea = Basic;
                }
                field(SettlementType; Rec."Settlement Type")
                {
                    ApplicationArea = Basic;
                }
                field(SettlementComments; Rec."Settlement Comments")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Control1500001)
            {
                field(Description2; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the description for the post-dated check journal line.';
                }
                field(CustomerBalance; CustomerBalance)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Balance (LCY)';
                    Editable = false;
                }
                field(LineCount; LineCount)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Count';
                    Editable = false;
                }
                field(LineAmount; LineAmount)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Amount';
                    Editable = false;
                }
            }
        }
        area(factboxes)
        {
            part(Control1905532107; "Dimensions FactBox")
            {
                Editable = false;
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Line)
            {
                Caption = '&Line';
                Image = Line;
                action(Dimensions)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions;
                    end;
                }
            }
            group(Account)
            {
                Caption = '&Account';
                Image = ChartOfAccounts;
                action(Card)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Card';
                    Image = EditLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        case Rec."Account Type" of
                            Rec."account type"::"G/L Account":
                                begin
                                    GLAccount.Get(Rec."Account No.");
                                    Page.RunModal(Page::"G/L Account Card", GLAccount);
                                end;
                            Rec."account type"::Customer:
                                begin
                                    Customer.Get(Rec."Account No.");
                                    Page.RunModal(Page::"Customer Card", Customer);
                                end;
                        end;
                    end;
                }
            }
            group("Function")
            {
                Caption = 'F&unction';
                Image = "Action";
                Visible = false;
                action("Change PDC Collected")
                {
                    ApplicationArea = Basic, Suite;
                    Image = UpdateDescription;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        UpdateStatusCollected; //WIN325
                    end;
                }
                action(SuggestChecksToBank)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Suggest Checks to Bank';
                    Image = FilterLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = false;

                    trigger OnAction()
                    begin
                        CustomerNo := '';
                        DateFilter := '';
                        Rec.SetView('SORTING(Line Number) WHERE(Account Type=FILTER(Customer|G/L Account))');
                        BankDate := '..' + Format(WorkDate);
                        Rec.SetFilter("Date Filter", BankDate);
                        Rec.SetFilter("Check Date", Rec.GetFilter("Date Filter"));
                        CurrPage.Update(false);
                        CountCheck := Rec.Count;
                        Message(Text002, CountCheck);
                    end;
                }
                action(ShowAll)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Show &All';
                    Image = RemoveFilterLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = false;

                    trigger OnAction()
                    begin
                        CustomerNo := '';
                        DateFilter := '';
                        Rec.SetView('SORTING(Line Number) WHERE(Account Type=FILTER(Customer|G/L Account))');
                    end;
                }
                action(ApplyEntries)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Apply &Entries';
                    Image = ApplyEntries;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Shift+F11';
                    Visible = false;

                    trigger OnAction()
                    begin
                        PostDatedCheckMgt.ApplyEntries(Rec);
                    end;
                }
            }
        }
        area(processing)
        {
            group(Print)
            {
                Caption = '&Print';
                Image = Print;
                action(PrintReport)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Print Report';

                    trigger OnAction()
                    begin
                        Report.RunModal(Report::"Post Dated Checks", true, true, Rec);
                    end;
                }
                action(PrintAcknowledgementReceipt)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Print Acknowledgement Receipt';
                    Image = PrintAcknowledgement;

                    trigger OnAction()
                    begin
                        PostDatedCheck.CopyFilters(Rec);
                        PostDatedCheck.SetRange("Account Type", Rec."Account Type");
                        PostDatedCheck.SetRange("Account No.", Rec."Account No.");
                        if PostDatedCheck.FindFirst then;
                        Report.RunModal(Report::"PDC Acknowledgement Receipt", true, true, PostDatedCheck);
                    end;
                }
            }
            action(CashReceiptJournal)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cash Receipt Journal';
                Image = CashReceiptJournal;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Cash Receipt Journal";
            }
            action(CustomerCard)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Customer Card';
                Image = Customer;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Customer Card";
            }
        }
        area(reporting)
        {
            action(PostDatedChecks)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Post Dated Checks';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Post Dated Checks";
            }
            action(PDCAcknowledgementReceipt)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'PDC Acknowledgement Receipt';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "PDC Acknowledgement Receipt";
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateBalance;
    end;

    trigger OnOpenPage()
    begin
        //WIN325
        ContractFilter := '';
        StatusFilter := Statusfilter::All;
        ContractNoOnAfterValidate;
        StatusOnAfterValidate;
    end;

    var
        CustomerNo: Code[20];
        Customer: Record Customer;
        PostDatedCheck: Record "Post Dated Check Line";
        GLAccount: Record "G/L Account";
        CustomerList: Page "Customer List";
        PostDatedCheckMgt: Codeunit PostDatedCheckMgt;
        //ApplicationManagement: Codeunit ApplicationManagement;/WIN292
        CountCheck: Integer;
        LineCount: Integer;
        CustomerBalance: Decimal;
        LineAmount: Decimal;
        DateFilter: Text[250];
        BankDate: Text[30];
        Text001: label 'Are you sure you want to create Cash Journal Lines?';
        Text002: label 'There are %1 check(s) to bank.';
        ContractFilter: Code[20];
        StatusFilter: Option " ",Collected,Deposited,"Reversed/Cancelled",All;
        Text003: label 'Are you sure you want to create Cash Journal Lines & Post?';


    procedure UpdateBalance()
    begin
        LineAmount := 0;
        LineCount := 0;
        if Customer.Get(Rec."Account No.") then begin
            Customer.CalcFields("Balance (LCY)");
            CustomerBalance := Customer."Balance (LCY)";
        end else
            CustomerBalance := 0;
        PostDatedCheck.Reset;
        PostDatedCheck.SetCurrentkey("Account Type", "Account No.");
        if DateFilter <> '' then
            PostDatedCheck.SetFilter("Check Date", DateFilter);
        PostDatedCheck.SetRange("Account Type", PostDatedCheck."account type"::Customer);
        if CustomerNo <> '' then
            PostDatedCheck.SetRange("Account No.", CustomerNo);
        if PostDatedCheck.FindSet then begin
            repeat
                LineAmount := LineAmount + PostDatedCheck."Amount (LCY)";
            until PostDatedCheck.Next = 0;
            LineCount := PostDatedCheck.Count;
        end;
    end;


    procedure UpdateCustomer()
    begin
        if CustomerNo = '' then
            Rec.SetRange("Account No.")
        else
            Rec.SetRange("Account No.", CustomerNo);
        CurrPage.Update(false);
    end;

    local procedure DateFilterOnAfterValidate()
    begin
        //if ApplicationManagement.MakeDateFilter(DateFilter) = 0 then;//WIN292
        Rec.SetFilter("Check Date", DateFilter);
        UpdateCustomer;
        UpdateBalance;
    end;

    local procedure CustomerNoOnAfterValidate()
    begin
        Rec.SetFilter("Check Date", DateFilter);
        UpdateCustomer;
        UpdateBalance;
    end;

    local procedure ContractNoOnAfterValidate()
    begin
        //WIN325
        Rec.SetFilter("Check Date", DateFilter);
        if ContractFilter = '' then
            Rec.SetRange("Contract No.")
        else
            Rec.SetRange("Contract No.", ContractFilter);
        UpdateBalance;
        CurrPage.Update(false);
    end;

    local procedure StatusOnAfterValidate()
    begin
        //WIN325
        Rec.SetFilter("Check Date", DateFilter);
        if StatusFilter = Statusfilter::All then
            Rec.SetRange(Status)
        else
            Rec.SetRange(Status, StatusFilter);
        UpdateBalance;
        CurrPage.Update(false);
    end;

    local procedure UpdateStatusCollected()
    var
        PDC: Record "Post Dated Check Line";
        lText001: label 'Do you want to update the Status as Collected?';
    begin
        if not Confirm(lText001) then
            exit;
        CurrPage.SetSelectionFilter(Rec);
        PDC.Copy(Rec);
        PDC.SetRange(Status, PDC.Status::" ");
        if PDC.FindSet then
            PDC.ModifyAll(Status, PDC.Status::Received);
        Rec.Reset;
        Rec.SetFilter("Account Type", 'Customer|G/L Account');
    end;
}

