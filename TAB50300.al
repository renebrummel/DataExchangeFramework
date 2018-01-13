tableextension 50300 IntermDataImportExt extends "Intermediate Data Import"
{
    fields
    {
    }
    
    trigger OnAfterInsert();
    begin
        AddItemCostAndUOM;
    end;
    local procedure AddItemCostAndUOM();
    var
        Item : Record Item;
        UnitOfMeasure : Record "Unit of Measure";
    begin
        if "Table ID" <> Database::"Purchase Line" then
            exit;
        if "Field ID" <> 6 then
            exit;

        Item.SetRange(GTIN,Value);
        if NOT Item.FindFirst then
            exit;

        if FieldNotInMapping("Data Exch. No.",Database::"Purchase Line",22) then
            InsertOrUpdateEntry("Data Exch. No.",Database::"Purchase Line",22,"Parent Record No.","Record No.",Format(Item."Unit Cost",0,9));

        if FieldNotInMapping("Data Exch. No.",Database::"Purchase Line",5407) then begin
            UnitOfMeasure.Get(Item."Purch. Unit of Measure");
            UnitOfMeasure.TestField("International Standard Code");
            InsertOrUpdateEntry("Data Exch. No.",Database::"Purchase Line",5407,"Parent Record No.","Record No.",UnitOfMeasure."International Standard Code");
        end;
    end;

    local procedure FieldNotInMapping(DataExchNo : Integer;TableID : integer ; FieldID : Integer) : Boolean;
    var
        DataExch : Record "Data Exch.";
        DataExchFieldMapping : Record "Data Exch. Field Mapping";
    begin
        with DataExchFieldMapping do begin
            DataExch.Get(DataExchNo);
            SetRange("Data Exch. Def Code",DataExch."Data Exch. Def Code");
            SetRange("Target Table ID",TableID);
            SetRange("Target Field ID",FieldID);
            exit(IsEmpty);
        end;
    end;
    var
        myInt : Integer;
}