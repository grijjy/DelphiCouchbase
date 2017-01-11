program CouchbaseTests;

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  TestCouchbase in 'TestCouchbase.pas',
  Couchbase.API in '..\Couchbase.API.pas',
  Couchbase in '..\Couchbase.pas',
  Grijjy.Bson in '..\..\GrijjyFoundation\Grijjy.Bson.pas',
  Grijjy.SysUtils in '..\..\GrijjyFoundation\Grijjy.SysUtils.pas',
  Grijjy.DateUtils in '..\..\GrijjyFoundation\Grijjy.DateUtils.pas',
  Grijjy.Bson.IO in '..\..\GrijjyFoundation\Grijjy.Bson.IO.pas',
  Grijjy.BinaryCoding in '..\..\GrijjyFoundation\Grijjy.BinaryCoding.pas';

{ R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.

