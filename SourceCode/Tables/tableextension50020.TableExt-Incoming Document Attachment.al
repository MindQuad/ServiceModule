tableextension 50020 tableextension50020 extends "Incoming Document Attachment"
{
    procedure NewAttachmentwithLineNo(var Lineno: Integer)
    var
        ImportAttachmentIncDoc: Codeunit 134;
    begin
        IF NOT CODEUNIT.RUN(CODEUNIT::"Import Attachment - Inc. Doc.", Rec) THEN
            ERROR('');
        //ImportAttachmentIncDoc.NextExpenseLine(Lineno);//WIN292
        ImportAttachmentIncDoc.RUN(Rec);
    end;

    procedure NewAttachment1(var ContNo: Code[20]; LineNo: Integer)
    var
        TempBlob: codeunit "Temp Blob";//WIn292

        FileManagement: Codeunit 419;
    begin
        //IF NOT CODEUNIT.RUN(CODEUNIT::"Import Attachment - Inc. Doc.",Rec) THEN
        //  ERROR('');
        //win315++
        ContactNum := ContNo;
        Ln := LineNo;
        CALCFIELDS(Content);
        FileName := FileManagement.BLOBImportWithFilter(TempBlob, ImportTxt, FileName, STRSUBSTNO(FileDialogTxt, FilterTxt), FilterTxt);//WIN292
        FileName2 := FileName;
        //Content := TempBlob.Blob;//WIN292
        //ERROR(FileName2);
        ImportDocumentAttch(Rec, FileName, ContactNum, Ln);
        //win315--
    end;

    local procedure ImportDocumentAttch(var IncomingDocumentAttachment: Record 133; FileName: Text[1024]; ContactNo: Code[20]; LnNum: Integer): Boolean
    var
        IncomingDocument: Record 130;
        TempBlob: codeunit "Temp Blob";//WIN292
        FileManagement: Codeunit 419;
        EntryNo: Integer;
        RecContact: Record 50009;
    begin
        //win315++
        IF FileName = '' THEN
            ERROR('');
        IncomingDocumentAttachment.RESET;
        IF IncomingDocumentAttachment.FINDLAST THEN;
        EntryNo := "Incoming Document Entry No." + 1;

        //Win513++
        //WITH IncomingDocumentAttachment DO BEGIN
        //Win513--
        "Incoming Document Entry No." := EntryNo;
        "Line No." := LnNum;//GetNextLineNo(IncomingDocument);
                            /*
                             IF NOT Content.HASVALUE THEN BEGIN
                               IF FileManagement.ServerFileExists(FileName) THEN BEGIN
                                 FileManagement.BLOBImportFromServerFile(TempBlob,FileName);
                                 MESSAGE('1')
                               END
                               ELSE Begin
                                 FileManagement.BLOBImportFromServerFile(TempBlob,FileManagement.UploadFileSilent(FileName));
                               Content := TempBlob.Blob;
                               MESSAGE('2');
                               END;
                             END;
                             */
                            /* FileManagement.BLOBImportFromServerFile(TempBlob, FileManagement.UploadFileSilent(FileName));
                            Content := TempBlob.Blob; *///WIN292

        VALIDATE("File Extension", LOWERCASE(COPYSTR(FileManagement.GetExtension(FileName), 1, MAXSTRLEN("File Extension"))));
        IF Name = '' THEN
            Name := COPYSTR(FileManagement.GetFileNameWithoutExtension(FileName), 1, MAXSTRLEN(Name));
        Name := COPYSTR(FileManagement.GetFileNameWithoutExtension(FileName), 1, MAXSTRLEN(Name));
        Txt := FileManagement.GetFileName(Name);
        //   ERROR(Txt);
        "Document No." := ContactNo;//WIN269
        "Posting Date" := IncomingDocument."Posting Date";
        IF IncomingDocument.Description = '' THEN BEGIN
        END;
        INSERT(TRUE);

        IF Type IN [Type::Image, Type::PDF] THEN;
        // OnAttachBinaryFile;//WIN292
        //Win513++
        //END;
        //Win513--
        EXIT(TRUE);

        //WIN-END
        //win315--

    end;

    var
        ContactNum: Code[20];
        Contact: Record 50009;
        FileName: Text[1024];
        FileName2: Text[1024];
        ImportTxt: Label 'Insert File';
        FileDialogTxt: Label 'Attachments (%1)|%1';
        FilterTxt: Label '*.jpg;*.jpeg;*.bmp;*.png;*.gif;*.tiff;*.tif;*.pdf;*.docx;*.doc;*.xlsx;*.xls;*.pptx;*.ppt;*.msg;*.xml;*.*';
        Ln: Integer;
        Txt: Text[1024];
}

