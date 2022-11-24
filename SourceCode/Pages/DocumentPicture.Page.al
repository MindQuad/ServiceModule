page 50047 "Document Picture"
{
    Caption = 'Contact Picture';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = CardPart;
    SourceTable = 133;

    layout
    {
        area(content)
        {
            //Win513++
            //field(Content; Rec.Content)
            field(Content_New; Rec.Content)
            //Win513--
            {
                ApplicationArea = Basic, Suite;
                ShowCaption = false;
                ToolTip = 'Specifies the picture of the contact, for example, a photograph if the contact is a person, or a logo if the contact is a company.';
            }
        }
    }

    actions
    {
        area(processing)
        {
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetEditableOnPictureActions;
    end;

    trigger OnOpenPage()
    begin
        /*  CameraAvailable := CameraProvider.IsAvailable;
         IF CameraAvailable THEN
             CameraProvider := CameraProvider.Create; */
    end;

    var
        //[RunOnClient]
        //[WithEvents]
        //CameraProvider: DotNet CameraProvider;//WIN292
        CameraAvailable: Boolean;
        OverrideImageQst: Label 'The existing picture will be replaced. Do you want to continue?';
        DeleteImageQst: Label 'Are you sure you want to delete the picture?';
        SelectPictureTxt: Label 'Select a picture to upload';
        DeleteExportEnabled: Boolean;
        DownloadImageTxt: Label 'Download image';

    local procedure SetEditableOnPictureActions()
    begin
        DeleteExportEnabled := Rec.Content.HASVALUE;
    end;

    /* trigger CameraProvider::PictureAvailable(PictureName: Text; PictureFilePath: Text)
    var
        File: File;
        Instream: InStream;
    begin
        IF (PictureName = '') OR (PictureFilePath = '') THEN
            EXIT;

        IF Rec.Content.HASVALUE THEN
            IF NOT CONFIRM(OverrideImageQst) THEN BEGIN
                IF ERASE(PictureFilePath) THEN;
                EXIT;
            END;

        File.OPEN(PictureFilePath);
        File.CREATEINSTREAM(Instream);

        CLEAR(Rec.Content);
        //Content.IMPORTSTREAM(Instream,PictureName);
        Rec.MODIFY(TRUE);

        File.CLOSE;
        IF ERASE(PictureFilePath) THEN;
    end; *///WIN292
}

