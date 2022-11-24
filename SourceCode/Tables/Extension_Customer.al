tableextension 50087 "Customer Ext" extends Customer
{
    fields
    {
        field(50000; "Building No."; Code[20])
        {
            Caption = 'Building No.';
            TableRelation = Building;
        }

        field(50004; "Source of Lead"; Code[20])
        {
            Caption = 'Source of Lead';

        }
        field(50005; "Source Company"; Text[50])
        {
            Caption = 'Source Company';
            Editable = false;
        }
        // field(50008; "Passport No."; Code[20])
        // {
        //     Caption = 'Passport No.';
        //     trigger OnValidate()
        //     begin
        //         CheckDuplicatePassportNo; //Shruti-WIN347
        //         CheckDuplicateinothercompany;
        //     end;
        // }
        field(50009; "Trade License No."; Code[20])
        {
            Caption = 'Trade License No.';

            trigger OnValidate()
            begin
                CheckDuplicateTradeLicenseNo; //Shruti-WIN347
                CheckDuplicateinothercompany;
            end;
        }
        field(50011; "Source Company Customer Code"; Code[20])
        {
            Caption = 'Source Company Customer Code';
        }
        field(50012; "Lead Subtype"; Option)
        {
            Caption = 'Lead Subtype';
            OptionCaption = ' ,Online, PR, Event, sponsorship, Affiliates, others';
            OptionMembers = " ",Online,PR,Event,sponsorship,Affiliates,others;
        }
        field(50016; "Campaign Code"; Code[20])
        {
            Caption = 'Campaign Code';
            TableRelation = Campaign."No.";
        }
        field(50017; "Emirates ID"; Code[20])
        {
            Caption = 'Emirates ID';

            trigger OnValidate()
            begin
                CheckDuplicateEmiratesID; //Shruti-WIN347
                CheckDuplicateinothercompany;
            end;

        }
        field(50018; "Passport No."; Code[20])
        {
            Caption = 'Passport No.';
            trigger OnValidate()
            begin
                CheckDuplicatePassportNo; //Shruti-WIN347
                CheckDuplicateinothercompany;
            end;

        }
        field(50019; "D-U-N-S Number"; Text[30])
        {
            Caption = 'D-U-N-S Number';
        }
        field(50020; "Document Verifield"; Boolean)
        {
            Caption = 'Document Verifield';
            Editable = false;
        }
        field(50021; "Verified By"; Code[50])
        {
            Caption = 'Verified By';
            Editable = false;
        }
        field(50022; "Verified Date-Time"; DateTime)
        {
            Caption = 'Verified Date-Time';
            Editable = false;
        }
        field(50023; "Marital Status"; Option)
        {
            Caption = 'Marital Status';
            OptionMembers = " ",Single,Married,Divorced,Seperated;
            OptionCaption = ' ,Single,Married,Divorced,Seperated';
        }
        field(50024; "Mobile Phone No.2"; Text[30])
        {
            Caption = 'Mobile Phone No.2';
        }
        field(50025; "VAT Reg. No."; Text[30])
        {
            Caption = 'VAT Reg. No.';

        }
        field(50026; "Emergency Contact Name"; Text[50])
        {
            Caption = 'Emergency Contact Name';
        }
        field(50027; "STD Code"; Code[10])
        {
            Caption = 'STD Code';

        }
        field(50028; "Contact Creation User Id"; Code[20])
        {
            Caption = 'Contact Creation User Id';
        }
        field(50029; "Tenancy Type"; Option)
        {
            Caption = 'Tenancy Type';
            OptionMembers = " ",Residential,Commercial;
            OptionCaption = ' ,Residential,Commercial';
        }
        field(50030; "Employer Name & Add."; Text[250])
        {
            Caption = 'Employer Name & Add.';

        }
        field(50031; "Employer's Contact & Email"; Text[100])
        {
            Caption = 'Employers Contact & Email';
        }
        field(50032; Nationality; Text[30])
        {
            Caption = 'Nationality';
        }
        field(50038; "S/T Expiry Date"; Date)
        {
            Caption = 'S/T Expiry Date';
        }

        field(50039; "Unit Code"; Code[20])
        {
            Caption = 'Unit Code';
            FieldClass = FlowField;
            CalcFormula = Lookup("Service Contract Header"."Unit No." WHERE("Customer No." = FIELD("No.")));
        }
        field(50040; Unit; Code[20])
        {
            Caption = 'Unit';
            FieldClass = FlowField;
            CalcFormula = Lookup("Service Contract Header"."Unit No." WHERE("Customer No." = FIELD("No.")));
        }
        field(50041; "Building Name"; Text[50])
        {
            Caption = 'Building Name';

            FieldClass = FlowField;
            CalcFormula = Lookup(Building.Description WHERE(Code = FIELD("Building No.")));
        }
        Field(50042; "Gender"; Enum Gender)
        {
            Caption = 'Gender';
        }
        Field(50043; "Company/Individual"; Enum "Company/Individual")
        {
            Caption = 'Company/Individual';
        }
        Field(50044; "Employer\ Employee Address"; Enum "Employer\ Employee Addres")
        {
            Caption = 'Employer\ Employee Address';
        }
        field(50500; "Company To"; Text[30])
        {
            Caption = 'Company To';
        }
        field(60000; Password; Text[30])
        {
            Caption = 'Password';
        }
        field(50505; "Service Item No."; Code[20])
        {
            Caption = 'Service Item No.';
            FieldClass = FlowField;
            CalcFormula = Lookup("Service Contract Header"."Service Item No." WHERE("Customer No." = FIELD("No."), "Contract Type" = const(Contract)));
        }
    }

    var
        myInt: Integer;
        RecCustomer: Record Customer;


    //WIN513++
    //WIN 269  FIN/2.8/1/1.5 
    // trigger OnAfterInsert()
    // begin
    //     Blocked := Blocked::All;
    // end;
    //WIN513--

    Procedure CheckDuplicatePassportNo()
    var

        lText001: Label 'Passport No already exists for the contact %1';
        lText002: Label 'Passport No already exists for the customer %1';
    begin
        IF "Passport No." = '' THEN
            EXIT;
        //Shruti-WIN347
        RecCustomer.RESET;
        RecCustomer.SETFILTER("No.", '<>%1', "No.");
        RecCustomer.SETRANGE("Passport No.", "Passport No.");
        IF RecCustomer.FINDSET THEN
            ERROR(lText002, RecCustomer."No.");
    end;

    procedure CheckDuplicateinothercompany()
    var

        comp: Record Company;
        compCustomer: Record Customer;
        lText001: Label 'Emirates ID. already exists for the contact %1 of Company %2';
        lText002: Label 'Passport No. already exists for the contact %1 of Company %2';
        lText003: Label 'Trade License No. already exists for the contact %1 of Company %2';
    begin
        IF ("Trade License No." = '') AND ("Passport No." = '') AND ("Emirates ID" = '') THEN
            EXIT;

        //Shruti-WIN347
        comp.SETFILTER(comp.Name, '<>%1', COMPANYNAME);
        IF comp.FINDFIRST THEN BEGIN
            REPEAT
                IF ("Emirates ID" <> '') THEN BEGIN
                    compCustomer.CHANGECOMPANY(comp.Name);
                    compCustomer.SETFILTER(compCustomer."Source Company Customer Code", '<>%1', "No.");
                    compCustomer.SETRANGE("Emirates ID", "Emirates ID");
                    IF compCustomer.FINDSET THEN
                        ERROR(lText001, compCustomer."No.", comp.Name);
                END;
                IF ("Passport No." <> '') THEN BEGIN
                    compCustomer.CHANGECOMPANY(comp.Name);
                    compCustomer.SETFILTER(compCustomer."Source Company Customer Code", '<>%1', "No.");
                    compCustomer.SETRANGE("Passport No.", "Passport No.");
                    IF compCustomer.FINDSET THEN
                        ERROR(lText002, compCustomer."No.", comp.Name);
                END;
                IF ("Trade License No." <> '') THEN BEGIN
                    compCustomer.CHANGECOMPANY(comp.Name);
                    compCustomer.SETFILTER(compCustomer."Source Company Customer Code", '<>%1', "No.");
                    compCustomer.SETRANGE("Trade License No.", "Trade License No.");
                    IF compCustomer.FINDSET THEN
                        ERROR(lText003, compCustomer."No.", comp.Name);
                END;
            UNTIL comp.NEXT = 0;
        END;
    end;

    procedure CheckDuplicateEmiratesID()
    var
        lText001: Label 'Emirates ID already exists for the contact %1';
        lText002: Label 'Emirates ID already exists for the customer %1';
    begin
        IF "Emirates ID" = '' THEN
            EXIT;
        //Shruti-WIN347
        RecCustomer.RESET;
        RecCustomer.SETFILTER("No.", '<>%1', "No.");
        RecCustomer.SETRANGE("Emirates ID", "Emirates ID");
        IF RecCustomer.FINDSET THEN
            ERROR(lText002, RecCustomer."No.");

        IF STRLEN("Emirates ID") <> 18 THEN
            ERROR('Length should be 18 Characters');
    end;


    procedure CheckDuplicateTradeLicenseNo()
    var

        lText001: Label 'Trade License No. already exists for the contact %1';
        lText002: Label 'Trade License No. already exists for the customer %1';
    begin
        IF "Trade License No." = '' THEN
            EXIT;
        //Shruti-WIN347
        RecCustomer.RESET;
        RecCustomer.SETFILTER("No.", '<>%1', "No.");
        RecCustomer.SETRANGE("Trade License No.", "Trade License No.");
        IF RecCustomer.FINDSET THEN
            ERROR(lText002, RecCustomer."No.");
    end;
}