pageextension 50100 JobCardExt extends "Job Card"
{

    actions
    {
        addbefore(Creating)
        {
            action("PowerAutomate")
            {
                Caption = 'Start Power Automate';
                Image = Flow;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    PowerAutomate: codeunit PowerAutomate;
                    JobRecRef: RecordRef;
                    JsonResponse: JsonObject;
                    JToken: JsonToken;
                    RequestUrl: Text;
                begin
                    JobRecRef.Open(Database::"Job");
                    JobRecRef.GetTable(Rec);
                    RequestUrl := 'https://prod-102.westeurope.logic.azure.com:443/workflows/70d96c7d5d094b27a127b5c9f0eecbfe/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=62uBTWdmAc758BrkxYl-L6yb2wokMFeo7WZ4VIHwO4E';
                    JsonResponse := PowerAutomate.CallService(PowerAutomate.RecToJson(JobRecRef), RequestUrl);
                    if JsonResponse.Get('message', JToken) then
                        message(JToken.AsValue().AsText());
                end;
            }
        }
    }
}