table 50112 Person
{
    Caption = 'Person';
    //LookupPageID = 33055951;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    HumanResSetup.GET;
                    NoSeriesMgt.TestManual(HumanResSetup."Person Nos.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "First Name"; Text[30])
        {
            Caption = 'First Name';

            trigger OnValidate()
            begin
                IF (xRec."First Name" <> '') AND UsedAsEmployee THEN
                    ERROR(Text007);

                IF ("First Name" <> '') AND ("Middle Name" <> '') THEN
                    Initials := COPYSTR("First Name", 1, 1) + '.' + COPYSTR("Middle Name", 1, 1) + '.';

                VALIDATE("Full Name", GetFullName);

                IF "First Name" <> xRec."First Name" THEN BEGIN
                    Employee.RESET;
                    Employee.SETCURRENTKEY("Person No.");
                    Employee.SETRANGE("Person No.", "No.");
                    //Employee.MODIFYALL("First Name","First Name");
                END;
            end;
        }
        field(3; "Middle Name"; Text[30])
        {
            Caption = 'Middle Name';

            trigger OnValidate()
            begin
                IF (xRec."Middle Name" <> '') AND UsedAsEmployee THEN
                    ERROR(Text007);

                IF ("First Name" <> '') AND ("Middle Name" <> '') THEN
                    Initials := COPYSTR("First Name", 1, 1) + '.' + COPYSTR("Middle Name", 1, 1) + '.';

                VALIDATE("Full Name", GetFullName);

                IF "Middle Name" <> xRec."Middle Name" THEN BEGIN
                    Employee.RESET;
                    Employee.SETCURRENTKEY("Person No.");
                    Employee.SETRANGE("Person No.", "No.");
                    //Employee.MODIFYALL("Middle Name","Middle Name");
                END;
            end;
        }
        field(4; "Last Name"; Text[30])
        {
            Caption = 'Last Name';

            trigger OnValidate()
            begin
                IF (xRec."Last Name" <> '') AND UsedAsEmployee THEN
                    ERROR(Text007);

                VALIDATE("Full Name", GetFullName);

                IF "Last Name" <> xRec."Last Name" THEN BEGIN
                    Employee.RESET;
                    Employee.SETCURRENTKEY("Person No.");
                    Employee.SETRANGE("Person No.", "No.");
                    //Employee.MODIFYALL("Last Name","Last Name");
                END;
            end;
        }
        field(5; Initials; Text[30])
        {
            Caption = 'Initials';

            trigger OnValidate()
            begin
                IF ("Search Name" = UPPERCASE(xRec.Initials)) OR ("Search Name" = '') THEN
                    "Search Name" := COPYSTR(Initials, 1, MAXSTRLEN("Search Name"));
            end;
        }
        field(6; "Full Name"; Text[100])
        {
            Caption = 'Full Name';

            trigger OnValidate()
            begin
                "Search Name" := UPPERCASE(COPYSTR("Full Name", 1, MAXSTRLEN("Search Name")));
            end;
        }
        field(7; "Search Name"; Text[50])
        {
            Caption = 'Search Name';
        }
        field(8; "Last Name Change Date"; Date)
        {
            Caption = 'Last Name Change Date';
            Editable = false;
        }
        field(13; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(14; "Mobile Phone No."; Text[30])
        {
            Caption = 'Mobile Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(15; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;
        }
        field(19; Picture; BLOB)
        {
            Caption = 'Picture';
            SubType = Bitmap;
        }
        field(20; "Birth Date"; Date)
        {
            Caption = 'Birth Date';

            trigger OnValidate()
            begin
                IF "Birth Date" <> xRec."Birth Date" THEN BEGIN
                    Employee.RESET;
                    Employee.SETCURRENTKEY("Person No.");
                    Employee.SETRANGE("Person No.", "No.");
                    //Employee.MODIFYALL("Birth Date","Birth Date");
                END;
            end;
        }
        field(21; "Social Security No."; Text[14])
        {
            Caption = 'Social Security No.';

            trigger OnValidate()
            var
                Pos10: Integer;
                CheckSum: Integer;
            begin
                IF "Social Security No." <> '' THEN BEGIN
                    IF STRLEN("Social Security No.") <> 14 THEN
                        ERROR(Text003, FIELDCAPTION("Social Security No."));
                    IF "Social Security No." <> '000-000-000 00' THEN
                        IF (COPYSTR("Social Security No.", 4, 1) = '-') AND
                           (COPYSTR("Social Security No.", 8, 1) = '-') AND
                           ((COPYSTR("Social Security No.", 12, 1) = ' ') OR (COPYSTR("Social Security No.", 12, 1) = '-')) AND
                           EVALUATE(Pos10, COPYSTR("Social Security No.", 13, 2)) AND
                           (DELCHR(DELCHR(COPYSTR("Social Security No.", 1, 11), '=', '-'), '=', '0987654321') = '')
                        THEN BEGIN
                            CheckSum := ((101 - STRCHECKSUM(DELCHR(COPYSTR("Social Security No.", 1, 11), '=', '-'), '987654321', 101)) MOD 101);
                            IF ((CheckSum = 100) OR (CheckSum = 101)) AND (Pos10 <> 0) THEN
                                ERROR(Text005, FIELDCAPTION("Social Security No."), 0);
                            IF (CheckSum < 100) AND (CheckSum <> Pos10) THEN
                                ERROR(Text005, FIELDCAPTION("Social Security No."), CheckSum);
                        END ELSE
                            ERROR(Text003);
                END;
            end;
        }
        field(22; "VAT Registration No."; Code[20])
        {
            Caption = 'VAT Registration No.';
            CharAllowed = '09';

            trigger OnValidate()
            var
                VATRegNoFormat: Record 381;
            begin
                VATRegNoFormat.Test("VAT Registration No.", '', "No.", DATABASE::Person);
            end;
        }
        field(23; "Tax Inspection Code"; Code[4])
        {
            Caption = 'Tax Inspection Code';
        }
        field(24; Gender; Option)
        {
            Caption = 'Gender';
            OptionCaption = ' ,Female,Male';
            OptionMembers = " ",Female,Male;

            trigger OnValidate()
            begin
                IF Gender <> xRec.Gender THEN BEGIN
                    Employee.RESET;
                    Employee.SETCURRENTKEY("Person No.");
                    Employee.SETRANGE("Person No.", "No.");
                    //Employee.MODIFYALL(Gender,Gender);
                END;
            end;
        }
        field(25; "Single Parent"; Boolean)
        {
            Caption = 'Single Parent';
        }
        field(26; "Family Status"; Code[10])
        {
            Caption = 'Family Status';
            //TableRelation = "Statutory Codes".Code WHERE(Group = CONST(10));
        }
        field(27; Citizenship; Code[10])
        {
            Caption = 'Citizenship';
            //TableRelation = "Statutory Codes".Code WHERE(Group = CONST(02));
        }
        field(28; Nationality; Code[10])
        {
            Caption = 'Nationality';
            //TableRelation = "Statutory Codes".Code WHERE(Group = CONST(03));
        }
        field(29; "Native Language"; Code[10])
        {
            Caption = 'Native Language';
            TableRelation = Language;
        }
        field(30; "Non-Resident"; Boolean)
        {
            Caption = 'Non-Resident';
        }
        field(31; "Identity Document Type"; Code[2])
        {
            Caption = 'Identity Document Type';
        }
        field(32; "Sick Leave Payment Benefit"; Boolean)
        {
            Caption = 'Sick Leave Payment Benefit';
        }
        field(33; "Citizenship Country/Region"; Code[10])
        {
            Caption = 'Citizenship Country/Region';
            TableRelation = "Country/Region";

            trigger OnValidate()
            begin
                IF "Citizenship Country/Region" <> xRec."Citizenship Country/Region" THEN BEGIN
                    Employee.RESET;
                    Employee.SETCURRENTKEY("Person No.");
                    Employee.SETRANGE("Person No.", "No.");
                    //Employee.MODIFYALL("Country/Region Code","Citizenship Country/Region");
                END;
            end;
        }
        field(39; Comment; Boolean)
        {
            Caption = 'Comment';
            Editable = false;
        }
        field(40; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(41; "Birthplace Type"; Option)
        {
            Caption = 'Birthplace Type';
            OptionCaption = 'Standard,Special';
            OptionMembers = Standard,Special;
        }
        field(53; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(80; "Military Status"; Option)
        {
            Caption = 'Military Status';
            OptionCaption = 'Not Liable,Liable,Dismissed';
            OptionMembers = "Not Liable",Liable,Dismissed;
        }
        field(81; "Military Rank"; Code[10])
        {
            Caption = 'Military Rank';
            //TableRelation = "Statutory Codes".Code WHERE(Group = CONST(17));
        }
        field(82; "Military Speciality No."; Text[15])
        {
            Caption = 'Military Speciality No.';
        }
        field(83; "Military Agency"; Text[20])
        {
            Caption = 'Military Agency';
            //TableRelation = "General Directory".Code WHERE(Type = CONST("Military Agency"));
        }
        field(84; "Military Retirement Category"; Option)
        {
            Caption = 'Military Retirement Category';
            OptionCaption = ' ,1,2,3';
            OptionMembers = " ","1","2","3";
        }
        field(85; "Military Structure"; Text[20])
        {
            Caption = 'Military Structure';
            //TableRelation = "General Directory".Code WHERE(Type = CONST(Military Composition));
        }
        field(86; "Military Fitness"; Option)
        {
            Caption = 'Military Fitness';
            OptionCaption = 'A-Valid,B-Valid with insignificant restrictions,V-Valid with restrictions,G-Temporary not valid,D-Not valid';
            OptionMembers = "A-Valid","B-Valid with insignificant restrictions","V-Valid with restrictions","G-Temporary not valid","D-Not valid";
        }
        field(87; "Military Registration No."; Text[15])
        {
            Caption = 'Military Registration No.';
        }
        field(88; "Military Registration Office"; Text[50])
        {
            Caption = 'Military Registration Office';
            // TableRelation = "General Directory".Code WHERE(Type = CONST(Military Office));
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(89; Recruit; Boolean)
        {
            Caption = 'Recruit';
        }
        field(90; Reservist; Boolean)
        {
            Caption = 'Reservist';
        }
        field(91; "Mobilisation Order"; Boolean)
        {
            Caption = 'Mobilisation Order';
        }
        field(92; "Military Dismissal Reason"; Option)
        {
            Caption = 'Military Dismissal Reason';
            OptionCaption = ' ,Age,State of Health';
            OptionMembers = " ",Age,"State of Health";
        }
        field(93; "Military Dismissal Date"; Date)
        {
            Caption = 'Military Dismissal Date';
        }
        field(94; "Militaty Duty Relation"; Code[10])
        {
            Caption = 'Militaty Duty Relation';
            //TableRelation = "Statutory Codes".Code WHERE(Group = CONST(16));
        }
        field(95; "Special Military Register"; Boolean)
        {
            Caption = 'Special Military Register';
        }
        field(100; "First Name (English)"; Text[30])
        {
            Caption = 'First Name (English)';
        }
        field(101; "Middle Name (English)"; Text[30])
        {
            Caption = 'Middle Name (English)';
        }
        field(102; "Last Name (English)"; Text[30])
        {
            Caption = 'Last Name (English)';
        }
        field(103; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';

            trigger OnLookup()
            var
                Vendor: Record 23;
            //VendorList: Page 27;
            begin
                /*
                Vendor.SETCURRENTKEY("Vendor Type");
                Vendor.FILTERGROUP(2);
                Vendor.SETRANGE("Vendor Type",Vendor."Vendor Type"::Person);
                Vendor.FILTERGROUP(0);
                IF "Vendor No." <> '' THEN BEGIN
                  Vendor.GET("Vendor No.");
                  VendorList.SETRECORD(Vendor);
                END;
                VendorList.SETTABLEVIEW(Vendor);
                VendorList.LOOKUPMODE := TRUE;
                IF VendorList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                  VendorList.GETRECORD(Vendor);
                  "Vendor No." := Vendor."No.";
                END;
                */

            end;

            trigger OnValidate()
            begin
                IF ("Vendor No." <> xRec."Vendor No.") AND
                   ("Vendor No." <> '')
                THEN BEGIN
                    Person.RESET;
                    Person.SETRANGE("Vendor No.", "Vendor No.");
                    Person.SETFILTER("No.", '<>%1', "No.");
                    IF Person.FINDFIRST THEN
                        ERROR(Text006, Person."No.", "Vendor No.");
                END;
            end;
        }
        field(110; "Total Service (Days)"; Integer)
        {
            Caption = 'Total Service (Days)';
            MaxValue = 30;
            MinValue = 0;

            trigger OnValidate()
            begin
                CheckJobHistory;
            end;
        }
        field(111; "Total Service (Months)"; Integer)
        {
            Caption = 'Total Service (Months)';
            MaxValue = 11;
            MinValue = 0;

            trigger OnValidate()
            begin
                CheckJobHistory;
            end;
        }
        field(112; "Total Service (Years)"; Integer)
        {
            Caption = 'Total Service (Years)';
            MinValue = 0;

            trigger OnValidate()
            begin
                CheckJobHistory;
            end;
        }
        field(113; "Insured Service (Days)"; Integer)
        {
            Caption = 'Insured Service (Days)';
            MaxValue = 30;
            MinValue = 0;

            trigger OnValidate()
            begin
                CheckJobHistory;
            end;
        }
        field(114; "Insured Service (Months)"; Integer)
        {
            Caption = 'Insured Service (Months)';
            MaxValue = 11;
            MinValue = 0;

            trigger OnValidate()
            begin
                CheckJobHistory;
            end;
        }
        field(115; "Insured Service (Years)"; Integer)
        {
            Caption = 'Insured Service (Years)';
            MinValue = 0;

            trigger OnValidate()
            begin
                CheckJobHistory;
            end;
        }
        field(116; "Unbroken Service (Days)"; Integer)
        {
            Caption = 'Unbroken Service (Days)';
            MaxValue = 30;
            MinValue = 0;

            trigger OnValidate()
            begin
                CheckJobHistory;
            end;
        }
        field(117; "Unbroken Service (Months)"; Integer)
        {
            Caption = 'Unbroken Service (Months)';
            MaxValue = 11;
            MinValue = 0;

            trigger OnValidate()
            begin
                CheckJobHistory;
            end;
        }
        field(118; "Unbroken Service (Years)"; Integer)
        {
            Caption = 'Unbroken Service (Years)';
            MinValue = 0;

            trigger OnValidate()
            begin
                CheckJobHistory;
            end;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "VAT Registration No.")
        {
        }
        key(Key3; "Last Name", "First Name")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Last Name", "First Name", "Middle Name")
        {
        }
    }

    trigger OnDelete()
    begin
        PersonNameHistory.SETRANGE("Person No.", "No.");
        PersonNameHistory.DELETEALL;
    end;

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
            HumanResSetup.GET;
            HumanResSetup.TESTFIELD("Person Nos.");
            NoSeriesMgt.InitSeries(HumanResSetup."Person Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        END;
    end;

    trigger OnModify()
    begin
        /* IF Vendor.READPERMISSION THEN
          PersonVendorUpdate.PersonToVendor(xRec,Rec); */
    end;

    var
        Vendor: Record 23;
        HumanResSetup: Record "Human Resources Setup";
        Person: Record 50112;
        Employee: Record 5200;
        AlternativeAddress: Record 5201;
        PersonMedicalInfo: Record 50113;
        EmployeeRelative: Record 5205;
        PersonNameHistory: Record 50114;
        NoSeriesMgt: Codeunit 396;

        Text003: Label '%1 format must be xxx-xxx-xxx xx.';
        Text005: Label 'Incorrect checksum for %1. Checksum must be %2.';
        Text006: Label 'Person No. %1 is already linked with %2.';
        //PersonVendorUpdate: Codeunit 33055743;
        Text007: Label 'Please use function Change Name to modify person name.';


    procedure AssistEdit(OldPerson: Record 50112): Boolean
    begin
        //Win513++
        //WITH Person DO BEGIN
        //Win513--
        Person := Rec;
        HumanResSetup.GET;
        HumanResSetup.TESTFIELD("Position Nos.");
        IF NoSeriesMgt.SelectSeries(HumanResSetup."Person Nos.", OldPerson."No. Series", "No. Series") THEN BEGIN
            HumanResSetup.GET;
            HumanResSetup.TESTFIELD("Person Nos.");
            NoSeriesMgt.SetSeries("No.");
            Rec := Person;
            EXIT(TRUE);
        END;
        //Win513++
        //END;
        //Win513--
    end;


    procedure GetFullName(): Text[100]
    begin
        EXIT("Last Name" + ' ' + "First Name" + ' ' + "Middle Name");
    end;


    procedure GetFullNameOnDate(CurrDate: Date): Text[100]
    var
        PersonNameHistory: Record 50114;
    begin
        PersonNameHistory.SETRANGE("Person No.", "No.");
        IF PersonNameHistory.ISEMPTY THEN
            EXIT(GetFullName);

        PersonNameHistory.SETFILTER("Start Date", '<=%1', CurrDate);
        PersonNameHistory.FINDLAST;
        EXIT(PersonNameHistory.GetFullName);
    end;


    procedure GetNameInitials(): Text[100]
    begin
        EXIT("Last Name" + ' ' + Initials);
    end;


    procedure GetNameInitialsOnDate(CurrDate: Date): Text[100]
    var
        PersonNameHistory: Record 50114;
    begin
        PersonNameHistory.SETRANGE("Person No.", "No.");
        IF PersonNameHistory.ISEMPTY THEN
            EXIT(GetNameInitials);

        PersonNameHistory.SETFILTER("Start Date", '<=%1', CurrDate);
        PersonNameHistory.FINDLAST;
        EXIT(PersonNameHistory.GetNameInitials);
    end;


    procedure GetEntireAge(BirthDate: Date; CurrDate: Date): Decimal
    var
        BD: array[3] of Integer;
        CD: array[3] of Integer;
        i: Integer;
        EntireAge: Integer;
    begin
        IF CurrDate <= BirthDate THEN
            EXIT(0);
        FOR i := 1 TO 3 DO BEGIN
            BD[i] := DATE2DMY(BirthDate, i);
            CD[i] := DATE2DMY(CurrDate, i);
        END;
        EntireAge := CD[3] - BD[3];
        IF (CD[2] < BD[2]) OR (CD[2] = BD[2]) AND (CD[1] < BD[1]) THEN
            EntireAge -= 1;
        EXIT(EntireAge);
    end;


    procedure GetIdentityDoc(CurrDate: Date; var PersonDoc: Record 50118)
    begin
        TESTFIELD("Identity Document Type");
        PersonDoc.RESET;
        PersonDoc.SETRANGE("Person No.", "No.");
        PersonDoc.SETRANGE("Document Type", "Identity Document Type");
        PersonDoc.SETRANGE("Valid from Date", 0D, CurrDate);
        PersonDoc.SETFILTER("Valid to Date", '%1|%2..', 0D, CurrDate);
        IF NOT PersonDoc.FINDLAST THEN
            CLEAR(PersonDoc);
    end;


    procedure IsChild(CurrentDate: Date): Boolean
    begin
        TESTFIELD("Birth Date");
        EXIT(GetEntireAge("Birth Date", CurrentDate) < 18);
    end;


    procedure IsVeteran(Type: Option Chernobyl,Afganistan,Pensioneer; CurrentDate: Date): Boolean
    begin
        PersonMedicalInfo.SETRANGE("Person No.", "No.");
        PersonMedicalInfo.SETRANGE("Starting Date", 0D, CurrentDate);
        PersonMedicalInfo.SETFILTER("Ending Date", '%1|%2..', 0D, CALCDATE('<1D>', CurrentDate));
        CASE Type OF
            Type::Chernobyl:
                PersonMedicalInfo.SETRANGE(Privilege, PersonMedicalInfo.Privilege::"Chernobyl Veteran");
            Type::Afganistan:
                PersonMedicalInfo.SETRANGE(Privilege, PersonMedicalInfo.Privilege::"Afghanistan Veteran");
            Type::Pensioneer:
                PersonMedicalInfo.SETRANGE(Privilege, PersonMedicalInfo.Privilege::Pensioner);
        END;
        EXIT(NOT PersonMedicalInfo.ISEMPTY);
    end;


    procedure IsDisabled(CurrentDate: Date): Boolean
    begin
        PersonMedicalInfo.SETRANGE("Person No.", "No.");
        PersonMedicalInfo.SETRANGE("Starting Date", 0D, CurrentDate);
        PersonMedicalInfo.SETFILTER("Ending Date", '%1|%2..', 0D, CALCDATE('<1D>', CurrentDate));
        PersonMedicalInfo.SETFILTER("Disability Group", '<>%1', 0);
        EXIT(NOT PersonMedicalInfo.ISEMPTY);
    end;


    procedure GetDisabilityGroup(CurrentDate: Date): Integer
    begin
        PersonMedicalInfo.SETRANGE("Person No.", "No.");
        PersonMedicalInfo.SETRANGE("Starting Date", 0D, CurrentDate);
        PersonMedicalInfo.SETFILTER("Ending Date", '%1|%2..', 0D, CALCDATE('<1D>', CurrentDate));
        PersonMedicalInfo.SETFILTER("Disability Group", '<>%1', 0);
        IF PersonMedicalInfo.FINDFIRST THEN
            EXIT(PersonMedicalInfo."Disability Group");

        EXIT(0);
    end;

    /*  [Scope('Internal')]
     procedure ChildrenNumber(CurrentDate: Date) Kids: Integer
     var
         Relative: Record "5204";
     begin
         Kids := 0;
         EmployeeRelative.RESET;
         EmployeeRelative.SETRANGE("Employee No.", "No.");
         IF EmployeeRelative.FINDSET THEN
             REPEAT
                 Relative.GET(EmployeeRelative."Relative Code");
                 IF (Relative."Relative Type" = Relative."Relative Type"::Child) AND
                    (GetEntireAge(EmployeeRelative."Birth Date", CurrentDate) < 18)
                 THEN
                     Kids := Kids + 1;
             UNTIL EmployeeRelative.NEXT = 0;
         EXIT(Kids);
     end; */


    procedure UsedAsEmployee(): Boolean
    begin
        Employee.RESET;
        Employee.SETCURRENTKEY("Person No.");
        Employee.SETRANGE("Person No.", "No.");
        EXIT(NOT Employee.ISEMPTY);
    end;

    /* [Scope('Internal')]
    procedure GetBirthPlace() BirthPlace: Text[50]
    begin
        AlternativeAddress.RESET;
        AlternativeAddress.SETRANGE("Employee No.", "No.");
        AlternativeAddress.SETRANGE("Address Type", AlternativeAddress."Address Type"::Birthplace);
        IF AlternativeAddress.FINDFIRST THEN
            BirthPlace := AlternativeAddress.City;
    end; */


    procedure CheckJobHistory()
    var
        PersonJobHistory: Record 50117;
    begin
        PersonJobHistory.SETRANGE("Person No.", "No.");
        IF NOT PersonJobHistory.ISEMPTY THEN
            CASE CurrFieldNo OF
                FIELDNO("Total Service (Days)"):
                    FIELDERROR("Total Service (Days)");
                FIELDNO("Total Service (Months)"):
                    FIELDERROR("Total Service (Months)");
                FIELDNO("Total Service (Years)"):
                    FIELDERROR("Total Service (Years)");
                FIELDNO("Insured Service (Days)"):
                    FIELDERROR("Insured Service (Days)");
                FIELDNO("Insured Service (Months)"):
                    FIELDERROR("Insured Service (Months)");
                FIELDNO("Insured Service (Years)"):
                    FIELDERROR("Insured Service (Years)");
                FIELDNO("Unbroken Service (Days)"):
                    FIELDERROR("Unbroken Service (Days)");
                FIELDNO("Unbroken Service (Months)"):
                    FIELDERROR("Unbroken Service (Months)");
                FIELDNO("Unbroken Service (Years)"):
                    FIELDERROR("Unbroken Service (Years)");
            END;
    end;
}

