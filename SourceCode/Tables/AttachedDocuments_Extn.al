tableextension 60000 AttachedDocuments_Extn extends "Document Attachment"
{
    fields
    {
        field(50000; "Confidential Code"; Code[10])
        {
            Caption = 'Confidential Code';
            NotBlank = true;
            TableRelation = Confidential.code;

            trigger OnValidate()
            var
                Confidential: Record Confidential;
                ErrEmployeeDocumentInvlaid: Label 'Invalid Document Type';
            begin
                IF Confidential.GET("Confidential Code") THEN BEGIN
                    Description := Confidential.Description;
                END ELSE
                    ERROR(ErrEmployeeDocumentInvlaid);
            end;
        }
        field(50001; Description; Text[50])
        {
            Caption = 'Description';
        }
        Field(50002; "Validity"; Date)
        {
            Caption = 'Validity';
        }
        Field(50003; "UID No."; Code[10])
        {
            Caption = 'UID No.';
        }
    }

    var
        myInt: Integer;
}