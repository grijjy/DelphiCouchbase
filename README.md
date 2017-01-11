# Working with big data databases in Delphi – Cassandra, Couchbase and MongoDB (Part 2 of 3)
 
This is the second part of a three-part series on working with big data databases directly from Delphi. In this second part we focus on a basic class framework for working with Couchbase along with unit tests and examples.![](http://i.imgur.com/bPiGRvJ.png)

[Part 1](https://github.com/grijjy/DelphiCassandra) focuses on Cassandra, [Part 2](https://github.com/grijjy/DelphiCouchbase) focuses on Couchbase and Part 3 focuses on MongoDB.

For more information about us, our support and services visit the [Grijjy homepage](http://www.grijjy.com) or the [Grijjy developers blog](http://blog.grijjy.com).

The example contained here depends upon part of our [Grijjy Foundation library](https://github.com/grijjy/GrijjyFoundation).

The source code and related example repository is hosted on GitHub at [https://github.com/grijjy/DelphiCouchbase](https://github.com/grijjy/DelphiCouchbase).

## Introduction to Couchbase
[Couchbase](https://www.couchbase.com/) is a high-performance NoSQL database renowned for it's speed and flexibility.

It combines some of the best aspects of other leading NoSQL databases into a model which is easy to deploy, maintain and scale.  Couchbase offers many things in addition to administrative tools, which are included, they also have solutions for mobile platforms.  Couchbase is widely used in Internet and cloud based apps and services and continues to grow in popularity.

Couchbase isn't directly tied to storing and retrieving JSON, any binary content can be stored and easily retrieved.  However, Couchbase offers subdocument capabilities that provide direct JSON manipulation (much like MongoDB) but doesn't directly tie you to a rigid schema. 

This is by no means an exhaustive look at the benefits of Couchbase.  If you are truly interested there are wealth of [resources online on the how to use Couchbase](https://developer.couchbase.com/).

## Delphi and Couchbase
In order to use Couchbase from Delphi we created a header conversion for the latest C library SDK interface provided by Couchbase.  The C/C++ interface is relatively new, and provides the most common CRUD operations but also provides subdocument APIs for working directly with JSON documents.

The examples here is for Delphi on Windows using a Couchbase remote database running on Linux.  We use [Ubuntu 16.04 LTS](https://www.ubuntu.com/download) for our examples.

## Installing Couchbase Server

Installing the Couchbase server is a fairly straightforward effort thanks to excellent documentation available on their website.  We prefer Ubuntu so the instructions set forth here are focused on that Linux flavor.

Installing Couchbase involves 3 main steps:

1. Install [Ubuntu 16.04 LTS](https://www.ubuntu.com/download).
2. [Download Couchbase Server](https://www.couchbase.com/nosql-databases/downloads#couchbase-server) for Ubuntu (currently 14.04 official)
3. Install Couchbase Server (currently 4.6 pre-release)

### To install Couchbase 4.6 for Ubuntu: 
```shell
sudo dpkg -i couchbase-server-enterprise_4.6.0-DP-ubuntu14.04_amd64.deb
```

### On Ubuntu if you want Couchbase to always start when the system restarts, then type:
```shell
systemctl start couchbase-server
systemctl enable couchbase-server
```

## LibCouchbase

In order to interact with Couchbase from Delphi we use the C/C++ SDK library provided by Couchbase.  The library headers are converted to Delphi and we wrap it in an easy to use Delphi class architecture.

The [pre-compiled libraries for the C SDK](https://developer.couchbase.com/server/other-products/release-notes-archives/c-sdk) for Couchbase can be located under the C SDK section of the website.

For our purposes we are using the *libcouchbase.dll* library contained in the Visual Studio 2012 x86-vc11 library.

## TgoCouchbase Class Architecture

The TgoCouchbase class architecture closely mirrors the API model provided by Couchbase for other APIs such as C/C++ and Python with most of the core operations named the same.

```Delphi
  TgoCouchbase = class(TObject)
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
```

## Connecting to Couchbase

To connect to Couchbase you first create an instance of the TgoCouchbase class and then call ```Connect``` using a Couchbase connection string which in our case is the address of your Couchbase server.

```Delphi
var
  Couchbase := TgoCouchbase.Create;
  ReturnValue: Boolean;
begin
  Couchbase := TgoCouchbase.Create;
  try
    ReturnValue := Couchbase.Connect('couchbase://192.168.1.84');
    if ReturnValue then
    begin
      // Connected
    end
    else
	  Writeln(Couchbase.LastErrorDesc);
  finally
    Couchbase.Free;
  end;
end;
```
If the connection fails you can examine ```Couchbase.LastErrorCode``` and ```Couchbase.LastErrorDesc```.  A list of error codes are provided below. 

## Working with Raw Data

In Couchbase you define whether the data you are working with is RAW binary data or specific JSON document content.  Since we default in our base class to JSON, you need to create a ```TCouchbaseOptions``` record to indicate the data format.  In the case of RAW data you are working with any flexible and dynamic content you decide but you must indicate to the API that it is RAW.

### Upsert
To insert (or update) RAW content to a key.  
```Delphi
var
  CBResult: TCouchbaseResult;
  CBOptions: TCouchbaseOptions;
  AValue: String;
begin
  CBOptions.Initialize;
  CBOptions.Format := TCouchbaseFormat.RAW;
  CBResult := FCouchbase.Upsert('Value', '1', CBOptions);
end;
```
This will set the key of 'Value' to the RAW data '1'.  If the operation succeeds then ```CBResult.Success``` will be ```True```.

### Get
To get RAW content from an existing key.
```Delphi
var
  CBResult: TCouchbaseResult;
  AValue: String;
begin
  CBResult := FCouchbase.Get('Value', AValue);
end;
```
In this example, ```CBResult.Success``` will return ```True``` if everything succeeds, ```CBResult.Format``` will return ```TCouchbaseFormat.RAW``` and ```AValue``` will contain ```'1'```. 

### Incr
To increment the value of an existing key by 1.
```Delphi
var
  CBResult: TCouchbaseResult;
begin
  CBResult := FCouchbase.Incr('Value');
end;
```
In the above example, if ```Value``` was previously set to ```'1'``` it will now become ```'2'```.

### Decr
To decrement the value of an existing key by 1.
```Delphi
var
  CBResult: TCouchbaseResult;
begin
  CBResult := FCouchbase.Decr('Value');
end;
```
In the above example, if ```Value``` was previously set to ```'2'``` it will now become ```'1'```.

### Append
To append RAW content to an existing key.
```Delphi
var
  CBResult: TCouchbaseResult;
begin
  CBResult := FCouchbase.Append('Value', 'DEF');
end;
```
In the above example, assuming ```Value``` was previously set to ```'1'``` it would now contain ```'1DEF'```.

### Prepend
To prepend RAW content to an existing key.
```Delphi
var
  CBResult: TCouchbaseResult;
begin
  CBResult := FCouchbase.Prepend('Value', 'ABC');
end;
```
In the above example, assuming ```Value``` was previously set to ```'1'``` it would now contain ```'ABC1'```.

## TCouchbaseResult 

All core operations return a ```TCouchbaseResult``` that implements the common result operations from Couchbase transactions.

```Delphi
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
  end;
```
The ```Success``` parameter will indicate ```True``` if the operation was successful and ```False``` if it failed.

In the event the operation failed, you can check the ```Error``` value which will correspond to a Couchbase error code.
```Delphi 
  { Error codes }
  LCB_SUCCESS = $00;
  LCB_AUTH_CONTINUE = $01;
  LCB_AUTH_ERROR = $02;
  LCB_DELTA_BADVAL = $03;
  LCB_E2BIG = $04;
  LCB_EBUSY = $05;
  LCB_EINTERNAL = $06;
  LCB_EINVAL = $07;
  LCB_ENOMEM = $08;
  LCB_ERANGE = $09;
  LCB_OTHER_ERROR = $0A;
  LCB_ETMPFAIL = $0B;
  LCB_KEY_EEXISTS = $0C;
  LCB_KEY_ENOENT = $0D;
  LCB_DLOPEN_FAILED = $0E;
  LCB_DLSYM_FAILED = $0F;
  LCB_NETWORK_ERROR = $10;
  LCB_NOT_MY_VBUCKET = $11;
  LCB_NOT_STORED = $12;
  LCB_NOT_SUPPORTED = $13;
  LCB_UNKNOWN_COMMAND = $14;
  LCB_UNKNOWN_HOST = $15;
  LCB_PROTOCOL_ERROR = $16;
  LCB_ETIMEDOUT = $17;
  LCB_CONNECT_ERROR = $18;
  LCB_BUCKET_ENOENT = $19;
  LCB_CLIENT_ENOMEM = $1A;
  LCB_CLIENT_ENOCONF = $1B;
  LCB_EBADHANDLE = $1C;
  LCB_SERVER_BUG = $1D;
  LCB_PLUGIN_VERSION_MISMATCH = $1E;
  LCB_INVALID_HOST_FORMAT = $1F;
  LCB_INVALID_CHAR = $20;
  LCB_DURABILITY_ETOOMANY = $21;
  LCB_DUPLICATE_COMMANDS = $22;
  LCB_NO_MATCHING_SERVER = $23;
  LCB_BAD_ENVIRONMENT = $24;
  LCB_BUSY = $25;
  LCB_INVALID_USERNAME = $26;
  LCB_CONFIG_CACHE_INVALID = $27;
  LCB_SASLMECH_UNAVAILABLE = $28;
  LCB_TOO_MANY_REDIRECTS = $29;
  LCB_MAP_CHANGED = $2A;
  LCB_INCOMPLETE_PACKET = $2B;
  LCB_ECONNREFUSED = $2C;
  LCB_ESOCKSHUTDOWN = $2D;
  LCB_ECONNRESET = $2E;
  LCB_ECANTGETPORT = $2F;
  LCB_EFDLIMITREACHED = $30;
  LCB_ENETUNREACH = $31;
  LCB_ECTL_UNKNOWN = $32;
  LCB_ECTL_UNSUPPMODE = $33;
  LCB_ECTL_BADARG = $34;
  LCB_EMPTY_KEY = $35;
  LCB_SSL_ERROR = $36;
  LCB_SSL_CANTVERIFY = $37;
  LCB_SCHEDFAIL_INTERNAL = $38;
  LCB_CLIENT_FEATURE_UNAVAILABLE = $39;
  LCB_OPTIONS_CONFLICT = $3A;
  LCB_HTTP_ERROR = $3B;
  LCB_DURABILITY_NO_MUTATION_TOKENS = $3C;
  LCB_UNKNOWN_MEMCACHED_ERROR = $3D;
  LCB_MUTATION_LOST = $3E;
  LCB_SUBDOC_PATH_ENOENT = $3F;
  LCB_SUBDOC_PATH_MISMATCH = $40;
  LCB_SUBDOC_PATH_EINVAL = $41;
  LCB_SUBDOC_PATH_E2BIG = $42;
  LCB_SUBDOC_DOC_E2DEEP = $43;
  LCB_SUBDOC_VALUE_CANTINSERT = $44;
  LCB_SUBDOC_DOC_NOTJSON = $45;
  LCB_SUBDOC_NUM_ERANGE = $46;
  LCB_SUBDOC_BAD_DELTA = $47;
  LCB_SUBDOC_PATH_EEXISTS = $48;
  LCB_SUBDOC_MULTI_FAILURE = $49;
  LCB_SUBDOC_VALUE_E2DEEP = $4A;
  LCB_EINVAL_MCD = $4B;
  LCB_EMPTY_PATH = $4C;
  LCB_UNKNOWN_SDCMD = $4D;
  LCB_ENO_COMMANDS = $4E;
  LCB_QUERY_ERROR = $4F;
```

## Working with JSON Documents

Couchbase offers special subdocument APIs designed specifically for manipulating JSON documents.  These APIs operate in a slightly different manner than the RAW APIs and assume the content they are manipulating is valid JSON.

For simplicity sake in Delphi we implement these APIs as an interface ```ICouchbaseSubDoc``` instead of an object class so that we execute operations without the need to destroy objects.  In addition we created the ```ICouchbaseSubDoc``` interface so the result of the various methods are also ```ICouchbaseSubDoc``` so we can build cascading database transactions.

For example, consider the following example JSON:

```JSON
{
  "id": "0001",
  "type": "donut",
  "name": "Cake",
  "number": 1,
  "batters":
    {
      "batter":
        [
          { "id": "1001", "type": "Regular" },
          { "id": "1002", "type": "Chocolate" },
          { "id": "1003", "type": "Blueberry" },
          { "id": "1004", "type": "Devil's Food" }
        ]
    }
}
``` 

### To insert the JSON we would do the following...

```Delphi
var
  CBResult: TCouchbaseResult;
begin
  CBResult := FCouchbase.Upsert('Test', ExampleJson);
end;
```
In the above example we called the ```Upsert``` method to insert or update the key called ```'Test'```with the example JSON above.

### To get a single value from a single name in the JSON we would do the following...
 
```Delphi
var
  CBSubDocResult: TCouchbaseSubDocResult;
begin
  CBSubDocResult := FCouchbase.LookupIn('Test').Get('type').Execute;
  if CBSubDocResult.Success then
    Writeln('type = ' + CBSubDocResult.Responses[0].Value);
end;
```
In the above example we first call the special method ```Couchbase.LookupIn``` which is used for queries of subdocuments (read-only JSON operations) then we ask the key named ```'Test'``` and the JSON name called ```'type'```.

If the subdocument transaction was successful, then ```CBSubDocResult.Success``` returns ```True``` and we receive a ```TArray<TCouchbaseSubDocResponse>```.  It is important to check the Length of this array because transactions can succeed and yield 0 results.

### To get multiple values from a multiple names in the JSON we would do the following...

```Delphi
var
  CBSubDocResult: TCouchbaseSubDocResult;
begin
  CBSubDocResult := FCouchbase.LookupIn('Test').Get('type').Get('name').Execute;
  if CBSubDocResult.Success then
  begin
    Writeln('type = ' + CBSubDocResult.Responses[0].Value);
    Writeln('name = ' + CBSubDocResult.Responses[1].Value);
  end;
end;
```
In the above example we create a cascading transaction of 2 distinct Get operations.  The resulting ```TArray<TCouchbaseSubDocResponse>``` will have a Length of 2 with the respective values for the specified names.

In this way we can cascade many different subdocument operations in a single transaction.  These operations can be of any method that returns ```ICouchbaseSubDoc```.

### To insert a new name and value in the JSON we would do the following...
```
var
  CBSubDocResult: TCouchbaseSubDocResult;
begin
  CBSubDocResult := FCouchbase.MutateIn('Test').Upsert('frosting', '"pink"').Execute;
end;
```
In the above example we call the special method ```Couchbase.MutateIn``` which is used for modifying subdocuments (write JSON operations) then we ask the key named ```'Test'```.  The ```Upsert``` cascading operation inserts a new name called ```'frosting'``` and sets it's value to ```'pink'```. 

I think you probably get the idea by now.   By combining cascading JSON operations into a single transaction you can perform relatively complex operations.

## JSON subdocument methods
The following methods are cascading methods that are used in conjunction with the ```Couchbase.LookupIn``` and ```Couchbase.MutateIn``` methods.

### Get a JSON value
To get a value for a given name in the JSON.
```Delphi
var
  CBSubDocResult: TCouchbaseSubDocResult;
begin
  CBSubDocResult := FCouchbase.LookupIn('Test').Get('type').Execute;
end;
```
### Get a JSON Array
To get an entire JSON array from a given name in the JSON.
```Delphi
var
  CBSubDocResult: TCouchbaseSubDocResult;
begin
  CBSubDocResult := FCouchbase.LookupIn('Test').Get('batters').Execute;
  if CBSubDocResult.Success then
    Writeln(CBSubDocResult.Responses[0].Value);
end;
```
The result ```CBSubDocResult.Responses[0].Value``` would be the JSON... 
```JSON
'{"batter":[{ "id": "1001", "type": "Regular" },{ "id": "1002", "type": "Chocolate" },{ "id": "1003", "type": "Blueberry" },{ "id": "1004", "type": "Devil''s Food" }]}'
```

### Get the value of a JSON array element
To get the JSON value assocated with a JSON array element. 
```Delphi
var
  CBSubDocResult: TCouchbaseSubDocResult;
begin
  CBSubDocResult := FCouchbase.LookupIn('Test').Get('batters.batter[0]').Execute;
end;
```
The result ```CBSubDocResult.Responses[0].Value``` would be the JSON...
```JSON
'{ "id": "1001", "type": "Regular" }'```

### Get the value of a JSON array element value
To get the value of a JSON array element value. 
```Delphi
var
  CBSubDocResult: TCouchbaseSubDocResult;
begin
  CBSubDocResult := FCouchbase.LookupIn('Test').Get('batters.batter[0].id').Execute;
end;
```
The result ```CBSubDocResult.Responses[0].Value``` would be the value ```"1001"```.

### To check whether a JSON name exists
Checking for the existance of a name in the JSON.
```Delphi
var
  CBSubDocResult: TCouchbaseSubDocResult;
begin
  CBSubDocResult := FCouchbase.LookupIn('Test').Exists('number').Execute;
  if CBSubDocResult.Success then
    if CBSubDocResult.Responses[0].Status = LCB_SUCCESS then
      Writeln('The name "number" exists');
end;
```
The above example will return the result ```CBSubDocResult.Responses[0].Status``` of ```LCB_SUCCESS``` if the name exists.

### To get the number of elements of a JSON array
To return the number of elements of a given JSON array.
```Delphi
var
  CBSubDocResult: TCouchbaseSubDocResult;
begin
  CBSubDocResult := FCouchbase.LookupIn('Test').GetCount('batters.batter').Execute; 
end;
```
**Note: The GetCount API does not appear to work correctly in the current pre-release 4.6 Couchbase Server in conjunction with the latest Couchbase APIs. **

### To upsert a new name/value pair into the JSON
```Delphi
var
  CBSubDocResult: TCouchbaseSubDocResult;
begin
  CBSubDocResult := FCouchbase.MutateIn('Test').Upsert('frosting', '"pink"').Execute;
end;
```
The above example will insert a new name called ```'frosting'``` into the JSON and set it's value to ```'pink'```.  The ```Upsert``` method can also modify the existing value associated with a name.

### To insert a new name/value pair into the JSON
```Delphi
var
  CBSubDocResult: TCouchbaseSubDocResult;
begin
  CBSubDocResult := FCouchbase.MutateIn('Test').Insert('frosting', '"pink"').Execute;
end;
```
The Insert method operates much like Upsert, but it will fail if you attempt to insert a name that already matches an existing name.  In the case of failure ```CBSubDocResult.Success``` will return as ```False``` and ```CBSubDocResult.Responses[0].Status``` will return the status of ```LCB_SUBDOC_PATH_EEXISTS```. 

### To replace the value associated with an existing name in the JSON
```Delphi
var
  CBSubDocResult: TCouchbaseSubDocResult;
begin
  CBSubDocResult := FCouchbase.MutateIn('Test').Replace('type', '"yummy"').Execute;
end;
```
In the above example the name ```'type'``` has it's value changed to ```'yummy'```.

### To delete or remove an existing name and value from the JSON
```Delphi
var
  CBSubDocResult: TCouchbaseSubDocResult;
begin
  CBSubDocResult := FCouchbase.MutateIn('Test').Remove('type').Execute;
end;
```
The above example will delete the name/value pair for ```'type'``` from the JSON.

### To append to an array in the JSON
```Delphi
var
  CBSubDocResult: TCouchbaseSubDocResult;
begin
  CBSubDocResult := FCouchbase.MutateIn('Test').ArrayAppend('batters.batter', '{ "id": "1005", "type": "Yummy" }').Execute;
end;
```
The above example simply adds another element to the existing array called ```batters.batter``` in the JSON.  By default the array will be created if it does not exist.  You can override this behavior by setting the ```CreateParent``` parameter to ```False```.

### To prepend to an array in the JSON
Prepending is the same as inserting into the array at the first position with the option of creating the array if it does not already exist.
```Delphi
var
  CBSubDocResult: TCouchbaseSubDocResult;
begin
  CBSubDocResult := FCouchbase.MutateIn('Test').ArrayPrepend('batters.batter', '{ "id": "1000", "type": "Cherry" }').Execute;
end;
```

### To add a unique value to a JSON array 
```Delphi
var
  CBSubDocResult: TCouchbaseSubDocResult;
begin
  CBSubDocResult := FCouchbase.MutateIn('Test').ArrayAddUnique('batters.numbers', '42').Execute;
end;
```
In the above example we create a new array under ```batters``` called ```numbers``` and we add the value ```'42'``` to the array.  If we attempted to add it again ```CBSubDocResult.Success``` would return ```False``` and ```CBSubDocResult.Responses[0].Status``` would indicate the error code ```LCB_SUBDOC_PATH_EEXISTS```.  

### To insert a value into an existing JSON array at a specific position
To indicate the element position to insert into an existing array, you provide the element index. 
```Delphi
var
  CBSubDocResult: TCouchbaseSubDocResult;
begin
  CBSubDocResult := FCouchbase.MutateIn('Test').ArrayInsert('batters.numbers[0]', '41').Execute;
end;
```
You can also use ```[-1]``` as an index if you want to insert into the first position. 

### To increment or decrement the value of a JSON name
```Delphi
var
  CBSubDocResult: TCouchbaseSubDocResult;
begin
  CBSubDocResult := FCouchbase.MutateIn('Test').Counter('Cost', '100').Execute;
  CBSubDocResult := FCouchbase.MutateIn('Test').Counter('Cost', '50').Execute;
end;
```
In the above example, ```Cost``` will initially be set to the value ```100``` but after the second call to Counter ```Cost``` will become the value ```150```.  You can use positive or negative numbers to increment or decrement respectively.

Of course the above example could easily be written as...
```Delphi
  CBSubDocResult := FCouchbase.MutateIn('Test').Counter('Cost', '100').Counter('Cost', '50').Execute;
```

## Creating content that expires
Couchbase includes the concept of expiring content.  If you want your content to delete automatically in the future you set the ExpireTime option when you insert or update the key.

This can be useful when content is temporary, such as cache memory tables or session variables, for example.  

Consider the following example:  
```Delphi
var
  CBResult: TCouchbaseResult;
  CBOptions: TCouchbaseOptions;
  AValue: String;
begin
  CBOptions.Initialize;
  CBOptions.ExpireTime := 1;
  CBResult := FCouchbase.Upsert('Expires', 'Something', CBOptions);
  if CBResult.Success then
  begin
    CBResult := FCouchbase.Get('Expires', AValue);
    // CBResult.Success will be True here
    Sleep(2000);
    CBResult := FCouchbase.Get('Expires', AValue);
    // CBResult.Success will be False here
  end;
end;
```
In the above example we create a key called ```Expires``` that contains ```'Something'``` and we set the option so it expires in one second ```CBOptions.ExpireTime := 1```.  Upon inserting the content and checking for success, the subsequent ```Get``` operation will succeed but after waiting 2 more seconds the ```Get``` operation will fail.  You will also receive ```CBResult.Error = LCB_KEY_ENOENT``` because the key is no longer valid.

To keep your content from expiring and thereby be deleted forever you can use the ```Touch``` method.  This method simply updates the expiration time for the given key.
```Delphi
var
  CBResult: TCouchbaseResult;
begin
  CBResult := FCouchbase.Touch('Expires', 3);
end;
```
In the above example we update the expiration to 3 seconds and restart the countdown.

## Querying Couchbase system statistics 
Internally Couchbase maintains various system statistics that relate to individual nodes and the overall system health.  You can query this information ondemand by using the ```Stats``` method.

```Delphi
var
  CBStatsResult: TCouchbaseStatsResult;
begin
  CBStatsResult := FCouchbase.Stats;
end;
```
The method returns a ```TCouchbaseStatsResult``` record.

```Delphi
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
```

The ```Stats``` method will return ```CouchbaseStatsResult.Success = True``` if the call succeeds.  ```CouchbaseStatsResult.Stats``` is a Dictionary that contains a list of Stat keys and respective values.

To iterate through the various keys you could do the following...
```Delphi
var
  Key: Utf8String;
begin
  for Key in CouchbaseStatsResult.Stats.Keys do
    Writeln(Format('%s %s=%s', [CouchbaseStatsResult.Node, Key, TEncoding.UTF8.GetString(CouchbaseStatsResult.Stats.Items[Key])]));
end;

```

## Database Querying with N1QL
The folks at Couchbase created the [N1QL query language](https://www.couchbase.com/n1ql) so that developers could optionally create SQL like syntax for JSON documents.

```Delphi
var
  CBQueryResult: TCouchbaseQueryResult;
  CBQuery: TgoCouchbaseN1QL;
  CBResult: TCouchbaseResult;
begin
  CBQuery := TgoCouchbaseN1QL.Create;
  CBQuery.SetStatement('SELECT * FROM default USE KEYS ''Test''');
  CBQueryResult := FCouchbase.Query(CBQuery);
  try
    if CBQueryResult.Success then
    begin
      if CBQueryResult.Metrics.ResultCount = 1 then
        Writeln(CBQueryResult.Rows[0]);
    end;
  finally
    CBQueryResult.Finalize;
  end;
  CBQuery.Free;
end;
```
The ```Query``` method returns a ```TCouchbaseQueryResult``` and if ```Success``` is ```True``` the ```Metrics.ResultCount``` will contain the number of ```Rows``` returned. 

For an exhaustive look at the various possibilities and related meta data, see [Couchbase's documentation on N1QL](https://www.couchbase.com/n1ql).

## Unit tests
We have included DUnit unit tests for the various APIs described in this document in the DelphiCouchbase repository on GitHub.

To run the unit tests you need to modify the constant ```CONNECT_STRING``` in the ```TestCouchbase.pas``` source to contain your actual connection string.

```Delphi
  { Connect string for your Couchbase Server instance }
  CONNECT_STRING = 'couchbase://192.168.1.84';
```

## JSON class libraries
This class uses the Grijjy JSON class libraries contained in the [Grijjy Foundation library](https://github.com/grijjy/GrijjyFoundation).

## Conclusion
We hope you enjoy and find useful this base framework for using Couchbase in Delphi and you learn to love the wonderful NoSQL solution Couchbase.

## License
TgoCouchbase and DelphiCouchbase is licensed under the Simplified BSD License. See License.txt for details.  

Grijjy is in no way affiliated with Couchbase.