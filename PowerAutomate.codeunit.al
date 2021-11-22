codeunit 50100 PowerAutomate
{
    procedure CallService(RequestBodyJson: JsonObject; RequestUrl: Text) ResponseBody: JsonObject
    var
        Client: HttpClient;
        RequestHeaders: HttpHeaders;
        RequestContent: HttpContent;
        ResponseMessage: HttpResponseMessage;
        RequestMessage: HttpRequestMessage;
        ResponseText: Text;
        contentHeaders: HttpHeaders;
        Body: Text;
        JsonResponse: JsonObject;
        JsonToken: JsonToken;
    begin
        RequestHeaders := Client.DefaultRequestHeaders();
        RequestBodyJson.WriteTo(Body);
        RequestContent.WriteFrom(Body);
        RequestContent.GetHeaders(contentHeaders);
        contentHeaders.Clear();
        contentHeaders.Add('Content-Type', 'application/json');
        Client.Post(RequestURL, RequestContent, ResponseMessage);
        if ResponseMessage.IsSuccessStatusCode then begin
            ResponseMessage.Content().ReadAs(ResponseText);
            JsonResponse.ReadFrom(ResponseText);
            exit(JsonResponse);
        end;
    end;

    procedure RecToJson(RecRef: RecordRef) RecJson: JsonObject
    var
        FieldRef: FieldRef;
        Field: Record Field;
        pDecimal: Decimal;
        pText: Text;
        pDate: Date;
        pInteger: Integer;
    begin
        Clear(RecJson);
        Field.SetRange(TableNo, RecRef.Number);
        Field.SetRange(Class, Field.Class::Normal);
        Field.SetRange(Enabled, true);
        Field.SetFilter(ObsoleteState, '%1|%2', Field.ObsoleteState::No, Field.ObsoleteState::Pending);
        if Field.FindSet() then
            repeat
                FieldRef := RecRef.Field(Field."No.");
                if Field.Class = Field.Class::FlowField then
                    FieldRef.CalcField();
                //Obviously incomplete
                case Field.Type of
                    Field.Type::Decimal:
                        begin
                            pDecimal := FieldRef.Value;
                            RecJson.Add(Field.FieldName, pDecimal);
                        end;
                    Field.Type::Integer:
                        begin
                            pInteger := FieldRef.Value;
                            RecJson.Add(Field.FieldName, pInteger);
                        end;
                    Field.Type::Text, Field.Type::Code:
                        begin
                            pText := FieldRef.Value;
                            RecJson.Add(Field.FieldName, pText);
                        end;
                    Field.Type::Date:
                        begin
                            pDate := FieldRef.Value;
                            RecJson.Add(Field.FieldName, pDate);
                        end;
                    else begin
                            begin
                                RecJson.Add(Field.FieldName, Format(FieldRef.Value));
                            end;
                        end;
                end;
            until Field.Next() = 0;
    end;


}