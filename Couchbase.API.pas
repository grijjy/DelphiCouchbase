unit Couchbase.API;

{ Implementation of the Couchbase library interface }

interface

{ Couchbase }

const
  LCB_CONFIG_MCD_PORT = 11210;
  LCB_CONFIG_MCD_SSL_PORT = 11207;
  LCB_CONFIG_HTTP_PORT = 8091;
  LCB_CONFIG_HTTP_SSL_PORT = 18091;
  LCB_CONFIG_MCCOMPAT_PORT = 11211;

  LCB_TYPE_BUCKET = 0;
  LCB_TYPE_CLUSTER = 1;

  LCB_CONFIG_TRANSPORT_LIST_END = 0;
  LCB_CONFIG_TRANSPORT_HTTP = 1;
  LCB_CONFIG_TRANSPORT_CCCP = LCB_CONFIG_TRANSPORT_HTTP + 1;
  LCB_CONFIG_TRANSPORT_MAX = LCB_CONFIG_TRANSPORT_CCCP + 1;

  LCB_RESP_F_FINAL = $01;
  LCB_RESP_F_CLIENTGEN = $02;
  LCB_RESP_F_NMVGEN = $04;
  LCB_RESP_F_EXTDATA = $08;
  LCB_RESP_F_SDSINGLE = $010;

  LCB_CALLBACK_DEFAULT = 0;
  LCB_CALLBACK_GET = LCB_CALLBACK_DEFAULT + 1;
  LCB_CALLBACK_STORE = LCB_CALLBACK_GET + 1;
  LCB_CALLBACK_COUNTER = LCB_CALLBACK_STORE + 1;
  LCB_CALLBACK_TOUCH = LCB_CALLBACK_COUNTER + 1;
  LCB_CALLBACK_REMOVE = LCB_CALLBACK_TOUCH + 1;
  LCB_CALLBACK_UNLOCK = LCB_CALLBACK_REMOVE + 1;
  LCB_CALLBACK_STATS = LCB_CALLBACK_UNLOCK + 1;
  LCB_CALLBACK_VERSIONS = LCB_CALLBACK_STATS + 1;
  LCB_CALLBACK_VERBOSITY = LCB_CALLBACK_VERSIONS + 1;
  LCB_CALLBACK_FLUSH = LCB_CALLBACK_VERBOSITY + 1;
  LCB_CALLBACK_OBSERVE = LCB_CALLBACK_FLUSH + 1;
  LCB_CALLBACK_GETREPLICA = LCB_CALLBACK_OBSERVE + 1;
  LCB_CALLBACK_ENDURE = LCB_CALLBACK_GETREPLICA + 1;
  LCB_CALLBACK_HTTP = LCB_CALLBACK_ENDURE + 1;
  LCB_CALLBACK_CBFLUSH = LCB_CALLBACK_HTTP + 1;
  LCB_CALLBACK_OBSEQNO = LCB_CALLBACK_CBFLUSH + 1;
  LCB_CALLBACK_STOREDUR = LCB_CALLBACK_OBSEQNO + 1;
  LCB_CALLBACK_SDLOOKUP = LCB_CALLBACK_STOREDUR + 1;
  LCB_CALLBACK_SDMUTATE = LCB_CALLBACK_SDLOOKUP + 1;
  LCB_CALLBACK__MAX = LCB_CALLBACK_SDMUTATE + 1;

  LCB_CALLBACK_VIEWQUERY = -1;
  LCB_CALLBACK_N1QL = -2;
  LCB_CALLBACK_IXMGMT = -3;
  LCB_CMDGET_F_CLEAREXP = 1 shl 16;

  LCB_DURABILITY_MODE_DEFAULT = 0;
  LCB_DURABILITY_MODE_CAS = LCB_DURABILITY_MODE_DEFAULT + 1;
  LCB_DURABILITY_MODE_SEQNO = LCB_DURABILITY_MODE_CAS + 1;

  LCB_CMDENDURE_F_MUTATION_TOKEN = 1 shl 16;
  LCB_DURABILITY_VALIDATE_CAPMAX = 1 shl 1;
  LCB_CMDOBSERVE_F_MASTER_ONLY = 1 shl 16;

  LCB_OBSERVE_FOUND = $00;
  LCB_OBSERVE_PERSISTED = $01;
  LCB_OBSERVE_NOT_FOUND = $80;
  LCB_OBSERVE_LOGICALLY_DELETED = $81;
  LCB_OBSERVE_MAX = $82;

  LCB_CMDSTATS_F_KV = 1 shl 16;

  LCB_CMDHTTP_F_STREAM = 1 shl 16;
  LCB_CMDHTTP_F_CASTMO = 1 shl 17;
  LCB_CMDHTTP_F_NOUPASS = 1 shl 18;

  LCB_DATATYPE_JSON = $01;

  LCB_VALUE_RAW = $00;
  LCB_VALUE_F_JSON = $01;
  LCB_VALUE_F_SNAPPYCOMP = LCB_VALUE_F_JSON + 1;

  LCB_GETNODE_UNAVAILABLE = 'invalid_host:0';

  LCB_TIMEUNIT_NSEC = 0;
  LCB_TIMEUNIT_USEC = 1;
  LCB_TIMEUNIT_MSEC = 2;
  LCB_TIMEUNIT_SEC = 3 ;

  LCB_VERSION_STRING = 'unknown';
  LCB_VERSION = $000000;
  LCB_VERSION_CHANGESET = '$deadbeef';
  LCB_SUPPORTS_SSL = 1;
  LCB_SUPPORTS_SNAPPY = 2;

  LCB_DUMP_VBCONFIG = $01;
  LCB_DUMP_PKTINFO = $02;
  LCB_DUMP_BUFINFO = $04;
  LCB_DUMP_ALL = $FF;

  { Operations }
  LCB_UPSERT = 0;
  LCB_ADD = 1;
  LCB_REPLACE = 2;
  LCB_SET = 3;
  LCB_APPEND = 4;
  LCB_PREPEND = 5;

  { Wait flags }
  LCB_WAIT_DEFAULT = 0;
  LCB_WAIT_NOCHECK = 1;

  { KV buffer types }
  LCB_KV_COPY = 0;
  LCB_KV_CONTIG = 1;
  LCB_KV_IOV = 2;
  LCB_KV_VBID = 3;
  LCB_KV_IOVCOPY = 4;

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

{ N1QL }

const
  LCB_N1P_CONSISTENCY_NONE = 0;
  LCB_N1P_CONSISTENCY_RYOW = 1;
  LCB_N1P_CONSISTENCY_REQUEST = 2;
  LCB_N1P_CONSISTENCY_STATEMENT = 3;

  LCB_CMDN1QL_F_PREPCACHE = 1 shl 16;
  LCB_CMDN1QL_F_JSONQUERY = 1 shl 17;

  LCB_N1P_QUERY_STATEMENT = 1;
  LCB_N1P_QUERY_PREPARED = 2;

type
  lcb_t = Pointer{plcb_st};
  plcb_t = ^lcb_t;
  lcb_http_request_t = Pointer{plcb_http_request_st};
  plcb_http_request_t = ^lcb_http_request_t;

  Lcb_type_t = Integer;

  lcb_create_st0 = record
    host: PAnsiChar;
    user: PAnsiChar;
    passwd: PAnsiChar;
    bucket: PAnsiChar;
    io: Pointer{plcb_io_opt_st};
  end;

  lcb_create_st1 = record
    host: PAnsiChar;
    user: PAnsiChar;
    passwd: PAnsiChar;
    bucket: PAnsiChar;
    io: Pointer{plcb_io_opt_st};
    &type: lcb_type_t;
  end;

  lcb_create_st2 = record
    host: PAnsiChar;
    user: PAnsiChar;
    passwd: PAnsiChar;
    bucket: PAnsiChar;
    io: Pointer{plcb_io_opt_st};
    &type: lcb_type_t;
    mchosts: PAnsiChar;
    transports: Pointer{plcb_config_transport_t};
  end;

  lcb_create_st3 = record
    connstr: PAnsiChar;
    username: PAnsiChar;
    passwd: PAnsiChar;
    _pad_bucket: Pointer;
    io: Pointer{plcb_io_opt_st};
    &type: Lcb_type_t;
  end;
  plcb_create_st3 = ^lcb_create_st3;

  lcb_create_st = record
    version: Integer;
    case Integer of
      0: (v0: lcb_create_st0);
      1: (v1: lcb_create_st1);
      2: (v2: lcb_create_st2);
      3: (v3: lcb_create_st3);
  end;
  plcb_create_st = ^lcb_create_st;

  Lcb_error_t = Integer;
  plcb_error_t = ^lcb_error_t;

  lcb_error = NativeInt;

  size_t = NativeUInt;
  ssize_t = NativeInt;
  time_t = NativeInt;

  lcb_int64_t = int64;
  lcb_int32_t = int32;
  lcb_size_t = size_t;
  lcb_ssize_t = ssize_t;
  lcb_vbucket_t = uint16;
  lcb_uint8_t = uint8;
  lcb_uint16_t = uint16;
  lcb_uint32_t = uint32;
  lcb_cas_t = uint64;
  lcb_uint64_t = uint64;
  lcb_time_t = time_t;

  lcb_S64 = lcb_int64_t;
  lcb_U64 = lcb_uint64_t;
  lcb_U32 = lcb_uint32_t;
  lcb_S32 = lcb_int32_t;
  lcb_U16 = lcb_uint16_t;
  lcb_U8 = lcb_uint8_t;
  lcb_SECS = lcb_time_t;
  plcb_U16 = ^lcb_U16;
  plcb_U32 = ^lcb_U32;

  lcb_datatype_t = lcb_U8;
  lcb_size = size_t;
  lcb_storage_t = Integer;
  lcb_cas = lcb_cas_t;

  lcb_RESPBASE = record
    cookie: Pointer;
    key: Pointer;
    nkey: lcb_size;
    cas: lcb_cas;
    rc: lcb_error_t;
    version: lcb_U16;
    rflags: lcb_U16;
  end;
  plcb_RESPBASE = ^lcb_RESPBASE;

  lcb_RESPSERVERFIELDS = record
    server: PAnsiChar;
  end;

  lcb_RESPSERVERBASE = packed record
    respbase: lcb_RESPBASE;
    respserverfields: lcb_RESPSERVERFIELDS;
  end;
  plcb_RESPSERVERBASE = ^lcb_RESPSERVERBASE;

  Lcb_timeunit_t = Integer;

  lcb_KVBUFTYPE = Integer;

  lcb_CONTIGBUF = record
    bytes: Pointer;
    nbytes: lcb_size_t;
  end;

  lcb_KEYBUF = record
    &type: lcb_KVBUFTYPE;
    contig: lcb_CONTIGBUF;
  end;
  plcb_KEYBUF = ^lcb_KEYBUF;

  lcb_CMDBASE = record
    cmdflags: lcb_U32;
    exptime: lcb_U32;
    cas: lcb_U64;
    key: lcb_KEYBUF;
    _hashkey: lcb_KEYBUF;
  end;
  plcb_CMDBASE = ^lcb_CMDBASE;

  lcb_CMDGET = record
    cmdbase: lcb_CMDBASE;
    lock: Integer;
  end;
  plcb_CMDGET = ^lcb_CMDGET;

  lcb_RESPSTORE = record
    respbase: lcb_RESPBASE;
    op: lcb_storage_t;
  end;
  plcb_RESPSTORE = ^lcb_RESPSTORE;

  lcb_RESPGET = record
    respbase: lcb_RESPBASE;
    value: Pointer;
    nvalue: lcb_size;
    bufh: Pointer;
    datatype: lcb_datatype_t;
    itmflags: lcb_U32;
  end;
  plcb_RESPGET = ^lcb_RESPGET;

  lcb_RESPCOUNTER = record
    respbase: lcb_RESPBASE;
    value: lcb_U64;
  end;
  plcb_RESPCOUNTER = ^lcb_RESPCOUNTER;

  lcb_RESPFLUSH = record
    respserverbase: lcb_RESPSERVERBASE;
  end;
  plcb_RESPFLUSH = ^lcb_RESPFLUSH;

  lcb_RESPSTATS = record
    respserverbase: lcb_RESPSERVERBASE;
    value: PAnsiChar;
    nvalue: lcb_SIZE;
  end;
  plcb_RESPSTATS = ^lcb_RESPSTATS;

  lcb_replica_t = (
    LCB_REPLICA_FIRST = 0,
    LCB_REPLICA_ALL = 1,
    LCB_REPLICA_SELECT = 2);

  lcb_CMDGETREPLICA = record
    cmdbase: lcb_CMDBASE;
    strategy: lcb_replica_t;
    index: Integer;
  end;
  plcb_CMDGETREPLICA = ^lcb_CMDGETREPLICA;

  lcb_FRAGBUF = record
    iov: Pointer{lcb_IOV};
    niov: UInt32;
    total_length: UInt32;
  end;

  lcb_VALBUF = record
    vtype: lcb_KVBUFTYPE;
    case Integer of
      0: (contig: lcb_CONTIGBUF);
      1: (multi: lcb_FRAGBUF);
  end;

  lcb_CMDSTORE = record
    cmdbase: lcb_CMDBASE;
    value: lcb_VALBUF;
    flags: lcb_U32;
    datatype: lcb_datatype_t;
    operation: lcb_storage_t;
  end;
  plcb_CMDSTORE = ^lcb_CMDSTORE;

  lcb_CMDREMOVE = record
    cmdbase: lcb_CMDBASE;
  end;
  plcb_CMDREMOVE = ^lcb_CMDREMOVE;

  lcb_DURABILITYOPTSv0 = record
    timeout: lcb_U32;
    interval: lcb_U32;
    persist_to: lcb_U16;
    replicate_to: lcb_U16;
    check_delete: lcb_U8;
    cap_max: lcb_U8;
    pollopts: lcb_U8;
  end;

  lcb_durability_opts_t = record
    version: Integer;
    case Integer of
      0: (v0: lcb_DURABILITYOPTSv0);
  end;
  plcb_durability_opts_t = ^lcb_durability_opts_t;

  lcb_CMDSTOREDUR = record
    cmdbase: lcb_CMDBASE;
    value: lcb_VALBUF;
    flags: lcb_U32;
    datatype: lcb_datatype_t;
    operation: lcb_storage_t;
    persist_to: Byte;
    replicate_to: Byte;
  end;
  plcb_CMDSTOREDUR = ^lcb_CMDSTOREDUR;

  plcb_MULTICMD_CTX_st = ^TLcb_MULTICMD_CTX_st;
  Pplcb_MULTICMD_CTX_st = ^plcb_MULTICMD_CTX_st;
  TLcb_MULTICMD_CTX_st = record
    addcmd: function(ctx: plcb_MULTICMD_CTX_st; const cmd: plcb_CMDBASE): Lcb_error_t; cdecl;
    done: function(ctx: plcb_MULTICMD_CTX_st; const cookie: Pointer): Lcb_error_t; cdecl;
    fail: procedure(ctx: plcb_MULTICMD_CTX_st); cdecl;
  end;
  Tlcb_MULTICMD_CTX = TLcb_MULTICMD_CTX_st;
  plcb_MULTICMD_CTX = ^TLcb_MULTICMD_CTX;

  lcb_CMDOBSEQNO = record
    cmdbase: lcb_CMDBASE;
    server_index: lcb_U16;
    vbid: lcb_U16;
    uuid: lcb_U64;
  end;
  plcb_CMDOBSEQNO = ^lcb_CMDOBSEQNO;

  lcb_MUTATION_TOKEN = record
    uuid_: lcb_U64;
    seqno_: lcb_U64;
    vbid_: lcb_U16;
  end;
  plcb_MUTATION_TOKEN = ^lcb_MUTATION_TOKEN;

  lcb_CMDCOUNTER = record
    cmdbase: lcb_CMDBASE;
    delta: lcb_int64_t;
    initial: lcb_U64;
    create: Integer;
  end;
  plcb_CMDCOUNTER = ^lcb_CMDCOUNTER;

  lcb_CMDUNLOCK = record
    cmdbase: lcb_CMDBASE;
  end;
  plcb_CMDUNLOCK = ^lcb_CMDUNLOCK;

  lcb_CMDTOUCH = record
    cmdbase: lcb_CMDBASE;
  end;
  plcb_CMDTOUCH = ^lcb_CMDTOUCH;

  lcb_CMDSTATS = record
    cmdbase: lcb_CMDBASE;
  end;
  plcb_CMDSTATS = ^lcb_CMDSTATS;

  lcb_verbosity_level_t = (
    LCB_VERBOSITY_DETAIL = 0,
    LCB_VERBOSITY_DEBUG = 1,
    LCB_VERBOSITY_INFO = 2,
    LCB_VERBOSITY_WARNING = 3);

  lcb_CMDVERBOSITY = record
    cmdbase: lcb_CMDBASE;
    server: PAnsiChar;
    level: lcb_verbosity_level_t;
  end;
  plcb_CMDVERBOSITY = ^lcb_CMDVERBOSITY;

  lcb_CMDCBFLUSH = record
    cmdbase: lcb_CMDBASE;
  end;
  plcb_CMDCBFLUSH = ^lcb_CMDCBFLUSH;

  lcb_CMDFLUSH = record
    cmdbase: lcb_CMDBASE;
  end;
  plcb_CMDFLUSH = ^lcb_CMDFLUSH;

  lcb_http_type_t = (
    LCB_HTTP_TYPE_VIEW = 0,
    LCB_HTTP_TYPE_MANAGEMENT = 1,
    LCB_HTTP_TYPE_RAW = 2,
    LCB_HTTP_TYPE_N1QL = 3,
    LCB_HTTP_TYPE_FTS = 4,
    LCB_HTTP_TYPE_MAX = LCB_HTTP_TYPE_FTS + 1);

  lcb_http_method_t = (
    LCB_HTTP_METHOD_GET = 0,
    LCB_HTTP_METHOD_POST = 1,
    LCB_HTTP_METHOD_PUT = 2,
    LCB_HTTP_METHOD_DELETE = 3,
    LCB_HTTP_METHOD_MAX = 4);

  lcb_CMDHTTP = record
    cmdbase: lcb_CMDBASE;
    &type: lcb_http_type_t;
    method: lcb_http_method_t;
    body: PAnsiChar;
    nbody: lcb_size;
    reqhandle: plcb_http_request_t;
    content_type: PAnsiChar;
    username: PAnsiChar;
    password: PAnsiChar;
    host: PAnsiChar;
  end;
  plcb_CMDHTTP = ^lcb_CMDHTTP;

  lcb_GETNODETYPE = (
    LCB_NODE_HTCONFIG = $01,
    LCB_NODE_DATA = $02,
    LCB_NODE_VIEWS = $04,
    LCB_NODE_CONNECTED = $08,
    LCB_NODE_NEVERNULL = $10,
    LCB_NODE_HTCONFIG_CONNECTED = $09,
    LCB_NODE_HTCONFIG_ANY = $11);

type
  lcb_RESPCALLBACK = procedure(instance: lcb_t; cbtype: Integer; const resp: plcb_RESPBASE); cdecl;

  lcb_bootstrap_callback = procedure(instance: lcb_t; err: Lcb_error_t); cdecl;
  lcb_timings_callback = procedure(instance: Lcb_t; const cookie: Pointer; timeunit: Lcb_timeunit_t; min: Lcb_U32; max: Lcb_U32; total: Lcb_U32; maxtotal: Lcb_U32); cdecl;
  lcb_destroy_callback = procedure(const cookie: Pointer); cdecl;

{ N1QL }
type
  lcb_N1QLHANDLE = Pointer;
  lcb_N1QLPARAMS = Pointer;

  lcb_RESPN1QL = record
    respbase: lcb_RESPBASE;
    row: PAnsiChar;
    nrow: size_t;
    htresp: Pointer{lcb_RESPHTTP};
  end;

  lcb_N1QLCALLBACK = procedure(instance: lcb_t; cbtype: Integer; const resp: lcb_RESPN1QL); cdecl;

  lcb_CMDN1QL = record
    cmdflags: lcb_U32;
    query: PAnsiChar;
    nquery: size_t;
    host: PAnsiChar;
    content_type: PAnsiChar;
    callback: lcb_N1QLCALLBACK;
    handle: lcb_N1QLHANDLE;
  end;
  plcb_CMDN1QL = ^lcb_CMDN1QL;

{ Subdocuments }

const
  LCB_SDCMD_GET = 1;
  LCB_SDCMD_EXISTS = 2;
  LCB_SDCMD_REPLACE = 3;
  LCB_SDCMD_DICT_ADD = 4;
  LCB_SDCMD_DICT_UPSERT = 5;
  LCB_SDCMD_ARRAY_ADD_FIRST = 6;
  LCB_SDCMD_ARRAY_ADD_LAST = 7;
  LCB_SDCMD_ARRAY_ADD_UNIQUE = 8;
  LCB_SDCMD_ARRAY_INSERT = 9;
  LCB_SDCMD_COUNTER = 10;
  LCB_SDCMD_REMOVE = 11;
  LCB_SDCMD_GET_COUNT = 12;
  LCB_SDCMD_MAX = 13;

  LCB_SDSPEC_F_MKINTERMEDIATES = 1 shl 16;
  LCB_SDSPEC_F_MKDOCUMENT = 1 shl 17;

  LCB_SDMULTI_MODE_INVALID = 0;
  LCB_SDMULTI_MODE_LOOKUP = 1;
  LCB_SDMULTI_MODE_MUTATE = 2;

type
  lcb_SUBDOCOP = Integer;

  lcb_SDSPEC = record
    sdcmd: lcb_U32;
    options: lcb_U32;
    path: lcb_KEYBUF;
    value: lcb_VALBUF;
  end;
  plcb_SDSPEC = ^lcb_SDSPEC;

  lcb_CMDSUBDOC = record
    cmdbase: lcb_CMDBASE;
    specs: plcb_SDSPEC;
    nspecs: size_t;
    error_index: pInteger;
    multimode: lcb_U32;
  end;
  plcb_CMDSUBDOC = ^lcb_CMDSUBDOC;

  lcb_RESPSUBDOC = record
    respbase: lcb_RESPBASE;
    responses: Pointer;
    bufh: Pointer;
  end;
  plcb_RESPSUBDOC = ^lcb_RESPSUBDOC;

  lcb_SDENTRY = packed record
    value: Pointer;
    nvalue: size_t;
    status: lcb_error_t;
    index: lcb_U8;
  end;
  plcb_SDENTRY = ^lcb_SDENTRY;

var
  lcb_create: function(instance: plcb_t; const options: plcb_create_st): Lcb_error_t; cdecl = nil;
  lcb_connect: function(instance: lcb_t): Lcb_error_t; cdecl = nil;
  lcb_set_bootstrap_callback: function(instance: lcb_t; callback: lcb_bootstrap_callback): lcb_bootstrap_callback; cdecl = nil;
  lcb_get_bootstrap_status: function(instance: lcb_t): Lcb_error_t; cdecl = nil;
  lcb_install_callback3: function(instance: lcb_t; cbtype: Integer; cb: lcb_RESPCALLBACK): lcb_RESPCALLBACK; cdecl = nil;
  lcb_get_callback3: function(instance: lcb_t; cbtype: Integer): lcb_RESPCALLBACK; cdecl = nil;
  lcb_strcbtype: function(cbtype: Integer): PAnsiChar; cdecl = nil;
  lcb_get3: function(instance: lcb_t; const cookie: Pointer; const cmd: plcb_CMDGET): Lcb_error_t; cdecl = nil;
  lcb_rget3: function(instance: lcb_t; const cookie: Pointer; const cmd: plcb_CMDGETREPLICA): Lcb_error_t; cdecl = nil;
  lcb_store3: function(instance: lcb_t; const cookie: Pointer; const cmd: plcb_CMDSTORE): Lcb_error_t; cdecl = nil;
  lcb_remove3: function(instance: lcb_t; const cookie: Pointer; const cmd: plcb_CMDREMOVE): Lcb_error_t; cdecl = nil;
  lcb_endure3_ctxnew: function(instance: lcb_t; const options: plcb_durability_opts_t; err: plcb_error_t): plcb_MULTICMD_CTX; cdecl = nil;
  lcb_storedur3: function(instance: lcb_t; const cookie: Pointer; const cmd: plcb_CMDSTOREDUR): Lcb_error_t; cdecl = nil;
  lcb_durability_validate: function(instance: lcb_t; persist_to: plcb_U16; replicate_to: plcb_U16; options: Integer): Lcb_error_t; cdecl = nil;
  lcb_observe3_ctxnew: function(instance: lcb_t): plcb_MULTICMD_CTX; cdecl = nil;
  lcb_observe_seqno3: function(instance: lcb_t; const cookie: Pointer; const cmd: plcb_CMDOBSEQNO): Lcb_error_t; cdecl = nil;
  lcb_resp_get_mutation_token: function(cbtype: Integer; const rb: plcb_RESPBASE): plcb_MUTATION_TOKEN; cdecl = nil;
  lcb_get_mutation_token: function(instance: lcb_t; const kb: plcb_KEYBUF; errp: plcb_error_t): plcb_MUTATION_TOKEN; cdecl = nil;
  lcb_counter3: function(instance: lcb_t; const cookie: Pointer; const cmd: plcb_CMDCOUNTER): Lcb_error_t; cdecl = nil;
  lcb_unlock3: function(instance: lcb_t; const cookie: Pointer; const cmd: plcb_CMDUNLOCK): Lcb_error_t; cdecl = nil;
  lcb_touch3: function(instance: lcb_t; const cookie: Pointer; const cmd: plcb_CMDTOUCH): Lcb_error_t; cdecl = nil;
  lcb_stats3: function(instance: lcb_t; const cookie: Pointer; const cmd: plcb_CMDSTATS): Lcb_error_t; cdecl = nil;
  lcb_server_versions3: function(instance: lcb_t; const cookie: Pointer; const cmd: plcb_CMDBASE): Lcb_error_t; cdecl = nil;
  lcb_server_verbosity3: function(instance: lcb_t; const cookie: Pointer; const cmd: plcb_CMDVERBOSITY): Lcb_error_t; cdecl = nil;
  lcb_cbflush3: function(instance: lcb_t; const cookie: Pointer; const cmd: plcb_CMDCBFLUSH): Lcb_error_t; cdecl = nil;
  lcb_flush3: function(instance: lcb_t; const cookie: Pointer; const cmd: plcb_CMDFLUSH): Lcb_error_t; cdecl = nil;
  lcb_http3: function(instance: lcb_t; const cookie: Pointer; const cmd: plcb_CMDHTTP): Lcb_error_t; cdecl = nil;
  lcb_cancel_http_request: procedure(instance: lcb_t; request: lcb_http_request_t); cdecl = nil;
  lcb_set_cookie: procedure(instance: lcb_t; const cookie: Pointer); cdecl = nil;
  lcb_get_cookie: function(instance: lcb_t): Pointer; cdecl = nil;
  lcb_wait: function(instance: lcb_t): Lcb_error_t; cdecl = nil;
  lcb_tick_nowait: function(instance: lcb_t): Lcb_error_t; cdecl = nil;
  lcb_wait3: procedure(instance: lcb_t; flags: Integer); cdecl = nil;
  lcb_breakout: procedure(instance: lcb_t); cdecl = nil;
  lcb_is_waiting: function(instance: lcb_t): Integer; cdecl = nil;
  lcb_refresh_config: procedure(instance: lcb_t); cdecl = nil;
  lcb_sched_enter: procedure(instance: lcb_t); cdecl = nil;
  lcb_sched_leave: procedure(instance: lcb_t); cdecl = nil;
  lcb_sched_fail: procedure(instance: lcb_t); cdecl = nil;
  lcb_sched_flush: procedure(instance: lcb_t); cdecl = nil;
  lcb_destroy: procedure(instance: lcb_t); cdecl = nil;
  lcb_set_destroy_callback: function(p1: lcb_t; p2: Lcb_destroy_callback): Lcb_destroy_callback; cdecl = nil;
  lcb_destroy_async: procedure(instance: lcb_t; const arg: Pointer); cdecl = nil;
  lcb_get_node: function(instance: lcb_t; _type: Lcb_GETNODETYPE; index: Cardinal): PAnsiChar; cdecl = nil;
  lcb_get_keynode: function(instance: lcb_t; const key: Pointer; nkey: SIZE_T): PAnsiChar; cdecl = nil;
  lcb_get_num_replicas: function(instance: lcb_t): Lcb_S32; cdecl = nil;
  lcb_get_num_nodes: function(instance: lcb_t): Lcb_S32; cdecl = nil;
  lcb_get_server_list: function(instance: lcb_t): PPAnsiChar; cdecl = nil;
  lcb_dump: procedure(instance: lcb_t; fp: Pointer; flags: Lcb_U32); cdecl = nil;
  lcb_cntl: function(instance: lcb_t; mode: Integer; cmd: Integer; arg: Pointer): Lcb_error_t; cdecl = nil;
  lcb_cntl_string: function(instance: lcb_t; const key: PAnsiChar; const value: PAnsiChar): Lcb_error_t; cdecl = nil;
  lcb_cntl_setu32: function(instance: lcb_t; cmd: Integer; arg: Lcb_U32): Lcb_error_t; cdecl = nil;
  lcb_cntl_getu32: function(instance: lcb_t; cmd: Integer): Lcb_U32; cdecl = nil;
  lcb_cntl_exists: function(ctl: Integer): Integer; cdecl = nil;
  lcb_enable_timings: function(instance: lcb_t): Lcb_error_t; cdecl = nil;
  lcb_disable_timings: function(instance: lcb_t): Lcb_error_t; cdecl = nil;
  lcb_get_timings: function(instance: lcb_t; const cookie: Pointer; callback: Lcb_timings_callback): Lcb_error_t; cdecl = nil;
  lcb_get_version: function(version: plcb_U32): PAnsiChar; cdecl = nil;
  lcb_supports_feature: function(n: Integer): Integer; cdecl = nil;
  lcb_mem_alloc: function(size: lcb_size): Pointer; cdecl = nil;
  lcb_mem_free: procedure(ptr: Pointer); cdecl = nil;

  { Errors }
  lcb_strerror: function(instance: lcb_t; error: lcb_error_t): PAnsiChar; cdecl = nil;

  { Subdocuments }
  lcb_subdoc3: function(instance: lcb_t; const cookie: Pointer; const cmd: plcb_CMDSUBDOC): lcb_error_t; cdecl = nil;
  lcb_sdresult_next: function(const resp: plcb_RESPSUBDOC; out entry: lcb_SDENTRY; var iter: size_t): Integer; cdecl = nil;

  { N1QL }
  lcb_n1p_new: function: lcb_N1QLPARAMS; cdecl = nil;
  lcb_n1p_reset: procedure(params: lcb_N1QLPARAMS); cdecl = nil;
  lcb_n1p_free: procedure(params: lcb_N1QLPARAMS); cdecl = nil;
  lcb_n1p_setquery: function(params: lcb_N1QLPARAMS; const qstr: PAnsiChar; nqstr: Integer; &type: Integer): lcb_error_t; cdecl = nil;
  lcb_n1p_namedparam: function(params: lcb_N1QLPARAMS; name: PAnsiChar; n_name: size_t; value: PAnsiChar; n_value: size_t): lcb_error_t; cdecl = nil;
  lcb_n1p_posparam: function(params: lcb_N1QLPARAMS; value: PAnsiChar; n_value: size_t): lcb_error_t; cdecl = nil;
  lcb_n1p_setopt: function(params: lcb_N1QLPARAMS; name: PAnsiChar; n_name: size_t; value: PAnsiChar; n_value: size_t): lcb_error_t; cdecl = nil;
  lcb_n1p_setconsistency: function(params: lcb_N1QLPARAMS; mode: Integer): lcb_error_t; cdecl = nil;
  lcb_n1p_setconsistent_token: function(params: lcb_N1QLPARAMS; keyspace: PAnsiChar; const st: lcb_MUTATION_TOKEN): lcb_error_t; cdecl = nil;
  lcb_n1p_setconsistent_handle: function(params: lcb_N1QLPARAMS; instance: lcb_t): lcb_error_t; cdecl = nil;
  lcb_n1p_encode: function(params: lcb_N1QLPARAMS; rc: plcb_error_t): PAnsiChar; cdecl = nil;
  lcb_n1p_mkcmd: function(params: lcb_N1QLPARAMS; cmd: plcb_CMDN1QL): lcb_error_t; cdecl = nil;
  lcb_n1ql_query: function(instance: lcb_t; cookie: Pointer; cmd: plcb_CMDN1QL): lcb_error_t; cdecl = nil;
  lcb_n1ql_cancel: procedure(instance: lcb_t; handle: lcb_N1QLHANDLE); cdecl = nil;

{ Helpers }
procedure LCB_CMD_SET_KEY(var cmdbase: lcb_CMDBASE; keybuf: Pointer; keylen: Integer);
procedure LCB_CMD_SET_VALUE(var scmd: lcb_CMDSTORE; valbuf: Pointer; vallen: Integer);
procedure LCB_SDSPEC_SET_PATH(var spec: lcb_SDSPEC; pathbuf: Pointer; pathlen: Integer);
procedure LCB_SDSPEC_SET_VALUE(var spec: lcb_SDSPEC; valbuf: Pointer; vallen: Integer);

implementation

uses
  {$IFDEF MSWINDOWS}
  Windows,
  {$ENDIF}
  SysUtils;

const
  {$IFDEF MSWINDOWS}
  COUCHBASE_LIBRARY = 'libcouchbase.dll';
  {$ENDIF}

var
  CouchbaseHandle: HMODULE;

{ Helpers }

//#define LCB_CMD_SET_KEY(cmd, keybuf, keylen) \
//        LCB_KREQ_SIMPLE(&(cmd)->key, keybuf, keylen)
//
//#define LCB_KREQ_SIMPLE(req, k, nk) do { \
//    (req)->type = LCB_KV_COPY; \
//    (req)->contig.bytes = k; \
//    (req)->contig.nbytes = nk; \
//} while (0);

procedure LCB_CMD_SET_KEY(var cmdbase: lcb_CMDBASE; keybuf: Pointer; keylen: Integer);
begin
  cmdbase.key.&type := LCB_KV_COPY;
  cmdbase.key.contig.bytes := keybuf;
  cmdbase.key.contig.nbytes := keylen;
end;

//#define LCB_CMD_SET_VALUE(scmd, valbuf, vallen) do { \
//    (scmd)->value.vtype = LCB_KV_COPY; \
//    (scmd)->value.u_buf.contig.bytes = valbuf; \
//    (scmd)->value.u_buf.contig.nbytes = vallen; \
//} while (0);

procedure LCB_CMD_SET_VALUE(var scmd: lcb_CMDSTORE; valbuf: Pointer; vallen: Integer);
begin
  scmd.value.vtype := LCB_KV_COPY;
  scmd.value.contig.bytes := valbuf;
  scmd.value.contig.nbytes := vallen;
end;

//#define LCB_SDSPEC_SET_PATH(s, p, n) do { \
//    (s)->path.contig.bytes = p; \
//    (s)->path.contig.nbytes = n; \
//    (s)->path.type = LCB_KV_COPY; \
//} while (0);

procedure LCB_SDSPEC_SET_PATH(var spec: lcb_SDSPEC; pathbuf: Pointer; pathlen: Integer);
begin
  spec.path.contig.bytes := pathbuf;
  spec.path.contig.nbytes := pathlen;
  spec.path.&type := LCB_KV_COPY;
end;

//#define LCB_SDSPEC_SET_VALUE(s, v, n) \
//    LCB_CMD_SET_VALUE(s, v, n)

procedure LCB_SDSPEC_SET_VALUE(var spec: lcb_SDSPEC; valbuf: Pointer; vallen: Integer);
begin
  spec.value.vtype := LCB_KV_COPY;
  spec.value.contig.bytes := valbuf;
  spec.value.contig.nbytes := vallen;
end;

//#define lcb_n1p_setstmtz(params, qstr) \
//    lcb_n1p_setquery(params, qstr, -1, LCB_N1P_QUERY_STATEMENT)

//#define lcb_n1p_namedparamz(params, name, value) \
//    lcb_n1p_namedparam(params, name, -1, value, -1)

//#define lcb_n1p_setoptz(params, key, value) \
//    lcb_n1p_setopt(params, key, -1, value, -1)

{ Library }

function LoadLib(const ALibFile: String): HMODULE;
begin
  Result := LoadLibrary(PChar(ALibFile));
  if (Result = 0) then
    raise Exception.CreateFmt('load %s failed', [ALibFile]);
end;

function FreeLib(ALibModule: HMODULE): Boolean;
begin
  Result := FreeLibrary(ALibModule);
end;

function GetProc(AModule: HMODULE; const AProcName: String): Pointer;
begin
  Result := GetProcAddress(AModule, PChar(AProcName));
  if (Result = nil) then
    raise Exception.CreateFmt('%s is not found', [AProcName]);
end;

procedure LoadCouchbase;
begin
  if (CouchbaseHandle <> 0) then Exit;
  CouchbaseHandle := LoadLib(COUCHBASE_LIBRARY);
  if (CouchbaseHandle = 0) then
  begin
    raise Exception.CreateFmt('Load %s failed', [COUCHBASE_LIBRARY]);
    Exit;
  end;

  lcb_create := GetProc(CouchbaseHandle, 'lcb_create');
  lcb_connect := GetProc(CouchbaseHandle, 'lcb_connect');
  lcb_set_bootstrap_callback := GetProc(CouchbaseHandle, 'lcb_set_bootstrap_callback');
  lcb_get_bootstrap_status := GetProc(CouchbaseHandle, 'lcb_get_bootstrap_status');
  lcb_install_callback3 := GetProc(CouchbaseHandle, 'lcb_install_callback3');
  lcb_get_callback3 := GetProc(CouchbaseHandle, 'lcb_get_callback3');
  lcb_strcbtype := GetProc(CouchbaseHandle, 'lcb_strcbtype');
  lcb_get3 := GetProc(CouchbaseHandle, 'lcb_get3');
  lcb_rget3 := GetProc(CouchbaseHandle, 'lcb_rget3');
  lcb_store3 := GetProc(CouchbaseHandle, 'lcb_store3');
  lcb_remove3 := GetProc(CouchbaseHandle, 'lcb_remove3');
  lcb_endure3_ctxnew := GetProc(CouchbaseHandle, 'lcb_endure3_ctxnew');
  lcb_storedur3 := GetProc(CouchbaseHandle, 'lcb_storedur3');
  lcb_durability_validate := GetProc(CouchbaseHandle, 'lcb_durability_validate');
  lcb_observe3_ctxnew := GetProc(CouchbaseHandle, 'lcb_observe3_ctxnew');
  lcb_observe_seqno3 := GetProc(CouchbaseHandle, 'lcb_observe_seqno3');
  lcb_resp_get_mutation_token := GetProc(CouchbaseHandle, 'lcb_resp_get_mutation_token');
  lcb_get_mutation_token := GetProc(CouchbaseHandle, 'lcb_get_mutation_token');
  lcb_counter3 := GetProc(CouchbaseHandle, 'lcb_counter3');
  lcb_unlock3 := GetProc(CouchbaseHandle, 'lcb_unlock3');
  lcb_touch3 := GetProc(CouchbaseHandle, 'lcb_touch3');
  lcb_stats3 := GetProc(CouchbaseHandle, 'lcb_stats3');
  lcb_server_versions3 := GetProc(CouchbaseHandle, 'lcb_server_versions3');
  lcb_server_verbosity3 := GetProc(CouchbaseHandle, 'lcb_server_verbosity3');
  lcb_cbflush3 := GetProc(CouchbaseHandle, 'lcb_cbflush3');
  lcb_flush3 := GetProc(CouchbaseHandle, 'lcb_flush3');
  lcb_http3 := GetProc(CouchbaseHandle, 'lcb_http3');
  lcb_cancel_http_request := GetProc(CouchbaseHandle, 'lcb_cancel_http_request');
  lcb_set_cookie := GetProc(CouchbaseHandle, 'lcb_set_cookie');
  lcb_get_cookie := GetProc(CouchbaseHandle, 'lcb_get_cookie');
  lcb_wait := GetProc(CouchbaseHandle, 'lcb_wait');
  lcb_tick_nowait := GetProc(CouchbaseHandle, 'lcb_tick_nowait');
  lcb_wait3 := GetProc(CouchbaseHandle, 'lcb_wait3');
  lcb_breakout := GetProc(CouchbaseHandle, 'lcb_breakout');
  lcb_is_waiting := GetProc(CouchbaseHandle, 'lcb_is_waiting');
  lcb_refresh_config := GetProc(CouchbaseHandle, 'lcb_refresh_config');
  lcb_sched_enter := GetProc(CouchbaseHandle, 'lcb_sched_enter');
  lcb_sched_leave := GetProc(CouchbaseHandle, 'lcb_sched_leave');
  lcb_sched_fail := GetProc(CouchbaseHandle, 'lcb_sched_fail');
  lcb_sched_flush := GetProc(CouchbaseHandle, 'lcb_sched_flush');
  lcb_destroy := GetProc(CouchbaseHandle, 'lcb_destroy');
  lcb_set_destroy_callback := GetProc(CouchbaseHandle, 'lcb_set_destroy_callback');
  lcb_destroy_async := GetProc(CouchbaseHandle, 'lcb_destroy_async');
  lcb_get_node := GetProc(CouchbaseHandle, 'lcb_get_node');
  lcb_get_keynode := GetProc(CouchbaseHandle, 'lcb_get_keynode');
  lcb_get_num_replicas := GetProc(CouchbaseHandle, 'lcb_get_num_replicas');
  lcb_get_num_nodes := GetProc(CouchbaseHandle, 'lcb_get_num_nodes');
  lcb_get_server_list := GetProc(CouchbaseHandle, 'lcb_get_server_list');
  lcb_dump := GetProc(CouchbaseHandle, 'lcb_dump');
  lcb_cntl := GetProc(CouchbaseHandle, 'lcb_cntl');
  lcb_cntl_string := GetProc(CouchbaseHandle, 'lcb_cntl_string');
  lcb_cntl_setu32 := GetProc(CouchbaseHandle, 'lcb_cntl_setu32');
  lcb_cntl_getu32 := GetProc(CouchbaseHandle, 'lcb_cntl_getu32');
  lcb_cntl_exists := GetProc(CouchbaseHandle, 'lcb_cntl_exists');
  lcb_enable_timings := GetProc(CouchbaseHandle, 'lcb_enable_timings');
  lcb_disable_timings := GetProc(CouchbaseHandle, 'lcb_disable_timings');
  lcb_get_timings := GetProc(CouchbaseHandle, 'lcb_get_timings');
  lcb_get_version := GetProc(CouchbaseHandle, 'lcb_get_version');
  lcb_supports_feature := GetProc(CouchbaseHandle, 'lcb_supports_feature');
  lcb_mem_alloc := GetProc(CouchbaseHandle, 'lcb_mem_alloc');
  lcb_mem_free := GetProc(CouchbaseHandle, 'lcb_mem_free');

  { Errors }
  lcb_strerror := GetProc(CouchbaseHandle, 'lcb_strerror');

  { Subdocuments }
  lcb_subdoc3 := GetProc(CouchbaseHandle, 'lcb_subdoc3');
  lcb_sdresult_next := GetProc(CouchbaseHandle, 'lcb_sdresult_next');

  { N1QL }
  lcb_n1p_new := GetProc(CouchbaseHandle, 'lcb_n1p_new');
  lcb_n1p_reset := GetProc(CouchbaseHandle, 'lcb_n1p_reset');
  lcb_n1p_free := GetProc(CouchbaseHandle, 'lcb_n1p_free');
  lcb_n1p_setquery := GetProc(CouchbaseHandle, 'lcb_n1p_setquery');
  lcb_n1p_namedparam := GetProc(CouchbaseHandle, 'lcb_n1p_namedparam');
  lcb_n1p_posparam := GetProc(CouchbaseHandle, 'lcb_n1p_posparam');
  lcb_n1p_setopt := GetProc(CouchbaseHandle, 'lcb_n1p_setopt');
  lcb_n1p_setconsistency := GetProc(CouchbaseHandle, 'lcb_n1p_setconsistency');
  lcb_n1p_setconsistent_token := GetProc(CouchbaseHandle, 'lcb_n1p_setconsistent_token');
  lcb_n1p_setconsistent_handle := GetProc(CouchbaseHandle, 'lcb_n1p_setconsistent_handle');
  lcb_n1p_encode := GetProc(CouchbaseHandle, 'lcb_n1p_encode');
  lcb_n1p_mkcmd := GetProc(CouchbaseHandle, 'lcb_n1p_mkcmd');
  lcb_n1ql_query := GetProc(CouchbaseHandle, 'lcb_n1ql_query');
  lcb_n1ql_cancel := GetProc(CouchbaseHandle, 'lcb_n1ql_cancel');
end;

procedure UnloadCouchbase;
begin
  if (CouchbaseHandle = 0) then Exit;
  FreeLib(CouchbaseHandle);
  CouchbaseHandle := 0;
end;

initialization
  LoadCouchbase;

finalization
  UnloadCouchbase;

end.