PageExtension 50277 pageextension50277 extends "Service Order Subform" 
{
    actions
    {

        //Unsupported feature: Code Modification on ""Service Item Worksheet"(Action 1900545504).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            ShowServOrderWorksheet;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            //WIN315++
            ServHdr.RESET;
            ServHdr.SETRANGE(ServHdr."No.",Rec."Document No.");
            IF ServHdr.FINDFIRST THEN BEGIN
              ServHdr.TESTFIELD("Location Code");
              ServHdr.TESTFIELD("Customer No.");
            END;
            //WIN315--
            ShowServOrderWorksheet;
            */
        //end;


        //Unsupported feature: Code Modification on ""Service Lines"(Action 1901652204).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            RegisterServInvLines;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            //WIN315++
            ServHdr.RESET;
            ServHdr.SETRANGE(ServHdr."No.",Rec."Document No.");
            IF ServHdr.FINDFIRST THEN BEGIN
              ServHdr.TESTFIELD("Location Code");
              ServHdr.TESTFIELD("Customer No.");
            END;
            //WIN315--
            RegisterServInvLines;
            */
        //end;
    }

    var
        ServHdr: Record "Service Header";
}

