
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton implementation for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "2.4.1"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1

/* Using locations.  */
#define YYLSP_NEEDED 0



/* Copy the first part of user declarations.  */

/* Line 189 of yacc.c  */
#line 19 "/blur/cpp/lib/sip/sipgen/parser.y"

#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#include "sip.h"


#define MAX_NESTED_IF       10
#define MAX_NESTED_SCOPE    10

#define inMainModule()      (currentSpec->module == currentModule || currentModule->container != NULL)


static sipSpec *currentSpec;            /* The current spec being parsed. */
static stringList *neededQualifiers;    /* The list of required qualifiers. */
static stringList *excludedQualifiers;  /* The list of excluded qualifiers. */
static moduleDef *currentModule;        /* The current module being parsed. */
static mappedTypeDef *currentMappedType;    /* The current mapped type. */
static enumDef *currentEnum;            /* The current enum being parsed. */
static int sectionFlags;                /* The current section flags. */
static int currentOverIsVirt;           /* Set if the overload is virtual. */
static int currentCtorIsExplicit;       /* Set if the ctor is explicit. */
static int currentIsStatic;             /* Set if the current is static. */
static int currentIsSignal;             /* Set if the current is Q_SIGNAL. */
static int currentIsSlot;               /* Set if the current is Q_SLOT. */
static int currentIsTemplate;           /* Set if the current is a template. */
static char *previousFile;              /* The file just parsed. */
static parserContext currentContext;    /* The current context. */
static int skipStackPtr;                /* The skip stack pointer. */
static int skipStack[MAX_NESTED_IF];    /* Stack of skip flags. */
static classDef *scopeStack[MAX_NESTED_SCOPE];  /* The scope stack. */
static int sectFlagsStack[MAX_NESTED_SCOPE];    /* The section flags stack. */
static int currentScopeIdx;             /* The scope stack index. */
static int currentTimelineOrder;        /* The current timeline order. */
static classList *currentSupers;        /* The current super-class list. */
static KwArgs defaultKwArgs;            /* The default keyword arguments support. */
static int makeProtPublic;              /* Treat protected items as public. */
static int parsingCSignature;           /* An explicit C/C++ signature is being parsed. */


static const char *getPythonName(moduleDef *mod, optFlags *optflgs,
        const char *cname);
static classDef *findClass(sipSpec *pt, ifaceFileType iftype,
        apiVersionRangeDef *api_range, scopedNameDef *fqname);
static classDef *findClassWithInterface(sipSpec *pt, ifaceFileDef *iff);
static classDef *newClass(sipSpec *pt, ifaceFileType iftype,
        apiVersionRangeDef *api_range, scopedNameDef *snd);
static void finishClass(sipSpec *, moduleDef *, classDef *, optFlags *);
static exceptionDef *findException(sipSpec *pt, scopedNameDef *fqname, int new);
static mappedTypeDef *newMappedType(sipSpec *,argDef *, optFlags *);
static enumDef *newEnum(sipSpec *pt, moduleDef *mod, mappedTypeDef *mt_scope,
        char *name, optFlags *of, int flags);
static void instantiateClassTemplate(sipSpec *pt, moduleDef *mod, classDef *scope, scopedNameDef *fqname, classTmplDef *tcd, templateDef *td);
static void newTypedef(sipSpec *, moduleDef *, char *, argDef *, optFlags *);
static void newVar(sipSpec *pt, moduleDef *mod, char *name, int isstatic,
        argDef *type, optFlags *of, codeBlock *acode, codeBlock *gcode,
        codeBlock *scode, int section);
static void newCtor(moduleDef *, char *, int, signatureDef *, optFlags *,
        codeBlock *, throwArgs *, signatureDef *, int, codeBlock *);
static void newFunction(sipSpec *, moduleDef *, classDef *, mappedTypeDef *,
        int, int, int, int, int, char *, signatureDef *, int, int, optFlags *,
        codeBlock *, codeBlock *, throwArgs *, signatureDef *, codeBlock *);
static optFlag *findOptFlag(optFlags *flgs, const char *name);
static optFlag *getOptFlag(optFlags *flgs, const char *name, flagType ft);
static memberDef *findFunction(sipSpec *, moduleDef *, classDef *,
        mappedTypeDef *, const char *, int, int, int);
static void checkAttributes(sipSpec *, moduleDef *, classDef *,
        mappedTypeDef *, const char *, int);
static void newModule(FILE *fp, const char *filename);
static moduleDef *allocModule();
static void parseFile(FILE *fp, const char *name, moduleDef *prevmod,
        int optional);
static void handleEOF(void);
static void handleEOM(void);
static qualDef *findQualifier(const char *name);
static const char *getInt(const char *cp, int *ip);
static scopedNameDef *text2scopedName(ifaceFileDef *scope, char *text);
static scopedNameDef *scopeScopedName(ifaceFileDef *scope,
        scopedNameDef *name);
static void pushScope(classDef *);
static void popScope(void);
static classDef *currentScope(void);
static void newQualifier(moduleDef *, int, int, const char *, qualType);
static qualDef *allocQualifier(moduleDef *, int, int, const char *, qualType);
static void newImport(const char *filename);
static int timePeriod(const char *lname, const char *uname);
static int platOrFeature(char *,int);
static int isNeeded(qualDef *);
static int notSkipping(void);
static void getHooks(optFlags *,char **,char **);
static int getTransfer(optFlags *optflgs);
static int getReleaseGIL(optFlags *optflgs);
static int getHoldGIL(optFlags *optflgs);
static int getDeprecated(optFlags *optflgs);
static int getAllowNone(optFlags *optflgs);
static const char *getDocType(optFlags *optflgs);
static const char *getDocValue(optFlags *optflgs);
static void templateSignature(signatureDef *sd, int result, classTmplDef *tcd, templateDef *td, classDef *ncd);
static void templateType(argDef *ad, classTmplDef *tcd, templateDef *td, classDef *ncd);
static int search_back(const char *end, const char *start, const char *target);
static char *type2string(argDef *ad);
static char *scopedNameToString(scopedNameDef *name);
static void addUsedFromCode(sipSpec *pt, ifaceFileList **used, const char *sname);
static int sameName(scopedNameDef *snd, const char *sname);
static int stringFind(stringList *sl, const char *s);
static void setModuleName(sipSpec *pt, moduleDef *mod, const char *fullname);
static int foundInScope(scopedNameDef *fq_name, scopedNameDef *rel_name);
static void defineClass(scopedNameDef *snd, classList *supers, optFlags *of);
static classDef *completeClass(scopedNameDef *snd, optFlags *of, int has_def);
static memberDef *instantiateTemplateMethods(memberDef *tmd, moduleDef *mod);
static void instantiateTemplateEnums(sipSpec *pt, classTmplDef *tcd,
        templateDef *td, classDef *cd, ifaceFileList **used,
        scopedNameDef *type_names, scopedNameDef *type_values);
static void instantiateTemplateVars(sipSpec *pt, classTmplDef *tcd,
        templateDef *td, classDef *cd, ifaceFileList **used,
        scopedNameDef *type_names, scopedNameDef *type_values);
static void instantiateTemplateTypedefs(sipSpec *pt, classTmplDef *tcd,
        templateDef *td, classDef *cd);
static overDef *instantiateTemplateOverloads(sipSpec *pt, overDef *tod,
        memberDef *tmethods, memberDef *methods, classTmplDef *tcd,
        templateDef *td, classDef *cd, ifaceFileList **used,
        scopedNameDef *type_names, scopedNameDef *type_values);
static void resolveAnyTypedef(sipSpec *pt, argDef *ad);
static void addTypedef(sipSpec *pt, typedefDef *tdd);
static void addVariable(sipSpec *pt, varDef *vd);
static void applyTypeFlags(moduleDef *mod, argDef *ad, optFlags *flags);
static argType convertEncoding(const char *encoding);
static apiVersionRangeDef *getAPIRange(optFlags *optflgs);
static apiVersionRangeDef *convertAPIRange(moduleDef *mod, nameDef *name,
        int from, int to);
static char *convertFeaturedString(char *fs);
static scopedNameDef *text2scopePart(char *text);
static KwArgs keywordArgs(moduleDef *mod, optFlags *optflgs, signatureDef *sd,
        int need_name);
static char *strip(char *s);
static int isEnabledFeature(const char *name);
static void addProperty(sipSpec *pt, moduleDef *mod, classDef *cd,
        const char *name, const char *get, const char *set,
        codeBlock *docstring);
static moduleDef *configureModule(sipSpec *pt, moduleDef *module,
        const char *filename, const char *name, int version, int c_module,
        KwArgs kwargs, int use_arg_names, codeBlock *docstring);
static void addAutoPyName(moduleDef *mod, const char *remove_leading);
static KwArgs convertKwArgs(const char *kwargs);
static void checkAnnos(optFlags *annos, const char *valid[]);
static void checkNoAnnos(optFlags *annos, const char *msg);
static void appendCodeBlock(codeBlockList **headp, codeBlock *cb);
static void handleKeepReference(optFlags *optflgs, argDef *ad, moduleDef *mod);


/* Line 189 of yacc.c  */
#line 225 "/blur/cpp/lib/sip/sipgen/parser.c"

/* Enabling traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* Enabling the token table.  */
#ifndef YYTOKEN_TABLE
# define YYTOKEN_TABLE 0
#endif


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     TK_API = 258,
     TK_AUTOPYNAME = 259,
     TK_DEFENCODING = 260,
     TK_PLUGIN = 261,
     TK_DOCSTRING = 262,
     TK_DOC = 263,
     TK_EXPORTEDDOC = 264,
     TK_EXTRACT = 265,
     TK_MAKEFILE = 266,
     TK_ACCESSCODE = 267,
     TK_GETCODE = 268,
     TK_SETCODE = 269,
     TK_PREINITCODE = 270,
     TK_INITCODE = 271,
     TK_POSTINITCODE = 272,
     TK_UNITCODE = 273,
     TK_UNITPOSTINCLUDECODE = 274,
     TK_MODCODE = 275,
     TK_TYPECODE = 276,
     TK_PREPYCODE = 277,
     TK_COPYING = 278,
     TK_MAPPEDTYPE = 279,
     TK_CODELINE = 280,
     TK_IF = 281,
     TK_END = 282,
     TK_NAME_VALUE = 283,
     TK_PATH_VALUE = 284,
     TK_STRING_VALUE = 285,
     TK_VIRTUALCATCHERCODE = 286,
     TK_VIRTERRORHANDLER = 287,
     TK_TRAVERSECODE = 288,
     TK_CLEARCODE = 289,
     TK_GETBUFFERCODE = 290,
     TK_RELEASEBUFFERCODE = 291,
     TK_READBUFFERCODE = 292,
     TK_WRITEBUFFERCODE = 293,
     TK_SEGCOUNTCODE = 294,
     TK_CHARBUFFERCODE = 295,
     TK_PICKLECODE = 296,
     TK_METHODCODE = 297,
     TK_FROMTYPE = 298,
     TK_TOTYPE = 299,
     TK_TOSUBCLASS = 300,
     TK_INCLUDE = 301,
     TK_OPTINCLUDE = 302,
     TK_IMPORT = 303,
     TK_EXPHEADERCODE = 304,
     TK_MODHEADERCODE = 305,
     TK_TYPEHEADERCODE = 306,
     TK_MODULE = 307,
     TK_CMODULE = 308,
     TK_CONSMODULE = 309,
     TK_COMPOMODULE = 310,
     TK_CLASS = 311,
     TK_STRUCT = 312,
     TK_PUBLIC = 313,
     TK_PROTECTED = 314,
     TK_PRIVATE = 315,
     TK_SIGNALS = 316,
     TK_SIGNAL_METHOD = 317,
     TK_SLOTS = 318,
     TK_SLOT_METHOD = 319,
     TK_BOOL = 320,
     TK_SHORT = 321,
     TK_INT = 322,
     TK_LONG = 323,
     TK_FLOAT = 324,
     TK_DOUBLE = 325,
     TK_CHAR = 326,
     TK_WCHAR_T = 327,
     TK_VOID = 328,
     TK_PYOBJECT = 329,
     TK_PYTUPLE = 330,
     TK_PYLIST = 331,
     TK_PYDICT = 332,
     TK_PYCALLABLE = 333,
     TK_PYSLICE = 334,
     TK_PYTYPE = 335,
     TK_VIRTUAL = 336,
     TK_ENUM = 337,
     TK_SIGNED = 338,
     TK_UNSIGNED = 339,
     TK_SCOPE = 340,
     TK_LOGICAL_OR = 341,
     TK_CONST = 342,
     TK_STATIC = 343,
     TK_SIPSIGNAL = 344,
     TK_SIPSLOT = 345,
     TK_SIPANYSLOT = 346,
     TK_SIPRXCON = 347,
     TK_SIPRXDIS = 348,
     TK_SIPSLOTCON = 349,
     TK_SIPSLOTDIS = 350,
     TK_SIPSSIZET = 351,
     TK_NUMBER_VALUE = 352,
     TK_REAL_VALUE = 353,
     TK_TYPEDEF = 354,
     TK_NAMESPACE = 355,
     TK_TIMELINE = 356,
     TK_PLATFORMS = 357,
     TK_FEATURE = 358,
     TK_LICENSE = 359,
     TK_QCHAR_VALUE = 360,
     TK_TRUE_VALUE = 361,
     TK_FALSE_VALUE = 362,
     TK_NULL_VALUE = 363,
     TK_OPERATOR = 364,
     TK_THROW = 365,
     TK_QOBJECT = 366,
     TK_EXCEPTION = 367,
     TK_RAISECODE = 368,
     TK_EXPLICIT = 369,
     TK_TEMPLATE = 370,
     TK_ELLIPSIS = 371,
     TK_DEFMETATYPE = 372,
     TK_DEFSUPERTYPE = 373,
     TK_PROPERTY = 374,
     TK_GET = 375,
     TK_ID = 376,
     TK_KWARGS = 377,
     TK_LANGUAGE = 378,
     TK_LICENSEE = 379,
     TK_NAME = 380,
     TK_OPTIONAL = 381,
     TK_ORDER = 382,
     TK_REMOVELEADING = 383,
     TK_SET = 384,
     TK_SIGNATURE = 385,
     TK_TIMESTAMP = 386,
     TK_TYPE = 387,
     TK_USEARGNAMES = 388,
     TK_VERSION = 389
   };
#endif
/* Tokens.  */
#define TK_API 258
#define TK_AUTOPYNAME 259
#define TK_DEFENCODING 260
#define TK_PLUGIN 261
#define TK_DOCSTRING 262
#define TK_DOC 263
#define TK_EXPORTEDDOC 264
#define TK_EXTRACT 265
#define TK_MAKEFILE 266
#define TK_ACCESSCODE 267
#define TK_GETCODE 268
#define TK_SETCODE 269
#define TK_PREINITCODE 270
#define TK_INITCODE 271
#define TK_POSTINITCODE 272
#define TK_UNITCODE 273
#define TK_UNITPOSTINCLUDECODE 274
#define TK_MODCODE 275
#define TK_TYPECODE 276
#define TK_PREPYCODE 277
#define TK_COPYING 278
#define TK_MAPPEDTYPE 279
#define TK_CODELINE 280
#define TK_IF 281
#define TK_END 282
#define TK_NAME_VALUE 283
#define TK_PATH_VALUE 284
#define TK_STRING_VALUE 285
#define TK_VIRTUALCATCHERCODE 286
#define TK_VIRTERRORHANDLER 287
#define TK_TRAVERSECODE 288
#define TK_CLEARCODE 289
#define TK_GETBUFFERCODE 290
#define TK_RELEASEBUFFERCODE 291
#define TK_READBUFFERCODE 292
#define TK_WRITEBUFFERCODE 293
#define TK_SEGCOUNTCODE 294
#define TK_CHARBUFFERCODE 295
#define TK_PICKLECODE 296
#define TK_METHODCODE 297
#define TK_FROMTYPE 298
#define TK_TOTYPE 299
#define TK_TOSUBCLASS 300
#define TK_INCLUDE 301
#define TK_OPTINCLUDE 302
#define TK_IMPORT 303
#define TK_EXPHEADERCODE 304
#define TK_MODHEADERCODE 305
#define TK_TYPEHEADERCODE 306
#define TK_MODULE 307
#define TK_CMODULE 308
#define TK_CONSMODULE 309
#define TK_COMPOMODULE 310
#define TK_CLASS 311
#define TK_STRUCT 312
#define TK_PUBLIC 313
#define TK_PROTECTED 314
#define TK_PRIVATE 315
#define TK_SIGNALS 316
#define TK_SIGNAL_METHOD 317
#define TK_SLOTS 318
#define TK_SLOT_METHOD 319
#define TK_BOOL 320
#define TK_SHORT 321
#define TK_INT 322
#define TK_LONG 323
#define TK_FLOAT 324
#define TK_DOUBLE 325
#define TK_CHAR 326
#define TK_WCHAR_T 327
#define TK_VOID 328
#define TK_PYOBJECT 329
#define TK_PYTUPLE 330
#define TK_PYLIST 331
#define TK_PYDICT 332
#define TK_PYCALLABLE 333
#define TK_PYSLICE 334
#define TK_PYTYPE 335
#define TK_VIRTUAL 336
#define TK_ENUM 337
#define TK_SIGNED 338
#define TK_UNSIGNED 339
#define TK_SCOPE 340
#define TK_LOGICAL_OR 341
#define TK_CONST 342
#define TK_STATIC 343
#define TK_SIPSIGNAL 344
#define TK_SIPSLOT 345
#define TK_SIPANYSLOT 346
#define TK_SIPRXCON 347
#define TK_SIPRXDIS 348
#define TK_SIPSLOTCON 349
#define TK_SIPSLOTDIS 350
#define TK_SIPSSIZET 351
#define TK_NUMBER_VALUE 352
#define TK_REAL_VALUE 353
#define TK_TYPEDEF 354
#define TK_NAMESPACE 355
#define TK_TIMELINE 356
#define TK_PLATFORMS 357
#define TK_FEATURE 358
#define TK_LICENSE 359
#define TK_QCHAR_VALUE 360
#define TK_TRUE_VALUE 361
#define TK_FALSE_VALUE 362
#define TK_NULL_VALUE 363
#define TK_OPERATOR 364
#define TK_THROW 365
#define TK_QOBJECT 366
#define TK_EXCEPTION 367
#define TK_RAISECODE 368
#define TK_EXPLICIT 369
#define TK_TEMPLATE 370
#define TK_ELLIPSIS 371
#define TK_DEFMETATYPE 372
#define TK_DEFSUPERTYPE 373
#define TK_PROPERTY 374
#define TK_GET 375
#define TK_ID 376
#define TK_KWARGS 377
#define TK_LANGUAGE 378
#define TK_LICENSEE 379
#define TK_NAME 380
#define TK_OPTIONAL 381
#define TK_ORDER 382
#define TK_REMOVELEADING 383
#define TK_SET 384
#define TK_SIGNATURE 385
#define TK_TIMESTAMP 386
#define TK_TYPE 387
#define TK_USEARGNAMES 388
#define TK_VERSION 389




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 214 of yacc.c  */
#line 170 "/blur/cpp/lib/sip/sipgen/parser.y"

    char            qchar;
    char            *text;
    long            number;
    double          real;
    argDef          memArg;
    signatureDef    signature;
    signatureDef    *optsignature;
    throwArgs       *throwlist;
    codeBlock       *codeb;
    valueDef        value;
    valueDef        *valp;
    optFlags        optflags;
    optFlag         flag;
    scopedNameDef   *scpvalp;
    fcallDef        fcall;
    int             boolean;
    exceptionDef    exceptionbase;
    classDef        *klass;
    apiCfg          api;
    autoPyNameCfg   autopyname;
    compModuleCfg   compmodule;
    consModuleCfg   consmodule;
    defEncodingCfg  defencoding;
    defMetatypeCfg  defmetatype;
    defSupertypeCfg defsupertype;
    exceptionCfg    exception;
    extractCfg      extract;
    featureCfg      feature;
    licenseCfg      license;
    importCfg       import;
    includeCfg      include;
    moduleCfg       module;
    pluginCfg       plugin;
    propertyCfg     property;
    variableCfg     variable;



/* Line 214 of yacc.c  */
#line 569 "/blur/cpp/lib/sip/sipgen/parser.c"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif


/* Copy the second part of user declarations.  */


/* Line 264 of yacc.c  */
#line 581 "/blur/cpp/lib/sip/sipgen/parser.c"

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#elif (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
typedef signed char yytype_int8;
#else
typedef short int yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(msgid) dgettext ("bison-runtime", msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(msgid) msgid
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(e) ((void) (e))
#else
# define YYUSE(e) /* empty */
#endif

/* Identity function, used to suppress warnings about constant conditions.  */
#ifndef lint
# define YYID(n) (n)
#else
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static int
YYID (int yyi)
#else
static int
YYID (yyi)
    int yyi;
#endif
{
  return yyi;
}
#endif

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#     ifndef _STDLIB_H
#      define _STDLIB_H 1
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's `empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (YYID (0))
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined _STDLIB_H \
       && ! ((defined YYMALLOC || defined malloc) \
	     && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef _STDLIB_H
#    define _STDLIB_H 1
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
	 || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

/* Copy COUNT objects from FROM to TO.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(To, From, Count) \
      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
#  else
#   define YYCOPY(To, From, Count)		\
      do					\
	{					\
	  YYSIZE_T yyi;				\
	  for (yyi = 0; yyi < (Count); yyi++)	\
	    (To)[yyi] = (From)[yyi];		\
	}					\
      while (YYID (0))
#  endif
# endif

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)				\
    do									\
      {									\
	YYSIZE_T yynewbytes;						\
	YYCOPY (&yyptr->Stack_alloc, Stack, yysize);			\
	Stack = &yyptr->Stack_alloc;					\
	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
	yyptr += yynewbytes / sizeof (*yyptr);				\
      }									\
    while (YYID (0))

#endif

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  4
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   1541

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  157
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  221
/* YYNRULES -- Number of rules.  */
#define YYNRULES  518
/* YYNRULES -- Number of states.  */
#define YYNSTATES  906

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   389

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,   142,     2,     2,     2,   155,   147,     2,
     135,   136,   145,   144,   137,   143,     2,   146,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,   152,   141,
     150,   138,   151,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,   153,     2,   154,   156,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,   139,   148,   140,   149,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    60,    61,    62,    63,    64,
      65,    66,    67,    68,    69,    70,    71,    72,    73,    74,
      75,    76,    77,    78,    79,    80,    81,    82,    83,    84,
      85,    86,    87,    88,    89,    90,    91,    92,    93,    94,
      95,    96,    97,    98,    99,   100,   101,   102,   103,   104,
     105,   106,   107,   108,   109,   110,   111,   112,   113,   114,
     115,   116,   117,   118,   119,   120,   121,   122,   123,   124,
     125,   126,   127,   128,   129,   130,   131,   132,   133,   134
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const yytype_uint16 yyprhs[] =
{
       0,     0,     3,     5,     8,     9,    12,    14,    16,    18,
      20,    22,    24,    26,    28,    30,    32,    34,    36,    38,
      40,    42,    44,    46,    48,    50,    52,    54,    56,    58,
      60,    62,    64,    66,    68,    70,    72,    74,    76,    78,
      80,    82,    84,    86,    88,    90,    92,    94,    96,    98,
     100,   102,   105,   107,   111,   113,   117,   121,   124,   126,
     130,   132,   136,   140,   143,   146,   150,   152,   156,   160,
     164,   170,   171,   175,   180,   182,   185,   187,   189,   191,
     193,   196,   197,   203,   204,   211,   216,   218,   221,   223,
     225,   227,   229,   232,   235,   237,   239,   253,   254,   260,
     261,   265,   267,   270,   271,   277,   279,   282,   285,   287,
     290,   292,   296,   298,   302,   306,   307,   313,   315,   318,
     320,   325,   327,   330,   334,   339,   341,   345,   347,   351,
     352,   354,   358,   360,   364,   368,   372,   376,   380,   383,
     385,   389,   391,   395,   399,   402,   404,   408,   410,   414,
     418,   422,   424,   428,   430,   434,   438,   439,   444,   446,
     449,   451,   453,   455,   459,   461,   465,   467,   471,   475,
     476,   481,   483,   486,   488,   490,   492,   496,   500,   503,
     507,   509,   513,   517,   521,   525,   529,   533,   534,   539,
     541,   544,   546,   548,   550,   552,   554,   556,   557,   559,
     562,   564,   568,   570,   574,   578,   582,   585,   588,   590,
     594,   596,   600,   604,   605,   608,   609,   612,   613,   616,
     619,   622,   625,   628,   631,   634,   637,   640,   643,   646,
     649,   652,   655,   658,   661,   664,   667,   670,   673,   676,
     679,   682,   685,   688,   692,   694,   698,   702,   706,   708,
     712,   714,   718,   722,   726,   731,   734,   736,   739,   740,
     749,   750,   752,   753,   755,   756,   758,   760,   763,   765,
     767,   772,   773,   775,   776,   779,   780,   783,   785,   789,
     791,   793,   795,   797,   799,   801,   802,   804,   806,   808,
     810,   813,   815,   819,   821,   823,   825,   827,   832,   834,
     836,   838,   840,   842,   844,   845,   847,   851,   857,   869,
     870,   871,   880,   881,   885,   890,   891,   892,   901,   902,
     905,   907,   911,   913,   914,   918,   920,   923,   925,   927,
     929,   931,   933,   935,   937,   939,   941,   943,   945,   947,
     949,   951,   953,   955,   957,   959,   961,   963,   965,   967,
     969,   971,   974,   977,   981,   985,   989,   992,   996,  1000,
    1002,  1006,  1010,  1014,  1018,  1019,  1024,  1026,  1029,  1031,
    1033,  1035,  1036,  1038,  1050,  1051,  1055,  1057,  1068,  1069,
    1070,  1077,  1078,  1079,  1087,  1088,  1090,  1105,  1113,  1128,
    1142,  1144,  1146,  1148,  1150,  1152,  1154,  1156,  1158,  1161,
    1164,  1167,  1170,  1173,  1176,  1179,  1182,  1185,  1188,  1192,
    1196,  1198,  1201,  1204,  1206,  1209,  1212,  1215,  1217,  1220,
    1221,  1223,  1224,  1227,  1228,  1232,  1234,  1238,  1240,  1244,
    1246,  1252,  1254,  1256,  1259,  1260,  1262,  1263,  1266,  1267,
    1270,  1272,  1273,  1275,  1279,  1284,  1289,  1294,  1298,  1302,
    1309,  1316,  1320,  1323,  1324,  1328,  1329,  1333,  1335,  1336,
    1340,  1342,  1344,  1346,  1347,  1351,  1353,  1362,  1363,  1367,
    1369,  1372,  1374,  1376,  1379,  1382,  1385,  1390,  1394,  1398,
    1399,  1401,  1402,  1405,  1407,  1412,  1415,  1418,  1420,  1422,
    1425,  1427,  1429,  1432,  1435,  1439,  1441,  1443,  1445,  1448,
    1451,  1453,  1455,  1457,  1459,  1461,  1463,  1465,  1467,  1469,
    1471,  1473,  1475,  1477,  1481,  1482,  1487,  1488,  1490
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int16 yyrhs[] =
{
     158,     0,    -1,   159,    -1,   158,   159,    -1,    -1,   160,
     161,    -1,   236,    -1,   222,    -1,   229,    -1,   167,    -1,
     257,    -1,   245,    -1,   249,    -1,   250,    -1,   171,    -1,
     202,    -1,   193,    -1,   198,    -1,   210,    -1,   163,    -1,
     214,    -1,   218,    -1,   258,    -1,   259,    -1,   270,    -1,
     272,    -1,   273,    -1,   274,    -1,   275,    -1,   276,    -1,
     277,    -1,   278,    -1,   279,    -1,   284,    -1,   288,    -1,
     181,    -1,   183,    -1,   162,    -1,   196,    -1,   206,    -1,
     209,    -1,   189,    -1,   311,    -1,   317,    -1,   314,    -1,
     175,    -1,   310,    -1,   291,    -1,   343,    -1,   366,    -1,
     260,    -1,     5,   164,    -1,    30,    -1,   135,   165,   136,
      -1,   166,    -1,   165,   137,   166,    -1,   125,   138,    30,
      -1,     6,   168,    -1,    28,    -1,   135,   169,   136,    -1,
     170,    -1,   169,   137,   170,    -1,   125,   138,    28,    -1,
       3,   172,    -1,    28,    97,    -1,   135,   173,   136,    -1,
     174,    -1,   173,   137,   174,    -1,   125,   138,    28,    -1,
     134,   138,    97,    -1,   112,   305,   176,   347,   177,    -1,
      -1,   135,   305,   136,    -1,   139,   178,   140,   141,    -1,
     179,    -1,   178,   179,    -1,   206,    -1,   209,    -1,   180,
      -1,   260,    -1,   113,   289,    -1,    -1,    24,   374,   347,
     182,   185,    -1,    -1,   316,    24,   374,   347,   184,   185,
      -1,   139,   186,   140,   141,    -1,   187,    -1,   186,   187,
      -1,   206,    -1,   209,    -1,   260,    -1,   271,    -1,    43,
     289,    -1,    44,   289,    -1,   291,    -1,   188,    -1,    88,
     370,    28,   135,   355,   136,   345,   376,   347,   340,   141,
     352,   353,    -1,    -1,   100,    28,   190,   191,   141,    -1,
      -1,   139,   192,   140,    -1,   162,    -1,   192,   162,    -1,
      -1,   102,   194,   139,   195,   140,    -1,   197,    -1,   195,
     197,    -1,    32,    28,    -1,    28,    -1,   103,   199,    -1,
      28,    -1,   135,   200,   136,    -1,   201,    -1,   200,   137,
     201,    -1,   125,   138,    28,    -1,    -1,   101,   203,   139,
     204,   140,    -1,   205,    -1,   204,   205,    -1,    28,    -1,
      26,   135,   208,   136,    -1,    28,    -1,   142,    28,    -1,
     207,    86,    28,    -1,   207,    86,   142,    28,    -1,   207,
      -1,   294,   143,   294,    -1,    27,    -1,   104,   211,   347,
      -1,    -1,    30,    -1,   135,   212,   136,    -1,   213,    -1,
     212,   137,   213,    -1,   132,   138,    30,    -1,   124,   138,
      30,    -1,   130,   138,    30,    -1,   131,   138,    30,    -1,
     117,   215,    -1,   243,    -1,   135,   216,   136,    -1,   217,
      -1,   216,   137,   217,    -1,   125,   138,   243,    -1,   118,
     219,    -1,   243,    -1,   135,   220,   136,    -1,   221,    -1,
     220,   137,   221,    -1,   125,   138,   243,    -1,    54,   223,
     226,    -1,   243,    -1,   135,   224,   136,    -1,   225,    -1,
     224,   137,   225,    -1,   125,   138,   243,    -1,    -1,   139,
     227,   140,   141,    -1,   228,    -1,   227,   228,    -1,   206,
      -1,   209,    -1,   351,    -1,    55,   230,   233,    -1,   243,
      -1,   135,   231,   136,    -1,   232,    -1,   231,   137,   232,
      -1,   125,   138,   243,    -1,    -1,   139,   234,   140,   141,
      -1,   235,    -1,   234,   235,    -1,   206,    -1,   209,    -1,
     351,    -1,    52,   237,   240,    -1,    53,   243,   244,    -1,
     243,   244,    -1,   135,   238,   136,    -1,   239,    -1,   238,
     137,   239,    -1,   122,   138,    30,    -1,   123,   138,    30,
      -1,   125,   138,   243,    -1,   133,   138,   307,    -1,   134,
     138,    97,    -1,    -1,   139,   241,   140,   141,    -1,   242,
      -1,   241,   242,    -1,   206,    -1,   209,    -1,   280,    -1,
     351,    -1,    28,    -1,    29,    -1,    -1,    97,    -1,    46,
     246,    -1,    29,    -1,   135,   247,   136,    -1,   248,    -1,
     247,   137,   248,    -1,   125,   138,    29,    -1,   126,   138,
     307,    -1,    47,    29,    -1,    48,   251,    -1,    29,    -1,
     135,   252,   136,    -1,   253,    -1,   252,   137,   253,    -1,
     125,   138,    29,    -1,    -1,    12,   289,    -1,    -1,    13,
     289,    -1,    -1,    14,   289,    -1,    23,   289,    -1,    49,
     289,    -1,    50,   289,    -1,    51,   289,    -1,    33,   289,
      -1,    34,   289,    -1,    35,   289,    -1,    36,   289,    -1,
      37,   289,    -1,    38,   289,    -1,    39,   289,    -1,    40,
     289,    -1,    41,   289,    -1,    20,   289,    -1,    21,   289,
      -1,    15,   289,    -1,    16,   289,    -1,    17,   289,    -1,
      18,   289,    -1,    19,   289,    -1,    22,   289,    -1,     8,
     289,    -1,     9,   289,    -1,     4,   281,    -1,   135,   282,
     136,    -1,   283,    -1,   282,   137,   283,    -1,   128,   138,
      30,    -1,    10,   285,   289,    -1,    28,    -1,   135,   286,
     136,    -1,   287,    -1,   286,   137,   287,    -1,   121,   138,
      28,    -1,   127,   138,    97,    -1,    11,    29,   293,   289,
      -1,   290,    27,    -1,    25,    -1,   290,    25,    -1,    -1,
      82,   294,   347,   292,   139,   295,   140,   141,    -1,    -1,
      29,    -1,    -1,    28,    -1,    -1,   296,    -1,   297,    -1,
     296,   297,    -1,   206,    -1,   209,    -1,    28,   299,   347,
     298,    -1,    -1,   137,    -1,    -1,   138,   304,    -1,    -1,
     138,   301,    -1,   304,    -1,   301,   302,   304,    -1,   143,
      -1,   144,    -1,   145,    -1,   146,    -1,   147,    -1,   148,
      -1,    -1,   142,    -1,   149,    -1,   143,    -1,   144,    -1,
     303,   308,    -1,   306,    -1,   305,    85,   306,    -1,    28,
      -1,   106,    -1,   107,    -1,   305,    -1,   374,   135,   309,
     136,    -1,    98,    -1,    97,    -1,   307,    -1,   108,    -1,
      30,    -1,   105,    -1,    -1,   301,    -1,   309,   137,   301,
      -1,    99,   370,    28,   347,   141,    -1,    99,   370,   135,
     373,    28,   136,   135,   375,   136,   347,   141,    -1,    -1,
      -1,    57,   305,   312,   320,   347,   313,   323,   141,    -1,
      -1,   316,   315,   317,    -1,   115,   150,   375,   151,    -1,
      -1,    -1,    56,   305,   318,   320,   347,   319,   323,   141,
      -1,    -1,   152,   321,    -1,   322,    -1,   321,   137,   322,
      -1,   305,    -1,    -1,   139,   324,   140,    -1,   325,    -1,
     324,   325,    -1,   206,    -1,   209,    -1,   189,    -1,   311,
      -1,   317,    -1,   175,    -1,   310,    -1,   291,    -1,   326,
      -1,   351,    -1,   271,    -1,   260,    -1,   261,    -1,   262,
      -1,   263,    -1,   264,    -1,   265,    -1,   266,    -1,   267,
      -1,   268,    -1,   269,    -1,   335,    -1,   334,    -1,   358,
      -1,    45,   289,    -1,    44,   289,    -1,    58,   333,   152,
      -1,    59,   333,   152,    -1,    60,   333,   152,    -1,    61,
     152,    -1,   119,   327,   330,    -1,   135,   328,   136,    -1,
     329,    -1,   328,   137,   329,    -1,   120,   138,    28,    -1,
     125,   138,    28,    -1,   129,   138,    28,    -1,    -1,   139,
     331,   140,   141,    -1,   332,    -1,   331,   332,    -1,   206,
      -1,   209,    -1,   351,    -1,    -1,    63,    -1,   342,   149,
      28,   135,   136,   376,   346,   347,   141,   353,   354,    -1,
      -1,   114,   336,   337,    -1,   337,    -1,    28,   135,   355,
     136,   376,   347,   338,   141,   352,   353,    -1,    -1,    -1,
     153,   339,   135,   355,   136,   154,    -1,    -1,    -1,   153,
     341,   370,   135,   355,   136,   154,    -1,    -1,    81,    -1,
     370,    28,   135,   355,   136,   345,   376,   346,   347,   340,
     141,   352,   353,   354,    -1,   370,   109,   138,   135,   370,
     136,   141,    -1,   370,   109,   344,   135,   355,   136,   345,
     376,   346,   347,   340,   141,   353,   354,    -1,   109,   370,
     135,   355,   136,   345,   376,   346,   347,   340,   141,   353,
     354,    -1,   144,    -1,   143,    -1,   145,    -1,   146,    -1,
     155,    -1,   147,    -1,   148,    -1,   156,    -1,   150,   150,
      -1,   151,   151,    -1,   144,   138,    -1,   143,   138,    -1,
     145,   138,    -1,   146,   138,    -1,   155,   138,    -1,   147,
     138,    -1,   148,   138,    -1,   156,   138,    -1,   150,   150,
     138,    -1,   151,   151,   138,    -1,   149,    -1,   135,   136,
      -1,   153,   154,    -1,   150,    -1,   150,   138,    -1,   138,
     138,    -1,   142,   138,    -1,   151,    -1,   151,   138,    -1,
      -1,    87,    -1,    -1,   138,    97,    -1,    -1,   146,   348,
     146,    -1,   349,    -1,   348,   137,   349,    -1,    28,    -1,
      28,   138,   350,    -1,   243,    -1,    28,   152,   244,   143,
     244,    -1,    30,    -1,    97,    -1,     7,   289,    -1,    -1,
     351,    -1,    -1,    42,   289,    -1,    -1,    31,   289,    -1,
     356,    -1,    -1,   357,    -1,   356,   137,   357,    -1,    89,
     294,   347,   300,    -1,    90,   294,   347,   300,    -1,    91,
     294,   347,   300,    -1,    92,   294,   347,    -1,    93,   294,
     347,    -1,    94,   135,   355,   136,   294,   347,    -1,    95,
     135,   355,   136,   294,   347,    -1,   111,   294,   347,    -1,
     371,   300,    -1,    -1,    62,   359,   361,    -1,    -1,    64,
     360,   361,    -1,   361,    -1,    -1,    88,   362,   363,    -1,
     363,    -1,   364,    -1,   366,    -1,    -1,    81,   365,   343,
      -1,   343,    -1,   370,    28,   347,   367,   141,   254,   255,
     256,    -1,    -1,   139,   368,   140,    -1,   369,    -1,   368,
     369,    -1,   206,    -1,   209,    -1,    12,   289,    -1,    13,
     289,    -1,    14,   289,    -1,    87,   374,   373,   372,    -1,
     374,   373,   372,    -1,   370,   294,   347,    -1,    -1,   147,
      -1,    -1,   373,   145,    -1,   305,    -1,   305,   150,   375,
     151,    -1,    57,   305,    -1,    84,    66,    -1,    66,    -1,
      84,    -1,    84,    67,    -1,    67,    -1,    68,    -1,    84,
      68,    -1,    68,    68,    -1,    84,    68,    68,    -1,    69,
      -1,    70,    -1,    65,    -1,    83,    71,    -1,    84,    71,
      -1,    71,    -1,    72,    -1,    73,    -1,    74,    -1,    75,
      -1,    76,    -1,    77,    -1,    78,    -1,    79,    -1,    80,
      -1,    96,    -1,   116,    -1,   370,    -1,   375,   137,   370,
      -1,    -1,   110,   135,   377,   136,    -1,    -1,   305,    -1,
     377,   137,   305,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   488,   488,   489,   492,   492,   511,   512,   513,   514,
     515,   516,   517,   518,   519,   520,   521,   522,   523,   524,
     525,   526,   527,   528,   529,   530,   531,   532,   533,   534,
     535,   536,   537,   538,   539,   540,   541,   542,   543,   546,
     547,   548,   549,   550,   551,   552,   553,   554,   555,   556,
     557,   570,   579,   584,   589,   590,   600,   607,   615,   620,
     625,   626,   636,   643,   669,   677,   682,   683,   694,   700,
     708,   758,   762,   836,   841,   842,   853,   856,   859,   871,
     885,   890,   890,   909,   909,   968,   982,   983,   986,   987,
     988,   992,   996,  1005,  1014,  1015,  1018,  1032,  1032,  1069,
    1070,  1073,  1074,  1077,  1077,  1106,  1107,  1110,  1115,  1120,
    1127,  1132,  1137,  1138,  1148,  1155,  1155,  1181,  1182,  1185,
    1191,  1204,  1207,  1210,  1213,  1218,  1219,  1224,  1230,  1267,
    1275,  1281,  1286,  1287,  1300,  1308,  1316,  1324,  1334,  1345,
    1350,  1355,  1356,  1366,  1373,  1384,  1389,  1394,  1395,  1405,
    1412,  1430,  1435,  1440,  1441,  1451,  1458,  1462,  1467,  1468,
    1478,  1481,  1484,  1498,  1516,  1521,  1526,  1527,  1537,  1544,
    1548,  1553,  1554,  1564,  1567,  1570,  1584,  1594,  1604,  1616,
    1621,  1622,  1636,  1645,  1660,  1669,  1678,  1692,  1696,  1701,
    1702,  1712,  1715,  1718,  1721,  1735,  1736,  1752,  1755,  1758,
    1767,  1773,  1778,  1779,  1790,  1796,  1804,  1812,  1818,  1823,
    1828,  1829,  1839,  1846,  1849,  1854,  1857,  1862,  1865,  1870,
    1876,  1882,  1888,  1893,  1898,  1903,  1908,  1913,  1918,  1923,
    1928,  1933,  1938,  1944,  1949,  1955,  1961,  1967,  1973,  1979,
    1984,  1990,  1996,  2002,  2007,  2008,  2018,  2025,  2034,  2040,
    2045,  2046,  2057,  2063,  2074,  2079,  2082,  2083,  2094,  2094,
    2113,  2116,  2121,  2124,  2129,  2130,  2133,  2134,  2137,  2138,
    2139,  2175,  2176,  2179,  2180,  2183,  2186,  2191,  2192,  2210,
    2213,  2216,  2219,  2222,  2225,  2230,  2233,  2236,  2239,  2242,
    2247,  2265,  2266,  2274,  2279,  2282,  2287,  2296,  2306,  2310,
    2314,  2318,  2322,  2326,  2332,  2337,  2343,  2361,  2378,  2413,
    2419,  2413,  2452,  2452,  2478,  2483,  2489,  2483,  2519,  2520,
    2523,  2524,  2527,  2566,  2569,  2574,  2575,  2578,  2579,  2580,
    2581,  2582,  2583,  2584,  2585,  2586,  2587,  2591,  2595,  2599,
    2610,  2621,  2632,  2643,  2654,  2665,  2676,  2687,  2698,  2699,
    2700,  2701,  2712,  2723,  2730,  2737,  2744,  2753,  2766,  2771,
    2772,  2784,  2791,  2798,  2807,  2811,  2816,  2817,  2827,  2830,
    2833,  2847,  2850,  2855,  2917,  2917,  2918,  2921,  2964,  2967,
    2967,  2978,  2981,  2981,  2993,  2996,  3001,  3019,  3039,  3075,
    3156,  3157,  3158,  3159,  3160,  3161,  3162,  3163,  3164,  3165,
    3166,  3167,  3168,  3169,  3170,  3171,  3172,  3173,  3174,  3175,
    3176,  3177,  3178,  3179,  3180,  3181,  3182,  3183,  3184,  3187,
    3190,  3195,  3198,  3206,  3209,  3215,  3219,  3231,  3235,  3241,
    3245,  3268,  3272,  3278,  3283,  3286,  3289,  3292,  3297,  3300,
    3305,  3353,  3358,  3364,  3391,  3402,  3413,  3424,  3442,  3452,
    3468,  3484,  3492,  3499,  3499,  3500,  3500,  3501,  3505,  3505,
    3506,  3510,  3511,  3515,  3515,  3516,  3519,  3571,  3577,  3582,
    3583,  3595,  3598,  3601,  3616,  3631,  3648,  3653,  3667,  3760,
    3763,  3771,  3774,  3779,  3787,  3798,  3813,  3817,  3821,  3825,
    3829,  3833,  3837,  3841,  3845,  3849,  3853,  3857,  3861,  3865,
    3869,  3873,  3877,  3881,  3885,  3889,  3893,  3897,  3901,  3905,
    3909,  3913,  3919,  3925,  3941,  3944,  3952,  3958,  3965
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "TK_API", "TK_AUTOPYNAME",
  "TK_DEFENCODING", "TK_PLUGIN", "TK_DOCSTRING", "TK_DOC",
  "TK_EXPORTEDDOC", "TK_EXTRACT", "TK_MAKEFILE", "TK_ACCESSCODE",
  "TK_GETCODE", "TK_SETCODE", "TK_PREINITCODE", "TK_INITCODE",
  "TK_POSTINITCODE", "TK_UNITCODE", "TK_UNITPOSTINCLUDECODE", "TK_MODCODE",
  "TK_TYPECODE", "TK_PREPYCODE", "TK_COPYING", "TK_MAPPEDTYPE",
  "TK_CODELINE", "TK_IF", "TK_END", "TK_NAME_VALUE", "TK_PATH_VALUE",
  "TK_STRING_VALUE", "TK_VIRTUALCATCHERCODE", "TK_VIRTERRORHANDLER",
  "TK_TRAVERSECODE", "TK_CLEARCODE", "TK_GETBUFFERCODE",
  "TK_RELEASEBUFFERCODE", "TK_READBUFFERCODE", "TK_WRITEBUFFERCODE",
  "TK_SEGCOUNTCODE", "TK_CHARBUFFERCODE", "TK_PICKLECODE", "TK_METHODCODE",
  "TK_FROMTYPE", "TK_TOTYPE", "TK_TOSUBCLASS", "TK_INCLUDE",
  "TK_OPTINCLUDE", "TK_IMPORT", "TK_EXPHEADERCODE", "TK_MODHEADERCODE",
  "TK_TYPEHEADERCODE", "TK_MODULE", "TK_CMODULE", "TK_CONSMODULE",
  "TK_COMPOMODULE", "TK_CLASS", "TK_STRUCT", "TK_PUBLIC", "TK_PROTECTED",
  "TK_PRIVATE", "TK_SIGNALS", "TK_SIGNAL_METHOD", "TK_SLOTS",
  "TK_SLOT_METHOD", "TK_BOOL", "TK_SHORT", "TK_INT", "TK_LONG", "TK_FLOAT",
  "TK_DOUBLE", "TK_CHAR", "TK_WCHAR_T", "TK_VOID", "TK_PYOBJECT",
  "TK_PYTUPLE", "TK_PYLIST", "TK_PYDICT", "TK_PYCALLABLE", "TK_PYSLICE",
  "TK_PYTYPE", "TK_VIRTUAL", "TK_ENUM", "TK_SIGNED", "TK_UNSIGNED",
  "TK_SCOPE", "TK_LOGICAL_OR", "TK_CONST", "TK_STATIC", "TK_SIPSIGNAL",
  "TK_SIPSLOT", "TK_SIPANYSLOT", "TK_SIPRXCON", "TK_SIPRXDIS",
  "TK_SIPSLOTCON", "TK_SIPSLOTDIS", "TK_SIPSSIZET", "TK_NUMBER_VALUE",
  "TK_REAL_VALUE", "TK_TYPEDEF", "TK_NAMESPACE", "TK_TIMELINE",
  "TK_PLATFORMS", "TK_FEATURE", "TK_LICENSE", "TK_QCHAR_VALUE",
  "TK_TRUE_VALUE", "TK_FALSE_VALUE", "TK_NULL_VALUE", "TK_OPERATOR",
  "TK_THROW", "TK_QOBJECT", "TK_EXCEPTION", "TK_RAISECODE", "TK_EXPLICIT",
  "TK_TEMPLATE", "TK_ELLIPSIS", "TK_DEFMETATYPE", "TK_DEFSUPERTYPE",
  "TK_PROPERTY", "TK_GET", "TK_ID", "TK_KWARGS", "TK_LANGUAGE",
  "TK_LICENSEE", "TK_NAME", "TK_OPTIONAL", "TK_ORDER", "TK_REMOVELEADING",
  "TK_SET", "TK_SIGNATURE", "TK_TIMESTAMP", "TK_TYPE", "TK_USEARGNAMES",
  "TK_VERSION", "'('", "')'", "','", "'='", "'{'", "'}'", "';'", "'!'",
  "'-'", "'+'", "'*'", "'/'", "'&'", "'|'", "'~'", "'<'", "'>'", "':'",
  "'['", "']'", "'%'", "'^'", "$accept", "specification", "statement",
  "$@1", "modstatement", "nsstatement", "defencoding", "defencoding_args",
  "defencoding_arg_list", "defencoding_arg", "plugin", "plugin_args",
  "plugin_arg_list", "plugin_arg", "api", "api_args", "api_arg_list",
  "api_arg", "exception", "baseexception", "exception_body",
  "exception_body_directives", "exception_body_directive", "raisecode",
  "mappedtype", "$@2", "mappedtypetmpl", "$@3", "mtdefinition", "mtbody",
  "mtline", "mtfunction", "namespace", "$@4", "optnsbody", "nsbody",
  "platforms", "$@5", "platformlist", "virterrorhandler", "platform",
  "feature", "feature_args", "feature_arg_list", "feature_arg", "timeline",
  "$@6", "qualifierlist", "qualifiername", "ifstart", "oredqualifiers",
  "qualifiers", "ifend", "license", "license_args", "license_arg_list",
  "license_arg", "defmetatype", "defmetatype_args", "defmetatype_arg_list",
  "defmetatype_arg", "defsupertype", "defsupertype_args",
  "defsupertype_arg_list", "defsupertype_arg", "consmodule",
  "consmodule_args", "consmodule_arg_list", "consmodule_arg",
  "consmodule_body", "consmodule_body_directives",
  "consmodule_body_directive", "compmodule", "compmodule_args",
  "compmodule_arg_list", "compmodule_arg", "compmodule_body",
  "compmodule_body_directives", "compmodule_body_directive", "module",
  "module_args", "module_arg_list", "module_arg", "module_body",
  "module_body_directives", "module_body_directive", "dottedname",
  "optnumber", "include", "include_args", "include_arg_list",
  "include_arg", "optinclude", "import", "import_args", "import_arg_list",
  "import_arg", "optaccesscode", "optgetcode", "optsetcode", "copying",
  "exphdrcode", "modhdrcode", "typehdrcode", "travcode", "clearcode",
  "getbufcode", "releasebufcode", "readbufcode", "writebufcode",
  "segcountcode", "charbufcode", "picklecode", "modcode", "typecode",
  "preinitcode", "initcode", "postinitcode", "unitcode", "unitpostinccode",
  "prepycode", "doc", "exporteddoc", "autopyname", "autopyname_args",
  "autopyname_arg_list", "autopyname_arg", "extract", "extract_args",
  "extract_arg_list", "extract_arg", "makefile", "codeblock", "codelines",
  "enum", "$@7", "optfilename", "optname", "optenumbody", "enumbody",
  "enumline", "optcomma", "optenumassign", "optassign", "expr", "binop",
  "optunop", "value", "scopedname", "scopepart", "bool_value",
  "simplevalue", "exprlist", "typedef", "struct", "$@8", "$@9",
  "classtmpl", "$@10", "template", "class", "$@11", "$@12", "superclasses",
  "superlist", "superclass", "optclassbody", "classbody", "classline",
  "property", "property_args", "property_arg_list", "property_arg",
  "property_body", "property_body_directives", "property_body_directive",
  "optslot", "dtor", "ctor", "$@13", "simplector", "optctorsig", "$@14",
  "optsig", "$@15", "optvirtual", "function", "operatorname", "optconst",
  "optabstract", "optflags", "flaglist", "flag", "flagvalue", "docstring",
  "optdocstring", "methodcode", "virtualcatchercode", "arglist",
  "rawarglist", "argvalue", "varmember", "$@16", "$@17", "simple_varmem",
  "$@18", "varmem", "member", "$@19", "variable", "variable_body",
  "variable_body_directives", "variable_body_directive", "cpptype",
  "argtype", "optref", "deref", "basetype", "cpptypelist", "optexceptions",
  "exceptionlist", 0
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
   token YYLEX-NUM.  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,   298,   299,   300,   301,   302,   303,   304,
     305,   306,   307,   308,   309,   310,   311,   312,   313,   314,
     315,   316,   317,   318,   319,   320,   321,   322,   323,   324,
     325,   326,   327,   328,   329,   330,   331,   332,   333,   334,
     335,   336,   337,   338,   339,   340,   341,   342,   343,   344,
     345,   346,   347,   348,   349,   350,   351,   352,   353,   354,
     355,   356,   357,   358,   359,   360,   361,   362,   363,   364,
     365,   366,   367,   368,   369,   370,   371,   372,   373,   374,
     375,   376,   377,   378,   379,   380,   381,   382,   383,   384,
     385,   386,   387,   388,   389,    40,    41,    44,    61,   123,
     125,    59,    33,    45,    43,    42,    47,    38,   124,   126,
      60,    62,    58,    91,    93,    37,    94
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint16 yyr1[] =
{
       0,   157,   158,   158,   160,   159,   161,   161,   161,   161,
     161,   161,   161,   161,   161,   161,   161,   161,   161,   161,
     161,   161,   161,   161,   161,   161,   161,   161,   161,   161,
     161,   161,   161,   161,   161,   161,   161,   161,   161,   162,
     162,   162,   162,   162,   162,   162,   162,   162,   162,   162,
     162,   163,   164,   164,   165,   165,   166,   167,   168,   168,
     169,   169,   170,   171,   172,   172,   173,   173,   174,   174,
     175,   176,   176,   177,   178,   178,   179,   179,   179,   179,
     180,   182,   181,   184,   183,   185,   186,   186,   187,   187,
     187,   187,   187,   187,   187,   187,   188,   190,   189,   191,
     191,   192,   192,   194,   193,   195,   195,   196,   197,   198,
     199,   199,   200,   200,   201,   203,   202,   204,   204,   205,
     206,   207,   207,   207,   207,   208,   208,   209,   210,   211,
     211,   211,   212,   212,   213,   213,   213,   213,   214,   215,
     215,   216,   216,   217,   218,   219,   219,   220,   220,   221,
     222,   223,   223,   224,   224,   225,   226,   226,   227,   227,
     228,   228,   228,   229,   230,   230,   231,   231,   232,   233,
     233,   234,   234,   235,   235,   235,   236,   236,   237,   237,
     238,   238,   239,   239,   239,   239,   239,   240,   240,   241,
     241,   242,   242,   242,   242,   243,   243,   244,   244,   245,
     246,   246,   247,   247,   248,   248,   249,   250,   251,   251,
     252,   252,   253,   254,   254,   255,   255,   256,   256,   257,
     258,   259,   260,   261,   262,   263,   264,   265,   266,   267,
     268,   269,   270,   271,   272,   273,   274,   275,   276,   277,
     278,   279,   280,   281,   282,   282,   283,   284,   285,   285,
     286,   286,   287,   287,   288,   289,   290,   290,   292,   291,
     293,   293,   294,   294,   295,   295,   296,   296,   297,   297,
     297,   298,   298,   299,   299,   300,   300,   301,   301,   302,
     302,   302,   302,   302,   302,   303,   303,   303,   303,   303,
     304,   305,   305,   306,   307,   307,   308,   308,   308,   308,
     308,   308,   308,   308,   309,   309,   309,   310,   310,   312,
     313,   311,   315,   314,   316,   318,   319,   317,   320,   320,
     321,   321,   322,   323,   323,   324,   324,   325,   325,   325,
     325,   325,   325,   325,   325,   325,   325,   325,   325,   325,
     325,   325,   325,   325,   325,   325,   325,   325,   325,   325,
     325,   325,   325,   325,   325,   325,   325,   326,   327,   328,
     328,   329,   329,   329,   330,   330,   331,   331,   332,   332,
     332,   333,   333,   334,   336,   335,   335,   337,   338,   339,
     338,   340,   341,   340,   342,   342,   343,   343,   343,   343,
     344,   344,   344,   344,   344,   344,   344,   344,   344,   344,
     344,   344,   344,   344,   344,   344,   344,   344,   344,   344,
     344,   344,   344,   344,   344,   344,   344,   344,   344,   345,
     345,   346,   346,   347,   347,   348,   348,   349,   349,   350,
     350,   350,   350,   351,   352,   352,   353,   353,   354,   354,
     355,   356,   356,   356,   357,   357,   357,   357,   357,   357,
     357,   357,   357,   359,   358,   360,   358,   358,   362,   361,
     361,   363,   363,   365,   364,   364,   366,   367,   367,   368,
     368,   369,   369,   369,   369,   369,   370,   370,   371,   372,
     372,   373,   373,   374,   374,   374,   374,   374,   374,   374,
     374,   374,   374,   374,   374,   374,   374,   374,   374,   374,
     374,   374,   374,   374,   374,   374,   374,   374,   374,   374,
     374,   374,   375,   375,   376,   376,   377,   377,   377
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     1,     2,     0,     2,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     2,     1,     3,     1,     3,     3,     2,     1,     3,
       1,     3,     3,     2,     2,     3,     1,     3,     3,     3,
       5,     0,     3,     4,     1,     2,     1,     1,     1,     1,
       2,     0,     5,     0,     6,     4,     1,     2,     1,     1,
       1,     1,     2,     2,     1,     1,    13,     0,     5,     0,
       3,     1,     2,     0,     5,     1,     2,     2,     1,     2,
       1,     3,     1,     3,     3,     0,     5,     1,     2,     1,
       4,     1,     2,     3,     4,     1,     3,     1,     3,     0,
       1,     3,     1,     3,     3,     3,     3,     3,     2,     1,
       3,     1,     3,     3,     2,     1,     3,     1,     3,     3,
       3,     1,     3,     1,     3,     3,     0,     4,     1,     2,
       1,     1,     1,     3,     1,     3,     1,     3,     3,     0,
       4,     1,     2,     1,     1,     1,     3,     3,     2,     3,
       1,     3,     3,     3,     3,     3,     3,     0,     4,     1,
       2,     1,     1,     1,     1,     1,     1,     0,     1,     2,
       1,     3,     1,     3,     3,     3,     2,     2,     1,     3,
       1,     3,     3,     0,     2,     0,     2,     0,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     3,     1,     3,     3,     3,     1,     3,
       1,     3,     3,     3,     4,     2,     1,     2,     0,     8,
       0,     1,     0,     1,     0,     1,     1,     2,     1,     1,
       4,     0,     1,     0,     2,     0,     2,     1,     3,     1,
       1,     1,     1,     1,     1,     0,     1,     1,     1,     1,
       2,     1,     3,     1,     1,     1,     1,     4,     1,     1,
       1,     1,     1,     1,     0,     1,     3,     5,    11,     0,
       0,     8,     0,     3,     4,     0,     0,     8,     0,     2,
       1,     3,     1,     0,     3,     1,     2,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     2,     2,     3,     3,     3,     2,     3,     3,     1,
       3,     3,     3,     3,     0,     4,     1,     2,     1,     1,
       1,     0,     1,    11,     0,     3,     1,    10,     0,     0,
       6,     0,     0,     7,     0,     1,    14,     7,    14,    13,
       1,     1,     1,     1,     1,     1,     1,     1,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     3,     3,
       1,     2,     2,     1,     2,     2,     2,     1,     2,     0,
       1,     0,     2,     0,     3,     1,     3,     1,     3,     1,
       5,     1,     1,     2,     0,     1,     0,     2,     0,     2,
       1,     0,     1,     3,     4,     4,     4,     3,     3,     6,
       6,     3,     2,     0,     3,     0,     3,     1,     0,     3,
       1,     1,     1,     0,     3,     1,     8,     0,     3,     1,
       2,     1,     1,     2,     2,     2,     4,     3,     3,     0,
       1,     0,     2,     1,     4,     2,     2,     1,     1,     2,
       1,     1,     2,     2,     3,     1,     1,     1,     2,     2,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     3,     0,     4,     0,     1,     3
};

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint16 yydefact[] =
{
       4,     4,     2,     0,     1,     3,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,   127,   293,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,   497,   487,
     490,   491,   495,   496,   500,   501,   502,   503,   504,   505,
     506,   507,   508,   509,   262,     0,   488,     0,   510,     0,
       0,   115,   103,     0,   129,     0,     0,     0,   511,     0,
       0,     5,    37,    19,     9,    14,    45,    35,    36,    41,
      16,    38,    17,    15,    39,    40,    18,    20,    21,     7,
       8,     6,    11,    12,    13,    10,    22,    23,    50,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      47,   483,   291,    46,    42,    44,   312,    43,    48,    49,
       0,   481,     0,     0,    63,    52,     0,    51,    58,     0,
      57,   256,   240,     0,   241,   248,     0,     0,   260,   234,
     235,   236,   237,   238,   232,   239,   219,     0,   423,   262,
     107,   200,     0,   199,   206,   208,     0,   207,   220,   221,
     222,   195,   196,     0,   187,   197,   197,     0,   156,   151,
       0,   169,   164,   315,   309,   493,   263,   423,   498,   486,
     489,   492,   499,   481,     0,    97,     0,     0,   110,     0,
     109,   130,     0,   423,     0,    71,     0,     0,   138,   139,
       0,   144,   145,     0,     0,     0,     0,   423,     0,   479,
      64,     0,     0,     0,    66,     0,     0,    54,     0,     0,
      60,   257,   255,     0,     0,     0,   250,   247,   261,     0,
     485,     0,    81,   121,     0,   125,     0,     0,     0,     0,
       0,   202,     0,     0,   210,     0,     0,     0,     0,     0,
       0,   180,     0,   176,   198,   178,   177,     0,     0,   153,
       0,   150,     0,     0,   166,     0,   163,   318,   318,   258,
     494,   479,   423,   481,    99,     0,     0,     0,     0,   112,
       0,     0,     0,     0,     0,   132,   128,   441,     0,   423,
     512,     0,     0,     0,   141,     0,     0,   147,   292,     0,
     423,   313,   441,   467,     0,     0,     0,   391,   390,   392,
     393,   395,   396,   410,   413,   417,     0,   394,   397,     0,
     482,   480,   477,     0,     0,    65,     0,     0,    53,     0,
       0,    59,     0,     0,     0,   249,     0,   254,   427,     0,
     425,     0,   122,     0,   120,   262,     0,     0,   201,     0,
       0,   209,     0,     0,     0,     0,     0,     0,   179,     0,
       0,     0,   191,   192,     0,   189,   193,   194,     0,   152,
       0,   160,   161,     0,   158,   162,     0,   165,     0,   173,
     174,     0,   171,   175,     0,   423,   423,     0,   476,     0,
       0,     0,     0,   119,     0,   117,   108,     0,   105,     0,
     111,     0,     0,     0,     0,     0,   131,     0,   262,   262,
     262,   262,   262,     0,     0,   262,     0,   440,   442,   262,
     275,     0,     0,     0,   314,     0,   140,     0,     0,   146,
       0,   484,    83,     0,     0,     0,   411,     0,   415,   416,
     401,   400,   402,   403,   405,   406,   414,   398,   418,   399,
     412,   404,   407,   441,    68,    69,    67,    56,    55,    62,
      61,   252,   253,   251,     0,     0,   424,     0,    82,   123,
       0,   126,   204,   294,   295,   205,   203,   212,   211,   182,
     183,   184,   185,   186,   181,     0,   242,   433,     0,   190,
     155,   154,     0,   159,   168,   167,     0,   172,   322,   319,
     320,   316,   310,   264,   307,     0,   101,     0,   312,    98,
     116,   118,   104,   106,   114,   113,   135,   136,   137,   134,
     133,   423,   423,   423,   423,   423,   441,   441,   423,   419,
       0,   423,   285,   452,    72,     0,    70,   513,   143,   142,
     149,   148,     0,   419,     0,     0,     0,   471,   472,     0,
     469,   213,     0,   408,   409,     0,   195,   431,   432,   429,
     428,   426,     0,     0,     0,     0,     0,    86,    95,    88,
      89,    90,    91,    94,   124,     0,     0,   244,   188,   157,
     170,     0,   323,   323,   273,   268,   269,     0,   265,   266,
       0,   100,   102,   275,   275,   275,   447,   448,     0,     0,
     451,   420,   514,   443,   478,   286,   288,   289,   287,   276,
       0,   277,     0,     0,    74,    78,    76,    77,    79,    84,
     514,   473,   474,   475,   468,   470,     0,   215,     0,   419,
     197,   233,    92,    93,     0,     0,    87,     0,   243,     0,
     321,   384,     0,     0,   285,   423,     0,   267,     0,   444,
     445,   446,   262,   262,     0,   421,   279,   280,   281,   282,
     283,   284,   285,   302,   299,   298,   303,   301,   296,   300,
     290,     0,    80,     0,    75,   421,   214,     0,   217,   387,
     514,     0,     0,    85,   246,   245,   293,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,   371,   371,
     371,     0,   453,   455,   463,   458,   374,     0,   332,   329,
     327,   328,   338,   339,   340,   341,   342,   343,   344,   345,
     346,   347,   337,   334,   333,   330,   331,   384,   325,   335,
     349,   348,   376,     0,   465,   336,   350,   457,   460,   461,
     462,   317,   311,   274,   271,   259,     0,   423,   423,   516,
       0,   423,   278,   285,    73,   423,   216,     0,   466,   421,
     197,   441,   441,   223,   224,   225,   226,   227,   228,   229,
     230,   231,   352,   351,   372,     0,     0,     0,   356,     0,
       0,     0,     0,     0,     0,   364,   324,   326,     0,   272,
     270,   423,   449,   450,   517,     0,   422,   381,   305,     0,
     381,   218,   423,   430,     0,     0,   353,   354,   355,   463,
     454,   456,   464,     0,   459,     0,   375,     0,     0,     0,
       0,   359,     0,   357,     0,     0,   515,     0,   382,     0,
     297,   285,     0,   381,   419,   514,     0,     0,     0,     0,
     358,     0,   368,   369,     0,   366,   370,     0,   308,   518,
       0,   436,   306,   434,     0,   514,   423,   361,   362,   363,
     360,     0,   367,   514,     0,     0,   438,   435,   436,   436,
     423,   378,   365,   421,   441,   437,     0,   389,   438,   438,
     381,   379,     0,   423,     0,   439,   386,   388,     0,     0,
     434,     0,     0,   434,   441,   436,   436,   383,   436,     0,
     377,   438,    96,     0,   373,   380
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     1,     2,     3,    71,    72,    73,   127,   216,   217,
      74,   130,   219,   220,    75,   124,   213,   214,    76,   289,
     536,   613,   614,   615,    77,   341,    78,   542,   468,   566,
     567,   568,    79,   274,   392,   507,    80,   187,   397,    81,
     398,    82,   190,   278,   279,    83,   186,   394,   395,    84,
     235,   236,    85,    86,   193,   284,   285,    87,   198,   293,
     294,    88,   201,   296,   297,    89,   168,   258,   259,   261,
     373,   374,    90,   171,   263,   264,   266,   381,   382,    91,
     164,   250,   251,   253,   364,   365,   165,   255,    92,   153,
     240,   241,    93,    94,   157,   243,   244,   627,   678,   758,
      95,    96,    97,    98,   713,   714,   715,   716,   717,   718,
     719,   720,   721,    99,   572,   100,   101,   102,   103,   104,
     105,   106,   107,   366,   486,   576,   577,   108,   137,   225,
     226,   109,   132,   133,   110,   387,   229,   177,   587,   588,
     589,   790,   645,   533,   609,   662,   610,   611,   111,   112,
     475,   670,   799,   113,   114,   268,   583,   115,   206,   508,
     117,   267,   582,   385,   499,   500,   642,   727,   728,   729,
     785,   820,   821,   823,   844,   845,   775,   730,   731,   783,
     732,   882,   889,   829,   850,   733,   734,   319,   602,   751,
     232,   339,   340,   560,   867,   868,   866,   877,   416,   417,
     418,   736,   779,   780,   737,   782,   738,   739,   781,   740,
     435,   549,   550,   419,   420,   322,   209,   121,   291,   655,
     795
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -667
static const yytype_int16 yypact[] =
{
    -667,   110,  -667,   938,  -667,  -667,    68,    39,    69,   117,
     117,    75,   135,   117,   117,   117,   117,   117,   117,   117,
     117,   738,    20,  -667,  -667,   170,    48,   179,    51,   117,
     117,   117,    53,   250,    55,    60,   202,   202,  -667,  -667,
    -667,   149,  -667,  -667,  -667,  -667,  -667,  -667,  -667,  -667,
    -667,  -667,  -667,  -667,   210,   174,   286,   738,  -667,  1425,
     219,  -667,  -667,    77,    72,  1425,   202,   104,  -667,    62,
      65,  -667,  -667,  -667,  -667,  -667,  -667,  -667,  -667,  -667,
    -667,  -667,  -667,  -667,  -667,  -667,  -667,  -667,  -667,  -667,
    -667,  -667,  -667,  -667,  -667,  -667,  -667,  -667,  -667,  -667,
    -667,  -667,  -667,  -667,  -667,  -667,  -667,  -667,  -667,  -667,
    -667,    66,  -667,  -667,  -667,  -667,   242,  -667,  -667,  -667,
      70,  -667,   176,    57,  -667,  -667,   168,  -667,  -667,   191,
    -667,  -667,  -667,   109,  -667,  -667,   155,   117,   317,  -667,
    -667,  -667,  -667,  -667,  -667,  -667,  -667,   202,   209,    24,
    -667,  -667,   180,  -667,  -667,  -667,   195,  -667,  -667,  -667,
    -667,  -667,  -667,   196,   227,   228,   228,   233,   235,  -667,
     243,   237,  -667,   303,    22,  -667,  -667,   209,  -667,  -667,
    -667,   332,  -667,  -667,    80,  -667,   263,   278,  -667,   290,
    -667,  -667,   217,   209,   299,    91,  1425,   297,  -667,  -667,
     323,  -667,  -667,   202,  1425,   738,   369,   100,   189,    12,
    -667,   311,   312,   177,  -667,   313,   186,  -667,   314,   258,
    -667,  -667,  -667,   316,   318,   260,  -667,  -667,  -667,   117,
     303,   427,  -667,   315,   429,   373,   325,   319,   322,   326,
     262,  -667,   330,   268,  -667,   331,   333,   334,   335,   336,
     270,  -667,   244,  -667,  -667,  -667,  -667,   337,   272,  -667,
     126,  -667,   340,   274,  -667,   126,  -667,   327,   327,  -667,
    -667,    12,   209,  -667,   341,   435,   442,   343,   276,  -667,
     344,   345,   347,   348,   283,  -667,  -667,  1153,   202,   209,
    -667,   116,   349,   287,  -667,   350,   291,  -667,  -667,   118,
     209,  -667,  1153,   351,   355,   154,   354,   356,   357,   358,
     360,   361,   363,  -667,   -29,   -22,   339,   364,   365,   362,
    -667,  -667,  -667,   478,   410,  -667,    57,   479,  -667,   168,
     480,  -667,   191,   482,   414,  -667,   155,  -667,   374,     3,
    -667,   375,  -667,    30,  -667,   210,   484,   324,  -667,   180,
     486,  -667,   195,   488,   489,   250,   324,   419,  -667,   196,
     385,   117,  -667,  -667,    41,  -667,  -667,  -667,   250,  -667,
     233,  -667,  -667,    33,  -667,  -667,   250,  -667,   243,  -667,
    -667,    47,  -667,  -667,   202,   209,   209,   382,  -667,   381,
      15,  1100,   383,  -667,    21,  -667,  -667,    44,  -667,   495,
    -667,   290,   496,   499,   500,   501,  -667,   217,   210,   210,
     210,   210,   210,   390,   398,   210,   401,   403,  -667,   210,
     400,    85,   402,  1425,  -667,   250,  -667,   297,   250,  -667,
     323,  -667,  -667,   406,   248,   404,  -667,  1425,  -667,  -667,
    -667,  -667,  -667,  -667,  -667,  -667,  -667,   405,  -667,   408,
    -667,  -667,  -667,  1153,  -667,  -667,  -667,  -667,  -667,  -667,
    -667,  -667,  -667,  -667,   203,   427,  -667,   213,  -667,  -667,
     516,  -667,  -667,  -667,  -667,  -667,  -667,  -667,  -667,  -667,
    -667,  -667,  -667,  -667,  -667,   420,  -667,  -667,   409,  -667,
    -667,  -667,   416,  -667,  -667,  -667,   417,  -667,   303,   412,
    -667,  -667,  -667,   359,  -667,   411,  -667,   685,  -667,  -667,
    -667,  -667,  -667,  -667,  -667,  -667,  -667,  -667,  -667,  -667,
    -667,   209,   209,   209,   209,   209,  1153,  1153,   209,   464,
    1153,   209,   229,  -667,  -667,    93,  -667,  -667,  -667,  -667,
    -667,  -667,   375,   464,   117,   117,   117,  -667,  -667,    52,
    -667,   543,   423,  -667,  -667,   424,   413,  -667,  -667,  -667,
    -667,  -667,   117,   117,   117,  1425,    74,  -667,  -667,  -667,
    -667,  -667,  -667,  -667,  -667,   426,   296,  -667,  -667,  -667,
    -667,   202,   422,   422,   428,  -667,  -667,   430,   359,  -667,
     432,  -667,  -667,   400,   400,   400,  -667,  -667,   433,   436,
    -667,  -667,   452,  -667,  -667,  -667,  -667,  -667,  -667,   236,
    1211,  -667,   117,    35,  -667,  -667,  -667,  -667,  -667,  -667,
     452,  -667,  -667,  -667,  -667,  -667,   117,   555,   434,   464,
     228,  -667,  -667,  -667,   545,   437,  -667,   541,  -667,   420,
    -667,  1036,   438,   439,   229,   209,   440,  -667,  1425,  -667,
    -667,  -667,   210,   210,   441,   444,  -667,  -667,  -667,  -667,
    -667,  -667,   229,  -667,  -667,  -667,  -667,  -667,   108,  -667,
    -667,   448,  -667,   447,  -667,   444,  -667,   117,   560,  -667,
     452,   449,   456,  -667,  -667,  -667,   458,   117,   117,   117,
     117,   117,   117,   117,   117,   117,   117,   117,   514,   514,
     514,   445,  -667,  -667,   451,  -667,  -667,   463,  -667,  -667,
    -667,  -667,  -667,  -667,  -667,  -667,  -667,  -667,  -667,  -667,
    -667,  -667,  -667,  -667,  -667,  -667,  -667,   823,  -667,  -667,
    -667,  -667,  -667,   454,  -667,  -667,  -667,  -667,  -667,  -667,
    -667,  -667,  -667,  -667,   468,  -667,   300,   209,   209,   202,
     504,   209,  -667,   166,  -667,   209,  -667,   117,  -667,   444,
     228,  1153,  1153,  -667,  -667,  -667,  -667,  -667,  -667,  -667,
    -667,  -667,  -667,  -667,  -667,   455,   459,   460,  -667,  1264,
    1264,  1372,  1318,   580,   152,   471,  -667,  -667,   585,  -667,
    -667,   209,  -667,  -667,   303,   302,  -667,   461,   236,   304,
     461,  -667,   209,  -667,   483,   487,  -667,  -667,  -667,  -667,
    -667,  -667,  -667,    76,  -667,   458,  -667,   477,   490,   491,
     306,  -667,   126,  -667,   485,   481,  -667,   202,  -667,   492,
    -667,   229,   493,   461,   464,   452,   497,   590,   596,   597,
    -667,   152,  -667,  -667,    49,  -667,  -667,   502,  -667,   303,
    1425,   584,   236,   620,   494,   452,   209,  -667,  -667,  -667,
    -667,   503,  -667,   452,   505,   117,   600,  -667,   584,   584,
     209,   498,  -667,   444,  1153,  -667,   117,  -667,   600,   600,
     461,  -667,   506,   209,   507,  -667,  -667,  -667,   508,   510,
     620,   509,   511,   620,  1153,   584,   584,  -667,   584,   512,
    -667,   600,  -667,   515,  -667,  -667
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -667,  -667,   635,  -667,  -667,  -344,  -667,  -667,  -667,   308,
    -667,  -667,  -667,   310,  -667,  -667,  -667,   328,  -556,  -667,
    -667,  -667,    40,  -667,  -667,  -667,  -667,  -667,   113,  -667,
      86,  -667,  -549,  -667,  -667,  -667,  -667,  -667,  -667,  -667,
     259,  -667,  -667,  -667,   256,  -667,  -667,  -667,   264,  -238,
    -667,  -667,  -223,  -667,  -667,  -667,   252,  -667,  -667,  -667,
     234,  -667,  -667,  -667,   230,  -667,  -667,  -667,   292,  -667,
    -667,   293,  -667,  -667,  -667,   285,  -667,  -667,   289,  -667,
    -667,  -667,   305,  -667,  -667,   307,     1,  -164,  -667,  -667,
    -667,   342,  -667,  -667,  -667,  -667,   320,  -667,  -667,  -667,
    -667,  -667,  -667,  -436,  -667,  -667,  -667,  -667,  -667,  -667,
    -667,  -667,  -667,  -667,  -526,  -667,  -667,  -667,  -667,  -667,
    -667,  -667,  -667,  -667,  -667,  -667,    29,  -667,  -667,  -667,
     338,  -667,   -10,  -667,  -428,  -667,  -667,  -125,  -667,  -667,
      87,  -667,  -667,  -202,  -666,  -667,  -667,  -538,   -25,   470,
    -312,  -667,  -667,  -518,  -509,  -667,  -667,  -667,  -667,   673,
    -188,  -667,  -667,   421,  -667,   107,   111,  -667,   -37,  -667,
    -667,  -667,  -149,  -667,  -667,  -151,  -255,  -667,  -667,  -667,
     -87,  -667,  -667,  -653,  -667,  -667,    10,  -667,  -517,  -645,
    -161,  -667,   232,  -667,  -227,  -586,  -646,  -642,  -285,  -667,
     169,  -667,  -667,  -667,  -333,  -667,   -84,  -667,  -667,    25,
    -667,  -667,   151,    -2,  -667,   431,  -128,    -6,  -181,  -567,
    -667
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -486
static const yytype_int16 yytable[] =
{
     134,   120,   256,   139,   140,   141,   142,   143,   144,   145,
     146,   173,   174,   118,   362,   148,   269,   433,   301,   158,
     159,   160,   371,   299,   237,   367,   620,   379,   119,   363,
     755,   571,   286,   375,   166,   169,   172,   372,   383,   573,
     361,   195,   380,   505,   482,   360,   303,   506,   361,   393,
    -485,   183,   233,   675,   361,   271,   361,   184,   469,    22,
      23,    22,    23,   194,   544,   545,   546,    22,    23,   125,
     199,   202,   396,    22,    23,    22,    23,   151,    22,    23,
     155,   161,   162,   161,   162,   708,    31,   798,   161,   162,
     161,   162,   709,   161,   162,   562,   122,   128,   207,   618,
      22,    23,   191,   135,   836,   188,   743,   203,   272,   446,
       4,   389,   680,   759,   802,   722,   448,   563,   564,    22,
      23,   447,   230,   724,   752,    31,   362,   227,   422,   449,
     571,  -485,   725,   361,   221,   371,   222,   367,   573,   432,
     465,   363,   131,   379,    31,   390,   375,   832,   612,   466,
     372,   203,    22,    23,   383,   149,    54,   320,   380,   321,
     320,   510,   565,   592,   138,   852,   234,  -485,   555,  -485,
     203,   708,   470,   492,   126,   673,   203,   618,   709,   208,
     854,   488,   211,   152,   512,   208,   156,   496,   163,   861,
     167,   212,   624,   203,   290,   170,   547,   197,   150,   300,
     200,   722,   290,   123,   129,   712,   612,   192,   154,   724,
     136,   548,   189,   723,   635,   273,   204,   175,   725,   337,
     471,   534,   878,   879,   501,   502,   288,   888,   883,   569,
      24,   556,   162,   557,   562,   302,   886,   887,   176,    22,
      23,   598,   599,  -483,   570,   178,   231,   185,   360,   900,
     901,   361,   902,   423,   196,   423,   563,   564,   204,   904,
     544,   545,   546,   421,    31,   585,   205,   424,   856,   431,
      22,    23,   817,   210,    22,    23,   223,   818,   161,   162,
     586,   819,   224,   521,   522,   523,   524,   525,   870,   437,
     528,   712,   438,   215,   531,    54,   873,   616,   669,   723,
     558,   565,  -304,  -304,   895,   238,   239,   898,   605,   606,
     607,   547,   617,   325,   326,   608,   218,   855,   245,   246,
     242,   247,   328,   329,   304,   254,   548,   305,   569,   248,
     249,   306,   307,   308,   309,   310,   311,   312,   313,   314,
     315,   280,   316,   570,   317,   318,   228,   281,   282,   283,
     585,   487,   179,   180,   181,   231,   481,   182,   257,   498,
     593,   594,   595,   596,   597,   586,   252,   600,   262,   490,
     604,   605,   606,   607,   260,   616,   265,   494,   608,   656,
     657,   658,   659,   660,   661,    22,    23,   584,   203,   120,
     617,   649,   650,   651,   331,   332,   335,   336,   348,   349,
     270,   118,   275,   710,   351,   352,   358,   359,   369,   370,
     377,   378,   400,   401,   735,   277,   119,   276,   711,   406,
     407,   537,   292,   426,   427,    36,   538,   429,   430,   540,
     473,   474,   638,   639,   287,   552,   791,   423,   826,   827,
     830,   831,   840,   841,   776,   777,   810,   811,   295,   323,
     324,   327,   330,   726,   333,   338,   334,   342,  -263,   343,
     346,   344,   345,   393,   347,   559,   681,   746,   350,   353,
     396,   354,   355,   356,   357,   368,   804,   805,   376,   384,
     391,   399,   402,   403,   744,   404,   405,   425,   428,   710,
     434,   436,   439,   450,   440,   441,   442,   453,   443,   444,
     735,   445,   451,   452,   711,   120,   454,   455,   459,   457,
     461,   462,   464,   472,   467,   477,   483,   118,   479,   480,
     485,   503,   504,   514,   509,   526,   516,   747,   748,   517,
     518,   519,   119,   527,   621,   622,   623,   529,   532,   726,
     530,   535,   543,   553,   574,   551,   554,   590,   575,   581,
     578,   601,   631,   632,   633,   626,   498,   579,   580,   628,
     629,   641,   654,   634,   637,   630,   644,   648,   677,   652,
     646,   684,   653,   682,   757,   679,   749,   774,   683,   741,
     742,   745,   750,   753,   842,   668,   792,   793,   754,   884,
     797,   761,   760,   762,   800,   846,   803,   778,   784,   843,
    -385,   796,   672,   788,   671,   789,   842,   806,   815,   899,
     822,   807,   808,   824,   828,   837,   676,   846,   857,   834,
     847,   843,   848,   835,   858,   859,   865,   361,   838,   839,
     825,   876,   302,   851,   853,   869,     5,   458,   863,   120,
     874,   833,   460,   892,   872,   894,   290,   890,   903,   893,
     896,   881,   636,   674,   456,   619,   513,   515,   511,   520,
     541,   539,   491,   495,   484,   897,   493,   756,   685,   905,
     497,   489,   478,   298,   463,   647,   116,   763,   764,   765,
     766,   767,   768,   769,   770,   771,   772,   773,   640,   386,
     787,   476,   860,   862,   643,   871,   816,   561,   814,   603,
     625,     0,   388,     0,     0,     0,     0,     0,     0,   880,
       0,    22,    23,    24,     0,     0,     0,     0,     0,     0,
       0,     0,   891,     0,   794,   120,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    31,     0,     0,     0,
       0,    36,    37,     0,     0,     0,     0,   801,     0,     0,
      38,    39,    40,    41,    42,    43,    44,    45,    46,    47,
      48,    49,    50,    51,    52,    53,    24,    54,    55,    56,
       0,     0,    57,     0,     0,     0,     0,   120,   120,   813,
     120,    58,     0,     0,    59,    60,     0,     0,     0,     0,
       0,   812,     0,     0,    65,   147,     0,    66,     0,     0,
      67,    68,   849,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,     0,
       0,    55,    56,     0,     0,   591,     0,     0,     0,     0,
     361,     0,     0,     0,    58,     0,     0,     0,     0,     0,
       0,     0,     0,     0,   562,     0,     0,     0,   864,    22,
      23,   686,     0,     0,    68,   875,   687,   688,   689,   690,
     691,   692,   693,   694,   695,     0,   885,   696,   697,     0,
       0,     0,     0,     0,    31,     0,     0,     0,     0,    36,
      37,   698,   699,   700,   701,   702,     0,   703,    38,    39,
      40,    41,    42,    43,    44,    45,    46,    47,    48,    49,
      50,    51,    52,    53,   704,    54,    55,    56,     0,     0,
      57,   705,     0,     0,     0,     0,     0,     0,     0,    58,
       0,     0,    59,    60,     0,     0,     0,     0,     0,     0,
       0,     0,    65,     0,     0,    66,     0,   706,     0,    68,
       0,     6,   707,     7,     8,     0,     9,    10,    11,    12,
       0,     0,     0,    13,    14,    15,    16,    17,    18,     0,
      19,    20,    21,   786,    22,    23,    24,     0,     0,     0,
      25,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    26,    27,    28,    29,    30,    31,
      32,    33,    34,    35,    36,    37,     0,     0,     0,     0,
       0,     0,     0,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,     0,
      54,    55,    56,     0,     0,    57,     0,     0,     0,     0,
       0,     0,     0,     0,    58,     0,     0,    59,    60,    61,
      62,    63,    64,   361,     0,     0,     0,    65,     0,     0,
      66,     0,     0,    67,    68,    69,    70,   562,     0,     0,
       0,     0,    22,    23,   686,     0,     0,     0,     0,   687,
     688,   689,   690,   691,   692,   693,   694,   695,     0,     0,
     696,   697,     0,     0,     0,     0,     0,    31,     0,     0,
       0,     0,    36,    37,   698,   699,   700,   701,   702,     0,
     703,    38,    39,    40,    41,    42,    43,    44,    45,    46,
      47,    48,    49,    50,    51,    52,    53,   704,    54,    55,
      56,     0,     0,    57,   705,     0,    22,    23,    24,     0,
       0,     0,    58,     0,     0,    59,    60,     0,     0,     0,
       0,     0,     0,     0,     0,    65,     0,     0,    66,     0,
     706,    31,    68,     0,     0,   707,    36,    37,     0,     0,
       0,     0,     0,     0,     0,    38,    39,    40,    41,    42,
      43,    44,    45,    46,    47,    48,    49,    50,    51,    52,
      53,    24,    54,    55,    56,     0,     0,    57,     0,     0,
       0,     0,     0,     0,     0,     0,    58,     0,     0,    59,
      60,     0,     0,     0,     0,     0,     0,     0,     0,    65,
     147,     0,    66,     0,     0,    67,    68,     0,    38,    39,
      40,    41,    42,    43,    44,    45,    46,    47,    48,    49,
      50,    51,    52,    53,     0,     0,    55,    56,     0,    24,
      57,   663,   408,   409,   410,   411,   412,   413,   414,    58,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,   415,     0,     0,     0,   147,    68,
       0,     0,     0,     0,     0,     0,    38,    39,    40,    41,
      42,    43,    44,    45,    46,    47,    48,    49,    50,    51,
      52,    53,    24,     0,    55,    56,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    58,   664,   665,
       0,     0,     0,     0,     0,     0,   666,   473,   474,   667,
       0,   147,     0,     0,     0,     0,     0,    68,     0,    38,
      39,    40,    41,    42,    43,    44,    45,    46,    47,    48,
      49,    50,    51,    52,    53,   809,    24,    55,    56,     0,
       0,    57,   705,     0,     0,     0,     0,     0,     0,     0,
      58,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    65,     0,   147,     0,     0,     0,     0,
      68,     0,     0,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,   809,
      24,    55,    56,     0,     0,    57,     0,     0,     0,     0,
       0,     0,     0,     0,    58,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    65,     0,   147,
       0,     0,     0,     0,    68,     0,     0,    38,    39,    40,
      41,    42,    43,    44,    45,    46,    47,    48,    49,    50,
      51,    52,    53,    24,     0,    55,    56,     0,     0,    57,
       0,     0,     0,     0,     0,     0,     0,     0,    58,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    65,   147,     0,     0,     0,     0,     0,    68,     0,
      38,    39,    40,    41,    42,    43,    44,    45,    46,    47,
      48,    49,    50,    51,    52,    53,     0,     0,    55,    56,
       0,     0,    57,     0,     0,     0,     0,     0,     0,     0,
       0,    58,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    68
};

static const yytype_int16 yycheck[] =
{
      10,     3,   166,    13,    14,    15,    16,    17,    18,    19,
      20,    36,    37,     3,   252,    21,   177,   302,   206,    29,
      30,    31,   260,   204,   149,   252,   543,   265,     3,   252,
     675,   467,   193,   260,    33,    34,    35,   260,   265,   467,
       7,    66,   265,    28,   356,     4,   207,   391,     7,    28,
      28,    57,    28,   620,     7,   183,     7,    59,    28,    26,
      27,    26,    27,    65,    12,    13,    14,    26,    27,    30,
      69,    70,    28,    26,    27,    26,    27,    29,    26,    27,
      29,    28,    29,    28,    29,   641,    51,   753,    28,    29,
      28,    29,   641,    28,    29,    21,    28,    28,    28,   535,
      26,    27,    30,    28,    28,    28,   644,    85,    28,   138,
       0,   272,   629,   680,   759,   641,   138,    43,    44,    26,
      27,   150,   147,   641,   662,    51,   364,   137,   289,   151,
     566,   109,   641,     7,    25,   373,    27,   364,   566,   300,
     137,   364,    25,   381,    51,   273,   373,   800,   113,   146,
     373,    85,    26,    27,   381,   135,    82,   145,   381,   147,
     145,   140,    88,   507,    29,   831,   142,   145,   453,   147,
      85,   727,   142,   140,   135,   140,    85,   613,   727,   109,
     833,   140,   125,   135,   140,   109,   135,   140,   135,   140,
     135,   134,   140,    85,   196,   135,   434,   135,    28,   205,
     135,   727,   204,   135,   135,   641,   113,   135,    29,   727,
     135,   434,   135,   641,   140,   135,   150,    68,   727,   229,
     345,   136,   868,   869,   385,   386,   135,   880,   873,   467,
      28,    28,    29,    30,    21,   135,   878,   879,    28,    26,
      27,   526,   527,   135,   467,    71,   146,    28,     4,   895,
     896,     7,   898,   137,   150,   137,    43,    44,   150,   901,
      12,    13,    14,   288,    51,   503,    24,   151,   835,   151,
      26,    27,   120,    97,    26,    27,   121,   125,    28,    29,
     503,   129,   127,   408,   409,   410,   411,   412,   855,   135,
     415,   727,   138,   125,   419,    82,   863,   535,   610,   727,
      97,    88,   136,   137,   890,   125,   126,   893,   142,   143,
     144,   549,   535,   136,   137,   149,   125,   834,   122,   123,
     125,   125,   136,   137,   135,    97,   549,   138,   566,   133,
     134,   142,   143,   144,   145,   146,   147,   148,   149,   150,
     151,   124,   153,   566,   155,   156,    29,   130,   131,   132,
     588,   361,    66,    67,    68,   146,   355,    71,   125,   384,
     521,   522,   523,   524,   525,   588,   139,   528,   125,   368,
     531,   142,   143,   144,   139,   613,   139,   376,   149,   143,
     144,   145,   146,   147,   148,    26,    27,    28,    85,   391,
     613,   593,   594,   595,   136,   137,   136,   137,   136,   137,
      68,   391,   139,   641,   136,   137,   136,   137,   136,   137,
     136,   137,   136,   137,   641,   125,   391,   139,   641,   136,
     137,   423,   125,   136,   137,    56,   425,   136,   137,   428,
     106,   107,   136,   137,   135,   437,   136,   137,   136,   137,
     136,   137,   136,   137,   699,   700,   779,   780,   125,   138,
     138,   138,   138,   641,   138,    28,   138,    28,   143,    86,
     138,   136,   143,    28,   138,   464,   630,   648,   138,   138,
      28,   138,   138,   138,   138,   138,   761,   762,   138,   152,
     139,   138,   138,   138,   645,   138,   138,   138,   138,   727,
     139,   136,   138,   154,   138,   138,   138,   135,   138,   138,
     727,   138,   138,   138,   727,   507,    28,    97,    28,    30,
      28,    97,   138,    29,   139,    29,    97,   507,    30,    30,
     135,   139,   141,    28,   141,   135,    30,   652,   653,    30,
      30,    30,   507,   135,   544,   545,   546,   136,   138,   727,
     137,   139,   136,   138,    28,   141,   138,   136,   128,   137,
     141,    87,   562,   563,   564,    12,   581,   141,   141,   136,
     136,   139,   110,   565,   138,   152,   138,   135,    13,   136,
     140,    30,   136,    28,    14,   141,   135,    63,   141,   141,
     141,   141,   138,   135,   822,   610,   747,   748,   141,   874,
     751,   135,   143,   135,   755,   822,   760,   152,   135,   822,
     149,    97,   612,   149,   610,   137,   844,   152,    28,   894,
     139,   152,   152,    28,   153,   138,   626,   844,    28,   136,
     135,   844,   141,   136,    28,    28,    42,     7,   138,   138,
     791,    31,   135,   141,   141,   141,     1,   329,   136,   641,
     135,   802,   332,   136,   141,   135,   648,   141,   136,   141,
     141,   153,   566,   613,   326,   542,   397,   401,   394,   407,
     430,   427,   370,   378,   359,   154,   373,   677,   639,   154,
     381,   364,   352,   203,   336,   588,     3,   687,   688,   689,
     690,   691,   692,   693,   694,   695,   696,   697,   581,   268,
     727,   349,   841,   844,   583,   856,   783,   465,   782,   530,
     549,    -1,   271,    -1,    -1,    -1,    -1,    -1,    -1,   870,
      -1,    26,    27,    28,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,   883,    -1,   749,   727,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    51,    -1,    -1,    -1,
      -1,    56,    57,    -1,    -1,    -1,    -1,   757,    -1,    -1,
      65,    66,    67,    68,    69,    70,    71,    72,    73,    74,
      75,    76,    77,    78,    79,    80,    28,    82,    83,    84,
      -1,    -1,    87,    -1,    -1,    -1,    -1,   779,   780,   781,
     782,    96,    -1,    -1,    99,   100,    -1,    -1,    -1,    -1,
      -1,   781,    -1,    -1,   109,    57,    -1,   112,    -1,    -1,
     115,   116,   827,    65,    66,    67,    68,    69,    70,    71,
      72,    73,    74,    75,    76,    77,    78,    79,    80,    -1,
      -1,    83,    84,    -1,    -1,   140,    -1,    -1,    -1,    -1,
       7,    -1,    -1,    -1,    96,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    21,    -1,    -1,    -1,   850,    26,
      27,    28,    -1,    -1,   116,   865,    33,    34,    35,    36,
      37,    38,    39,    40,    41,    -1,   876,    44,    45,    -1,
      -1,    -1,    -1,    -1,    51,    -1,    -1,    -1,    -1,    56,
      57,    58,    59,    60,    61,    62,    -1,    64,    65,    66,
      67,    68,    69,    70,    71,    72,    73,    74,    75,    76,
      77,    78,    79,    80,    81,    82,    83,    84,    -1,    -1,
      87,    88,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    96,
      -1,    -1,    99,   100,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,   109,    -1,    -1,   112,    -1,   114,    -1,   116,
      -1,     3,   119,     5,     6,    -1,     8,     9,    10,    11,
      -1,    -1,    -1,    15,    16,    17,    18,    19,    20,    -1,
      22,    23,    24,   140,    26,    27,    28,    -1,    -1,    -1,
      32,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    46,    47,    48,    49,    50,    51,
      52,    53,    54,    55,    56,    57,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    65,    66,    67,    68,    69,    70,    71,
      72,    73,    74,    75,    76,    77,    78,    79,    80,    -1,
      82,    83,    84,    -1,    -1,    87,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    96,    -1,    -1,    99,   100,   101,
     102,   103,   104,     7,    -1,    -1,    -1,   109,    -1,    -1,
     112,    -1,    -1,   115,   116,   117,   118,    21,    -1,    -1,
      -1,    -1,    26,    27,    28,    -1,    -1,    -1,    -1,    33,
      34,    35,    36,    37,    38,    39,    40,    41,    -1,    -1,
      44,    45,    -1,    -1,    -1,    -1,    -1,    51,    -1,    -1,
      -1,    -1,    56,    57,    58,    59,    60,    61,    62,    -1,
      64,    65,    66,    67,    68,    69,    70,    71,    72,    73,
      74,    75,    76,    77,    78,    79,    80,    81,    82,    83,
      84,    -1,    -1,    87,    88,    -1,    26,    27,    28,    -1,
      -1,    -1,    96,    -1,    -1,    99,   100,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,   109,    -1,    -1,   112,    -1,
     114,    51,   116,    -1,    -1,   119,    56,    57,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    65,    66,    67,    68,    69,
      70,    71,    72,    73,    74,    75,    76,    77,    78,    79,
      80,    28,    82,    83,    84,    -1,    -1,    87,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    96,    -1,    -1,    99,
     100,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   109,
      57,    -1,   112,    -1,    -1,   115,   116,    -1,    65,    66,
      67,    68,    69,    70,    71,    72,    73,    74,    75,    76,
      77,    78,    79,    80,    -1,    -1,    83,    84,    -1,    28,
      87,    30,    89,    90,    91,    92,    93,    94,    95,    96,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,   111,    -1,    -1,    -1,    57,   116,
      -1,    -1,    -1,    -1,    -1,    -1,    65,    66,    67,    68,
      69,    70,    71,    72,    73,    74,    75,    76,    77,    78,
      79,    80,    28,    -1,    83,    84,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    96,    97,    98,
      -1,    -1,    -1,    -1,    -1,    -1,   105,   106,   107,   108,
      -1,    57,    -1,    -1,    -1,    -1,    -1,   116,    -1,    65,
      66,    67,    68,    69,    70,    71,    72,    73,    74,    75,
      76,    77,    78,    79,    80,    81,    28,    83,    84,    -1,
      -1,    87,    88,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      96,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,   109,    -1,    57,    -1,    -1,    -1,    -1,
     116,    -1,    -1,    65,    66,    67,    68,    69,    70,    71,
      72,    73,    74,    75,    76,    77,    78,    79,    80,    81,
      28,    83,    84,    -1,    -1,    87,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    96,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,   109,    -1,    57,
      -1,    -1,    -1,    -1,   116,    -1,    -1,    65,    66,    67,
      68,    69,    70,    71,    72,    73,    74,    75,    76,    77,
      78,    79,    80,    28,    -1,    83,    84,    -1,    -1,    87,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    96,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,   109,    57,    -1,    -1,    -1,    -1,    -1,   116,    -1,
      65,    66,    67,    68,    69,    70,    71,    72,    73,    74,
      75,    76,    77,    78,    79,    80,    -1,    -1,    83,    84,
      -1,    -1,    87,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    96,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,   116
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint16 yystos[] =
{
       0,   158,   159,   160,     0,   159,     3,     5,     6,     8,
       9,    10,    11,    15,    16,    17,    18,    19,    20,    22,
      23,    24,    26,    27,    28,    32,    46,    47,    48,    49,
      50,    51,    52,    53,    54,    55,    56,    57,    65,    66,
      67,    68,    69,    70,    71,    72,    73,    74,    75,    76,
      77,    78,    79,    80,    82,    83,    84,    87,    96,    99,
     100,   101,   102,   103,   104,   109,   112,   115,   116,   117,
     118,   161,   162,   163,   167,   171,   175,   181,   183,   189,
     193,   196,   198,   202,   206,   209,   210,   214,   218,   222,
     229,   236,   245,   249,   250,   257,   258,   259,   260,   270,
     272,   273,   274,   275,   276,   277,   278,   279,   284,   288,
     291,   305,   306,   310,   311,   314,   316,   317,   343,   366,
     370,   374,    28,   135,   172,    30,   135,   164,    28,   135,
     168,    25,   289,   290,   289,    28,   135,   285,    29,   289,
     289,   289,   289,   289,   289,   289,   289,    57,   374,   135,
      28,    29,   135,   246,    29,    29,   135,   251,   289,   289,
     289,    28,    29,   135,   237,   243,   243,   135,   223,   243,
     135,   230,   243,   305,   305,    68,    28,   294,    71,    66,
      67,    68,    71,   374,   370,    28,   203,   194,    28,   135,
     199,    30,   135,   211,   370,   305,   150,   135,   215,   243,
     135,   219,   243,    85,   150,    24,   315,    28,   109,   373,
      97,   125,   134,   173,   174,   125,   165,   166,   125,   169,
     170,    25,    27,   121,   127,   286,   287,   289,    29,   293,
     305,   146,   347,    28,   142,   207,   208,   294,   125,   126,
     247,   248,   125,   252,   253,   122,   123,   125,   133,   134,
     238,   239,   139,   240,    97,   244,   244,   125,   224,   225,
     139,   226,   125,   231,   232,   139,   233,   318,   312,   347,
      68,   373,    28,   135,   190,   139,   139,   125,   200,   201,
     124,   130,   131,   132,   212,   213,   347,   135,   135,   176,
     370,   375,   125,   216,   217,   125,   220,   221,   306,   375,
     374,   317,   135,   347,   135,   138,   142,   143,   144,   145,
     146,   147,   148,   149,   150,   151,   153,   155,   156,   344,
     145,   147,   372,   138,   138,   136,   137,   138,   136,   137,
     138,   136,   137,   138,   138,   136,   137,   289,    28,   348,
     349,   182,    28,    86,   136,   143,   138,   138,   136,   137,
     138,   136,   137,   138,   138,   138,   138,   138,   136,   137,
       4,     7,   206,   209,   241,   242,   280,   351,   138,   136,
     137,   206,   209,   227,   228,   351,   138,   136,   137,   206,
     209,   234,   235,   351,   152,   320,   320,   292,   372,   347,
     373,   139,   191,    28,   204,   205,    28,   195,   197,   138,
     136,   137,   138,   138,   138,   138,   136,   137,    89,    90,
      91,    92,    93,    94,    95,   111,   355,   356,   357,   370,
     371,   305,   347,   137,   151,   138,   136,   137,   138,   136,
     137,   151,   347,   355,   139,   367,   136,   135,   138,   138,
     138,   138,   138,   138,   138,   138,   138,   150,   138,   151,
     154,   138,   138,   135,    28,    97,   174,    30,   166,    28,
     170,    28,    97,   287,   138,   137,   146,   139,   185,    28,
     142,   294,    29,   106,   107,   307,   248,    29,   253,    30,
      30,   243,   307,    97,   239,   135,   281,   289,   140,   242,
     243,   225,   140,   228,   243,   232,   140,   235,   305,   321,
     322,   347,   347,   139,   141,    28,   162,   192,   316,   141,
     140,   205,   140,   197,    28,   201,    30,    30,    30,    30,
     213,   294,   294,   294,   294,   294,   135,   135,   294,   136,
     137,   294,   138,   300,   136,   139,   177,   370,   243,   217,
     243,   221,   184,   136,    12,    13,    14,   206,   209,   368,
     369,   141,   370,   138,   138,   355,    28,    30,    97,   243,
     350,   349,    21,    43,    44,    88,   186,   187,   188,   206,
     209,   260,   271,   291,    28,   128,   282,   283,   141,   141,
     141,   137,   319,   313,    28,   206,   209,   295,   296,   297,
     136,   140,   162,   347,   347,   347,   347,   347,   355,   355,
     347,    87,   345,   357,   347,   142,   143,   144,   149,   301,
     303,   304,   113,   178,   179,   180,   206,   209,   260,   185,
     345,   289,   289,   289,   140,   369,    12,   254,   136,   136,
     152,   289,   289,   289,   370,   140,   187,   138,   136,   137,
     322,   139,   323,   323,   138,   299,   140,   297,   135,   300,
     300,   300,   136,   136,   110,   376,   143,   144,   145,   146,
     147,   148,   302,    30,    97,    98,   105,   108,   305,   307,
     308,   374,   289,   140,   179,   376,   289,    13,   255,   141,
     345,   244,    28,   141,    30,   283,    28,    33,    34,    35,
      36,    37,    38,    39,    40,    41,    44,    45,    58,    59,
      60,    61,    62,    64,    81,    88,   114,   119,   175,   189,
     206,   209,   260,   261,   262,   263,   264,   265,   266,   267,
     268,   269,   271,   291,   310,   311,   317,   324,   325,   326,
     334,   335,   337,   342,   343,   351,   358,   361,   363,   364,
     366,   141,   141,   304,   347,   141,   375,   294,   294,   135,
     138,   346,   304,   135,   141,   346,   289,    14,   256,   376,
     143,   135,   135,   289,   289,   289,   289,   289,   289,   289,
     289,   289,   289,   289,    63,   333,   333,   333,   152,   359,
     360,   365,   362,   336,   135,   327,   140,   325,   149,   137,
     298,   136,   347,   347,   305,   377,    97,   347,   301,   309,
     347,   289,   346,   244,   355,   355,   152,   152,   152,    81,
     361,   361,   343,   370,   363,    28,   337,   120,   125,   129,
     328,   329,   139,   330,    28,   347,   136,   137,   153,   340,
     136,   137,   340,   347,   136,   136,    28,   138,   138,   138,
     136,   137,   206,   209,   331,   332,   351,   135,   141,   305,
     341,   141,   301,   141,   340,   345,   376,    28,    28,    28,
     329,   140,   332,   136,   370,    42,   353,   351,   352,   141,
     376,   347,   141,   376,   135,   289,    31,   354,   353,   353,
     347,   153,   338,   346,   355,   289,   354,   354,   340,   339,
     141,   347,   136,   141,   135,   352,   141,   154,   352,   355,
     353,   353,   353,   136,   354,   154
};

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		(-2)
#define YYEOF		0

#define YYACCEPT	goto yyacceptlab
#define YYABORT		goto yyabortlab
#define YYERROR		goto yyerrorlab


/* Like YYERROR except do call yyerror.  This remains here temporarily
   to ease the transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  */

#define YYFAIL		goto yyerrlab

#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)					\
do								\
  if (yychar == YYEMPTY && yylen == 1)				\
    {								\
      yychar = (Token);						\
      yylval = (Value);						\
      yytoken = YYTRANSLATE (yychar);				\
      YYPOPSTACK (1);						\
      goto yybackup;						\
    }								\
  else								\
    {								\
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;							\
    }								\
while (YYID (0))


#define YYTERROR	1
#define YYERRCODE	256


/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
   If N is 0, then set CURRENT to the empty location which ends
   the previous symbol: RHS[0] (always defined).  */

#define YYRHSLOC(Rhs, K) ((Rhs)[K])
#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)				\
    do									\
      if (YYID (N))                                                    \
	{								\
	  (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;	\
	  (Current).first_column = YYRHSLOC (Rhs, 1).first_column;	\
	  (Current).last_line    = YYRHSLOC (Rhs, N).last_line;		\
	  (Current).last_column  = YYRHSLOC (Rhs, N).last_column;	\
	}								\
      else								\
	{								\
	  (Current).first_line   = (Current).last_line   =		\
	    YYRHSLOC (Rhs, 0).last_line;				\
	  (Current).first_column = (Current).last_column =		\
	    YYRHSLOC (Rhs, 0).last_column;				\
	}								\
    while (YYID (0))
#endif


/* YY_LOCATION_PRINT -- Print the location on the stream.
   This macro was not mandated originally: define only if we know
   we won't break user code: when these are the locations we know.  */

#ifndef YY_LOCATION_PRINT
# if YYLTYPE_IS_TRIVIAL
#  define YY_LOCATION_PRINT(File, Loc)			\
     fprintf (File, "%d.%d-%d.%d",			\
	      (Loc).first_line, (Loc).first_column,	\
	      (Loc).last_line,  (Loc).last_column)
# else
#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
# endif
#endif


/* YYLEX -- calling `yylex' with the right arguments.  */

#ifdef YYLEX_PARAM
# define YYLEX yylex (YYLEX_PARAM)
#else
# define YYLEX yylex ()
#endif

/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)			\
do {						\
  if (yydebug)					\
    YYFPRINTF Args;				\
} while (YYID (0))

# define YY_SYMBOL_PRINT(Title, Type, Value, Location)			  \
do {									  \
  if (yydebug)								  \
    {									  \
      YYFPRINTF (stderr, "%s ", Title);					  \
      yy_symbol_print (stderr,						  \
		  Type, Value); \
      YYFPRINTF (stderr, "\n");						  \
    }									  \
} while (YYID (0))


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_value_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# else
  YYUSE (yyoutput);
# endif
  switch (yytype)
    {
      default:
	break;
    }
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (yytype < YYNTOKENS)
    YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
  else
    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
#else
static void
yy_stack_print (yybottom, yytop)
    yytype_int16 *yybottom;
    yytype_int16 *yytop;
#endif
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)				\
do {								\
  if (yydebug)							\
    yy_stack_print ((Bottom), (Top));				\
} while (YYID (0))


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_reduce_print (YYSTYPE *yyvsp, int yyrule)
#else
static void
yy_reduce_print (yyvsp, yyrule)
    YYSTYPE *yyvsp;
    int yyrule;
#endif
{
  int yynrhs = yyr2[yyrule];
  int yyi;
  unsigned long int yylno = yyrline[yyrule];
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
	     yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr, yyrhs[yyprhs[yyrule] + yyi],
		       &(yyvsp[(yyi + 1) - (yynrhs)])
		       		       );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)		\
do {					\
  if (yydebug)				\
    yy_reduce_print (yyvsp, Rule); \
} while (YYID (0))

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef	YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif



#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static YYSIZE_T
yystrlen (const char *yystr)
#else
static YYSIZE_T
yystrlen (yystr)
    const char *yystr;
#endif
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static char *
yystpcpy (char *yydest, const char *yysrc)
#else
static char *
yystpcpy (yydest, yysrc)
    char *yydest;
    const char *yysrc;
#endif
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
	switch (*++yyp)
	  {
	  case '\'':
	  case ',':
	    goto do_not_strip_quotes;

	  case '\\':
	    if (*++yyp != '\\')
	      goto do_not_strip_quotes;
	    /* Fall through.  */
	  default:
	    if (yyres)
	      yyres[yyn] = *yyp;
	    yyn++;
	    break;

	  case '"':
	    if (yyres)
	      yyres[yyn] = '\0';
	    return yyn;
	  }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into YYRESULT an error message about the unexpected token
   YYCHAR while in state YYSTATE.  Return the number of bytes copied,
   including the terminating null byte.  If YYRESULT is null, do not
   copy anything; just return the number of bytes that would be
   copied.  As a special case, return 0 if an ordinary "syntax error"
   message will do.  Return YYSIZE_MAXIMUM if overflow occurs during
   size calculation.  */
static YYSIZE_T
yysyntax_error (char *yyresult, int yystate, int yychar)
{
  int yyn = yypact[yystate];

  if (! (YYPACT_NINF < yyn && yyn <= YYLAST))
    return 0;
  else
    {
      int yytype = YYTRANSLATE (yychar);
      YYSIZE_T yysize0 = yytnamerr (0, yytname[yytype]);
      YYSIZE_T yysize = yysize0;
      YYSIZE_T yysize1;
      int yysize_overflow = 0;
      enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
      char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
      int yyx;

# if 0
      /* This is so xgettext sees the translatable formats that are
	 constructed on the fly.  */
      YY_("syntax error, unexpected %s");
      YY_("syntax error, unexpected %s, expecting %s");
      YY_("syntax error, unexpected %s, expecting %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s");
# endif
      char *yyfmt;
      char const *yyf;
      static char const yyunexpected[] = "syntax error, unexpected %s";
      static char const yyexpecting[] = ", expecting %s";
      static char const yyor[] = " or %s";
      char yyformat[sizeof yyunexpected
		    + sizeof yyexpecting - 1
		    + ((YYERROR_VERBOSE_ARGS_MAXIMUM - 2)
		       * (sizeof yyor - 1))];
      char const *yyprefix = yyexpecting;

      /* Start YYX at -YYN if negative to avoid negative indexes in
	 YYCHECK.  */
      int yyxbegin = yyn < 0 ? -yyn : 0;

      /* Stay within bounds of both yycheck and yytname.  */
      int yychecklim = YYLAST - yyn + 1;
      int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
      int yycount = 1;

      yyarg[0] = yytname[yytype];
      yyfmt = yystpcpy (yyformat, yyunexpected);

      for (yyx = yyxbegin; yyx < yyxend; ++yyx)
	if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
	  {
	    if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
	      {
		yycount = 1;
		yysize = yysize0;
		yyformat[sizeof yyunexpected - 1] = '\0';
		break;
	      }
	    yyarg[yycount++] = yytname[yyx];
	    yysize1 = yysize + yytnamerr (0, yytname[yyx]);
	    yysize_overflow |= (yysize1 < yysize);
	    yysize = yysize1;
	    yyfmt = yystpcpy (yyfmt, yyprefix);
	    yyprefix = yyor;
	  }

      yyf = YY_(yyformat);
      yysize1 = yysize + yystrlen (yyf);
      yysize_overflow |= (yysize1 < yysize);
      yysize = yysize1;

      if (yysize_overflow)
	return YYSIZE_MAXIMUM;

      if (yyresult)
	{
	  /* Avoid sprintf, as that infringes on the user's name space.
	     Don't have undefined behavior even if the translation
	     produced a string with the wrong number of "%s"s.  */
	  char *yyp = yyresult;
	  int yyi = 0;
	  while ((*yyp = *yyf) != '\0')
	    {
	      if (*yyp == '%' && yyf[1] == 's' && yyi < yycount)
		{
		  yyp += yytnamerr (yyp, yyarg[yyi++]);
		  yyf += 2;
		}
	      else
		{
		  yyp++;
		  yyf++;
		}
	    }
	}
      return yysize;
    }
}
#endif /* YYERROR_VERBOSE */


/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
#else
static void
yydestruct (yymsg, yytype, yyvaluep)
    const char *yymsg;
    int yytype;
    YYSTYPE *yyvaluep;
#endif
{
  YYUSE (yyvaluep);

  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  switch (yytype)
    {

      default:
	break;
    }
}

/* Prevent warnings from -Wmissing-prototypes.  */
#ifdef YYPARSE_PARAM
#if defined __STDC__ || defined __cplusplus
int yyparse (void *YYPARSE_PARAM);
#else
int yyparse ();
#endif
#else /* ! YYPARSE_PARAM */
#if defined __STDC__ || defined __cplusplus
int yyparse (void);
#else
int yyparse ();
#endif
#endif /* ! YYPARSE_PARAM */


/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;

/* Number of syntax errors so far.  */
int yynerrs;



/*-------------------------.
| yyparse or yypush_parse.  |
`-------------------------*/

#ifdef YYPARSE_PARAM
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void *YYPARSE_PARAM)
#else
int
yyparse (YYPARSE_PARAM)
    void *YYPARSE_PARAM;
#endif
#else /* ! YYPARSE_PARAM */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void)
#else
int
yyparse ()

#endif
#endif
{


    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       `yyss': related to states.
       `yyvs': related to semantic values.

       Refer to the stacks thru separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yytoken = 0;
  yyss = yyssa;
  yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */

  /* Initialize stack pointers.
     Waste one element of value and location stack
     so that they stay on the same level as the state stack.
     The wasted elements are never initialized.  */
  yyssp = yyss;
  yyvsp = yyvs;

  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
	/* Give user a chance to reallocate the stack.  Use copies of
	   these so that the &'s don't force the real ones into
	   memory.  */
	YYSTYPE *yyvs1 = yyvs;
	yytype_int16 *yyss1 = yyss;

	/* Each stack pointer address is followed by the size of the
	   data in use in that stack, in bytes.  This used to be a
	   conditional around just the two extra args, but that might
	   be undefined if yyoverflow is a macro.  */
	yyoverflow (YY_("memory exhausted"),
		    &yyss1, yysize * sizeof (*yyssp),
		    &yyvs1, yysize * sizeof (*yyvsp),
		    &yystacksize);

	yyss = yyss1;
	yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
	goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
	yystacksize = YYMAXDEPTH;

      {
	yytype_int16 *yyss1 = yyss;
	union yyalloc *yyptr =
	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
	if (! yyptr)
	  goto yyexhaustedlab;
	YYSTACK_RELOCATE (yyss_alloc, yyss);
	YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
	if (yyss1 != yyssa)
	  YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
		  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
	YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yyn == YYPACT_NINF)
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = YYLEX;
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yyn == 0 || yyn == YYTABLE_NINF)
	goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  *++yyvsp = yylval;

  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     `$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 4:

/* Line 1455 of yacc.c  */
#line 492 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            /*
             * We don't do these in parserEOF() because the parser is reading
             * ahead and that would be too early.
             */

            if (previousFile != NULL)
            {
                handleEOF();

                if (currentContext.prevmod != NULL)
                    handleEOM();

                free(previousFile);
                previousFile = NULL;
            }
    }
    break;

  case 50:

/* Line 1455 of yacc.c  */
#line 557 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                classDef *scope = currentScope();

                if (scope == NULL)
                    yyerror("%TypeHeaderCode can only be used in a namespace, class or mapped type");

                appendCodeBlock(&scope->iff->hdrcode, (yyvsp[(1) - (1)].codeb));
            }
        }
    break;

  case 51:

/* Line 1455 of yacc.c  */
#line 570 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                if ((currentModule->encoding = convertEncoding((yyvsp[(2) - (2)].defencoding).name)) == no_type)
                    yyerror("The %DefaultEncoding name must be one of \"ASCII\", \"Latin-1\", \"UTF-8\" or \"None\"");
            }
        }
    break;

  case 52:

/* Line 1455 of yacc.c  */
#line 579 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            resetLexerState();

            (yyval.defencoding).name = (yyvsp[(1) - (1)].text);
        }
    break;

  case 53:

/* Line 1455 of yacc.c  */
#line 584 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.defencoding) = (yyvsp[(2) - (3)].defencoding);
        }
    break;

  case 55:

/* Line 1455 of yacc.c  */
#line 590 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.defencoding) = (yyvsp[(1) - (3)].defencoding);

            switch ((yyvsp[(3) - (3)].defencoding).token)
            {
            case TK_NAME: (yyval.defencoding).name = (yyvsp[(3) - (3)].defencoding).name; break;
            }
        }
    break;

  case 56:

/* Line 1455 of yacc.c  */
#line 600 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.defencoding).token = TK_NAME;

            (yyval.defencoding).name = (yyvsp[(3) - (3)].text);
        }
    break;

  case 57:

/* Line 1455 of yacc.c  */
#line 607 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            /* Note that %Plugin is internal in SIP v4. */

            if (notSkipping())
                appendString(&currentSpec->plugins, (yyvsp[(2) - (2)].plugin).name);
        }
    break;

  case 58:

/* Line 1455 of yacc.c  */
#line 615 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            resetLexerState();

            (yyval.plugin).name = (yyvsp[(1) - (1)].text);
        }
    break;

  case 59:

/* Line 1455 of yacc.c  */
#line 620 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.plugin) = (yyvsp[(2) - (3)].plugin);
        }
    break;

  case 61:

/* Line 1455 of yacc.c  */
#line 626 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.plugin) = (yyvsp[(1) - (3)].plugin);

            switch ((yyvsp[(3) - (3)].plugin).token)
            {
            case TK_NAME: (yyval.plugin).name = (yyvsp[(3) - (3)].plugin).name; break;
            }
        }
    break;

  case 62:

/* Line 1455 of yacc.c  */
#line 636 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.plugin).token = TK_NAME;

            (yyval.plugin).name = (yyvsp[(3) - (3)].text);
        }
    break;

  case 63:

/* Line 1455 of yacc.c  */
#line 643 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                apiVersionRangeDef *avd;

                if (findAPI(currentSpec, (yyvsp[(2) - (2)].api).name) != NULL)
                    yyerror("The API name in the %API directive has already been defined");

                if ((yyvsp[(2) - (2)].api).version < 1)
                    yyerror("The version number in the %API directive must be greater than or equal to 1");

                avd = sipMalloc(sizeof (apiVersionRangeDef));

                avd->api_name = cacheName(currentSpec, (yyvsp[(2) - (2)].api).name);
                avd->from = (yyvsp[(2) - (2)].api).version;
                avd->to = -1;

                avd->next = currentModule->api_versions;
                currentModule->api_versions = avd;

                if (inMainModule())
                    setIsUsedName(avd->api_name);
            }
        }
    break;

  case 64:

/* Line 1455 of yacc.c  */
#line 669 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            resetLexerState();

            deprecated("%API name and version number should be specified using the 'name' and 'version' arguments");

            (yyval.api).name = (yyvsp[(1) - (2)].text);
            (yyval.api).version = (yyvsp[(2) - (2)].number);
        }
    break;

  case 65:

/* Line 1455 of yacc.c  */
#line 677 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.api) = (yyvsp[(2) - (3)].api);
        }
    break;

  case 67:

/* Line 1455 of yacc.c  */
#line 683 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.api) = (yyvsp[(1) - (3)].api);

            switch ((yyvsp[(3) - (3)].api).token)
            {
            case TK_NAME: (yyval.api).name = (yyvsp[(3) - (3)].api).name; break;
            case TK_VERSION: (yyval.api).version = (yyvsp[(3) - (3)].api).version; break;
            }
        }
    break;

  case 68:

/* Line 1455 of yacc.c  */
#line 694 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.api).token = TK_NAME;

            (yyval.api).name = (yyvsp[(3) - (3)].text);
            (yyval.api).version = 0;
        }
    break;

  case 69:

/* Line 1455 of yacc.c  */
#line 700 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.api).token = TK_VERSION;

            (yyval.api).name = NULL;
            (yyval.api).version = (yyvsp[(3) - (3)].number);
        }
    break;

  case 70:

/* Line 1455 of yacc.c  */
#line 708 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                static const char *annos[] = {
                    "Default",
                    "PyName",
                    NULL
                };

                exceptionDef *xd;
                const char *pyname;

                checkAnnos(&(yyvsp[(4) - (5)].optflags), annos);

                if (currentSpec->genc)
                    yyerror("%Exception not allowed in a C module");

                if ((yyvsp[(5) - (5)].exception).raise_code == NULL)
                    yyerror("%Exception must have a %RaiseCode sub-directive");

                pyname = getPythonName(currentModule, &(yyvsp[(4) - (5)].optflags), scopedNameTail((yyvsp[(2) - (5)].scpvalp)));

                checkAttributes(currentSpec, currentModule, NULL, NULL,
                        pyname, FALSE);

                xd = findException(currentSpec, (yyvsp[(2) - (5)].scpvalp), TRUE);

                if (xd->cd != NULL)
                    yyerror("%Exception name has already been seen as a class name - it must be defined before being used");

                if (xd->iff->module != NULL)
                    yyerror("The %Exception has already been defined");

                /* Complete the definition. */
                xd->iff->module = currentModule;
                appendCodeBlock(&xd->iff->hdrcode, (yyvsp[(5) - (5)].exception).type_header_code);
                xd->pyname = pyname;
                xd->bibase = (yyvsp[(3) - (5)].exceptionbase).bibase;
                xd->base = (yyvsp[(3) - (5)].exceptionbase).base;
                appendCodeBlock(&xd->raisecode, (yyvsp[(5) - (5)].exception).raise_code);

                if (getOptFlag(&(yyvsp[(4) - (5)].optflags), "Default", bool_flag) != NULL)
                    currentModule->defexception = xd;

                if (xd->bibase != NULL || xd->base != NULL)
                    xd->exceptionnr = currentModule->nrexceptions++;
            }
        }
    break;

  case 71:

/* Line 1455 of yacc.c  */
#line 758 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.exceptionbase).bibase = NULL;
            (yyval.exceptionbase).base = NULL;
        }
    break;

  case 72:

/* Line 1455 of yacc.c  */
#line 762 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            exceptionDef *xd;

            (yyval.exceptionbase).bibase = NULL;
            (yyval.exceptionbase).base = NULL;

            /* See if it is a defined exception. */
            for (xd = currentSpec->exceptions; xd != NULL; xd = xd->next)
                if (compareScopedNames(xd->iff->fqcname, (yyvsp[(2) - (3)].scpvalp)) == 0)
                {
                    (yyval.exceptionbase).base = xd;
                    break;
                }

            if (xd == NULL && (yyvsp[(2) - (3)].scpvalp)->next == NULL && strncmp((yyvsp[(2) - (3)].scpvalp)->name, "SIP_", 4) == 0)
            {
                /* See if it is a builtin exception. */

                static char *builtins[] = {
                    "Exception",
                    "StopIteration",
                    "StandardError",
                    "ArithmeticError",
                    "LookupError",
                    "AssertionError",
                    "AttributeError",
                    "EOFError",
                    "FloatingPointError",
                    "EnvironmentError",
                    "IOError",
                    "OSError",
                    "ImportError",
                    "IndexError",
                    "KeyError",
                    "KeyboardInterrupt",
                    "MemoryError",
                    "NameError",
                    "OverflowError",
                    "RuntimeError",
                    "NotImplementedError",
                    "SyntaxError",
                    "IndentationError",
                    "TabError",
                    "ReferenceError",
                    "SystemError",
                    "SystemExit",
                    "TypeError",
                    "UnboundLocalError",
                    "UnicodeError",
                    "UnicodeEncodeError",
                    "UnicodeDecodeError",
                    "UnicodeTranslateError",
                    "ValueError",
                    "ZeroDivisionError",
                    "WindowsError",
                    "VMSError",
                    NULL
                };

                char **cp;

                for (cp = builtins; *cp != NULL; ++cp)
                    if (strcmp((yyvsp[(2) - (3)].scpvalp)->name + 4, *cp) == 0)
                    {
                        (yyval.exceptionbase).bibase = *cp;
                        break;
                    }
            }

            if ((yyval.exceptionbase).bibase == NULL && (yyval.exceptionbase).base == NULL)
                yyerror("Unknown exception base type");
        }
    break;

  case 73:

/* Line 1455 of yacc.c  */
#line 836 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.exception) = (yyvsp[(2) - (4)].exception);
        }
    break;

  case 75:

/* Line 1455 of yacc.c  */
#line 842 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.exception) = (yyvsp[(1) - (2)].exception);

            switch ((yyvsp[(2) - (2)].exception).token)
            {
            case TK_RAISECODE: (yyval.exception).raise_code = (yyvsp[(2) - (2)].exception).raise_code; break;
            case TK_TYPEHEADERCODE: (yyval.exception).type_header_code = (yyvsp[(2) - (2)].exception).type_header_code; break;
            }
        }
    break;

  case 76:

/* Line 1455 of yacc.c  */
#line 853 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.exception).token = TK_IF;
        }
    break;

  case 77:

/* Line 1455 of yacc.c  */
#line 856 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.exception).token = TK_END;
        }
    break;

  case 78:

/* Line 1455 of yacc.c  */
#line 859 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                (yyval.exception).token = TK_RAISECODE;
                (yyval.exception).raise_code = (yyvsp[(1) - (1)].codeb);
            }
            else
            {
                (yyval.exception).token = 0;
                (yyval.exception).raise_code = NULL;
            }
        }
    break;

  case 79:

/* Line 1455 of yacc.c  */
#line 871 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                (yyval.exception).token = TK_TYPEHEADERCODE;
                (yyval.exception).type_header_code = (yyvsp[(1) - (1)].codeb);
            }
            else
            {
                (yyval.exception).token = 0;
                (yyval.exception).type_header_code = NULL;
            }
        }
    break;

  case 80:

/* Line 1455 of yacc.c  */
#line 885 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.codeb) = (yyvsp[(2) - (2)].codeb);
        }
    break;

  case 81:

/* Line 1455 of yacc.c  */
#line 890 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                static const char *annos[] = {
                    "AllowNone",
                    "API",
                    "DocType",
                    "NoRelease",
                    "PyName",
                    NULL
                };

                checkAnnos(&(yyvsp[(3) - (3)].optflags), annos);

                currentMappedType = newMappedType(currentSpec, &(yyvsp[(2) - (3)].memArg), &(yyvsp[(3) - (3)].optflags));
            }
        }
    break;

  case 83:

/* Line 1455 of yacc.c  */
#line 909 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                static const char *annos[] = {
                    "DocType",
                    NULL
                };

                int a;
                mappedTypeTmplDef *mtt;
                ifaceFileDef *iff;

                checkAnnos(&(yyvsp[(4) - (4)].optflags), annos);

                if (currentSpec->genc)
                    yyerror("%MappedType templates not allowed in a C module");

                /*
                 * Check the template arguments are basic types or simple
                 * names.
                 */
                for (a = 0; a < (yyvsp[(1) - (4)].signature).nrArgs; ++a)
                {
                    argDef *ad = &(yyvsp[(1) - (4)].signature).args[a];

                    if (ad->atype == defined_type && ad->u.snd->next != NULL)
                        yyerror("%MappedType template arguments must be simple names");
                }

                if ((yyvsp[(3) - (4)].memArg).atype != template_type)
                    yyerror("%MappedType template must map a template type");

                /* Check a template hasn't already been provided. */
                for (mtt = currentSpec->mappedtypetemplates; mtt != NULL; mtt = mtt->next)
                    if (compareScopedNames(mtt->mt->type.u.td->fqname, (yyvsp[(3) - (4)].memArg).u.td->fqname) == 0 && sameTemplateSignature(&mtt->mt->type.u.td->types, &(yyvsp[(3) - (4)].memArg).u.td->types, TRUE))
                        yyerror("%MappedType template for this type has already been defined");

                (yyvsp[(3) - (4)].memArg).nrderefs = 0;
                (yyvsp[(3) - (4)].memArg).argflags = 0;

                mtt = sipMalloc(sizeof (mappedTypeTmplDef));

                mtt->sig = (yyvsp[(1) - (4)].signature);
                mtt->mt = allocMappedType(currentSpec, &(yyvsp[(3) - (4)].memArg));
                mtt->mt->doctype = getDocType(&(yyvsp[(4) - (4)].optflags));
                mtt->next = currentSpec->mappedtypetemplates;

                currentSpec->mappedtypetemplates = mtt;

                currentMappedType = mtt->mt;

                /* Create a dummy interface file. */
                iff = sipMalloc(sizeof (ifaceFileDef));
                iff->hdrcode = NULL;
                mtt->mt->iff = iff;
            }
        }
    break;

  case 85:

/* Line 1455 of yacc.c  */
#line 968 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                if (currentMappedType->convfromcode == NULL)
                    yyerror("%MappedType must have a %ConvertFromTypeCode directive");

                if (currentMappedType->convtocode == NULL)
                    yyerror("%MappedType must have a %ConvertToTypeCode directive");

                currentMappedType = NULL;
            }
        }
    break;

  case 90:

/* Line 1455 of yacc.c  */
#line 988 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
                appendCodeBlock(&currentMappedType->iff->hdrcode, (yyvsp[(1) - (1)].codeb));
        }
    break;

  case 91:

/* Line 1455 of yacc.c  */
#line 992 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
                appendCodeBlock(&currentMappedType->typecode, (yyvsp[(1) - (1)].codeb));
        }
    break;

  case 92:

/* Line 1455 of yacc.c  */
#line 996 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                if (currentMappedType->convfromcode != NULL)
                    yyerror("%MappedType has more than one %ConvertFromTypeCode directive");

                appendCodeBlock(&currentMappedType->convfromcode, (yyvsp[(2) - (2)].codeb));
            }
        }
    break;

  case 93:

/* Line 1455 of yacc.c  */
#line 1005 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                if (currentMappedType->convtocode != NULL)
                    yyerror("%MappedType has more than one %ConvertToTypeCode directive");

                appendCodeBlock(&currentMappedType->convtocode, (yyvsp[(2) - (2)].codeb));
            }
        }
    break;

  case 96:

/* Line 1455 of yacc.c  */
#line 1018 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                applyTypeFlags(currentModule, &(yyvsp[(2) - (13)].memArg), &(yyvsp[(9) - (13)].optflags));

                (yyvsp[(5) - (13)].signature).result = (yyvsp[(2) - (13)].memArg);

                newFunction(currentSpec, currentModule, NULL,
                        currentMappedType, 0, TRUE, FALSE, FALSE, FALSE, (yyvsp[(3) - (13)].text),
                        &(yyvsp[(5) - (13)].signature), (yyvsp[(7) - (13)].number), FALSE, &(yyvsp[(9) - (13)].optflags), (yyvsp[(13) - (13)].codeb), NULL, (yyvsp[(8) - (13)].throwlist), (yyvsp[(10) - (13)].optsignature), (yyvsp[(12) - (13)].codeb));
            }
        }
    break;

  case 97:

/* Line 1455 of yacc.c  */
#line 1032 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (currentSpec -> genc)
                yyerror("namespace definition not allowed in a C module");

            if (notSkipping())
            {
                classDef *ns, *c_scope;
                ifaceFileDef *scope;

                if ((c_scope = currentScope()) != NULL)
                    scope = c_scope->iff;
                else
                    scope = NULL;

                ns = newClass(currentSpec, namespace_iface, NULL,
                        text2scopedName(scope, (yyvsp[(2) - (2)].text)));

                pushScope(ns);

                sectionFlags = 0;
            }
        }
    break;

  case 98:

/* Line 1455 of yacc.c  */
#line 1053 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                if (inMainModule())
                {
                    classDef *ns = currentScope();

                    setIsUsedName(ns->iff->name);
                    setIsUsedName(ns->pyname);
                }

                popScope();
            }
        }
    break;

  case 103:

/* Line 1455 of yacc.c  */
#line 1077 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                qualDef *qd;

                for (qd = currentModule->qualifiers; qd != NULL; qd = qd->next)
                    if (qd->qtype == platform_qualifier)
                        yyerror("%Platforms has already been defined for this module");
            }
        }
    break;

  case 104:

/* Line 1455 of yacc.c  */
#line 1087 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                qualDef *qd;
                int nrneeded;

                /* Check that exactly one platform in the set was requested. */
                nrneeded = 0;

                for (qd = currentModule->qualifiers; qd != NULL; qd = qd->next)
                    if (qd->qtype == platform_qualifier && isNeeded(qd))
                        ++nrneeded;

                if (nrneeded > 1)
                    yyerror("No more than one of these %Platforms must be specified with the -t flag");
            }
        }
    break;

  case 107:

/* Line 1455 of yacc.c  */
#line 1110 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            currentModule->virterrorhandler = (yyvsp[(2) - (2)].text);
        }
    break;

  case 108:

/* Line 1455 of yacc.c  */
#line 1115 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            newQualifier(currentModule,-1,-1,(yyvsp[(1) - (1)].text),platform_qualifier);
        }
    break;

  case 109:

/* Line 1455 of yacc.c  */
#line 1120 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
                newQualifier(currentModule, -1, -1, (yyvsp[(2) - (2)].feature).name,
                        feature_qualifier);
        }
    break;

  case 110:

/* Line 1455 of yacc.c  */
#line 1127 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            resetLexerState();

            (yyval.feature).name = (yyvsp[(1) - (1)].text);
        }
    break;

  case 111:

/* Line 1455 of yacc.c  */
#line 1132 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.feature) = (yyvsp[(2) - (3)].feature);
        }
    break;

  case 113:

/* Line 1455 of yacc.c  */
#line 1138 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.feature) = (yyvsp[(1) - (3)].feature);

            switch ((yyvsp[(3) - (3)].feature).token)
            {
            case TK_NAME: (yyval.feature).name = (yyvsp[(3) - (3)].feature).name; break;
            }
        }
    break;

  case 114:

/* Line 1455 of yacc.c  */
#line 1148 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.feature).token = TK_NAME;

            (yyval.feature).name = (yyvsp[(3) - (3)].text);
        }
    break;

  case 115:

/* Line 1455 of yacc.c  */
#line 1155 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            currentTimelineOrder = 0;
        }
    break;

  case 116:

/* Line 1455 of yacc.c  */
#line 1158 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                qualDef *qd;
                int nrneeded;

                /*
                 * Check that exactly one time slot in the set was requested.
                 */
                nrneeded = 0;

                for (qd = currentModule->qualifiers; qd != NULL; qd = qd->next)
                    if (qd->qtype == time_qualifier && isNeeded(qd))
                        ++nrneeded;

                if (nrneeded > 1)
                    yyerror("At most one of this %Timeline must be specified with the -t flag");

                currentModule->nrtimelines++;
            }
        }
    break;

  case 119:

/* Line 1455 of yacc.c  */
#line 1185 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            newQualifier(currentModule, currentModule->nrtimelines,
                    currentTimelineOrder++, (yyvsp[(1) - (1)].text), time_qualifier);
        }
    break;

  case 120:

/* Line 1455 of yacc.c  */
#line 1191 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (skipStackPtr >= MAX_NESTED_IF)
                yyerror("Internal error: increase the value of MAX_NESTED_IF");

            /* Nested %Ifs are implicit logical ands. */

            if (skipStackPtr > 0)
                (yyvsp[(3) - (4)].boolean) = ((yyvsp[(3) - (4)].boolean) && skipStack[skipStackPtr - 1]);

            skipStack[skipStackPtr++] = (yyvsp[(3) - (4)].boolean);
        }
    break;

  case 121:

/* Line 1455 of yacc.c  */
#line 1204 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.boolean) = platOrFeature((yyvsp[(1) - (1)].text),FALSE);
        }
    break;

  case 122:

/* Line 1455 of yacc.c  */
#line 1207 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.boolean) = platOrFeature((yyvsp[(2) - (2)].text),TRUE);
        }
    break;

  case 123:

/* Line 1455 of yacc.c  */
#line 1210 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.boolean) = (platOrFeature((yyvsp[(3) - (3)].text),FALSE) || (yyvsp[(1) - (3)].boolean));
        }
    break;

  case 124:

/* Line 1455 of yacc.c  */
#line 1213 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.boolean) = (platOrFeature((yyvsp[(4) - (4)].text),TRUE) || (yyvsp[(1) - (4)].boolean));
        }
    break;

  case 126:

/* Line 1455 of yacc.c  */
#line 1219 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.boolean) = timePeriod((yyvsp[(1) - (3)].text), (yyvsp[(3) - (3)].text));
        }
    break;

  case 127:

/* Line 1455 of yacc.c  */
#line 1224 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (skipStackPtr-- <= 0)
                yyerror("Too many %End directives");
        }
    break;

  case 128:

/* Line 1455 of yacc.c  */
#line 1230 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            optFlag *of;

            if ((yyvsp[(3) - (3)].optflags).nrFlags != 0)
                deprecated("%License annotations are deprecated, use arguments instead");

            if ((yyvsp[(2) - (3)].license).type == NULL)
                if ((of = getOptFlag(&(yyvsp[(3) - (3)].optflags), "Type", string_flag)) != NULL)
                    (yyvsp[(2) - (3)].license).type = of->fvalue.sval;

            if ((yyvsp[(2) - (3)].license).licensee == NULL)
                if ((of = getOptFlag(&(yyvsp[(3) - (3)].optflags), "Licensee", string_flag)) != NULL)
                    (yyvsp[(2) - (3)].license).licensee = of->fvalue.sval;

            if ((yyvsp[(2) - (3)].license).signature == NULL)
                if ((of = getOptFlag(&(yyvsp[(3) - (3)].optflags), "Signature", string_flag)) != NULL)
                    (yyvsp[(2) - (3)].license).signature = of->fvalue.sval;

            if ((yyvsp[(2) - (3)].license).timestamp == NULL)
                if ((of = getOptFlag(&(yyvsp[(3) - (3)].optflags), "Timestamp", string_flag)) != NULL)
                    (yyvsp[(2) - (3)].license).timestamp = of->fvalue.sval;

            if ((yyvsp[(2) - (3)].license).type == NULL)
                yyerror("%License must have a 'type' argument");

            if (notSkipping())
            {
                currentModule->license = sipMalloc(sizeof (licenseDef));

                currentModule->license->type = (yyvsp[(2) - (3)].license).type;
                currentModule->license->licensee = (yyvsp[(2) - (3)].license).licensee;
                currentModule->license->sig = (yyvsp[(2) - (3)].license).signature;
                currentModule->license->timestamp = (yyvsp[(2) - (3)].license).timestamp;
            }
        }
    break;

  case 129:

/* Line 1455 of yacc.c  */
#line 1267 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            resetLexerState();

            (yyval.license).type = NULL;
            (yyval.license).licensee = NULL;
            (yyval.license).signature = NULL;
            (yyval.license).timestamp = NULL;
        }
    break;

  case 130:

/* Line 1455 of yacc.c  */
#line 1275 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.license).type = (yyvsp[(1) - (1)].text);
            (yyval.license).licensee = NULL;
            (yyval.license).signature = NULL;
            (yyval.license).timestamp = NULL;
        }
    break;

  case 131:

/* Line 1455 of yacc.c  */
#line 1281 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.license) = (yyvsp[(2) - (3)].license);
        }
    break;

  case 133:

/* Line 1455 of yacc.c  */
#line 1287 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.license) = (yyvsp[(1) - (3)].license);

            switch ((yyvsp[(3) - (3)].license).token)
            {
            case TK_TYPE: (yyval.license).type = (yyvsp[(3) - (3)].license).type; break;
            case TK_LICENSEE: (yyval.license).licensee = (yyvsp[(3) - (3)].license).licensee; break;
            case TK_SIGNATURE: (yyval.license).signature = (yyvsp[(3) - (3)].license).signature; break;
            case TK_TIMESTAMP: (yyval.license).timestamp = (yyvsp[(3) - (3)].license).timestamp; break;
            }
        }
    break;

  case 134:

/* Line 1455 of yacc.c  */
#line 1300 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.license).token = TK_NAME;

            (yyval.license).type = (yyvsp[(3) - (3)].text);
            (yyval.license).licensee = NULL;
            (yyval.license).signature = NULL;
            (yyval.license).timestamp = NULL;
        }
    break;

  case 135:

/* Line 1455 of yacc.c  */
#line 1308 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.license).token = TK_LICENSEE;

            (yyval.license).type = NULL;
            (yyval.license).licensee = (yyvsp[(3) - (3)].text);
            (yyval.license).signature = NULL;
            (yyval.license).timestamp = NULL;
        }
    break;

  case 136:

/* Line 1455 of yacc.c  */
#line 1316 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.license).token = TK_SIGNATURE;

            (yyval.license).type = NULL;
            (yyval.license).licensee = NULL;
            (yyval.license).signature = (yyvsp[(3) - (3)].text);
            (yyval.license).timestamp = NULL;
        }
    break;

  case 137:

/* Line 1455 of yacc.c  */
#line 1324 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.license).token = TK_TIMESTAMP;

            (yyval.license).type = NULL;
            (yyval.license).licensee = NULL;
            (yyval.license).signature = NULL;
            (yyval.license).timestamp = (yyvsp[(3) - (3)].text);
        }
    break;

  case 138:

/* Line 1455 of yacc.c  */
#line 1334 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                if (currentModule->defmetatype != NULL)
                    yyerror("%DefaultMetatype has already been defined for this module");

                currentModule->defmetatype = cacheName(currentSpec, (yyvsp[(2) - (2)].defmetatype).name);
            }
        }
    break;

  case 139:

/* Line 1455 of yacc.c  */
#line 1345 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            resetLexerState();

            (yyval.defmetatype).name = (yyvsp[(1) - (1)].text);
        }
    break;

  case 140:

/* Line 1455 of yacc.c  */
#line 1350 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.defmetatype) = (yyvsp[(2) - (3)].defmetatype);
        }
    break;

  case 142:

/* Line 1455 of yacc.c  */
#line 1356 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.defmetatype) = (yyvsp[(1) - (3)].defmetatype);

            switch ((yyvsp[(3) - (3)].defmetatype).token)
            {
            case TK_NAME: (yyval.defmetatype).name = (yyvsp[(3) - (3)].defmetatype).name; break;
            }
        }
    break;

  case 143:

/* Line 1455 of yacc.c  */
#line 1366 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.defmetatype).token = TK_NAME;

            (yyval.defmetatype).name = (yyvsp[(3) - (3)].text);
        }
    break;

  case 144:

/* Line 1455 of yacc.c  */
#line 1373 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                if (currentModule->defsupertype != NULL)
                    yyerror("%DefaultSupertype has already been defined for this module");

                currentModule->defsupertype = cacheName(currentSpec, (yyvsp[(2) - (2)].defsupertype).name);
            }
        }
    break;

  case 145:

/* Line 1455 of yacc.c  */
#line 1384 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            resetLexerState();

            (yyval.defsupertype).name = (yyvsp[(1) - (1)].text);
        }
    break;

  case 146:

/* Line 1455 of yacc.c  */
#line 1389 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.defsupertype) = (yyvsp[(2) - (3)].defsupertype);
        }
    break;

  case 148:

/* Line 1455 of yacc.c  */
#line 1395 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.defsupertype) = (yyvsp[(1) - (3)].defsupertype);

            switch ((yyvsp[(3) - (3)].defsupertype).token)
            {
            case TK_NAME: (yyval.defsupertype).name = (yyvsp[(3) - (3)].defsupertype).name; break;
            }
        }
    break;

  case 149:

/* Line 1455 of yacc.c  */
#line 1405 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.defsupertype).token = TK_NAME;

            (yyval.defsupertype).name = (yyvsp[(3) - (3)].text);
        }
    break;

  case 150:

/* Line 1455 of yacc.c  */
#line 1412 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                /* Make sure this is the first mention of a module. */
                if (currentSpec->module != currentModule)
                    yyerror("A %ConsolidatedModule cannot be %Imported");

                if (currentModule->fullname != NULL)
                    yyerror("%ConsolidatedModule must appear before any %Module or %CModule directive");

                setModuleName(currentSpec, currentModule, (yyvsp[(2) - (3)].consmodule).name);
                appendCodeBlock(&currentModule->docstring, (yyvsp[(3) - (3)].consmodule).docstring);

                setIsConsolidated(currentModule);
            }
        }
    break;

  case 151:

/* Line 1455 of yacc.c  */
#line 1430 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            resetLexerState();

            (yyval.consmodule).name = (yyvsp[(1) - (1)].text);
        }
    break;

  case 152:

/* Line 1455 of yacc.c  */
#line 1435 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.consmodule) = (yyvsp[(2) - (3)].consmodule);
        }
    break;

  case 154:

/* Line 1455 of yacc.c  */
#line 1441 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.consmodule) = (yyvsp[(1) - (3)].consmodule);

            switch ((yyvsp[(3) - (3)].consmodule).token)
            {
            case TK_NAME: (yyval.consmodule).name = (yyvsp[(3) - (3)].consmodule).name; break;
            }
        }
    break;

  case 155:

/* Line 1455 of yacc.c  */
#line 1451 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.consmodule).token = TK_NAME;

            (yyval.consmodule).name = (yyvsp[(3) - (3)].text);
        }
    break;

  case 156:

/* Line 1455 of yacc.c  */
#line 1458 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.consmodule).token = 0;
            (yyval.consmodule).docstring = NULL;
        }
    break;

  case 157:

/* Line 1455 of yacc.c  */
#line 1462 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.consmodule) = (yyvsp[(2) - (4)].consmodule);
        }
    break;

  case 159:

/* Line 1455 of yacc.c  */
#line 1468 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.consmodule) = (yyvsp[(1) - (2)].consmodule);

            switch ((yyvsp[(2) - (2)].consmodule).token)
            {
            case TK_DOCSTRING: (yyval.consmodule).docstring = (yyvsp[(2) - (2)].consmodule).docstring; break;
            }
        }
    break;

  case 160:

/* Line 1455 of yacc.c  */
#line 1478 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.consmodule).token = TK_IF;
        }
    break;

  case 161:

/* Line 1455 of yacc.c  */
#line 1481 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.consmodule).token = TK_END;
        }
    break;

  case 162:

/* Line 1455 of yacc.c  */
#line 1484 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                (yyval.consmodule).token = TK_DOCSTRING;
                (yyval.consmodule).docstring = (yyvsp[(1) - (1)].codeb);
            }
            else
            {
                (yyval.consmodule).token = 0;
                (yyval.consmodule).docstring = NULL;
            }
        }
    break;

  case 163:

/* Line 1455 of yacc.c  */
#line 1498 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                /* Make sure this is the first mention of a module. */
                if (currentSpec->module != currentModule)
                    yyerror("A %CompositeModule cannot be %Imported");

                if (currentModule->fullname != NULL)
                    yyerror("%CompositeModule must appear before any %Module directive");

                setModuleName(currentSpec, currentModule, (yyvsp[(2) - (3)].compmodule).name);
                appendCodeBlock(&currentModule->docstring, (yyvsp[(3) - (3)].compmodule).docstring);

                setIsComposite(currentModule);
            }
        }
    break;

  case 164:

/* Line 1455 of yacc.c  */
#line 1516 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            resetLexerState();

            (yyval.compmodule).name = (yyvsp[(1) - (1)].text);
        }
    break;

  case 165:

/* Line 1455 of yacc.c  */
#line 1521 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.compmodule) = (yyvsp[(2) - (3)].compmodule);
        }
    break;

  case 167:

/* Line 1455 of yacc.c  */
#line 1527 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.compmodule) = (yyvsp[(1) - (3)].compmodule);

            switch ((yyvsp[(3) - (3)].compmodule).token)
            {
            case TK_NAME: (yyval.compmodule).name = (yyvsp[(3) - (3)].compmodule).name; break;
            }
        }
    break;

  case 168:

/* Line 1455 of yacc.c  */
#line 1537 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.compmodule).token = TK_NAME;

            (yyval.compmodule).name = (yyvsp[(3) - (3)].text);
        }
    break;

  case 169:

/* Line 1455 of yacc.c  */
#line 1544 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.compmodule).token = 0;
            (yyval.compmodule).docstring = NULL;
        }
    break;

  case 170:

/* Line 1455 of yacc.c  */
#line 1548 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.compmodule) = (yyvsp[(2) - (4)].compmodule);
        }
    break;

  case 172:

/* Line 1455 of yacc.c  */
#line 1554 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.compmodule) = (yyvsp[(1) - (2)].compmodule);

            switch ((yyvsp[(2) - (2)].compmodule).token)
            {
            case TK_DOCSTRING: (yyval.compmodule).docstring = (yyvsp[(2) - (2)].compmodule).docstring; break;
            }
        }
    break;

  case 173:

/* Line 1455 of yacc.c  */
#line 1564 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.compmodule).token = TK_IF;
        }
    break;

  case 174:

/* Line 1455 of yacc.c  */
#line 1567 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.compmodule).token = TK_END;
        }
    break;

  case 175:

/* Line 1455 of yacc.c  */
#line 1570 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                (yyval.compmodule).token = TK_DOCSTRING;
                (yyval.compmodule).docstring = (yyvsp[(1) - (1)].codeb);
            }
            else
            {
                (yyval.compmodule).token = 0;
                (yyval.compmodule).docstring = NULL;
            }
        }
    break;

  case 176:

/* Line 1455 of yacc.c  */
#line 1584 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if ((yyvsp[(2) - (3)].module).name == NULL)
                yyerror("%Module must have a 'name' argument");

            if (notSkipping())
                currentModule = configureModule(currentSpec, currentModule,
                        currentContext.filename, (yyvsp[(2) - (3)].module).name, (yyvsp[(2) - (3)].module).version,
                        (yyvsp[(2) - (3)].module).c_module, (yyvsp[(2) - (3)].module).kwargs, (yyvsp[(2) - (3)].module).use_arg_names,
                        (yyvsp[(3) - (3)].module).docstring);
        }
    break;

  case 177:

/* Line 1455 of yacc.c  */
#line 1594 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            deprecated("%CModule is deprecated, use %Module and the 'language' argument instead");

            if (notSkipping())
                currentModule = configureModule(currentSpec, currentModule,
                        currentContext.filename, (yyvsp[(2) - (3)].text), (yyvsp[(3) - (3)].number), TRUE, defaultKwArgs,
                        FALSE, NULL);
        }
    break;

  case 178:

/* Line 1455 of yacc.c  */
#line 1604 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            resetLexerState();

            if ((yyvsp[(2) - (2)].number) >= 0)
                deprecated("%Module version number should be specified using the 'version' argument");

            (yyval.module).c_module = FALSE;
            (yyval.module).kwargs = defaultKwArgs;
            (yyval.module).name = (yyvsp[(1) - (2)].text);
            (yyval.module).use_arg_names = FALSE;
            (yyval.module).version = (yyvsp[(2) - (2)].number);
        }
    break;

  case 179:

/* Line 1455 of yacc.c  */
#line 1616 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.module) = (yyvsp[(2) - (3)].module);
        }
    break;

  case 181:

/* Line 1455 of yacc.c  */
#line 1622 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.module) = (yyvsp[(1) - (3)].module);

            switch ((yyvsp[(3) - (3)].module).token)
            {
            case TK_KWARGS: (yyval.module).kwargs = (yyvsp[(3) - (3)].module).kwargs; break;
            case TK_LANGUAGE: (yyval.module).c_module = (yyvsp[(3) - (3)].module).c_module; break;
            case TK_NAME: (yyval.module).name = (yyvsp[(3) - (3)].module).name; break;
            case TK_USEARGNAMES: (yyval.module).use_arg_names = (yyvsp[(3) - (3)].module).use_arg_names; break;
            case TK_VERSION: (yyval.module).version = (yyvsp[(3) - (3)].module).version; break;
            }
        }
    break;

  case 182:

/* Line 1455 of yacc.c  */
#line 1636 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.module).token = TK_KWARGS;

            (yyval.module).c_module = FALSE;
            (yyval.module).kwargs = convertKwArgs((yyvsp[(3) - (3)].text));
            (yyval.module).name = NULL;
            (yyval.module).use_arg_names = FALSE;
            (yyval.module).version = -1;
        }
    break;

  case 183:

/* Line 1455 of yacc.c  */
#line 1645 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.module).token = TK_LANGUAGE;

            if (strcmp((yyvsp[(3) - (3)].text), "C++") == 0)
                (yyval.module).c_module = FALSE;
            else if (strcmp((yyvsp[(3) - (3)].text), "C") == 0)
                (yyval.module).c_module = TRUE;
            else
                yyerror("%Module 'language' argument must be either \"C++\" or \"C\"");

            (yyval.module).kwargs = defaultKwArgs;
            (yyval.module).name = NULL;
            (yyval.module).use_arg_names = FALSE;
            (yyval.module).version = -1;
        }
    break;

  case 184:

/* Line 1455 of yacc.c  */
#line 1660 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.module).token = TK_NAME;

            (yyval.module).c_module = FALSE;
            (yyval.module).kwargs = defaultKwArgs;
            (yyval.module).name = (yyvsp[(3) - (3)].text);
            (yyval.module).use_arg_names = FALSE;
            (yyval.module).version = -1;
        }
    break;

  case 185:

/* Line 1455 of yacc.c  */
#line 1669 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.module).token = TK_USEARGNAMES;

            (yyval.module).c_module = FALSE;
            (yyval.module).kwargs = defaultKwArgs;
            (yyval.module).name = NULL;
            (yyval.module).use_arg_names = (yyvsp[(3) - (3)].boolean);
            (yyval.module).version = -1;
        }
    break;

  case 186:

/* Line 1455 of yacc.c  */
#line 1678 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if ((yyvsp[(3) - (3)].number) < 0)
                yyerror("%Module 'version' argument cannot be negative");

            (yyval.module).token = TK_VERSION;

            (yyval.module).c_module = FALSE;
            (yyval.module).kwargs = defaultKwArgs;
            (yyval.module).name = NULL;
            (yyval.module).use_arg_names = FALSE;
            (yyval.module).version = (yyvsp[(3) - (3)].number);
        }
    break;

  case 187:

/* Line 1455 of yacc.c  */
#line 1692 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.module).token = 0;
            (yyval.module).docstring = NULL;
        }
    break;

  case 188:

/* Line 1455 of yacc.c  */
#line 1696 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.module) = (yyvsp[(2) - (4)].module);
        }
    break;

  case 190:

/* Line 1455 of yacc.c  */
#line 1702 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.module) = (yyvsp[(1) - (2)].module);

            switch ((yyvsp[(2) - (2)].module).token)
            {
            case TK_DOCSTRING: (yyval.module).docstring = (yyvsp[(2) - (2)].module).docstring; break;
            }
        }
    break;

  case 191:

/* Line 1455 of yacc.c  */
#line 1712 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.module).token = TK_IF;
        }
    break;

  case 192:

/* Line 1455 of yacc.c  */
#line 1715 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.module).token = TK_END;
        }
    break;

  case 193:

/* Line 1455 of yacc.c  */
#line 1718 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.module).token = TK_AUTOPYNAME;
        }
    break;

  case 194:

/* Line 1455 of yacc.c  */
#line 1721 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                (yyval.module).token = TK_DOCSTRING;
                (yyval.module).docstring = (yyvsp[(1) - (1)].codeb);
            }
            else
            {
                (yyval.module).token = 0;
                (yyval.module).docstring = NULL;
            }
        }
    break;

  case 196:

/* Line 1455 of yacc.c  */
#line 1736 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            /*
             * The grammar design is a bit broken and this is the easiest way
             * to allow periods in names.
             */

            char *cp;

            for (cp = (yyvsp[(1) - (1)].text); *cp != '\0'; ++cp)
                if (*cp != '.' && *cp != '_' && !isalnum(*cp))
                    yyerror("Invalid character in name");

            (yyval.text) = (yyvsp[(1) - (1)].text);
        }
    break;

  case 197:

/* Line 1455 of yacc.c  */
#line 1752 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.number) = -1;
        }
    break;

  case 199:

/* Line 1455 of yacc.c  */
#line 1758 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if ((yyvsp[(2) - (2)].include).name == NULL)
                yyerror("%Include must have a 'name' argument");

            if (notSkipping())
                parseFile(NULL, (yyvsp[(2) - (2)].include).name, NULL, (yyvsp[(2) - (2)].include).optional);
        }
    break;

  case 200:

/* Line 1455 of yacc.c  */
#line 1767 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            resetLexerState();

            (yyval.include).name = (yyvsp[(1) - (1)].text);
            (yyval.include).optional = FALSE;
        }
    break;

  case 201:

/* Line 1455 of yacc.c  */
#line 1773 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.include) = (yyvsp[(2) - (3)].include);
        }
    break;

  case 203:

/* Line 1455 of yacc.c  */
#line 1779 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.include) = (yyvsp[(1) - (3)].include);

            switch ((yyvsp[(3) - (3)].include).token)
            {
            case TK_NAME: (yyval.include).name = (yyvsp[(3) - (3)].include).name; break;
            case TK_OPTIONAL: (yyval.include).optional = (yyvsp[(3) - (3)].include).optional; break;
            }
        }
    break;

  case 204:

/* Line 1455 of yacc.c  */
#line 1790 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.include).token = TK_NAME;

            (yyval.include).name = (yyvsp[(3) - (3)].text);
            (yyval.include).optional = FALSE;
        }
    break;

  case 205:

/* Line 1455 of yacc.c  */
#line 1796 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.include).token = TK_OPTIONAL;

            (yyval.include).name = NULL;
            (yyval.include).optional = (yyvsp[(3) - (3)].boolean);
        }
    break;

  case 206:

/* Line 1455 of yacc.c  */
#line 1804 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            deprecated("%OptionalInclude is deprecated, use %Include and the 'optional' argument instead");

            if (notSkipping())
                parseFile(NULL, (yyvsp[(2) - (2)].text), NULL, TRUE);
        }
    break;

  case 207:

/* Line 1455 of yacc.c  */
#line 1812 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
                newImport((yyvsp[(2) - (2)].import).name);
        }
    break;

  case 208:

/* Line 1455 of yacc.c  */
#line 1818 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            resetLexerState();

            (yyval.import).name = (yyvsp[(1) - (1)].text);
        }
    break;

  case 209:

/* Line 1455 of yacc.c  */
#line 1823 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.import) = (yyvsp[(2) - (3)].import);
        }
    break;

  case 211:

/* Line 1455 of yacc.c  */
#line 1829 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.import) = (yyvsp[(1) - (3)].import);

            switch ((yyvsp[(3) - (3)].import).token)
            {
            case TK_NAME: (yyval.import).name = (yyvsp[(3) - (3)].import).name; break;
            }
        }
    break;

  case 212:

/* Line 1455 of yacc.c  */
#line 1839 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.import).token = TK_NAME;

            (yyval.import).name = (yyvsp[(3) - (3)].text);
        }
    break;

  case 213:

/* Line 1455 of yacc.c  */
#line 1846 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.codeb) = NULL;
        }
    break;

  case 214:

/* Line 1455 of yacc.c  */
#line 1849 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.codeb) = (yyvsp[(2) - (2)].codeb);
        }
    break;

  case 215:

/* Line 1455 of yacc.c  */
#line 1854 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.codeb) = NULL;
        }
    break;

  case 216:

/* Line 1455 of yacc.c  */
#line 1857 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.codeb) = (yyvsp[(2) - (2)].codeb);
        }
    break;

  case 217:

/* Line 1455 of yacc.c  */
#line 1862 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.codeb) = NULL;
        }
    break;

  case 218:

/* Line 1455 of yacc.c  */
#line 1865 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.codeb) = (yyvsp[(2) - (2)].codeb);
        }
    break;

  case 219:

/* Line 1455 of yacc.c  */
#line 1870 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
                appendCodeBlock(&currentModule->copying, (yyvsp[(2) - (2)].codeb));
        }
    break;

  case 220:

/* Line 1455 of yacc.c  */
#line 1876 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
                appendCodeBlock(&currentSpec->exphdrcode, (yyvsp[(2) - (2)].codeb));
        }
    break;

  case 221:

/* Line 1455 of yacc.c  */
#line 1882 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
                appendCodeBlock(&currentModule->hdrcode, (yyvsp[(2) - (2)].codeb));
        }
    break;

  case 222:

/* Line 1455 of yacc.c  */
#line 1888 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.codeb) = (yyvsp[(2) - (2)].codeb);
        }
    break;

  case 223:

/* Line 1455 of yacc.c  */
#line 1893 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.codeb) = (yyvsp[(2) - (2)].codeb);
        }
    break;

  case 224:

/* Line 1455 of yacc.c  */
#line 1898 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.codeb) = (yyvsp[(2) - (2)].codeb);
        }
    break;

  case 225:

/* Line 1455 of yacc.c  */
#line 1903 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.codeb) = (yyvsp[(2) - (2)].codeb);
        }
    break;

  case 226:

/* Line 1455 of yacc.c  */
#line 1908 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.codeb) = (yyvsp[(2) - (2)].codeb);
        }
    break;

  case 227:

/* Line 1455 of yacc.c  */
#line 1913 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.codeb) = (yyvsp[(2) - (2)].codeb);
        }
    break;

  case 228:

/* Line 1455 of yacc.c  */
#line 1918 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.codeb) = (yyvsp[(2) - (2)].codeb);
        }
    break;

  case 229:

/* Line 1455 of yacc.c  */
#line 1923 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.codeb) = (yyvsp[(2) - (2)].codeb);
        }
    break;

  case 230:

/* Line 1455 of yacc.c  */
#line 1928 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.codeb) = (yyvsp[(2) - (2)].codeb);
        }
    break;

  case 231:

/* Line 1455 of yacc.c  */
#line 1933 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.codeb) = (yyvsp[(2) - (2)].codeb);
        }
    break;

  case 232:

/* Line 1455 of yacc.c  */
#line 1938 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
                appendCodeBlock(&currentModule->cppcode, (yyvsp[(2) - (2)].codeb));
        }
    break;

  case 233:

/* Line 1455 of yacc.c  */
#line 1944 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.codeb) = (yyvsp[(2) - (2)].codeb);
        }
    break;

  case 234:

/* Line 1455 of yacc.c  */
#line 1949 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
                appendCodeBlock(&currentModule->preinitcode, (yyvsp[(2) - (2)].codeb));
        }
    break;

  case 235:

/* Line 1455 of yacc.c  */
#line 1955 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
                appendCodeBlock(&currentModule->initcode, (yyvsp[(2) - (2)].codeb));
        }
    break;

  case 236:

/* Line 1455 of yacc.c  */
#line 1961 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
                appendCodeBlock(&currentModule->postinitcode, (yyvsp[(2) - (2)].codeb));
        }
    break;

  case 237:

/* Line 1455 of yacc.c  */
#line 1967 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
                appendCodeBlock(&currentModule->unitcode, (yyvsp[(2) - (2)].codeb));
        }
    break;

  case 238:

/* Line 1455 of yacc.c  */
#line 1973 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
                appendCodeBlock(&currentModule->unitpostinccode, (yyvsp[(2) - (2)].codeb));
        }
    break;

  case 239:

/* Line 1455 of yacc.c  */
#line 1979 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            /* Deprecated. */
        }
    break;

  case 240:

/* Line 1455 of yacc.c  */
#line 1984 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping() && inMainModule())
                appendCodeBlock(&currentSpec->docs, (yyvsp[(2) - (2)].codeb));
        }
    break;

  case 241:

/* Line 1455 of yacc.c  */
#line 1990 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
                appendCodeBlock(&currentSpec->docs, (yyvsp[(2) - (2)].codeb));
        }
    break;

  case 242:

/* Line 1455 of yacc.c  */
#line 1996 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
                addAutoPyName(currentModule, (yyvsp[(2) - (2)].autopyname).remove_leading);
        }
    break;

  case 243:

/* Line 1455 of yacc.c  */
#line 2002 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.autopyname) = (yyvsp[(2) - (3)].autopyname);
        }
    break;

  case 245:

/* Line 1455 of yacc.c  */
#line 2008 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.autopyname) = (yyvsp[(1) - (3)].autopyname);

            switch ((yyvsp[(3) - (3)].autopyname).token)
            {
            case TK_REMOVELEADING: (yyval.autopyname).remove_leading = (yyvsp[(3) - (3)].autopyname).remove_leading; break;
            }
        }
    break;

  case 246:

/* Line 1455 of yacc.c  */
#line 2018 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.autopyname).token = TK_REMOVELEADING;

            (yyval.autopyname).remove_leading = (yyvsp[(3) - (3)].text);
        }
    break;

  case 247:

/* Line 1455 of yacc.c  */
#line 2025 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if ((yyvsp[(2) - (3)].extract).id == NULL)
                yyerror("%Extract must have an 'id' argument");

            if (notSkipping())
                addExtractPart(currentSpec, (yyvsp[(2) - (3)].extract).id, (yyvsp[(2) - (3)].extract).order, (yyvsp[(3) - (3)].codeb));
        }
    break;

  case 248:

/* Line 1455 of yacc.c  */
#line 2034 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            resetLexerState();

            (yyval.extract).id = (yyvsp[(1) - (1)].text);
            (yyval.extract).order = -1;
        }
    break;

  case 249:

/* Line 1455 of yacc.c  */
#line 2040 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.extract) = (yyvsp[(2) - (3)].extract);
        }
    break;

  case 251:

/* Line 1455 of yacc.c  */
#line 2046 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.extract) = (yyvsp[(1) - (3)].extract);

            switch ((yyvsp[(3) - (3)].extract).token)
            {
            case TK_ID: (yyval.extract).id = (yyvsp[(3) - (3)].extract).id; break;
            case TK_ORDER: (yyval.extract).order = (yyvsp[(3) - (3)].extract).order; break;
            }
        }
    break;

  case 252:

/* Line 1455 of yacc.c  */
#line 2057 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.extract).token = TK_ID;

            (yyval.extract).id = (yyvsp[(3) - (3)].text);
            (yyval.extract).order = -1;
        }
    break;

  case 253:

/* Line 1455 of yacc.c  */
#line 2063 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.extract).token = TK_ORDER;

            if ((yyvsp[(3) - (3)].number) < 0)
                yyerror("The 'order' of an %Extract directive must not be negative");

            (yyval.extract).id = NULL;
            (yyval.extract).order = (yyvsp[(3) - (3)].number);
        }
    break;

  case 254:

/* Line 1455 of yacc.c  */
#line 2074 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            /* Deprecated. */
        }
    break;

  case 257:

/* Line 1455 of yacc.c  */
#line 2083 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.codeb) = (yyvsp[(1) - (2)].codeb);

            append(&(yyval.codeb)->frag, (yyvsp[(2) - (2)].codeb)->frag);

            free((yyvsp[(2) - (2)].codeb)->frag);
            free((char *)(yyvsp[(2) - (2)].codeb)->filename);
            free((yyvsp[(2) - (2)].codeb));
        }
    break;

  case 258:

/* Line 1455 of yacc.c  */
#line 2094 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                const char *annos[] = {
                    "PyName",
                    NULL
                };

                checkAnnos(&(yyvsp[(3) - (3)].optflags), annos);

                if (sectionFlags != 0 && (sectionFlags & ~(SECT_IS_PUBLIC | SECT_IS_PROT)) != 0)
                    yyerror("Class enums must be in the public or protected sections");

                currentEnum = newEnum(currentSpec, currentModule,
                        currentMappedType, (yyvsp[(2) - (3)].text), &(yyvsp[(3) - (3)].optflags), sectionFlags);
            }
        }
    break;

  case 260:

/* Line 1455 of yacc.c  */
#line 2113 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.text) = NULL;
        }
    break;

  case 261:

/* Line 1455 of yacc.c  */
#line 2116 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.text) = (yyvsp[(1) - (1)].text);
        }
    break;

  case 262:

/* Line 1455 of yacc.c  */
#line 2121 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.text) = NULL;
        }
    break;

  case 263:

/* Line 1455 of yacc.c  */
#line 2124 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.text) = (yyvsp[(1) - (1)].text);
        }
    break;

  case 270:

/* Line 1455 of yacc.c  */
#line 2139 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                const char *annos[] = {
                    "PyName",
                    NULL
                };

                enumMemberDef *emd, **tail;

                checkAnnos(&(yyvsp[(3) - (4)].optflags), annos);

                /* Note that we don't use the assigned value. */
                emd = sipMalloc(sizeof (enumMemberDef));

                emd -> pyname = cacheName(currentSpec,
                        getPythonName(currentModule, &(yyvsp[(3) - (4)].optflags), (yyvsp[(1) - (4)].text)));
                emd -> cname = (yyvsp[(1) - (4)].text);
                emd -> ed = currentEnum;
                emd -> next = NULL;

                checkAttributes(currentSpec, currentModule, emd->ed->ecd,
                        emd->ed->emtd, emd->pyname->text, FALSE);

                /* Append to preserve the order. */
                for (tail = &currentEnum->members; *tail != NULL; tail = &(*tail)->next)
                    ;

                *tail = emd;

                if (inMainModule())
                    setIsUsedName(emd -> pyname);
            }
        }
    break;

  case 275:

/* Line 1455 of yacc.c  */
#line 2183 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.valp) = NULL;
        }
    break;

  case 276:

/* Line 1455 of yacc.c  */
#line 2186 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.valp) = (yyvsp[(2) - (2)].valp);
        }
    break;

  case 278:

/* Line 1455 of yacc.c  */
#line 2192 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            valueDef *vd;
 
            if ((yyvsp[(1) - (3)].valp) -> vtype == string_value || (yyvsp[(3) - (3)].valp) -> vtype == string_value)
                yyerror("Invalid binary operator for string");
 
            /* Find the last value in the existing expression. */
 
            for (vd = (yyvsp[(1) - (3)].valp); vd -> next != NULL; vd = vd -> next)
                ;
 
            vd -> vbinop = (yyvsp[(2) - (3)].qchar);
            vd -> next = (yyvsp[(3) - (3)].valp);

            (yyval.valp) = (yyvsp[(1) - (3)].valp);
        }
    break;

  case 279:

/* Line 1455 of yacc.c  */
#line 2210 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.qchar) = '-';
        }
    break;

  case 280:

/* Line 1455 of yacc.c  */
#line 2213 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.qchar) = '+';
        }
    break;

  case 281:

/* Line 1455 of yacc.c  */
#line 2216 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.qchar) = '*';
        }
    break;

  case 282:

/* Line 1455 of yacc.c  */
#line 2219 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.qchar) = '/';
        }
    break;

  case 283:

/* Line 1455 of yacc.c  */
#line 2222 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.qchar) = '&';
        }
    break;

  case 284:

/* Line 1455 of yacc.c  */
#line 2225 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.qchar) = '|';
        }
    break;

  case 285:

/* Line 1455 of yacc.c  */
#line 2230 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.qchar) = '\0';
        }
    break;

  case 286:

/* Line 1455 of yacc.c  */
#line 2233 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.qchar) = '!';
        }
    break;

  case 287:

/* Line 1455 of yacc.c  */
#line 2236 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.qchar) = '~';
        }
    break;

  case 288:

/* Line 1455 of yacc.c  */
#line 2239 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.qchar) = '-';
        }
    break;

  case 289:

/* Line 1455 of yacc.c  */
#line 2242 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.qchar) = '+';
        }
    break;

  case 290:

/* Line 1455 of yacc.c  */
#line 2247 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if ((yyvsp[(1) - (2)].qchar) != '\0' && (yyvsp[(2) - (2)].value).vtype == string_value)
                yyerror("Invalid unary operator for string");
 
            /*
             * Convert the value to a simple expression on the
             * heap.
             */
 
            (yyval.valp) = sipMalloc(sizeof (valueDef));
 
            *(yyval.valp) = (yyvsp[(2) - (2)].value);
            (yyval.valp) -> vunop = (yyvsp[(1) - (2)].qchar);
            (yyval.valp) -> vbinop = '\0';
            (yyval.valp) -> next = NULL;
        }
    break;

  case 292:

/* Line 1455 of yacc.c  */
#line 2266 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (currentSpec -> genc)
                yyerror("Scoped names are not allowed in a C module");

            appendScopedName(&(yyvsp[(1) - (3)].scpvalp),(yyvsp[(3) - (3)].scpvalp));
        }
    break;

  case 293:

/* Line 1455 of yacc.c  */
#line 2274 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.scpvalp) = text2scopePart((yyvsp[(1) - (1)].text));
        }
    break;

  case 294:

/* Line 1455 of yacc.c  */
#line 2279 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.boolean) = TRUE;
        }
    break;

  case 295:

/* Line 1455 of yacc.c  */
#line 2282 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.boolean) = FALSE;
        }
    break;

  case 296:

/* Line 1455 of yacc.c  */
#line 2287 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            /*
             * We let the C++ compiler decide if the value is a valid one - no
             * point in building a full C++ parser here.
             */

            (yyval.value).vtype = scoped_value;
            (yyval.value).u.vscp = (yyvsp[(1) - (1)].scpvalp);
        }
    break;

  case 297:

/* Line 1455 of yacc.c  */
#line 2296 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            fcallDef *fcd;

            fcd = sipMalloc(sizeof (fcallDef));
            *fcd = (yyvsp[(3) - (4)].fcall);
            fcd -> type = (yyvsp[(1) - (4)].memArg);

            (yyval.value).vtype = fcall_value;
            (yyval.value).u.fcd = fcd;
        }
    break;

  case 298:

/* Line 1455 of yacc.c  */
#line 2306 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.value).vtype = real_value;
            (yyval.value).u.vreal = (yyvsp[(1) - (1)].real);
        }
    break;

  case 299:

/* Line 1455 of yacc.c  */
#line 2310 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.value).vtype = numeric_value;
            (yyval.value).u.vnum = (yyvsp[(1) - (1)].number);
        }
    break;

  case 300:

/* Line 1455 of yacc.c  */
#line 2314 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.value).vtype = numeric_value;
            (yyval.value).u.vnum = (yyvsp[(1) - (1)].boolean);
        }
    break;

  case 301:

/* Line 1455 of yacc.c  */
#line 2318 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.value).vtype = numeric_value;
            (yyval.value).u.vnum = 0;
        }
    break;

  case 302:

/* Line 1455 of yacc.c  */
#line 2322 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.value).vtype = string_value;
            (yyval.value).u.vstr = (yyvsp[(1) - (1)].text);
        }
    break;

  case 303:

/* Line 1455 of yacc.c  */
#line 2326 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.value).vtype = qchar_value;
            (yyval.value).u.vqchar = (yyvsp[(1) - (1)].qchar);
        }
    break;

  case 304:

/* Line 1455 of yacc.c  */
#line 2332 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            /* No values. */

            (yyval.fcall).nrArgs = 0;
        }
    break;

  case 305:

/* Line 1455 of yacc.c  */
#line 2337 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            /* The single or first expression. */

            (yyval.fcall).args[0] = (yyvsp[(1) - (1)].valp);
            (yyval.fcall).nrArgs = 1;
        }
    break;

  case 306:

/* Line 1455 of yacc.c  */
#line 2343 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            /* Check that it wasn't ...(,expression...). */

            if ((yyval.fcall).nrArgs == 0)
                yyerror("First argument to function call is missing");

            /* Check there is room. */

            if ((yyvsp[(1) - (3)].fcall).nrArgs == MAX_NR_ARGS)
                yyerror("Too many arguments to function call");

            (yyval.fcall) = (yyvsp[(1) - (3)].fcall);

            (yyval.fcall).args[(yyval.fcall).nrArgs] = (yyvsp[(3) - (3)].valp);
            (yyval.fcall).nrArgs++;
        }
    break;

  case 307:

/* Line 1455 of yacc.c  */
#line 2361 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                const char *annos[] = {
                    "DocType",
                    "Encoding",
                    "NoTypeName",
                    "PyInt",
                    NULL
                };

                checkAnnos(&(yyvsp[(4) - (5)].optflags), annos);

                applyTypeFlags(currentModule, &(yyvsp[(2) - (5)].memArg), &(yyvsp[(4) - (5)].optflags));
                newTypedef(currentSpec, currentModule, (yyvsp[(3) - (5)].text), &(yyvsp[(2) - (5)].memArg), &(yyvsp[(4) - (5)].optflags));
            }
        }
    break;

  case 308:

/* Line 1455 of yacc.c  */
#line 2378 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                const char *annos[] = {
                    "DocType",
                    "Encoding",
                    "NoTypeName",
                    "PyInt",
                    NULL
                };

                signatureDef *sig;
                argDef ftype;

                checkAnnos(&(yyvsp[(10) - (11)].optflags), annos);

                applyTypeFlags(currentModule, &(yyvsp[(2) - (11)].memArg), &(yyvsp[(10) - (11)].optflags));

                memset(&ftype, 0, sizeof (argDef));

                /* Create the full signature on the heap. */
                sig = sipMalloc(sizeof (signatureDef));
                *sig = (yyvsp[(8) - (11)].signature);
                sig->result = (yyvsp[(2) - (11)].memArg);

                /* Create the full type. */
                ftype.atype = function_type;
                ftype.nrderefs = (yyvsp[(4) - (11)].number);
                ftype.u.sa = sig;

                newTypedef(currentSpec, currentModule, (yyvsp[(5) - (11)].text), &ftype, &(yyvsp[(10) - (11)].optflags));
            }
        }
    break;

  case 309:

/* Line 1455 of yacc.c  */
#line 2413 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (currentSpec -> genc && (yyvsp[(2) - (2)].scpvalp)->next != NULL)
                yyerror("Namespaces not allowed in a C module");

            if (notSkipping())
                currentSupers = NULL;
        }
    break;

  case 310:

/* Line 1455 of yacc.c  */
#line 2419 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                const char *annos[] = {
                    "Abstract",
                    "AllowNone",
                    "API",
                    "DelayDtor",
                    "Deprecated",
                    "External",
                    "Metatype",
                    "NoDefaultCtors",
                    "PyName",
                    "PyQt4Flags",
                    "PyQt4NoQMetaObject",
                    "Supertype",
                    NULL
                };

                checkAnnos(&(yyvsp[(5) - (5)].optflags), annos);

                if (currentSpec->genc && currentSupers != NULL)
                    yyerror("Super-classes not allowed in a C module struct");

                defineClass((yyvsp[(2) - (5)].scpvalp), currentSupers, &(yyvsp[(5) - (5)].optflags));
                sectionFlags = SECT_IS_PUBLIC;
            }
        }
    break;

  case 311:

/* Line 1455 of yacc.c  */
#line 2446 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
                completeClass((yyvsp[(2) - (8)].scpvalp), &(yyvsp[(5) - (8)].optflags), (yyvsp[(7) - (8)].boolean));
        }
    break;

  case 312:

/* Line 1455 of yacc.c  */
#line 2452 "/blur/cpp/lib/sip/sipgen/parser.y"
    {currentIsTemplate = TRUE;}
    break;

  case 313:

/* Line 1455 of yacc.c  */
#line 2452 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (currentSpec->genc)
                yyerror("Class templates not allowed in a C module");

            if (notSkipping())
            {
                classTmplDef *tcd;

                /*
                 * Make sure there is room for the extra class name argument.
                 */
                if ((yyvsp[(1) - (3)].signature).nrArgs == MAX_NR_ARGS)
                    yyerror("Internal error - increase the value of MAX_NR_ARGS");

                tcd = sipMalloc(sizeof (classTmplDef));
                tcd->sig = (yyvsp[(1) - (3)].signature);
                tcd->cd = (yyvsp[(3) - (3)].klass);
                tcd->next = currentSpec->classtemplates;

                currentSpec->classtemplates = tcd;
            }

            currentIsTemplate = FALSE;
        }
    break;

  case 314:

/* Line 1455 of yacc.c  */
#line 2478 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.signature) = (yyvsp[(3) - (4)].signature);
        }
    break;

  case 315:

/* Line 1455 of yacc.c  */
#line 2483 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (currentSpec->genc)
                yyerror("Class definition not allowed in a C module");

            if (notSkipping())
                currentSupers = NULL;
        }
    break;

  case 316:

/* Line 1455 of yacc.c  */
#line 2489 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                const char *annos[] = {
                    "Abstract",
                    "AllowNone",
                    "API",
                    "DelayDtor",
                    "Deprecated",
                    "External",
                    "Metatype",
                    "NoDefaultCtors",
                    "PyName",
                    "PyQt4Flags",
                    "PyQt4NoQMetaObject",
                    "Supertype",
                    NULL
                };

                checkAnnos(&(yyvsp[(5) - (5)].optflags), annos);

                defineClass((yyvsp[(2) - (5)].scpvalp), currentSupers, &(yyvsp[(5) - (5)].optflags));
                sectionFlags = SECT_IS_PRIVATE;
            }
        }
    break;

  case 317:

/* Line 1455 of yacc.c  */
#line 2513 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
                (yyval.klass) = completeClass((yyvsp[(2) - (8)].scpvalp), &(yyvsp[(5) - (8)].optflags), (yyvsp[(7) - (8)].boolean));
        }
    break;

  case 322:

/* Line 1455 of yacc.c  */
#line 2527 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                argDef ad;
                classDef *super;
                scopedNameDef *snd = (yyvsp[(1) - (1)].scpvalp);

                /*
                 * This is a hack to allow typedef'ed classes to be used before
                 * we have resolved the typedef definitions.  Unlike elsewhere,
                 * we require that the typedef is defined before being used.
                 */
                for (;;)
                {
                    ad.atype = no_type;
                    ad.argflags = 0;
                    ad.nrderefs = 0;
                    ad.original_type = NULL;

                    searchTypedefs(currentSpec, snd, &ad);

                    if (ad.atype != defined_type)
                        break;

                    if (ad.nrderefs != 0 || isConstArg(&ad) || isReference(&ad))
                        break;

                    snd = ad.u.snd;
                }

                if (ad.atype != no_type)
                    yyerror("Super-class list contains an invalid type");

                super = findClass(currentSpec, class_iface, NULL, snd);
                appendToClassList(&currentSupers, super);
            }
        }
    break;

  case 323:

/* Line 1455 of yacc.c  */
#line 2566 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.boolean) = FALSE;
        }
    break;

  case 324:

/* Line 1455 of yacc.c  */
#line 2569 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.boolean) = TRUE;
        }
    break;

  case 336:

/* Line 1455 of yacc.c  */
#line 2587 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
                appendCodeBlock(&currentScope()->docstring, (yyvsp[(1) - (1)].codeb));
        }
    break;

  case 337:

/* Line 1455 of yacc.c  */
#line 2591 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
                appendCodeBlock(&currentScope()->cppcode, (yyvsp[(1) - (1)].codeb));
        }
    break;

  case 338:

/* Line 1455 of yacc.c  */
#line 2595 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
                appendCodeBlock(&currentScope()->iff->hdrcode, (yyvsp[(1) - (1)].codeb));
        }
    break;

  case 339:

/* Line 1455 of yacc.c  */
#line 2599 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                classDef *scope = currentScope();

                if (scope->travcode != NULL)
                    yyerror("%GCTraverseCode already given for class");

                appendCodeBlock(&scope->travcode, (yyvsp[(1) - (1)].codeb));
            }
        }
    break;

  case 340:

/* Line 1455 of yacc.c  */
#line 2610 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                classDef *scope = currentScope();

                if (scope->clearcode != NULL)
                    yyerror("%GCClearCode already given for class");

                appendCodeBlock(&scope->clearcode, (yyvsp[(1) - (1)].codeb));
            }
        }
    break;

  case 341:

/* Line 1455 of yacc.c  */
#line 2621 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                classDef *scope = currentScope();

                if (scope->getbufcode != NULL)
                    yyerror("%BIGetBufferCode already given for class");

                appendCodeBlock(&scope->getbufcode, (yyvsp[(1) - (1)].codeb));
            }
        }
    break;

  case 342:

/* Line 1455 of yacc.c  */
#line 2632 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                classDef *scope = currentScope();

                if (scope->releasebufcode != NULL)
                    yyerror("%BIReleaseBufferCode already given for class");

                appendCodeBlock(&scope->releasebufcode, (yyvsp[(1) - (1)].codeb));
            }
        }
    break;

  case 343:

/* Line 1455 of yacc.c  */
#line 2643 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                classDef *scope = currentScope();

                if (scope->readbufcode != NULL)
                    yyerror("%BIGetReadBufferCode already given for class");

                appendCodeBlock(&scope->readbufcode, (yyvsp[(1) - (1)].codeb));
            }
        }
    break;

  case 344:

/* Line 1455 of yacc.c  */
#line 2654 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                classDef *scope = currentScope();

                if (scope->writebufcode != NULL)
                    yyerror("%BIGetWriteBufferCode already given for class");

                appendCodeBlock(&scope->writebufcode, (yyvsp[(1) - (1)].codeb));
            }
        }
    break;

  case 345:

/* Line 1455 of yacc.c  */
#line 2665 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                classDef *scope = currentScope();

                if (scope->segcountcode != NULL)
                    yyerror("%BIGetSegCountCode already given for class");

                appendCodeBlock(&scope->segcountcode, (yyvsp[(1) - (1)].codeb));
            }
        }
    break;

  case 346:

/* Line 1455 of yacc.c  */
#line 2676 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                classDef *scope = currentScope();

                if (scope->charbufcode != NULL)
                    yyerror("%BIGetCharBufferCode already given for class");

                appendCodeBlock(&scope->charbufcode, (yyvsp[(1) - (1)].codeb));
            }
        }
    break;

  case 347:

/* Line 1455 of yacc.c  */
#line 2687 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                classDef *scope = currentScope();

                if (scope->picklecode != NULL)
                    yyerror("%PickleCode already given for class");

                appendCodeBlock(&scope->picklecode, (yyvsp[(1) - (1)].codeb));
            }
        }
    break;

  case 351:

/* Line 1455 of yacc.c  */
#line 2701 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                classDef *scope = currentScope();

                if (scope->convtosubcode != NULL)
                    yyerror("Class has more than one %ConvertToSubClassCode directive");

                appendCodeBlock(&scope->convtosubcode, (yyvsp[(2) - (2)].codeb));
            }
        }
    break;

  case 352:

/* Line 1455 of yacc.c  */
#line 2712 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                classDef *scope = currentScope();

                if (scope->convtocode != NULL)
                    yyerror("Class has more than one %ConvertToTypeCode directive");

                appendCodeBlock(&scope->convtocode, (yyvsp[(2) - (2)].codeb));
            }
        }
    break;

  case 353:

/* Line 1455 of yacc.c  */
#line 2723 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (currentSpec -> genc)
                yyerror("public section not allowed in a C module");

            if (notSkipping())
                sectionFlags = SECT_IS_PUBLIC | (yyvsp[(2) - (3)].number);
        }
    break;

  case 354:

/* Line 1455 of yacc.c  */
#line 2730 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (currentSpec -> genc)
                yyerror("protected section not allowed in a C module");

            if (notSkipping())
                sectionFlags = SECT_IS_PROT | (yyvsp[(2) - (3)].number);
        }
    break;

  case 355:

/* Line 1455 of yacc.c  */
#line 2737 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (currentSpec -> genc)
                yyerror("private section not allowed in a C module");

            if (notSkipping())
                sectionFlags = SECT_IS_PRIVATE | (yyvsp[(2) - (3)].number);
        }
    break;

  case 356:

/* Line 1455 of yacc.c  */
#line 2744 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (currentSpec -> genc)
                yyerror("signals section not allowed in a C module");

            if (notSkipping())
                sectionFlags = SECT_IS_SIGNAL;
        }
    break;

  case 357:

/* Line 1455 of yacc.c  */
#line 2753 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if ((yyvsp[(2) - (3)].property).name == NULL)
                yyerror("A %Property directive must have a 'name' argument");

            if ((yyvsp[(2) - (3)].property).get == NULL)
                yyerror("A %Property directive must have a 'get' argument");

            if (notSkipping())
                addProperty(currentSpec, currentModule, currentScope(),
                        (yyvsp[(2) - (3)].property).name, (yyvsp[(2) - (3)].property).get, (yyvsp[(2) - (3)].property).set, (yyvsp[(3) - (3)].property).docstring);
        }
    break;

  case 358:

/* Line 1455 of yacc.c  */
#line 2766 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.property) = (yyvsp[(2) - (3)].property);
        }
    break;

  case 360:

/* Line 1455 of yacc.c  */
#line 2772 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.property) = (yyvsp[(1) - (3)].property);

            switch ((yyvsp[(3) - (3)].property).token)
            {
            case TK_GET: (yyval.property).get = (yyvsp[(3) - (3)].property).get; break;
            case TK_NAME: (yyval.property).name = (yyvsp[(3) - (3)].property).name; break;
            case TK_SET: (yyval.property).set = (yyvsp[(3) - (3)].property).set; break;
            }
        }
    break;

  case 361:

/* Line 1455 of yacc.c  */
#line 2784 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.property).token = TK_GET;

            (yyval.property).get = (yyvsp[(3) - (3)].text);
            (yyval.property).name = NULL;
            (yyval.property).set = NULL;
        }
    break;

  case 362:

/* Line 1455 of yacc.c  */
#line 2791 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.property).token = TK_NAME;

            (yyval.property).get = NULL;
            (yyval.property).name = (yyvsp[(3) - (3)].text);
            (yyval.property).set = NULL;
        }
    break;

  case 363:

/* Line 1455 of yacc.c  */
#line 2798 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.property).token = TK_SET;

            (yyval.property).get = NULL;
            (yyval.property).name = NULL;
            (yyval.property).set = (yyvsp[(3) - (3)].text);
        }
    break;

  case 364:

/* Line 1455 of yacc.c  */
#line 2807 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.property).token = 0;
            (yyval.property).docstring = NULL;
        }
    break;

  case 365:

/* Line 1455 of yacc.c  */
#line 2811 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.property) = (yyvsp[(2) - (4)].property);
        }
    break;

  case 367:

/* Line 1455 of yacc.c  */
#line 2817 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.property) = (yyvsp[(1) - (2)].property);

            switch ((yyvsp[(2) - (2)].property).token)
            {
            case TK_DOCSTRING: (yyval.property).docstring = (yyvsp[(2) - (2)].property).docstring; break;
            }
        }
    break;

  case 368:

/* Line 1455 of yacc.c  */
#line 2827 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.property).token = TK_IF;
        }
    break;

  case 369:

/* Line 1455 of yacc.c  */
#line 2830 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.property).token = TK_END;
        }
    break;

  case 370:

/* Line 1455 of yacc.c  */
#line 2833 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                (yyval.property).token = TK_DOCSTRING;
                (yyval.property).docstring = (yyvsp[(1) - (1)].codeb);
            }
            else
            {
                (yyval.property).token = 0;
                (yyval.property).docstring = NULL;
            }
        }
    break;

  case 371:

/* Line 1455 of yacc.c  */
#line 2847 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.number) = 0;
        }
    break;

  case 372:

/* Line 1455 of yacc.c  */
#line 2850 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.number) = SECT_IS_SLOT;
        }
    break;

  case 373:

/* Line 1455 of yacc.c  */
#line 2855 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            /* Note that we allow non-virtual dtors in C modules. */

            if (notSkipping())
            {
                const char *annos[] = {
                    "HoldGIL",
                    "ReleaseGIL",
                    NULL
                };

                classDef *cd = currentScope();

                checkAnnos(&(yyvsp[(8) - (11)].optflags), annos);

                if (strcmp(classBaseName(cd),(yyvsp[(3) - (11)].text)) != 0)
                    yyerror("Destructor doesn't have the same name as its class");

                if (isDtor(cd))
                    yyerror("Destructor has already been defined");

                if (currentSpec -> genc && (yyvsp[(10) - (11)].codeb) == NULL)
                    yyerror("Destructor in C modules must include %MethodCode");

                appendCodeBlock(&cd->dealloccode, (yyvsp[(10) - (11)].codeb));
                appendCodeBlock(&cd->dtorcode, (yyvsp[(11) - (11)].codeb));
                cd -> dtorexceptions = (yyvsp[(6) - (11)].throwlist);

                /*
                 * Note that we don't apply the protected/public hack to dtors
                 * as it (I think) may change the behaviour of the wrapped API.
                 */
                cd->classflags |= sectionFlags;

                if ((yyvsp[(7) - (11)].number))
                {
                    if (!(yyvsp[(1) - (11)].number))
                        yyerror("Abstract destructor must be virtual");

                    setIsAbstractClass(cd);
                }

                /*
                 * The class has a shadow if we have a virtual dtor or some
                 * dtor code.
                 */
                if ((yyvsp[(1) - (11)].number) || (yyvsp[(11) - (11)].codeb) != NULL)
                {
                    if (currentSpec -> genc)
                        yyerror("Virtual destructor or %VirtualCatcherCode not allowed in a C module");

                    setHasShadow(cd);
                }

                if (getReleaseGIL(&(yyvsp[(8) - (11)].optflags)))
                    setIsReleaseGILDtor(cd);
                else if (getHoldGIL(&(yyvsp[(8) - (11)].optflags)))
                    setIsHoldGILDtor(cd);
            }
        }
    break;

  case 374:

/* Line 1455 of yacc.c  */
#line 2917 "/blur/cpp/lib/sip/sipgen/parser.y"
    {currentCtorIsExplicit = TRUE;}
    break;

  case 377:

/* Line 1455 of yacc.c  */
#line 2921 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            /* Note that we allow ctors in C modules. */

            if (notSkipping())
            {
                const char *annos[] = {
                    "API",
                    "Default",
                    "Deprecated",
                    "HoldGIL",
                    "KeywordArgs",
                    "NoDerived",
                    "PostHook",
                    "PreHook",
                    "ReleaseGIL",
                    "Transfer",
                    NULL
                };

                checkAnnos(&(yyvsp[(6) - (10)].optflags), annos);

                if (currentSpec -> genc)
                {
                    if ((yyvsp[(10) - (10)].codeb) == NULL && (yyvsp[(3) - (10)].signature).nrArgs != 0)
                        yyerror("Constructors with arguments in C modules must include %MethodCode");

                    if (currentCtorIsExplicit)
                        yyerror("Explicit constructors not allowed in a C module");
                }

                if ((sectionFlags & (SECT_IS_PUBLIC | SECT_IS_PROT | SECT_IS_PRIVATE)) == 0)
                    yyerror("Constructor must be in the public, private or protected sections");

                newCtor(currentModule, (yyvsp[(1) - (10)].text), sectionFlags, &(yyvsp[(3) - (10)].signature), &(yyvsp[(6) - (10)].optflags), (yyvsp[(10) - (10)].codeb), (yyvsp[(5) - (10)].throwlist), (yyvsp[(7) - (10)].optsignature),
                        currentCtorIsExplicit, (yyvsp[(9) - (10)].codeb));
            }

            free((yyvsp[(1) - (10)].text));

            currentCtorIsExplicit = FALSE;
        }
    break;

  case 378:

/* Line 1455 of yacc.c  */
#line 2964 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.optsignature) = NULL;
        }
    break;

  case 379:

/* Line 1455 of yacc.c  */
#line 2967 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            parsingCSignature = TRUE;
        }
    break;

  case 380:

/* Line 1455 of yacc.c  */
#line 2969 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.optsignature) = sipMalloc(sizeof (signatureDef));

            *(yyval.optsignature) = (yyvsp[(4) - (6)].signature);

            parsingCSignature = FALSE;
        }
    break;

  case 381:

/* Line 1455 of yacc.c  */
#line 2978 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.optsignature) = NULL;
        }
    break;

  case 382:

/* Line 1455 of yacc.c  */
#line 2981 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            parsingCSignature = TRUE;
        }
    break;

  case 383:

/* Line 1455 of yacc.c  */
#line 2983 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.optsignature) = sipMalloc(sizeof (signatureDef));

            *(yyval.optsignature) = (yyvsp[(5) - (7)].signature);
            (yyval.optsignature)->result = (yyvsp[(3) - (7)].memArg);

            parsingCSignature = FALSE;
        }
    break;

  case 384:

/* Line 1455 of yacc.c  */
#line 2993 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.number) = FALSE;
        }
    break;

  case 385:

/* Line 1455 of yacc.c  */
#line 2996 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.number) = TRUE;
        }
    break;

  case 386:

/* Line 1455 of yacc.c  */
#line 3001 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                applyTypeFlags(currentModule, &(yyvsp[(1) - (14)].memArg), &(yyvsp[(9) - (14)].optflags));

                (yyvsp[(4) - (14)].signature).result = (yyvsp[(1) - (14)].memArg);

                newFunction(currentSpec, currentModule, currentScope(), NULL,
                        sectionFlags, currentIsStatic, currentIsSignal,
                        currentIsSlot, currentOverIsVirt, (yyvsp[(2) - (14)].text), &(yyvsp[(4) - (14)].signature), (yyvsp[(6) - (14)].number), (yyvsp[(8) - (14)].number), &(yyvsp[(9) - (14)].optflags),
                        (yyvsp[(13) - (14)].codeb), (yyvsp[(14) - (14)].codeb), (yyvsp[(7) - (14)].throwlist), (yyvsp[(10) - (14)].optsignature), (yyvsp[(12) - (14)].codeb));
            }

            currentIsStatic = FALSE;
            currentIsSignal = FALSE;
            currentIsSlot = FALSE;
            currentOverIsVirt = FALSE;
        }
    break;

  case 387:

/* Line 1455 of yacc.c  */
#line 3019 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            /*
             * It looks like an assignment operator (though we don't bother to
             * check the types) so make sure it is private.
             */
            if (notSkipping())
            {
                classDef *cd = currentScope();

                if (cd == NULL || !(sectionFlags & SECT_IS_PRIVATE))
                    yyerror("Assignment operators may only be defined as private");

                setCannotAssign(cd);
            }

            currentIsStatic = FALSE;
            currentIsSignal = FALSE;
            currentIsSlot = FALSE;
            currentOverIsVirt = FALSE;
        }
    break;

  case 388:

/* Line 1455 of yacc.c  */
#line 3039 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                classDef *cd = currentScope();

                /*
                 * If the scope is a namespace then make sure the operator is
                 * handled as a global.
                 */
                if (cd != NULL && cd->iff->type == namespace_iface)
                    cd = NULL;

                applyTypeFlags(currentModule, &(yyvsp[(1) - (14)].memArg), &(yyvsp[(10) - (14)].optflags));

                /* Handle the unary '+' and '-' operators. */
                if ((cd != NULL && (yyvsp[(5) - (14)].signature).nrArgs == 0) || (cd == NULL && (yyvsp[(5) - (14)].signature).nrArgs == 1))
                {
                    if (strcmp((yyvsp[(3) - (14)].text), "__add__") == 0)
                        (yyvsp[(3) - (14)].text) = "__pos__";
                    else if (strcmp((yyvsp[(3) - (14)].text), "__sub__") == 0)
                        (yyvsp[(3) - (14)].text) = "__neg__";
                }

                (yyvsp[(5) - (14)].signature).result = (yyvsp[(1) - (14)].memArg);

                newFunction(currentSpec, currentModule, cd, NULL,
                        sectionFlags, currentIsStatic, currentIsSignal,
                        currentIsSlot, currentOverIsVirt, (yyvsp[(3) - (14)].text), &(yyvsp[(5) - (14)].signature), (yyvsp[(7) - (14)].number), (yyvsp[(9) - (14)].number),
                        &(yyvsp[(10) - (14)].optflags), (yyvsp[(13) - (14)].codeb), (yyvsp[(14) - (14)].codeb), (yyvsp[(8) - (14)].throwlist), (yyvsp[(11) - (14)].optsignature), NULL);
            }

            currentIsStatic = FALSE;
            currentIsSignal = FALSE;
            currentIsSlot = FALSE;
            currentOverIsVirt = FALSE;
        }
    break;

  case 389:

/* Line 1455 of yacc.c  */
#line 3075 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                char *sname;
                classDef *scope = currentScope();

                if (scope == NULL || (yyvsp[(4) - (13)].signature).nrArgs != 0)
                    yyerror("Operator casts must be specified in a class and have no arguments");

                applyTypeFlags(currentModule, &(yyvsp[(2) - (13)].memArg), &(yyvsp[(9) - (13)].optflags));

                switch ((yyvsp[(2) - (13)].memArg).atype)
                {
                case defined_type:
                    sname = NULL;
                    break;

                case bool_type:
                case cbool_type:
                case byte_type:
                case sbyte_type:
                case ubyte_type:
                case short_type:
                case ushort_type:
                case int_type:
                case cint_type:
                case uint_type:
                    sname = "__int__";
                    break;

                case long_type:
                case ulong_type:
                case longlong_type:
                case ulonglong_type:
                    sname = "__long__";
                    break;

                case float_type:
                case cfloat_type:
                case double_type:
                case cdouble_type:
                    sname = "__float__";
                    break;

                default:
                    yyerror("Unsupported operator cast");
                }

                if (sname != NULL)
                {
                    (yyvsp[(4) - (13)].signature).result = (yyvsp[(2) - (13)].memArg);

                    newFunction(currentSpec, currentModule, scope, NULL,
                            sectionFlags, currentIsStatic, currentIsSignal,
                            currentIsSlot, currentOverIsVirt, sname, &(yyvsp[(4) - (13)].signature), (yyvsp[(6) - (13)].number),
                            (yyvsp[(8) - (13)].number), &(yyvsp[(9) - (13)].optflags), (yyvsp[(12) - (13)].codeb), (yyvsp[(13) - (13)].codeb), (yyvsp[(7) - (13)].throwlist), (yyvsp[(10) - (13)].optsignature), NULL);
                }
                else
                {
                    argList *al;

                    /* Check it doesn't already exist. */
                    for (al = scope->casts; al != NULL; al = al->next)
                        if (compareScopedNames((yyvsp[(2) - (13)].memArg).u.snd, al->arg.u.snd) == 0)
                            yyerror("This operator cast has already been specified in this class");

                    al = sipMalloc(sizeof (argList));
                    al->arg = (yyvsp[(2) - (13)].memArg);
                    al->next = scope->casts;

                    scope->casts = al;
                }
            }

            currentIsStatic = FALSE;
            currentIsSignal = FALSE;
            currentIsSlot = FALSE;
            currentOverIsVirt = FALSE;
        }
    break;

  case 390:

/* Line 1455 of yacc.c  */
#line 3156 "/blur/cpp/lib/sip/sipgen/parser.y"
    {(yyval.text) = "__add__";}
    break;

  case 391:

/* Line 1455 of yacc.c  */
#line 3157 "/blur/cpp/lib/sip/sipgen/parser.y"
    {(yyval.text) = "__sub__";}
    break;

  case 392:

/* Line 1455 of yacc.c  */
#line 3158 "/blur/cpp/lib/sip/sipgen/parser.y"
    {(yyval.text) = "__mul__";}
    break;

  case 393:

/* Line 1455 of yacc.c  */
#line 3159 "/blur/cpp/lib/sip/sipgen/parser.y"
    {(yyval.text) = "__div__";}
    break;

  case 394:

/* Line 1455 of yacc.c  */
#line 3160 "/blur/cpp/lib/sip/sipgen/parser.y"
    {(yyval.text) = "__mod__";}
    break;

  case 395:

/* Line 1455 of yacc.c  */
#line 3161 "/blur/cpp/lib/sip/sipgen/parser.y"
    {(yyval.text) = "__and__";}
    break;

  case 396:

/* Line 1455 of yacc.c  */
#line 3162 "/blur/cpp/lib/sip/sipgen/parser.y"
    {(yyval.text) = "__or__";}
    break;

  case 397:

/* Line 1455 of yacc.c  */
#line 3163 "/blur/cpp/lib/sip/sipgen/parser.y"
    {(yyval.text) = "__xor__";}
    break;

  case 398:

/* Line 1455 of yacc.c  */
#line 3164 "/blur/cpp/lib/sip/sipgen/parser.y"
    {(yyval.text) = "__lshift__";}
    break;

  case 399:

/* Line 1455 of yacc.c  */
#line 3165 "/blur/cpp/lib/sip/sipgen/parser.y"
    {(yyval.text) = "__rshift__";}
    break;

  case 400:

/* Line 1455 of yacc.c  */
#line 3166 "/blur/cpp/lib/sip/sipgen/parser.y"
    {(yyval.text) = "__iadd__";}
    break;

  case 401:

/* Line 1455 of yacc.c  */
#line 3167 "/blur/cpp/lib/sip/sipgen/parser.y"
    {(yyval.text) = "__isub__";}
    break;

  case 402:

/* Line 1455 of yacc.c  */
#line 3168 "/blur/cpp/lib/sip/sipgen/parser.y"
    {(yyval.text) = "__imul__";}
    break;

  case 403:

/* Line 1455 of yacc.c  */
#line 3169 "/blur/cpp/lib/sip/sipgen/parser.y"
    {(yyval.text) = "__idiv__";}
    break;

  case 404:

/* Line 1455 of yacc.c  */
#line 3170 "/blur/cpp/lib/sip/sipgen/parser.y"
    {(yyval.text) = "__imod__";}
    break;

  case 405:

/* Line 1455 of yacc.c  */
#line 3171 "/blur/cpp/lib/sip/sipgen/parser.y"
    {(yyval.text) = "__iand__";}
    break;

  case 406:

/* Line 1455 of yacc.c  */
#line 3172 "/blur/cpp/lib/sip/sipgen/parser.y"
    {(yyval.text) = "__ior__";}
    break;

  case 407:

/* Line 1455 of yacc.c  */
#line 3173 "/blur/cpp/lib/sip/sipgen/parser.y"
    {(yyval.text) = "__ixor__";}
    break;

  case 408:

/* Line 1455 of yacc.c  */
#line 3174 "/blur/cpp/lib/sip/sipgen/parser.y"
    {(yyval.text) = "__ilshift__";}
    break;

  case 409:

/* Line 1455 of yacc.c  */
#line 3175 "/blur/cpp/lib/sip/sipgen/parser.y"
    {(yyval.text) = "__irshift__";}
    break;

  case 410:

/* Line 1455 of yacc.c  */
#line 3176 "/blur/cpp/lib/sip/sipgen/parser.y"
    {(yyval.text) = "__invert__";}
    break;

  case 411:

/* Line 1455 of yacc.c  */
#line 3177 "/blur/cpp/lib/sip/sipgen/parser.y"
    {(yyval.text) = "__call__";}
    break;

  case 412:

/* Line 1455 of yacc.c  */
#line 3178 "/blur/cpp/lib/sip/sipgen/parser.y"
    {(yyval.text) = "__getitem__";}
    break;

  case 413:

/* Line 1455 of yacc.c  */
#line 3179 "/blur/cpp/lib/sip/sipgen/parser.y"
    {(yyval.text) = "__lt__";}
    break;

  case 414:

/* Line 1455 of yacc.c  */
#line 3180 "/blur/cpp/lib/sip/sipgen/parser.y"
    {(yyval.text) = "__le__";}
    break;

  case 415:

/* Line 1455 of yacc.c  */
#line 3181 "/blur/cpp/lib/sip/sipgen/parser.y"
    {(yyval.text) = "__eq__";}
    break;

  case 416:

/* Line 1455 of yacc.c  */
#line 3182 "/blur/cpp/lib/sip/sipgen/parser.y"
    {(yyval.text) = "__ne__";}
    break;

  case 417:

/* Line 1455 of yacc.c  */
#line 3183 "/blur/cpp/lib/sip/sipgen/parser.y"
    {(yyval.text) = "__gt__";}
    break;

  case 418:

/* Line 1455 of yacc.c  */
#line 3184 "/blur/cpp/lib/sip/sipgen/parser.y"
    {(yyval.text) = "__ge__";}
    break;

  case 419:

/* Line 1455 of yacc.c  */
#line 3187 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.number) = FALSE;
        }
    break;

  case 420:

/* Line 1455 of yacc.c  */
#line 3190 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.number) = TRUE;
        }
    break;

  case 421:

/* Line 1455 of yacc.c  */
#line 3195 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.number) = 0;
        }
    break;

  case 422:

/* Line 1455 of yacc.c  */
#line 3198 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if ((yyvsp[(2) - (2)].number) != 0)
                yyerror("Abstract virtual function '= 0' expected");

            (yyval.number) = TRUE;
        }
    break;

  case 423:

/* Line 1455 of yacc.c  */
#line 3206 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.optflags).nrFlags = 0;
        }
    break;

  case 424:

/* Line 1455 of yacc.c  */
#line 3209 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.optflags) = (yyvsp[(2) - (3)].optflags);
        }
    break;

  case 425:

/* Line 1455 of yacc.c  */
#line 3215 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.optflags).flags[0] = (yyvsp[(1) - (1)].flag);
            (yyval.optflags).nrFlags = 1;
        }
    break;

  case 426:

/* Line 1455 of yacc.c  */
#line 3219 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            /* Check there is room. */

            if ((yyvsp[(1) - (3)].optflags).nrFlags == MAX_NR_FLAGS)
                yyerror("Too many optional flags");

            (yyval.optflags) = (yyvsp[(1) - (3)].optflags);

            (yyval.optflags).flags[(yyval.optflags).nrFlags++] = (yyvsp[(3) - (3)].flag);
        }
    break;

  case 427:

/* Line 1455 of yacc.c  */
#line 3231 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.flag).ftype = bool_flag;
            (yyval.flag).fname = (yyvsp[(1) - (1)].text);
        }
    break;

  case 428:

/* Line 1455 of yacc.c  */
#line 3235 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.flag) = (yyvsp[(3) - (3)].flag);
            (yyval.flag).fname = (yyvsp[(1) - (3)].text);
        }
    break;

  case 429:

/* Line 1455 of yacc.c  */
#line 3241 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.flag).ftype = (strchr((yyvsp[(1) - (1)].text), '.') != NULL) ? dotted_name_flag : name_flag;
            (yyval.flag).fvalue.sval = (yyvsp[(1) - (1)].text);
        }
    break;

  case 430:

/* Line 1455 of yacc.c  */
#line 3245 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            apiVersionRangeDef *avd;
            int from, to;

            (yyval.flag).ftype = api_range_flag;

            /* Check that the API is known. */
            if ((avd = findAPI(currentSpec, (yyvsp[(1) - (5)].text))) == NULL)
                yyerror("unknown API name in API annotation");

            if (inMainModule())
                setIsUsedName(avd->api_name);

            /* Unbounded values are represented by 0. */
            if ((from = (yyvsp[(3) - (5)].number)) < 0)
                from = 0;

            if ((to = (yyvsp[(5) - (5)].number)) < 0)
                to = 0;

            (yyval.flag).fvalue.aval = convertAPIRange(currentModule, avd->api_name,
                    from, to);
        }
    break;

  case 431:

/* Line 1455 of yacc.c  */
#line 3268 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.flag).ftype = string_flag;
            (yyval.flag).fvalue.sval = convertFeaturedString((yyvsp[(1) - (1)].text));
        }
    break;

  case 432:

/* Line 1455 of yacc.c  */
#line 3272 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.flag).ftype = integer_flag;
            (yyval.flag).fvalue.ival = (yyvsp[(1) - (1)].number);
        }
    break;

  case 433:

/* Line 1455 of yacc.c  */
#line 3278 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.codeb) = (yyvsp[(2) - (2)].codeb);
        }
    break;

  case 434:

/* Line 1455 of yacc.c  */
#line 3283 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.codeb) = NULL;
        }
    break;

  case 436:

/* Line 1455 of yacc.c  */
#line 3289 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.codeb) = NULL;
        }
    break;

  case 437:

/* Line 1455 of yacc.c  */
#line 3292 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.codeb) = (yyvsp[(2) - (2)].codeb);
        }
    break;

  case 438:

/* Line 1455 of yacc.c  */
#line 3297 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.codeb) = NULL;
        }
    break;

  case 439:

/* Line 1455 of yacc.c  */
#line 3300 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.codeb) = (yyvsp[(2) - (2)].codeb);
        }
    break;

  case 440:

/* Line 1455 of yacc.c  */
#line 3305 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            int a, nrrxcon, nrrxdis, nrslotcon, nrslotdis, nrarray, nrarraysize;

            nrrxcon = nrrxdis = nrslotcon = nrslotdis = nrarray = nrarraysize = 0;

            for (a = 0; a < (yyvsp[(1) - (1)].signature).nrArgs; ++a)
            {
                argDef *ad = &(yyvsp[(1) - (1)].signature).args[a];

                switch (ad -> atype)
                {
                case rxcon_type:
                    ++nrrxcon;
                    break;

                case rxdis_type:
                    ++nrrxdis;
                    break;

                case slotcon_type:
                    ++nrslotcon;
                    break;

                case slotdis_type:
                    ++nrslotdis;
                    break;
                }

                if (isArray(ad))
                    ++nrarray;

                if (isArraySize(ad))
                    ++nrarraysize;
            }

            if (nrrxcon != nrslotcon || nrrxcon > 1)
                yyerror("SIP_RXOBJ_CON and SIP_SLOT_CON must both be given and at most once");

            if (nrrxdis != nrslotdis || nrrxdis > 1)
                yyerror("SIP_RXOBJ_DIS and SIP_SLOT_DIS must both be given and at most once");

            if (nrarray != nrarraysize || nrarray > 1)
                yyerror("/Array/ and /ArraySize/ must both be given and at most once");

            (yyval.signature) = (yyvsp[(1) - (1)].signature);
        }
    break;

  case 441:

/* Line 1455 of yacc.c  */
#line 3353 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            /* No arguments. */

            (yyval.signature).nrArgs = 0;
        }
    break;

  case 442:

/* Line 1455 of yacc.c  */
#line 3358 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            /* The single or first argument. */

            (yyval.signature).args[0] = (yyvsp[(1) - (1)].memArg);
            (yyval.signature).nrArgs = 1;
        }
    break;

  case 443:

/* Line 1455 of yacc.c  */
#line 3364 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            /* Check that it wasn't ...(,arg...). */
            if ((yyvsp[(1) - (3)].signature).nrArgs == 0)
                yyerror("First argument of the list is missing");

            /* Check there is nothing after an ellipsis. */
            if ((yyvsp[(1) - (3)].signature).args[(yyvsp[(1) - (3)].signature).nrArgs - 1].atype == ellipsis_type)
                yyerror("An ellipsis must be at the end of the argument list");

            /*
             * If this argument has no default value, then the
             * previous one mustn't either.
             */
            if ((yyvsp[(3) - (3)].memArg).defval == NULL && (yyvsp[(1) - (3)].signature).args[(yyvsp[(1) - (3)].signature).nrArgs - 1].defval != NULL)
                yyerror("Compulsory argument given after optional argument");

            /* Check there is room. */
            if ((yyvsp[(1) - (3)].signature).nrArgs == MAX_NR_ARGS)
                yyerror("Internal error - increase the value of MAX_NR_ARGS");

            (yyval.signature) = (yyvsp[(1) - (3)].signature);

            (yyval.signature).args[(yyval.signature).nrArgs] = (yyvsp[(3) - (3)].memArg);
            (yyval.signature).nrArgs++;
        }
    break;

  case 444:

/* Line 1455 of yacc.c  */
#line 3391 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            checkNoAnnos(&(yyvsp[(3) - (4)].optflags), "SIP_SIGNAL has no annotations");

            (yyval.memArg).atype = signal_type;
            (yyval.memArg).argflags = ARG_IS_CONST;
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).name = cacheName(currentSpec, (yyvsp[(2) - (4)].text));
            (yyval.memArg).defval = (yyvsp[(4) - (4)].valp);

            currentSpec -> sigslots = TRUE;
        }
    break;

  case 445:

/* Line 1455 of yacc.c  */
#line 3402 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            checkNoAnnos(&(yyvsp[(3) - (4)].optflags), "SIP_SLOT has no annotations");

            (yyval.memArg).atype = slot_type;
            (yyval.memArg).argflags = ARG_IS_CONST;
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).name = cacheName(currentSpec, (yyvsp[(2) - (4)].text));
            (yyval.memArg).defval = (yyvsp[(4) - (4)].valp);

            currentSpec -> sigslots = TRUE;
        }
    break;

  case 446:

/* Line 1455 of yacc.c  */
#line 3413 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            checkNoAnnos(&(yyvsp[(3) - (4)].optflags), "SIP_ANYSLOT has no annotations");

            (yyval.memArg).atype = anyslot_type;
            (yyval.memArg).argflags = ARG_IS_CONST;
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).name = cacheName(currentSpec, (yyvsp[(2) - (4)].text));
            (yyval.memArg).defval = (yyvsp[(4) - (4)].valp);

            currentSpec -> sigslots = TRUE;
        }
    break;

  case 447:

/* Line 1455 of yacc.c  */
#line 3424 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            const char *annos[] = {
                "SingleShot",
                NULL
            };

            checkAnnos(&(yyvsp[(3) - (3)].optflags), annos);

            (yyval.memArg).atype = rxcon_type;
            (yyval.memArg).argflags = 0;
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).name = cacheName(currentSpec, (yyvsp[(2) - (3)].text));

            if (getOptFlag(&(yyvsp[(3) - (3)].optflags), "SingleShot", bool_flag) != NULL)
                (yyval.memArg).argflags |= ARG_SINGLE_SHOT;

            currentSpec -> sigslots = TRUE;
        }
    break;

  case 448:

/* Line 1455 of yacc.c  */
#line 3442 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            checkNoAnnos(&(yyvsp[(3) - (3)].optflags), "SIP_RXOBJ_DIS has no annotations");

            (yyval.memArg).atype = rxdis_type;
            (yyval.memArg).argflags = 0;
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).name = cacheName(currentSpec, (yyvsp[(2) - (3)].text));

            currentSpec -> sigslots = TRUE;
        }
    break;

  case 449:

/* Line 1455 of yacc.c  */
#line 3452 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            checkNoAnnos(&(yyvsp[(6) - (6)].optflags), "SIP_SLOT_CON has no annotations");

            (yyval.memArg).atype = slotcon_type;
            (yyval.memArg).argflags = ARG_IS_CONST;
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).name = cacheName(currentSpec, (yyvsp[(5) - (6)].text));

            memset(&(yyvsp[(3) - (6)].signature).result, 0, sizeof (argDef));
            (yyvsp[(3) - (6)].signature).result.atype = void_type;

            (yyval.memArg).u.sa = sipMalloc(sizeof (signatureDef));
            *(yyval.memArg).u.sa = (yyvsp[(3) - (6)].signature);

            currentSpec -> sigslots = TRUE;
        }
    break;

  case 450:

/* Line 1455 of yacc.c  */
#line 3468 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            checkNoAnnos(&(yyvsp[(6) - (6)].optflags), "SIP_SLOT_DIS has no annotations");

            (yyval.memArg).atype = slotdis_type;
            (yyval.memArg).argflags = ARG_IS_CONST;
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).name = cacheName(currentSpec, (yyvsp[(5) - (6)].text));

            memset(&(yyvsp[(3) - (6)].signature).result, 0, sizeof (argDef));
            (yyvsp[(3) - (6)].signature).result.atype = void_type;

            (yyval.memArg).u.sa = sipMalloc(sizeof (signatureDef));
            *(yyval.memArg).u.sa = (yyvsp[(3) - (6)].signature);

            currentSpec -> sigslots = TRUE;
        }
    break;

  case 451:

/* Line 1455 of yacc.c  */
#line 3484 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            checkNoAnnos(&(yyvsp[(3) - (3)].optflags), "SIP_QOBJECT has no annotations");

            (yyval.memArg).atype = qobject_type;
            (yyval.memArg).argflags = 0;
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).name = cacheName(currentSpec, (yyvsp[(2) - (3)].text));
        }
    break;

  case 452:

/* Line 1455 of yacc.c  */
#line 3492 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.memArg) = (yyvsp[(1) - (2)].memArg);
            (yyval.memArg).defval = (yyvsp[(2) - (2)].valp);
        }
    break;

  case 453:

/* Line 1455 of yacc.c  */
#line 3499 "/blur/cpp/lib/sip/sipgen/parser.y"
    {currentIsSignal = TRUE;}
    break;

  case 455:

/* Line 1455 of yacc.c  */
#line 3500 "/blur/cpp/lib/sip/sipgen/parser.y"
    {currentIsSlot = TRUE;}
    break;

  case 458:

/* Line 1455 of yacc.c  */
#line 3505 "/blur/cpp/lib/sip/sipgen/parser.y"
    {currentIsStatic = TRUE;}
    break;

  case 463:

/* Line 1455 of yacc.c  */
#line 3515 "/blur/cpp/lib/sip/sipgen/parser.y"
    {currentOverIsVirt = TRUE;}
    break;

  case 466:

/* Line 1455 of yacc.c  */
#line 3519 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                const char *annos[] = {
                    "DocType",
                    "Encoding",
                    "PyInt",
                    "PyName",
                    NULL
                };

                checkAnnos(&(yyvsp[(3) - (8)].optflags), annos);

                if ((yyvsp[(6) - (8)].codeb) != NULL)
                {
                    if ((yyvsp[(4) - (8)].variable).access_code != NULL)
                        yyerror("%AccessCode already defined");

                    (yyvsp[(4) - (8)].variable).access_code = (yyvsp[(6) - (8)].codeb);

                    deprecated("%AccessCode should be used a sub-directive");
                }

                if ((yyvsp[(7) - (8)].codeb) != NULL)
                {
                    if ((yyvsp[(4) - (8)].variable).get_code != NULL)
                        yyerror("%GetCode already defined");

                    (yyvsp[(4) - (8)].variable).get_code = (yyvsp[(7) - (8)].codeb);

                    deprecated("%GetCode should be used a sub-directive");
                }

                if ((yyvsp[(8) - (8)].codeb) != NULL)
                {
                    if ((yyvsp[(4) - (8)].variable).set_code != NULL)
                        yyerror("%SetCode already defined");

                    (yyvsp[(4) - (8)].variable).set_code = (yyvsp[(8) - (8)].codeb);

                    deprecated("%SetCode should be used a sub-directive");
                }

                newVar(currentSpec, currentModule, (yyvsp[(2) - (8)].text), currentIsStatic, &(yyvsp[(1) - (8)].memArg),
                        &(yyvsp[(3) - (8)].optflags), (yyvsp[(4) - (8)].variable).access_code, (yyvsp[(4) - (8)].variable).get_code, (yyvsp[(4) - (8)].variable).set_code,
                        sectionFlags);
            }

            currentIsStatic = FALSE;
        }
    break;

  case 467:

/* Line 1455 of yacc.c  */
#line 3571 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.variable).token = 0;
            (yyval.variable).access_code = NULL;
            (yyval.variable).get_code = NULL;
            (yyval.variable).set_code = NULL;
        }
    break;

  case 468:

/* Line 1455 of yacc.c  */
#line 3577 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.variable) = (yyvsp[(2) - (3)].variable);
        }
    break;

  case 470:

/* Line 1455 of yacc.c  */
#line 3583 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.variable) = (yyvsp[(1) - (2)].variable);

            switch ((yyvsp[(2) - (2)].variable).token)
            {
            case TK_ACCESSCODE: (yyval.variable).access_code = (yyvsp[(2) - (2)].variable).access_code; break;
            case TK_GETCODE: (yyval.variable).get_code = (yyvsp[(2) - (2)].variable).get_code; break;
            case TK_SETCODE: (yyval.variable).set_code = (yyvsp[(2) - (2)].variable).set_code; break;
            }
        }
    break;

  case 471:

/* Line 1455 of yacc.c  */
#line 3595 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.variable).token = TK_IF;
        }
    break;

  case 472:

/* Line 1455 of yacc.c  */
#line 3598 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.variable).token = TK_END;
        }
    break;

  case 473:

/* Line 1455 of yacc.c  */
#line 3601 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                (yyval.variable).token = TK_ACCESSCODE;
                (yyval.variable).access_code = (yyvsp[(2) - (2)].codeb);
            }
            else
            {
                (yyval.variable).token = 0;
                (yyval.variable).access_code = NULL;
            }

            (yyval.variable).get_code = NULL;
            (yyval.variable).set_code = NULL;
        }
    break;

  case 474:

/* Line 1455 of yacc.c  */
#line 3616 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                (yyval.variable).token = TK_GETCODE;
                (yyval.variable).get_code = (yyvsp[(2) - (2)].codeb);
            }
            else
            {
                (yyval.variable).token = 0;
                (yyval.variable).get_code = NULL;
            }

            (yyval.variable).access_code = NULL;
            (yyval.variable).set_code = NULL;
        }
    break;

  case 475:

/* Line 1455 of yacc.c  */
#line 3631 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (notSkipping())
            {
                (yyval.variable).token = TK_SETCODE;
                (yyval.variable).set_code = (yyvsp[(2) - (2)].codeb);
            }
            else
            {
                (yyval.variable).token = 0;
                (yyval.variable).set_code = NULL;
            }

            (yyval.variable).access_code = NULL;
            (yyval.variable).get_code = NULL;
        }
    break;

  case 476:

/* Line 1455 of yacc.c  */
#line 3648 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.memArg) = (yyvsp[(2) - (4)].memArg);
            (yyval.memArg).nrderefs += (yyvsp[(3) - (4)].number);
            (yyval.memArg).argflags |= ARG_IS_CONST | (yyvsp[(4) - (4)].number);
        }
    break;

  case 477:

/* Line 1455 of yacc.c  */
#line 3653 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.memArg) = (yyvsp[(1) - (3)].memArg);
            (yyval.memArg).nrderefs += (yyvsp[(2) - (3)].number);
            (yyval.memArg).argflags |= (yyvsp[(3) - (3)].number);

            /* PyObject * is a synonym for SIP_PYOBJECT. */
            if ((yyvsp[(1) - (3)].memArg).atype == defined_type && strcmp((yyvsp[(1) - (3)].memArg).u.snd->name, "PyObject") == 0 && (yyvsp[(1) - (3)].memArg).u.snd->next == NULL && (yyvsp[(2) - (3)].number) == 1 && (yyvsp[(3) - (3)].number) == 0)
            {
                (yyval.memArg).atype = pyobject_type;
                (yyval.memArg).nrderefs = 0;
            }
        }
    break;

  case 478:

/* Line 1455 of yacc.c  */
#line 3667 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            const char *annos[] = {
                "AllowNone",
                "Array",
                "ArraySize",
                "Constrained",
                "DocType",
                "DocValue",
                "Encoding",
                "GetWrapper",
                "In",
                "KeepReference",
                "NoCopy",
                "Out",
                "PyInt",
                "ResultSize",
                "Transfer",
                "TransferBack",
                "TransferThis",
                NULL
            };

            optFlag *of;

            checkAnnos(&(yyvsp[(3) - (3)].optflags), annos);

            (yyval.memArg) = (yyvsp[(1) - (3)].memArg);
            (yyval.memArg).name = cacheName(currentSpec, (yyvsp[(2) - (3)].text));

            handleKeepReference(&(yyvsp[(3) - (3)].optflags), &(yyval.memArg), currentModule);

            if (getAllowNone(&(yyvsp[(3) - (3)].optflags)))
                (yyval.memArg).argflags |= ARG_ALLOW_NONE;

            if (getOptFlag(&(yyvsp[(3) - (3)].optflags),"GetWrapper",bool_flag) != NULL)
                (yyval.memArg).argflags |= ARG_GET_WRAPPER;

            if (getOptFlag(&(yyvsp[(3) - (3)].optflags),"Array",bool_flag) != NULL)
                (yyval.memArg).argflags |= ARG_ARRAY;

            if (getOptFlag(&(yyvsp[(3) - (3)].optflags),"ArraySize",bool_flag) != NULL)
                (yyval.memArg).argflags |= ARG_ARRAY_SIZE;

            if (getTransfer(&(yyvsp[(3) - (3)].optflags)))
                (yyval.memArg).argflags |= ARG_XFERRED;

            if (getOptFlag(&(yyvsp[(3) - (3)].optflags),"TransferThis",bool_flag) != NULL)
                (yyval.memArg).argflags |= ARG_THIS_XFERRED;

            if (getOptFlag(&(yyvsp[(3) - (3)].optflags),"TransferBack",bool_flag) != NULL)
                (yyval.memArg).argflags |= ARG_XFERRED_BACK;

            if (getOptFlag(&(yyvsp[(3) - (3)].optflags),"In",bool_flag) != NULL)
                (yyval.memArg).argflags |= ARG_IN;

            if (getOptFlag(&(yyvsp[(3) - (3)].optflags),"Out",bool_flag) != NULL)
                (yyval.memArg).argflags |= ARG_OUT;

            if (getOptFlag(&(yyvsp[(3) - (3)].optflags), "ResultSize", bool_flag) != NULL)
                (yyval.memArg).argflags |= ARG_RESULT_SIZE;

            if (getOptFlag(&(yyvsp[(3) - (3)].optflags), "NoCopy", bool_flag) != NULL)
                (yyval.memArg).argflags |= ARG_NO_COPY;

            if (getOptFlag(&(yyvsp[(3) - (3)].optflags),"Constrained",bool_flag) != NULL)
            {
                (yyval.memArg).argflags |= ARG_CONSTRAINED;

                switch ((yyval.memArg).atype)
                {
                case bool_type:
                    (yyval.memArg).atype = cbool_type;
                    break;

                case int_type:
                    (yyval.memArg).atype = cint_type;
                    break;

                case float_type:
                    (yyval.memArg).atype = cfloat_type;
                    break;

                case double_type:
                    (yyval.memArg).atype = cdouble_type;
                    break;
                }
            }

            applyTypeFlags(currentModule, &(yyval.memArg), &(yyvsp[(3) - (3)].optflags));
            (yyval.memArg).docval = getDocValue(&(yyvsp[(3) - (3)].optflags));
        }
    break;

  case 479:

/* Line 1455 of yacc.c  */
#line 3760 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.number) = 0;
        }
    break;

  case 480:

/* Line 1455 of yacc.c  */
#line 3763 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (currentSpec -> genc)
                yyerror("References not allowed in a C module");

            (yyval.number) = ARG_IS_REF;
        }
    break;

  case 481:

/* Line 1455 of yacc.c  */
#line 3771 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.number) = 0;
        }
    break;

  case 482:

/* Line 1455 of yacc.c  */
#line 3774 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.number) = (yyvsp[(1) - (2)].number) + 1;
        }
    break;

  case 483:

/* Line 1455 of yacc.c  */
#line 3779 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            memset(&(yyval.memArg), 0, sizeof (argDef));
            (yyval.memArg).atype = defined_type;
            (yyval.memArg).u.snd = (yyvsp[(1) - (1)].scpvalp);

            /* Try and resolve typedefs as early as possible. */
            resolveAnyTypedef(currentSpec, &(yyval.memArg));
        }
    break;

  case 484:

/* Line 1455 of yacc.c  */
#line 3787 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            templateDef *td;

            td = sipMalloc(sizeof(templateDef));
            td->fqname = (yyvsp[(1) - (4)].scpvalp);
            td->types = (yyvsp[(3) - (4)].signature);

            memset(&(yyval.memArg), 0, sizeof (argDef));
            (yyval.memArg).atype = template_type;
            (yyval.memArg).u.td = td;
        }
    break;

  case 485:

/* Line 1455 of yacc.c  */
#line 3798 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            memset(&(yyval.memArg), 0, sizeof (argDef));

            /* In a C module all structures must be defined. */
            if (currentSpec -> genc)
            {
                (yyval.memArg).atype = defined_type;
                (yyval.memArg).u.snd = (yyvsp[(2) - (2)].scpvalp);
            }
            else
            {
                (yyval.memArg).atype = struct_type;
                (yyval.memArg).u.sname = (yyvsp[(2) - (2)].scpvalp);
            }
        }
    break;

  case 486:

/* Line 1455 of yacc.c  */
#line 3813 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            memset(&(yyval.memArg), 0, sizeof (argDef));
            (yyval.memArg).atype = ushort_type;
        }
    break;

  case 487:

/* Line 1455 of yacc.c  */
#line 3817 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            memset(&(yyval.memArg), 0, sizeof (argDef));
            (yyval.memArg).atype = short_type;
        }
    break;

  case 488:

/* Line 1455 of yacc.c  */
#line 3821 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            memset(&(yyval.memArg), 0, sizeof (argDef));
            (yyval.memArg).atype = uint_type;
        }
    break;

  case 489:

/* Line 1455 of yacc.c  */
#line 3825 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            memset(&(yyval.memArg), 0, sizeof (argDef));
            (yyval.memArg).atype = uint_type;
        }
    break;

  case 490:

/* Line 1455 of yacc.c  */
#line 3829 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            memset(&(yyval.memArg), 0, sizeof (argDef));
            (yyval.memArg).atype = int_type;
        }
    break;

  case 491:

/* Line 1455 of yacc.c  */
#line 3833 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            memset(&(yyval.memArg), 0, sizeof (argDef));
            (yyval.memArg).atype = long_type;
        }
    break;

  case 492:

/* Line 1455 of yacc.c  */
#line 3837 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            memset(&(yyval.memArg), 0, sizeof (argDef));
            (yyval.memArg).atype = ulong_type;
        }
    break;

  case 493:

/* Line 1455 of yacc.c  */
#line 3841 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            memset(&(yyval.memArg), 0, sizeof (argDef));
            (yyval.memArg).atype = longlong_type;
        }
    break;

  case 494:

/* Line 1455 of yacc.c  */
#line 3845 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            memset(&(yyval.memArg), 0, sizeof (argDef));
            (yyval.memArg).atype = ulonglong_type;
        }
    break;

  case 495:

/* Line 1455 of yacc.c  */
#line 3849 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            memset(&(yyval.memArg), 0, sizeof (argDef));
            (yyval.memArg).atype = float_type;
        }
    break;

  case 496:

/* Line 1455 of yacc.c  */
#line 3853 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            memset(&(yyval.memArg), 0, sizeof (argDef));
            (yyval.memArg).atype = double_type;
        }
    break;

  case 497:

/* Line 1455 of yacc.c  */
#line 3857 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            memset(&(yyval.memArg), 0, sizeof (argDef));
            (yyval.memArg).atype = bool_type;
        }
    break;

  case 498:

/* Line 1455 of yacc.c  */
#line 3861 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            memset(&(yyval.memArg), 0, sizeof (argDef));
            (yyval.memArg).atype = sstring_type;
        }
    break;

  case 499:

/* Line 1455 of yacc.c  */
#line 3865 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            memset(&(yyval.memArg), 0, sizeof (argDef));
            (yyval.memArg).atype = ustring_type;
        }
    break;

  case 500:

/* Line 1455 of yacc.c  */
#line 3869 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            memset(&(yyval.memArg), 0, sizeof (argDef));
            (yyval.memArg).atype = string_type;
        }
    break;

  case 501:

/* Line 1455 of yacc.c  */
#line 3873 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            memset(&(yyval.memArg), 0, sizeof (argDef));
            (yyval.memArg).atype = wstring_type;
        }
    break;

  case 502:

/* Line 1455 of yacc.c  */
#line 3877 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            memset(&(yyval.memArg), 0, sizeof (argDef));
            (yyval.memArg).atype = void_type;
        }
    break;

  case 503:

/* Line 1455 of yacc.c  */
#line 3881 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            memset(&(yyval.memArg), 0, sizeof (argDef));
            (yyval.memArg).atype = pyobject_type;
        }
    break;

  case 504:

/* Line 1455 of yacc.c  */
#line 3885 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            memset(&(yyval.memArg), 0, sizeof (argDef));
            (yyval.memArg).atype = pytuple_type;
        }
    break;

  case 505:

/* Line 1455 of yacc.c  */
#line 3889 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            memset(&(yyval.memArg), 0, sizeof (argDef));
            (yyval.memArg).atype = pylist_type;
        }
    break;

  case 506:

/* Line 1455 of yacc.c  */
#line 3893 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            memset(&(yyval.memArg), 0, sizeof (argDef));
            (yyval.memArg).atype = pydict_type;
        }
    break;

  case 507:

/* Line 1455 of yacc.c  */
#line 3897 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            memset(&(yyval.memArg), 0, sizeof (argDef));
            (yyval.memArg).atype = pycallable_type;
        }
    break;

  case 508:

/* Line 1455 of yacc.c  */
#line 3901 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            memset(&(yyval.memArg), 0, sizeof (argDef));
            (yyval.memArg).atype = pyslice_type;
        }
    break;

  case 509:

/* Line 1455 of yacc.c  */
#line 3905 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            memset(&(yyval.memArg), 0, sizeof (argDef));
            (yyval.memArg).atype = pytype_type;
        }
    break;

  case 510:

/* Line 1455 of yacc.c  */
#line 3909 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            memset(&(yyval.memArg), 0, sizeof (argDef));
            (yyval.memArg).atype = ssize_type;
        }
    break;

  case 511:

/* Line 1455 of yacc.c  */
#line 3913 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            memset(&(yyval.memArg), 0, sizeof (argDef));
            (yyval.memArg).atype = ellipsis_type;
        }
    break;

  case 512:

/* Line 1455 of yacc.c  */
#line 3919 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            /* The single or first type. */

            (yyval.signature).args[0] = (yyvsp[(1) - (1)].memArg);
            (yyval.signature).nrArgs = 1;
        }
    break;

  case 513:

/* Line 1455 of yacc.c  */
#line 3925 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            /* Check there is nothing after an ellipsis. */
            if ((yyvsp[(1) - (3)].signature).args[(yyvsp[(1) - (3)].signature).nrArgs - 1].atype == ellipsis_type)
                yyerror("An ellipsis must be at the end of the argument list");

            /* Check there is room. */
            if ((yyvsp[(1) - (3)].signature).nrArgs == MAX_NR_ARGS)
                yyerror("Internal error - increase the value of MAX_NR_ARGS");

            (yyval.signature) = (yyvsp[(1) - (3)].signature);

            (yyval.signature).args[(yyval.signature).nrArgs] = (yyvsp[(3) - (3)].memArg);
            (yyval.signature).nrArgs++;
        }
    break;

  case 514:

/* Line 1455 of yacc.c  */
#line 3941 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            (yyval.throwlist) = NULL;
        }
    break;

  case 515:

/* Line 1455 of yacc.c  */
#line 3944 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            if (currentSpec->genc)
                yyerror("Exceptions not allowed in a C module");

            (yyval.throwlist) = (yyvsp[(3) - (4)].throwlist);
        }
    break;

  case 516:

/* Line 1455 of yacc.c  */
#line 3952 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            /* Empty list so use a blank. */

            (yyval.throwlist) = sipMalloc(sizeof (throwArgs));
            (yyval.throwlist) -> nrArgs = 0;
        }
    break;

  case 517:

/* Line 1455 of yacc.c  */
#line 3958 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            /* The only or first exception. */

            (yyval.throwlist) = sipMalloc(sizeof (throwArgs));
            (yyval.throwlist) -> nrArgs = 1;
            (yyval.throwlist) -> args[0] = findException(currentSpec, (yyvsp[(1) - (1)].scpvalp), FALSE);
        }
    break;

  case 518:

/* Line 1455 of yacc.c  */
#line 3965 "/blur/cpp/lib/sip/sipgen/parser.y"
    {
            /* Check that it wasn't ...(,arg...). */

            if ((yyvsp[(1) - (3)].throwlist) -> nrArgs == 0)
                yyerror("First exception of throw specifier is missing");

            /* Check there is room. */

            if ((yyvsp[(1) - (3)].throwlist) -> nrArgs == MAX_NR_ARGS)
                yyerror("Internal error - increase the value of MAX_NR_ARGS");

            (yyval.throwlist) = (yyvsp[(1) - (3)].throwlist);
            (yyval.throwlist) -> args[(yyval.throwlist) -> nrArgs++] = findException(currentSpec, (yyvsp[(3) - (3)].scpvalp), FALSE);
        }
    break;



/* Line 1455 of yacc.c  */
#line 8122 "/blur/cpp/lib/sip/sipgen/parser.c"
      default: break;
    }
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now `shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*------------------------------------.
| yyerrlab -- here on detecting error |
`------------------------------------*/
yyerrlab:
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
      {
	YYSIZE_T yysize = yysyntax_error (0, yystate, yychar);
	if (yymsg_alloc < yysize && yymsg_alloc < YYSTACK_ALLOC_MAXIMUM)
	  {
	    YYSIZE_T yyalloc = 2 * yysize;
	    if (! (yysize <= yyalloc && yyalloc <= YYSTACK_ALLOC_MAXIMUM))
	      yyalloc = YYSTACK_ALLOC_MAXIMUM;
	    if (yymsg != yymsgbuf)
	      YYSTACK_FREE (yymsg);
	    yymsg = (char *) YYSTACK_ALLOC (yyalloc);
	    if (yymsg)
	      yymsg_alloc = yyalloc;
	    else
	      {
		yymsg = yymsgbuf;
		yymsg_alloc = sizeof yymsgbuf;
	      }
	  }

	if (0 < yysize && yysize <= yymsg_alloc)
	  {
	    (void) yysyntax_error (yymsg, yystate, yychar);
	    yyerror (yymsg);
	  }
	else
	  {
	    yyerror (YY_("syntax error"));
	    if (yysize != 0)
	      goto yyexhaustedlab;
	  }
      }
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
	 error, discard it.  */

      if (yychar <= YYEOF)
	{
	  /* Return failure if at end of input.  */
	  if (yychar == YYEOF)
	    YYABORT;
	}
      else
	{
	  yydestruct ("Error: discarding",
		      yytoken, &yylval);
	  yychar = YYEMPTY;
	}
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule which action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;	/* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (yyn != YYPACT_NINF)
	{
	  yyn += YYTERROR;
	  if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
	    {
	      yyn = yytable[yyn];
	      if (0 < yyn)
		break;
	    }
	}

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
	YYABORT;


      yydestruct ("Error: popping",
		  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  *++yyvsp = yylval;


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#if !defined(yyoverflow) || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEMPTY)
     yydestruct ("Cleanup: discarding lookahead",
		 yytoken, &yylval);
  /* Do not reclaim the symbols of the rule which action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
		  yystos[*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  /* Make sure YYID is used.  */
  return YYID (yyresult);
}



/* Line 1675 of yacc.c  */
#line 3981 "/blur/cpp/lib/sip/sipgen/parser.y"



/*
 * Parse the specification.
 */
void parse(sipSpec *spec, FILE *fp, char *filename, stringList *tsl,
        stringList *xfl, KwArgs kwArgs, int protHack)
{
    classTmplDef *tcd;

    /* Initialise the spec. */
 
    spec->modules = NULL;
    spec->namecache = NULL;
    spec->ifacefiles = NULL;
    spec->classes = NULL;
    spec->classtemplates = NULL;
    spec->exceptions = NULL;
    spec->mappedtypes = NULL;
    spec->mappedtypetemplates = NULL;
    spec->enums = NULL;
    spec->vars = NULL;
    spec->typedefs = NULL;
    spec->exphdrcode = NULL;
    spec->docs = NULL;
    spec->sigslots = FALSE;
    spec->genc = -1;
    spec->plugins = NULL;
    spec->extracts = NULL;

    currentSpec = spec;
    neededQualifiers = tsl;
    excludedQualifiers = xfl;
    currentModule = NULL;
    currentMappedType = NULL;
    currentOverIsVirt = FALSE;
    currentCtorIsExplicit = FALSE;
    currentIsStatic = FALSE;
    currentIsSignal = FALSE;
    currentIsSlot = FALSE;
    currentIsTemplate = FALSE;
    previousFile = NULL;
    skipStackPtr = 0;
    currentScopeIdx = 0;
    sectionFlags = 0;
    defaultKwArgs = kwArgs;
    makeProtPublic = protHack;

    newModule(fp, filename);
    spec->module = currentModule;

    yyparse();

    handleEOF();
    handleEOM();

    /*
     * Go through each template class and remove it from the list of classes.
     */
    for (tcd = spec->classtemplates; tcd != NULL; tcd = tcd->next)
    {
        classDef **cdp;

        for (cdp = &spec->classes; *cdp != NULL; cdp = &(*cdp)->next)
            if (*cdp == tcd->cd)
            {
                ifaceFileDef **ifdp;

                /* Remove the interface file as well. */
                for (ifdp = &spec->ifacefiles; *ifdp != NULL; ifdp = &(*ifdp)->next)
                    if (*ifdp == tcd->cd->iff)
                    {
                        *ifdp = (*ifdp)->next;
                        break;
                    }

                *cdp = (*cdp)->next;
                break;
            }
    }
}


/*
 * Tell the parser that a complete file has now been read.
 */
void parserEOF(char *name, parserContext *pc)
{
    previousFile = sipStrdup(name);
    currentContext = *pc;
}


/*
 * Append a class definition to a class list if it doesn't already appear.
 * Append is needed specifically for the list of super-classes because the
 * order is important to Python.
 */
void appendToClassList(classList **clp,classDef *cd)
{
    classList *new;

    /* Find the end of the list. */

    while (*clp != NULL)
    {
        if ((*clp) -> cd == cd)
            return;

        clp = &(*clp) -> next;
    }

    new = sipMalloc(sizeof (classList));

    new -> cd = cd;
    new -> next = NULL;

    *clp = new;
}


/*
 * Create a new module for the current specification and make it current.
 */
static void newModule(FILE *fp, const char *filename)
{
    moduleDef *mod;

    parseFile(fp, filename, currentModule, FALSE);

    mod = allocModule();
    mod->file = filename;

    if (currentModule != NULL)
        mod->defexception = currentModule->defexception;

    currentModule = mod;
}


/*
 * Allocate and initialise the memory for a new module.
 */
static moduleDef *allocModule()
{
    moduleDef *newmod, **tailp;

    newmod = sipMalloc(sizeof (moduleDef));

    newmod->version = -1;
    newmod->encoding = no_type;
    newmod->qobjclass = -1;
    newmod->nrvirthandlers = -1;
    newmod->next_key = -2;

    /*
     * The consolidated module support needs these to be in order that they
     * appeared.
     */
    for (tailp = &currentSpec->modules; *tailp != NULL; tailp = &(*tailp)->next)
        ;

    *tailp = newmod;

    return newmod;
}


/*
 * Switch to parsing a new file.
 */
static void parseFile(FILE *fp, const char *name, moduleDef *prevmod,
        int optional)
{
    parserContext pc;

    pc.filename = name;
    pc.ifdepth = skipStackPtr;
    pc.prevmod = prevmod;

    if (setInputFile(fp, &pc, optional))
        currentContext = pc;
}


/*
 * Find an interface file, or create a new one.
 */
ifaceFileDef *findIfaceFile(sipSpec *pt, moduleDef *mod, scopedNameDef *fqname,
        ifaceFileType iftype, apiVersionRangeDef *api_range, argDef *ad)
{
    ifaceFileDef *iff, *first_alt = NULL;

    /* See if the name is already used. */

    for (iff = pt->ifacefiles; iff != NULL; iff = iff->next)
    {
        if (compareScopedNames(iff->fqcname, fqname) != 0)
            continue;

        /*
         * If they are both versioned then assume the user knows what they are
         * doing.
         */
        if (iff->api_range != NULL && api_range != NULL && iff->module == mod)
        {
            /* Remember the first of the alternate APIs. */
            if ((first_alt = iff->first_alt) == NULL)
                first_alt = iff;

            break;
        }

        /*
         * They must be the same type except that we allow a class if we want
         * an exception.  This is because we allow classes to be used before
         * they are defined.
         */
        if (iff->type != iftype)
            if (iftype != exception_iface || iff->type != class_iface)
                yyerror("A class, exception, namespace or mapped type has already been defined with the same name");

        /* Ignore an external class declared in another module. */
        if (iftype == class_iface && iff->module != mod)
        {
            classDef *cd;

            for (cd = pt->classes; cd != NULL; cd = cd->next)
                if (cd->iff == iff)
                    break;

            if (cd != NULL && iff->module != NULL && isExternal(cd))
                continue;
        }

        /*
         * If this is a mapped type with the same name defined in a different
         * module, then check that this type isn't the same as any of the
         * mapped types defined in that module.
         */
        if (iftype == mappedtype_iface && iff->module != mod)
        {
            mappedTypeDef *mtd;

            /*
             * This is a bit of a cheat.  With consolidated modules it's
             * possible to have two implementations of a mapped type in
             * different branches of the module hierarchy.  We assume that, if
             * there really are multiple implementations in the same branch,
             * then it will be picked up in a non-consolidated build.
             */
            if (isConsolidated(pt->module))
                continue;

            for (mtd = pt->mappedtypes; mtd != NULL; mtd = mtd->next)
            {
                if (mtd->iff != iff)
                    continue;

                if (ad->atype != template_type ||
                    mtd->type.atype != template_type ||
                    sameBaseType(ad, &mtd->type))
                    yyerror("Mapped type has already been defined in another module");
            }

            /*
             * If we got here then we have a mapped type based on an existing
             * template, but with unique parameters.  We don't want to use
             * interface files from other modules, so skip this one.
             */

            continue;
        }

        /* Ignore a namespace defined in another module. */
        if (iftype == namespace_iface && iff->module != mod)
            continue;

        return iff;
    }

    iff = sipMalloc(sizeof (ifaceFileDef));

    iff->name = cacheName(pt, scopedNameToString(fqname));
    iff->api_range = api_range;

    if (first_alt != NULL)
    {
        iff->first_alt = first_alt;
        iff->next_alt = first_alt->next_alt;

        first_alt->next_alt = iff;
    }
    else
    {
        /* This is the first alternate so point to itself. */
        iff->first_alt = iff;
    }

    iff->type = iftype;
    iff->ifacenr = -1;
    iff->fqcname = fqname;
    iff->module = NULL;
    iff->hdrcode = NULL;
    iff->used = NULL;
    iff->next = pt->ifacefiles;

    pt->ifacefiles = iff;

    return iff;
}


/*
 * Find a class definition in a parse tree.
 */
static classDef *findClass(sipSpec *pt, ifaceFileType iftype,
        apiVersionRangeDef *api_range, scopedNameDef *fqname)
{
    return findClassWithInterface(pt, findIfaceFile(pt, currentModule, fqname, iftype, api_range, NULL));
}


/*
 * Find a class definition given an existing interface file.
 */
static classDef *findClassWithInterface(sipSpec *pt, ifaceFileDef *iff)
{
    classDef *cd;

    for (cd = pt -> classes; cd != NULL; cd = cd -> next)
        if (cd -> iff == iff)
            return cd;

    /* Create a new one. */
    cd = sipMalloc(sizeof (classDef));

    cd->iff = iff;
    cd->pyname = cacheName(pt, classBaseName(cd));
    cd->next = pt->classes;

    pt->classes = cd;

    return cd;
}


/*
 * Add an interface file to an interface file list if it isn't already there.
 */
void addToUsedList(ifaceFileList **ifflp, ifaceFileDef *iff)
{
    /* Make sure we don't try to add an interface file to its own list. */
    if (&iff->used != ifflp)
    {
        ifaceFileList *iffl;

        while ((iffl = *ifflp) != NULL)
        {
            /* Don't bother if it is already there. */
            if (iffl->iff == iff)
                return;

            ifflp = &iffl -> next;
        }

        iffl = sipMalloc(sizeof (ifaceFileList));

        iffl->iff = iff;
        iffl->next = NULL;

        *ifflp = iffl;
    }
}


/*
 * Find an undefined (or create a new) exception definition in a parse tree.
 */
static exceptionDef *findException(sipSpec *pt, scopedNameDef *fqname, int new)
{
    exceptionDef *xd, **tail;
    ifaceFileDef *iff;
    classDef *cd;

    iff = findIfaceFile(pt, currentModule, fqname, exception_iface, NULL, NULL);

    /* See if it is an existing one. */
    for (xd = pt->exceptions; xd != NULL; xd = xd->next)
        if (xd->iff == iff)
            return xd;

    /*
     * If it is an exception interface file then we have never seen this
     * name before.  We require that exceptions are defined before being
     * used, but don't make the same requirement of classes (for reasons of
     * backwards compatibility).  Therefore the name must be reinterpreted
     * as a (as yet undefined) class.
     */
    if (new)
    {
        if (iff->type == exception_iface)
            cd = NULL;
        else
            yyerror("There is already a class with the same name or the exception has been used before being defined");
    }
    else
    {
        if (iff->type == exception_iface)
            iff->type = class_iface;

        cd = findClassWithInterface(pt, iff);
    }

    /* Create a new one. */
    xd = sipMalloc(sizeof (exceptionDef));

    xd->exceptionnr = -1;
    xd->iff = iff;
    xd->pyname = NULL;
    xd->cd = cd;
    xd->bibase = NULL;
    xd->base = NULL;
    xd->raisecode = NULL;
    xd->next = NULL;

    /* Append it to the list. */
    for (tail = &pt->exceptions; *tail != NULL; tail = &(*tail)->next)
        ;

    *tail = xd;

    return xd;
}


/*
 * Find an undefined (or create a new) class definition in a parse tree.
 */
static classDef *newClass(sipSpec *pt, ifaceFileType iftype,
        apiVersionRangeDef *api_range, scopedNameDef *fqname)
{
    int flags;
    classDef *cd, *scope;
    codeBlockList *hdrcode;

    if (sectionFlags & SECT_IS_PRIVATE)
        yyerror("Classes, structs and namespaces must be in the public or protected sections");

    flags = 0;

    if ((scope = currentScope()) != NULL)
    {
        if (sectionFlags & SECT_IS_PROT && !makeProtPublic)
        {
            flags = CLASS_IS_PROTECTED;

            if (scope->iff->type == class_iface)
                setHasShadow(scope);
        }

        /* Header code from outer scopes is also included. */
        hdrcode = scope->iff->hdrcode;
    }
    else
        hdrcode = NULL;

    if (pt -> genc)
    {
        /* C structs are always global types. */
        while (fqname -> next != NULL)
            fqname = fqname -> next;

        scope = NULL;
    }

    cd = findClass(pt, iftype, api_range, fqname);

    /* Check it hasn't already been defined. */
    if (iftype != namespace_iface && cd->iff->module != NULL)
        yyerror("The struct/class has already been defined");

    /* Complete the initialisation. */
    cd->classflags |= flags;
    cd->ecd = scope;
    cd->iff->module = currentModule;

    if (currentIsTemplate)
        setIsTemplateClass(cd);

    appendCodeBlockList(&cd->iff->hdrcode, hdrcode);

    /* See if it is a namespace extender. */
    if (iftype == namespace_iface)
    {
        classDef *ns;

        for (ns = pt->classes; ns != NULL; ns = ns->next)
        {
            if (ns == cd)
                continue;

            if (ns->iff->type != namespace_iface)
                continue;

            if (compareScopedNames(ns->iff->fqcname, fqname) != 0)
                continue;

            cd->real = ns;
            break;
        }
    }

    return cd;
}


/*
 * Tidy up after finishing a class definition.
 */
static void finishClass(sipSpec *pt, moduleDef *mod, classDef *cd,
        optFlags *of)
{
    const char *pyname;
    optFlag *flg;

    /* Get the Python name and see if it is different to the C++ name. */
    pyname = getPythonName(mod, of, classBaseName(cd));

    cd->pyname = NULL;
    checkAttributes(pt, mod, cd->ecd, NULL, pyname, FALSE);
    cd->pyname = cacheName(pt, pyname);

    if ((flg = getOptFlag(of, "Metatype", dotted_name_flag)) != NULL)
        cd->metatype = cacheName(pt, flg->fvalue.sval);

    if ((flg = getOptFlag(of, "Supertype", dotted_name_flag)) != NULL)
        cd->supertype = cacheName(pt, flg->fvalue.sval);

    if ((flg = getOptFlag(of, "PyQt4Flags", integer_flag)) != NULL)
        cd->pyqt4_flags = flg->fvalue.ival;

    if (getOptFlag(of, "PyQt4NoQMetaObject", bool_flag) != NULL)
        setPyQt4NoQMetaObject(cd);

    if (isOpaque(cd))
    {
        if (getOptFlag(of, "External", bool_flag) != NULL)
            setIsExternal(cd);
    }
    else
    {
        int seq_might, seq_not;
        memberDef *md;

        if (getOptFlag(of, "NoDefaultCtors", bool_flag) != NULL)
            setNoDefaultCtors(cd);

        if (cd -> ctors == NULL)
        {
            if (!noDefaultCtors(cd))
            {
                /* Provide a default ctor. */

                cd->ctors = sipMalloc(sizeof (ctorDef));
 
                cd->ctors->ctorflags = SECT_IS_PUBLIC;
                cd->ctors->pysig.result.atype = void_type;
                cd->ctors->cppsig = &cd->ctors->pysig;

                cd->defctor = cd->ctors;

                setCanCreate(cd);
            }
        }
        else if (cd -> defctor == NULL)
        {
            ctorDef *ct, *last = NULL;

            for (ct = cd -> ctors; ct != NULL; ct = ct -> next)
            {
                if (!isPublicCtor(ct))
                    continue;

                if (ct -> pysig.nrArgs == 0 || ct -> pysig.args[0].defval != NULL)
                {
                    cd -> defctor = ct;
                    break;
                }

                if (last == NULL)
                    last = ct;
            }

            /* The last resort is the first public ctor. */
            if (cd->defctor == NULL)
                cd->defctor = last;
        }

        if (getDeprecated(of))
            setIsDeprecatedClass(cd);

        if (cd->convtocode != NULL && getAllowNone(of))
            setClassHandlesNone(cd);

        if (getOptFlag(of,"Abstract",bool_flag) != NULL)
        {
            setIsAbstractClass(cd);
            setIsIncomplete(cd);
            resetCanCreate(cd);
        }

        /* We assume a public dtor if nothing specific was provided. */
        if (!isDtor(cd))
            setIsPublicDtor(cd);

        if (getOptFlag(of, "DelayDtor", bool_flag) != NULL)
        {
            setIsDelayedDtor(cd);
            setHasDelayedDtors(mod);
        }

        if ((flg = getOptFlag(of,"VirtualErrorHandler",opt_name_flag)) != NULL)
        {
            cd->virterrorhandler = flg->fvalue.sval;
        }


        /*
         * There are subtle differences between the add and concat methods and
         * the multiply and repeat methods.  The number versions can have their
         * operands swapped and may return NotImplemented.  If the user has
         * used the /Numeric/ annotation or there are other numeric operators
         * then we use add/multiply.  Otherwise, if there are indexing
         * operators then we use concat/repeat.
         */
        seq_might = seq_not = FALSE;

        for (md = cd -> members; md != NULL; md = md -> next)
            switch (md -> slot)
            {
            case getitem_slot:
            case setitem_slot:
            case delitem_slot:
                /* This might be a sequence. */
                seq_might = TRUE;
                break;

            case sub_slot:
            case isub_slot:
            case div_slot:
            case idiv_slot:
            case mod_slot:
            case imod_slot:
            case floordiv_slot:
            case ifloordiv_slot:
            case truediv_slot:
            case itruediv_slot:
            case pos_slot:
            case neg_slot:
                /* This is definately not a sequence. */
                seq_not = TRUE;
                break;
            }

        if (!seq_not && seq_might)
            for (md = cd -> members; md != NULL; md = md -> next)
            {
                /* Ignore if the user has been explicit. */
                if (isNumeric(md))
                    continue;

                switch (md -> slot)
                {
                case add_slot:
                    md -> slot = concat_slot;
                    break;

                case iadd_slot:
                    md -> slot = iconcat_slot;
                    break;

                case mul_slot:
                    md -> slot = repeat_slot;
                    break;

                case imul_slot:
                    md -> slot = irepeat_slot;
                    break;
                }
            }
    }

    if (inMainModule())
    {
        setIsUsedName(cd->iff->name);
        setIsUsedName(cd->pyname);
    }
}


/*
 * Return the encoded name of a template (ie. including its argument types) as
 * a scoped name.
 */
scopedNameDef *encodedTemplateName(templateDef *td)
{
    int a;
    scopedNameDef *snd;

    snd = copyScopedName(td->fqname);

    for (a = 0; a < td->types.nrArgs; ++a)
    {
        char buf[50];
        int flgs;
        scopedNameDef *arg_snd;
        argDef *ad = &td->types.args[a];

        flgs = 0;

        if (isConstArg(ad))
            flgs += 1;

        if (isReference(ad))
            flgs += 2;

        /* We use numbers so they don't conflict with names. */
        sprintf(buf, "%02d%d%d", ad->atype, flgs, ad->nrderefs);

        switch (ad->atype)
        {
        case defined_type:
            arg_snd = copyScopedName(ad->u.snd);
            break;

        case template_type:
            arg_snd = encodedTemplateName(ad->u.td);
            break;

        case struct_type:
            arg_snd = copyScopedName(ad->u.sname);
            break;

        default:
            arg_snd = NULL;
        }

        /*
         * Replace the first element of the argument name with a copy with the
         * encoding prepended.
         */
        if (arg_snd != NULL)
            arg_snd->name = concat(buf, arg_snd->name, NULL);
        else
            arg_snd = text2scopePart(sipStrdup(buf));

        appendScopedName(&snd, arg_snd);
    }

    return snd;
}


/*
 * Create a new mapped type.
 */
static mappedTypeDef *newMappedType(sipSpec *pt, argDef *ad, optFlags *of)
{
    mappedTypeDef *mtd;
    scopedNameDef *snd;
    ifaceFileDef *iff;
    const char *cname;

    /* Check that the type is one we want to map. */
    switch (ad->atype)
    {
    case defined_type:
        snd = ad->u.snd;
        cname = scopedNameTail(snd);
        break;

    case template_type:
        snd = encodedTemplateName(ad->u.td);
        cname = NULL;
        break;

    case struct_type:
        snd = ad->u.sname;
        cname = scopedNameTail(snd);
        break;

    default:
        yyerror("Invalid type for %MappedType");
    }

    iff = findIfaceFile(pt, currentModule, snd, mappedtype_iface,
            getAPIRange(of), ad);

    /* Check it hasn't already been defined. */
    for (mtd = pt->mappedtypes; mtd != NULL; mtd = mtd->next)
        if (mtd->iff == iff)
        {
            /*
             * We allow types based on the same template but with different
             * arguments.
             */
            if (ad->atype != template_type || sameBaseType(ad, &mtd->type))
                yyerror("Mapped type has already been defined in this module");
        }

    /* The module may not have been set yet. */
    iff->module = currentModule;

    /* Create a new mapped type. */
    mtd = allocMappedType(pt, ad);

    if (cname != NULL)
        mtd->pyname = cacheName(pt, getPythonName(currentModule, of, cname));

    if (getOptFlag(of, "NoRelease", bool_flag) != NULL)
        setNoRelease(mtd);

    if (getAllowNone(of))
        setHandlesNone(mtd);

    mtd->doctype = getDocType(of);

    mtd->iff = iff;
    mtd->next = pt->mappedtypes;

    pt->mappedtypes = mtd;

    if (inMainModule())
    {
        setIsUsedName(mtd->cname);

        if (mtd->pyname)
            setIsUsedName(mtd->pyname);
    }

    return mtd;
}


/*
 * Allocate, initialise and return a mapped type structure.
 */
mappedTypeDef *allocMappedType(sipSpec *pt, argDef *type)
{
    mappedTypeDef *mtd;

    mtd = sipMalloc(sizeof (mappedTypeDef));

    mtd->type = *type;
    mtd->type.argflags = 0;
    mtd->type.nrderefs = 0;

    mtd->cname = cacheName(pt, type2string(&mtd->type));

    return mtd;
}


/*
 * Create a new enum.
 */
static enumDef *newEnum(sipSpec *pt, moduleDef *mod, mappedTypeDef *mt_scope,
        char *name, optFlags *of, int flags)
{
    enumDef *ed, *first_alt, *next_alt;
    classDef *c_scope;
    ifaceFileDef *scope;

    if (mt_scope != NULL)
    {
        scope = mt_scope->iff;
        c_scope = NULL;
    }
    else
    {
        if ((c_scope = currentScope()) != NULL)
            scope = c_scope->iff;
        else
            scope = NULL;
    }

    ed = sipMalloc(sizeof (enumDef));

    /* Assume the enum isn't versioned. */
    first_alt = ed;
    next_alt = NULL;

    if (name != NULL)
    {
        ed->pyname = cacheName(pt, getPythonName(mod, of, name));
        checkAttributes(pt, mod, c_scope, mt_scope, ed->pyname->text, FALSE);

        ed->fqcname = text2scopedName(scope, name);
        ed->cname = cacheName(pt, scopedNameToString(ed->fqcname));

        if (inMainModule())
        {
            setIsUsedName(ed->pyname);
            setIsUsedName(ed->cname);
        }

        /* If the scope is versioned then look for any alternate. */
        if (scope != NULL && scope->api_range != NULL)
        {
            enumDef *alt;

            for (alt = pt->enums; alt != NULL; alt = alt->next)
            {
                if (alt->module != mod || alt->fqcname == NULL)
                    continue;

                if (compareScopedNames(alt->fqcname, ed->fqcname) == 0)
                {
                    first_alt = alt->first_alt;
                    next_alt = first_alt->next_alt;
                    first_alt->next_alt = ed;

                    break;
                }
            }
        }
    }
    else
    {
        ed->pyname = NULL;
        ed->fqcname = NULL;
        ed->cname = NULL;
    }

    if (flags & SECT_IS_PROT)
    {
        if (makeProtPublic)
        {
            flags &= ~SECT_IS_PROT;
            flags |= SECT_IS_PUBLIC;
        }
        else if (c_scope != NULL)
        {
            setHasShadow(c_scope);
        }
    }

    ed->enumflags = flags;
    ed->enumnr = -1;
    ed->ecd = c_scope;
    ed->emtd = mt_scope;
    ed->first_alt = first_alt;
    ed->next_alt = next_alt;
    ed->module = mod;
    ed->members = NULL;
    ed->slots = NULL;
    ed->overs = NULL;
    ed->next = pt -> enums;

    pt->enums = ed;

    return ed;
}


/*
 * Get the type values and (optionally) the type names for substitution in
 * handwritten code.
 */
void appendTypeStrings(scopedNameDef *ename, signatureDef *patt, signatureDef *src, signatureDef *known, scopedNameDef **names, scopedNameDef **values)
{
    int a;

    for (a = 0; a < patt->nrArgs; ++a)
    {
        argDef *pad = &patt->args[a];

        if (pad->atype == defined_type)
        {
            char *nam = NULL, *val;
            argDef *sad;

            /*
             * If the type names are already known then check that this is one
             * of them.
             */
            if (known == NULL)
                nam = scopedNameTail(pad->u.snd);
            else if (pad->u.snd->next == NULL)
            {
                int k;

                for (k = 0; k < known->nrArgs; ++k)
                {
                    /* Skip base types. */
                    if (known->args[k].atype != defined_type)
                        continue;

                    if (strcmp(pad->u.snd->name, known->args[k].u.snd->name) == 0)
                    {
                        nam = pad->u.snd->name;
                        break;
                    }
                }
            }

            if (nam == NULL)
                continue;

            /* Add the name. */
            appendScopedName(names, text2scopePart(nam));

            /*
             * Add the corresponding value.  For defined types we don't want 
             * any indirection or references.
             */
            sad = &src->args[a];

            if (sad->atype == defined_type)
                val = scopedNameToString(sad->u.snd);
            else
                val = type2string(sad);

            /* We do want const. */
            if (isConstArg(sad))
            {
                char *const_val = sipStrdup("const ");

                append(&const_val, val);
                free(val);

                val = const_val;
            }

            appendScopedName(values, text2scopePart(val));
        }
        else if (pad->atype == template_type)
        {
            argDef *sad = &src->args[a];

            /* These checks shouldn't be necessary, but... */
            if (sad->atype == template_type && pad->u.td->types.nrArgs == sad->u.td->types.nrArgs)
                appendTypeStrings(ename, &pad->u.td->types, &sad->u.td->types, known, names, values);
        }
    }
}


/*
 * Convert a type to a string on the heap.  The string will use the minimum
 * whitespace while still remaining valid C++.
 */
static char *type2string(argDef *ad)
{
    int i, on_heap = FALSE;
    int nr_derefs = ad->nrderefs;
    int is_reference = isReference(ad);
    char *s;

    /* Use the original type if possible. */
    if (ad->original_type != NULL && !noTypeName(ad->original_type))
    {
        s = scopedNameToString(ad->original_type->fqname);
        on_heap = TRUE;

        nr_derefs -= ad->original_type->type.nrderefs;

        if (isReference(&ad->original_type->type))
            is_reference = FALSE;
    }
    else
        switch (ad->atype)
        {
        case template_type:
            {
                templateDef *td = ad->u.td;

                s = scopedNameToString(td->fqname);
                append(&s, "<");

                for (i = 0; i < td->types.nrArgs; ++i)
                {
                    char *sub_type = type2string(&td->types.args[i]);

                    if (i > 0)
                        append(&s, ",");

                    append(&s, sub_type);
                    free(sub_type);
                }

                if (s[strlen(s) - 1] == '>')
                    append(&s, " >");
                else
                    append(&s, ">");

                on_heap = TRUE;
                break;
            }

        case struct_type:
            s = scopedNameToString(ad->u.sname);
            on_heap = TRUE;
            break;

        case defined_type:
            s = scopedNameToString(ad->u.snd);
            on_heap = TRUE;
            break;

        case ubyte_type:
        case ustring_type:
            s = "unsigned char";
            break;

        case byte_type:
        case ascii_string_type:
        case latin1_string_type:
        case utf8_string_type:
        case string_type:
            s = "char";
            break;

        case sbyte_type:
        case sstring_type:
            s = "signed char";
            break;

        case wstring_type:
            s = "wchar_t";
            break;

        case ushort_type:
            s = "unsigned short";
            break;

        case short_type:
            s = "short";
            break;

        case uint_type:
            s = "uint";
            break;

        case int_type:
        case cint_type:
            s = "int";
            break;

        case ulong_type:
            s = "unsigned long";
            break;

        case long_type:
            s = "long";
            break;

        case ulonglong_type:
            s = "unsigned long long";
            break;

        case longlong_type:
            s = "long long";
            break;

        case float_type:
        case cfloat_type:
            s = "float";
            break;

        case double_type:
        case cdouble_type:
            s = "double";
            break;

        case bool_type:
        case cbool_type:
            s = "bool";
            break;

        default:
            fatal("Unsupported type argument to type2string(): %d\n", ad->atype);
        }

    /* Make sure the string is on the heap. */
    if (!on_heap)
        s = sipStrdup(s);

    while (nr_derefs-- > 0)
        append(&s, "*");

    if (is_reference)
        append(&s, "&");

    return s;
}


/*
 * Convert a scoped name to a string on the heap.
 */
static char *scopedNameToString(scopedNameDef *name)
{
    static const char scope_string[] = "::";
    size_t len;
    scopedNameDef *snd;
    char *s, *dp;

    /* Work out the length of buffer needed. */
    len = 0;

    for (snd = name; snd != NULL; snd = snd->next)
    {
        len += strlen(snd->name);

        if (snd->next != NULL)
        {
            /* Ignore the encoded part of template names. */
            if (isdigit(snd->next->name[0]))
                break;

            len += strlen(scope_string);
        }
    }

    /* Allocate and populate the buffer. */
    dp = s = sipMalloc(len + 1);

    for (snd = name; snd != NULL; snd = snd->next)
    {
        strcpy(dp, snd->name);
        dp += strlen(snd->name);

        if (snd->next != NULL)
        {
            /* Ignore the encoded part of template names. */
            if (isdigit(snd->next->name[0]))
                break;

            strcpy(dp, scope_string);
            dp += strlen(scope_string);
        }
    }

    return s;
}


/*
 * Instantiate a class template.
 */
static void instantiateClassTemplate(sipSpec *pt, moduleDef *mod,
        classDef *scope, scopedNameDef *fqname, classTmplDef *tcd,
        templateDef *td)
{
    scopedNameDef *type_names, *type_values;
    classDef *cd;
    ctorDef *oct, **cttail;
    argDef *ad;
    ifaceFileList *iffl, **used;

    type_names = type_values = NULL;
    appendTypeStrings(classFQCName(tcd->cd), &tcd->sig, &td->types, NULL, &type_names, &type_values);

    /*
     * Add a mapping from the template name to the instantiated name.  If we
     * have got this far we know there is room for it.
     */
    ad = &tcd->sig.args[tcd->sig.nrArgs++];
    memset(ad, 0, sizeof (argDef));
    ad->atype = defined_type;
    ad->u.snd = classFQCName(tcd->cd);

    appendScopedName(&type_names, text2scopePart(scopedNameTail(classFQCName(tcd->cd))));
    appendScopedName(&type_values, text2scopePart(scopedNameToString(fqname)));

    /* Create the new class. */
    cd = sipMalloc(sizeof (classDef));

    /* Start with a shallow copy. */
    *cd = *tcd->cd;

    resetIsTemplateClass(cd);
    cd->pyname = cacheName(pt, scopedNameTail(fqname));
    cd->td = td;

    /* Handle the interface file. */
    cd->iff = findIfaceFile(pt, mod, fqname, class_iface,
            (scope != NULL ? scope->iff->api_range : NULL), NULL);
    cd->iff->module = mod;

    appendCodeBlockList(&cd->iff->hdrcode, tcd->cd->iff->hdrcode);

    /* Make a copy of the used list and add the enclosing scope. */
    used = &cd->iff->used;

    for (iffl = tcd->cd->iff->used; iffl != NULL; iffl = iffl->next)
        addToUsedList(used, iffl->iff);

    /* Include any scope header code. */
    if (scope != NULL)
        appendCodeBlockList(&cd->iff->hdrcode, scope->iff->hdrcode);

    if (inMainModule())
    {
        setIsUsedName(cd->iff->name);
        setIsUsedName(cd->pyname);
    }

    cd->ecd = currentScope();

    /* Handle the enums. */
    instantiateTemplateEnums(pt, tcd, td, cd, used, type_names, type_values);

    /* Handle the variables. */
    instantiateTemplateVars(pt, tcd, td, cd, used, type_names, type_values);

    /* Handle the typedefs. */
    instantiateTemplateTypedefs(pt, tcd, td, cd);

    /* Handle the ctors. */
    cd->ctors = NULL;
    cttail = &cd->ctors;

    for (oct = tcd->cd->ctors; oct != NULL; oct = oct->next)
    {
        ctorDef *nct = sipMalloc(sizeof (ctorDef));

        /* Start with a shallow copy. */
        *nct = *oct;

        templateSignature(&nct->pysig, FALSE, tcd, td, cd);

        if (oct->cppsig == NULL)
            nct->cppsig = NULL;
        else if (oct->cppsig == &oct->pysig)
            nct->cppsig = &nct->pysig;
        else
        {
            nct->cppsig = sipMalloc(sizeof (signatureDef));

            *nct->cppsig = *oct->cppsig;

            templateSignature(nct->cppsig, FALSE, tcd, td, cd);
        }

        nct->methodcode = templateCode(pt, used, nct->methodcode, type_names, type_values);

        nct->next = NULL;
        *cttail = nct;
        cttail = &nct->next;

        /* Handle the default ctor. */
        if (tcd->cd->defctor == oct)
            cd->defctor = nct;
    }

    cd->dealloccode = templateCode(pt, used, cd->dealloccode, type_names, type_values);
    cd->dtorcode = templateCode(pt, used, cd->dtorcode, type_names, type_values);

    /* Handle the methods. */
    cd->members = instantiateTemplateMethods(tcd->cd->members, mod);
    cd->overs = instantiateTemplateOverloads(pt, tcd->cd->overs,
            tcd->cd->members, cd->members, tcd, td, cd, used, type_names,
            type_values);

    cd->cppcode = templateCode(pt, used, cd->cppcode, type_names, type_values);
    cd->iff->hdrcode = templateCode(pt, used, cd->iff->hdrcode, type_names, type_values);
    cd->convtosubcode = templateCode(pt, used, cd->convtosubcode, type_names, type_values);
    cd->convtocode = templateCode(pt, used, cd->convtocode, type_names, type_values);
    cd->travcode = templateCode(pt, used, cd->travcode, type_names, type_values);
    cd->clearcode = templateCode(pt, used, cd->clearcode, type_names, type_values);
    cd->getbufcode = templateCode(pt, used, cd->getbufcode, type_names, type_values);
    cd->releasebufcode = templateCode(pt, used, cd->releasebufcode, type_names, type_values);
    cd->readbufcode = templateCode(pt, used, cd->readbufcode, type_names, type_values);
    cd->writebufcode = templateCode(pt, used, cd->writebufcode, type_names, type_values);
    cd->segcountcode = templateCode(pt, used, cd->segcountcode, type_names, type_values);
    cd->charbufcode = templateCode(pt, used, cd->charbufcode, type_names, type_values);
    cd->picklecode = templateCode(pt, used, cd->picklecode, type_names, type_values);
    cd->next = pt->classes;

    pt->classes = cd;

    tcd->sig.nrArgs--;

    freeScopedName(type_names);
    freeScopedName(type_values);
}


/*
 * Instantiate the methods of a template class.
 */
static memberDef *instantiateTemplateMethods(memberDef *tmd, moduleDef *mod)
{
    memberDef *md, *methods, **mdtail;

    methods = NULL;
    mdtail = &methods;

    for (md = tmd; md != NULL; md = md->next)
    {
        memberDef *nmd = sipMalloc(sizeof (memberDef));

        /* Start with a shallow copy. */
        *nmd = *md;

        nmd->module = mod;

        if (inMainModule())
            setIsUsedName(nmd->pyname);

        nmd->next = NULL;
        *mdtail = nmd;
        mdtail = &nmd->next;
    }

    return methods;
}


/*
 * Instantiate the overloads of a template class.
 */
static overDef *instantiateTemplateOverloads(sipSpec *pt, overDef *tod,
        memberDef *tmethods, memberDef *methods, classTmplDef *tcd,
        templateDef *td, classDef *cd, ifaceFileList **used,
        scopedNameDef *type_names, scopedNameDef *type_values)
{
    overDef *od, *overloads, **odtail;

    overloads = NULL;
    odtail = &overloads;

    for (od = tod; od != NULL; od = od->next)
    {
        overDef *nod = sipMalloc(sizeof (overDef));
        memberDef *nmd, *omd;

        /* Start with a shallow copy. */
        *nod = *od;

        for (nmd = methods, omd = tmethods; omd != NULL; omd = omd->next, nmd = nmd->next)
            if (omd == od->common)
            {
                nod->common = nmd;
                break;
            }

        templateSignature(&nod->pysig, TRUE, tcd, td, cd);

        if (od->cppsig == &od->pysig)
            nod->cppsig = &nod->pysig;
        else
        {
            nod->cppsig = sipMalloc(sizeof (signatureDef));

            *nod->cppsig = *od->cppsig;

            templateSignature(nod->cppsig, TRUE, tcd, td, cd);
        }

        nod->methodcode = templateCode(pt, used, nod->methodcode, type_names, type_values);

        /* Handle any virtual handler. */
        if (od->virthandler != NULL)
        {
            moduleDef *mod = cd->iff->module;

            nod->virthandler = sipMalloc(sizeof (virtHandlerDef));

            /* Start with a shallow copy. */
            *nod->virthandler = *od->virthandler;

            if (od->virthandler->cppsig == &od->pysig)
                nod->virthandler->cppsig = &nod->pysig;
            else
            {
                nod->virthandler->cppsig = sipMalloc(sizeof (signatureDef));

                *nod->virthandler->cppsig = *od->virthandler->cppsig;

                templateSignature(nod->virthandler->cppsig, TRUE, tcd, td, cd);
            }

            nod->virthandler->module = mod;
            nod->virthandler->virtcode = templateCode(pt, used, nod->virthandler->virtcode, type_names, type_values);
            nod->virthandler->next = mod->virthandlers;

            mod->virthandlers = nod->virthandler;
        }

        nod->next = NULL;
        *odtail = nod;
        odtail = &nod->next;
    }

    return overloads;
}


/*
 * Instantiate the enums of a template class.
 */
static void instantiateTemplateEnums(sipSpec *pt, classTmplDef *tcd,
        templateDef *td, classDef *cd, ifaceFileList **used,
        scopedNameDef *type_names, scopedNameDef *type_values)
{
    enumDef *ted;
    moduleDef *mod = cd->iff->module;

    for (ted = pt->enums; ted != NULL; ted = ted->next)
        if (ted->ecd == tcd->cd)
        {
            enumDef *ed;
            enumMemberDef *temd;

            ed = sipMalloc(sizeof (enumDef));

            /* Start with a shallow copy. */
            *ed = *ted;

            if (ed->fqcname != NULL)
            {
                ed->fqcname = text2scopedName(cd->iff,
                        scopedNameTail(ed->fqcname));
                ed->cname = cacheName(pt, scopedNameToString(ed->fqcname));
            }

            if (inMainModule())
            {
                if (ed->pyname != NULL)
                    setIsUsedName(ed->pyname);

                if (ed->cname != NULL)
                    setIsUsedName(ed->cname);
            }

            ed->ecd = cd;
            ed->first_alt = ed;
            ed->module = mod;
            ed->members = NULL;

            for (temd = ted->members; temd != NULL; temd = temd->next)
            {
                enumMemberDef *emd;

                emd = sipMalloc(sizeof (enumMemberDef));

                /* Start with a shallow copy. */
                *emd = *temd;
                emd->ed = ed;

                emd->next = ed->members;
                ed->members = emd;
            }

            ed->slots = instantiateTemplateMethods(ted->slots, mod);
            ed->overs = instantiateTemplateOverloads(pt, ted->overs,
                    ted->slots, ed->slots, tcd, td, cd, used, type_names,
                    type_values);

            ed->next = pt->enums;
            pt->enums = ed;
        }
}


/*
 * Instantiate the variables of a template class.
 */
static void instantiateTemplateVars(sipSpec *pt, classTmplDef *tcd,
        templateDef *td, classDef *cd, ifaceFileList **used,
        scopedNameDef *type_names, scopedNameDef *type_values)
{
    varDef *tvd;

    for (tvd = pt->vars; tvd != NULL; tvd = tvd->next)
        if (tvd->ecd == tcd->cd)
        {
            varDef *vd;

            vd = sipMalloc(sizeof (varDef));

            /* Start with a shallow copy. */
            *vd = *tvd;

            if (inMainModule())
                setIsUsedName(vd->pyname);

            vd->fqcname = text2scopedName(cd->iff,
                    scopedNameTail(vd->fqcname));
            vd->ecd = cd;
            vd->module = cd->iff->module;

            templateType(&vd->type, tcd, td, cd);

            vd->accessfunc = templateCode(pt, used, vd->accessfunc, type_names, type_values);
            vd->getcode = templateCode(pt, used, vd->getcode, type_names, type_values);
            vd->setcode = templateCode(pt, used, vd->setcode, type_names, type_values);

            addVariable(pt, vd);
        }
}


/*
 * Instantiate the typedefs of a template class.
 */
static void instantiateTemplateTypedefs(sipSpec *pt, classTmplDef *tcd,
        templateDef *td, classDef *cd)
{
    typedefDef *tdd;

    for (tdd = pt->typedefs; tdd != NULL; tdd = tdd->next)
    {
        typedefDef *new_tdd;

        if (tdd->ecd != tcd->cd)
            continue;

        new_tdd = sipMalloc(sizeof (typedefDef));

        /* Start with a shallow copy. */
        *new_tdd = *tdd;

        new_tdd->fqname = text2scopedName(cd->iff,
                scopedNameTail(new_tdd->fqname));
        new_tdd->ecd = cd;
        new_tdd->module = cd->iff->module;

        templateType(&new_tdd->type, tcd, td, cd);

        addTypedef(pt, new_tdd);
    }
}


/*
 * Replace any template arguments in a signature.
 */
static void templateSignature(signatureDef *sd, int result, classTmplDef *tcd, templateDef *td, classDef *ncd)
{
    int a;

    if (result)
        templateType(&sd->result, tcd, td, ncd);

    for (a = 0; a < sd->nrArgs; ++a)
        templateType(&sd->args[a], tcd, td, ncd);
}


/*
 * Replace any template arguments in a type.
 */
static void templateType(argDef *ad, classTmplDef *tcd, templateDef *td, classDef *ncd)
{
    int a;
    char *name;

    /* Descend into any sub-templates. */
    if (ad->atype == template_type)
    {
        templateDef *new_td = sipMalloc(sizeof (templateDef));

        /* Make a deep copy of the template definition. */
        *new_td = *ad->u.td;
        ad->u.td = new_td;

        templateSignature(&ad->u.td->types, FALSE, tcd, td, ncd);

        return;
    }

    /* Ignore if it isn't an unscoped name. */
    if (ad->atype != defined_type || ad->u.snd->next != NULL)
        return;

    name = ad->u.snd->name;

    for (a = 0; a < tcd->sig.nrArgs - 1; ++a)
        if (strcmp(name, scopedNameTail(tcd->sig.args[a].u.snd)) == 0)
        {
            argDef *tad = &td->types.args[a];

            ad->atype = tad->atype;

            /* We take the constrained flag from the real type. */
            resetIsConstrained(ad);

            if (isConstrained(tad))
                setIsConstrained(ad);

            ad->u = tad->u;

            return;
        }

    /* Handle the class name itself. */
    if (strcmp(name, scopedNameTail(classFQCName(tcd->cd))) == 0)
    {
        ad->atype = class_type;
        ad->u.cd = ncd;
        ad->original_type = NULL;
    }
}


/*
 * Replace any template arguments in a literal code block.
 */
codeBlockList *templateCode(sipSpec *pt, ifaceFileList **used,
        codeBlockList *ocbl, scopedNameDef *names, scopedNameDef *values)
{
    codeBlockList *ncbl = NULL;

    while (ocbl != NULL)
    {
        char *at = ocbl->block->frag;
        int start_of_line = TRUE;

        do
        {
            char *from = at, *first = NULL;
            codeBlock *cb;
            scopedNameDef *nam, *val, *nam_first, *val_first;

            /*
             * Don't do any substitution in lines that appear to be
             * preprocessor directives.  This prevents #include'd file names
             * being broken.
             */
            if (start_of_line)
            {
                /* Strip leading whitespace. */
                while (isspace(*from))
                    ++from;

                if (*from == '#')
                {
                    /* Skip to the end of the line. */
                    do
                        ++from;
                    while (*from != '\n' && *from != '\0');
                }
                else
                {
                    start_of_line = FALSE;
                }
            }

            /*
             * Go through the rest of this fragment looking for each of the
             * types and the name of the class itself.
             */
            nam = names;
            val = values;

            while (nam != NULL && val != NULL)
            {
                char *cp;

                if ((cp = strstr(from, nam->name)) != NULL)
                    if (first == NULL || first > cp)
                    {
                        nam_first = nam;
                        val_first = val;
                        first = cp;
                    }

                nam = nam->next;
                val = val->next;
            }

            /* Create the new fragment. */
            cb = sipMalloc(sizeof (codeBlock));

            if (at == ocbl->block->frag)
            {
                cb->filename = ocbl->block->filename;
                cb->linenr = ocbl->block->linenr;
            }
            else
                cb->filename = NULL;

            appendCodeBlock(&ncbl, cb);

            /* See if anything was found. */
            if (first == NULL)
            {
                /* We can just point to this. */
                cb->frag = at;

                /* All done with this one. */
                at = NULL;
            }
            else
            {
                static char *gen_names[] = {
                    "sipType_",
                    "sipClass_",
                    "sipEnum_",
                    "sipException_",
                    NULL
                };

                char *dp, *sp, **gn;
                int genname = FALSE;

                /*
                 * If the context in which the text is used is in the name of a
                 * SIP generated object then translate any "::" scoping to "_"
                 * and remove any const.
                 */
                for (gn = gen_names; *gn != NULL; ++gn)
                    if (search_back(first, at, *gn))
                    {
                        addUsedFromCode(pt, used, val_first->name);
                        genname = TRUE;
                        break;
                    }

                /* Fragment the fragment. */
                cb->frag = sipMalloc(first - at + strlen(val_first->name) + 1);

                strncpy(cb->frag, at, first - at);

                dp = &cb->frag[first - at];
                sp = val_first->name;

                if (genname)
                {
                    char gch;

                    if (strlen(sp) > 6 && strncmp(sp, "const ", 6) == 0)
                        sp += 6;

                    while ((gch = *sp++) != '\0')
                        if (gch == ':' && *sp == ':')
                        {
                            *dp++ = '_';
                            ++sp;
                        }
                        else
                            *dp++ = gch;

                    *dp = '\0';
                }
                else
                    strcpy(dp, sp);

                /* Move past the replaced text. */
                at = first + strlen(nam_first->name);

                if (*at == '\n')
                    start_of_line = TRUE;
            }
        }
        while (at != NULL && *at != '\0');

        ocbl = ocbl->next;
    }

    return ncbl;
}


/*
 * Return TRUE if the text at the end of a string matches the target string.
 */
static int search_back(const char *end, const char *start, const char *target)
{
    size_t tlen = strlen(target);

    if (start + tlen >= end)
        return FALSE;

    return (strncmp(end - tlen, target, tlen) == 0);
}


/*
 * Add any needed interface files based on handwritten code.
 */
static void addUsedFromCode(sipSpec *pt, ifaceFileList **used, const char *sname)
{
    ifaceFileDef *iff;
    enumDef *ed;

    for (iff = pt->ifacefiles; iff != NULL; iff = iff->next)
    {
        if (iff->type != class_iface && iff->type != exception_iface)
            continue;

        if (sameName(iff->fqcname, sname))
        {
            addToUsedList(used, iff);
            return;
        }
    }

    for (ed = pt->enums; ed != NULL; ed = ed->next)
    {
        if (ed->ecd == NULL)
            continue;

        if (sameName(ed->fqcname, sname))
        {
            addToUsedList(used, ed->ecd->iff);
            return;
        }
    }
}


/*
 * Compare a scoped name with its string equivalent.
 */
static int sameName(scopedNameDef *snd, const char *sname)
{
    while (snd != NULL && *sname != '\0')
    {
        const char *sp = snd->name;

        while (*sp != '\0' && *sname != ':' && *sname != '\0')
            if (*sp++ != *sname++)
                return FALSE;

        if (*sp != '\0' || (*sname != ':' && *sname != '\0'))
            return FALSE;

        snd = snd->next;

        if (*sname == ':')
            sname += 2;
    }

    return (snd == NULL && *sname == '\0');
}


/*
 * Compare a (possibly) relative scoped name with a fully qualified scoped name
 * while taking the current scope into account.
 */
static int foundInScope(scopedNameDef *fq_name, scopedNameDef *rel_name)
{
    classDef *scope;

    for (scope = currentScope(); scope != NULL; scope = scope->ecd)
    {
        scopedNameDef *snd;
        int found;

        snd = copyScopedName(classFQCName(scope));
        appendScopedName(&snd, copyScopedName(rel_name));

        found = (compareScopedNames(fq_name, snd) == 0);

        freeScopedName(snd);

        if (found)
            return TRUE;
    }

    return compareScopedNames(fq_name, rel_name) == 0;
}


/*
 * Create a new typedef.
 */
static void newTypedef(sipSpec *pt, moduleDef *mod, char *name, argDef *type,
        optFlags *optflgs)
{
    typedefDef *td;
    scopedNameDef *fqname;
    classDef *scope;

    scope = currentScope();
    fqname = text2scopedName((scope != NULL ? scope->iff : NULL), name);

    /* See if we are instantiating a template class. */
    if (type->atype == template_type)
    {
        classTmplDef *tcd;
        templateDef *td = type->u.td;

        for (tcd = pt->classtemplates; tcd != NULL; tcd = tcd->next)
            if (foundInScope(tcd->cd->iff->fqcname, td->fqname) &&
                sameTemplateSignature(&tcd->sig, &td->types, FALSE))
            {
                instantiateClassTemplate(pt, mod, scope, fqname, tcd, td);

                /* All done. */
                return;
            }
    }

    td = sipMalloc(sizeof (typedefDef));

    td->tdflags = 0;
    td->fqname = fqname;
    td->ecd = scope;
    td->module = mod;
    td->type = *type;

    if (getOptFlag(optflgs, "NoTypeName", bool_flag) != NULL)
        setNoTypeName(td);

    addTypedef(pt, td);
}


/*
 * Add a typedef to the list so that the list remains sorted.
 */
static void addTypedef(sipSpec *pt, typedefDef *tdd)
{
    typedefDef **tdp;

    /*
     * Check it doesn't already exist and find the position in the sorted list
     * where it should be put.
     */
    for (tdp = &pt->typedefs; *tdp != NULL; tdp = &(*tdp)->next)
    {
        int res = compareScopedNames((*tdp)->fqname, tdd->fqname);

        if (res == 0)
        {
            fatalScopedName(tdd->fqname);
            fatal(" already defined\n");
        }

        if (res > 0)
            break;
    }

    tdd->next = *tdp;
    *tdp = tdd;

    tdd->module->nrtypedefs++;
}


/*
 * Speculatively try and resolve any typedefs.  In some cases (eg. when
 * comparing template signatures) it helps to use the real type if it is known.
 * Note that this wouldn't be necessary if we required that all types be known
 * before they are used.
 */
static void resolveAnyTypedef(sipSpec *pt, argDef *ad)
{
    argDef orig = *ad;

    while (ad->atype == defined_type)
    {
        ad->atype = no_type;
        searchTypedefs(pt, ad->u.snd, ad);

        /*
         * Don't resolve to a template type as it may be superceded later on
         * by a more specific mapped type.
         */
        if (ad->atype == no_type || ad->atype == template_type)
        {
            *ad = orig;
            break;
        }
    }
}


/*
 * Return TRUE if the template signatures are the same.  A deep comparison is
 * used for mapped type templates where we want to recurse into any nested
 * templates.
 */
int sameTemplateSignature(signatureDef *tmpl_sd, signatureDef *args_sd,
        int deep)
{
    int a;

    if (tmpl_sd->nrArgs != args_sd->nrArgs)
        return FALSE;

    for (a = 0; a < tmpl_sd->nrArgs; ++a)
    {
        argDef *tmpl_ad = &tmpl_sd->args[a];
        argDef *args_ad = &args_sd->args[a];

        /*
         * If we are doing a shallow comparision (ie. for class templates) then
         * a type name in the template signature matches anything in the
         * argument signature.
         */
        if (tmpl_ad->atype == defined_type && !deep)
            continue;

        /*
         * For type names only compare the references and pointers, and do the
         * same for any nested templates.
         */
        if (tmpl_ad->atype == defined_type && args_ad->atype == defined_type)
        {
            if (isReference(tmpl_ad) != isReference(args_ad) || tmpl_ad->nrderefs != args_ad->nrderefs)
                return FALSE;
        }
        else if (tmpl_ad->atype == template_type && args_ad->atype == template_type)
        {
            if (!sameTemplateSignature(&tmpl_ad->u.td->types, &args_ad->u.td->types, deep))
                return FALSE;
        }
        else if (!sameBaseType(tmpl_ad, args_ad))
            return FALSE;
    }

    return TRUE;
}


/*
 * Create a new variable.
 */
static void newVar(sipSpec *pt, moduleDef *mod, char *name, int isstatic,
        argDef *type, optFlags *of, codeBlock *acode, codeBlock *gcode,
        codeBlock *scode, int section)
{
    varDef *var;
    classDef *escope = currentScope();
    nameDef *nd;

    /* Check the section. */
    if (section != 0)
    {
        if ((section & SECT_IS_PUBLIC) == 0)
            yyerror("Class variables must be in the public section");

        if (!isstatic && acode != NULL)
            yyerror("%AccessCode cannot be specified for non-static class variables");
    }

    if (isstatic && pt->genc)
        yyerror("Cannot have static members in a C structure");

    if (gcode != NULL || scode != NULL)
    {
        if (acode != NULL)
            yyerror("Cannot mix %AccessCode and %GetCode or %SetCode");

        if (escope == NULL)
            yyerror("Cannot specify %GetCode or %SetCode for global variables");
    }

    applyTypeFlags(mod, type, of);

    nd = cacheName(pt, getPythonName(mod, of, name));

    if (inMainModule())
        setIsUsedName(nd);

    checkAttributes(pt, mod, escope, NULL, nd->text, FALSE);

    var = sipMalloc(sizeof (varDef));

    var->pyname = nd;
    var->fqcname = text2scopedName((escope != NULL ? escope->iff : NULL),
            name);
    var->ecd = escope;
    var->module = mod;
    var->varflags = 0;
    var->type = *type;
    appendCodeBlock(&var->accessfunc, acode);
    appendCodeBlock(&var->getcode, gcode);
    appendCodeBlock(&var->setcode, scode);

    if (isstatic || (escope != NULL && escope->iff->type == namespace_iface))
        setIsStaticVar(var);

    addVariable(pt, var);
}


/*
 * Create a new ctor.
 */
static void newCtor(moduleDef *mod, char *name, int sectFlags,
        signatureDef *args, optFlags *optflgs, codeBlock *methodcode,
        throwArgs *exceptions, signatureDef *cppsig, int explicit,
        codeBlock *docstring)
{
    ctorDef *ct, **ctp;
    classDef *cd = currentScope();

    /* Check the name of the constructor. */
    if (strcmp(classBaseName(cd), name) != 0)
        yyerror("Constructor doesn't have the same name as its class");

    if (docstring != NULL)
        appendCodeBlock(&cd->docstring, docstring);

    /* Add to the list of constructors. */
    ct = sipMalloc(sizeof (ctorDef));

    if (sectFlags & SECT_IS_PROT && makeProtPublic)
    {
        sectFlags &= ~SECT_IS_PROT;
        sectFlags |= SECT_IS_PUBLIC;
    }

    /* Allow the signature to be used like an function signature. */
    memset(&args->result, 0, sizeof (argDef));
    args->result.atype = void_type;

    ct->ctorflags = sectFlags;
    ct->api_range = getAPIRange(optflgs);
    ct->pysig = *args;
    ct->cppsig = (cppsig != NULL ? cppsig : &ct->pysig);
    ct->exceptions = exceptions;
    appendCodeBlock(&ct->methodcode, methodcode);

    if (!isPrivateCtor(ct))
        setCanCreate(cd);

    if (isProtectedCtor(ct))
        setHasShadow(cd);

    if (explicit)
        setIsExplicitCtor(ct);

    getHooks(optflgs, &ct->prehook, &ct->posthook);

    if (getReleaseGIL(optflgs))
        setIsReleaseGILCtor(ct);
    else if (getHoldGIL(optflgs))
        setIsHoldGILCtor(ct);

    if (getTransfer(optflgs))
        setIsResultTransferredCtor(ct);

    if (getDeprecated(optflgs))
        setIsDeprecatedCtor(ct);

    if (!isPrivateCtor(ct))
        ct->kwargs = keywordArgs(mod, optflgs, &ct->pysig, FALSE);

    if (getOptFlag(optflgs, "NoDerived", bool_flag) != NULL)
    {
        if (cppsig != NULL)
            yyerror("The /NoDerived/ annotation cannot be used with a C++ signature");

        if (methodcode == NULL)
            yyerror("The /NoDerived/ annotation must be used with %MethodCode");

        ct->cppsig = NULL;
    }

    if (getOptFlag(optflgs, "Default", bool_flag) != NULL)
    {
        if (cd->defctor != NULL)
            yyerror("A constructor with the /Default/ annotation has already been defined");

        cd->defctor = ct;
    }

    /* Append to the list. */
    for (ctp = &cd->ctors; *ctp != NULL; ctp = &(*ctp)->next)
        ;

    *ctp = ct;
}


/*
 * Create a new function.
 */
static void newFunction(sipSpec *pt, moduleDef *mod, classDef *c_scope,
        mappedTypeDef *mt_scope, int sflags, int isstatic, int issignal,
        int isslot, int isvirt, char *name, signatureDef *sig, int isconst,
        int isabstract, optFlags *optflgs, codeBlock *methodcode,
        codeBlock *vcode, throwArgs *exceptions, signatureDef *cppsig,
        codeBlock *docstring)
{
    static const char *annos[] = {
        "__len__",
        "API",
        "AutoGen",
        "Deprecated",
        "DocType",
        "Encoding",
        "Factory",
        "HoldGIL",
        "KeywordArgs",
        "KeepReference",
        "NewThread",
        "NoArgParser",
        "NoCopy",
        "Numeric",
        "PostHook",
        "PreHook",
        "PyInt",
        "PyName",
        "RaisesPyException",
        "ReleaseGIL",
        "Transfer",
        "TransferBack",
        "TransferThis",
        NULL
    };

    const char *pyname;
    int factory, xferback, no_arg_parser;
    overDef *od, **odp, **headp;
    optFlag *of;
    virtHandlerDef *vhd;

    checkAnnos(optflgs, annos);

    /* Extra checks for a C module. */
    if (pt->genc)
    {
        if (c_scope != NULL)
            yyerror("Function declaration not allowed in a struct in a C module");

        if (isstatic)
            yyerror("Static functions not allowed in a C module");

        if (exceptions != NULL)
            yyerror("Exceptions not allowed in a C module");
    }

    if (mt_scope != NULL)
        headp = &mt_scope->overs;
    else if (c_scope != NULL)
        headp = &c_scope->overs;
    else
        headp = &mod->overs;

    /*
     * See if the function has a non-lazy method.  These are methods that
     * Python expects to see defined in the type before any instance of the
     * type is created.
     */
    if (c_scope != NULL)
    {
        static const char *lazy[] = {
            "__getattribute__",
            "__getattr__",
            "__enter__",
            "__exit__",
            NULL
        };

        const char **l;

        for (l = lazy; *l != NULL; ++l)
            if (strcmp(name, *l) == 0)
            {
                setHasNonlazyMethod(c_scope);
                break;
            }
    }

    /* See if it is a factory method. */
    if (getOptFlag(optflgs, "Factory", bool_flag) != NULL)
        factory = TRUE;
    else
    {
        int a;

        factory = FALSE;

        /* Check /TransferThis/ wasn't specified. */
        if (c_scope == NULL || isstatic)
            for (a = 0; a < sig->nrArgs; ++a)
                if (isThisTransferred(&sig->args[a]))
                    yyerror("/TransferThis/ may only be specified in constructors and class methods");
    }

    /* See if the result is to be returned to Python ownership. */
    xferback = (getOptFlag(optflgs, "TransferBack", bool_flag) != NULL);

    if (factory && xferback)
        yyerror("/TransferBack/ and /Factory/ cannot both be specified");

    /* Create a new overload definition. */

    od = sipMalloc(sizeof (overDef));

    /* Set the overload flags. */

    if ((sflags & SECT_IS_PROT) && makeProtPublic)
    {
        sflags &= ~SECT_IS_PROT;
        sflags |= SECT_IS_PUBLIC | OVER_REALLY_PROT;
    }

    od->overflags = sflags;

    if (issignal)
    {
        resetIsSlot(od);
        setIsSignal(od);
    }
    else if (isslot)
    {
        resetIsSignal(od);
        setIsSlot(od);
    }

    if (factory)
        setIsFactory(od);

    if (xferback)
        setIsResultTransferredBack(od);

    if (getTransfer(optflgs))
        setIsResultTransferred(od);

    if (getOptFlag(optflgs, "TransferThis", bool_flag) != NULL)
        setIsThisTransferredMeth(od);

    if (methodcode == NULL && getOptFlag(optflgs, "RaisesPyException", bool_flag) != NULL)
        setRaisesPyException(od);

    if (isProtected(od))
        setHasShadow(c_scope);

    if ((isSlot(od) || isSignal(od)) && !isPrivate(od))
    {
        if (isSignal(od))
            setHasShadow(c_scope);

        pt->sigslots = TRUE;
    }

    if (isSignal(od) && (methodcode != NULL || vcode != NULL))
        yyerror("Cannot provide code for signals");

    if (isstatic)
    {
        if (isSignal(od))
            yyerror("Static functions cannot be signals");

        if (isvirt)
            yyerror("Static functions cannot be virtual");

        setIsStatic(od);
    }

    if (isconst)
        setIsConst(od);

    if (isabstract)
    {
        if (sflags == 0)
            yyerror("Non-class function specified as abstract");

        setIsAbstract(od);
    }

    if ((of = getOptFlag(optflgs, "AutoGen", opt_name_flag)) != NULL)
    {
        if (of->fvalue.sval == NULL || isEnabledFeature(of->fvalue.sval))
            setIsAutoGen(od);
    }

    of = getOptFlag(optflgs,"VirtualErrorHandler",opt_name_flag);
    od->virterrorhandler = 0;

    if (isvirt)
    {
        if (isSignal(od) && pluginPyQt3(pt))
            yyerror("Virtual signals aren't supported");

        setIsVirtual(od);
        setHasShadow(c_scope);

        vhd = sipMalloc(sizeof (virtHandlerDef));

        vhd->virthandlernr = -1;
        vhd->vhflags = 0;
        vhd->pysig = &od->pysig;
        vhd->cppsig = (cppsig != NULL ? cppsig : &od->pysig);
        appendCodeBlock(&vhd->virtcode, vcode);
        od->virterrorhandler = ((of && of -> fvalue.sval) ? of -> fvalue.sval : 0);
 
        if( od->virterrorhandler ) {
            printf( "VirtualErrorHandler set to %s\n", od->virterrorhandler );
        }

        if (factory || xferback)
            setIsTransferVH(vhd);

        /*
         * Only add it to the module's virtual handlers if we are not in a
         * class template.
         */
        if (!currentIsTemplate)
        {
            vhd->module = mod;

            vhd->next = mod->virthandlers;
            mod->virthandlers = vhd;
        }

        if (of && !of -> fvalue.sval)
            yyerror("%VirtualErrorHandler annotation must provide the name of the handler");
    }
    else
    {
        if (vcode != NULL)
            yyerror("%VirtualCatcherCode provided for non-virtual function");

        if (of != NULL)
            yyerror("%VirtualErrorHandler provided for non-virtual function");

        vhd = NULL;
    }

    od->cppname = name;
    od->pysig = *sig;
    od->cppsig = (cppsig != NULL ? cppsig : &od->pysig);
    od->exceptions = exceptions;
    appendCodeBlock(&od->methodcode, methodcode);
    od->virthandler = vhd;

    no_arg_parser = (getOptFlag(optflgs, "NoArgParser", bool_flag) != NULL);

    if (no_arg_parser)
    {
        if (methodcode == NULL)
            yyerror("%MethodCode must be supplied if /NoArgParser/ is specified");
    }

    if (getOptFlag(optflgs, "NoCopy", bool_flag) != NULL)
        setNoCopy(&od->pysig.result);

    handleKeepReference(optflgs, &od->pysig.result, mod);

    pyname = getPythonName(mod, optflgs, name);

    od->common = findFunction(pt, mod, c_scope, mt_scope, pyname,
            (methodcode != NULL), sig->nrArgs, no_arg_parser);
    
    if (strcmp(pyname, "__delattr__") == 0)
        setIsDelattr(od);

    if (docstring != NULL)
        appendCodeBlock(&od->common->docstring, docstring);

    od->api_range = getAPIRange(optflgs);

    if (od->api_range == NULL)
        setNotVersioned(od->common);

    if (getOptFlag(optflgs, "Numeric", bool_flag) != NULL)
        setIsNumeric(od->common);

    /* Methods that run in new threads must be virtual. */
    if (getOptFlag(optflgs, "NewThread", bool_flag) != NULL)
    {
        argDef *res;

        if (!isvirt)
            yyerror("/NewThread/ may only be specified for virtual functions");

        /*
         * This is an arbitary limitation to make the code generator slightly
         * easier - laziness on my part.
         */
        res = &od->cppsig->result;

        if (res->atype != void_type || res->nrderefs != 0)
            yyerror("/NewThread/ may only be specified for void functions");

        setIsNewThread(od);
    }

    getHooks(optflgs, &od->prehook, &od->posthook);

    if (getReleaseGIL(optflgs))
        setIsReleaseGIL(od);
    else if (getHoldGIL(optflgs))
        setIsHoldGIL(od);

    if (getDeprecated(optflgs))
        setIsDeprecated(od);

    if (!isPrivate(od) && !isSignal(od) && (od->common->slot == no_slot || od->common->slot == call_slot))
    {
        od->kwargs = keywordArgs(mod, optflgs, &od->pysig, isProtected(od));

        if (od->kwargs != NoKwArgs)
            setUseKeywordArgs(od->common);
    }

    /* See if we want to auto-generate a __len__() method. */
    if (getOptFlag(optflgs, "__len__", bool_flag) != NULL)
    {
        overDef *len;

        len = sipMalloc(sizeof (overDef));

        len->cppname = "__len__";
        len->overflags = SECT_IS_PUBLIC;
        len->pysig.result.atype = ssize_type;
        len->pysig.nrArgs = 0;
        len->cppsig = &len->pysig;

        len->common = findFunction(pt, mod, c_scope, mt_scope, len->cppname,
                TRUE, 0, FALSE);

        if ((len->methodcode = od->methodcode) == NULL)
        {
            char *buf = sipStrdup("            sipRes = (SIP_SSIZE_T)sipCpp->");
            codeBlock *code;

            append(&buf, od->cppname);
            append(&buf, "();\n");

            code = sipMalloc(sizeof (codeBlock));

            code->frag = buf;
            code->filename = "Auto-generated";
            code->linenr = 1;

            appendCodeBlock(&len->methodcode, code);
        }

        len->next = NULL;

        od->next = len;
    }
    else
    {
        od->next = NULL;
    }

    /* Append to the list. */
    for (odp = headp; *odp != NULL; odp = &(*odp)->next)
        ;

    *odp = od;
}


/*
 * Return the Python name based on the C/C++ name and any /PyName/ annotation.
 */
static const char *getPythonName(moduleDef *mod, optFlags *optflgs,
        const char *cname)
{
    const char *pname;
    optFlag *of;
    autoPyNameDef *apnd;

    /* Use the explicit name if given. */
    if ((of = getOptFlag(optflgs, "PyName", name_flag)) != NULL)
        return of->fvalue.sval;

    /* Apply any automatic naming rules. */
    pname = cname;

    for (apnd = mod->autopyname; apnd != NULL; apnd = apnd->next)
    {
        size_t len = strlen(apnd->remove_leading);

        if (strncmp(pname, apnd->remove_leading, len) == 0)
            pname += len;
    }

    return pname;
}


/*
 * Cache a name in a module.  Entries in the cache are stored in order of
 * decreasing length.
 */
nameDef *cacheName(sipSpec *pt, const char *name)
{
    nameDef *nd, **ndp;
    size_t len;

    /* Allow callers to be lazy about checking if there is really a name. */
    if (name == NULL)
        return NULL;

    /* Skip entries that are too large. */
    ndp = &pt->namecache;
    len = strlen(name);

    while (*ndp != NULL && (*ndp)->len > len)
        ndp = &(*ndp)->next;

    /* Check entries that are the right length. */
    for (nd = *ndp; nd != NULL && nd->len == len; nd = nd->next)
        if (memcmp(nd->text, name, len) == 0)
            return nd;

    /* Create a new one. */
    nd = sipMalloc(sizeof (nameDef));

    nd->nameflags = 0;
    nd->text = name;
    nd->len = len;
    nd->next = *ndp;

    *ndp = nd;

    return nd;
}


/*
 * Find (or create) an overloaded function name.
 */
static memberDef *findFunction(sipSpec *pt, moduleDef *mod, classDef *c_scope,
        mappedTypeDef *mt_scope, const char *pname, int hwcode, int nrargs,
        int no_arg_parser)
{
    static struct slot_map {
        const char *name;   /* The slot name. */
        slotType type;      /* The corresponding type. */
        int needs_hwcode;   /* Set if handwritten code is required. */
        int nrargs;         /* Nr. of arguments. */
    } slot_table[] = {
        {"__str__", str_slot, TRUE, 0},
        {"__unicode__", unicode_slot, TRUE, 0},
        {"__int__", int_slot, FALSE, 0},
        {"__long__", long_slot, FALSE, 0},
        {"__float__", float_slot, FALSE, 0},
        {"__len__", len_slot, TRUE, 0},
        {"__contains__", contains_slot, TRUE, 1},
        {"__add__", add_slot, FALSE, 1},
        {"__sub__", sub_slot, FALSE, 1},
        {"__mul__", mul_slot, FALSE, 1},
        {"__div__", div_slot, FALSE, 1},
        {"__mod__", mod_slot, FALSE, 1},
        {"__floordiv__", floordiv_slot, TRUE, 1},
        {"__truediv__", truediv_slot, FALSE, 1},
        {"__and__", and_slot, FALSE, 1},
        {"__or__", or_slot, FALSE, 1},
        {"__xor__", xor_slot, FALSE, 1},
        {"__lshift__", lshift_slot, FALSE, 1},
        {"__rshift__", rshift_slot, FALSE, 1},
        {"__iadd__", iadd_slot, FALSE, 1},
        {"__isub__", isub_slot, FALSE, 1},
        {"__imul__", imul_slot, FALSE, 1},
        {"__idiv__", idiv_slot, FALSE, 1},
        {"__imod__", imod_slot, FALSE, 1},
        {"__ifloordiv__", ifloordiv_slot, TRUE, 1},
        {"__itruediv__", itruediv_slot, FALSE, 1},
        {"__iand__", iand_slot, FALSE, 1},
        {"__ior__", ior_slot, FALSE, 1},
        {"__ixor__", ixor_slot, FALSE, 1},
        {"__ilshift__", ilshift_slot, FALSE, 1},
        {"__irshift__", irshift_slot, FALSE, 1},
        {"__invert__", invert_slot, FALSE, 0},
        {"__call__", call_slot, FALSE, -1},
        {"__getitem__", getitem_slot, FALSE, 1},
        {"__setitem__", setitem_slot, TRUE, 2},
        {"__delitem__", delitem_slot, TRUE, 1},
        {"__lt__", lt_slot, FALSE, 1},
        {"__le__", le_slot, FALSE, 1},
        {"__eq__", eq_slot, FALSE, 1},
        {"__ne__", ne_slot, FALSE, 1},
        {"__gt__", gt_slot, FALSE, 1},
        {"__ge__", ge_slot, FALSE, 1},
        {"__cmp__", cmp_slot, FALSE, 1},
        {"__bool__", bool_slot, TRUE, 0},
        {"__nonzero__", bool_slot, TRUE, 0},
        {"__neg__", neg_slot, FALSE, 0},
        {"__pos__", pos_slot, FALSE, 0},
        {"__abs__", abs_slot, TRUE, 0},
        {"__repr__", repr_slot, TRUE, 0},
        {"__hash__", hash_slot, TRUE, 0},
        {"__index__", index_slot, TRUE, 0},
        {"__iter__", iter_slot, TRUE, 0},
        {"__next__", next_slot, TRUE, 0},
        {"__setattr__", setattr_slot, TRUE, 2},
        {"__delattr__", delattr_slot, TRUE, 1},
        {NULL}
    };

    memberDef *md, **flist;
    struct slot_map *sm;
    slotType st;

    /* Get the slot type. */
    st = no_slot;

    for (sm = slot_table; sm->name != NULL; ++sm)
        if (strcmp(sm->name, pname) == 0)
        {
            if (sm->needs_hwcode && !hwcode)
                yyerror("This Python slot requires %MethodCode");

            if (sm->nrargs >= 0)
            {
                if (mt_scope == NULL && c_scope == NULL)
                {
                    /* Global operators need one extra argument. */
                    if (sm -> nrargs + 1 != nrargs)
                        yyerror("Incorrect number of arguments to global operator");
                }
                else if (sm->nrargs != nrargs)
                    yyerror("Incorrect number of arguments to Python slot");
            }

            st = sm->type;

            break;
        }

    /* Check there is no name clash. */
    checkAttributes(pt, mod, c_scope, mt_scope, pname, TRUE);

    /* See if it already exists. */
    if (mt_scope != NULL)
        flist = &mt_scope->members;
    else if (c_scope != NULL)
        flist = &c_scope->members;
    else
        flist = &mod->othfuncs;

    /* __delattr__ is implemented as __setattr__. */
    if (st == delattr_slot)
    {
        if (inMainModule())
            setIsUsedName(cacheName(pt, pname));

        st = setattr_slot;
        pname = "__setattr__";
    }

    for (md = *flist; md != NULL; md = md->next)
        if (strcmp(md->pyname->text, pname) == 0 && md->module == mod)
            break;

    if (md == NULL)
    {
        /* Create a new one. */
        md = sipMalloc(sizeof (memberDef));

        md->pyname = cacheName(pt, pname);
        md->memberflags = 0;
        md->slot = st;
        md->module = mod;
        md->next = *flist;

        *flist = md;

        if (inMainModule())
            setIsUsedName(md->pyname);

        if (no_arg_parser)
            setNoArgParser(md);
    }
    else if (noArgParser(md))
        yyerror("Another overload has already been defined that is annotated as /NoArgParser/");

    /* Global operators are a subset. */
    if (mt_scope == NULL && c_scope == NULL && st != no_slot && st != neg_slot && st != pos_slot && !isNumberSlot(md) && !isInplaceNumberSlot(md) && !isRichCompareSlot(md))
        yyerror("Global operators must be either numeric or comparison operators");

    return md;
}


/*
 * Search a set of flags for a particular one.
 */
static optFlag *findOptFlag(optFlags *flgs, const char *name)
{
    int f;

    for (f = 0; f < flgs->nrFlags; ++f)
    {
        optFlag *of = &flgs->flags[f];

        if (strcmp(of->fname, name) == 0)
            return of;
    }

    return NULL;
}


/*
 * Search a set of flags for a particular one and check its type.
 */
static optFlag *getOptFlag(optFlags *flgs, const char *name, flagType ft)
{
    optFlag *of = findOptFlag(flgs, name);

    if (of != NULL)
    {
        /* An optional name can look like a boolean or a name. */
        if (ft == opt_name_flag)
        {
            if (of->ftype == bool_flag)
            {
                of->ftype = opt_name_flag;
                of->fvalue.sval = NULL;
            }
            else if (of->ftype == name_flag)
            {
                of->ftype = opt_name_flag;
            }
        }

        /* An optional integer can look like a boolean or an integer. */
        if (ft == opt_integer_flag)
        {
            if (of->ftype == bool_flag)
            {
                of->ftype = opt_integer_flag;
                of->fvalue.ival = -1;
            }
            else if (of->ftype == integer_flag)
            {
                of->ftype = opt_integer_flag;
            }
        }

        if (ft != of->ftype)
            yyerror("Annotation has a value of the wrong type");
    }

    return of;
}


/*
 * A name is going to be used as a Python attribute name within a Python scope
 * (ie. a Python dictionary), so check against what we already know is going in
 * the same scope in case there is a clash.
 */
static void checkAttributes(sipSpec *pt, moduleDef *mod, classDef *py_c_scope,
        mappedTypeDef *py_mt_scope, const char *attr, int isfunc)
{
    enumDef *ed;
    varDef *vd;
    classDef *cd;

    /* Check the enums. */

    for (ed = pt->enums; ed != NULL; ed = ed->next)
    {
        enumMemberDef *emd;

        if (ed->pyname == NULL)
            continue;

        if (py_c_scope != NULL)
        {
            if (ed->ecd != py_c_scope)
                continue;
        }
        else if (py_mt_scope != NULL)
        {
            if (ed->emtd != py_mt_scope)
                continue;
        }
        else if (ed->ecd != NULL || ed->emtd != NULL)
        {
            continue;
        }

        if (strcmp(ed->pyname->text, attr) == 0)
            yyerror("There is already an enum in scope with the same Python name");

        for (emd = ed->members; emd != NULL; emd = emd->next)
            if (strcmp(emd->pyname->text, attr) == 0)
                yyerror("There is already an enum member in scope with the same Python name");
    }

    /*
     * Only check the members if this attribute isn't a member because we
     * can handle members with the same name in the same scope.
     */
    if (!isfunc)
    {
        memberDef *md, *membs;
        overDef *overs;

        if (py_mt_scope != NULL)
        {
            membs = py_mt_scope->members;
            overs = py_mt_scope->overs;
        }
        else if (py_c_scope != NULL)
        {
            membs = py_c_scope->members;
            overs = py_c_scope->overs;
        }
        else
        {
            membs = mod->othfuncs;
            overs = mod->overs;
        }

        for (md = membs; md != NULL; md = md->next)
        {
            overDef *od;

            if (strcmp(md->pyname->text, attr) != 0)
                continue;

            /* Check for a conflict with all overloads. */
            for (od = overs; od != NULL; od = od->next)
            {
                if (od->common != md)
                    continue;

                yyerror("There is already a function in scope with the same Python name");
            }
        }
    }

    /* If the scope was a mapped type then that's all we have to check. */
    if (py_mt_scope != NULL)
        return;

    /* Check the variables. */
    for (vd = pt->vars; vd != NULL; vd = vd->next)
    {
        if (vd->ecd != py_c_scope)
            continue;

        if (strcmp(vd->pyname->text,attr) == 0)
            yyerror("There is already a variable in scope with the same Python name");
    }

    /* Check the classes. */
    for (cd = pt->classes; cd != NULL; cd = cd->next)
    {
        if (cd->ecd != py_c_scope || cd->pyname == NULL)
            continue;

        if (strcmp(cd->pyname->text, attr) == 0 && !isExternal(cd))
            yyerror("There is already a class or namespace in scope with the same Python name");
    }

    /* Check the exceptions. */
    if (py_c_scope == NULL)
    {
        exceptionDef *xd;

        for (xd = pt->exceptions; xd != NULL; xd = xd->next)
            if (xd->pyname != NULL && strcmp(xd->pyname, attr) == 0)
                yyerror("There is already an exception with the same Python name");
    }

    /* Check the properties. */
    if (py_c_scope != NULL)
    {
        propertyDef *pd;

        for (pd = py_c_scope->properties; pd != NULL; pd = pd->next)
            if (strcmp(pd->name->text, attr) == 0)
                yyerror("There is already a property with the same name");
    }
}


/*
 * Append a code block to a list of them.
 */
static void appendCodeBlock(codeBlockList **headp, codeBlock *cb)
{
    codeBlockList *cbl;

    /* Handle the trivial case. */
    if (cb == NULL)
        return;

    /* Find the end of the list. */
    while (*headp != NULL)
    {
        /* Ignore if the block is already in the list. */
        if ((*headp)->block == cb)
            return;

        headp = &(*headp)->next;
    }

    cbl = sipMalloc(sizeof (codeBlockList));
    cbl->block = cb;

    *headp = cbl;
}


/*
 * Append a code block list to an existing list.
 */
void appendCodeBlockList(codeBlockList **headp, codeBlockList *cbl)
{
    while (cbl != NULL)
    {
        appendCodeBlock(headp, cbl->block);
        cbl = cbl->next;
    }
}


/*
 * Handle the end of a fully parsed a file.
 */
static void handleEOF()
{
    /*
     * Check that the number of nested if's is the same as when we started
     * the file.
     */

    if (skipStackPtr > currentContext.ifdepth)
        fatal("Too many %%If statements in %s\n", previousFile);

    if (skipStackPtr < currentContext.ifdepth)
        fatal("Too many %%End statements in %s\n", previousFile);
}


/*
 * Handle the end of a fully parsed a module.
 */
static void handleEOM()
{
    moduleDef *from;

    /* Check it has been named. */
    if (currentModule->name == NULL)
        fatal("No %%Module has been specified for module defined in %s\n",
                previousFile);

    from = currentContext.prevmod;

    if (from != NULL && from->encoding == no_type)
        from->encoding = currentModule->encoding;

    /* The previous module is now current. */
    currentModule = from;
}


/*
 * Find an existing qualifier.
 */
static qualDef *findQualifier(const char *name)
{
    moduleDef *mod;

    for (mod = currentSpec->modules; mod != NULL; mod = mod->next)
    {
        qualDef *qd;

        for (qd = mod->qualifiers; qd != NULL; qd = qd->next)
            if (strcmp(qd->name, name) == 0)
                return qd;
    }

    /* Qualifiers corresponding to the SIP version are created on the fly. */
    if (name[0] == 'S' && name[1] == 'I' && name[2] == 'P' && name[3] == '_')
    {
        const char *cp = &name[3];
        int major, minor, patch;

        cp = getInt(cp, &major);
        cp = getInt(cp, &minor);
        cp = getInt(cp, &patch);

        if (*cp != '\0')
            yyerror("Unexpected character after SIP version number");

        return allocQualifier(currentModule, -1,
                (major << 16) | (minor << 8) | patch, name, time_qualifier);
    }

    return NULL;
}


/*
 * Get an integer from string.
 */
static const char *getInt(const char *cp, int *ip)
{
    /* Handle the default value. */
    *ip = 0;

    if (*cp == '\0')
        return cp;

    /* There must be a leading underscore. */
    if (*cp++ != '_')
        yyerror("An underscore must separate the parts of a SIP version number");

    while (isdigit(*cp))
    {
        *ip *= 10;
        *ip += *cp - '0';
        ++cp;
    }

    return cp;
}


/*
 * Find an existing API.
 */
apiVersionRangeDef *findAPI(sipSpec *pt, const char *name)
{
    moduleDef *mod;

    for (mod = pt->modules; mod != NULL; mod = mod->next)
    {
        apiVersionRangeDef *avd;

        for (avd = mod->api_versions; avd != NULL; avd = avd->next)
            if (strcmp(avd->api_name->text, name) == 0)
                return avd;
    }

    return NULL;
}


/*
 * Return a copy of a scoped name.
 */
scopedNameDef *copyScopedName(scopedNameDef *snd)
{
    scopedNameDef *head;

    head = NULL;

    while (snd != NULL)
    {
        appendScopedName(&head,text2scopePart(snd -> name));
        snd = snd -> next;
    }

    return head;
}


/*
 * Append a name to a list of scopes.
 */
void appendScopedName(scopedNameDef **headp,scopedNameDef *newsnd)
{
    while (*headp != NULL)
        headp = &(*headp) -> next;

    *headp = newsnd;
}


/*
 * Free a scoped name - but not the text itself.
 */
void freeScopedName(scopedNameDef *snd)
{
    while (snd != NULL)
    {
        scopedNameDef *next = snd -> next;

        free(snd);

        snd = next;
    }
}


/*
 * Convert a text string to a scope part structure.
 */
static scopedNameDef *text2scopePart(char *text)
{
    scopedNameDef *snd;

    snd = sipMalloc(sizeof (scopedNameDef));

    snd->name = text;
    snd->next = NULL;

    return snd;
}


/*
 * Convert a text string to a fully scoped name.
 */
static scopedNameDef *text2scopedName(ifaceFileDef *scope, char *text)
{
    return scopeScopedName(scope, text2scopePart(text));
}


/*
 * Prepend any current scope to a scoped name.
 */
static scopedNameDef *scopeScopedName(ifaceFileDef *scope, scopedNameDef *name)
{
    scopedNameDef *snd;

    snd = (scope != NULL ? copyScopedName(scope->fqcname) : NULL);

    appendScopedName(&snd, name);

    return snd;
}


/*
 * Return a pointer to the tail part of a scoped name.
 */
char *scopedNameTail(scopedNameDef *snd)
{
    if (snd == NULL)
        return NULL;

    while (snd -> next != NULL)
        snd = snd -> next;

    return snd -> name;
}


/*
 * Push the given scope onto the scope stack.
 */
static void pushScope(classDef *scope)
{
    if (currentScopeIdx >= MAX_NESTED_SCOPE)
        fatal("Internal error: increase the value of MAX_NESTED_SCOPE\n");

    scopeStack[currentScopeIdx] = scope;
    sectFlagsStack[currentScopeIdx] = sectionFlags;

    ++currentScopeIdx;
}


/*
 * Pop the scope stack.
 */
static void popScope(void)
{
    if (currentScopeIdx > 0)
        sectionFlags = sectFlagsStack[--currentScopeIdx];
}


/*
 * Return non-zero if the current input should be parsed rather than be
 * skipped.
 */
static int notSkipping()
{
    return (skipStackPtr == 0 ? TRUE : skipStack[skipStackPtr - 1]);
}


/*
 * Return the value of an expression involving a time period.
 */
static int timePeriod(const char *lname, const char *uname)
{
    int this, line;
    qualDef *qd, *lower, *upper;
    moduleDef *mod;

    if (lname == NULL)
        lower = NULL;
    else if ((lower = findQualifier(lname)) == NULL || lower->qtype != time_qualifier)
        yyerror("Lower bound is not a time version");

    if (uname == NULL)
        upper = NULL;
    else if ((upper = findQualifier(uname)) == NULL || upper->qtype != time_qualifier)
        yyerror("Upper bound is not a time version");

    /* Sanity checks on the bounds. */
    if (lower == NULL && upper == NULL)
        yyerror("Lower and upper bounds cannot both be omitted");

    if (lower != NULL && upper != NULL)
    {
        if (lower->module != upper->module || lower->line != upper->line)
            yyerror("Lower and upper bounds are from different timelines");

        if (lower == upper)
            yyerror("Lower and upper bounds must be different");

        if (lower->order > upper->order)
            yyerror("Later version specified as lower bound");
    }

    /* Go through each slot in the relevant timeline. */
    if (lower != NULL)
    {
        mod = lower->module;
        line = lower->line;
    }
    else
    {
        mod = upper->module;
        line = upper->line;
    }

    /* Handle the SIP version number pseudo-timeline. */
    if (line < 0)
    {
        if (lower != NULL && lower->order > SIP_VERSION)
            return FALSE;

        if (upper != NULL && upper->order <= SIP_VERSION)
            return FALSE;

        return TRUE;
    }

    this = FALSE;

    for (qd = mod->qualifiers; qd != NULL; qd = qd->next)
    {
        if (qd->qtype != time_qualifier || qd->line != line)
            continue;

        if (lower != NULL && qd->order < lower->order)
            continue;

        if (upper != NULL && qd->order >= upper->order)
            continue;

        /*
         * This is within the required range so if it is also needed then the
         * expression is true.
         */
        if (isNeeded(qd))
        {
            this = TRUE;
            break;
        }
    }

    return this;
}


/*
 * Return the value of an expression involving a single platform or feature.
 */
static int platOrFeature(char *name,int optnot)
{
    int this;
    qualDef *qd;

    if ((qd = findQualifier(name)) == NULL || qd -> qtype == time_qualifier)
        yyerror("No such platform or feature");

    /* Assume this sub-expression is false. */

    this = FALSE;

    if (qd -> qtype == feature_qualifier)
    {
        if (!excludedFeature(excludedQualifiers,qd))
            this = TRUE;
    }
    else if (isNeeded(qd))
        this = TRUE;

    if (optnot)
        this = !this;

    return this;
}


/*
 * Return TRUE if the given qualifier is excluded.
 */
int excludedFeature(stringList *xsl,qualDef *qd)
{
    while (xsl != NULL)
    {
        if (strcmp(qd -> name,xsl -> s) == 0)
            return TRUE;

        xsl = xsl -> next;
    }

    return FALSE;
}


/*
 * Return TRUE if the given qualifier is needed.
 */
static int isNeeded(qualDef *qd)
{
    stringList *sl;

    for (sl = neededQualifiers; sl != NULL; sl = sl -> next)
        if (strcmp(qd -> name,sl -> s) == 0)
            return TRUE;

    return FALSE;
}


/*
 * Return the current scope.  currentScope() is only valid if notSkipping()
 * returns non-zero.
 */
static classDef *currentScope(void)
{
    return (currentScopeIdx > 0 ? scopeStack[currentScopeIdx - 1] : NULL);
}


/*
 * Create a new qualifier.
 */
static void newQualifier(moduleDef *mod, int line, int order, const char *name,
        qualType qt)
{
    /* Check it doesn't already exist. */
    if (findQualifier(name) != NULL)
        yyerror("Version is already defined");

    allocQualifier(mod, line, order, name, qt);
}


/*
 * Allocate a new qualifier.
 */
static qualDef *allocQualifier(moduleDef *mod, int line, int order,
        const char *name, qualType qt)
{
    qualDef *qd;

    qd = sipMalloc(sizeof (qualDef));

    qd->name = name;
    qd->qtype = qt;
    qd->module = mod;
    qd->line = line;
    qd->order = order;
    qd->next = mod->qualifiers;

    mod->qualifiers = qd;

    return qd;
}


/*
 * Create a new imported module.
 */
static void newImport(const char *filename)
{
    moduleDef *from, *mod;
    moduleListDef *mld;

    /* Create a new module if it has not already been defined. */
    for (mod = currentSpec->modules; mod != NULL; mod = mod->next)
        if (strcmp(mod->file, filename) == 0)
            break;

    from = currentModule;

    if (mod == NULL)
    {
        newModule(NULL, filename);
        mod = currentModule;
    }
    else if (from->encoding == no_type)
    {
        /* Import any defaults from the already parsed module. */
        from->encoding = mod->encoding;
    }

    /* Add the new import unless it has already been imported. */
    for (mld = from->imports; mld != NULL; mld = mld->next)
        if (mld->module == mod)
            return;

    mld = sipMalloc(sizeof (moduleListDef));
    mld->module = mod;
    mld->next = from->imports;

    from->imports = mld;
}


/*
 * Set up pointers to hook names.
 */
static void getHooks(optFlags *optflgs,char **pre,char **post)
{
    optFlag *of;

    if ((of = getOptFlag(optflgs,"PreHook",name_flag)) != NULL)
        *pre = of -> fvalue.sval;
    else
        *pre = NULL;

    if ((of = getOptFlag(optflgs,"PostHook",name_flag)) != NULL)
        *post = of -> fvalue.sval;
    else
        *post = NULL;
}


/*
 * Get the /Transfer/ option flag.
 */
static int getTransfer(optFlags *optflgs)
{
    return (getOptFlag(optflgs, "Transfer", bool_flag) != NULL);
}


/*
 * Get the /ReleaseGIL/ option flag.
 */
static int getReleaseGIL(optFlags *optflgs)
{
    return (getOptFlag(optflgs, "ReleaseGIL", bool_flag) != NULL);
}


/*
 * Get the /HoldGIL/ option flag.
 */
static int getHoldGIL(optFlags *optflgs)
{
    return (getOptFlag(optflgs, "HoldGIL", bool_flag) != NULL);
}


/*
 * Get the /Deprecated/ option flag.
 */
static int getDeprecated(optFlags *optflgs)
{
    return (getOptFlag(optflgs, "Deprecated", bool_flag) != NULL);
}


/*
 * Get the /AllowNone/ option flag.
 */
static int getAllowNone(optFlags *optflgs)
{
    return (getOptFlag(optflgs, "AllowNone", bool_flag) != NULL);
}


/*
 * Get the /DocType/ option flag.
 */
static const char *getDocType(optFlags *optflgs)
{
    optFlag *of = getOptFlag(optflgs, "DocType", string_flag);

    if (of == NULL)
        return NULL;

    return of->fvalue.sval;
}


/*
 * Get the /DocValue/ option flag.
 */
static const char *getDocValue(optFlags *optflgs)
{
    optFlag *of = getOptFlag(optflgs, "DocValue", string_flag);

    if (of == NULL)
        return NULL;

    return of->fvalue.sval;
}


/*
 * Return TRUE if the PyQt3 plugin was specified.
 */
int pluginPyQt3(sipSpec *pt)
{
    return stringFind(pt->plugins, "PyQt3");
}


/*
 * Return TRUE if the PyQt4 plugin was specified.
 */
int pluginPyQt4(sipSpec *pt)
{
    return stringFind(pt->plugins, "PyQt4");
}


/*
 * Return TRUE if a list of strings contains a given entry.
 */
static int stringFind(stringList *sl, const char *s)
{
    while (sl != NULL)
    {
        if (strcmp(sl->s, s) == 0)
            return TRUE;

        sl = sl->next;
    }

    return FALSE;
}


/*
 * Set the name of a module.
 */
static void setModuleName(sipSpec *pt, moduleDef *mod, const char *fullname)
{
    mod->fullname = cacheName(pt, fullname);

    if (inMainModule())
        setIsUsedName(mod->fullname);

    if ((mod->name = strrchr(fullname, '.')) != NULL)
        mod->name++;
    else
        mod->name = fullname;
}


/*
 * Define a new class and set its name.
 */
static void defineClass(scopedNameDef *snd, classList *supers, optFlags *of)
{
    classDef *cd, *c_scope = currentScope();

    cd = newClass(currentSpec, class_iface, getAPIRange(of),
            scopeScopedName((c_scope != NULL ? c_scope->iff : NULL), snd));
    cd->supers = supers;

    pushScope(cd);
}


/*
 * Complete the definition of a class.
 */
static classDef *completeClass(scopedNameDef *snd, optFlags *of, int has_def)
{
    classDef *cd = currentScope();

    /* See if the class was defined or just declared. */
    if (has_def)
    {
        if (snd->next != NULL)
            yyerror("A scoped name cannot be given in a class/struct definition");

    }
    else if (cd->supers != NULL)
        yyerror("Class/struct has super-classes but no definition");
    else
        setIsOpaque(cd);

    finishClass(currentSpec, currentModule, cd, of);
    popScope();

    /*
     * Check that external classes have only been declared at the global scope.
     */
    if (isExternal(cd) && currentScope() != NULL)
        yyerror("External classes/structs can only be declared in the global scope");

    return cd;
}


/*
 * Add a variable to the list so that the list remains sorted.
 */
static void addVariable(sipSpec *pt, varDef *vd)
{
    varDef **at = &pt->vars;

    while (*at != NULL)
    {
        if (strcmp(vd->pyname->text, (*at)->pyname->text) < 0)
            break;

        at = &(*at)->next;
    }

    vd->next = *at;
    *at = vd;
}


/*
 * Update a type according to optional flags.
 */
static void applyTypeFlags(moduleDef *mod, argDef *ad, optFlags *flags)
{
    ad->doctype = getDocType(flags);

    if (getOptFlag(flags, "PyInt", bool_flag) != NULL)
    {
        if (ad->atype == string_type)
            ad->atype = byte_type;
        else if (ad->atype == sstring_type)
            ad->atype = sbyte_type;
        else if (ad->atype == ustring_type)
            ad->atype = ubyte_type;
    }

    if (ad->atype == string_type && !isArray(ad) && !isReference(ad))
    {
        optFlag *of;

        if ((of = getOptFlag(flags, "Encoding", string_flag)) == NULL)
        {
            if (mod->encoding != no_type)
                ad->atype = mod->encoding;
            else
                ad->atype = string_type;
        }
        else if ((ad->atype = convertEncoding(of->fvalue.sval)) == no_type)
            yyerror("The value of the /Encoding/ annotation must be one of \"ASCII\", \"Latin-1\", \"UTF-8\" or \"None\"");
    }
}


/*
 * Return the keyword argument support converted from a string.
 */
static KwArgs convertKwArgs(const char *kwargs)
{
    if (strcmp(kwargs, "None") == 0)
        return NoKwArgs;

    if (strcmp(kwargs, "All") == 0)
        return AllKwArgs;

    if (strcmp(kwargs, "Optional") == 0)
        return OptionalKwArgs;

    yyerror("The style of keyword argument support must be one of \"All\", \"Optional\" or \"None\"");
}


/*
 * Return the argument type for a string with the given encoding or no_type if
 * the encoding was invalid.
 */
static argType convertEncoding(const char *encoding)
{
    if (strcmp(encoding, "ASCII") == 0)
        return ascii_string_type;

    if (strcmp(encoding, "Latin-1") == 0)
        return latin1_string_type;

    if (strcmp(encoding, "UTF-8") == 0)
        return utf8_string_type;

    if (strcmp(encoding, "None") == 0)
        return string_type;

    return no_type;
}


/*
 * Get the /API/ option flag.
 */
static apiVersionRangeDef *getAPIRange(optFlags *optflgs)
{
    optFlag *of;

    if ((of = getOptFlag(optflgs, "API", api_range_flag)) == NULL)
        return NULL;

    return of->fvalue.aval;
}


/*
 * Return the API range structure and version number corresponding to the
 * given API range.
 */
static apiVersionRangeDef *convertAPIRange(moduleDef *mod, nameDef *name,
        int from, int to)
{
    int index;
    apiVersionRangeDef *avd, **avdp;

    /* Handle the trivial case. */
    if (from == 0 && to == 0)
        return NULL;

    for (index = 0, avdp = &mod->api_ranges; (*avdp) != NULL; avdp = &(*avdp)->next, ++index)
    {
        avd = *avdp;

        if (avd->api_name == name && avd->from == from && avd->to == to)
            return avd;
    }

    /* The new one must be appended so that version numbers remain valid. */
    avd = sipMalloc(sizeof (apiVersionRangeDef));

    avd->api_name = name;
    avd->from = from;
    avd->to = to;
    avd->index = index;

    avd->next = NULL;
    *avdp = avd;

    return avd;
}


/*
 * Return the style of keyword argument support for a signature.
 */
static KwArgs keywordArgs(moduleDef *mod, optFlags *optflgs, signatureDef *sd,
        int need_name)
{
    KwArgs kwargs;
    optFlag *ka_anno, *no_ka_anno;

    /* Get the default. */
    kwargs = mod->kwargs;

    /*
     * Get the possible annotations allowing /KeywordArgs/ to have different
     * types of values.
     */
    ka_anno = findOptFlag(optflgs, "KeywordArgs");
    no_ka_anno = getOptFlag(optflgs, "NoKeywordArgs", bool_flag);

    if (no_ka_anno != NULL)
    {
        if (ka_anno != NULL)
            yyerror("/KeywordArgs/ and /NoKeywordArgs/ cannot both be specified");

        deprecated("/NoKeywordArgs/ is deprecated, use /KeywordArgs=\"None\" instead");

        kwargs = NoKwArgs;
    }
    else if (ka_anno != NULL)
    {
        /* A string value is the non-deprecated type. */
        if (ka_anno->ftype == string_flag)
        {
            kwargs = convertKwArgs(ka_anno->fvalue.sval);
        }
        else
        {
            deprecated("/KeywordArgs/ is deprecated, use /KeywordArgs=\"All\" instead");

            /* Get it again to check the type. */
            ka_anno = getOptFlag(optflgs, "KeywordArgs", bool_flag);
        }
    }

    /* An ellipsis cannot be used with keyword arguments. */
    if (sd->nrArgs > 0 && sd->args[sd->nrArgs - 1].atype == ellipsis_type)
        kwargs = NoKwArgs;

    if (kwargs != NoKwArgs)
    {
        int a, is_name = FALSE;

        /*
         * Mark argument names as being used and check there is at least one.
         */
        for (a = 0; a < sd->nrArgs; ++a)
        {
            argDef *ad = &sd->args[a];

            if (kwargs == OptionalKwArgs && ad->defval == NULL)
                continue;

            if (ad->name != NULL)
            {
                if (need_name || inMainModule())
                    setIsUsedName(ad->name);

                is_name = TRUE;
            }
        }

        if (!is_name)
            kwargs = NoKwArgs;
    }

    return kwargs;
}


/*
 * Extract the version of a string value optionally associated with a
 * particular feature.
 */
static char *convertFeaturedString(char *fs)
{
    while (fs != NULL)
    {
        char *next, *value;

        /* Individual values are ';' separated. */
        if ((next = strchr(fs, ';')) != NULL)
            *next++ = '\0';

        /* Features and values are ':' separated. */
        if ((value = strchr(fs, ':')) == NULL)
        {
            /* This is an unconditional value so just return it. */
            return strip(fs);
        }

        *value++ = '\0';

        if (isEnabledFeature(strip(fs)))
            return strip(value);

        fs = next;
    }

    /* No value was enabled. */
    return NULL;
}


/*
 * Return the stripped version of a string.
 */
static char *strip(char *s)
{
    while (*s == ' ')
        ++s;

    if (*s != '\0')
    {
        char *cp = &s[strlen(s) - 1];

        while (*cp == ' ')
            *cp-- = '\0';
    }

    return s;
}


/*
 * Return TRUE if the given feature is enabled.
 */
static int isEnabledFeature(const char *name)
{
    qualDef *qd;

    if ((qd = findQualifier(name)) == NULL || qd->qtype != feature_qualifier)
        yyerror("No such feature");

    return !excludedFeature(excludedQualifiers, qd);
}


/*
 * Add a property definition to a class.
 */
static void addProperty(sipSpec *pt, moduleDef *mod, classDef *cd,
        const char *name, const char *get, const char *set,
        codeBlock *docstring)
{
    propertyDef *pd;

    checkAttributes(pt, mod, cd, NULL, name, FALSE);

    pd = sipMalloc(sizeof (propertyDef));

    pd->name = cacheName(pt, name);
    pd->get = get;
    pd->set = set;
    appendCodeBlock(&pd->docstring, docstring);
    pd->next = cd->properties;

    cd->properties = pd;

    if (inMainModule())
        setIsUsedName(pd->name);
}


/*
 * Configure a module and return the (possibly new) current module.
 */
static moduleDef *configureModule(sipSpec *pt, moduleDef *module,
        const char *filename, const char *name, int version, int c_module,
        KwArgs kwargs, int use_arg_names, codeBlock *docstring)
{
    moduleDef *mod;

    /* Check the module hasn't already been defined. */
    for (mod = pt->modules; mod != NULL; mod = mod->next)
        if (mod->fullname != NULL && strcmp(mod->fullname->text, name) == 0)
            yyerror("Module is already defined");

    /*
     * If we are in a container module then create a component module and make
     * it current.
     */
    if (isContainer(module) || module->container != NULL)
    {
        mod = allocModule();

        mod->file = filename;
        mod->container = (isContainer(module) ? module : module->container);

        module = mod;
    }

    setModuleName(pt, module, name);
    module->kwargs = kwargs;
    module->version = version;
    appendCodeBlock(&module->docstring, docstring);

    if (use_arg_names)
        setUseArgNames(module);

    if (pt->genc < 0)
        pt->genc = c_module;
    else if (pt->genc != c_module)
        yyerror("Cannot mix C and C++ modules");

    return module;
}


/*
 * Add a Python naming rule to a module.
 */
static void addAutoPyName(moduleDef *mod, const char *remove_leading)
{
    autoPyNameDef *apnd, **apndp;

    for (apndp = &mod->autopyname; *apndp != NULL; apndp = &(*apndp)->next)
        ;

    apnd = sipMalloc(sizeof (autoPyNameDef));
    apnd->remove_leading = remove_leading;
    apnd->next = *apndp;

    *apndp = apnd;
}


/*
 * Check that no invalid or unknown annotations are given.
 */
static void checkAnnos(optFlags *annos, const char *valid[])
{
    if (parsingCSignature && annos->nrFlags != 0)
    {
        deprecated("Annotations should not be used in explicit C/C++ signatures");
    }
    else
    {
        int i;

        for (i = 0; i < annos->nrFlags; i++)
        {
            const char **name;

            for (name = valid; *name != NULL; ++name)
                if (strcmp(*name, annos->flags[i].fname) == 0)
                    break;

            if (*name == NULL)
                deprecated("Annotation is invalid");
        }
    }
}


/*
 * Check that no annotations were given.
 */
static void checkNoAnnos(optFlags *annos, const char *msg)
{
    if (annos->nrFlags != 0)
        deprecated(msg);
}


/*
 * Handle any /KeepReference/ annotation for a type.
 */
static void handleKeepReference(optFlags *optflgs, argDef *ad, moduleDef *mod)
{
    optFlag *of;

    if ((of = getOptFlag(optflgs, "KeepReference", opt_integer_flag)) != NULL)
    {
        setKeepReference(ad);

        if ((ad->key = of->fvalue.ival) < -1)
            yyerror("/KeepReference/ key cannot be negative");

        /* If there was no explicit key then auto-allocate one. */
        if (ad->key == -1)
            ad->key = mod->next_key--;
    }
}

