tableextension 50011 tableextension50011 extends "Purchase Line"
{
    local procedure "--"()
    begin
    end;


    var
        CommentLbl: Label 'Comment';
        CannotBeNegativeErr: Label 'The %1 field cannot be negative on the purchase line.', Comment = '%1 - Field Caption';
}

