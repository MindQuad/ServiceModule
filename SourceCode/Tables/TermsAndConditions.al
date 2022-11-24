tableextension 50502 TermsAndConditions_Extn extends "Terms And Conditions"
{
    fields
    {
        field(50000; "Contract Type"; Option)
        {
            Caption = 'Contract Type';
            OptionCaption = 'Commercial,Residential';
            OptionMembers = "Commercial","Residential";
            DataClassification = ToBeClassified;
        }
        field(50001; Mandatory; Boolean)
        {
            Caption = 'Mandatory';
            DataClassification = ToBeClassified;
        }
        field(50002; "Select"; Boolean)
        {
            Caption = 'Select';
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}