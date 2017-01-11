unit TestCouchbase;

interface

uses
  TestFramework,
  SysUtils,
  IOUtils,
  Couchbase.API,
  Couchbase;

const
  { Connect string for your Couchbase Server instance }
  CONNECT_STRING = 'couchbase://192.168.1.84';

type
  TestTgoCouchbase = class(TTestCase)
  strict private
    class var FCouchbase: TgoCouchbase;
    class var FExampleJson: String;
    class destructor Destroy;
  public
    class constructor Create;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestConnect;

    { Json }
    procedure TestUpsertJson;
    procedure TestGetJson;
    procedure TestAddJson;
    procedure TestReplaceJson;
    procedure TestDeleteJson;

    { Raw Data }
    procedure TestUpsertData;
    procedure TestIncrData;
    procedure TestDecrData;
    procedure TestAppendData;
    procedure TestPrependData;

    { Other }
    procedure TestExpires;
    procedure TestTouch;
    procedure TestStats;

    { N1QL }
    procedure TestQuery;
  end;

  TestTgoCouchbaseSubDoc = class(TTestCase)
  strict private
    class var FCouchbase: TgoCouchbase;
    class var FExampleJson: String;
    class destructor Destroy;
  public
    class constructor Create;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    { LookupIn }
    procedure TestConnect;
    procedure TestSimpleGet;
    procedure TestGet2;
    procedure TestGetArray;
    procedure TestGetArrayElement;
    procedure TestGetArrayElementValue;
    procedure TestExists;
    procedure TestGetCount;

    { MutateIn }
    procedure TestUpsert;
    procedure TestInsert;
    procedure TestReplace;
    procedure TestRemove;
    procedure TestArrayAppend;
    procedure TestArrayPrepend;
    procedure TestArrayAddUnique;
    procedure TestArrayInsert;
    procedure TestCounter;
  end;

implementation

uses
  DateUtils;

class constructor TestTgoCouchbase.Create;
begin
  FCouchbase := TgoCouchbase.Create;
  FExampleJson := TFile.ReadAllText('example.json');
end;

class destructor TestTgoCouchbase.Destroy;
begin
  FCouchbase.Free;
end;

procedure TestTgoCouchbase.SetUp;
begin
  inherited;
end;

procedure TestTgoCouchbase.TearDown;
begin
  inherited;
end;

procedure TestTgoCouchbase.TestConnect;
var
  ReturnValue: Boolean;
begin
  ReturnValue := FCouchbase.Connect(CONNECT_STRING);
  CheckTrue(ReturnValue);
  CheckEquals(0, FCouchbase.LastErrorCode);
end;

procedure TestTgoCouchbase.TestUpsertJson;
var
  CBResult: TCouchbaseResult;
begin
  CBResult := FCouchbase.Upsert('Test', FExampleJson);
  CheckTrue(CBResult.Success);
end;

procedure TestTgoCouchbase.TestGetJson;
var
  CBResult: TCouchbaseResult;
  AValue: String;
begin
  CBResult := FCouchbase.Upsert('Test', FExampleJson);
  CheckTrue(CBResult.Success);
  CBResult := FCouchbase.Get('Test', AValue);
  CheckTrue(CBResult.Success);
  CheckEquals(Ord(TCouchbaseFormat.JSON), Ord(CBResult.Format));
  CheckEquals(FExampleJson, AValue);
end;

procedure TestTgoCouchbase.TestAddJson;
var
  CBResult: TCouchbaseResult;
  AValue: String;
  RandomKey: Utf8String;
begin
  RandomKey := Utf8Encode(TGuid.NewGuid.ToString);
  CBResult := FCouchbase.Add(RandomKey, FExampleJson);
  CheckTrue(CBResult.Success);
  CBResult := FCouchbase.Get(RandomKey, AValue);
  CheckTrue(CBResult.Success);
  CheckEquals(Ord(TCouchbaseFormat.JSON), Ord(CBResult.Format));
  CheckEquals(FExampleJson, AValue);
  CBResult := FCouchbase.Add(RandomKey, FExampleJson); { attempt again }
  CheckFalse(CBResult.Success);
  CheckEquals(LCB_KEY_EEXISTS, CBResult.Error);
end;

procedure TestTgoCouchbase.TestReplaceJson;
var
  CBResult: TCouchbaseResult;
  AValue: String;
begin
  CBResult := FCouchbase.Replace('Test', '{ "hello" : "world" }');
  CheckTrue(CBResult.Success);
  CBResult := FCouchbase.Get('Test', AValue);
  CheckTrue(CBResult.Success);
  CheckEquals(Ord(TCouchbaseFormat.JSON), Ord(CBResult.Format));
  CheckEquals('{ "hello" : "world" }', AValue);
  CBResult := FCouchbase.Upsert('Test', FExampleJson);
  CheckTrue(CBResult.Success);
  CBResult := FCouchbase.Get('Test', AValue);
  CheckTrue(CBResult.Success);
  CheckEquals(Ord(TCouchbaseFormat.JSON), Ord(CBResult.Format));
  CheckEquals(FExampleJson, AValue);
end;

procedure TestTgoCouchbase.TestDeleteJson;
var
  CBResult: TCouchbaseResult;
  AValue: String;
begin
  CBResult := FCouchbase.Delete('Test');
  CheckTrue(CBResult.Success);
  CBResult := FCouchbase.Get('Test', AValue);
  CheckFalse(CBResult.Success);
  CBResult := FCouchbase.Upsert('Test', FExampleJson);
  CheckTrue(CBResult.Success);
end;

procedure TestTgoCouchbase.TestUpsertData;
var
  CBResult: TCouchbaseResult;
  CBOptions: TCouchbaseOptions;
  AValue: String;
begin
  CBOptions.Initialize;
  CBOptions.Format := TCouchbaseFormat.RAW;
  CBResult := FCouchbase.Upsert('Value', '1', CBOptions);
  CheckTrue(CBResult.Success);
  CBResult := FCouchbase.Get('Value', AValue);
  CheckTrue(CBResult.Success);
  CheckEquals(Ord(TCouchbaseFormat.RAW), Ord(CBResult.Format));
  CheckEquals('1', AValue);
end;

procedure TestTgoCouchbase.TestIncrData;
var
  CBResult: TCouchbaseResult;
  CBOptions: TCouchbaseOptions;
  AValue: String;
begin
  CBOptions.Initialize;
  CBOptions.Format := TCouchbaseFormat.RAW;
  CBResult := FCouchbase.Upsert('Value', '1', CBOptions);
  CheckTrue(CBResult.Success);
  CBResult := FCouchbase.Incr('Value');
  CheckTrue(CBResult.Success);
  CBResult := FCouchbase.Get('Value', AValue);
  CheckTrue(CBResult.Success);
  CheckEquals('2', AValue);
end;

procedure TestTgoCouchbase.TestDecrData;
var
  CBResult: TCouchbaseResult;
  CBOptions: TCouchbaseOptions;
  AValue: String;
begin
  CBOptions.Initialize;
  CBOptions.Format := TCouchbaseFormat.RAW;
  CBResult := FCouchbase.Upsert('Value', '2', CBOptions);
  CheckTrue(CBResult.Success);
  CBResult := FCouchbase.Decr('Value');
  CheckTrue(CBResult.Success);
  CBResult := FCouchbase.Get('Value', AValue);
  CheckTrue(CBResult.Success);
  CheckEquals('1', AValue);
end;

procedure TestTgoCouchbase.TestAppendData;
var
  CBResult: TCouchbaseResult;
  CBOptions: TCouchbaseOptions;
  AValue: String;
begin
  CBOptions.Initialize;
  CBOptions.Format := TCouchbaseFormat.RAW;
  CBResult := FCouchbase.Upsert('Value', '1', CBOptions);
  CheckTrue(CBResult.Success);
  CBResult := FCouchbase.Append('Value', 'DEF');
  CheckTrue(CBResult.Success);
  CBResult := FCouchbase.Get('Value', AValue);
  CheckTrue(CBResult.Success);
  CheckEquals('1DEF', AValue);
end;

procedure TestTgoCouchbase.TestPrependData;
var
  CBResult: TCouchbaseResult;
  CBOptions: TCouchbaseOptions;
  AValue: String;
begin
  CBOptions.Initialize;
  CBOptions.Format := TCouchbaseFormat.RAW;
  CBResult := FCouchbase.Upsert('Value', '1', CBOptions);
  CheckTrue(CBResult.Success);
  CBResult := FCouchbase.Prepend('Value', 'ABC');
  CheckTrue(CBResult.Success);
  CBResult := FCouchbase.Get('Value', AValue);
  CheckTrue(CBResult.Success);
  CheckEquals('ABC1', AValue);
end;

procedure TestTgoCouchbase.TestExpires;
var
  CBResult: TCouchbaseResult;
  CBOptions: TCouchbaseOptions;
  AValue: String;
begin
  CBOptions.Initialize;
  CBOptions.ExpireTime := 1;
  CBResult := FCouchbase.Upsert('Expires', FExampleJson, CBOptions);
  CheckTrue(CBResult.Success);
  CBResult := FCouchbase.Get('Expires', AValue);
  CheckTrue(CBResult.Success);
  Sleep(2000);
  CBResult := FCouchbase.Get('Expires', AValue);
  CheckFalse(CBResult.Success);
  CheckEquals(LCB_KEY_ENOENT, CBResult.Error);
end;

procedure TestTgoCouchbase.TestTouch;
var
  CBResult: TCouchbaseResult;
  CBOptions: TCouchbaseOptions;
  AValue: String;
  Start: TDateTime;
begin
  CBOptions.Initialize;
  CBOptions.ExpireTime := 3;
  CBResult := FCouchbase.Upsert('Expires', FExampleJson, CBOptions);
  CheckTrue(CBResult.Success);
  CBResult := FCouchbase.Get('Expires', AValue);
  CheckTrue(CBResult.Success);
  Start := Now;
  while SecondsBetween(Now, Start) < 5 do
  begin
    CBResult := FCouchbase.Touch('Expires', 3); { keep alive }
    CheckTrue(CBResult.Success);
    Sleep(1000);
  end;
  Sleep(4000);
  CBResult := FCouchbase.Get('Expires', AValue);
  CheckFalse(CBResult.Success);
  CheckEquals(LCB_KEY_ENOENT, CBResult.Error);
end;

procedure TestTgoCouchbase.TestStats;
var
  CBStatsResult: TCouchbaseStatsResult;
begin
  CBStatsResult := FCouchbase.Stats;
  try
    CheckTrue(CBStatsResult.Success);
    CheckTrue(CBStatsResult.Stats.ContainsKey('ep_alog_path'));
  finally
    CBStatsResult.Finalize;
  end;
end;

procedure TestTgoCouchbase.TestQuery;
var
  CBQueryResult: TCouchbaseQueryResult;
  CBQuery: TgoCouchbaseN1QL;
  CBResult: TCouchbaseResult;
begin
  CBResult := FCouchbase.Upsert('Test', FExampleJson);
  CheckTrue(CBResult.Success);
  CBQuery := TgoCouchbaseN1QL.Create;
  CBQuery.SetStatement('SELECT * FROM default USE KEYS ''Test''');
  CBQueryResult := FCouchbase.Query(CBQuery);
  CheckTrue(CBQueryResult.Success);
  CheckEquals(1, CBQueryResult.Metrics.ResultCount);
  CheckEquals(TFile.ReadAllText('query.json'), CBQueryResult.Rows[0]);
  CBQueryResult.Finalize;
  CBQuery.Free;
end;

{ TestTCouchbaseSubDoc }

class constructor TestTgoCouchbaseSubDoc.Create;
begin
  FCouchbase := TgoCouchbase.Create;
  FExampleJson := TFile.ReadAllText('example.json');
end;

class destructor TestTgoCouchbaseSubDoc.Destroy;
begin
  FCouchbase.Free;
end;

procedure TestTgoCouchbaseSubDoc.SetUp;
begin
  inherited;
end;

procedure TestTgoCouchbaseSubDoc.TearDown;
begin
  inherited;
end;

procedure TestTgoCouchbaseSubDoc.TestConnect;
var
  ReturnValue: Boolean;
begin
  ReturnValue := FCouchbase.Connect(CONNECT_STRING);
  CheckTrue(ReturnValue);
  CheckEquals(0, FCouchbase.LastErrorCode);
end;

procedure TestTgoCouchbaseSubDoc.TestSimpleGet;
var
  CBResult: TCouchbaseResult;
  CBSubDocResult: TCouchbaseSubDocResult;
begin
  CBResult := FCouchbase.Upsert('Test', FExampleJson);
  CheckTrue(CBResult.Success);

  CBSubDocResult := FCouchbase.LookupIn('Test').Get('type').Execute;
  CheckTrue(CBSubDocResult.Success);
  CheckEquals(1, Length(CBSubDocResult.Responses));
  CheckEquals('"donut"', CBSubDocResult.Responses[0].Value);
end;

procedure TestTgoCouchbaseSubDoc.TestGet2;
var
  CBResult: TCouchbaseResult;
  CBSubDocResult: TCouchbaseSubDocResult;
begin
  CBResult := FCouchbase.Upsert('Test', FExampleJson);
  CheckTrue(CBResult.Success);

  CBSubDocResult := FCouchbase.LookupIn('Test').Get('type').Get('name').Execute;
  CheckTrue(CBSubDocResult.Success);
  CheckEquals(2, Length(CBSubDocResult.Responses));
  CheckEquals('"donut"', CBSubDocResult.Responses[0].Value);
  CheckEquals('"Cake"', CBSubDocResult.Responses[1].Value);
end;

procedure TestTgoCouchbaseSubDoc.TestGetArray;
var
  CBResult: TCouchbaseResult;
  CBSubDocResult: TCouchbaseSubDocResult;
begin
  CBResult := FCouchbase.Upsert('Test', FExampleJson);
  CheckTrue(CBResult.Success);

  CBSubDocResult := FCouchbase.LookupIn('Test').Get('batters').Execute;
  CheckTrue(CBSubDocResult.Success);
  CheckEquals(1, Length(CBSubDocResult.Responses));
  CheckEquals('{"batter":[{ "id": "1001", "type": "Regular" },{ "id": "1002", "type": "Chocolate" },{ "id": "1003", "type": "Blueberry" },{ "id": "1004", "type": "Devil''s Food" }]}', CBSubDocResult.Responses[0].Value);
end;

procedure TestTgoCouchbaseSubDoc.TestGetArrayElement;
var
  CBResult: TCouchbaseResult;
  CBSubDocResult: TCouchbaseSubDocResult;
begin
  CBResult := FCouchbase.Upsert('Test', FExampleJson);
  CheckTrue(CBResult.Success);

  CBSubDocResult := FCouchbase.LookupIn('Test').Get('batters.batter[0]').Execute;
  CheckTrue(CBSubDocResult.Success);
  CheckEquals(1, Length(CBSubDocResult.Responses));
  CheckEquals('{ "id": "1001", "type": "Regular" }', CBSubDocResult.Responses[0].Value);
end;

procedure TestTgoCouchbaseSubDoc.TestGetArrayElementValue;
var
  CBResult: TCouchbaseResult;
  CBSubDocResult: TCouchbaseSubDocResult;
begin
  CBResult := FCouchbase.Upsert('Test', FExampleJson);
  CheckTrue(CBResult.Success);

  CBSubDocResult := FCouchbase.LookupIn('Test').Get('batters.batter[0].id').Execute;
  CheckTrue(CBSubDocResult.Success);
  CheckEquals(1, Length(CBSubDocResult.Responses));
  CheckEquals('"1001"', CBSubDocResult.Responses[0].Value);
end;

procedure TestTgoCouchbaseSubDoc.TestExists;
var
  CBResult: TCouchbaseResult;
  CBSubDocResult: TCouchbaseSubDocResult;
begin
  CBResult := FCouchbase.Upsert('Test', FExampleJson);
  CheckTrue(CBResult.Success);

  CBSubDocResult := FCouchbase.LookupIn('Test').Exists('number').Execute;
  CheckTrue(CBSubDocResult.Success);
  CheckEquals(1, Length(CBSubDocResult.Responses));
  CheckEquals(LCB_SUCCESS, CBSubDocResult.Responses[0].Status);

  CBSubDocResult := FCouchbase.LookupIn('Test').Exists('something').Execute;
  CheckFalse(CBSubDocResult.Success);
  CheckEquals(LCB_SUBDOC_MULTI_FAILURE, CBSubDocResult.Error);
  CheckEquals(1, Length(CBSubDocResult.Responses));
  CheckEquals(LCB_SUBDOC_PATH_ENOENT, CBSubDocResult.Responses[0].Status);
end;

procedure TestTgoCouchbaseSubDoc.TestGetCount;
var
  CBResult: TCouchbaseResult;
  CBSubDocResult: TCouchbaseSubDocResult;
begin
  CBResult := FCouchbase.Upsert('Test', FExampleJson);
  CheckTrue(CBResult.Success);

  CBSubDocResult := FCouchbase.LookupIn('Test').GetCount('batters.batter').Execute; // this API does not work?
  CheckTrue(CBSubDocResult.Success);
  CheckEquals(1, Length(CBSubDocResult.Responses));
end;

procedure TestTgoCouchbaseSubDoc.TestUpsert;
var
  CBResult: TCouchbaseResult;
  CBSubDocResult: TCouchbaseSubDocResult;
begin
  CBResult := FCouchbase.Upsert('Test', FExampleJson);
  CheckTrue(CBResult.Success);

  CBSubDocResult := FCouchbase.MutateIn('Test').Upsert('frosting', '"pink"').Execute;
  CheckTrue(CBSubDocResult.Success);
  CheckEquals(1, Length(CBSubDocResult.Responses));

  CBSubDocResult := FCouchbase.LookupIn('Test').Get('frosting').Execute;
  CheckTrue(CBSubDocResult.Success);
  CheckEquals(1, Length(CBSubDocResult.Responses));
  CheckEquals('"pink"', CBSubDocResult.Responses[0].Value);
end;

procedure TestTgoCouchbaseSubDoc.TestInsert;
var
  CBResult: TCouchbaseResult;
  CBSubDocResult: TCouchbaseSubDocResult;
begin
  CBResult := FCouchbase.Upsert('Test', FExampleJson);
  CheckTrue(CBResult.Success);

  CBSubDocResult := FCouchbase.MutateIn('Test').Insert('frosting', '"pink"').Execute;
  CheckTrue(CBSubDocResult.Success);
  CheckEquals(1, Length(CBSubDocResult.Responses));

  CBSubDocResult := FCouchbase.LookupIn('Test').Get('frosting').Execute;
  CheckTrue(CBSubDocResult.Success);
  CheckEquals(1, Length(CBSubDocResult.Responses));
  CheckEquals('"pink"', CBSubDocResult.Responses[0].Value);

  { insert again }
  CBSubDocResult := FCouchbase.MutateIn('Test').Insert('frosting', '"pink"').Execute;
  CheckFalse(CBSubDocResult.Success);
  CheckEquals(1, Length(CBSubDocResult.Responses));
  CheckEquals(LCB_SUBDOC_PATH_EEXISTS, CBSubDocResult.Responses[0].Status);
end;

procedure TestTgoCouchbaseSubDoc.TestReplace;
var
  CBResult: TCouchbaseResult;
  CBSubDocResult: TCouchbaseSubDocResult;
begin
  CBResult := FCouchbase.Upsert('Test', FExampleJson);
  CheckTrue(CBResult.Success);

  CBSubDocResult := FCouchbase.MutateIn('Test').Replace('type', '"yummy"').Execute;
  CheckTrue(CBSubDocResult.Success);
  CheckEquals(1, Length(CBSubDocResult.Responses));

  CBSubDocResult := FCouchbase.LookupIn('Test').Get('type').Execute;
  CheckTrue(CBSubDocResult.Success);
  CheckEquals(1, Length(CBSubDocResult.Responses));
  CheckEquals('"yummy"', CBSubDocResult.Responses[0].Value);
end;

procedure TestTgoCouchbaseSubDoc.TestRemove;
var
  CBResult: TCouchbaseResult;
  CBSubDocResult: TCouchbaseSubDocResult;
begin
  CBResult := FCouchbase.Upsert('Test', FExampleJson);
  CheckTrue(CBResult.Success);

  CBSubDocResult := FCouchbase.MutateIn('Test').Remove('type').Execute;
  CheckTrue(CBSubDocResult.Success);
  CheckEquals(1, Length(CBSubDocResult.Responses));

  CBSubDocResult := FCouchbase.LookupIn('Test').Get('type').Execute;
  CheckFalse(CBSubDocResult.Success);
  CheckEquals(1, Length(CBSubDocResult.Responses));
  CheckEquals(LCB_SUBDOC_PATH_ENOENT, CBSubDocResult.Responses[0].Status);
end;

procedure TestTgoCouchbaseSubDoc.TestArrayAppend;
var
  CBResult: TCouchbaseResult;
  CBSubDocResult: TCouchbaseSubDocResult;
begin
  CBResult := FCouchbase.Upsert('Test', FExampleJson);
  CheckTrue(CBResult.Success);

  CBSubDocResult := FCouchbase.MutateIn('Test').ArrayAppend('batters.batter', '{ "id": "1005", "type": "Yummy" }').Execute;
  CheckTrue(CBSubDocResult.Success);
  CheckEquals(1, Length(CBSubDocResult.Responses));

  CBSubDocResult := FCouchbase.LookupIn('Test').Get('batters.batter[-1]').Execute;
  CheckTrue(CBSubDocResult.Success);
  CheckEquals(1, Length(CBSubDocResult.Responses));
  CheckEquals('{ "id": "1005", "type": "Yummy" }', CBSubDocResult.Responses[0].Value);
end;

procedure TestTgoCouchbaseSubDoc.TestArrayPrepend;
var
  CBResult: TCouchbaseResult;
  CBSubDocResult: TCouchbaseSubDocResult;
begin
  CBResult := FCouchbase.Upsert('Test', FExampleJson);
  CheckTrue(CBResult.Success);

  CBSubDocResult := FCouchbase.MutateIn('Test').ArrayPrepend('batters.batter', '{ "id": "1000", "type": "Cherry" }').Execute;
  CheckTrue(CBSubDocResult.Success);
  CheckEquals(1, Length(CBSubDocResult.Responses));

  CBSubDocResult := FCouchbase.LookupIn('Test').Get('batters.batter[0]').Execute;
  CheckTrue(CBSubDocResult.Success);
  CheckEquals(1, Length(CBSubDocResult.Responses));
  CheckEquals('{ "id": "1000", "type": "Cherry" }', CBSubDocResult.Responses[0].Value);
end;

procedure TestTgoCouchbaseSubDoc.TestArrayAddUnique;
var
  CBResult: TCouchbaseResult;
  CBSubDocResult: TCouchbaseSubDocResult;
begin
  CBResult := FCouchbase.Upsert('Test', FExampleJson);
  CheckTrue(CBResult.Success);

  CBSubDocResult := FCouchbase.MutateIn('Test').ArrayAddUnique('batters.numbers', '42').Execute;
  CheckTrue(CBSubDocResult.Success);
  CheckEquals(1, Length(CBSubDocResult.Responses));

  { try to add it again }
  CBSubDocResult := FCouchbase.MutateIn('Test').ArrayAddUnique('batters.numbers', '42').Execute;
  CheckFalse(CBSubDocResult.Success);
  CheckEquals(1, Length(CBSubDocResult.Responses));
  CheckEquals(LCB_SUBDOC_PATH_EEXISTS, CBSubDocResult.Responses[0].Status);
end;

procedure TestTgoCouchbaseSubDoc.TestArrayInsert;
var
  CBResult: TCouchbaseResult;
  CBSubDocResult: TCouchbaseSubDocResult;
begin
  CBResult := FCouchbase.Upsert('Test', FExampleJson);
  CheckTrue(CBResult.Success);

  CBSubDocResult := FCouchbase.MutateIn('Test').ArrayAddUnique('batters.numbers', '42').Execute;
  CheckTrue(CBSubDocResult.Success);
  CheckEquals(1, Length(CBSubDocResult.Responses));

  CBSubDocResult := FCouchbase.MutateIn('Test').ArrayInsert('batters.numbers[0]', '41').Execute;
  CheckTrue(CBSubDocResult.Success);
  CheckEquals(1, Length(CBSubDocResult.Responses));

  CBSubDocResult := FCouchbase.LookupIn('Test').Get('batters.numbers[-1]').Execute;
  CheckTrue(CBSubDocResult.Success);
  CheckEquals(1, Length(CBSubDocResult.Responses));
  CheckEquals('42', CBSubDocResult.Responses[0].Value);
end;

procedure TestTgoCouchbaseSubDoc.TestCounter;
var
  CBResult: TCouchbaseResult;
  CBSubDocResult: TCouchbaseSubDocResult;
begin
  CBResult := FCouchbase.Upsert('Test', FExampleJson);
  CheckTrue(CBResult.Success);

  CBSubDocResult := FCouchbase.MutateIn('Test').Counter('Cost', '100').Execute;
  CheckTrue(CBSubDocResult.Success);

  CBSubDocResult := FCouchbase.LookupIn('Test').Get('Cost').Execute;
  CheckTrue(CBSubDocResult.Success);
  CheckEquals(1, Length(CBSubDocResult.Responses));
  CheckEquals('100', CBSubDocResult.Responses[0].Value);

  CBSubDocResult := FCouchbase.MutateIn('Test').Counter('Cost', '50').Execute;
  CheckTrue(CBSubDocResult.Success);
  CheckEquals(1, Length(CBSubDocResult.Responses));

  CBSubDocResult := FCouchbase.LookupIn('Test').Get('Cost').Execute;
  CheckTrue(CBSubDocResult.Success);
  CheckEquals(1, Length(CBSubDocResult.Responses));
  CheckEquals('150', CBSubDocResult.Responses[0].Value);
end;

initialization
  RegisterTest(TestTgoCouchbase.Suite);
  RegisterTest(TestTgoCouchbaseSubDoc.Suite);

end.
