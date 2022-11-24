Codeunit 50000 "RDK Functions"
{
    // //WIN325300517 - Created


    trigger OnRun()
    begin
    end;

    var
        Comp2: Record Company;
        Text000: label 'The lines were successfully transferred to an invoice.';
        Text001: label 'The lines were not transferred to an invoice.';
        Text002: label 'There was no %1 with a %2 larger than 0. No lines were transferred.';
        Text003: label '%1 may not be lower than %2 and may not exceed %3.';
        Text004: label 'You must specify Invoice No. or New Invoice.';
        Text005: label 'You must specify Credit Memo No. or New Invoice.';
        Text007: label 'You must specify %1.';
        Text008: label 'The lines were successfully transferred to a credit memo.';
        Text009: label 'The selected planning lines must have the same %1.';
        Text010: label 'The currency dates on all planning lines will be updated based on the invoice posting date because there is a difference in currency exchange rates. Recalculations will be based on the Exch. Calculation setup for the Cost and Price values for the job. Do you want to continue?';
        Text011: label 'The currency exchange rate on all planning lines will be updated based on the exchange rate on the sales invoice. Do you want to continue?';
        Text012: label 'The %1 %2 does not exist anymore. A printed copy of the document was created before the document was deleted.', Comment = 'The Sales Invoice Header 103001 does not exist in the system anymore. A printed copy of the document was created before deletion.';
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        TempRec: Record "Aging Band Buffer" temporary;
        Text013: label 'You cannot delete.Purchase Invoice exists for this Planning Line No. %1';
        PurchInvHeader: Record "Purch. Inv. Header";
        Text014: label 'Do you want to change the status?';
        Cont: Record Contact;
        Text015: label 'Payment Lines Inserted for this Service Item %1';
        Text016: label 'Do you want to Import Milestones Lines?';
        Text017: label 'Sales Lines exists. Do you want to delete and recreate lines?';
        Text018: label 'Nothing to import';
        Text019: label 'You cannot change Payment Plan code. Sales lines already exists';
        Text020: label 'You cannot change Payment Plan code. Sales Invoice lines already exists';
        Text021: label 'If you change the Payment Plan Code,the existing lines will be deleted and recreated. Do you want to continue?';
        Text022: label '%1 = '' %2 ''  does not exist in the company = '' %3 ''';
        ContBusRel: Record "Contact Business Relation";
        Text023: label 'If you change the status to inactive,if customer exists for this contact will be blocked. Do you want to continue?';

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterInsertEvent', '', false, false)]
    local procedure CustCreationBlockedAll(var Rec: Record Customer; RunTrigger: Boolean)
    begin
        if Rec."Unit Code" = '' then begin
            Rec.Blocked := Rec.Blocked::All;
            Rec.Modify;
        end;
    end;

    [EventSubscriber(Objecttype::Page, 654, 'OnAfterActionEvent', 'Approve', false, false)]
    local procedure CustomerUnBlockedApproval(var Rec: Record "Approval Entry")
    var
        lAppEntry: Record "Approval Entry";
        lCust: Record Customer;
    begin
        //For approval done from Request to approve Page
        if Rec."Table ID" = 18 then begin
            lAppEntry.Reset;
            lAppEntry.SetRange("Table ID", Database::Customer);
            lAppEntry.SetFilter("Sequence No.", '>%1', Rec."Sequence No.");
            lAppEntry.SetRange("Record ID to Approve", Rec."Record ID to Approve");
            lAppEntry.SetRange(lAppEntry."Workflow Step Instance ID", Rec."Workflow Step Instance ID");
            lAppEntry.SetFilter(lAppEntry.Status, '%1|%2', lAppEntry.Status::Open, lAppEntry.Status::Created);
            if not lAppEntry.FindSet then begin
                if lCust.Get(Rec."Record ID to Approve") then begin
                    lCust.Blocked := lCust.Blocked::" ";
                    lCust.Modify;
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', false, false)]
    local procedure CustomerOnaapprovalfromRecord(var ApprovalEntry: Record "Approval Entry")
    var
        lappentry: Record "Approval Entry";
        lcust: Record Customer;
    begin
        //For approval done from Customer master if Sender and approver ID are same
        if ApprovalEntry."Table ID" = 18 then begin
            lappentry.Reset;
            lappentry.SetRange("Table ID", Database::Customer);
            lappentry.SetFilter("Sequence No.", '>%1', ApprovalEntry."Sequence No.");
            lappentry.SetRange("Record ID to Approve", ApprovalEntry."Record ID to Approve");
            lappentry.SetRange(lappentry."Workflow Step Instance ID", ApprovalEntry."Workflow Step Instance ID");
            lappentry.SetFilter(lappentry.Status, '%1|%2', lappentry.Status::Open, lappentry.Status::Created);
            if not lappentry.FindSet then begin
                if lcust.Get(ApprovalEntry."Record ID to Approve") then begin
                    lcust.Blocked := lcust.Blocked::" ";
                    lcust.Modify;
                end;
            end;
        end;
    end;

    [EventSubscriber(Objecttype::Page, 21, 'OnAfterActionEvent', 'Approve', false, false)]
    local procedure CustomerUnBlockedApproval2(var Rec: Record Customer)
    var
        lAppEntry: Record "Approval Entry";
        lCust: Record Customer;
        lAppEntry2: Record "Approval Entry";
    begin
        //For approval done from Request to approval
        lAppEntry.Reset;
        lAppEntry.SetRange("Table ID", Database::Customer);
        lAppEntry.SetRange("Record ID to Approve", Rec.RecordId);
        lAppEntry.SetRange("Approver ID", UserId);
        if lAppEntry.FindSet then begin
            lAppEntry2.Reset;
            lAppEntry2.SetRange("Table ID", Database::Customer);
            lAppEntry2.SetRange("Record ID to Approve", Rec.RecordId);
            lAppEntry2.SetFilter("Sequence No.", '>%1', lAppEntry."Sequence No.");
            if not lAppEntry2.FindSet then begin
                Rec.Blocked := Rec.Blocked::" ";
                Rec.Modify;
            end;
        end;
    end;

    [EventSubscriber(Objecttype::Page, 654, 'OnAfterActionEvent', 'Approve', false, false)]
    local procedure VendorUnBlockedApproval(var Rec: Record "Approval Entry")
    var
        lAppEntry: Record "Approval Entry";
        lVend: Record Vendor;
    begin

        if Rec."Table ID" = 23 then begin
            lAppEntry.Reset;
            lAppEntry.SetRange("Table ID", Database::Vendor);
            lAppEntry.SetFilter("Sequence No.", '>%1', Rec."Sequence No.");
            lAppEntry.SetRange("Record ID to Approve", Rec."Record ID to Approve");
            lAppEntry.SetRange(lAppEntry."Workflow Step Instance ID", Rec."Workflow Step Instance ID");
            lAppEntry.SetFilter(lAppEntry.Status, '%1|%2', lAppEntry.Status::Open, lAppEntry.Status::Created);
            if not lAppEntry.FindSet then begin
                if lVend.Get(Rec."Record ID to Approve") then begin
                    lVend.Blocked := lVend.Blocked::" ";
                    lVend.Modify;
                end;
            end;
        end;
    end;

    [EventSubscriber(Objecttype::Page, 26, 'OnAfterActionEvent', 'Approve', false, false)]
    local procedure VendorUnBlockedApproval2(var Rec: Record Vendor)
    var
        lAppEntry: Record "Approval Entry";
        lCust: Record Customer;
        lAppEntry2: Record "Approval Entry";
    begin
        lAppEntry.Reset;
        lAppEntry.SetRange("Table ID", Database::Vendor);
        lAppEntry.SetRange("Record ID to Approve", Rec.RecordId);
        lAppEntry.SetRange("Approver ID", UserId);
        if lAppEntry.FindSet then begin
            lAppEntry2.Reset;
            lAppEntry2.SetRange("Table ID", Database::Vendor);
            lAppEntry2.SetRange("Record ID to Approve", Rec.RecordId);
            lAppEntry2.SetFilter("Sequence No.", '>%1', lAppEntry."Sequence No.");
            if not lAppEntry2.FindSet then begin
                Rec.Blocked := Rec.Blocked::" ";
                Rec.Modify;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', false, false)]
    local procedure VendorOnaapprovalfromRecord(var ApprovalEntry: Record "Approval Entry")
    var
        lappentry: Record "Approval Entry";
        lcust: Record Customer;
        lVend: Record Vendor;
    begin
        //For approval done from Vendor master if Sender and approver ID are same
        if ApprovalEntry."Table ID" = 23 then begin
            lappentry.Reset;
            lappentry.SetRange("Table ID", Database::Vendor);
            lappentry.SetFilter("Sequence No.", '>%1', ApprovalEntry."Sequence No.");
            lappentry.SetRange("Record ID to Approve", ApprovalEntry."Record ID to Approve");
            lappentry.SetRange(lappentry."Workflow Step Instance ID", ApprovalEntry."Workflow Step Instance ID");
            lappentry.SetFilter(lappentry.Status, '%1|%2', lappentry.Status::Open, lappentry.Status::Created);
            if not lappentry.FindSet then begin
                if lVend.Get(ApprovalEntry."Record ID to Approve") then begin
                    lVend.Blocked := lVend.Blocked::" ";
                    lVend.Modify;
                end;
            end;
        end;
    end;


    procedure CopyCustomer(var RecCust: Record Customer)
    var
        CompList: Page "Companies Lookup";
        lText50000: label 'Do you want to copy the customer?';
        Comp: Record Company;
        CustNew: Record Customer;
        lText50001: label 'Customer(s) copied to %1 company successfully!!!';
        lCust: Record Customer;
        Inserted: Boolean;
        Txt: Text[100];
        lMarkSetup: Record "Marketing Setup";
        CompSalesReceivablesSetup: Record "Sales & Receivables Setup";
        CompNoSeriesLine: Record "No. Series Line";
    begin
        //Copying Customer Details from one company to Other companies

        if not Confirm(lText50000) then
            exit;

        if RecCust.FindSet then
            repeat
                RecCust.TestField(Blocked, RecCust.Blocked::" ");
            until RecCust.Next = 0;

        lMarkSetup.Get;
        Commit;
        Comp.Reset;
        Comp.SetFilter(Comp.Name, '<>%1', COMPANYNAME);
        CompList.SetTableview(Comp);
        CompList.LookupMode(true);
        if CompList.RunModal = Action::LookupOK then begin
            Txt := CompList.GetSelectionFilter;
            Comp2.Reset;
            Comp2.SetFilter(Name, Txt);
            if Comp2.FindSet then begin
                repeat
                    Clear(CustNew);
                    CustNew.ChangeCompany(Comp2.Name);
                    if RecCust.FindSet then begin
                        repeat
                            if RecCust."Unit Code" <> '' then
                                Error('This Customer is already copied from Company %1,so cannot be copied further.You need to go to company %1 and try copy company from there', RecCust."Unit Code");
                            RecCust.CheckDuplicateinothercompany;
                            CheckMastersExist(RecCust, Comp2);
                            CustNew.Reset;
                            CustNew.SetRange(CustNew."Emirates ID", RecCust."Emirates ID");
                            if CustNew.FindFirst then
                                Error('Customer No. %1 already exist in %2 with Emirates ID %3', CustNew."No.", Comp2.Name, CustNew."Emirates ID");
                            CustNew.Reset;
                            CustNew.SetRange(CustNew."Passport No.", RecCust."Passport No.");
                            if CustNew.FindFirst then
                                Error('Customer No. %1 already exist in %2 with Passport No. %3', CustNew."No.", Comp2.Name, CustNew."Passport No.");

                            CustNew.Reset;
                            CustNew.SetRange(CustNew."Trade License No.", RecCust."Trade License No.");
                            if CustNew.FindFirst then
                                Error('Customer No. %1 already exist in %2 with Trade License No. %3', CustNew."No.", Comp2.Name, CustNew."Trade License No.");

                            CustNew.Init;
                            CustNew.TransferFields(RecCust);
                            //to get customer no from another company
                            CompSalesReceivablesSetup.ChangeCompany(Comp2.Name);
                            CompSalesReceivablesSetup.Get;
                            if CompSalesReceivablesSetup."Customer Nos." = '' then
                                Error('Customer No. series not defined in %1', Comp2.Name);
                            CompNoSeriesLine.ChangeCompany(Comp2.Name);
                            CompNoSeriesLine.SetRange(CompNoSeriesLine."Series Code", CompSalesReceivablesSetup."Customer Nos.");
                            CompNoSeriesLine.SetFilter(CompNoSeriesLine."Starting Date", '<=%1', Today);
                            CompNoSeriesLine.FindLast;
                            if CompNoSeriesLine."Last No. Used" <> '' then
                                CustNew."No." := IncStr(CompNoSeriesLine."Last No. Used")
                            else
                                CustNew."No." := CompNoSeriesLine."Starting No.";
                            CompNoSeriesLine."Last No. Used" := CustNew."No.";
                            CompNoSeriesLine.Modify;


                            CustNew."Unit Code" := COMPANYNAME;
                            CustNew."Source Company Customer Code" := RecCust."No.";
                            if lMarkSetup."Copy Contacts to Company" then
                                CopyContacts(RecCust, Comp2)
                            else
                                CustNew."Primary Contact No." := '';
                            if CustNew.Insert then
                                Inserted := true;
                            CustNew.Blocked := CustNew.Blocked::" ";
                            CustNew.Modify;
                        until RecCust.Next = 0;
                    end;
                    if Inserted then
                        Message(lText50001, Comp2.Name);
                until Comp2.Next = 0;
            end;
            exit;
        end;
    end;

    local procedure CopyContacts(var pCust: Record Customer; pComp: Record Company)
    var
        lCont: Record Contact;
        lContBusRel: Record "Contact Business Relation";
        lMarkSetup: Record "Marketing Setup";
        lContNew: Record Contact;
        lContBusRel2: Record "Contact Business Relation";
    begin
        //Copy Contacts
        lMarkSetup.Get;
        if lMarkSetup."Copy Contacts to Company" then begin
            lContBusRel.Reset;
            lContBusRel.SetRange(lContBusRel."Link to Table", lContBusRel."link to table"::Customer);
            lContBusRel.SetRange(lContBusRel."No.", pCust."No.");
            if lContBusRel.FindSet then begin
                repeat
                    lContBusRel2.ChangeCompany(pComp.Name);
                    lContBusRel2.Init;
                    lContBusRel2.TransferFields(lContBusRel);
                    if lContBusRel2.Insert then;

                    lCont.Reset;
                    lCont.SetRange("Company No.", lContBusRel."Contact No.");
                    if lCont.FindSet then
                        repeat
                            lCont.TestField(Status, lCont.Status::"Request to Create Customer");
                            lContNew.ChangeCompany(pComp.Name);
                            lContNew.Init;
                            lContNew.TransferFields(lCont);
                            if lContNew.Insert then;
                        until lCont.Next = 0;

                until lContBusRel.Next = 0;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterInsertEvent', '', false, false)]
    local procedure VendorCreationBlockedAllStatus(var Rec: Record Vendor; RunTrigger: Boolean)
    begin
        //Creating new vendor with blocked status as All
        Rec.Blocked := Rec.Blocked::All;
        Rec.Modify;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Job Planning Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure InsertSubcontractinJBL(var Rec: Record "Job Planning Line"; RunTrigger: Boolean)
    var
        lJobTask: Record "Job Task";
    begin
        //Updating Subcontractor No and Deduction Plan code in Job Planning Lines from Job Task Line
        if lJobTask.Get(Rec."Job No.", Rec."Job Task No.") then begin
            Rec."SubContractor No." := lJobTask."SubContractor No.";
            Rec."Deduction Plan Code" := lJobTask."Deduction Plan Code";
            Rec.Modify;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Job Planning Line", 'OnAfterValidateEvent', 'Subcontractor Bill Value', false, false)]
    local procedure CalculateBaseValueJBL(var Rec: Record "Job Planning Line"; var xRec: Record "Job Planning Line"; CurrFieldNo: Integer)
    var
        lDedPlan: Record "Deduction Plan";
    begin
        //Calculating Line Amount and Unit Cost in Job Planning Lines based on the Deduction Plan
        Rec.TestField("SubContractor No.");
        Rec.TestField("Deduction Plan Code");

        Rec.SetFilter("Date Filter", '<%1', Rec."Planning Date");
        Rec.CalcFields("Previous Bill Values", "Previous Postive Values");

        lDedPlan.Reset;
        lDedPlan.SetRange(Code, Rec."Deduction Plan Code");
        if lDedPlan.FindSet then
            lDedPlan.CalcSums(Percentage);
        Rec."Line Amount" := (((Rec."Subcontractor Bill Value" + Rec."Previous Bill Values") / (1 - (lDedPlan.Percentage / 100)) - (Rec."Previous Postive Values")));
        Rec."Unit Cost" := (Rec."Line Amount" / Rec.Quantity);
        Rec.Validate(Rec."Unit Cost");
        Rec.Modify;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Job Planning Line", 'OnAfterDeleteEvent', '', false, false)]
    local procedure DeleteJBLValidation(var Rec: Record "Job Planning Line"; RunTrigger: Boolean)
    begin
        //Validating deletion of Job Planning Lines if Invoices Exists

        Rec.CalcFields("Purchase Invoice No.", "Posted Pur. Inv. No.");
        if (Rec."Purchase Invoice No." <> '') or (Rec."Posted Pur. Inv. No." <> '') then
            Error(Text013, Rec."Line No.");
    end;

    [EventSubscriber(Objecttype::Page, 1007, 'OnAfterActionEvent', 'Jobs - Transaction Detail', false, false)]
    local procedure ShowSubcontractInvoices(var Rec: Record "Job Planning Line")
    begin

        Rec.CalcFields("Purchase Invoice No.", "Posted Pur. Inv. No.");
        if (Rec."Purchase Invoice No." <> '') then begin
            PurchHeader.Reset;
            PurchHeader.SetRange("Document Type", PurchHeader."document type"::Invoice);
            PurchHeader.SetRange("No.", Rec."Purchase Invoice No.");
            Page.Run(51, PurchHeader);
        end else
            if (Rec."Posted Pur. Inv. No." <> '') then begin
                PurchInvHeader.Reset;
                PurchInvHeader.SetRange("No.", Rec."Posted Pur. Inv. No.");
                Page.Run(138, PurchInvHeader);
            end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Contact, 'OnAfterInsertEvent', '', false, false)]
    local procedure ContactSalespersonUpdate(var Rec: Record Contact; RunTrigger: Boolean)
    var
        lUsersetup: Record "User Setup";
    begin
        if Rec.Type = Rec.Type::Person then
            exit;
        lUsersetup.Get(UserId);
        Rec."Salesperson Code" := lUsersetup."Salespers./Purch. Code";
        Rec.Modify;
    end;

    [EventSubscriber(Objecttype::Page, 5050, 'OnAfterActionEvent', 'ContactCoverSheet', false, false)]

    procedure ContactStatusActive(var Rec: Record Contact)
    begin
        Rec.TestField(Type, Rec.Type::Company);

        if (Rec."Emirates ID" = '') and (Rec."Emirates ID" = '') and (Rec."Trade License No." = '') then
            Error('No Identification is provided for this contact');
        if not Confirm(Text014) then
            exit;

        /*
        IF Rec."Unit No." = Rec."Unit No."::"1" THEN
          EXIT;
        */
        Rec.SendMailtoSP;
        //Rec."Unit No." := Rec."Unit No."::"1";
        Rec.Modify;

        Cont.Reset;
        Cont.SetRange(Type, Cont.Type::Person);
        Cont.SetRange("Company No.", Rec."No.");
        /*
        IF Cont.FINDSET THEN
          Cont.MODIFYALL("Unit No.",Cont."Unit No."::"1");
          */

    end;

    [EventSubscriber(Objecttype::Page, 5050, 'OnAfterActionEvent', 'ContactCoverSheet', false, false)]

    procedure ContactStatusInActive(var Rec: Record Contact)
    var
        lCust: Record Customer;
    begin
        Rec.TestField(Type, Rec.Type::Company);

        if not Confirm(Text014) then
            exit;

        ContBusRel.Reset;
        ContBusRel.SetRange("Link to Table", ContBusRel."link to table"::Customer);
        ContBusRel.SetRange("Contact No.", Rec."Company No.");
        if ContBusRel.FindSet then
            if not Confirm(Text023) then
                exit;
        /*
        IF Rec."Unit No." = Rec."Unit No."::"0" THEN
          EXIT;
        
        Rec.TESTFIELD("Rent Amount");
        Rec."Unit No." := Rec."Unit No."::"0";
        Rec.MODIFY;
        
        Cont.RESET;
        Cont.SETRANGE(Type,Cont.Type::Person);
        Cont.SETRANGE("Company No.",Rec."No.");
        IF Cont.FINDSET THEN
          Cont.MODIFYALL("Unit No.",Cont."Unit No."::"0");
        */
        ContBusRel.Reset;
        ContBusRel.SetRange("Link to Table", ContBusRel."link to table"::Customer);
        ContBusRel.SetRange("Contact No.", Rec."Company No.");
        if ContBusRel.FindSet then begin
            if lCust.Get(ContBusRel."No.") then begin
                lCust.Blocked := lCust.Blocked::All;
                lCust.Modify;
            end;
        end;

    end;

    [EventSubscriber(ObjectType::Table, Database::Contact, 'OnAfterValidateEvent', 'Company No.', false, false)]
    local procedure ContactPersonStatus(var Rec: Record Contact; var xRec: Record Contact; CurrFieldNo: Integer)
    begin
        if Rec.Type = Rec.Type::Company then
            exit;

        if (Rec.Type = Rec.Type::Person) and (Rec."Company No." <> '') then begin
            Cont.Reset;
            Cont.SetRange(Type, Cont.Type::Company);
            Cont.SetRange("No.", Rec."Company No.");
            if Cont.FindSet then begin
                /*
                Rec."Unit No." := Cont."Unit No.";
                Rec."Rent Amount" := Cont."Rent Amount";
                Rec."No. of Bathroom"      := Cont."No. of Bathroom";
                Rec."Emirates ID"         := Cont."Emirates ID";
                Rec."Emirates ID":=Cont."Emirates ID";
                Rec."Trade License No.":=Cont."Trade License No.";
                Rec.MODIFY;
                */
            end;
        end;

    end;

    [EventSubscriber(ObjectType::Table, Database::"Service Item", 'OnAfterValidateEvent', 'Payment Plan Code', false, false)]

    procedure GetServiceItemPaymentLines(var Rec: Record "Service Item"; var xRec: Record "Service Item"; CurrFieldNo: Integer)
    var
        lPayPlan: Record "Payment Plan";
        lPayPlan2: Record "Payment Plan";
        lSLine: Record "Sales Line";
        lSInvLine: Record "Sales Invoice Line";
        lPayPlan3: Record "Payment Plan";
        Inserted: Boolean;
    begin
        Rec.TestField(Rec."Unit Purpose", Rec."unit purpose"::"Saleable Unit");

        if Rec."Payment Plan Code" <> xRec."Payment Plan Code" then begin
            if xRec."Payment Plan Code" <> '' then begin
                lSLine.Reset;
                lSLine.SetRange("Document Type", lSLine."document type"::Order);
                //lSLine.SETRANGE("Payment Plan Code",xRec."Payment Plan Code");
                //lSLine.SETRANGE("Service Item No.",Rec."No.");
                if lSLine.FindSet then
                    Error(Text019);

                lSInvLine.Reset;
                //lSInvLine.SETRANGE("Payment Plan Code",xRec."Payment Plan Code");
                //lSInvLine.SETRANGE("Service Item No.",Rec."No.");
                if lSInvLine.FindSet then
                    Error(Text020);

                lPayPlan3.Reset;
                lPayPlan3.SetRange("Service Item No.", Rec."No.");
                lPayPlan3.SetRange("Payment Plan Code", xRec."Payment Plan Code");
                if lPayPlan3.FindSet then
                    if not Confirm(Text021) then begin
                        Rec."Payment Plan Code" := xRec."Payment Plan Code";
                        Rec.Modify;
                        exit;
                    end else
                        lPayPlan3.DeleteAll;

            end;
        end;
        Clear(Inserted);
        lPayPlan.Reset;
        lPayPlan.SetRange("Service Item No.", '');
        lPayPlan.SetRange("Payment Plan Code", Rec."Payment Plan Code");
        if lPayPlan.FindSet then begin
            repeat
                if not lPayPlan2.Get(lPayPlan."Payment Plan Code", lPayPlan."Milestone Code", Rec."No.") then begin
                    lPayPlan2.Init;
                    lPayPlan2.TransferFields(lPayPlan);
                    lPayPlan2."Service Item No." := Rec."No.";
                    if lPayPlan2.Insert then
                        Inserted := true;
                end;
            until lPayPlan.Next = 0;
        end else
            Error(Text018);
        if Inserted then
            Message(Text015, Rec."No.");
    end;

    /*  [EventSubscriber(Objecttype::Page, 42, 'OnAfterActionEvent', 'Get Milestone Payment Lines', false, false)]
     local procedure GetPaymentLinesSalesOrder(var Rec: Record "Sales Header")
     var
         lSLine: Record "Sales Line";
         LNo: Integer;
         lPayPlan: Record "Payment Plan";
         lServiceItem: Record "Service Item";
     begin
         //Rec.TESTFIELD(Rec."Service Item No.");
         if not Confirm(Text016) then
             exit;

         //lServiceItem.GET(Rec."Service Item No.");
         lServiceItem.TestField("Sales Unit Price");

         lSLine.Reset;
         lSLine.SetRange("Document Type", Rec."Document Type");
         lSLine.SetRange("Document No.", Rec."No.");
         if lSLine.FindSet then
             if Confirm(Text017) then
                 lSLine.DeleteAll(true)
             else
                 exit;

         LNo := 10000;

         lPayPlan.Reset;
         //lPayPlan.SETRANGE("Service Item No.",Rec."Service Item No.");
         lPayPlan.SetRange("Payment Plan Code", lServiceItem."Payment Plan Code");
         if lPayPlan.FindSet then begin
             repeat
                 if lPayPlan."Milestone %" = 0 then
                     lPayPlan.TestField("Milestone Amount")
                 else
                     lPayPlan.TestField("Milestone %");
                 lPayPlan.TestField("Revenue Interim Account");
                 lPayPlan.TestField("Invoice Due date Calculation");

                 lSLine.Init;
                 lSLine."Document Type" := Rec."Document Type";
                 lSLine."Document No." := Rec."No.";
                 lSLine."Line No." := LNo;
                 lSLine.Insert(true);
                 lSLine.Validate(Type, lSLine.Type::"G/L Account");
                 lSLine.Validate("No.", lPayPlan."Revenue Interim Account");
                 lSLine.Description := lPayPlan."Milestone Description";
                 lSLine.Validate(Quantity, 1);
                 if lPayPlan."Milestone Amount" <> 0 then
                     lSLine.Validate("Unit Price", lPayPlan."Milestone Amount")
                 else
                     lSLine.Validate("Unit Price", (lServiceItem."Sales Unit Price" * (lPayPlan."Milestone %" / 100)));
                 //lSLine."Payment Plan Code"            := lPayPlan."Payment Plan Code";
                 //lSLine."Milestone Code"               := lPayPlan."Milestone Code";
                 //lSLine."Job Code"                     := lServiceItem."Job Code";
                 //lSLine."Milestone %"                  := lPayPlan."Milestone %";
                 if (lPayPlan."Milestone %" <> 0) then
                     //lSLine."Milestone Amount"           := (lServiceItem."Sales Unit Price" * (lPayPlan."Milestone %"/ 100))
                     //ELSE
                     //lSLine."Milestone Amount"           := lPayPlan."Milestone Amount";
                     //lSLine."Invoice Due date Calculation" := lPayPlan."Invoice Due date Calculation";
                     //lSLine."Invoice Due Date"             := CALCDATE(lPayPlan."Invoice Due date Calculation",Rec."Order Date");
                     //lSLine."Service Item No."             := Rec."Service Item No.";
                     //lSLine."Variance Amount"              := lSLine."Line Amount" - lSLine."Milestone Amount";
                     lSLine.Modify(true);
                 LNo += 10000;
             until lPayPlan.Next = 0;
         end else
             Error(Text018);
     end; */ //WIN292//Action not available

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Order Date', false, false)]
    local procedure CalculateInvDueDate(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        lSLine: Record "Sales Line";
    begin
        if (Rec."Document Type" = Rec."document type"::Order) and (Rec."Order Date" <> xRec."Order Date") /*AND (Rec."Service Item No." <> '')*/ then begin
            lSLine.Reset;
            lSLine.SetRange("Document Type", Rec."Document Type");
            lSLine.SetRange("Document No.", Rec."No.");
            if lSLine.FindSet then
                repeat
                    lSLine.TestField("Qty. Shipped (Base)", 0);
                    //lSLine."Invoice Due Date" := CALCDATE(lSLine."Invoice Due date Calculation",Rec."Order Date");
                    lSLine.Modify;
                until lSLine.Next = 0;
        end;

    end;

    local procedure CheckMastersExist(var pCust: Record Customer; pComp: Record Company)
    var
        lGenBusPostGrp: Record "Gen. Business Posting Group";
        lCustPostGrp: Record "Customer Posting Group";
        lCustPriceGrp: Record "Customer Price Group";
        lVatBusPostGrp: Record "VAT Business Posting Group";
        lPayTerms: Record "Payment Terms";
        lPayMethod: Record "Payment Method";
        lCont: Record Contact;
        lContBusRel: Record "Contact Business Relation";
        lMarkSetup: Record "Marketing Setup";
        lContNew: Record Contact;
        lContBusRel2: Record "Contact Business Relation";
    begin
        exit;
        //Gen Bus Posting Group Table
        if (pCust."Gen. Bus. Posting Group" <> '') then begin
            lGenBusPostGrp.ChangeCompany(pComp.Name);
            if not lGenBusPostGrp.Get(pCust."Gen. Bus. Posting Group") then
                Error(Text022, pCust.FieldName("Gen. Bus. Posting Group"), pCust."Gen. Bus. Posting Group", pComp.Name);
        end;

        //Customer Posting Group Table
        if (pCust."Customer Posting Group" <> '') then begin
            lCustPostGrp.ChangeCompany(pComp.Name);
            if not lCustPostGrp.Get(pCust."Customer Posting Group") then
                Error(Text022, pCust.FieldName("Customer Posting Group"), pCust."Customer Posting Group", pComp.Name);
        end;

        //Customer Price Group Table
        if (pCust."Customer Price Group" <> '') then begin
            lCustPriceGrp.ChangeCompany(pComp.Name);
            if not lCustPriceGrp.Get(pCust."Customer Price Group") then
                Error(Text022, pCust.FieldName("Customer Price Group"), pCust."Customer Price Group", pComp.Name);
        end;

        //VAT Bus Posting Group Table
        if (pCust."VAT Bus. Posting Group" <> '') then begin
            lVatBusPostGrp.ChangeCompany(pComp.Name);
            if not lVatBusPostGrp.Get(pCust."VAT Bus. Posting Group") then
                Error(Text022, pCust.FieldName("VAT Bus. Posting Group"), pCust."VAT Bus. Posting Group", pComp.Name);
        end;

        //Payment Terms Table
        if (pCust."Payment Terms Code" <> '') then begin
            lPayTerms.ChangeCompany(pComp.Name);
            if not lPayTerms.Get(pCust."Payment Terms Code") then
                Error(Text022, pCust.FieldName("Payment Terms Code"), pCust."Payment Terms Code", pComp.Name);
        end;

        //Payment Method Table
        if (pCust."Payment Method Code" <> '') then begin
            lPayMethod.ChangeCompany(pComp.Name);
            if not lPayMethod.Get(pCust."Payment Method Code") then
                Error(Text022, pCust.FieldName("Payment Method Code"), pCust."Payment Method Code", pComp.Name);
        end;
    end;

    /* [EventSubscriber(Objecttype::Page, 50006, 'OnAfterActionEvent', 'Activate', false, false)]

    procedure BrokerStatusActive(var Rec: Record Contact)
    begin
        Rec.TestField(Type, Rec.Type::Company);
        //Rec.TESTFIELD("Building Name",TRUE);
        if not Confirm(Text014) then
            exit;

        //IF Rec."Unit No." = Rec."Unit No."::"1" THEN
        //EXIT;

        //Rec."Unit No." := Rec."Unit No."::"1";
        //Rec.MODIFY;

        Cont.Reset;
        Cont.SetRange(Type, Cont.Type::Person);
        Cont.SetRange("Company No.", Rec."No.");
        if Cont.FindSet then
            ; *///WIN292//Action not available

    /* [EventSubscriber(Objecttype::Page, 50006, 'OnAfterActionEvent', 'Deactivate', false, false)]

    procedure BrokerStatusInActive(var Rec: Record Contact)
    var
        lCust: Record Customer;
    begin
        Rec.TestField(Type, Rec.Type::Company);
        //Rec.TESTFIELD("Building Name",TRUE);
        if not Confirm(Text014) then
            exit;

        ContBusRel.Reset;
        ContBusRel.SetRange("Link to Table", ContBusRel."link to table"::Customer);
        ContBusRel.SetRange("Contact No.", Rec."Company No.");
        if ContBusRel.FindSet then
            if not Confirm(Text023) then
                exit;

        //IF Rec."Unit No." = Rec."Unit No."::"0" THEN
        //EXIT;

        //Rec.TESTFIELD("Rent Amount");
        //Rec."Unit No." := Rec."Unit No."::"0";
        //Rec.MODIFY;

        Cont.Reset;
        Cont.SetRange(Type, Cont.Type::Person);
        Cont.SetRange("Company No.", Rec."No.");
        if Cont.FindSet then
            //Cont.MODIFYALL("Unit No.",Cont."Unit No."::"0");

            ContBusRel.Reset;
        ContBusRel.SetRange("Link to Table", ContBusRel."link to table"::Customer);
        ContBusRel.SetRange("Contact No.", Rec."Company No.");
        if ContBusRel.FindSet then begin
            if lCust.Get(ContBusRel."No.") then begin
                lCust.Blocked := lCust.Blocked::All;
                lCust.Modify;
            end;
        end;
    end; *///WIN292//Action not available


    procedure SendMailtoCustomer(var DocNo: Code[20]; ReasonCode: Code[20]; ReversalComments: Text[100])
    var
        lCLE: Record "Cust. Ledger Entry";
        lCust: Record Customer;
        lText001: label 'Email Id is blank for the Customer %1';
        // SMTPMail: Codeunit "SMTP Mail";
        // SMTPSetup: Record "SMTP Mail Setup";
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        Subject: Text;
        Body: Text;
        lText002: label 'Mail sent to Customer %1 Successfully';
        lReasonCode: Record "Reason Code";
        lUserSetup: Record "User Setup";
        lUser: Record User;
        //EMail: List of [Text];
        Recipients: List of [Text];
    begin
        if lReasonCode.Get(ReasonCode) then
            if not lReasonCode."Mail to Customer" then
                exit;
        lUserSetup.Get(UserId);
        lUserSetup.TestField("E-Mail");

        lUser.Reset;
        lUser.SetRange("User Name", UserId);
        if lUser.FindSet then;

        lCLE.Reset;
        lCLE.SetRange("Document No.", DocNo);
        if not lCLE.FindSet then
            exit;

        if lCust.Get(lCLE."Customer No.") then begin
            if lCust."E-Mail" = '' then
                Error(lText001, lCust."No.");


            Recipients.Add(lCust."E-Mail");
            // SMTPMail.CreateMessage(lUser."Full Name", lUserSetup."E-Mail", EMail, 'Reversal Entry ' + DocNo, '', true);
            // SMTPMail.AppendBody('Hi ' + Format(lCust.Name) + ',');
            // SMTPMail.AppendBody('<br><br>');
            // SMTPMail.AppendBody('Good day!');
            // SMTPMail.AppendBody('<br><Br>');
            // SMTPMail.AppendBody(ReversalComments);
            // SMTPMail.AppendBody('<br><Br>');
            // SMTPMail.AppendBody('Thanks & Regards,');
            // SMTPMail.AppendBody('<br>');
            // SMTPMail.AppendBody(lUser."Full Name");
            // SMTPMail.AppendBody('<br><br>');
            // SMTPMail.Send;

            Subject := 'Reversal Entry ' + DocNo;
            Body := 'Hi ' + Format(lCust.Name) + ', <br><br> Good day! <br><Br>';
            Body += ReversalComments + '<br><Br> Thanks & Regards, <br>' + lUser."Full Name" + '<br><br>';
            EmailMessage.Create(Recipients, Subject, Body, true);
            Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
            Message(lText002, lCust."No.");
        end;
    end;


    procedure SendMailtoNotifyLegalDepart(var pPDCLine: Record "Post Dated Check Line")
    var
        lCLE: Record "Cust. Ledger Entry";
        lCust: Record Customer;
        lText001: label 'Email Id is blank %1';
        // SMTPMail: Codeunit "SMTP Mail";
        // SMTPSetup: Record "SMTP Mail Setup";
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        Subject: Text;
        Body: Text;
        lText002: label 'Mail sent successfully';
        lReasonCode: Record "Reason Code";
        lUserSetup: Record "User Setup";
        lUser: Record User;
        lPDCLine: Record "Post Dated Check Line";
        lGlSetup: Record "General Ledger Setup";
        lText003: label 'Do you want to send mail to Legal department?';
        //EMail: List of [Text];
        Recipients: List of [Text];
    begin
        if not Confirm(lText003) then
            exit;

        lGlSetup.Get;
        lGlSetup.TestField("Legal Department Mail ID");

        lUserSetup.Get(UserId);
        lUserSetup.TestField("E-Mail");

        lUser.Reset;
        lUser.SetRange("User Name", UserId);
        if lUser.FindSet then;

        // EMail.Add(lGlSetup."Legal Department Mail ID");

        // SMTPMail.CreateMessage(lUser."Full Name", lUserSetup."E-Mail", EMail, 'PDC Details', '', true);
        // SMTPMail.AppendBody('Hi ' + ',');
        // SMTPMail.AppendBody('<br><br>');
        // SMTPMail.AppendBody('Good day!');
        // SMTPMail.AppendBody('<br><Br>');
        Recipients.Add(lGlSetup."Legal Department Mail ID");
        Subject := 'PDC Details';
        Body := 'Hi, <br><br> Good day! <br><Br>';

        lPDCLine.Copy(pPDCLine);
        lPDCLine.SetFilter(Status, '%1|%2', lPDCLine.Status::Received, lPDCLine.Status::Reversed);
        lPDCLine.SetRange("Settlement Type", lPDCLine."settlement type"::"Notify Legal Department");
        if lPDCLine.FindSet then begin
            repeat
                lPDCLine.TestField("Settlement Comments");
                // SMTPMail.AppendBody(lPDCLine."Settlement Comments");
                // SMTPMail.AppendBody('<br>');
                Body += lPDCLine."Settlement Comments" + '<br>';
            until lPDCLine.Next = 0;
        end;

        // SMTPMail.AppendBody('<br><Br>');
        // SMTPMail.AppendBody('Thanks & Regards,');
        // SMTPMail.AppendBody('<br>');
        // SMTPMail.AppendBody(lUser."Full Name");
        // SMTPMail.AppendBody('<br><br>');
        // SMTPMail.Send;

        Body += '<br><Br> Thanks & Regards, <br>' + lUser."Full Name" + '<br><br>';
        EmailMessage.Create(Recipients, Subject, Body, true);
        Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
        Message(lText002);
    end;


    procedure SendMailtointernal(var DocNo: Code[20]; ReasonCode: Code[20]; ReversalComments: Text[100])
    var
        lCLE: Record "Cust. Ledger Entry";
        lCust: Record Customer;
        lText001: label 'Email Id is blank for the Customer %1';
        // SMTPMail: Codeunit "SMTP Mail";
        // SMTPSetup: Record "SMTP Mail Setup";
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        Subject: Text;
        Body: Text;
        lText002: label 'Mail sent to Legal Department Successfully';
        lReasonCode: Record "Reason Code";
        lUserSetup: Record "User Setup";
        lUser: Record User;
        GeneralLedgerSetup: Record "General Ledger Setup";
        // EMail: List of [Text];
        // EMail1: List of [Text];
        Recipients: List of [Text];
    begin
        if lReasonCode.Get(ReasonCode) then
            if not lReasonCode."Mail to Property Mgmt/Legal" then
                exit;
        lUserSetup.Get(UserId);
        lUserSetup.TestField("E-Mail");

        lUser.Reset;
        lUser.SetRange("User Name", UserId);
        if lUser.FindSet then;

        lCLE.Reset;
        lCLE.SetRange("Document No.", DocNo);
        if not lCLE.FindSet then
            exit;

        GeneralLedgerSetup.Get;
        GeneralLedgerSetup.TestField("Legal Department Mail ID");
        GeneralLedgerSetup.TestField("Property Management Mail ID");

        // EMail.Add(GeneralLedgerSetup."Legal Department Mail ID");
        // EMail1.Add(GeneralLedgerSetup."Property Management Mail ID");
        // SMTPMail.CreateMessage(lUser."Full Name", lUserSetup."E-Mail", EMail, 'Reversal Entry ' + DocNo, '', true);
        // SMTPMail.AddRecipients(EMail1);
        // SMTPMail.AppendBody('Hi Team');
        // SMTPMail.AppendBody('<br><br>');
        // SMTPMail.AppendBody('Good day!');
        // SMTPMail.AppendBody('<br><Br>');
        // SMTPMail.AppendBody('Just to notify that PDC entry has been reversed and reversal comments are as below');
        // SMTPMail.AppendBody(ReversalComments);
        // SMTPMail.AppendBody('<br><Br>');
        // SMTPMail.AppendBody('Thanks & Regards,');
        // SMTPMail.AppendBody('<br>');
        // SMTPMail.AppendBody(lUser."Full Name");
        // SMTPMail.AppendBody('<br><br>');
        // SMTPMail.Send;

        Recipients.Add(GeneralLedgerSetup."Legal Department Mail ID");
        Recipients.Add(GeneralLedgerSetup."Property Management Mail ID");
        Subject := 'Reversal Entry ' + DocNo;
        Body := 'Hi Team <br><br>  Good day! <br><Br>';
        Body += 'Just to notify that PDC entry has been reversed and reversal comments are as below';
        Body += ReversalComments + '<br><Br>  Thanks & Regards, <br>' + lUser."Full Name" + '<br><br>';
        EmailMessage.Create(Recipients, Subject, Body, true);
        Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
        Message(lText002);
    end;


    procedure Copybuilding(var Recbuild: Record Building)
    var
        CompList: Page "Companies Lookup";
        Comp: Record Company;
        BuildNew: Record Building;
        lText50001: label 'Building(s) copied to %1 company successfully!!!';
        lCust: Record Building;
        Inserted: Boolean;
        Txt: Text[100];
        lMarkSetup: Record "Marketing Setup";
        CompSalesReceivablesSetup: Record "Sales & Receivables Setup";
        CompNoSeriesLine: Record "No. Series Line";
        ServAmenities: Record "Document Amenities";
        ServAmenities2: Record "Document Amenities";
        Amenities: Record Amenities;
    begin
        Commit;
        Comp.Reset;
        Comp.SetFilter(Comp.Name, '<>%1', COMPANYNAME);
        CompList.SetTableview(Comp);
        CompList.LookupMode(true);
        if CompList.RunModal = Action::LookupOK then begin
            Txt := CompList.GetSelectionFilter;
            Comp2.Reset;
            Comp2.SetFilter(Name, Txt);
            if Comp2.FindSet then begin
                repeat
                    Clear(BuildNew);
                    BuildNew.ChangeCompany(Comp2.Name);
                    //IF Recbuild.FINDSET THEN BEGIN
                    //REPEAT
                    Recbuild.TestField(Recbuild.County);

                    BuildNew.Reset;
                    BuildNew.SetRange(BuildNew.County, Recbuild.County);
                    if BuildNew.FindFirst then
                        Error('Building No %1 with Plot No %2 already exist in Company %3', BuildNew.Code, BuildNew.County, Comp2.Name);


                    BuildNew.Init;
                    BuildNew.TransferFields(Recbuild);
                    BuildNew."Owner code" := '';
                    BuildNew."Owner Name" := '';
                    BuildNew.Insert;
                    Inserted := true;

                    ServAmenities.SetRange(Type, ServAmenities.Type::"Service Item");
                    ServAmenities.SetRange("No.", Recbuild.Code);
                    if ServAmenities.FindFirst then begin
                        repeat
                            Amenities.ChangeCompany(Comp2.Name);
                            if not Amenities.Get(ServAmenities."Amenities Code") then
                                Error('Amenities code %1 doesnot exist in %2', ServAmenities."Amenities Code", Comp2.Name);
                            ServAmenities2.ChangeCompany(Comp2.Name);
                            ServAmenities2.Init;
                            ServAmenities2.TransferFields(ServAmenities);
                            ServAmenities2.Insert;
                        until ServAmenities.Next = 0;
                    end;

                    //UNTIL Recbuild.NEXT =0;
                    //END;
                    if Inserted then
                        Message(lText50001, Comp2.Name);
                until Comp2.Next = 0;
            end;
            exit;
        end;
    end;


    procedure Copyserviceitem(var Recserv: Record "Service Item")
    var
        CompList: Page "Companies Lookup";
        Comp: Record Company;
        ServNew: Record "Service Item";
        lText50001: label 'Service Item/Unit(s) copied to %1 company successfully!!!';
        lCust: Record "Service Item";
        Inserted: Boolean;
        Txt: Text[100];
        CompSalesReceivablesSetup: Record "Service Mgt. Setup";
        CompNoSeriesLine: Record "No. Series Line";
        BuildingCOMP: Record Building;
        servno: Code[20];
        ServAmenities: Record "Document Amenities";
        ServAmenities2: Record "Document Amenities";
        Amenities: Record Amenities;
    begin

        Commit;
        Comp.Reset;
        Comp.SetFilter(Comp.Name, '<>%1', COMPANYNAME);
        CompList.SetTableview(Comp);
        CompList.LookupMode(true);
        if CompList.RunModal = Action::LookupOK then begin
            Txt := CompList.GetSelectionFilter;
            Comp2.Reset;
            Comp2.SetFilter(Name, Txt);
            if Comp2.FindSet then begin
                repeat
                    Clear(ServNew);
                    ServNew.ChangeCompany(Comp2.Name);
                    //IF RecServ.FINDSET THEN BEGIN
                    //REPEAT
                    Message(Recserv."No.");
                    Recserv.TestField(Recserv."Unit No.");
                    Recserv.TestField(Recserv."Building No.");
                    BuildingCOMP.ChangeCompany(Comp2.Name);
                    BuildingCOMP.SetRange(Code, Recserv."Building No.");
                    if not BuildingCOMP.FindFirst then
                        Error('Building %1 doesnt exist in company %2', Recserv."Building No.", Comp2.Name);
                    ServNew.Reset;
                    ServNew.SetRange(ServNew."Unit No.", Recserv."Unit No.");
                    ServNew.SetRange("Building No.", Recserv."Building No.");
                    if ServNew.FindFirst then
                        Error('Service Item already exist in %1 with Building No %2 and  Unit No %3', Comp2.Name, Recserv."Building No.", Recserv."Unit No.");


                    ServNew.Init;
                    ServNew.TransferFields(Recserv);
                    CompSalesReceivablesSetup.ChangeCompany(Comp2.Name);
                    CompSalesReceivablesSetup.Get;
                    if CompSalesReceivablesSetup."Service Item Nos." = '' then
                        Error('Service Item No. series not defined in %1', Comp2.Name);
                    CompNoSeriesLine.ChangeCompany(Comp2.Name);
                    CompNoSeriesLine.SetRange(CompNoSeriesLine."Series Code", CompSalesReceivablesSetup."Service Item Nos.");
                    CompNoSeriesLine.SetFilter(CompNoSeriesLine."Starting Date", '<=%1', Today);
                    CompNoSeriesLine.FindLast;
                    if CompNoSeriesLine."Last No. Used" <> '' then
                        ServNew."No." := IncStr(CompNoSeriesLine."Last No. Used")
                    else
                        ServNew."No." := CompNoSeriesLine."Starting No.";
                    servno := ServNew."No.";
                    CompNoSeriesLine."Last No. Used" := ServNew."No.";
                    CompNoSeriesLine.Modify;
                    ServNew."Job Code" := '';
                    ServNew."Payment Plan Code" := '';
                    ServNew."Customer No." := '';
                    ServNew."Ship-to Code" := '';
                    ServNew."Prospect Code" := '';
                    ServNew.Insert;

                    ServAmenities.SetRange(Type, ServAmenities.Type::"Service Item");
                    ServAmenities.SetRange("No.", Recserv."No.");
                    if ServAmenities.FindFirst then begin
                        repeat
                            Amenities.ChangeCompany(Comp2.Name);
                            if not Amenities.Get(ServAmenities."Amenities Code") then
                                Error('Amenities code %1 doesnot exist in %2', ServAmenities."Amenities Code", Comp2.Name);
                            ServAmenities2.ChangeCompany(Comp2.Name);
                            ServAmenities2.Init;
                            ServAmenities2.TransferFields(ServAmenities);
                            ServAmenities2."No." := servno;
                            ServAmenities2.Insert;
                        until ServAmenities.Next = 0;
                    end;
                    Inserted := true;
                    //UNTIL RecServ.NEXT =0;
                    // END;
                    if Inserted then
                        Message(lText50001, Comp2.Name);
                until Comp2.Next = 0;
            end;
            exit;
        end;
    end;

    //Win513++

    [EventSubscriber(ObjectType::Table, Database::"Contact", 'OnBeforeCreateCustomerFromTemplate', '', true, true)]
    local procedure "Contact_OnBeforeCreateCustomerFromTemplate"
    (
        var Contact: Record "Contact";
        var CustNo: Code[20];
        var IsHandled: Boolean;
        CustomerTemplate: Code[20];
        HideValidationDialog: Boolean
    )
    begin
        Contact.TestField("Emirates ID");
        Contact.TestField("Mobile Phone No.");
        Contact.TestField("E-Mail");
        Contact.TestField(Status, Contact.Status::"Request to Create Customer");
    end;


    [EventSubscriber(ObjectType::Table, Database::"Contact", 'OnAfterCreateCustomer', '', true, true)]
    local procedure "Contact_OnAfterCreateCustomer"
    (
        var Contact: Record "Contact";
        var Customer: Record "Customer"
    )
    var
        Documents: Record "Documents and Articles";
        NewDocuments: Record "Documents and Articles";
        DocumentAttachment: Record "Document Attachment";
        NewDocAttachment: Record "Document Attachment";
        LastDocId: Integer;
    begin
        Customer.Blocked := Customer.Blocked::All;
        //Customer.Rename(Contact."Emirates ID");

        Documents.Reset();
        Documents.SetRange(Documents."Issued To Type", Documents."Issued To Type"::Contact);
        Documents.SetRange(Documents."Issued To", Contact."No.");
        if Documents.FindSet() then
            repeat
                NewDocuments.Init();
                NewDocuments.TransferFields(Documents);
                NewDocuments."Issued To Type" := NewDocuments."Issued To Type"::Customer;
                NewDocuments."Issued To" := Customer."No.";
                NewDocuments.Insert();
            until Documents.Next() = 0;
        //Win593
        LastDocId := 1;
        if DocumentAttachment.FindLast() then
            LastDocId += DocumentAttachment.ID;

        DocumentAttachment.Reset();
        DocumentAttachment.SetRange("No.", Contact."No.");
        DocumentAttachment.SetRange("Table ID", 5050);
        if DocumentAttachment.FindSet() then
            repeat
                NewDocAttachment.Init();
                NewDocAttachment.TransferFields(DocumentAttachment);
                NewDocAttachment.ID := LastDocId;
                NewDocAttachment."No." := Customer."No.";
                NewDocAttachment."Table ID" := 18;
                NewDocAttachment.Insert(true);
            until DocumentAttachment.Next() = 0;

    end;
    //Win593
    [EventSubscriber(ObjectType::Page, Page::"Opportunity List", 'OnOpenPageEvent', '', true, true)]
    local procedure "Opportunity List_OnOpenPageEvent"(var Rec: Record "Opportunity")
    begin
        Rec.SetRange("From Borker", false);
    end;


    [EventSubscriber(ObjectType::Page, Page::"Service Contract", 'OnBeforeActionEvent', '&Print', true, true)]
    local procedure "Service Contract_OnBeforeActionEvent_[processing / General] - &Print"(var Rec: Record "Service Contract Header")
    begin
        Rec.TestField(Rec."Approval Status", Rec."Approval Status"::Released);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SignServContractDoc", 'OnAfterSignContractQuote', '', true, true)]
    local procedure "SignServContractDoc_OnAfterSignContractQuote"
    (
        var SourceServiceContractHeader: Record "Service Contract Header";
        var DestServiceContractHeader: Record "Service Contract Header"
    )
    var
        "Terms&Concotion": Record "Terms & Condtions";
        "Terms&Concotion1": Record "Terms & Condtions";
    begin
        "Terms&Concotion".Reset();
        "Terms&Concotion".SetRange("Terms&Concotion"."Transaction Type", "Terms&Concotion"."Transaction Type"::Service);
        "Terms&Concotion".SetRange("Terms&Concotion"."Document Type", "Terms&Concotion"."Document Type"::Quote);
        "Terms&Concotion".SetRange("Terms&Concotion"."Document No.", SourceServiceContractHeader."Contact No.");
        if "Terms&Concotion".FindSet() then
            repeat
                "Terms&Concotion1".Init();
                "Terms&Concotion1".TransferFields("Terms&Concotion");
                "Terms&Concotion1"."Document Type" := "Terms&Concotion1"."Document Type"::Contract;
                "Terms&Concotion1"."Document No." := DestServiceContractHeader."Contact No.";
                "Terms&Concotion1".Insert();
            until "Terms&Concotion".Next() = 0;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnAfterInitFieldsFromRecRef', '', true, true)]
    local procedure "Document Attachment_OnAfterInitFieldsFromRecRef"
    (
        var DocumentAttachment: Record "Document Attachment";
        var RecRef: RecordRef
    )
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
    begin
        if RecRef.Number = DATABASE::Contact then begin
            FieldRef := RecRef.Field(1);
            RecNo := FieldRef.Value;
            DocumentAttachment.Validate(DocumentAttachment."No.", RecNo);
        end;
    end;
    //Win513--

    //Win593--
    [EventSubscriber(ObjectType::Table, Database::"Service Contract Header", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertOfServiceContract(var Rec: Record "Service Contract Header")
    var
        ServiceCharges: Record "Service Charges";
        ServiceChargesNew: Record "Service Charges";
        ServiceItem: Record "Service Item";
    begin
        if Rec."Contract Type" = Rec."Contract Type"::Contract then begin
            ServiceItem.Get(Rec."Service Item No.");
            ServiceItem."Occupancy Status" := ServiceItem."Occupancy Status"::Occupied;
            ServiceItem.Modify(true);
            ServiceCharges.SetRange("Service Contract Quote No.", Rec."Contract No.");
            if ServiceCharges.FindSet then
                repeat
                    ServiceChargesNew.Init();
                    ServiceChargesNew.TransferFields(ServiceCharges);
                    ServiceChargesNew."Service Contract Quote No." := '';
                    ServiceChargesNew."Service Contract No." := ServiceCharges."Service Contract Quote No.";
                    ServiceChargesNew."Table Subtype" := ServiceChargesNew."Table Subtype"::Contract;
                    ServiceChargesNew.Insert();
                until ServiceCharges.Next() = 0;
        end;
    end;


    [EventSubscriber(ObjectType::Page, Page::"Service Contract Quotes", 'OnAfterActionEvent', '&Make Contract', false, false)]
    local procedure OnAfterActionMakeContractList(var Rec: Record "Service Contract Header")
    begin
        CreateServiceOrder(Rec);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Service Contract Quote", 'OnAfterActionEvent', '&Make Contract', false, false)]
    local procedure OnAfterActionMakeContractCard(var Rec: Record "Service Contract Header")
    begin
        CreateServiceOrder(Rec);
    end;

    local procedure CreateServiceOrder(Rec: Record "Service Contract Header")
    var
        ServiceHeader: Record "Service Header";
    begin
        ServiceHeader.Init();
        ServiceHeader.Validate("Document Type", ServiceHeader."Document Type"::Order);
        //ServiceHeader.Validate("No.",Rec."Contract No.");
        ServiceHeader.Insert(true);
        ServiceHeader.Validate("Customer No.", Rec."Customer No.");
        ServiceHeader.Validate("Building No.", Rec."Building No.");
        ServiceHeader.Validate("Unit No.", Rec."Unit No.");
        ServiceHeader.Validate("Service Item No.", Rec."Service Item No.");
        ServiceHeader."Contact No." := Rec."Contact No.";
        ServiceHeader."Phone No." := Rec."Phone No.";
        ServiceHeader."Contract No." := Rec."Contract No.";//Win593
        ServiceHeader."Approval Status" := Rec."Approval Status";
        ServiceHeader.Name := Rec.Name;
        ServiceHeader."Name 2" := Rec."Name 2";
        ServiceHeader."Type of Ticket" := ServiceHeader."Type of Ticket"::"Check In";
        ServiceHeader.Modify(true);

        CreateSalesLines(Rec, ServiceHeader);
    end;

    local procedure CreateSalesLines(Rec: Record "Service Contract Header"; ServiceHeader: Record "Service Header")
    var
        ServiceItemLine: Record "Service Item Line";
        ServiceContractLine: Record "Service Contract Line";
    begin
        ServiceContractLine.SetRange("Contract Type", Rec."Contract Type"::Quote);
        ServiceContractLine.SetRange("Contract No.", Rec."Contract No.");
        if ServiceContractLine.FindSet() then
            repeat
                ServiceItemLine.Init();
                ServiceItemLine.Validate("Document Type", ServiceHeader."Document Type"::Order);
                ServiceItemLine.Validate("Document No.", ServiceHeader."No.");
                ServiceItemLine.Validate("Line No.", ServiceContractLine."Line No.");
                ServiceItemLine.Validate("Service Item No.", ServiceContractLine."Service Item No.");
                ServiceItemLine."Service Item Group Code" := ServiceContractLine."Service Item Group Code";
                ServiceItemLine.Description := ServiceContractLine.Description;
                if ServiceContractLine."Item No." <> '' then
                    ServiceItemLine.Validate("Item No.", ServiceContractLine."Item No.");
                ServiceItemLine.Insert(true);
            until ServiceContractLine.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Service Header", 'OnInitInsertOnBeforeInitSeries', '', false, false)]
    local procedure OnInitInsertOnBeforeInitSeries(var ServiceHeader: Record "Service Header"; var IsHandled: Boolean)
    var
        ServiceMgtSetup: Record "Service Mgt. Setup";
        NoSeries: Record "No. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        if ServiceHeader."FMS SO" then
            if ServiceHeader."No." = '' then begin
                ServiceMgtSetup.Get();
                if ServiceHeader."Document Type" = ServiceHeader."Document Type"::Quote then begin
                    ServiceMgtSetup.TestField("FMS Quote Nos.");
                    NoSeries.Get(ServiceMgtSetup."FMS Quote Nos.");
                    NoSeriesMgt.InitSeries(ServiceMgtSetup."FMS Quote Nos.", ServiceHeader."No. Series", 0D, ServiceHeader."No.", ServiceHeader."No. Series");
                end;

                if ServiceHeader."Document Type" = ServiceHeader."Document Type"::Order then begin
                    ServiceMgtSetup.TestField("FMS Order Nos.");
                    NoSeries.Get(ServiceMgtSetup."FMS Order Nos.");
                    NoSeriesMgt.InitSeries(ServiceMgtSetup."FMS Order Nos.", ServiceHeader."No. Series", 0D, ServiceHeader."No.", ServiceHeader."No. Series");
                end;
                IsHandled := true;
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ServContractManagement, 'OnBeforeInitServiceLineAppliedGLAccount', '', false, false)]
    local procedure OnBeforeInitServiceLineAppliedGLAccount(var ServLine: Record "Service Line"; var IsHandled: Boolean)
    var
        ServContractHeader: Record "Service Contract Header";
        ServHdr: Record "Service Header";
        DeferralTemplate: Record "Deferral Template";
        GlAcc: Record "G/L Account";
    begin
        // For Multiple Invoices // RealEstateCR
        //IF ForSubstituteInv THEN BEGIN
        ServHdr.Get(ServLine."Document Type", ServLine."Document No.");
        ServContractHeader.Get(ServContractHeader."Contract Type"::Contract, ServHdr."Contract No.");
        ServContractHeader.TESTFIELD("Defferal Code");
        DeferralTemplate.GET(ServContractHeader."Defferal Code");
        DeferralTemplate.TESTFIELD("Deferral Account");
        GlAcc.GET(DeferralTemplate."Deferral Account");
        GlAcc.TESTFIELD("Direct Posting");

        ServLine.Type := ServLine.Type::"G/L Account";
        ServLine.Validate("No.", GlAcc."No.");

        IsHandled := true;

        //END;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Serv-Documents Mgt.", 'OnFinalizeOnBeforeFinalizeHeaderAndLines', '', false, false)]
    local procedure OnFinalizeOnBeforeFinalizeHeaderAndLines(var PassedServHeader: Record "Service Header"; var IsHandled: Boolean)
    begin
        //Service Ticket not to delete from service Header Table
        if (PassedServHeader."Document Type" = PassedServHeader."Document Type"::Order) And (PassedServHeader."FMS SO") then
            IsHandled := true;
    end;
    //Win593--


    [EventSubscriber(ObjectType::Page, Page::"Service Contract", 'OnAfterActionEvent', 'Termination Cr. Memo', false, false)]
    local procedure OnAFterActionCreateSerOrderCheckout(var Rec: Record "Service Contract Header")
    begin
        CreateServiceOrderCheckOut(Rec);
    end;

    local procedure CreateServiceOrderCheckOut(Rec: Record "Service Contract Header")
    var
        RecServiceHeader: Record "Service Header";
    begin

        RecServiceHeader.Init();
        RecServiceHeader.Validate("Document Type", RecServiceHeader."Document Type"::Order);
        RecServiceHeader.Insert(true);
        RecServiceHeader.Validate("Customer No.", Rec."Customer No.");
        RecServiceHeader.Validate("Building No.", Rec."Building No.");
        RecServiceHeader.Validate("Unit No.", Rec."Unit No.");
        RecServiceHeader.Validate("Service Item No.", Rec."Service Item No.");
        RecServiceHeader."Contact No." := Rec."Contact No.";
        RecServiceHeader."Phone No." := Rec."Phone No.";
        RecServiceHeader."Contract No." := Rec."Contract No.";
        RecServiceHeader."Approval Status" := Rec."Approval Status";
        RecServiceHeader.Name := RecServiceHeader.Name;
        RecServiceHeader."Name 2" := RecServiceHeader."Name 2";
        RecServiceHeader.Validate("Order Date", Rec."Termination Date");
        //RecServiceHeader."Type of Ticket" := RecServiceHeader."Type of Ticket"::"Check Out";
        RecServiceHeader.Validate("Type of Ticket", RecServiceHeader."Type of Ticket"::"Check Out");
        RecServiceHeader.Modify(true);

        CreateServiceLines(Rec, RecServiceHeader);

    end;

    local procedure CreateServiceLines(Rec: Record "Service Contract Header"; RecServiceHeader: Record "Service Header")
    var
        RecServiceitemLine: Record "Service Item Line";
        RecServiceContractLine: Record "Service Contract Line";
    begin
        RecServiceContractLine.SetRange("Contract Type", Rec."Contract Type"::Contract);
        RecServiceContractLine.SetRange("Contract No.", Rec."Contract No.");
        if RecServiceContractLine.FindSet() then
            repeat
                RecServiceitemLine.Init();
                RecServiceitemLine.Validate("Document Type", RecServiceHeader."Document Type"::Order);
                RecServiceitemLine.Validate("Document No.", RecServiceHeader."No.");
                RecServiceitemLine.Validate("Line No.", RecServiceContractLine."Line No.");
                RecServiceitemLine.Insert();
                RecServiceitemLine."Service Item No." := RecServiceContractLine."Service Item No.";
                RecServiceitemLine."Service Item Group Code" := RecServiceContractLine."Service Item Group Code";
                RecServiceitemLine.Description := RecServiceContractLine.Description;
                if RecServiceContractLine."Item No." <> '' then
                    RecServiceitemLine."Item No." := RecServiceContractLine."Item No.";
                if RecServiceitemLine.Modify() then;
            until RecServiceContractLine.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Contact Card", 'OnBeforeActionEvent', 'CreateCustomer', false, false)]
    local procedure CheckEmiratesIdCustomer(var Rec: Record Contact)
    begin
        if Rec."Emirates ID" = '' then
            Error('Please Entre Emirates ID');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order", 'OnBeforeDeleteSalesQuote', '', true, true)]
    //Win593++
    local procedure OnBeforeDeleteSalesQuote(var QuoteSalesHeader: Record "Sales Header"; var OrderSalesHeader: Record "Sales Header")
    var
        AmortizationEntry: Record "Amortization Entry";
        AmortizationEntryOrder: Record "Amortization Entry";
        PDCEntry: Record "Post Dated Check Line";
        PDCForOrder: Record "Post Dated Check Line";
    begin
        AmortizationEntry.SetRange("Document Type", AmortizationEntry."Document Type"::Quote);
        AmortizationEntry.SetRange("Document No.", QuoteSalesHeader."No.");
        if AmortizationEntry.FindSet() then begin
            repeat
                AmortizationEntryOrder.TransferFields(AmortizationEntry, true);
                AmortizationEntryOrder."Document Type" := AmortizationEntryOrder."Document Type"::Order;
                AmortizationEntryOrder."Document No." := OrderSalesHeader."No.";
                AmortizationEntryOrder.Insert();
            until AmortizationEntry.Next() = 0;

            AmortizationEntry.DeleteAll();
        end;
        PDCEntry.SetRange("Document Type", PDCEntry."Document Type"::Quote);
        PDCEntry.SetRange("Document No.", QuoteSalesHeader."No.");
        if PDCEntry.FindSet() then begin
            repeat
                PDCForOrder.TransferFields(PDCEntry, true);
                PDCForOrder."Document Type" := PDCForOrder."Document Type"::Order;
                PDCForOrder."Document No." := OrderSalesHeader."No.";
                PDCForOrder.Insert();
            until PDCForOrder.Next() = 0;

            PDCEntry.DeleteAll();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeDeleteAfterPosting', '', false, false)]
    local procedure OnBeforeDeleteAfterPosting(var SalesHeader: Record "Sales Header"; var SkipDelete: Boolean)
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            SalesHeader.Status := SalesHeader.Status::Released;
            SalesHeader.Modify(true);
            SkipDelete := true;
        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', false, false)]
    local procedure OnBeforePostSalesDoc(var SalesHeader: Record "Sales Header")
    var
        AmountErr: Label 'Loan Amount and Down Payment must be equal to %1';
    begin
        if (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) AND
         (SalesHeader."Loan Type" = SalesHeader."Loan Type"::"RDK Loan") then begin
            SalesHeader.CalcFields("Amount Including VAT");
            if (SalesHeader."Own Contribution" + SalesHeader."RDK Loan") <> SalesHeader."Amount Including VAT" then
                Error(AmountErr, SalesHeader."Amount Including VAT");
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Contact, 'OnAfterCreateCustomer', '', false, false)]
    local procedure OnAfterCreateCustomer(var Customer: Record Customer)
    begin
        Customer.Blocked := Customer.Blocked::All;
        Customer.Modify();
    end;
    //Win593--
}

