table 50100 "Power Automate"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Type"; option)
        {
            OptionMembers = "Job Card","Service Order";
            DataClassification = ToBeClassified;
        }
        field(2; "Reqeust Url"; text[2048])
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(Key1; Type)
        {
            Clustered = true;
        }
    }

}