unit Couchbase;

{ Delphi classes for Couchbase }

interface

uses
  SysUtils,
  System.Generics.Collections,
  Couchbase.API;

type
  TCouchbaseFormat = (
    Unknown = 0,
    Foreign = 1,
    JSON = 2,
    RAW = 3,
    UTF8 = 4);

  TCouchbaseOptions = record
    Format: TCouchbaseFormat;
    ExpireTime: UInt32;
    CAS: UInt64;
  public
    procedure Initialize;
  end;

  TCouchbaseSubDocResponse = record
    Value: Utf8String;
    Status: Integer;
  end;
  TCouchbaseSubDocResponses = TArray<TCouchbaseSubDocResponse>;

type
  TCouchbaseResult = record
    Success: Boolean;
    Error: Integer;
    Key: Utf8String;
    Value: TBytes;
    Format: TCouchbaseFormat;
    Flags: Integer;
    CAS: Integer;
    Operation: Integer;
    Counter: Integer; { incr/decr ops }
  public
    procedure Initialize;
  end;
  PCouchbaseResult = ^TCouchbaseResult;

  TCouchbaseFlushResult = record
    Success: Boolean;
    Error: Integer;
    Flags: Integer;
    CAS: Integer;
    Node: Utf8String; { flush/stat ops }
  public
    procedure Initialize;
  end;
  PCouchbaseFlushResult = ^TCouchbaseFlushResult;

  TCouchbaseStatsResult = record
    Success: Boolean;
    Error: Integer;
    Stats: TDictionary<Utf8String, TBytes>;
    Flags: Integer;
    CAS: Integer;
    Node: Utf8String; { flush/stat ops }
  public
    procedure Initialize;
    procedure Finalize;
  end;
  PCouchbaseStatsResult = ^TCouchbaseStatsResult;

  TCouchbaseSubDocResult = record
    Success: Boolean;
    Error: Integer;
    ErrorIndex: Integer;
    Key: Utf8String;
    Flags: Integer;
    CAS: Integer;
    Responses: TCouchbaseSubDocResponses;
  public
    procedure Initialize;
  end;
  PCouchbaseSubDocResult = ^TCouchbaseSubDocResult;

  TCouchbaseQueryError = record
    Code: Integer;
    Msg: Utf8String;
  end;

  TCouchbaseQueryMetrics = record
    ElapsedTime: Utf8String;
    ExecutionTime: Utf8String;
    ResultCount: Integer;
    ResultSize: Integer;
    ErrorCount: Integer;
  end;

  TCouchbaseQueryResult = record
    Success: Boolean;
    RequestId: Utf8String;
    Errors: TArray<TCouchbaseQueryError>;
    Status: Utf8String;
    Metrics: TCouchbaseQueryMetrics;
    Rows: TList<Utf8String>;
    MetaData: Utf8String;
  public
    procedure Initialize;
    procedure Finalize;
  end;
  PCouchbaseQueryResult = ^TCouchbaseQueryResult;

type
  TgoCouchbase = class;

  ICouchbaseSubDoc = interface
    function Get(const APath: Utf8String): ICouchbaseSubDoc;
    function Exists(const APath: Utf8String): ICouchbaseSubDoc;
    function GetCount(const APath: Utf8String): ICouchbaseSubDoc;

    function Upsert(const APath: Utf8String; const AValue: TBytes; const ACreateParent: Boolean = True): ICouchbaseSubDoc; overload;
    function Upsert(const APath: Utf8String; const AValue: Utf8String; const ACreateParent: Boolean = True): ICouchbaseSubDoc; overload;

    function Insert(const APath: Utf8String; const AValue: TBytes; const ACreateParent: Boolean = True): ICouchbaseSubDoc; overload;
    function Insert(const APath: Utf8String; const AValue: Utf8String; const ACreateParent: Boolean = True): ICouchbaseSubDoc; overload;

    function Replace(const APath: Utf8String; const AValue: TBytes): ICouchbaseSubDoc; overload;
    function Replace(const APath: Utf8String; const AValue: Utf8String): ICouchbaseSubDoc; overload;

    function Remove(const APath: Utf8String): ICouchbaseSubDoc;

    function ArrayAppend(const APath: Utf8String; const AValue: TBytes; const ACreateParent: Boolean = True): ICouchbaseSubDoc; overload;
    function ArrayAppend(const APath: Utf8String; const AValue: Utf8String; const ACreateParent: Boolean = True): ICouchbaseSubDoc; overload;

    function ArrayPrepend(const APath: Utf8String; const AValue: TBytes; const ACreateParent: Boolean = True): ICouchbaseSubDoc; overload;
    function ArrayPrepend(const APath: Utf8String; const AValue: Utf8String; const ACreateParent: Boolean = True): ICouchbaseSubDoc; overload;

    function ArrayAddUnique(const APath: Utf8String; const AValue: TBytes; const ACreateParent: Boolean = True): ICouchbaseSubDoc; overload;
    function ArrayAddUnique(const APath: Utf8String; const AValue: Utf8String; const ACreateParent: Boolean = True): ICouchbaseSubDoc; overload;

    function ArrayInsert(const APath: Utf8String; const AValue: TBytes): ICouchbaseSubDoc; overload;
    function ArrayInsert(const APath: Utf8String; const AValue: Utf8String): ICouchbaseSubDoc; overload;

    function Counter(const APath: Utf8String; const AValue: Utf8String; const ACreateParent: Boolean = True): ICouchbaseSubDoc;

    { Executes the subdocument query }
    function Execute: TCouchbaseSubDocResult;
  end;

  TgoCouchbaseSubDoc = class(TInterfacedObject, ICouchbaseSubDoc)
  protected
    FLastErrorCode: Integer;
    FLastErrorDesc: String;
    function Success(const AResult: Lcb_error_t): Boolean;
  private
    FCouchbase: TgoCouchbase;
    FKey: Utf8String;
    FMultiMode: Integer;
  private
    procedure Append(const ACommand: Integer; const APath: Utf8String); overload;
    procedure Append(const ACommand: Integer; const APath: Utf8String;
      const AValue: TBytes); overload;
    procedure Append(const ACommand: Integer; const APath: Utf8String;
      const AValue: TBytes; const ACreateParent: Boolean); overload;
  private
    FSpecs: TArray<lcb_SDSPEC>;
  public
    constructor Create(const ACouchbase: TgoCouchbase; const AKey: Utf8String; const AMultiMode: Integer);
    destructor Destroy; override;
  public
    function Get(const APath: Utf8String): ICouchbaseSubDoc;
    function Exists(const APath: Utf8String): ICouchbaseSubDoc;
    function GetCount(const APath: Utf8String): ICouchbaseSubDoc;

    function Upsert(const APath: Utf8String; const AValue: TBytes; const ACreateParent: Boolean = True): ICouchbaseSubDoc; overload;
    function Upsert(const APath: Utf8String; const AValue: Utf8String; const ACreateParent: Boolean = True): ICouchbaseSubDoc; overload;

    function Insert(const APath: Utf8String; const AValue: TBytes; const ACreateParent: Boolean = True): ICouchbaseSubDoc; overload;
    function Insert(const APath: Utf8String; const AValue: Utf8String; const ACreateParent: Boolean = True): ICouchbaseSubDoc; overload;

    function Replace(const APath: Utf8String; const AValue: TBytes): ICouchbaseSubDoc; overload;
    function Replace(const APath: Utf8String; const AValue: Utf8String): ICouchbaseSubDoc; overload;

    function Remove(const APath: Utf8String): ICouchbaseSubDoc;

    function ArrayAppend(const APath: Utf8String; const AValue: TBytes; const ACreateParent: Boolean = True): ICouchbaseSubDoc; overload;
    function ArrayAppend(const APath: Utf8String; const AValue: Utf8String; const ACreateParent: Boolean = True): ICouchbaseSubDoc; overload;

    function ArrayPrepend(const APath: Utf8String; const AValue: TBytes; const ACreateParent: Boolean = True): ICouchbaseSubDoc; overload;
    function ArrayPrepend(const APath: Utf8String; const AValue: Utf8String; const ACreateParent: Boolean = True): ICouchbaseSubDoc; overload;

    function ArrayAddUnique(const APath: Utf8String; const AValue: TBytes; const ACreateParent: Boolean = True): ICouchbaseSubDoc; overload;
    function ArrayAddUnique(const APath: Utf8String; const AValue: Utf8String; const ACreateParent: Boolean = True): ICouchbaseSubDoc; overload;

    function ArrayInsert(const APath: Utf8String; const AValue: TBytes): ICouchbaseSubDoc; overload;
    function ArrayInsert(const APath: Utf8String; const AValue: Utf8String): ICouchbaseSubDoc; overload;

    function Counter(const APath: Utf8String; const AValue: Utf8String; const ACreateParent: Boolean = True): ICouchbaseSubDoc;

    { Executes the subdocument query }
    function Execute: TCouchbaseSubDocResult;
  public
    property LastErrorCode: Integer read FLastErrorCode;
    property LastErrorDesc: String read FLastErrorDesc;
  end;

  TgoCouchbaseN1QL = class(TObject)
  private
    FParams: lcb_N1QLPARAMS;
  public
    constructor Create;
    destructor Destroy; override;
  public
    function SetStatement(const AQuery: Utf8String): Lcb_error_t;
  public
    property Params: lcb_N1QLPARAMS read FParams;
  end;

  TgoCouchbase = class(TObject)
  protected
    FLastErrorCode: Integer;
    FLastErrorDesc: String;
    function Success(const AResult: Lcb_error_t): Boolean;
    function Store(const AOperation: Integer; const AKey: Utf8String; const AValue: TBytes;
      const AOptions: TCouchbaseOptions): TCouchbaseResult;
    function StoreRaw(const AOperation: Integer; const AKey: Utf8String; const AValue: TBytes): TCouchbaseResult;
  private
    FInstance: lcb_t;
    FOptions: lcb_create_st;
  public
    constructor Create;
    destructor Destroy; override;
  public
    function Connect(const AConnection: String; const AUsername: String = ''; const APassword: String = ''): Boolean;

    { Get }
    function Get(const AKey: Utf8String; out AValue: TBytes): TCouchbaseResult; overload;
    function Get(const AKey: Utf8String; out AValue: String): TCouchbaseResult; overload;

    { Set/Upsert }
    function Upsert(const AKey: Utf8String; const AValue: TBytes; const AOptions: TCouchbaseOptions): TCouchbaseResult; overload;
    function Upsert(const AKey: Utf8String; const AValue: String; const AOptions: TCouchbaseOptions): TCouchbaseResult; overload;
    function Upsert(const AKey: Utf8String; const AValue: String): TCouchbaseResult; overload;

    { Add }
    function Add(const AKey: Utf8String; const AValue: TBytes; const AOptions: TCouchbaseOptions): TCouchbaseResult; overload;
    function Add(const AKey: Utf8String; const AValue: String; const AOptions: TCouchbaseOptions): TCouchbaseResult; overload;
    function Add(const AKey: Utf8String; const AValue: String): TCouchbaseResult; overload;

    { Replace }
    function Replace(const AKey: Utf8String; const AValue: TBytes; const AOptions: TCouchbaseOptions): TCouchbaseResult; overload;
    function Replace(const AKey: Utf8String; const AValue: String; const AOptions: TCouchbaseOptions): TCouchbaseResult; overload;
    function Replace(const AKey: Utf8String; const AValue: String): TCouchbaseResult; overload;

    { Append/Prepend }
    function Append(const AKey: Utf8String; const AValue: TBytes): TCouchbaseResult; overload;
    function Append(const AKey: Utf8String; const AValue: String): TCouchbaseResult; overload;
    function Prepend(const AKey: Utf8String; const AValue: TBytes): TCouchbaseResult; overload;
    function Prepend(const AKey: Utf8String; const AValue: String): TCouchbaseResult; overload;

    { Touch }
    function Touch(const AKey: Utf8String; const AExpireTime: UInt32 = 0): TCouchbaseResult;

    { Increment/Decrement }
    function Incr(const AKey: Utf8String; const ADelta: Integer = 1; const AInitial: Integer = 0;
      const ACreate: Boolean = True): TCouchbaseResult;
    function Decr(const AKey: Utf8String; const ADelta: Integer = -1; const AInitial: Integer = 0;
      const ACreate: Boolean = True): TCouchbaseResult;

    { Delete }
    function Delete(const AKey: Utf8String): TCouchbaseResult;

    { Flush }
    function Flush: TCouchbaseFlushResult;

    { Stats }
    function Stats: TCouchbaseStatsResult;
  public
    { Subdocuments }

    { Lookup subdoc operations }
    function LookupIn(const AKey: Utf8String): ICouchbaseSubDoc;

    { Mutate subdoc operations }
    function MutateIn(const AKey: Utf8String): ICouchbaseSubDoc;
  public
    { N1QL }

    function Query(const AParams: TgoCouchbaseN1QL): TCouchbaseQueryResult;
  public
    property LastErrorCode: Integer read FLastErrorCode;
    property LastErrorDesc: String read FLastErrorDesc;

    { Bucket instance }
    property Instance: lcb_t read FInstance;
  end;

implementation

uses
  Grijjy.Bson;

var
  DEFAULT_OPTIONS: TCouchbaseOptions;

{ TCouchbase }

constructor TgoCouchbase.Create;
begin
  FInstance := nil;
end;

destructor TgoCouchbase.Destroy;
begin
  if FInstance <> nil then
  begin
    lcb_destroy(FInstance);
    FInstance := nil;
  end;
  inherited;
end;

function TgoCouchbase.Success(const AResult: Lcb_error_t): Boolean;
begin
  FLastErrorCode := AResult;
  if FLastErrorCode = LCB_SUCCESS then
  begin
    FLastErrorDesc := 'Success';
    Result := True;
  end
  else
  begin
    FLastErrorDesc := String(lcb_strerror(nil, FLastErrorCode));
    Result := False;
  end;
end;

function TgoCouchbase.Store(const AOperation: Integer; const AKey: Utf8String; const AValue: TBytes;
  const AOptions: TCouchbaseOptions): TCouchbaseResult;
var
  Command: lcb_CMDSTORE;
begin
  FillChar(Command, SizeOf(Command), 0);
  Result.Initialize;
  Command.flags := Integer(AOptions.Format) shl 24;
  Command.cmdbase.exptime := AOptions.ExpireTime;
  Command.cmdbase.cas := AOptions.CAS;
  LCB_CMD_SET_KEY(Command.cmdbase, MarshaledAString(AKey), Length(AKey));
  LCB_CMD_SET_VALUE(Command, AValue, Length(AValue));
  Command.operation := AOperation;
  if Success(lcb_store3(FInstance, @Result, @Command)) then
    lcb_wait3(FInstance, LCB_WAIT_NOCHECK);
end;

function TgoCouchbase.StoreRaw(const AOperation: Integer; const AKey: Utf8String; const AValue: TBytes): TCouchbaseResult;
var
  Command: lcb_CMDSTORE;
begin
  FillChar(Command, SizeOf(Command), 0);
  Result.Initialize;
  LCB_CMD_SET_KEY(Command.cmdbase, MarshaledAString(AKey), Length(AKey));
  LCB_CMD_SET_VALUE(Command, AValue, Length(AValue));
  Command.operation := AOperation;
  if Success(lcb_store3(FInstance, @Result, @Command)) then
    lcb_wait3(FInstance, LCB_WAIT_NOCHECK);
end;

procedure ResponseCallback(AInstance: lcb_t; ACBType: Integer; const AResponseBase: plcb_RESPBASE); cdecl;
var
  CBResult: PCouchbaseResult;
  ResponseGet: plcb_RESPGET;
  ResponseStore: plcb_RESPSTORE;
  ResponseCounter: plcb_RESPCOUNTER;
begin
  if AResponseBase.cookie <> nil then
  begin
    CBResult := AResponseBase.cookie;
    CBResult.Success := AResponseBase.rc = LCB_SUCCESS;
    SetLength(CBResult.Key, AResponseBase.nkey);
    Move(AResponseBase.key^, CBResult.Key[1], AResponseBase.nkey);
    CBResult.Flags := AResponseBase.rflags;
    CBResult.CAS := AResponseBase.cas;
    if CBResult.Success then
    begin
      case ACBType of
        LCB_CALLBACK_GET:
        begin
          ResponseGet := plcb_RESPGET(AResponseBase);
          CBResult.Format := TCouchbaseFormat(ResponseGet.itmflags shr 24);
          SetLength(CBResult.Value, ResponseGet.nvalue);
          Move(ResponseGet.value^, CBResult.Value[0], ResponseGet.nvalue);
        end;
        LCB_CALLBACK_STORE:
        begin
          ResponseStore := plcb_RESPSTORE(AResponseBase);
          CBResult.Operation := ResponseStore.op;
        end;
        LCB_CALLBACK_COUNTER:
        begin
          ResponseCounter := plcb_RESPCOUNTER(AResponseBase);
          CBResult.Counter := ResponseCounter.value;
        end;
      end;
    end
    else
      CBResult.Error := AResponseBase.rc;
  end;
end;

procedure ResponseFlushCallback(AInstance: lcb_t; ACBType: Integer; const AResponseBase: plcb_RESPBASE); cdecl;
var
  CBFlushResult: PCouchbaseFlushResult;
  ResponseFlush: plcb_RESPFLUSH;
begin
  if AResponseBase.cookie <> nil then
  begin
    CBFlushResult := AResponseBase.cookie;
    CBFlushResult.Success := AResponseBase.rc = LCB_SUCCESS;
    CBFlushResult.Flags := AResponseBase.rflags;
    CBFlushResult.CAS := AResponseBase.cas;
    if CBFlushResult.Success then
    begin
      case ACBType of
        LCB_CALLBACK_FLUSH:
        begin
          ResponseFlush := plcb_RESPFLUSH(AResponseBase);
          SetLength(CBFlushResult.Node, Length(ResponseFlush.respserverbase.respserverfields.server));
          Move(ResponseFlush.respserverbase.respserverfields.server^, CBFlushResult.Node[1], Length(ResponseFlush.respserverbase.respserverfields.server));
        end;
      end;
    end
    else
      CBFlushResult.Error := AResponseBase.rc;
  end;
end;

procedure ResponseStatsCallback(AInstance: lcb_t; ACBType: Integer; const AResponseBase: plcb_RESPBASE); cdecl;
var
  CBStatsResult: PCouchbaseStatsResult;
  ResponseStats: plcb_RESPSTATS;
  Key: Utf8String;
  Value: TBytes;
begin
  if AResponseBase.cookie <> nil then
  begin
    CBStatsResult := AResponseBase.cookie;
    CBStatsResult.Success := AResponseBase.rc = LCB_SUCCESS;
    CBStatsResult.Flags := AResponseBase.rflags;
    CBStatsResult.CAS := AResponseBase.cas;
    if CBStatsResult.Success then
    begin
      case ACBType of
        LCB_CALLBACK_STATS:
        begin
          { the callback for this command is invoked an indeterminate amount number of times and
            is finished when resp->rflags & LCB_RESP_F_FINAL }
          ResponseStats := plcb_RESPSTATS(AResponseBase);
          if (ResponseStats.respserverbase.respbase.rflags AND LCB_RESP_F_FINAL) = 0 then
          begin
            SetLength(CBStatsResult.Node, Length(ResponseStats.respserverbase.respserverfields.server));
            Move(ResponseStats.respserverbase.respserverfields.server^, CBStatsResult.Node[1], Length(ResponseStats.respserverbase.respserverfields.server));
            SetLength(Key, ResponseStats.respserverbase.respbase.nkey);
            Move(ResponseStats.respserverbase.respbase.key^, Key[1], ResponseStats.respserverbase.respbase.nkey);
            SetLength(Value, ResponseStats.nvalue);
            Move(ResponseStats.value^, Value[0], ResponseStats.nValue);
            CBStatsResult.Stats.Add(Key, Value);
          end;
        end;
      end;
    end
    else
      CBStatsResult.Error := AResponseBase.rc;
  end;
end;

procedure ResponseSubDocCallback(AInstance: lcb_t; ACBType: Integer; const AResponseBase: plcb_RESPBASE); cdecl;
var
  CBSubDocResult: PCouchbaseSubDocResult;
  CBSubDocResponse: TCouchbaseSubDocResponse;
  ResponseSubDoc: plcb_RESPSUBDOC;
  SDEntry: lcb_SDENTRY;
  Iterator: size_t;
  Index: Integer;
begin
  if AResponseBase.cookie <> nil then
  begin
    CBSubDocResult := AResponseBase.cookie;
    CBSubDocResult.Success := AResponseBase.rc = LCB_SUCCESS;
    CBSubDocResult.Error := AResponseBase.rc;
    SetLength(CBSubDocResult.Key, AResponseBase.nkey);
    Move(AResponseBase.key^, CBSubDocResult.Key[1], AResponseBase.nkey);
    CBSubDocResult.Flags := AResponseBase.rflags;
    CBSubDocResult.CAS := AResponseBase.cas;
    case ACBType of
      LCB_CALLBACK_SDLOOKUP,
      LCB_CALLBACK_SDMUTATE:
      begin
        ResponseSubDoc := plcb_RESPSUBDOC(AResponseBase);
        Iterator := 0;
        Index := 0;
        while lcb_sdresult_next(ResponseSubDoc, SDEntry, Iterator) <> 0 do
        begin
          if ACBType = LCB_CALLBACK_SDMUTATE then
            Index := SDEntry.index; { mutate only }
          if Length(CBSubDocResult.Responses) < (Index + 1) then
            SetLength(CBSubDocResult.Responses, (Index + 1));
          SetLength(CBSubDocResponse.Value, SDEntry.nvalue);
          Move(SDEntry.value^, CBSubDocResponse.Value[1], SDEntry.nvalue); { always json }
          CBSubDocResponse.Status := SDEntry.status;
          CBSubDocResult.Responses[Index] := CBSubDocResponse;
          if ACBType = LCB_CALLBACK_SDLOOKUP then
            Inc(Index);
        end;
      end;
    end;
  end;
end;

procedure ResponseQueryCallback(AInstance: lcb_t; ACBType: Integer; const AResponse: lcb_RESPN1QL); cdecl;
var
  CBQueryResult: PCouchbaseQueryResult;
  Value: Utf8String;
begin
  if AResponse.respbase.cookie <> nil then
  begin
    CBQueryResult := AResponse.respbase.cookie;
    CBQueryResult.Success := AResponse.respbase.rc = LCB_SUCCESS;
    if (AResponse.respbase.rflags AND LCB_RESP_F_FINAL) = 0 then
    begin
      SetLength(Value, AResponse.nRow);
      Move(AResponse.row^, Value[1], AResponse.nRow);
      CBQueryResult.Rows.Add(Value);
    end
    else
    begin
      // metadata
      SetLength(CBQueryResult.MetaData, AResponse.nRow);
      Move(AResponse.row^, CBQueryResult.MetaData[1], AResponse.nRow);
    end;
  end;
end;

function TgoCouchbase.Connect(const AConnection: String; const AUsername, APassword: String): Boolean;
begin
  Result := False;
  FillChar(FOptions, SizeOf(FOptions), 0);
  FOptions.version := 3;
  FOptions.v3.connstr := MarshaledAString(TMarshal.AsAnsi(AConnection));
  FOptions.v3.username := MarshaledAString(TMarshal.AsAnsi(AUsername));
  FOptions.v3.passwd := MarshaledAString(TMarshal.AsAnsi(APassword));
  if Success(lcb_create(@FInstance, @FOptions)) then
    if Success(lcb_connect(FInstance)) then
    begin
      lcb_wait3(FInstance, LCB_WAIT_NOCHECK);
      Result := Success(lcb_get_bootstrap_status(FInstance));
      if Result then
      begin
        { crud callbacks }
        lcb_install_callback3(FInstance, LCB_CALLBACK_GET, ResponseCallback);
        lcb_install_callback3(FInstance, LCB_CALLBACK_STORE, ResponseCallback);
        lcb_install_callback3(FInstance, LCB_CALLBACK_COUNTER, ResponseCallback);
        lcb_install_callback3(FInstance, LCB_CALLBACK_TOUCH, ResponseCallback);
        lcb_install_callback3(FInstance, LCB_CALLBACK_REMOVE, ResponseCallback);

        { flush/stats callbacks }
        lcb_install_callback3(FInstance, LCB_CALLBACK_FLUSH, ResponseFlushCallback);
        lcb_install_callback3(FInstance, LCB_CALLBACK_STATS, ResponseStatsCallback);

        { json subdoc callbacks }
        lcb_install_callback3(FInstance, LCB_CALLBACK_SDLOOKUP, ResponseSubDocCallback);
        lcb_install_callback3(FInstance, LCB_CALLBACK_SDMUTATE, ResponseSubDocCallback);
      end;
    end;
end;

function TgoCouchbase.Get(const AKey: Utf8String; out AValue: TBytes): TCouchbaseResult;
var
  Command: lcb_CMDGET;
begin
  FillChar(Command, SizeOf(Command), 0);
  Result.Initialize;
  LCB_CMD_SET_KEY(Command.cmdbase, MarshaledAString(AKey), Length(AKey));
  if Success(lcb_get3(FInstance, @Result, @Command)) then
  begin
    lcb_wait3(FInstance, LCB_WAIT_NOCHECK);
    if Result.Success then
      AValue := Result.Value;
  end;
end;

function TgoCouchbase.Get(const AKey: Utf8String; out AValue: String): TCouchbaseResult;
var
  Value: TBytes;
begin
  Result := Get(AKey, Value);
  if Result.Success then
    AValue := TEncoding.Utf8.GetString(Value);
end;

function TgoCouchbase.Upsert(const AKey: Utf8String; const AValue: TBytes;
  const AOptions: TCouchbaseOptions): TCouchbaseResult;
begin
  Result := Store(LCB_SET, AKey, AValue, AOptions);
end;

function TgoCouchbase.Upsert(const AKey: Utf8String; const AValue: String;
  const AOptions: TCouchbaseOptions): TCouchbaseResult;
begin
  Result := Store(LCB_SET, AKey, TEncoding.UTF8.GetBytes(AValue), AOptions);
end;

function TgoCouchbase.Upsert(const AKey: Utf8String; const AValue: String): TCouchbaseResult;
begin
  Result := Store(LCB_SET, AKey, TEncoding.UTF8.GetBytes(AValue), DEFAULT_OPTIONS);
end;

function TgoCouchbase.Add(const AKey: Utf8String; const AValue: TBytes;
  const AOptions: TCouchbaseOptions): TCouchbaseResult;
begin
  Result := Store(LCB_ADD, AKey, AValue, AOptions);
end;

function TgoCouchbase.Add(const AKey: Utf8String; const AValue: String;
  const AOptions: TCouchbaseOptions): TCouchbaseResult;
begin
  Result := Store(LCB_ADD, AKey, TEncoding.UTF8.GetBytes(AValue), AOptions);
end;

function TgoCouchbase.Add(const AKey: Utf8String; const AValue: String): TCouchbaseResult;
begin
  Result := Store(LCB_ADD, AKey, TEncoding.UTF8.GetBytes(AValue), DEFAULT_OPTIONS);
end;

function TgoCouchbase.Replace(const AKey: Utf8String; const AValue: TBytes;
  const AOptions: TCouchbaseOptions): TCouchbaseResult;
begin
  Result := Store(LCB_REPLACE, AKey, AValue, AOptions);
end;

function TgoCouchbase.Replace(const AKey: Utf8String; const AValue: String;
  const AOptions: TCouchbaseOptions): TCouchbaseResult;
begin
  Result := Store(LCB_REPLACE, AKey, TEncoding.UTF8.GetBytes(AValue), AOptions);
end;

function TgoCouchbase.Replace(const AKey: Utf8String; const AValue: String): TCouchbaseResult;
begin
  Result := Store(LCB_REPLACE, AKey, TEncoding.UTF8.GetBytes(AValue), DEFAULT_OPTIONS);
end;

function TgoCouchbase.Append(const AKey: Utf8String; const AValue: TBytes): TCouchbaseResult;
begin
  Result := StoreRaw(LCB_APPEND, AKey, AValue);
end;

function TgoCouchbase.Append(const AKey: Utf8String; const AValue: String): TCouchbaseResult;
begin
  Result := StoreRaw(LCB_APPEND, AKey, TEncoding.UTF8.GetBytes(AValue));
end;

function TgoCouchbase.Prepend(const AKey: Utf8String; const AValue: TBytes): TCouchbaseResult;
begin
  Result := StoreRaw(LCB_PREPEND, AKey, AValue);
end;

function TgoCouchbase.Prepend(const AKey: Utf8String; const AValue: String): TCouchbaseResult;
begin
  Result := StoreRaw(LCB_PREPEND, AKey, TEncoding.UTF8.GetBytes(AValue));
end;

function TgoCouchbase.Query(const AParams: TgoCouchbaseN1QL): TCouchbaseQueryResult;
var
  Command: lcb_CMDN1QL;
  Doc, Error, Metrics: TgoBsonDocument;
  Errors: TgoBsonArray;
  Value: TgoBsonValue;
  I: Integer;
begin
  FillChar(Command, SizeOf(Command), 0);
  Result.Initialize;
  Command.callback := ResponseQueryCallback;
  if Success(lcb_n1p_mkcmd(AParams.Params, @Command)) then
    if Success(lcb_n1ql_query(FInstance, @Result, @Command)) then
    begin
      lcb_wait3(FInstance, LCB_WAIT_NOCHECK);
      if TgoBsonDocument.TryParse(Result.MetaData, Doc) then
      begin
        Result.Status := Doc['status'];
        Result.Success := Result.Status = 'success';
        Result.RequestId := Doc['requestID'];

        if (Doc.TryGetValue('errors', Value)) then
        begin
          Errors := Value.AsBsonArray;
          SetLength(Result.Errors, Errors.Count);
          for I := 0 to Errors.Count - 1 do
          begin
            Error := Errors[I].AsBsonDocument;
            Result.Errors[I].Code := Error['code'];
            Result.Errors[I].Msg := Error['msg'];
          end;
        end;

        if (Doc.TryGetValue('metrics', Value)) then
        begin
          Metrics := Value.AsBsonDocument;
          Result.Metrics.ElapsedTime := Metrics['elapsedTime'];
          Result.Metrics.ExecutionTime:= Metrics['executionTime'];
          Result.Metrics.ResultCount := Metrics['resultCount'];
          Result.Metrics.ResultSize := Metrics['resultSize'];
          Result.Metrics.ErrorCount := Metrics['errorCount'];
        end;
      end;
    end;
end;

function TgoCouchbase.Touch(const AKey: Utf8String; const AExpireTime: UInt32): TCouchbaseResult;
var
  Command: lcb_CMDTOUCH;
begin
  FillChar(Command, SizeOf(Command), 0);
  Command.cmdbase.exptime := AExpireTime;
  Result.Initialize;
  LCB_CMD_SET_KEY(Command.cmdbase, MarshaledAString(AKey), Length(AKey));
  if Success(lcb_touch3(FInstance, @Result, @Command)) then
    lcb_wait3(FInstance, LCB_WAIT_NOCHECK);
end;

function TgoCouchbase.Incr(const AKey: Utf8String; const ADelta: Integer; const AInitial: Integer;
  const ACreate: Boolean): TCouchbaseResult;
var
  Command: lcb_CMDCOUNTER;
begin
  FillChar(Command, SizeOf(Command), 0);
  Command.delta := ADelta;
  Command.initial := AInitial;
  Command.create := Integer(ACreate);
  Result.Initialize;
  LCB_CMD_SET_KEY(Command.cmdbase, MarshaledAString(AKey), Length(AKey));
  if Success(lcb_counter3(FInstance, @Result, @Command)) then
    lcb_wait3(FInstance, LCB_WAIT_NOCHECK);
end;

function TgoCouchbase.Decr(const AKey: Utf8String; const ADelta: Integer; const AInitial: Integer;
  const ACreate: Boolean): TCouchbaseResult;
var
  Command: lcb_CMDCOUNTER;
begin
  FillChar(Command, SizeOf(Command), 0);
  Command.delta := ADelta;
  Command.initial := AInitial;
  Command.create := Integer(ACreate);
  Result.Initialize;
  LCB_CMD_SET_KEY(Command.cmdbase, MarshaledAString(AKey), Length(AKey));
  if Success(lcb_counter3(FInstance, @Result, @Command)) then
    lcb_wait3(FInstance, LCB_WAIT_NOCHECK);
end;

function TgoCouchbase.Delete(const AKey: Utf8String): TCouchbaseResult;
var
  Command: lcb_CMDREMOVE;
begin
  FillChar(Command, SizeOf(Command), 0);
  Result.Initialize;
  LCB_CMD_SET_KEY(Command.cmdbase, MarshaledAString(AKey), Length(AKey));
  if Success(lcb_remove3(FInstance, @Result, @Command)) then
    lcb_wait3(FInstance, LCB_WAIT_NOCHECK);
end;

function TgoCouchbase.Flush: TCouchbaseFlushResult;
var
  Command: lcb_CMDFLUSH;
begin
  FillChar(Command, SizeOf(Command), 0);
  Result.Initialize;
  if Success(lcb_flush3(FInstance, @Result, @Command)) then
    lcb_wait3(FInstance, LCB_WAIT_NOCHECK);
end;

function TgoCouchbase.Stats: TCouchbaseStatsResult;
var
  Command: lcb_CMDSTATS;
begin
  FillChar(Command, SizeOf(Command), 0);
  Result.Initialize;
  if Success(lcb_stats3(FInstance, @Result, @Command)) then
    lcb_wait3(FInstance, LCB_WAIT_NOCHECK);
end;

function TgoCouchbase.LookupIn(const AKey: Utf8String): ICouchbaseSubDoc;
begin
  Result := TgoCouchbaseSubDoc.Create(Self, AKey, LCB_SDMULTI_MODE_LOOKUP);
end;

function TgoCouchbase.MutateIn(const AKey: Utf8String): ICouchbaseSubDoc;
begin
  Result := TgoCouchbaseSubDoc.Create(Self, AKey, LCB_SDMULTI_MODE_MUTATE);
end;

{ TCouchbaseResult }

procedure TCouchbaseResult.Initialize;
begin
  Success := False;
  Error := 0;
  Key := '';
  Value := nil;
  Format := TCouchbaseFormat.JSON;
  Flags := 0;
  CAS := 0;
  Operation := 0;
  Counter := 0;
end;

{ TCouchbaseSubDoc }

constructor TgoCouchbaseSubDoc.Create(const ACouchbase: TgoCouchbase;
  const AKey: Utf8String; const AMultiMode: Integer);
begin
  FCouchbase := ACouchbase;
  FKey := AKey;
  FMultiMode := AMultiMode;
end;

destructor TgoCouchbaseSubDoc.Destroy;
begin
  inherited;
end;

function TgoCouchbaseSubDoc.Success(const AResult: Lcb_error_t): Boolean;
begin
  FLastErrorCode := AResult;
  if FLastErrorCode = LCB_SUCCESS then
  begin
    FLastErrorDesc := 'Success';
    Result := True;
  end
  else
  begin
    FLastErrorDesc := String(lcb_strerror(nil, FLastErrorCode));
    Result := False;
  end;
end;

procedure TgoCouchbaseSubDoc.Append(const ACommand: Integer; const APath: Utf8String);
var
  Spec: lcb_SDSPEC;
begin
  FillChar(Spec, SizeOf(Spec), 0);
  Spec.sdcmd := ACommand;
  LCB_SDSPEC_SET_PATH(Spec, MarshaledAString(APath), Length(APath));
  FSpecs := FSpecs + [Spec];
end;

procedure TgoCouchbaseSubDoc.Append(const ACommand: Integer; const APath: Utf8String;
  const AValue: TBytes);
var
  Spec: lcb_SDSPEC;
begin
  FillChar(Spec, SizeOf(Spec), 0);
  Spec.sdcmd := ACommand;
  LCB_SDSPEC_SET_PATH(Spec, MarshaledAString(APath), Length(APath));
  LCB_SDSPEC_SET_VALUE(Spec, AValue, Length(AValue));
  FSpecs := FSpecs + [Spec];
end;

procedure TgoCouchbaseSubDoc.Append(const ACommand: Integer; const APath: Utf8String;
  const AValue: TBytes; const ACreateParent: Boolean);
var
  Spec: lcb_SDSPEC;
begin
  FillChar(Spec, SizeOf(Spec), 0);
  Spec.sdcmd := ACommand;
  if ACreateParent then
    Spec.options := LCB_SDSPEC_F_MKINTERMEDIATES;
  LCB_SDSPEC_SET_PATH(Spec, MarshaledAString(APath), Length(APath));
  LCB_SDSPEC_SET_VALUE(Spec, AValue, Length(AValue));
  FSpecs := FSpecs + [Spec];
end;

function TgoCouchbaseSubDoc.Get(const APath: Utf8String): ICouchbaseSubDoc;
begin
  Append(LCB_SDCMD_GET, APath);
  Result := Self;
end;

function TgoCouchbaseSubDoc.Exists(const APath: Utf8String): ICouchbaseSubDoc;
begin
  Append(LCB_SDCMD_EXISTS, APath);
  Result := Self;
end;

function TgoCouchbaseSubDoc.GetCount(const APath: Utf8String): ICouchbaseSubDoc;
begin
  Append(LCB_SDCMD_GET_COUNT, APath);
  Result := Self;
end;

function TgoCouchbaseSubDoc.Upsert(const APath: Utf8String;
  const AValue: TBytes; const ACreateParent: Boolean): ICouchbaseSubDoc;
begin
  Append(LCB_SDCMD_DICT_UPSERT, APath, AValue, ACreateParent);
  Result := Self;
end;

function TgoCouchbaseSubDoc.Upsert(const APath: Utf8String;
  const AValue: Utf8String; const ACreateParent: Boolean): ICouchbaseSubDoc;
begin
  Upsert(APath, TEncoding.UTF8.GetBytes(AValue), ACreateParent);
  Result := Self;
end;

function TgoCouchbaseSubDoc.Insert(const APath: Utf8String;
  const AValue: TBytes; const ACreateParent: Boolean): ICouchbaseSubDoc;
begin
  Append(LCB_SDCMD_DICT_ADD, APath, AValue, ACreateParent);
  Result := Self;
end;

function TgoCouchbaseSubDoc.Insert(const APath: Utf8String;
  const AValue: Utf8String; const ACreateParent: Boolean): ICouchbaseSubDoc;
begin
  Insert(APath, TEncoding.UTF8.GetBytes(AValue), ACreateParent);
  Result := Self;
end;

function TgoCouchbaseSubDoc.Replace(const APath: Utf8String;
  const AValue: TBytes): ICouchbaseSubDoc;
begin
  Append(LCB_SDCMD_REPLACE, APath, AValue);
  Result := Self;
end;

function TgoCouchbaseSubDoc.Replace(const APath: Utf8String;
  const AValue: Utf8String): ICouchbaseSubDoc;
begin
  Replace(APath, TEncoding.UTF8.GetBytes(AValue));
  Result := Self;
end;

function TgoCouchbaseSubDoc.Remove(const APath: Utf8String): ICouchbaseSubDoc;
begin
  Append(LCB_SDCMD_REMOVE, APath);
  Result := Self;
end;

function TgoCouchbaseSubDoc.ArrayAppend(const APath: Utf8String;
  const AValue: TBytes; const ACreateParent: Boolean): ICouchbaseSubDoc;
begin
  Append(LCB_SDCMD_ARRAY_ADD_LAST, APath, AValue, ACreateParent);
  Result := Self;
end;

function TgoCouchbaseSubDoc.ArrayAppend(const APath: Utf8String;
  const AValue: Utf8String; const ACreateParent: Boolean): ICouchbaseSubDoc;
begin
  ArrayAppend(APath, TEncoding.UTF8.GetBytes(AValue), ACreateParent);
  Result := Self;
end;

function TgoCouchbaseSubDoc.ArrayPrepend(const APath: Utf8String;
  const AValue: TBytes; const ACreateParent: Boolean): ICouchbaseSubDoc;
begin
  Append(LCB_SDCMD_ARRAY_ADD_FIRST, APath, AValue, ACreateParent);
  Result := Self;
end;

function TgoCouchbaseSubDoc.ArrayPrepend(const APath: Utf8String;
  const AValue: Utf8String; const ACreateParent: Boolean): ICouchbaseSubDoc;
begin
  ArrayPrepend(APath, TEncoding.UTF8.GetBytes(AValue), ACreateParent);
  Result := Self;
end;

function TgoCouchbaseSubDoc.ArrayInsert(const APath: Utf8String;
  const AValue: TBytes): ICouchbaseSubDoc;
begin
  Append(LCB_SDCMD_ARRAY_INSERT, APath, AValue, False);
  Result := Self;
end;

function TgoCouchbaseSubDoc.ArrayInsert(const APath: Utf8String;
  const AValue: Utf8String): ICouchbaseSubDoc;
begin
  ArrayInsert(APath, TEncoding.UTF8.GetBytes(AValue));
  Result := Self;
end;

function TgoCouchbaseSubDoc.ArrayAddUnique(const APath: Utf8String;
  const AValue: TBytes; const ACreateParent: Boolean): ICouchbaseSubDoc;
begin
  Append(LCB_SDCMD_ARRAY_ADD_UNIQUE, APath, AValue, ACreateParent);
  Result := Self;
end;

function TgoCouchbaseSubDoc.ArrayAddUnique(const APath: Utf8String;
  const AValue: Utf8String; const ACreateParent: Boolean): ICouchbaseSubDoc;
begin
  ArrayAddUnique(APath, TEncoding.UTF8.GetBytes(AValue), ACreateParent);
  Result := Self;
end;

function TgoCouchbaseSubDoc.Counter(const APath: Utf8String;
  const AValue: Utf8String; const ACreateParent: Boolean): ICouchbaseSubDoc;
begin
  Append(LCB_SDCMD_COUNTER, APath, TEncoding.UTF8.GetBytes(AValue), ACreateParent);
  Result := Self;
end;

function TgoCouchbaseSubDoc.Execute: TCouchbaseSubDocResult;
var
  Command: lcb_CMDSUBDOC;
begin
  FillChar(Command, SizeOf(Command), 0);
  Command.specs := @FSpecs[0];
  Command.nspecs := Length(FSpecs);
  Command.multimode := FMultiMode;
  Result.Initialize;
  LCB_CMD_SET_KEY(Command.cmdbase, MarshaledAString(FKey), Length(FKey));
  if Success(lcb_subdoc3(FCouchbase.Instance, @Result, @Command)) then
    lcb_wait3(FCouchbase.Instance, LCB_WAIT_NOCHECK);
end;

{ TCouchbaseN1QL }

constructor TgoCouchbaseN1QL.Create;
begin
  FParams := lcb_n1p_new;
end;

destructor TgoCouchbaseN1QL.Destroy;
begin
  lcb_n1p_free(FParams);
  inherited;
end;

function TgoCouchbaseN1QL.SetStatement(const AQuery: Utf8String): Lcb_error_t;
begin
  Result := lcb_n1p_setquery(FParams, MarshaledAString(AQuery), -1, LCB_N1P_QUERY_STATEMENT);
end;

{ TCouchbaseSubDocResult }

procedure TCouchbaseSubDocResult.Initialize;
begin
  Success := False;
  Error := 0;
  ErrorIndex := 0;
  Key := '';
  Flags := 0;
  CAS := 0;
  Responses := nil;
end;

{ TCouchbaseOptions }

procedure TCouchbaseOptions.Initialize;
begin
  Format := TCouchbaseFormat.JSON;
  ExpireTime := 0;
  CAS := 0;
end;

{ TCouchbaseFlushResult }

procedure TCouchbaseFlushResult.Initialize;
begin
  Success := False;
  Error := 0;
  Flags := 0;
  CAS := 0;
  Node := '';
end;

{ TCouchbaseStatsResult }

procedure TCouchbaseStatsResult.Initialize;
begin
  Success := False;
  Error := 0;
  Stats := TDictionary<Utf8String, TBytes>.Create;
  Flags := 0;
  CAS := 0;
  Node := '';
end;

procedure TCouchbaseStatsResult.Finalize;
begin
  Stats.Free;
end;

{ TCouchbaseQueryResult }

procedure TCouchbaseQueryResult.Initialize;
begin
  Success := False;
  Errors := nil;
  Status := '';
  Rows := TList<Utf8String>.Create;
  MetaData := '';
  Metrics.ElapsedTime := '';
  Metrics.ExecutionTime := '';
  Metrics.ResultCount := 0;
  Metrics.ResultSize := 0;
  Metrics.ErrorCount := 0;
end;

procedure TCouchbaseQueryResult.Finalize;
begin
  Rows.Free;
end;

initialization
  DEFAULT_OPTIONS.Initialize;

end.
