codeunit 50110 "Utility Entries Management"
{

    procedure ImportUtilityEntriesFromCSVUsingCSVBuffer()
    var
        UtilityEntries: Record "Utility Entries";
        TempCSVBuffer: Record "CSV Buffer" temporary;
        FilePath: Text;
        InFileStream: InStream;
    begin
        if UploadIntoStream('Select File..', '', '', FilePath, InFileStream) then begin
            TempCSVBuffer.DeleteAll();
            TempCSVBuffer.LoadDataFromStream(InFileStream, ',');
            if TempCSVBuffer.FindSet() then
                repeat
                    case TempCSVBuffer."Field No." of
                        1:
                            begin
                                Evaluate(UtilityEntries."Utility Date", TempCSVBuffer.Value);
                                UtilityEntries.Init();
                            end;
                        2:
                            UtilityEntries.Validate("Utility Code", TempCSVBuffer.Value);
                        3:
                            UtilityEntries.Validate("Unit Code", TempCSVBuffer.Value);
                        4:
                            Evaluate(UtilityEntries."Meter Reading", TempCSVBuffer.Value);
                        5:
                            begin
                                Evaluate(UtilityEntries.Amount, TempCSVBuffer.Value);
                                UtilityEntries.Insert(true);
                            end;
                    end;
                until TempCSVBuffer.Next() = 0;
        end;
    end;

    procedure ProcessUtilityEntries()
    var
        ServiceSetup: Record "Service Mgt. Setup";
        ServiceHeader: Record "Service Header";
        ServiceLine: Record "Service Line";
        UtilityEntries: Record "Utility Entries";
        PrevCustomerNo: Code[20];
        UtilityMaster: Record "Utility Master";
        ServiceLineDes: Label '%1 for %2';
        MonthTextL: Text;
    begin
        UtilityEntries.SetCurrentKey("Customer No.");
        UtilityEntries.SetRange("Service Invoice No.", '');
        if UtilityEntries.FindSet() then
            repeat
                if PrevCustomerNo <> UtilityEntries."Customer No." then begin
                    PrevCustomerNo := UtilityEntries."Customer No.";
                    Clear(ServiceHeader);
                    ServiceHeader.Init();
                    ServiceHeader.Validate("Document Type", ServiceHeader."Document Type"::Invoice);
                    ServiceHeader.Validate("Customer No.", UtilityEntries."Customer No.");
                    ServiceHeader.Validate("Posting Date", Today);
                    ServiceHeader.Validate("Due Date", Today);
                    ServiceHeader.Insert(true);
                end;

                clear(ServiceLine);
                ServiceLine.Init();
                ServiceLine.Validate("Document Type", ServiceHeader."Document Type");
                ServiceLine.Validate("Document No.", ServiceHeader."No.");
                ServiceLine.Validate("Line No.", GetServiceLineNo(ServiceHeader));
                ServiceLine.Validate(Type, ServiceLine.Type::"G/L Account");
                UtilityMaster.Get(UtilityEntries."Utility Code");
                ServiceLine.Validate("No.", UtilityMaster."Related G/L Account");
                MonthTextL := Format(UtilityEntries."Utility Date", 0, '<Month Text> <Year4>');
                ServiceLine.Validate(Description, StrSubstNo(ServiceLineDes, UtilityMaster."Utility Description", MonthTextL));
                ServiceLine.Validate(Quantity, 1);
                ServiceLine.Validate("Unit Price", UtilityEntries.Amount);
                ServiceLine.Insert(true);

                UtilityEntries."Service Invoice No." := ServiceHeader."No.";
                UtilityEntries.Modify(true);
            Until UtilityEntries.Next() = 0;

        ServiceSetup.Get();
        if ServiceSetup."Post Utility Entries" then begin
            Commit();
            PostServiceInvoices();
        end;
    end;

    local procedure GetServiceLineNo(ServiceHeader: Record "Service Header"): Integer
    var
        ServiceLine: Record "Service Line";
    begin
        ServiceLine.SetRange("Document Type", ServiceHeader."Document Type");
        ServiceLine.SetRange("Document No.", ServiceHeader."No.");
        if ServiceLine.FindLast() then
            exit(ServiceLine."Line No." + 10000)
        else
            exit(10000);
    end;

    local procedure PostServiceInvoices()
    var
        ServiceHeader: Record "Service Header";
        ServiceInvHeader: Record "Service Invoice Header";
        UtilityEntries: Record "Utility Entries";
        UtilityEntries2: Record "Utility Entries";
        ServicePost: Codeunit "Service-Post";
    begin
        UtilityEntries.SetCurrentKey("Service Invoice No.", "Posted Service Invoice No.");
        UtilityEntries.SetFilter("Service Invoice No.", '<>%1', '');
        UtilityEntries.SetRange("Posted Service Invoice No.", '');
        if UtilityEntries.FindSet() then
            repeat
                Clear(UtilityEntries2);
                ClearLastError();
                if ServiceHeader.Get(ServiceHeader."Document Type"::Invoice, UtilityEntries."Service Invoice No.") then
                    if ServicePost.Run(ServiceHeader) then begin
                        ServiceInvHeader.SetRange("Pre-Assigned No.", UtilityEntries."Service Invoice No.");
                        if ServiceInvHeader.FindFirst() then;
                        UtilityEntries2.SetRange("Utility Date", UtilityEntries."Utility Date");
                        UtilityEntries2.SetRange("Utility Code", UtilityEntries."Utility Code");
                        UtilityEntries2.SetRange("Unit Code", UtilityEntries."Unit Code");
                        if UtilityEntries2.FindSet() then begin
                            UtilityEntries2.ModifyAll("Posted Service Invoice No.", ServiceInvHeader."No.");
                            UtilityEntries2.ModifyAll("Error Message", '');
                        end;
                    end else begin
                        UtilityEntries2.SetRange("Utility Date", UtilityEntries."Utility Date");
                        UtilityEntries2.SetRange("Utility Code", UtilityEntries."Utility Code");
                        UtilityEntries2.SetRange("Unit Code", UtilityEntries."Unit Code");
                        UtilityEntries2.ModifyAll("Error Message", GetLastErrorText());
                    end;
                Commit();
            until UtilityEntries.Next() = 0;
    end;
}