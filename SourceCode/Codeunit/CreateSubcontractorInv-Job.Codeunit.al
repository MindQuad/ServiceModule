Codeunit 50001 "Create Subcontractor Inv - Job"
{
    // //WIN325090617 - Created


    trigger OnRun()
    begin
    end;

    var
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        TempRec: Record "Aging Band Buffer" temporary;
        Job: Record Job;
        InvCount: Integer;
        Text001: label '%1 Subcontractor Invoices created successfully!!';
        Text002: label 'Do you want to Create Purchase Invoice?';
        Text003: label 'You cannot create Purchase Invoice.Its already exists.';


    procedure CreateSubContractInvoice(var JobPlanningLine: Record "Job Planning Line")
    var
        SalesHeader: Record "Sales Header";
        GetSalesCrMemoNo: Report "Job Transfer to Credit Memo";
        Done: Boolean;
        NewInvoice: Boolean;
        PostingDate: Date;
        InvoiceNo: Code[20];
    begin
        if not Confirm(Text002) then
          exit;

        TempRec.DeleteAll;
        JobPlanningLine.SetCurrentkey("Job No.","Job Task No.","SubContractor No.");;
        if JobPlanningLine.FindSet then begin
          repeat
            JobPlanningLine.CalcFields(JobPlanningLine."Purchase Invoice No.",JobPlanningLine."Posted Pur. Inv. No.");
            if (JobPlanningLine."Purchase Invoice No." <> '') or (JobPlanningLine."Posted Pur. Inv. No." <> '') then
              Error(Text003);

            JobPlanningLine.TestField("SubContractor No.");
            JobPlanningLine.TestField("Subcontractor Bill Value");
            if not TempRec.Get(JobPlanningLine."SubContractor No.") then begin
              TempRec.Init;
              TempRec."Currency Code" := JobPlanningLine."SubContractor No.";
              TempRec.Insert;
            end;
          until JobPlanningLine.Next =0;
        end;

        Clear(InvCount);
        TempRec.Reset;
        if TempRec.FindSet then begin
         repeat
            //Creating Purchase Header
            PurchHeader.Init;
            PurchHeader."Document Type" := PurchHeader."document type"::Invoice;
            PurchHeader."No." := '';
            InvCount += 1;
            PurchHeader.Insert(true);
            PurchHeader.Validate("Buy-from Vendor No.",TempRec."Currency Code");
            PurchHeader.Validate("Posting Date",JobPlanningLine."Planning Date");
            PurchHeader."Requisition No." := JobPlanningLine."Job No.";
            //PurchHeader."Job Task No." := JobPlanningLine."Job Task No.";
            //PurchHeader."Job Planning Line No." := JobPlanningLine."Line No.";
            PurchHeader.Modify(true);

            //Creating Purchase Lines
            CreatePurchLines(JobPlanningLine);
            if JobPlanningLine."Deduction Plan Code" <> '' then
              CreateDeductionPurchLines(JobPlanningLine);
         until TempRec.Next =0;
        end;

        if InvCount <> 0 then
          Message(Text001,InvCount);
    end;

    local procedure CreatePurchLines(var JobPlanningLine: Record "Job Planning Line")
    var
        Job: Record Job;
        DimMgt: Codeunit DimensionManagement;
        Factor: Integer;
        DimSetIDArr: array [10] of Integer;
    begin
         JobPlanningLine.SetRange("SubContractor No.",PurchHeader."Buy-from Vendor No.");
         if JobPlanningLine.FindSet then begin
           repeat
            PurchLine.Init;
            PurchLine."Document Type" := PurchHeader."Document Type";
            PurchLine."Document No."  := PurchHeader."No.";
            PurchLine."Line No."      := GetNextLineNo(PurchLine);
            PurchLine.Insert(true);
            if JobPlanningLine.Type = JobPlanningLine.Type::"G/L Account" then
              PurchLine.Validate(Type,PurchLine.Type::"G/L Account");
            if JobPlanningLine.Type = JobPlanningLine.Type::Item then
              PurchLine.Validate(Type,PurchLine.Type::Item);
            PurchLine.Validate("No.",JobPlanningLine."No.");
            PurchLine.Description := JobPlanningLine.Description;
            PurchLine.Validate("Location Code",JobPlanningLine."Location Code");
            PurchLine.Validate("Unit of Measure Code",JobPlanningLine."Unit of Measure Code");
            PurchLine.Validate(Quantity,JobPlanningLine.Quantity);
            PurchLine.Validate("Direct Unit Cost",JobPlanningLine."Unit Cost");
            PurchLine.Validate("Job No.",JobPlanningLine."Job No.");
            PurchLine.Validate("Job Task No.",JobPlanningLine."Job Task No.");
            PurchLine.Validate("Job Line Type",JobPlanningLine."Line Type");
            PurchLine.Validate("Job Planning Line No.",JobPlanningLine."Line No.");
            //PurchLine."Ref. Planning Line No." := JobPlanningLine."Line No.";
            //PurchLine."Created from Job" := TRUE;
            PurchLine.Modify(true);
           until JobPlanningLine.Next =0;
         end;

    end;

    local procedure CreateDeductionPurchLines(var JobPlanningLine: Record "Job Planning Line")
    var
        Job: Record Job;
        DimMgt: Codeunit DimensionManagement;
        Factor: Integer;
        DimSetIDArr: array [10] of Integer;
        lDedPlan: Record "Deduction Plan";
    begin
        JobPlanningLine.TestField("Deduction Plan Code");
        lDedPlan.Reset;
        lDedPlan.SetRange(Code,JobPlanningLine."Deduction Plan Code");
        lDedPlan.SetFilter(Type,'<>%1',lDedPlan.Type::Expense);
        if lDedPlan.FindSet then begin
          repeat
            lDedPlan.TestField("G/L Account");
            lDedPlan.TestField(Percentage);
            PurchLine.Init;
            PurchLine."Document Type" := PurchHeader."Document Type";
            PurchLine."Document No."  := PurchHeader."No.";
            PurchLine."Line No."      := GetNextLineNo(PurchLine);
            PurchLine.Insert(true);
            PurchLine.Validate(Type,PurchLine.Type::"G/L Account");
            PurchLine.Validate("No.",lDedPlan."G/L Account");
            PurchLine.Validate(Description,lDedPlan.Description);
            PurchLine.Validate("Location Code",JobPlanningLine."Location Code");
            PurchLine.Validate("Unit of Measure Code",JobPlanningLine."Unit of Measure Code");
            PurchLine.Validate(Quantity,-1);
            PurchLine.Validate("Direct Unit Cost",(JobPlanningLine."Unit Cost" * (lDedPlan.Percentage /100)));
            PurchLine.Validate("Job No.",JobPlanningLine."Job No.");
            PurchLine.Validate("Job Task No.",JobPlanningLine."Job Task No.");
            PurchLine.Validate("Job Line Type",JobPlanningLine."Line Type");
            //PurchLine."Ref. Planning Line No." := JobPlanningLine."Line No.";
            //PurchLine."Created from Job" := TRUE;
            PurchLine.Modify(true);
          until lDedPlan.Next =0;
        end;
    end;

    local procedure GetNextLineNo(PurchLine: Record "Purchase Line"): Integer
    var
        NextLineNo: Integer;
    begin
        PurchLine.SetRange("Document Type",PurchLine."Document Type");
        PurchLine.SetRange("Document No.",PurchLine."Document No.");
        NextLineNo := 10000;
        if PurchLine.FindLast then
          NextLineNo := PurchLine."Line No." + 10000;
        exit(NextLineNo);
    end;
}

