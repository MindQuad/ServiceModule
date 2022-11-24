page 50049 "Post Dated Checks Leasing"
{
    // WINPDC : Created new function for Revoke Cheque 'UpdateStatusRevoked' and added new button for the same.
    // WINPDC : Added code on actiosn button 'CreateCashJournal & Post' and 'CreateCashJournal' to check status Revoked.
    // WINPDC : Shown Cheque Dropped field | Created new function for Revoke Cheque 'UpdateChequeDropped' and added new button for the same.
    // WINPDC : Added code on On Assist Trigger on Document No. for No. Series.
    // WINPDC : Added Code on Action Button to change status and create and post journal for cash entries.

    AutoSplitKey = false;
    Caption = 'Post Dated Checks Register';
    CardPageID = "Post Dated Check Card";
    PageType = List;
    SaveValues = true;
    SourceTable = "Post Dated Check Line";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Line Number"; Rec."Line Number")
                {
                    ApplicationArea = All;
                }
                field("Contract No."; Rec."Contract No.")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        /*CALCFIELDS("Approval Status");
                        TESTFIELD("Approval Status","Approval Status"::Open);*/

                    end;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Select the type of account that the entry on the journal line will be posted to.';

                    trigger OnValidate()
                    begin
                        /*CALCFIELDS("Approval Status");
                        TESTFIELD("Approval Status","Approval Status"::Open);*/

                    end;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Select the number of the account that the entry on the journal line will be posted to.';

                    trigger OnValidate()
                    begin
                        /*CALCFIELDS("Approval Status");
                        TESTFIELD("Approval Status","Approval Status"::Open);*/

                    end;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the document no. for this post-dated check journal.';

                    trigger OnAssistEdit()
                    begin
                        //WINPDC++
                        IF rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                        //WINPDC--
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the description for the post-dated check journal line.';
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ApplicationArea = All;
                }
                field("Bank Account"; Rec."Bank Account")
                {
                    ApplicationArea = All;
                    Caption = 'Bal. Account No.';
                    ToolTip = 'Specifies the bank account No. where you want to bank the post-dated check.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        /*CALCFIELDS("Approval Status");
                        TESTFIELD("Approval Status","Approval Status"::Open);*/

                    end;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Payment Method"; Rec."Payment Method")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        /*CALCFIELDS("Approval Status");
                        TESTFIELD("Approval Status","Approval Status"::Open);*/

                    end;
                }
                field("Check No."; Rec."Check No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the check No. for the post-dated check.';

                    trigger OnValidate()
                    begin
                        /*CALCFIELDS("Approval Status");
                        TESTFIELD("Approval Status","Approval Status"::Open);*/

                    end;
                }
                field("Check Date"; Rec."Check Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date of the post-dated check when it is supposed to be banked.';

                    trigger OnValidate()
                    begin
                        /*CALCFIELDS("Approval Status");
                        TESTFIELD("Approval Status","Approval Status"::Open);*/

                    end;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the currency code of the post-dated check.';
                }
                field(Charges; rec.Charges)
                {
                    ApplicationArea = All;
                }
                field("Charge Code"; Rec."Charge Code")
                {
                    ApplicationArea = All;
                }
                field("Charge Description"; Rec."Charge Description")
                {
                    ApplicationArea = All;
                }
                field("Amount Paid"; Rec."Amount Paid")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Amount of the post-dated check.';

                    trigger OnValidate()
                    begin
                        /*CALCFIELDS("Approval Status");
                        TESTFIELD("Approval Status","Approval Status"::Open);*/

                    end;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies this is an auto-generated field which calculates the LCY amount.';
                    Visible = false;
                }
                field("Date Received"; Rec."Date Received")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date when we received the post-dated check.';
                }
                field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies this field is used if the journal line will be applied to an already-posted document.';
                    Visible = false;
                }
                field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies this field is used if the journal line will be applied to an already-posted document.';
                    Visible = false;
                }
                field("Applies-to ID"; Rec."Applies-to ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Apply Entry"; Rec."Apply Entry")
                {
                    ApplicationArea = All;
                }
                field("Applied Amount"; Rec."Applied Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Balancing Amount"; Rec."Remaining Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Balancing Amount';
                    Editable = false;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the comment for the transaction for your reference.';
                }
                field("Batch Name"; Rec."Batch Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a default batch.';
                }
                field("Building No."; Rec."Building No.")
                {
                    ApplicationArea = All;
                }
                field("Unit No."; Rec."Unit No.")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Reversal Reason Code"; Rec."Reversal Reason Code")
                {
                    ApplicationArea = All;
                }
                field("Reversal Reason Comments"; Rec."Reversal Reason Comments")
                {
                    ApplicationArea = All;
                }
                field("Reversal Date"; Rec."Reversal Date")
                {
                    ApplicationArea = All;
                }
                field("Settlement Type"; Rec."Settlement Type")
                {
                    ApplicationArea = All;
                }
                field("Settlement Comments"; Rec."Settlement Comments")
                {
                    ApplicationArea = All;
                }
                field("Updated with Legal Dept"; rec."Updated with Legal Dept")
                {
                    ApplicationArea = All;
                }
                field("PDC Due Date"; Rec."PDC Due Date")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("System Generated Date"; Rec."Contract Due Date")
                {
                    ApplicationArea = All;
                }
                field("System Generated Amount"; Rec."Contract Amount")
                {
                    ApplicationArea = All;
                }
                field("Cancelled Check"; Rec."Cancelled Check")
                {
                    ApplicationArea = All;
                }
                field("Police Case No."; Rec."Police Case No.")
                {
                    ApplicationArea = All;
                }
                field("Police Case"; Rec."Police Case")
                {
                    ApplicationArea = All;
                }
                field("Transaction No."; Rec."Transaction No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("G/L Transaction No."; Rec."G/L Transaction No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Check Bounce"; Rec."Check Bounce")
                {
                    ApplicationArea = All;
                }
                field("Replacement Check"; Rec."Replacement Check")
                {
                    ApplicationArea = All;
                }
                field("Payment Entry"; Rec."Payment Entry")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part("Dimensions FactBox"; 9083)
            {
                ApplicationArea = All;
                Editable = false;
                Visible = false;
            }
            systempart(RecordLinks; Links)
            {
                ApplicationArea = All;
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
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
                        rec.ShowDimensions;
                    end;
                }
            }
            group("&Account")
            {
                Caption = '&Account';
                Image = ChartOfAccounts;
                action(Card)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Card';
                    Image = EditLines;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        CASE rec."Account Type" OF
                            rec."Account Type"::"G/L Account":
                                BEGIN
                                    GLAccount.GET(rec."Account No.");
                                    PAGE.RUNMODAL(PAGE::"G/L Account Card", GLAccount);
                                END;
                            rec."Account Type"::Customer:
                                BEGIN
                                    Customer.GET(rec."Account No.");
                                    PAGE.RUNMODAL(PAGE::"Customer Card", Customer);
                                END;
                        END;
                    end;
                }
            }
            group("F&unction")
            {
                Caption = 'F&unction';
                Image = "Action";
                action("Drop Cheque")
                {
                    ApplicationArea = Basic, Suite;
                    Image = DisableBreakpoint;
                    Visible = false;

                    trigger OnAction()
                    begin
                        UpdateChequeDropped;   //WINPDC
                    end;
                }
                action("Revoke Cheque")
                {
                    ApplicationArea = Basic, Suite;
                    Image = CancelAllLines;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        UpdateStatusRevoked;   //WINPDC
                    end;
                }
                action("PDC Received")
                {
                    ApplicationArea = Basic, Suite;
                    Image = UpdateDescription;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        Rec.CALCFIELDS("G/L Transaction No.");
                        IF rec."G/L Transaction No." = 0 THEN
                            UpdateStatusCollected //WIN325
                        ELSE
                            ERROR('You cannot post this transaction as %1 PDC line already posted', Rec."Document No.");
                    end;
                }
                action("Notify to Legal Department")
                {
                    ApplicationArea = Basic, Suite;
                    Image = Email;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = true;

                    trigger OnAction()
                    begin
                        //IF WORKDATE > ("Check Date" + 30) THEN BEGIN

                        CurrPage.SETSELECTIONFILTER(Rec);
                        /* MailCU.SendMailtoNotifyLegalDepart(Rec); *///WIN292

                        if Confirm('Do you want to send an email?', true) then
                            SendMailtoNotify
                        else
                            exit;
                        Rec.RESET;
                        Rec.SETFILTER("Account Type", 'Customer|G/L Account');
                        Rec.SETFILTER(Status, '<>%1', Rec.Status::Deposited); //WIN325
                        //END;
                    end;
                }
                action(SuggestChecksToBank)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Suggest Checks to Bank';
                    Image = FilterLines;
                    Visible = false;

                    trigger OnAction()
                    begin
                        CustomerNo := '';
                        DateFilter := '';
                        Rec.SETVIEW('SORTING(Line Number) WHERE(Account Type=FILTER(Customer|G/L Account))');
                        BankDate := '..' + FORMAT(WORKDATE);
                        Rec.SETFILTER("Date Filter", BankDate);
                        Rec.SETFILTER("Check Date", Rec.GETFILTER("Date Filter"));
                        CurrPage.UPDATE(FALSE);
                        CountCheck := Rec.COUNT;
                        MESSAGE(Text002, CountCheck);
                    end;
                }
                action("Cheque Replacement")
                {
                    ApplicationArea = All;
                    Image = Reuse;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = true;

                    trigger OnAction()
                    var
                        PDCBuffer: Record 50017;
                        NewPDCGEnerated: Boolean;
                    begin
                        //win315++
                        /*IF "Replacement Check" = FALSE THEN BEGIN
                          Status := Status::Replaced;
                          MODIFY
                          END ELSE
                            ERROR('This check already replaced.');*/
                        //win315--
                        CurrPage.SAVERECORD;
                        IF Rec."Replacement Check" = FALSE THEN BEGIN
                            IF (Rec.Status = Rec.Status::Deposited) AND (Rec.Status <> Rec.Status::Reversed) AND (Rec.Status <> Rec.Status::Cancelled) THEN BEGIN
                                Rec.CALCFIELDS("Transaction No.");
                                Rec.TESTFIELD("Transaction No.");
                                // For Replacement Entry Creation
                                PDCBuffer.FILTERGROUP(2);
                                PDCBuffer.SETRANGE("PDC Document No", Rec."Document No.");
                                PDCBuffer.SETRANGE("Contract No.", Rec."Contract No.");
                                PDCBuffer.SETRANGE("Old Cheque Ref.", Rec."Check No.");
                                PDCBuffer.SETRANGE("Old Cheque Amount", Rec.Amount);
                                PDCBuffer.FILTERGROUP(0);
                                IF PAGE.RUNMODAL(0, PDCBuffer) = ACTION::LookupOK THEN BEGIN
                                    CLEAR(ReversalEntry);
                                    ReversalEntry.SetHideDialog(TRUE);
                                    ReversalEntry.SetHideWarningDialogs;
                                    ReversalEntry.ReverseTransaction(Rec."Transaction No.");
                                    PDCBuffer.CreateCheckReplEntry;
                                END;
                                // For Replacement Entry Creation
                                // PostPaymentEntry;
                            END ELSE
                                ERROR('Status should be deposited');
                        END ELSE
                            ERROR('This check already replaced.');
                        CurrPage.UPDATE(FALSE);

                    end;
                }
                action("Cancel Check")
                {
                    ApplicationArea = All;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = true;

                    trigger OnAction()
                    begin
                        //win315++
                        IF Rec."Cancelled Check" = FALSE THEN BEGIN
                            IF (Rec.Status = Rec.Status::Deposited) AND (Rec.Status <> Rec.Status::Reversed) AND (Rec.Status <> Rec.Status::Cancelled) THEN BEGIN
                                Rec.CALCFIELDS("Transaction No.");
                                Rec.TESTFIELD("Transaction No.");
                                ReversalEntry.ReverseTransaction(Rec."Transaction No.");
                                PostPaymentEntry;
                            END ELSE
                                ERROR('Status should be deposited');
                        END ELSE
                            ERROR('Check already cancelled');
                        //win315--
                    end;
                }
                action("Cancel Check Before Posting")
                {
                    ApplicationArea = All;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    var
                        PDC: Record "Post Dated Check Line";
                    begin
                        //win315++
                        /*IF "Check Cancelled Befoe Posting" = FALSE THEN BEGIN
                          {IF (Status = Status::Deposited) AND (Status <> Status::Reversed) AND (Status <> Status::Cancelled) THEN BEGIN
                            Rec.CALCFIELDS("Transaction No.");
                            TESTFIELD("Transaction No.");
                            ReversalEntry.ReverseTransaction("Transaction No.");
                          END ELSE
                            ERROR('Status should be deposited');}
                        END ELSE
                          ERROR('Check already cancelled');*/
                        //win315--

                        IF CONFIRM('Do you want to cancel check before posting?', TRUE) THEN BEGIN
                            Rec."Check Cancelled Befoe Posting" := TRUE;
                            Rec.MODIFY;
                            //WINPDC++
                            IF Rec.Status = Rec.Status::"Revoke Cheque" THEN
                                ERROR('Cannot Create Cash Journal & Post as cheque is revoked');
                            //WINPDC--
                            //TESTFIELD("Service Contract Type","Service Contract Type"::Internal); //WINS-394
                            IF CONFIRM(Text003, FALSE) THEN BEGIN
                                CurrPage.SETSELECTIONFILTER(Rec);
                                PDC.COPY(Rec);
                                PostDatedCheckMgt.PostJournal(Rec, TRUE);
                                /*CustomerNo := '';
                                DateFilter := '';
                                ContractFilter := '';
                                StatusFilter   := StatusFilter::All;  //win315
                                RESET;*/
                            END;

                            Rec.SETFILTER("Account Type", 'Customer|G/L Account');
                            Rec.SETFILTER(Status, '<>%1', Rec.Status::Deposited); //WIN325
                        END;

                    end;
                }
                action("Send for Police Case")
                {
                    ApplicationArea = All;
                    Image = ChangeStatus;
                    Visible = true;

                    trigger OnAction()
                    begin
                        //win315++

                        Rec.Status := Rec.Status::"Send for Police Case";
                        Rec.MODIFY;
                        //win315--
                    end;
                }
                action("Police Cases")
                {
                    ApplicationArea = All;
                    Image = SendConfirmation;
                    Visible = true;

                    trigger OnAction()
                    begin
                        //win315++
                        Rec.TESTFIELD("Police Case No.");
                        IF Rec."Police Case" = FALSE THEN BEGIN
                            Rec.Status := Rec.Status::"Police Case";
                            Rec."Police Case" := TRUE;
                            Rec.MODIFY;
                        END ELSE
                            ERROR('Already sent for Police case');
                        //win315--
                    end;
                }
                action("Closed Police Case")
                {
                    ApplicationArea = All;
                    Image = SelectField;
                    Visible = true;

                    trigger OnAction()
                    begin
                        //win315++
                        //TESTFIELD("Applies-to Doc. No.");
                        //TESTFIELD("Applies-to Doc. Type");
                        Rec.CALCFIELDS("Apply Entry");
                        Rec.TESTFIELD("Apply Entry");

                        IF Rec."Closed Police Case" = FALSE THEN BEGIN
                            IF CONFIRM('Do you want to close Police case?', TRUE) THEN BEGIN
                                SendMailtoSP1;
                                Rec.Status := Rec.Status::"Case Closed ";
                                Rec."Closed Police Case" := TRUE;
                                Rec.MODIFY;
                            END ELSE
                                EXIT;
                        END ELSE
                            ERROR('Police case already closed');
                        //win315--
                    end;
                }
                action("Court Case Details")
                {
                    ApplicationArea = All;
                    Image = Info;
                    Visible = true;

                    trigger OnAction()
                    begin
                        CourtCaseInsertion.GetPDC(Rec);
                        CourtCaseInsertion.SETFILTER(CourtCaseInsertion."PDC No.", Rec."Document No.");
                        IF CourtCaseInsertion.FINDLAST THEN BEGIN
                            CourtCaseDetails.SETTABLEVIEW(CourtCaseInsertion);
                            CourtCaseDetails.RUN;
                        END;
                    end;
                }
                action("Court Case Register")
                {
                    ApplicationArea = All;
                    Image = Register;
                    RunObject = Page "Court Case Entries";
                }
                action("Check Bounces")
                {
                    ApplicationArea = All;
                    Image = Check;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = true;

                    trigger OnAction()
                    begin
                        //win315++
                        /*
                        PostDatedCheck1.RESET;
                        PostDatedCheck1.SETRANGE(PostDatedCheck1."Document No.",Rec."Document No.");
                        IF PostDatedCheck1.FINDFIRST THEN BEGIN
                        IF PostDatedCheck1."Check Bounce" = FALSE THEN BEGIN
                          IF (PostDatedCheck1.Status = PostDatedCheck1.Status::Deposited) AND (PostDatedCheck1.Status <> PostDatedCheck1.Status::Reversed) AND (PostDatedCheck1.Status <> PostDatedCheck1.Status::Cancelled) THEN BEGIN
                            PostDatedCheck1.CALCFIELDS("Transaction No.");
                            PostDatedCheck1.TESTFIELD("Transaction No.");
                            ReversalEntry.ReverseTransaction(PostDatedCheck1."Transaction No.");
                            {
                            PostDatedCheck1."Check Bounce" := TRUE;
                            PostDatedCheck1.MODIFY;
                            CurrPage.UPDATE(FALSE);
                            }
                          END ELSE
                            ERROR('Status should be deposited');
                        END ELSE
                          ERROR('Check %1 has been reversed already.',PostDatedCheck1."Check No.");
                        END;
                        
                        */

                        IF Rec."Check Bounce" = FALSE THEN BEGIN
                            IF (Rec.Status = Rec.Status::Deposited) AND (Rec.Status <> Rec.Status::Reversed) AND (Rec.Status <> Rec.Status::Cancelled) THEN BEGIN
                                Rec.CALCFIELDS("Transaction No.");
                                Rec.TESTFIELD("Transaction No.");
                                ReversalEntry.ReverseTransaction(Rec."Transaction No.");
                                //IF "Check Bounce" = TRUE THEN
                                PostPaymentEntry;       //to post payment entry
                            END ELSE
                                ERROR('Status should be deposited');
                        END ELSE
                            ERROR('Check %1 has been reversed already.', Rec."Check No.");
                        //win315--

                        /*IF (( "Check Bounce" = TRUE) AND ("Payment Entry" = FALSE)) THEN
                          PostPaymentEntry;  //to post payment entry*/

                    end;
                }
                action("Show &All")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Show &All';
                    Image = RemoveFilterLines;

                    trigger OnAction()
                    begin
                        CustomerNo := '';
                        DateFilter := '';
                        Rec.SETVIEW('SORTING(Line Number) WHERE(Account Type=FILTER(Customer|G/L Account))');
                    end;
                }
                action("Apply &Entries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Apply &Entries';
                    Image = ApplyEntries;
                    ShortCutKey = 'Shift+F11';
                    Visible = false;

                    trigger OnAction()
                    begin
                        PostDatedCheckMgt.ApplyEntries(Rec);
                    end;
                }
                action("Under Collection")
                {
                    ApplicationArea = All;
                    Caption = 'Under Collection';
                    Image = InactivityDescription;

                    trigger OnAction()
                    begin
                        IF Rec.Status <> Rec.Status::"Under Collection" THEN BEGIN
                            Rec.Status := Rec.Status::"Under Collection";
                            //"Closed Police Case" := TRUE;
                            Rec.MODIFY;
                        END;
                        //END ELSE
                        //ERROR('Police case already closed');
                        //win315--
                    end;
                }
                action(Intercation)
                {
                    ApplicationArea = All;
                    Caption = 'Intercation';
                    Image = InactivityDescription;
                    RunObject = Page 50074;
                    Visible = false;
                }
                action("Intercation Entries")
                {
                    ApplicationArea = All;
                    Caption = 'Intercation Entries';
                    Image = InactivityDescription;

                    trigger OnAction()
                    begin
                        //win315++
                        IF CONFIRM('Do you want to create New Interaction?', TRUE) THEN BEGIN
                            Interaction.GetPDC(Rec);
                            Interaction.SETFILTER("PDC No.", Rec."Document No.");
                            IF Interaction.FIND THEN
                                CollectionEntries.SETTABLEVIEW(Interaction);
                            CollectionEntries.RUN;
                        END ELSE BEGIN
                            Interaction.SETFILTER("PDC No.", Rec."Document No.");
                            IF Interaction.FIND THEN
                                CollectionEntries.SETTABLEVIEW(Interaction);
                            CollectionEntries.RUN;
                        END;
                        //win315--
                    end;
                }
                action("Interaction Log Entries")
                {
                    ApplicationArea = All;
                    Caption = 'Interaction Log Entries';
                    Image = LedgerBook;
                    RunObject = Page "Collection Log Entries";
                    RunPageLink = "PDC No." = FIELD("Document No.");
                }
                action("Apply Entries")
                {
                    ApplicationArea = All;
                    Caption = 'Apply Entries';
                    Image = ApplyEntries;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        Custledger.AddDocNo(Rec."Document No.", Rec."Customer No.");
                        Custledger.RUN;
                    end;
                }
            }
        }
        area(processing)
        {
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action(CreateCashJournal)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Create Cash Journal';
                    Image = CheckJournal;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = false;

                    trigger OnAction()
                    var
                        PDC: Record "Post Dated Check Line";
                    begin
                        //WINPDC++
                        IF Rec.Status = Rec.Status::"Revoke Cheque" THEN
                            ERROR('Cannot Create Cash Journal as cheque is revoked');
                        //WINPDC--
                        //TESTFIELD("Service Contract Type","Service Contract Type"::Internal); //WINS-394
                        IF CONFIRM(Text001, FALSE) THEN BEGIN
                            //PostDatedCheckMgt.Post(Rec);
                            CurrPage.SETSELECTIONFILTER(Rec);
                            PDC.COPY(Rec);
                            PostDatedCheckMgt.PostJournal(Rec, FALSE);
                            /*CustomerNo := '';
                            DateFilter := '';
                            ContractFilter := '';
                            StatusFilter   := StatusFilter::All;  //win315
                            RESET;*/
                        END;
                        Rec.SETFILTER("Account Type", 'Customer|G/L Account');
                        Rec.SETFILTER(Status, '<>%1', Rec.Status::Deposited); //WIN325

                    end;
                }
                action("CreateCashJournal & Post")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Create Cash Journal && Post';
                    Image = CheckJournal;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        PDC: Record "Post Dated Check Line";
                    begin
                        //WINPDC++
                        /*IF (("Payment Method" = "Payment Method"::Cash) OR("Payment Method" = "Payment Method"::" ")) THEN BEGIN
                          Rec.CALCFIELDS("G/L Transaction No.");
                          TESTFIELD("G/L Transaction No.");
                        END ELSE BEGIN
                        Rec.CALCFIELDS("Transaction No.");
                            TESTFIELD("Transaction No.");
                        END;*/
                        //IF "Transaction No." <>

                        Rec.CALCFIELDS("G/L Transaction No.");
                        IF Rec."G/L Transaction No." = 0 THEN BEGIN
                            IF Rec.Status = Rec.Status::"Revoke Cheque" THEN
                                ERROR('Cannot Create Cash Journal & Post as cheque is revoked');
                            //WINPDC--
                            //TESTFIELD("Service Contract Type","Service Contract Type"::Internal); //WINS-394
                            IF CONFIRM(Text003, FALSE) THEN BEGIN
                                CurrPage.SETSELECTIONFILTER(Rec);
                                PDC.COPY(Rec);
                                PostDatedCheckMgt.PostJournal(Rec, TRUE);
                                /*CustomerNo := '';
                                DateFilter := '';
                                ContractFilter := '';
                                StatusFilter   := StatusFilter::All;  //win315
                                RESET;*/
                            END;

                            Rec.SETFILTER("Account Type", 'Customer|G/L Account');
                            Rec.SETFILTER(Status, '<>%1', Rec.Status::Deposited); //WIN325
                        END ELSE
                            ERROR('You cannot post this transaction as %1 PDC line already posted', Rec."Document No.");

                    end;
                }
                action("Bank Ledger Entries")
                {
                    ApplicationArea = All;
                    Image = BankAccountLedger;
                    RunObject = Page "Bank Account Ledger Entries";
                    RunPageLink = "Document No." = FIELD("Document No.");
                }
                action("General Ledger Entries")
                {
                    ApplicationArea = All;
                    Image = GeneralLedger;
                    RunObject = Page "General Ledger Entries";
                    RunPageLink = "Document No." = FIELD("Document No.");
                }
            }
            group("&Print")
            {
                Caption = '&Print';
                Image = Print;
                action("Print Report")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Print Report';
                    Visible = true;

                    trigger OnAction()
                    begin
                        REPORT.RUNMODAL(REPORT::"Post Dated Checks", TRUE, TRUE, Rec);
                    end;
                }
                action("Print Acknowledgement Receipt")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Print Acknowledgement Receipt';
                    Image = PrintAcknowledgement;
                    Visible = true;

                    trigger OnAction()
                    begin
                        PostDatedCheck.COPYFILTERS(Rec);
                        PostDatedCheck.SETRANGE("Account Type", Rec."Account Type");
                        PostDatedCheck.SETRANGE("Account No.", Rec."Account No.");
                        IF PostDatedCheck.FINDFIRST THEN;
                        REPORT.RUNMODAL(REPORT::"PDC Acknowledgement Receipt", TRUE, TRUE, PostDatedCheck);
                    end;
                }
            }
            action("Cash Receipt Journal")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cash Receipt Journal';
                Image = CashReceiptJournal;
                RunObject = Page "Cash Receipt Journal";
            }
            action("Customer Card")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Customer Card';
                Image = Customer;
                RunObject = Page "Customer Card";
                Visible = false;
            }
        }
        area(reporting)
        {
            action("Post Dated Checks")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Post Dated Checks';
                Image = "Report";
                RunObject = Report "Post Dated Checks";
            }
            action("PDC Acknowledgement Receipt")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'PDC Acknowledgement Receipt';
                Image = "Report";
                RunObject = Report "PDC Acknowledgement Receipt";
                Visible = true;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateBalance;
    end;

    var
        CustomerNo: Code[20];
        Customer: Record 18;
        PostDatedCheck: Record "Post Dated Check Line";
        GLAccount: Record 15;
        CustomerList: Page "Customer List";
        PostDatedCheckMgt: Codeunit PostDatedCheckMgt;
        //ApplicationManagement: Codeunit "1";//WIn292
        CountCheck: Integer;
        LineCount: Integer;
        CustomerBalance: Decimal;
        LineAmount: Decimal;
        DateFilter: Text[250];
        BankDate: Text[30];
        Text001: Label 'Are you sure you want to create Cash Journal Lines?';
        Text002: Label 'There are %1 check(s) to bank.';
        ContractFilter: Code[20];
        StatusFilter: Option " ",Received,Deposited,"Reversed/Cancelled",All;
        MailCU: Codeunit 17;
        Text003: Label 'Are you sure you want to create Cash Journal Lines & Post?';
        Text004: Label 'Do you want to send mail to Legal Department?';
        PaymentMethodFilter: Option " ",Cheque,Bank,Cash,All;
        GeneralLedgerSetup: Record 98;
        NoSeriesMgt: Codeunit 396;
        ReversalCode: Code[20];
        PageReason: Page 259;
        ReasonCode: Record 231;
        ReversalComments: Text[100];


        //Commentbox: DotNet Interaction;//WIN292
        ReversalEntry: Record 179;
        PostDatedCheck1: Record "Post Dated Check Line";
        Interaction: Record "Interaction";
        CollectionEntries: Page 50076;
        CourtCaseInsertion: Record 50014;
        CourtCaseDetails: Page 50080;
        Custledger: Page 50084;
        CLE: Record 21;


    procedure UpdateBalance()
    begin
        LineAmount := 0;
        LineCount := 0;
        IF Customer.GET(Rec."Account No.") THEN BEGIN
            Customer.CALCFIELDS("Balance (LCY)");
            CustomerBalance := Customer."Balance (LCY)";
        END ELSE
            CustomerBalance := 0;
        PostDatedCheck.RESET;
        PostDatedCheck.SETCURRENTKEY("Account Type", "Account No.");
        IF DateFilter <> '' THEN
            PostDatedCheck.SETFILTER("Check Date", DateFilter);
        PostDatedCheck.SETRANGE("Account Type", PostDatedCheck."Account Type"::Customer);
        IF CustomerNo <> '' THEN
            PostDatedCheck.SETRANGE("Account No.", CustomerNo);
        IF PostDatedCheck.FINDSET THEN BEGIN
            REPEAT
                LineAmount := LineAmount + PostDatedCheck."Amount (LCY)";
            UNTIL PostDatedCheck.NEXT = 0;
            LineCount := PostDatedCheck.COUNT;
        END;
    end;


    procedure UpdateCustomer()
    begin
        IF CustomerNo = '' THEN
            Rec.SETRANGE("Account No.")
        ELSE
            Rec.SETRANGE("Account No.", CustomerNo);
        CurrPage.UPDATE(FALSE);
    end;

    local procedure DateFilterOnAfterValidate()
    begin
        /* IF ApplicationManagement.MakeDateFilter(DateFilter) = 0 THEN; *///WIN292
        Rec.SETFILTER("Check Date", DateFilter);
        UpdateCustomer;
        UpdateBalance;
    end;

    local procedure CustomerNoOnAfterValidate()
    begin
        Rec.SETFILTER("Check Date", DateFilter);
        UpdateCustomer;
        UpdateBalance;
    end;

    local procedure ContractNoOnAfterValidate()
    begin
        //WIN325
        Rec.SETFILTER("Check Date", DateFilter);
        IF ContractFilter = '' THEN
            Rec.SETRANGE("Contract No.")
        ELSE
            Rec.SETRANGE("Contract No.", ContractFilter);
        UpdateBalance;
        CurrPage.UPDATE(FALSE);
    end;

    local procedure StatusOnAfterValidate()
    begin
        //WIN325
        Rec.SETFILTER("Check Date", DateFilter);
        IF StatusFilter = StatusFilter::All THEN
            Rec.SETRANGE(Status)
        ELSE
            Rec.SETRANGE(Status, StatusFilter);
        UpdateBalance;
        CurrPage.UPDATE(FALSE);
    end;

    local procedure UpdateStatusCollected()
    var
        PDC: Record "Post Dated Check Line";
        lText001: Label 'Do you want to update the Status as Collected?';
    begin
        //WIN325
        IF NOT CONFIRM(lText001) THEN
            EXIT;
        CurrPage.SETSELECTIONFILTER(Rec);
        PDC.COPY(Rec);
        PDC.SETRANGE(Status, PDC.Status::" ");
        IF PDC.FINDSET THEN
            PDC.MODIFYALL(Status, PDC.Status::Received);

        /*
        FILTERGROUP(0);
        RESET;
        SETFILTER("Account Type",'Customer|G/L Account');
        SETFILTER(Status,'<>%1',Status::Deposited);*/

    end;

    local procedure UpdateStatusRevoked()
    var
        lText001: Label 'Do you want to update the Status as Revoke Cheque?';
        PDC: Record "Post Dated Check Line";
    begin
        //WINPDC++
        IF NOT CONFIRM(lText001) THEN
            EXIT;
        CurrPage.SETSELECTIONFILTER(Rec);
        PDC.COPY(Rec);
        IF PDC.FINDSET THEN
            PDC.MODIFYALL(Status, PDC.Status::"Revoke Cheque");
        //WINPDC--
    end;

    local procedure UpdateChequeDropped()
    var
        lText001: Label 'Do you want to Drop Cheque for the selected entries?';
        PDC: Record "Post Dated Check Line";
    begin
        //WINPDC++
        IF NOT CONFIRM(lText001) THEN
            EXIT;
        CurrPage.SETSELECTIONFILTER(Rec);
        PDC.COPY(Rec);
        IF PDC.FINDSET THEN
            PDC.MODIFYALL("Cheque Dropped", TRUE);
        //WINPDC--
    end;

    local procedure PaymentMethodOnAfterValidate()
    begin
        //WINPDC++
        Rec.SETFILTER("Check Date", DateFilter);
        Rec.SETRANGE("Payment Method", PaymentMethodFilter);
        IF PaymentMethodFilter = PaymentMethodFilter::All THEN
            Rec.SETRANGE("Payment Method")
        ELSE
            Rec.SETRANGE("Payment Method", PaymentMethodFilter);
        UpdateBalance;
        CurrPage.UPDATE(FALSE);
        //WINPDC--
    end;


    procedure PostPaymentEntry()
    var
        PDCEntries: Record "Post Dated Check Line";
        GenJournalLine: Record "Gen. Journal Line";
        Num: Integer;
        JournalTemp: Record 80;
        GenJnlPostLine: Codeunit 12;
    begin
        GenJournalLine.RESET;
        GenJournalLine.SETFILTER("Journal Template Name", '%1', 'PAYMENT');
        GenJournalLine.SETFILTER("Journal Batch Name", '%1', 'PDC');
        IF GenJournalLine.FINDLAST THEN
            Num := GenJournalLine."Line No."
        ELSE
            Num := 0;

        //MESSAGE(FORMAT(Num));
        //PDCEntries.SETFILTER(Posted,'%1',FALSE);
        //PDCEntries.SETFILTER("PDC Bounced",'%1',FALSE);
        //PDCEntries.SETFILTER("On Hold",'%1',FALSE);
        //PDCEntries.SETFILTER("Sent for Posting",'%1',FALSE);
        PDCEntries.RESET;
        PDCEntries.SETRANGE(PDCEntries."Document No.", Rec."Document No.");
        PDCEntries.SETFILTER(PDCEntries."Payment Entry", '%1', FALSE);
        IF PDCEntries.FINDSET THEN
            REPEAT
                GenJournalLine.INIT;
                GenJournalLine.VALIDATE(GenJournalLine."Journal Template Name", 'PAYMENT');
                GenJournalLine.VALIDATE(GenJournalLine."Journal Batch Name", 'PDC');
                Num := Num + 10000;
                GenJournalLine."Line No." := Num;
                IF JournalTemp.GET(GenJournalLine."Journal Template Name") THEN
                    GenJournalLine.VALIDATE("Source Code", JournalTemp."Source Code");
                GenJournalLine.VALIDATE("Posting Date", PDCEntries."Check Date");
                GenJournalLine."Document No." := PDCEntries."Document No.";
                GenJournalLine.VALIDATE(GenJournalLine."Document Type", GenJournalLine."Document Type"::" ");
                GenJournalLine.VALIDATE(GenJournalLine."Account Type", PDCEntries."Account Type"::Customer);
                GenJournalLine.VALIDATE(GenJournalLine."Account No.", PDCEntries."Customer No.");
                GenJournalLine.VALIDATE(GenJournalLine.Amount, -(PDCEntries.Amount));
                //GenJournalLine."External Document No.":=PDCEntries."PDC No.";
                GenJournalLine.VALIDATE(GenJournalLine."Bal. Account Type", GenJournalLine."Bal. Account Type"::"G/L Account");
                GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.", PDCEntries."Account No.");
                GenJournalLine.VALIDATE(GenJournalLine."Check Date", PDCEntries."Check Date");
                GenJournalLine.VALIDATE(GenJournalLine."Check No", PDCEntries."Check No.");
                GenJournalLine.VALIDATE(GenJournalLine."Service Contract No.", PDCEntries."Contract No.");
                GenJournalLine.INSERT(TRUE);
                //PDCEntries."Sent for Posting":=TRUE;
                //PDCEntries."PDC Status":=PDCEntries."PDC Status"::Closed;
                PDCEntries."Payment Entry" := TRUE;
                PDCEntries.MODIFY;
                GenJnlPostLine.RunWithCheck(GenJournalLine);
            UNTIL PDCEntries.NEXT = 0;

        MESSAGE('Payment entry has been reversed');
    end;


    procedure SendMailtoSP1()
    var
        lCLE: Record 21;
        lCust: Record 18;
        lText001: Label 'Do you want to send mail to Salesperson ?';
        // SMTPMail: Codeunit 400;
        // SMTPSetup: Record 409;
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        Subject: Text;
        Body: Text;
        Recipients: List of [Text];

        lText002: Label 'Mail sent to Legal Department Successfully';
        lReasonCode: Record 231;
        UserSetup: Record 91;
        lUser: Record 2000000120;
        GeneralLedgerSetup: Record 98;
        SalespersonPurchaser: Record 13;
        MarketingSetup: Record 5079;
        FileName: Text;
        FileManagement: Codeunit 419;
        ImportTxt: Label 'Insert File';
        FileDialogTxt: Label 'Attachments (%1)|%1', Comment = '%1=file types, such as *.txt or *.docx';
        FilterTxt: Label '*.jpg;*.jpeg;*.bmp;*.png;*.gif;*.tiff;*.tif;*.pdf;*.docx;*.doc;*.xlsx;*.xls;*.pptx;*.ppt;*.msg;*.xml;*.*', Locked = true;
        Text1: Text[250];
    begin
        //win315++

        //SMTPSetup.GET;
        //TESTFIELD("E-Mail");
        //SMTPSetup.TESTFIELD("User ID");
        //SMTPSetup.TESTFIELD("Email Sender To");

        //MarketingSetup.GET;
        //MarketingSetup.TESTFIELD("Email Sender To");

        GeneralLedgerSetup.GET;
        GeneralLedgerSetup.TESTFIELD("Finance/Legal User Mail ID");
        Recipients.Add(GeneralLedgerSetup."Finance/Legal User Mail ID");

        //SMTPMail.CreateMessage('Admin',SMTPSetup."User ID",SMTPSetup."Email Sender To",'Contact No '+FORMAT("No.")+' is assigned','',TRUE);
        //SMTPMail.CreateMessage('Admin', SMTPSetup."User ID", GeneralLedgerSetup."Finance/Legal User Mail ID", 'Closing Police Case', '', TRUE);//WIN292
        //IF MarketingSetup."Email Sender CC" <> '' THEN
        //SMTPMail.AddCC(MarketingSetup."Email Sender CC");
        //SMTPMail.AppendBody('Hi '+SalespersonPurchaser.Name);
        //SMTPMail.AppendBody('Hi '+ Name);
        // SMTPMail.AppendBody('Dear Sir / Madam ');
        // SMTPMail.AppendBody('<br><br>');
        // SMTPMail.AppendBody('Good day!');
        // SMTPMail.AppendBody('<br><Br>');
        // //SMTPMail.AppendBody('Contact No '+FORMAT("No.")+' is assigned to you,please check and start interacting with them');
        // SMTPMail.AppendBody('Police case has been closed for this contract' + ' ' + FORMAT(Rec."Contract No.") + ' ' + 'and PDC No.' + ' ' + FORMAT(Rec."Document No.") + '.');
        // SMTPMail.AppendBody('<br><Br>');
        // SMTPMail.AppendBody('Thanks & Regards,');
        // SMTPMail.AppendBody('<br>');
        // SMTPMail.AppendBody('NAV Administrator');
        // SMTPMail.AppendBody('<br><br>');

        Subject := 'Closing Police Case';
        Body := 'Dear Sir / Madam, <br><br> Good day! <br><Br>';
        Body += 'Police case has been closed for this contract' + ' ' + FORMAT(Rec."Contract No.") + ' ' + 'and PDC No.' + ' ' + FORMAT(Rec."Document No.") + '.';
        Body += '<br><Br> Thanks & Regards, <br> NAV Administrator <br><br>';

        /*DocArticles1.RESET;
        DocArticles1.SETRANGE(DocArticles1."Issued To",Rec."No.");
        IF DocArticles1.FINDSET THEN REPEAT
          SMTPMail.AddAttachment(DocArticles1.Link,DocArticles1.Link);
        UNTIL DocArticles1.NEXT =0;*/
        //SMTPMail.Send;
        EmailMessage.Create(Recipients, Subject, Body, true);
        Email.Send(EmailMessage, Enum::"Email Scenario"::Default);

        MESSAGE('Email has been sent.');

        //win315--

    end;

    procedure SendMailtoNotify()
    var
        lCLE: Record 21;
        lCust: Record 18;
        lText001: Label 'Do you want to send mail to Salesperson ?';
        // SMTPMail: Codeunit 400;
        // SMTPSetup: Record 409;
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        Subject: Text;
        Body: Text;
        Recipients: List of [Text];

        lText002: Label 'Mail sent to Legal Department Successfully';
        lText003: Label 'Do you want to send mail to Legal department?';
        lReasonCode: Record 231;
        UserSetup: Record 91;
        lUser: Record 2000000120;
        GeneralLedgerSetup: Record 98;
        SalespersonPurchaser: Record 13;
        MarketingSetup: Record 5079;
        RecPDCLIne: Record "Post Dated Check Line";
        RecServconthd: Record "Service Contract Header";
        Recrecordlinks: Record "Record Link";
        FileName: Text;
        FileManagement: Codeunit 419;
        ImportTxt: Label 'Insert File';
        FileDialogTxt: Label 'Attachments (%1)|%1', Comment = '%1=file types, such as *.txt or *.docx';
        FilterTxt: Label '*.jpg;*.jpeg;*.bmp;*.png;*.gif;*.tiff;*.tif;*.pdf;*.docx;*.doc;*.xlsx;*.xls;*.pptx;*.ppt;*.msg;*.xml;*.*', Locked = true;
        Text1: Text[250];
        IStream: InStream;
        OStream: OutStream;
    begin
        //win586

        //SMTPSetup.GET;
        //TESTFIELD("E-Mail");
        //SMTPSetup.TESTFIELD("User ID");
        //SMTPSetup.TESTFIELD("Email Sender To");

        //MarketingSetup.GET;
        //MarketingSetup.TESTFIELD("Email Sender To");

        IF NOT CONFIRM(lText003) THEN
            EXIT;

        GeneralLedgerSetup.GET;
        GeneralLedgerSetup.TESTFIELD("Finance/Legal User Mail ID");
        Recipients.Add(GeneralLedgerSetup."Finance/Legal User Mail ID");

        UserSetup.get(UserId);
        UserSetup.TestField("E-Mail");


        lUser.Reset();
        lUser.SetRange("User Name", UserId);
        if lUser.FindSet() then;


        //SMTPMail.CreateMessage('Admin',SMTPSetup."User ID",SMTPSetup."Email Sender To",'Contact No '+FORMAT("No.")+' is assigned','',TRUE);
        //SMTPMail.CreateMessage('Admin', SMTPSetup."User ID", GeneralLedgerSetup."Finance/Legal User Mail ID", 'Closing Police Case', '', TRUE);//WIN292
        //IF MarketingSetup."Email Sender CC" <> '' THEN
        //SMTPMail.AddCC(MarketingSetup."Email Sender CC");
        //SMTPMail.AppendBody('Hi '+SalespersonPurchaser.Name);
        //SMTPMail.AppendBody('Hi '+ Name);
        // SMTPMail.AppendBody('Dear Sir / Madam ');
        // SMTPMail.AppendBody('<br><br>');
        // SMTPMail.AppendBody('Good day!');
        // SMTPMail.AppendBody('<br><Br>');
        // //SMTPMail.AppendBody('Contact No '+FORMAT("No.")+' is assigned to you,please check and start interacting with them');
        // SMTPMail.AppendBody('Police case has been closed for this contract' + ' ' + FORMAT(Rec."Contract No.") + ' ' + 'and PDC No.' + ' ' + FORMAT(Rec."Document No.") + '.');
        // SMTPMail.AppendBody('<br><Br>');
        // SMTPMail.AppendBody('Thanks & Regards,');
        // SMTPMail.AppendBody('<br>');
        // SMTPMail.AppendBody('NAV Administrator');
        // SMTPMail.AppendBody('<br><br>');
        /*Recipients.Add(UserSetup."E-Mail");
        Subject := 'Closing Police Case';
        Body := 'Dear Sir / Madam, <br><br> Good day! <br><Br>';
        Body += 'Police case has been closed for this contract' + ' ' + FORMAT(Rec."Contract No.") + ' ' + 'and PDC No.' + ' ' + FORMAT(Rec."Document No.") + '.';
        Body += '<br><Br> Thanks & Regards, <br> NAV Administrator <br><br>';*/


        Subject := 'PDC Details';
        Body := 'Dear Sir / Madam, <br><br> Good day! <br><Br>';

        RecPDCLIne.Copy(rec);
        RecPDCLIne.SetRange("Settlement Type", RecPDCLIne."Settlement Type"::"Notify Legal Department");
        if RecPDCLIne.FindSet() then begin
            repeat
                RecPDCLIne.TestField("Settlement Comments");
                Body += RecPDCLIne."Settlement Comments";
                Body += '<br><Br>';
                Body += 'Just to notify that we have already sent email for bounce check and we are informing to legal department. Following are the Details.';
                Body += '<Br>';
            until RecPDCLIne.Next() = 0;
        end;

        Body += 'Tenant name: ' + Format(RecPDCLIne."Customer Name") + ',' + 'Building No.: ' + Format(RecPDCLIne."Building No.") + ',' + 'Unit No.: ' + Format(RecPDCLIne."Unit No.")
               + ',' + 'Check No.: ' + Format(RecPDCLIne."Check No.") + ',' + 'Bank Name: ' + Format(RecPDCLIne."Bank Account") + ',' + 'Amount: ' + Format(abs(RecPDCLIne.Amount)) + '.';
        Body += '<br><Br>';
        Body += 'Thanks & Regards,';
        Body += '<br>';
        Body += lUser."Full Name";
        Body += '<br><br>';

        RecServconthd.Reset();
        RecServconthd.SetRange(RecServconthd."Contact No.", RecPDCLIne."Contract No.");
        if RecServconthd.findfirst then begin
            Recrecordlinks.SetRange(Recrecordlinks."Record ID", RecServconthd.RecordId);
            if Recrecordlinks.FindSet() then
                repeat
                    EmailMessage.AddAttachment(Recrecordlinks.URL1, Recrecordlinks.URL1, IStream);
                until Recrecordlinks.Next() = 0;
        end;

        RecPDCLIne.Status := RecPDCLIne.Status::"Escalated to Legal";
        RecPDCLIne.Modify();

        EmailMessage.Create(Recipients, Subject, Body, true);
        Email.Send(EmailMessage, Enum::"Email Scenario"::Default);




        /*DocArticles1.RESET;
        DocArticles1.SETRANGE(DocArticles1."Issued To",Rec."No.");
        IF DocArticles1.FINDSET THEN REPEAT
          SMTPMail.AddAttachment(DocArticles1.Link,DocArticles1.Link);
        UNTIL DocArticles1.NEXT =0;*/
        //SMTPMail.Send;
        //EmailMessage.Create(Recipients, Subject, Body, true);
        //Email.Send(EmailMessage, Enum::"Email Scenario"::Default);

        MESSAGE('Email has been sent.');

        //win586


    end;
}

