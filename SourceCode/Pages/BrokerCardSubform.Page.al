page 50007 "Broker Card Subform"
{
    Caption = 'Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = 5089;
    SourceTableView = SORTING("Contact No.", "Answer Priority", "Profile Questionnaire Priority")
                      ORDER(Descending)
                      WHERE("Answer Priority" = FILTER(<> 'Very Low (Hidden)'));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Answer Priority"; Rec."Answer Priority")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the priority of the profile answer. There are five options:';
                    Visible = false;
                }
                field("Profile Questionnaire Priority"; Rec."Profile Questionnaire Priority")
                {
                    ToolTip = 'Specifies the priority of the questionnaire that the profile answer is linked to. There are five options: Very Low, Low, Normal, High, and Very High.';
                    Visible = false;
                    ApplicationArea = all;
                }
                field(Question; Rec.Question)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Question';
                    ToolTip = 'Specifies the question in the profile questionnaire.';
                }
                field(Answer; Rec.Answer)
                {
                    ApplicationArea = RelationshipMgmt;
                    DrillDown = false;
                    ToolTip = 'Specifies your contact''s answer to the question.';

                    trigger OnAssistEdit()
                    var
                        ContactProfileAnswer: Record 5089;
                        Rating: Record 5111;
                        RatingTemp: Record 5111 temporary;
                        ProfileQuestionnaireLine: Record 5088;
                        Contact: Record 5050;
                        ProfileManagement: Codeunit 5059;
                    begin
                        ProfileQuestionnaireLine.GET(Rec."Profile Questionnaire Code", Rec."Line No.");
                        ProfileQuestionnaireLine.GET(Rec."Profile Questionnaire Code", ProfileQuestionnaireLine.FindQuestionLine);
                        IF ProfileQuestionnaireLine."Auto Contact Classification" THEN BEGIN
                            IF ProfileQuestionnaireLine."Contact Class. Field" = ProfileQuestionnaireLine."Contact Class. Field"::Rating THEN BEGIN
                                Rating.SETRANGE("Profile Questionnaire Code", Rec."Profile Questionnaire Code");
                                Rating.SETRANGE("Profile Questionnaire Line No.", ProfileQuestionnaireLine."Line No.");
                                IF Rating.FIND('-') THEN
                                    REPEAT
                                        IF ContactProfileAnswer.GET(
                                             Rec."Contact No.", Rating."Rating Profile Quest. Code", Rating."Rating Profile Quest. Line No.")
                                        THEN BEGIN
                                            RatingTemp := Rating;
                                            RatingTemp.INSERT;
                                        END;
                                    UNTIL Rating.NEXT = 0;

                                IF NOT RatingTemp.ISEMPTY THEN
                                    PAGE.RUNMODAL(PAGE::"Answer Points List", RatingTemp)
                                ELSE
                                    MESSAGE(Text001);
                            END ELSE
                                MESSAGE(Text002, Rec."Last Date Updated");
                        END ELSE BEGIN
                            Contact.GET(Rec."Contact No.");
                            ProfileManagement.ShowContactQuestionnaireCard(Contact, Rec."Profile Questionnaire Code", Rec."Line No.");
                            CurrPage.UPDATE(FALSE);
                        END;
                    end;
                }
                field("Questions Answered (%)"; Rec."Questions Answered (%)")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the number of questions in percentage of total questions that have scored points based on the question you used for your rating.';
                }
                field("Last Date Updated"; Rec."Last Date Updated")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the date when the contact profile answer was last updated. This field shows the first date when the questions used to rate this contact has been given points.';
                }
            }
        }
    }

    actions
    {
    }

    var
        Text001: Label 'There are no answer values for this rating answer.';
        Text002: Label 'This answer reflects the state of the contact on %1 when the Update Contact Class. batch job was run.\To make the answer reflect the current state of the contact, run the batch job again.';
}

