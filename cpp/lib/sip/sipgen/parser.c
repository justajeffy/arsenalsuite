/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton implementation for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

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
#define YYBISON_VERSION "2.3"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Using locations.  */
#define YYLSP_NEEDED 0



/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     TK_API = 258,
     TK_DEFENCODING = 259,
     TK_PLUGIN = 260,
     TK_DOC = 261,
     TK_EXPORTEDDOC = 262,
     TK_MAKEFILE = 263,
     TK_ACCESSCODE = 264,
     TK_GETCODE = 265,
     TK_SETCODE = 266,
     TK_PREINITCODE = 267,
     TK_INITCODE = 268,
     TK_POSTINITCODE = 269,
     TK_UNITCODE = 270,
     TK_MODCODE = 271,
     TK_TYPECODE = 272,
     TK_PREPYCODE = 273,
     TK_COPYING = 274,
     TK_MAPPEDTYPE = 275,
     TK_CODELINE = 276,
     TK_IF = 277,
     TK_END = 278,
     TK_NAME = 279,
     TK_PATHNAME = 280,
     TK_STRING = 281,
     TK_VIRTUALCATCHERCODE = 282,
     TK_VIRTERRORHANDLER = 283,
     TK_TRAVERSECODE = 284,
     TK_CLEARCODE = 285,
     TK_GETBUFFERCODE = 286,
     TK_RELEASEBUFFERCODE = 287,
     TK_READBUFFERCODE = 288,
     TK_WRITEBUFFERCODE = 289,
     TK_SEGCOUNTCODE = 290,
     TK_CHARBUFFERCODE = 291,
     TK_PICKLECODE = 292,
     TK_METHODCODE = 293,
     TK_FROMTYPE = 294,
     TK_TOTYPE = 295,
     TK_TOSUBCLASS = 296,
     TK_INCLUDE = 297,
     TK_OPTINCLUDE = 298,
     TK_IMPORT = 299,
     TK_EXPHEADERCODE = 300,
     TK_MODHEADERCODE = 301,
     TK_TYPEHEADERCODE = 302,
     TK_MODULE = 303,
     TK_CMODULE = 304,
     TK_CONSMODULE = 305,
     TK_COMPOMODULE = 306,
     TK_CLASS = 307,
     TK_STRUCT = 308,
     TK_PUBLIC = 309,
     TK_PROTECTED = 310,
     TK_PRIVATE = 311,
     TK_SIGNALS = 312,
     TK_SLOTS = 313,
     TK_BOOL = 314,
     TK_SHORT = 315,
     TK_INT = 316,
     TK_LONG = 317,
     TK_FLOAT = 318,
     TK_DOUBLE = 319,
     TK_CHAR = 320,
     TK_WCHAR_T = 321,
     TK_VOID = 322,
     TK_PYOBJECT = 323,
     TK_PYTUPLE = 324,
     TK_PYLIST = 325,
     TK_PYDICT = 326,
     TK_PYCALLABLE = 327,
     TK_PYSLICE = 328,
     TK_PYTYPE = 329,
     TK_VIRTUAL = 330,
     TK_ENUM = 331,
     TK_SIGNED = 332,
     TK_UNSIGNED = 333,
     TK_SCOPE = 334,
     TK_LOGICAL_OR = 335,
     TK_CONST = 336,
     TK_STATIC = 337,
     TK_SIPSIGNAL = 338,
     TK_SIPSLOT = 339,
     TK_SIPANYSLOT = 340,
     TK_SIPRXCON = 341,
     TK_SIPRXDIS = 342,
     TK_SIPSLOTCON = 343,
     TK_SIPSLOTDIS = 344,
     TK_NUMBER = 345,
     TK_REAL = 346,
     TK_TYPEDEF = 347,
     TK_NAMESPACE = 348,
     TK_TIMELINE = 349,
     TK_PLATFORMS = 350,
     TK_FEATURE = 351,
     TK_LICENSE = 352,
     TK_QCHAR = 353,
     TK_TRUE = 354,
     TK_FALSE = 355,
     TK_NULL = 356,
     TK_OPERATOR = 357,
     TK_THROW = 358,
     TK_QOBJECT = 359,
     TK_EXCEPTION = 360,
     TK_RAISECODE = 361,
     TK_EXPLICIT = 362,
     TK_TEMPLATE = 363,
     TK_ELLIPSIS = 364,
     TK_DEFMETATYPE = 365,
     TK_DEFSUPERTYPE = 366
   };
#endif
/* Tokens.  */
#define TK_API 258
#define TK_DEFENCODING 259
#define TK_PLUGIN 260
#define TK_DOC 261
#define TK_EXPORTEDDOC 262
#define TK_MAKEFILE 263
#define TK_ACCESSCODE 264
#define TK_GETCODE 265
#define TK_SETCODE 266
#define TK_PREINITCODE 267
#define TK_INITCODE 268
#define TK_POSTINITCODE 269
#define TK_UNITCODE 270
#define TK_MODCODE 271
#define TK_TYPECODE 272
#define TK_PREPYCODE 273
#define TK_COPYING 274
#define TK_MAPPEDTYPE 275
#define TK_CODELINE 276
#define TK_IF 277
#define TK_END 278
#define TK_NAME 279
#define TK_PATHNAME 280
#define TK_STRING 281
#define TK_VIRTUALCATCHERCODE 282
#define TK_VIRTERRORHANDLER 283
#define TK_TRAVERSECODE 284
#define TK_CLEARCODE 285
#define TK_GETBUFFERCODE 286
#define TK_RELEASEBUFFERCODE 287
#define TK_READBUFFERCODE 288
#define TK_WRITEBUFFERCODE 289
#define TK_SEGCOUNTCODE 290
#define TK_CHARBUFFERCODE 291
#define TK_PICKLECODE 292
#define TK_METHODCODE 293
#define TK_FROMTYPE 294
#define TK_TOTYPE 295
#define TK_TOSUBCLASS 296
#define TK_INCLUDE 297
#define TK_OPTINCLUDE 298
#define TK_IMPORT 299
#define TK_EXPHEADERCODE 300
#define TK_MODHEADERCODE 301
#define TK_TYPEHEADERCODE 302
#define TK_MODULE 303
#define TK_CMODULE 304
#define TK_CONSMODULE 305
#define TK_COMPOMODULE 306
#define TK_CLASS 307
#define TK_STRUCT 308
#define TK_PUBLIC 309
#define TK_PROTECTED 310
#define TK_PRIVATE 311
#define TK_SIGNALS 312
#define TK_SLOTS 313
#define TK_BOOL 314
#define TK_SHORT 315
#define TK_INT 316
#define TK_LONG 317
#define TK_FLOAT 318
#define TK_DOUBLE 319
#define TK_CHAR 320
#define TK_WCHAR_T 321
#define TK_VOID 322
#define TK_PYOBJECT 323
#define TK_PYTUPLE 324
#define TK_PYLIST 325
#define TK_PYDICT 326
#define TK_PYCALLABLE 327
#define TK_PYSLICE 328
#define TK_PYTYPE 329
#define TK_VIRTUAL 330
#define TK_ENUM 331
#define TK_SIGNED 332
#define TK_UNSIGNED 333
#define TK_SCOPE 334
#define TK_LOGICAL_OR 335
#define TK_CONST 336
#define TK_STATIC 337
#define TK_SIPSIGNAL 338
#define TK_SIPSLOT 339
#define TK_SIPANYSLOT 340
#define TK_SIPRXCON 341
#define TK_SIPRXDIS 342
#define TK_SIPSLOTCON 343
#define TK_SIPSLOTDIS 344
#define TK_NUMBER 345
#define TK_REAL 346
#define TK_TYPEDEF 347
#define TK_NAMESPACE 348
#define TK_TIMELINE 349
#define TK_PLATFORMS 350
#define TK_FEATURE 351
#define TK_LICENSE 352
#define TK_QCHAR 353
#define TK_TRUE 354
#define TK_FALSE 355
#define TK_NULL 356
#define TK_OPERATOR 357
#define TK_THROW 358
#define TK_QOBJECT 359
#define TK_EXCEPTION 360
#define TK_RAISECODE 361
#define TK_EXPLICIT 362
#define TK_TEMPLATE 363
#define TK_ELLIPSIS 364
#define TK_DEFMETATYPE 365
#define TK_DEFSUPERTYPE 366




/* Copy the first part of user declarations.  */
#line 20 "parser.y"

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


static const char *getPythonName(optFlags *optflgs, const char *cname);
static classDef *findClass(sipSpec *pt, ifaceFileType iftype,
        apiVersionRangeDef *api_range, scopedNameDef *fqname);
static classDef *findClassWithInterface(sipSpec *pt, ifaceFileDef *iff);
static classDef *newClass(sipSpec *pt, ifaceFileType iftype,
        apiVersionRangeDef *api_range, scopedNameDef *snd);
static void finishClass(sipSpec *,moduleDef *,classDef *,optFlags *);
static exceptionDef *findException(sipSpec *pt, scopedNameDef *fqname, int new);
static mappedTypeDef *newMappedType(sipSpec *,argDef *, optFlags *);
static enumDef *newEnum(sipSpec *pt, moduleDef *mod, mappedTypeDef *mt_scope,
        char *name, optFlags *of, int flags);
static void instantiateClassTemplate(sipSpec *pt, moduleDef *mod, classDef *scope, scopedNameDef *fqname, classTmplDef *tcd, templateDef *td);
static void newTypedef(sipSpec *, moduleDef *, char *, argDef *, optFlags *);
static void newVar(sipSpec *, moduleDef *, char *, int, argDef *, optFlags *,
        codeBlock *, codeBlock *, codeBlock *);
static void newCtor(char *, int, signatureDef *, optFlags *, codeBlock *,
        throwArgs *, signatureDef *, int);
static void newFunction(sipSpec *, moduleDef *, classDef *, mappedTypeDef *,
        int, int, int, char *, signatureDef *, int, int, optFlags *,
        codeBlock *, codeBlock *, throwArgs *, signatureDef *);
static optFlag *findOptFlag(optFlags *,char *,flagType);
static memberDef *findFunction(sipSpec *, moduleDef *, classDef *,
        mappedTypeDef *, const char *, int, int, int);
static void checkAttributes(sipSpec *, moduleDef *, classDef *,
        mappedTypeDef *, const char *, int);
static void newModule(FILE *fp, char *filename);
static moduleDef *allocModule();
static void parseFile(FILE *fp, char *name, moduleDef *prevmod, int optional);
static void handleEOF(void);
static void handleEOM(void);
static qualDef *findQualifier(char *);
static nameDef *findAPI(sipSpec *pt, const char *name);
static scopedNameDef *text2scopedName(ifaceFileDef *scope, char *text);
static scopedNameDef *scopeScopedName(ifaceFileDef *scope,
        scopedNameDef *name);
static void pushScope(classDef *);
static void popScope(void);
static classDef *currentScope(void);
static void newQualifier(moduleDef *,int,int,char *,qualType);
static void newImport(char *filename);
static int timePeriod(char *,char *);
static int platOrFeature(char *,int);
static int isNeeded(qualDef *);
static int notSkipping(void);
static void getHooks(optFlags *,char **,char **);
static int getTransfer(optFlags *optflgs);
static int getReleaseGIL(optFlags *optflgs);
static int getHoldGIL(optFlags *optflgs);
static int getDeprecated(optFlags *optflgs);
static int getAllowNone(optFlags *optflgs);
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
static overDef *instantiateTemplateOverloads(sipSpec *pt, overDef *tod,
        memberDef *tmethods, memberDef *methods, classTmplDef *tcd,
        templateDef *td, classDef *cd, ifaceFileList **used,
        scopedNameDef *type_names, scopedNameDef *type_values);
static void resolveAnyTypedef(sipSpec *pt, argDef *ad);
static void addVariable(sipSpec *pt, varDef *vd);
static void applyTypeFlags(moduleDef *mod, argDef *ad, optFlags *flags);
static argType convertEncoding(const char *encoding);
static apiVersionRangeDef *getAPIRange(optFlags *optflgs);
static apiVersionRangeDef *convertAPIRange(moduleDef *mod, nameDef *name,
        int from, int to);
static scopedNameDef *text2scopePart(char *text);


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

#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 139 "parser.y"
{
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
}
/* Line 187 of yacc.c.  */
#line 458 "parser.c"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif



/* Copy the second part of user declarations.  */


/* Line 216 of yacc.c.  */
#line 471 "parser.c"

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
YYID (int i)
#else
static int
YYID (i)
    int i;
#endif
{
  return i;
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
  yytype_int16 yyss;
  YYSTYPE yyvs;
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
# define YYSTACK_RELOCATE(Stack)					\
    do									\
      {									\
	YYSIZE_T yynewbytes;						\
	YYCOPY (&yyptr->Stack, Stack, yysize);				\
	Stack = &yyptr->Stack;						\
	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
	yyptr += yynewbytes / sizeof (*yyptr);				\
      }									\
    while (YYID (0))

#endif

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  4
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   1151

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  134
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  147
/* YYNRULES -- Number of rules.  */
#define YYNRULES  365
/* YYNRULES -- Number of states.  */
#define YYNSTATES  625

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   366

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,   117,     2,     2,     2,   132,   124,     2,
     115,   116,   122,   121,   119,   118,     2,   123,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,   129,   114,
     127,   120,   128,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,   130,     2,   131,   133,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,   112,   125,   113,   126,     2,     2,     2,
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
     105,   106,   107,   108,   109,   110,   111
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
     101,   104,   108,   118,   119,   123,   126,   127,   133,   134,
     140,   145,   147,   150,   152,   155,   158,   160,   162,   175,
     176,   184,   186,   189,   190,   196,   198,   201,   203,   206,
     209,   210,   216,   218,   221,   223,   228,   230,   233,   237,
     242,   244,   248,   250,   253,   256,   259,   262,   265,   269,
     271,   273,   275,   277,   278,   280,   283,   286,   289,   290,
     293,   294,   297,   298,   301,   304,   307,   310,   313,   314,
     316,   319,   322,   325,   328,   331,   334,   337,   340,   343,
     346,   349,   352,   355,   358,   361,   364,   367,   370,   375,
     378,   380,   383,   384,   393,   394,   396,   397,   399,   400,
     402,   404,   407,   409,   411,   416,   417,   419,   420,   423,
     424,   427,   429,   433,   435,   437,   439,   441,   443,   445,
     446,   448,   450,   452,   454,   457,   459,   463,   465,   467,
     472,   474,   476,   478,   480,   482,   484,   486,   487,   489,
     493,   499,   511,   512,   513,   522,   523,   527,   532,   533,
     534,   543,   544,   547,   549,   553,   555,   556,   560,   562,
     565,   567,   569,   571,   573,   575,   577,   579,   581,   583,
     585,   587,   589,   591,   593,   595,   597,   599,   601,   603,
     605,   607,   609,   612,   615,   619,   623,   627,   630,   631,
     633,   645,   646,   650,   652,   662,   663,   669,   670,   677,
     678,   680,   694,   702,   717,   731,   733,   735,   737,   739,
     741,   743,   745,   747,   750,   753,   756,   759,   762,   765,
     768,   771,   774,   777,   781,   785,   787,   790,   793,   795,
     798,   801,   804,   806,   809,   810,   812,   813,   816,   817,
     821,   823,   827,   829,   833,   835,   841,   843,   845,   846,
     849,   850,   853,   855,   856,   858,   862,   867,   872,   877,
     881,   885,   892,   899,   903,   906,   907,   911,   913,   915,
     917,   918,   922,   924,   932,   937,   941,   945,   946,   948,
     949,   952,   954,   959,   962,   965,   967,   969,   972,   974,
     976,   979,   982,   986,   988,   990,   992,   995,   998,  1000,
    1002,  1004,  1006,  1008,  1010,  1012,  1014,  1016,  1018,  1020,
    1022,  1026,  1027,  1032,  1033,  1035
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int16 yyrhs[] =
{
     135,     0,    -1,   136,    -1,   135,   136,    -1,    -1,   137,
     138,    -1,   176,    -1,   174,    -1,   175,    -1,   141,    -1,
     186,    -1,   180,    -1,   181,    -1,   182,    -1,   142,    -1,
     163,    -1,   157,    -1,   162,    -1,   171,    -1,   140,    -1,
     172,    -1,   173,    -1,   187,    -1,   188,    -1,   200,    -1,
     202,    -1,   203,    -1,   204,    -1,   205,    -1,   206,    -1,
     207,    -1,   208,    -1,   209,    -1,   146,    -1,   148,    -1,
     139,    -1,   161,    -1,   167,    -1,   170,    -1,   154,    -1,
     231,    -1,   237,    -1,   234,    -1,   143,    -1,   230,    -1,
     212,    -1,   254,    -1,   272,    -1,   189,    -1,     4,    26,
      -1,     5,    24,    -1,     3,    24,    90,    -1,   105,   226,
     144,   258,   112,   190,   145,   113,   114,    -1,    -1,   115,
     226,   116,    -1,   106,   210,    -1,    -1,    20,   277,   258,
     147,   150,    -1,    -1,   236,    20,   277,   149,   150,    -1,
     112,   151,   113,   114,    -1,   152,    -1,   151,   152,    -1,
     189,    -1,    39,   210,    -1,    40,   210,    -1,   212,    -1,
     153,    -1,    82,   273,    24,   115,   264,   116,   256,   279,
     258,   252,   114,   262,    -1,    -1,    93,    24,   155,   112,
     156,   113,   114,    -1,   139,    -1,   156,   139,    -1,    -1,
      95,   158,   112,   159,   113,    -1,   160,    -1,   159,   160,
      -1,    24,    -1,    28,    24,    -1,    96,    24,    -1,    -1,
      94,   164,   112,   165,   113,    -1,   166,    -1,   165,   166,
      -1,    24,    -1,    22,   115,   169,   116,    -1,    24,    -1,
     117,    24,    -1,   168,    80,    24,    -1,   168,    80,   117,
      24,    -1,   168,    -1,   215,   118,   215,    -1,    23,    -1,
      97,   258,    -1,   110,   178,    -1,   111,   178,    -1,    50,
     178,    -1,    51,   178,    -1,   177,   178,   179,    -1,    48,
      -1,    49,    -1,    24,    -1,    25,    -1,    -1,    90,    -1,
      42,    25,    -1,    43,    25,    -1,    44,    25,    -1,    -1,
       9,   210,    -1,    -1,    10,   210,    -1,    -1,    11,   210,
      -1,    19,   210,    -1,    45,   210,    -1,    46,   210,    -1,
      47,   210,    -1,    -1,   189,    -1,    29,   210,    -1,    30,
     210,    -1,    31,   210,    -1,    32,   210,    -1,    33,   210,
      -1,    34,   210,    -1,    35,   210,    -1,    36,   210,    -1,
      37,   210,    -1,    16,   210,    -1,    17,   210,    -1,    12,
     210,    -1,    13,   210,    -1,    14,   210,    -1,    15,   210,
      -1,    18,   210,    -1,     6,   210,    -1,     7,   210,    -1,
       8,    25,   214,   210,    -1,   211,    23,    -1,    21,    -1,
     211,    21,    -1,    -1,    76,   215,   258,   213,   112,   216,
     113,   114,    -1,    -1,    25,    -1,    -1,    24,    -1,    -1,
     217,    -1,   218,    -1,   217,   218,    -1,   167,    -1,   170,
      -1,    24,   220,   258,   219,    -1,    -1,   119,    -1,    -1,
     120,   225,    -1,    -1,   120,   222,    -1,   225,    -1,   222,
     223,   225,    -1,   118,    -1,   121,    -1,   122,    -1,   123,
      -1,   124,    -1,   125,    -1,    -1,   117,    -1,   126,    -1,
     118,    -1,   121,    -1,   224,   228,    -1,   227,    -1,   226,
      79,   227,    -1,    24,    -1,   226,    -1,   277,   115,   229,
     116,    -1,    91,    -1,    90,    -1,    99,    -1,   100,    -1,
     101,    -1,    26,    -1,    98,    -1,    -1,   222,    -1,   229,
     119,   222,    -1,    92,   273,    24,   258,   114,    -1,    92,
     273,   115,   276,    24,   116,   115,   278,   116,   258,   114,
      -1,    -1,    -1,    53,   226,   232,   240,   258,   233,   243,
     114,    -1,    -1,   236,   235,   237,    -1,   108,   127,   278,
     128,    -1,    -1,    -1,    52,   226,   238,   240,   258,   239,
     243,   114,    -1,    -1,   129,   241,    -1,   242,    -1,   241,
     119,   242,    -1,   226,    -1,    -1,   112,   244,   113,    -1,
     245,    -1,   244,   245,    -1,   167,    -1,   170,    -1,   154,
      -1,   231,    -1,   237,    -1,   143,    -1,   230,    -1,   212,
      -1,   201,    -1,   189,    -1,   191,    -1,   192,    -1,   193,
      -1,   194,    -1,   195,    -1,   196,    -1,   197,    -1,   198,
      -1,   199,    -1,   248,    -1,   247,    -1,   267,    -1,    41,
     210,    -1,    40,   210,    -1,    54,   246,   129,    -1,    55,
     246,   129,    -1,    56,   246,   129,    -1,    57,   129,    -1,
      -1,    58,    -1,   253,   126,    24,   115,   116,   279,   257,
     258,   114,   262,   263,    -1,    -1,   107,   249,   250,    -1,
     250,    -1,    24,   115,   264,   116,   279,   258,   251,   114,
     262,    -1,    -1,   130,   115,   264,   116,   131,    -1,    -1,
     130,   273,   115,   264,   116,   131,    -1,    -1,    75,    -1,
     273,    24,   115,   264,   116,   256,   279,   257,   258,   252,
     114,   262,   263,    -1,   273,   102,   120,   115,   273,   116,
     114,    -1,   273,   102,   255,   115,   264,   116,   256,   279,
     257,   258,   252,   114,   262,   263,    -1,   102,   273,   115,
     264,   116,   256,   279,   257,   258,   252,   114,   262,   263,
      -1,   121,    -1,   118,    -1,   122,    -1,   123,    -1,   132,
      -1,   124,    -1,   125,    -1,   133,    -1,   127,   127,    -1,
     128,   128,    -1,   121,   120,    -1,   118,   120,    -1,   122,
     120,    -1,   123,   120,    -1,   132,   120,    -1,   124,   120,
      -1,   125,   120,    -1,   133,   120,    -1,   127,   127,   120,
      -1,   128,   128,   120,    -1,   126,    -1,   115,   116,    -1,
     130,   131,    -1,   127,    -1,   127,   120,    -1,   120,   120,
      -1,   117,   120,    -1,   128,    -1,   128,   120,    -1,    -1,
      81,    -1,    -1,   120,    90,    -1,    -1,   123,   259,   123,
      -1,   260,    -1,   259,   119,   260,    -1,    24,    -1,    24,
     120,   261,    -1,   178,    -1,    24,   129,   179,   118,   179,
      -1,    26,    -1,    90,    -1,    -1,    38,   210,    -1,    -1,
      27,   210,    -1,   265,    -1,    -1,   266,    -1,   265,   119,
     266,    -1,    83,   215,   258,   221,    -1,    84,   215,   258,
     221,    -1,    85,   215,   258,   221,    -1,    86,   215,   258,
      -1,    87,   215,   258,    -1,    88,   115,   264,   116,   215,
     258,    -1,    89,   115,   264,   116,   215,   258,    -1,   104,
     215,   258,    -1,   274,   221,    -1,    -1,    82,   268,   269,
      -1,   269,    -1,   270,    -1,   272,    -1,    -1,    75,   271,
     254,    -1,   254,    -1,   273,    24,   258,   114,   183,   184,
     185,    -1,    81,   277,   276,   275,    -1,   277,   276,   275,
      -1,   273,   215,   258,    -1,    -1,   124,    -1,    -1,   276,
     122,    -1,   226,    -1,   226,   127,   278,   128,    -1,    53,
     226,    -1,    78,    60,    -1,    60,    -1,    78,    -1,    78,
      61,    -1,    61,    -1,    62,    -1,    78,    62,    -1,    62,
      62,    -1,    78,    62,    62,    -1,    63,    -1,    64,    -1,
      59,    -1,    77,    65,    -1,    78,    65,    -1,    65,    -1,
      66,    -1,    67,    -1,    68,    -1,    69,    -1,    70,    -1,
      71,    -1,    72,    -1,    73,    -1,    74,    -1,   109,    -1,
     273,    -1,   278,   119,   273,    -1,    -1,   103,   115,   280,
     116,    -1,    -1,   226,    -1,   280,   119,   226,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   338,   338,   339,   342,   342,   361,   362,   363,   364,
     365,   366,   367,   368,   369,   370,   371,   372,   373,   374,
     375,   376,   377,   381,   385,   389,   390,   391,   392,   393,
     394,   395,   396,   397,   398,   399,   400,   403,   404,   405,
     406,   407,   408,   409,   410,   411,   412,   413,   414,   427,
     436,   441,   467,   503,   507,   581,   586,   586,   592,   592,
     641,   655,   656,   659,   663,   672,   681,   682,   685,   699,
     699,   736,   737,   740,   740,   767,   768,   771,   776,   781,
     786,   786,   811,   812,   815,   820,   833,   836,   839,   842,
     847,   848,   853,   859,   886,   897,   908,   921,   934,   967,
     970,   975,   976,   992,   995,   998,  1003,  1008,  1013,  1016,
    1021,  1024,  1029,  1032,  1037,  1042,  1047,  1052,  1057,  1060,
    1063,  1068,  1073,  1078,  1083,  1088,  1093,  1098,  1103,  1108,
    1113,  1118,  1124,  1130,  1136,  1142,  1151,  1157,  1162,  1168,
    1171,  1172,  1183,  1183,  1195,  1198,  1203,  1206,  1211,  1212,
    1215,  1216,  1219,  1220,  1221,  1249,  1250,  1253,  1254,  1257,
    1260,  1265,  1266,  1284,  1287,  1290,  1293,  1296,  1299,  1304,
    1307,  1310,  1313,  1316,  1321,  1339,  1340,  1348,  1353,  1362,
    1372,  1376,  1380,  1384,  1388,  1392,  1396,  1402,  1407,  1413,
    1431,  1438,  1463,  1469,  1463,  1484,  1484,  1510,  1515,  1521,
    1515,  1533,  1534,  1537,  1538,  1541,  1580,  1583,  1588,  1589,
    1592,  1593,  1594,  1595,  1596,  1597,  1598,  1599,  1600,  1604,
    1608,  1619,  1630,  1641,  1652,  1663,  1674,  1685,  1696,  1707,
    1708,  1709,  1710,  1721,  1732,  1739,  1746,  1753,  1762,  1765,
    1770,  1819,  1819,  1820,  1823,  1849,  1852,  1859,  1862,  1870,
    1873,  1878,  1893,  1911,  1937,  2012,  2013,  2014,  2015,  2016,
    2017,  2018,  2019,  2020,  2021,  2022,  2023,  2024,  2025,  2026,
    2027,  2028,  2029,  2030,  2031,  2032,  2033,  2034,  2035,  2036,
    2037,  2038,  2039,  2040,  2043,  2046,  2051,  2054,  2062,  2065,
    2071,  2075,  2087,  2091,  2097,  2101,  2123,  2127,  2133,  2136,
    2141,  2144,  2149,  2197,  2202,  2208,  2235,  2244,  2253,  2262,
    2273,  2281,  2296,  2311,  2317,  2323,  2323,  2324,  2327,  2328,
    2331,  2331,  2332,  2335,  2370,  2376,  2384,  2452,  2455,  2463,
    2466,  2471,  2482,  2496,  2513,  2520,  2527,  2534,  2541,  2548,
    2555,  2562,  2569,  2576,  2583,  2590,  2597,  2604,  2611,  2618,
    2625,  2632,  2639,  2646,  2653,  2660,  2667,  2674,  2681,  2690,
    2696,  2712,  2715,  2723,  2729,  2736
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "TK_API", "TK_DEFENCODING", "TK_PLUGIN",
  "TK_DOC", "TK_EXPORTEDDOC", "TK_MAKEFILE", "TK_ACCESSCODE", "TK_GETCODE",
  "TK_SETCODE", "TK_PREINITCODE", "TK_INITCODE", "TK_POSTINITCODE",
  "TK_UNITCODE", "TK_MODCODE", "TK_TYPECODE", "TK_PREPYCODE", "TK_COPYING",
  "TK_MAPPEDTYPE", "TK_CODELINE", "TK_IF", "TK_END", "TK_NAME",
  "TK_PATHNAME", "TK_STRING", "TK_VIRTUALCATCHERCODE",
  "TK_VIRTERRORHANDLER", "TK_TRAVERSECODE", "TK_CLEARCODE",
  "TK_GETBUFFERCODE", "TK_RELEASEBUFFERCODE", "TK_READBUFFERCODE",
  "TK_WRITEBUFFERCODE", "TK_SEGCOUNTCODE", "TK_CHARBUFFERCODE",
  "TK_PICKLECODE", "TK_METHODCODE", "TK_FROMTYPE", "TK_TOTYPE",
  "TK_TOSUBCLASS", "TK_INCLUDE", "TK_OPTINCLUDE", "TK_IMPORT",
  "TK_EXPHEADERCODE", "TK_MODHEADERCODE", "TK_TYPEHEADERCODE", "TK_MODULE",
  "TK_CMODULE", "TK_CONSMODULE", "TK_COMPOMODULE", "TK_CLASS", "TK_STRUCT",
  "TK_PUBLIC", "TK_PROTECTED", "TK_PRIVATE", "TK_SIGNALS", "TK_SLOTS",
  "TK_BOOL", "TK_SHORT", "TK_INT", "TK_LONG", "TK_FLOAT", "TK_DOUBLE",
  "TK_CHAR", "TK_WCHAR_T", "TK_VOID", "TK_PYOBJECT", "TK_PYTUPLE",
  "TK_PYLIST", "TK_PYDICT", "TK_PYCALLABLE", "TK_PYSLICE", "TK_PYTYPE",
  "TK_VIRTUAL", "TK_ENUM", "TK_SIGNED", "TK_UNSIGNED", "TK_SCOPE",
  "TK_LOGICAL_OR", "TK_CONST", "TK_STATIC", "TK_SIPSIGNAL", "TK_SIPSLOT",
  "TK_SIPANYSLOT", "TK_SIPRXCON", "TK_SIPRXDIS", "TK_SIPSLOTCON",
  "TK_SIPSLOTDIS", "TK_NUMBER", "TK_REAL", "TK_TYPEDEF", "TK_NAMESPACE",
  "TK_TIMELINE", "TK_PLATFORMS", "TK_FEATURE", "TK_LICENSE", "TK_QCHAR",
  "TK_TRUE", "TK_FALSE", "TK_NULL", "TK_OPERATOR", "TK_THROW",
  "TK_QOBJECT", "TK_EXCEPTION", "TK_RAISECODE", "TK_EXPLICIT",
  "TK_TEMPLATE", "TK_ELLIPSIS", "TK_DEFMETATYPE", "TK_DEFSUPERTYPE", "'{'",
  "'}'", "';'", "'('", "')'", "'!'", "'-'", "','", "'='", "'+'", "'*'",
  "'/'", "'&'", "'|'", "'~'", "'<'", "'>'", "':'", "'['", "']'", "'%'",
  "'^'", "$accept", "specification", "statement", "@1", "modstatement",
  "nsstatement", "defencoding", "plugin", "api", "exception",
  "baseexception", "raisecode", "mappedtype", "@2", "mappedtypetmpl", "@3",
  "mtdefinition", "mtbody", "mtline", "mtfunction", "namespace", "@4",
  "nsbody", "platforms", "@5", "platformlist", "platform",
  "virterrorhandler", "feature", "timeline", "@6", "qualifierlist",
  "qualifiername", "ifstart", "oredqualifiers", "qualifiers", "ifend",
  "license", "defmetatype", "defsupertype", "consmodule", "compmodule",
  "module", "modlang", "dottedname", "optnumber", "include", "optinclude",
  "import", "optaccesscode", "optgetcode", "optsetcode", "copying",
  "exphdrcode", "modhdrcode", "typehdrcode", "opttypehdrcode", "travcode",
  "clearcode", "getbufcode", "releasebufcode", "readbufcode",
  "writebufcode", "segcountcode", "charbufcode", "picklecode", "modcode",
  "typecode", "preinitcode", "initcode", "postinitcode", "unitcode",
  "prepycode", "doc", "exporteddoc", "makefile", "codeblock", "codelines",
  "enum", "@7", "optfilename", "optname", "optenumbody", "enumbody",
  "enumline", "optcomma", "optenumassign", "optassign", "expr", "binop",
  "optunop", "value", "scopedname", "scopepart", "simplevalue", "exprlist",
  "typedef", "struct", "@8", "@9", "classtmpl", "@10", "template", "class",
  "@11", "@12", "superclasses", "superlist", "superclass", "optclassbody",
  "classbody", "classline", "optslot", "dtor", "ctor", "@13", "simplector",
  "optctorsig", "optsig", "optvirtual", "function", "operatorname",
  "optconst", "optabstract", "optflags", "flaglist", "flag", "flagvalue",
  "methodcode", "virtualcatchercode", "arglist", "rawarglist", "argvalue",
  "varmember", "@14", "varmem", "member", "@15", "variable", "cpptype",
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
     365,   366,   123,   125,    59,    40,    41,    33,    45,    44,
      61,    43,    42,    47,    38,   124,   126,    60,    62,    58,
      91,    93,    37,    94
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint16 yyr1[] =
{
       0,   134,   135,   135,   137,   136,   138,   138,   138,   138,
     138,   138,   138,   138,   138,   138,   138,   138,   138,   138,
     138,   138,   138,   138,   138,   138,   138,   138,   138,   138,
     138,   138,   138,   138,   138,   138,   138,   139,   139,   139,
     139,   139,   139,   139,   139,   139,   139,   139,   139,   140,
     141,   142,   143,   144,   144,   145,   147,   146,   149,   148,
     150,   151,   151,   152,   152,   152,   152,   152,   153,   155,
     154,   156,   156,   158,   157,   159,   159,   160,   161,   162,
     164,   163,   165,   165,   166,   167,   168,   168,   168,   168,
     169,   169,   170,   171,   172,   173,   174,   175,   176,   177,
     177,   178,   178,   179,   179,   180,   181,   182,   183,   183,
     184,   184,   185,   185,   186,   187,   188,   189,   190,   190,
     191,   192,   193,   194,   195,   196,   197,   198,   199,   200,
     201,   202,   203,   204,   205,   206,   207,   208,   209,   210,
     211,   211,   213,   212,   214,   214,   215,   215,   216,   216,
     217,   217,   218,   218,   218,   219,   219,   220,   220,   221,
     221,   222,   222,   223,   223,   223,   223,   223,   223,   224,
     224,   224,   224,   224,   225,   226,   226,   227,   228,   228,
     228,   228,   228,   228,   228,   228,   228,   229,   229,   229,
     230,   230,   232,   233,   231,   235,   234,   236,   238,   239,
     237,   240,   240,   241,   241,   242,   243,   243,   244,   244,
     245,   245,   245,   245,   245,   245,   245,   245,   245,   245,
     245,   245,   245,   245,   245,   245,   245,   245,   245,   245,
     245,   245,   245,   245,   245,   245,   245,   245,   246,   246,
     247,   249,   248,   248,   250,   251,   251,   252,   252,   253,
     253,   254,   254,   254,   254,   255,   255,   255,   255,   255,
     255,   255,   255,   255,   255,   255,   255,   255,   255,   255,
     255,   255,   255,   255,   255,   255,   255,   255,   255,   255,
     255,   255,   255,   255,   256,   256,   257,   257,   258,   258,
     259,   259,   260,   260,   261,   261,   261,   261,   262,   262,
     263,   263,   264,   265,   265,   265,   266,   266,   266,   266,
     266,   266,   266,   266,   266,   268,   267,   267,   269,   269,
     271,   270,   270,   272,   273,   273,   274,   275,   275,   276,
     276,   277,   277,   277,   277,   277,   277,   277,   277,   277,
     277,   277,   277,   277,   277,   277,   277,   277,   277,   277,
     277,   277,   277,   277,   277,   277,   277,   277,   277,   278,
     278,   279,   279,   280,   280,   280
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     1,     2,     0,     2,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     2,
       2,     3,     9,     0,     3,     2,     0,     5,     0,     5,
       4,     1,     2,     1,     2,     2,     1,     1,    12,     0,
       7,     1,     2,     0,     5,     1,     2,     1,     2,     2,
       0,     5,     1,     2,     1,     4,     1,     2,     3,     4,
       1,     3,     1,     2,     2,     2,     2,     2,     3,     1,
       1,     1,     1,     0,     1,     2,     2,     2,     0,     2,
       0,     2,     0,     2,     2,     2,     2,     2,     0,     1,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     4,     2,
       1,     2,     0,     8,     0,     1,     0,     1,     0,     1,
       1,     2,     1,     1,     4,     0,     1,     0,     2,     0,
       2,     1,     3,     1,     1,     1,     1,     1,     1,     0,
       1,     1,     1,     1,     2,     1,     3,     1,     1,     4,
       1,     1,     1,     1,     1,     1,     1,     0,     1,     3,
       5,    11,     0,     0,     8,     0,     3,     4,     0,     0,
       8,     0,     2,     1,     3,     1,     0,     3,     1,     2,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     2,     2,     3,     3,     3,     2,     0,     1,
      11,     0,     3,     1,     9,     0,     5,     0,     6,     0,
       1,    13,     7,    14,    13,     1,     1,     1,     1,     1,
       1,     1,     1,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     3,     3,     1,     2,     2,     1,     2,
       2,     2,     1,     2,     0,     1,     0,     2,     0,     3,
       1,     3,     1,     3,     1,     5,     1,     1,     0,     2,
       0,     2,     1,     0,     1,     3,     4,     4,     4,     3,
       3,     6,     6,     3,     2,     0,     3,     1,     1,     1,
       0,     3,     1,     7,     4,     3,     3,     0,     1,     0,
       2,     1,     4,     2,     2,     1,     1,     2,     1,     1,
       2,     2,     3,     1,     1,     1,     2,     2,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       3,     0,     4,     0,     1,     3
};

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint16 yydefact[] =
{
       4,     4,     2,     0,     1,     3,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    92,   177,     0,     0,     0,     0,     0,     0,     0,
      99,   100,     0,     0,     0,     0,   345,   335,   338,   339,
     343,   344,   348,   349,   350,   351,   352,   353,   354,   355,
     356,   357,   146,     0,   336,     0,     0,     0,    80,    73,
       0,   288,     0,     0,     0,   358,     0,     0,     5,    35,
      19,     9,    14,    43,    33,    34,    39,    16,    36,    17,
      15,    37,    38,    18,    20,    21,     7,     8,     6,     0,
      11,    12,    13,    10,    22,    23,    48,    24,    25,    26,
      27,    28,    29,    30,    31,    32,    45,   331,   175,    44,
      40,    42,   195,    41,    46,    47,     0,   329,     0,    49,
      50,   140,   136,     0,   137,   144,   131,   132,   133,   134,
     129,   135,   114,     0,   288,   146,    78,   105,   106,   107,
     115,   116,   117,   101,   102,    96,    97,   198,   192,   341,
     147,   288,   346,   334,   337,   340,   347,   329,     0,    69,
       0,     0,    79,     0,    93,     0,    53,     0,    94,    95,
     103,     0,     0,     0,     0,   288,     0,   327,    51,   141,
     139,   145,     0,   333,    56,    86,     0,    90,     0,     0,
     201,   201,   142,   342,   327,   288,   329,     0,     0,     0,
     292,     0,   290,   303,     0,   288,   359,     0,   104,    98,
     176,     0,    58,   196,   303,     0,     0,     0,   256,     0,
     255,   257,   258,   260,   261,   275,   278,   282,     0,   259,
     262,     0,   330,   328,   325,   138,     0,    87,     0,    85,
     146,     0,   288,   288,     0,   324,     0,     0,     0,    84,
       0,    82,    77,     0,    75,     0,     0,   289,   146,   146,
     146,   146,   146,     0,     0,   146,     0,   302,   304,   146,
     159,     0,     0,     0,   197,   332,     0,     0,   108,   276,
     281,   266,     0,   280,   265,   267,   268,   270,   271,   279,
     263,   283,   264,   277,   269,   272,   303,     0,    57,    88,
       0,    91,   205,   202,   203,   199,   193,   148,   190,     0,
      71,     0,   195,    81,    83,    74,    76,   101,   296,   297,
     294,   293,   291,   288,   288,   288,   288,   288,   303,   303,
     288,   284,     0,   288,   169,   314,    54,   118,   360,    59,
     284,     0,   110,     0,   273,   274,     0,     0,     0,     0,
       0,    61,    67,    63,    66,    89,     0,   206,   206,   157,
     152,   153,     0,   149,   150,     0,     0,    72,   103,   159,
     159,   159,   309,   310,     0,     0,   313,   285,   361,   305,
     326,   170,   172,   173,   171,   160,     0,   161,   119,     0,
     361,   109,     0,   112,     0,   284,    64,    65,     0,     0,
      62,   204,   249,     0,     0,   169,   288,     0,   151,     0,
      70,     0,   306,   307,   308,   146,   146,     0,   286,   163,
     164,   165,   166,   167,   168,   169,   185,   181,   180,   186,
     182,   183,   184,   178,   174,     0,     0,     0,   286,   111,
       0,   323,   252,   361,     0,    60,     0,   177,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,   238,
     238,   238,     0,   320,   315,   241,   215,   212,   210,   211,
     219,   220,   221,   222,   223,   224,   225,   226,   227,   228,
     218,   217,   216,   213,   214,   249,   208,   230,   229,   243,
       0,   322,   231,   317,   318,   319,   200,   194,   158,   155,
     143,     0,   103,   288,   288,   363,     0,   288,   162,   169,
      55,     0,   288,   113,   286,   303,   130,   303,   120,   121,
     122,   123,   124,   125,   126,   127,   128,   233,   232,   239,
       0,     0,     0,   237,     0,     0,     0,   207,   209,     0,
     156,   154,   288,   295,   311,   312,   364,     0,   287,   247,
     188,     0,    52,   247,   288,     0,     0,   234,   235,   236,
     321,     0,   320,   316,     0,   242,     0,     0,   362,     0,
       0,     0,   179,   169,     0,   247,   284,   361,     0,     0,
     191,   365,     0,   298,   189,   298,     0,   361,   288,   361,
     303,     0,   300,   300,   298,   288,   245,   286,     0,   299,
       0,   254,   251,   300,   247,     0,     0,   288,     0,   301,
     253,     0,   303,   298,     0,   248,   298,     0,   244,   298,
      68,     0,   300,   246,   240
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     1,     2,     3,    68,    69,    70,    71,    72,    73,
     205,   437,    74,   236,    75,   276,   298,   350,   351,   352,
      76,   197,   311,    77,   161,   253,   254,    78,    79,    80,
     160,   250,   251,    81,   187,   188,    82,    83,    84,    85,
      86,    87,    88,    89,   145,   209,    90,    91,    92,   342,
     393,   441,    93,    94,    95,    96,   389,   471,   472,   473,
     474,   475,   476,   477,   478,   479,    97,   480,    98,    99,
     100,   101,   102,   103,   104,   105,   122,   123,   106,   244,
     182,   151,   362,   363,   364,   541,   406,   335,   385,   425,
     386,   387,   107,   108,   434,   551,   109,   110,   191,   358,
     111,   174,   312,   113,   190,   357,   242,   303,   304,   403,
     485,   486,   530,   487,   488,   536,   489,   606,   571,   490,
     114,   231,   378,   507,   164,   201,   202,   321,   592,   601,
     266,   267,   268,   492,   535,   493,   494,   534,   115,   269,
     270,   234,   177,   117,   207,   418,   547
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -537
static const yytype_int16 yypact[] =
{
    -537,    53,  -537,   551,  -537,  -537,    71,    89,   120,   128,
     128,   129,   128,   128,   128,   128,   128,   128,   128,   124,
      49,  -537,  -537,   145,   151,   174,   184,   128,   128,   128,
    -537,  -537,   134,   134,   191,   191,  -537,  -537,  -537,   154,
    -537,  -537,  -537,  -537,  -537,  -537,  -537,  -537,  -537,  -537,
    -537,  -537,   196,   159,   113,   124,  1042,   201,  -537,  -537,
     205,   107,  1042,   191,   105,  -537,   134,   134,  -537,  -537,
    -537,  -537,  -537,  -537,  -537,  -537,  -537,  -537,  -537,  -537,
    -537,  -537,  -537,  -537,  -537,  -537,  -537,  -537,  -537,   134,
    -537,  -537,  -537,  -537,  -537,  -537,  -537,  -537,  -537,  -537,
    -537,  -537,  -537,  -537,  -537,  -537,  -537,   -27,  -537,  -537,
    -537,  -537,   214,  -537,  -537,  -537,    12,  -537,   146,  -537,
    -537,  -537,  -537,    84,  -537,   217,  -537,  -537,  -537,  -537,
    -537,  -537,  -537,   191,   107,    17,  -537,  -537,  -537,  -537,
    -537,  -537,  -537,  -537,  -537,  -537,  -537,   165,     8,  -537,
    -537,   107,  -537,  -537,  -537,   183,  -537,  -537,     4,  -537,
     137,   139,  -537,   230,  -537,   148,   -35,  1042,  -537,  -537,
     185,   191,  1042,   124,   224,   -26,   228,    57,  -537,  -537,
    -537,  -537,   128,   165,  -537,   160,   253,   199,   166,   163,
     155,   155,  -537,  -537,    57,   107,  -537,   171,   261,   263,
     168,   -11,  -537,   846,   191,   107,  -537,   -63,  -537,  -537,
    -537,   -58,  -537,  -537,   846,   175,   177,   170,   178,   -46,
     180,   181,   182,   186,   187,  -537,   -16,   -22,   164,   190,
     192,   176,  -537,  -537,  -537,  -537,   193,  -537,    18,  -537,
     196,   191,   107,   107,   202,  -537,   189,    11,   795,  -537,
       5,  -537,  -537,    23,  -537,    67,   230,  -537,   196,   196,
     196,   196,   196,   203,   204,   196,   195,   197,  -537,   196,
     206,   -28,   209,  1042,  -537,  -537,   193,   207,   285,  -537,
    -537,  -537,  1042,  -537,  -537,  -537,  -537,  -537,  -537,  -537,
     208,  -537,   210,  -537,  -537,  -537,   846,   188,  -537,  -537,
     275,  -537,   165,   198,  -537,  -537,  -537,   236,  -537,   211,
    -537,   433,  -537,  -537,  -537,  -537,  -537,   200,  -537,  -537,
    -537,  -537,  -537,   107,   107,   107,   107,   107,   846,   846,
     107,   223,   846,   107,    34,  -537,  -537,   277,  -537,  -537,
     223,   128,   298,   218,  -537,  -537,   219,   128,   128,  1042,
     179,  -537,  -537,  -537,  -537,  -537,   191,   213,   213,   216,
    -537,  -537,   220,   236,  -537,   225,   227,  -537,   185,   206,
     206,   206,  -537,  -537,   226,   241,  -537,  -537,   256,  -537,
    -537,  -537,  -537,  -537,  -537,   144,   912,  -537,  -537,   233,
     256,  -537,   128,   311,   249,   223,  -537,  -537,   320,   250,
    -537,  -537,   734,   251,   252,    34,   107,   254,  -537,  1042,
    -537,   255,  -537,  -537,  -537,   196,   196,   257,   247,  -537,
    -537,  -537,  -537,  -537,  -537,    34,  -537,  -537,  -537,  -537,
    -537,  -537,  -537,   -31,  -537,   259,   128,   258,   247,  -537,
     128,  -537,  -537,   256,   260,  -537,   128,   262,   128,   128,
     128,   128,   128,   128,   128,   128,   128,   128,   128,   312,
     312,   312,   240,   264,  -537,  -537,  -537,  -537,  -537,  -537,
    -537,  -537,  -537,  -537,  -537,  -537,  -537,  -537,  -537,  -537,
    -537,  -537,  -537,  -537,  -537,   641,  -537,  -537,  -537,  -537,
     265,  -537,  -537,  -537,  -537,  -537,  -537,  -537,  -537,   266,
    -537,   -48,   185,   107,   107,   191,   286,   107,  -537,   122,
    -537,   267,   107,  -537,   247,   846,  -537,   846,  -537,  -537,
    -537,  -537,  -537,  -537,  -537,  -537,  -537,  -537,  -537,  -537,
     268,   269,   270,  -537,   990,   963,   354,  -537,  -537,   355,
    -537,  -537,   107,  -537,  -537,  -537,   165,    37,  -537,   271,
     144,    52,  -537,   271,   107,   273,   278,  -537,  -537,  -537,
    -537,    22,  -537,  -537,   262,  -537,   280,   272,  -537,   191,
    1042,   279,  -537,    34,   282,   271,   223,   256,   287,   288,
    -537,   165,   290,   365,   144,   365,   292,   256,   107,   256,
     846,   128,   381,   381,   365,   107,   281,   247,   293,  -537,
     128,  -537,  -537,   381,   271,   297,   299,   107,   283,  -537,
    -537,   301,   846,   365,   302,  -537,   365,   303,  -537,   365,
    -537,   289,   381,  -537,  -537
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -537,  -537,   416,  -537,  -537,  -208,  -537,  -537,  -537,  -365,
    -537,  -537,  -537,  -537,  -537,  -537,   142,  -537,    73,  -537,
    -357,  -537,  -537,  -537,  -537,  -537,   172,  -537,  -537,  -537,
    -537,  -537,   212,  -285,  -537,  -537,  -273,  -537,  -537,  -537,
    -537,  -537,  -537,  -537,    -8,  -341,  -537,  -537,  -537,  -537,
    -537,  -537,  -537,  -537,  -537,  -271,  -537,  -537,  -537,  -537,
    -537,  -537,  -537,  -537,  -537,  -537,  -537,  -537,  -537,  -537,
    -537,  -537,  -537,  -537,  -537,  -537,   -10,  -537,  -277,  -537,
    -537,  -119,  -537,  -537,    58,  -537,  -537,   -97,  -471,  -537,
    -537,  -342,   -24,   294,  -537,  -537,  -340,  -338,  -537,  -537,
    -537,  -537,   421,  -165,  -537,  -537,   237,  -537,    75,    69,
    -537,   -56,  -323,  -537,  -537,  -537,  -104,  -537,  -503,  -537,
    -372,  -537,  -319,  -415,  -120,  -537,   194,  -537,  -363,  -536,
    -202,  -537,   101,  -537,  -537,  -100,  -537,  -537,  -369,    -2,
    -537,   243,  -114,    -6,  -157,  -366,  -537
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -334
static const yytype_int16 yytable[] =
{
     124,   116,   126,   127,   128,   129,   130,   131,   132,   213,
     147,   148,   277,   134,   184,   211,   189,   140,   141,   142,
     354,   390,   360,   512,   438,   146,   353,   411,   195,   249,
     491,   192,  -333,   495,   361,   309,   175,   466,   550,   166,
     310,   185,   299,   194,   171,   467,   578,   252,   171,   157,
     574,   171,   171,     4,   158,   215,   273,   602,   168,   169,
     165,   273,   482,   498,   483,   274,   388,   610,   542,   282,
     275,   273,   586,   354,   283,   246,   443,   514,   360,   353,
     204,   170,   247,   508,  -331,   272,   624,   171,   336,   214,
     361,   317,   144,   318,   346,   118,   172,   163,   291,   554,
     172,   611,   584,   367,   289,   179,   292,   180,   256,   183,
    -333,   290,   257,   491,   176,   119,   495,   468,   313,   196,
     466,   301,   305,   306,   176,   481,   374,   375,   467,   469,
    -333,   470,  -333,   232,   186,   300,   315,   531,   532,   323,
     324,   325,   326,   327,   120,   482,   330,   483,    22,   121,
     333,   381,   382,   568,   125,   383,   569,   319,   143,   144,
     384,   543,   560,   491,   135,   206,   495,   212,   572,   136,
     206,   573,   235,   153,   154,   155,   137,   133,   156,   232,
     271,   233,   607,    36,    37,    38,    39,    40,    41,    42,
      43,    44,    45,    46,    47,    48,    49,    50,    51,   138,
     468,    53,    54,   369,   370,   371,   372,   373,   481,   139,
     376,   588,   469,   380,   470,    22,   149,   302,   347,   348,
     150,   595,   593,   597,   152,   159,    29,   347,   348,   162,
     163,   603,   167,    65,   173,    29,   178,   484,  -187,   381,
     382,  -187,   181,   383,   171,   193,   116,   320,   384,   198,
     618,   199,   501,   620,   200,    52,   622,   587,    20,    21,
     359,   349,   419,   203,    52,   420,   421,   422,   423,   424,
     349,   338,   412,   413,   414,   208,    34,   237,  -147,   238,
     343,   240,   239,   248,   241,   249,   499,   252,   255,   278,
     280,   296,   399,   279,   341,   293,   503,   504,   281,   355,
     284,   285,   286,   308,   377,   297,   287,   288,   392,   116,
     294,   331,   295,   555,   307,   556,   332,   356,   328,   329,
     484,   337,   440,   340,    29,   402,   334,   365,   344,   368,
     345,   391,   302,   407,   394,   395,   405,   396,   397,   436,
     409,   410,   415,   216,   444,   217,   218,   398,   219,   220,
     221,   222,   223,   224,   225,   226,   227,   416,   228,   417,
     229,   230,   433,   442,   445,   496,   497,   506,   500,   533,
     529,   511,   505,   502,   509,   515,   548,   517,   564,   566,
     435,   552,   439,   544,   545,   540,   580,   549,   598,   576,
    -250,   539,   553,   583,   577,   579,   585,   557,   558,   559,
     116,   570,   214,   591,   589,   590,   594,   206,   600,   608,
     617,   605,   612,   613,   615,   616,   619,     5,   339,   621,
     623,   408,   567,   400,   112,   316,   510,   404,   243,   538,
     513,   401,   565,   379,   575,   563,   516,   245,   518,   519,
     520,   521,   522,   523,   524,   525,   526,   527,   528,     0,
     322,     0,     0,     0,     0,    20,    21,    22,     0,     0,
       0,     0,   314,     0,     0,   210,     0,     0,   596,     0,
       0,     0,     0,     0,     0,   604,     0,     0,     0,     0,
      29,   546,     0,   116,     0,    34,    35,   614,     0,     0,
       0,     0,    36,    37,    38,    39,    40,    41,    42,    43,
      44,    45,    46,    47,    48,    49,    50,    51,     0,    52,
      53,    54,     0,     0,    55,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    56,    57,     0,     0,     0,
       0,     0,   561,   116,     0,    62,     0,     0,    63,     0,
       0,    64,    65,     0,     0,   581,   366,     0,     0,     0,
       0,     0,     0,     0,     6,     7,     8,     9,    10,    11,
       0,     0,     0,    12,    13,    14,    15,    16,   582,    17,
      18,    19,     0,    20,    21,    22,     0,     0,     0,    23,
       0,   599,     0,     0,     0,     0,     0,     0,     0,     0,
     609,     0,     0,    24,    25,    26,    27,    28,    29,    30,
      31,    32,    33,    34,    35,     0,     0,     0,     0,     0,
      36,    37,    38,    39,    40,    41,    42,    43,    44,    45,
      46,    47,    48,    49,    50,    51,     0,    52,    53,    54,
       0,     0,    55,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    56,    57,    58,    59,    60,    61,     0,
       0,     0,     0,    62,     0,     0,    63,     0,   446,    64,
      65,    66,    67,    20,    21,   447,     0,     0,     0,     0,
     448,   449,   450,   451,   452,   453,   454,   455,   456,     0,
       0,   457,   458,     0,     0,     0,     0,     0,    29,     0,
       0,     0,     0,    34,    35,   459,   460,   461,   462,     0,
      36,    37,    38,    39,    40,    41,    42,    43,    44,    45,
      46,    47,    48,    49,    50,    51,   463,    52,    53,    54,
       0,     0,    55,   464,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    56,    57,     0,     0,     0,     0,     0,
       0,     0,     0,    62,     0,     0,    63,     0,   465,     0,
      65,   446,     0,     0,   537,     0,    20,    21,   447,     0,
       0,     0,     0,   448,   449,   450,   451,   452,   453,   454,
     455,   456,     0,     0,   457,   458,     0,     0,     0,     0,
       0,    29,     0,     0,     0,     0,    34,    35,   459,   460,
     461,   462,     0,    36,    37,    38,    39,    40,    41,    42,
      43,    44,    45,    46,    47,    48,    49,    50,    51,   463,
      52,    53,    54,     0,     0,    55,   464,    20,    21,    22,
       0,     0,     0,     0,     0,     0,    56,    57,     0,     0,
       0,     0,     0,     0,     0,     0,    62,     0,     0,    63,
       0,   465,    29,    65,     0,     0,     0,    34,    35,     0,
       0,     0,     0,     0,    36,    37,    38,    39,    40,    41,
      42,    43,    44,    45,    46,    47,    48,    49,    50,    51,
      22,    52,    53,    54,     0,     0,    55,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    56,    57,     0,
       0,     0,     0,     0,     0,     0,     0,    62,     0,   133,
      63,     0,     0,    64,    65,    36,    37,    38,    39,    40,
      41,    42,    43,    44,    45,    46,    47,    48,    49,    50,
      51,     0,     0,    53,    54,     0,     0,    55,     0,   258,
     259,   260,   261,   262,   263,   264,    22,     0,   426,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     265,     0,     0,     0,     0,    65,     0,     0,     0,     0,
       0,     0,     0,     0,     0,   133,     0,     0,     0,     0,
       0,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    22,     0,    53,
      54,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,   427,   428,     0,     0,     0,     0,     0,     0,
     429,   430,   431,   432,    22,     0,   133,     0,     0,     0,
       0,    65,    36,    37,    38,    39,    40,    41,    42,    43,
      44,    45,    46,    47,    48,    49,    50,    51,   562,     0,
      53,    54,     0,   133,    55,     0,     0,     0,     0,    36,
      37,    38,    39,    40,    41,    42,    43,    44,    45,    46,
      47,    48,    49,    50,    51,    62,    22,    53,    54,     0,
       0,    55,    65,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    62,     0,     0,   133,     0,     0,     0,    65,
       0,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,     0,     0,    53,
      54,     0,     0,    55,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    65
};

static const yytype_int16 yycheck[] =
{
      10,     3,    12,    13,    14,    15,    16,    17,    18,   174,
      34,    35,   214,    19,   134,   172,   135,    27,    28,    29,
     297,   340,   307,   438,   390,    33,   297,   368,    24,    24,
     402,   151,    24,   402,   307,    24,    24,   402,   509,    63,
     248,    24,    24,   157,    79,   402,    24,    24,    79,    55,
     553,    79,    79,     0,    56,   175,   119,   593,    66,    67,
      62,   119,   402,   405,   402,   128,   337,   603,   116,   115,
     128,   119,   575,   350,   120,   195,   395,   443,   363,   350,
     115,    89,   196,   425,   115,   205,   622,    79,   116,   115,
     363,    24,    25,    26,   296,    24,   127,   123,   120,   514,
     127,   604,   573,   311,   120,    21,   128,    23,   119,   133,
     102,   127,   123,   485,   102,    26,   485,   402,   113,   115,
     485,   240,   242,   243,   102,   402,   328,   329,   485,   402,
     122,   402,   124,   122,   117,   117,   113,   460,   461,   258,
     259,   260,   261,   262,    24,   485,   265,   485,    24,    21,
     269,   117,   118,   116,    25,   121,   119,    90,    24,    25,
     126,   502,   534,   535,   115,   167,   535,   173,   116,    24,
     172,   119,   182,    60,    61,    62,    25,    53,    65,   122,
     204,   124,   597,    59,    60,    61,    62,    63,    64,    65,
      66,    67,    68,    69,    70,    71,    72,    73,    74,    25,
     485,    77,    78,   323,   324,   325,   326,   327,   485,    25,
     330,   577,   485,   333,   485,    24,    62,   241,    39,    40,
      24,   587,   585,   589,    65,    24,    47,    39,    40,    24,
     123,   594,   127,   109,    20,    47,    90,   402,   116,   117,
     118,   119,    25,   121,    79,    62,   248,   255,   126,   112,
     613,   112,   409,   616,    24,    76,   619,   576,    22,    23,
      24,    82,   118,   115,    76,   121,   122,   123,   124,   125,
      82,   273,   369,   370,   371,    90,    52,    24,   118,    80,
     282,   118,   116,   112,   129,    24,   406,    24,   120,   114,
     120,   115,   113,   116,     9,   131,   415,   416,   120,    24,
     120,   120,   120,   114,    81,   112,   120,   120,    10,   311,
     120,   116,   120,   515,   112,   517,   119,   119,   115,   115,
     485,   112,    11,   116,    47,   112,   120,   116,   120,   129,
     120,   341,   356,   113,   116,   116,   120,   347,   348,   106,
     115,   114,   116,   115,    24,   117,   118,   349,   120,   121,
     122,   123,   124,   125,   126,   127,   128,   116,   130,   103,
     132,   133,   386,   114,   114,   114,   114,   120,   114,   129,
      58,   113,   115,   118,   115,   115,    90,   115,    24,    24,
     386,   114,   392,   503,   504,   119,   114,   507,   590,   116,
     126,   126,   512,   114,   116,   115,   114,   129,   129,   129,
     402,   130,   115,    38,   116,   115,   114,   409,    27,   116,
     612,   130,   115,   114,   131,   114,   114,     1,   276,   116,
     131,   363,   542,   350,     3,   253,   436,   358,   191,   485,
     440,   356,   536,   332,   554,   535,   446,   194,   448,   449,
     450,   451,   452,   453,   454,   455,   456,   457,   458,    -1,
     256,    -1,    -1,    -1,    -1,    22,    23,    24,    -1,    -1,
      -1,    -1,   250,    -1,    -1,   171,    -1,    -1,   588,    -1,
      -1,    -1,    -1,    -1,    -1,   595,    -1,    -1,    -1,    -1,
      47,   505,    -1,   485,    -1,    52,    53,   607,    -1,    -1,
      -1,    -1,    59,    60,    61,    62,    63,    64,    65,    66,
      67,    68,    69,    70,    71,    72,    73,    74,    -1,    76,
      77,    78,    -1,    -1,    81,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    92,    93,    -1,    -1,    -1,
      -1,    -1,   534,   535,    -1,   102,    -1,    -1,   105,    -1,
      -1,   108,   109,    -1,    -1,   569,   113,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,     3,     4,     5,     6,     7,     8,
      -1,    -1,    -1,    12,    13,    14,    15,    16,   570,    18,
      19,    20,    -1,    22,    23,    24,    -1,    -1,    -1,    28,
      -1,   591,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
     600,    -1,    -1,    42,    43,    44,    45,    46,    47,    48,
      49,    50,    51,    52,    53,    -1,    -1,    -1,    -1,    -1,
      59,    60,    61,    62,    63,    64,    65,    66,    67,    68,
      69,    70,    71,    72,    73,    74,    -1,    76,    77,    78,
      -1,    -1,    81,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    92,    93,    94,    95,    96,    97,    -1,
      -1,    -1,    -1,   102,    -1,    -1,   105,    -1,    17,   108,
     109,   110,   111,    22,    23,    24,    -1,    -1,    -1,    -1,
      29,    30,    31,    32,    33,    34,    35,    36,    37,    -1,
      -1,    40,    41,    -1,    -1,    -1,    -1,    -1,    47,    -1,
      -1,    -1,    -1,    52,    53,    54,    55,    56,    57,    -1,
      59,    60,    61,    62,    63,    64,    65,    66,    67,    68,
      69,    70,    71,    72,    73,    74,    75,    76,    77,    78,
      -1,    -1,    81,    82,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    92,    93,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,   102,    -1,    -1,   105,    -1,   107,    -1,
     109,    17,    -1,    -1,   113,    -1,    22,    23,    24,    -1,
      -1,    -1,    -1,    29,    30,    31,    32,    33,    34,    35,
      36,    37,    -1,    -1,    40,    41,    -1,    -1,    -1,    -1,
      -1,    47,    -1,    -1,    -1,    -1,    52,    53,    54,    55,
      56,    57,    -1,    59,    60,    61,    62,    63,    64,    65,
      66,    67,    68,    69,    70,    71,    72,    73,    74,    75,
      76,    77,    78,    -1,    -1,    81,    82,    22,    23,    24,
      -1,    -1,    -1,    -1,    -1,    -1,    92,    93,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,   102,    -1,    -1,   105,
      -1,   107,    47,   109,    -1,    -1,    -1,    52,    53,    -1,
      -1,    -1,    -1,    -1,    59,    60,    61,    62,    63,    64,
      65,    66,    67,    68,    69,    70,    71,    72,    73,    74,
      24,    76,    77,    78,    -1,    -1,    81,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    92,    93,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,   102,    -1,    53,
     105,    -1,    -1,   108,   109,    59,    60,    61,    62,    63,
      64,    65,    66,    67,    68,    69,    70,    71,    72,    73,
      74,    -1,    -1,    77,    78,    -1,    -1,    81,    -1,    83,
      84,    85,    86,    87,    88,    89,    24,    -1,    26,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
     104,    -1,    -1,    -1,    -1,   109,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    53,    -1,    -1,    -1,    -1,
      -1,    59,    60,    61,    62,    63,    64,    65,    66,    67,
      68,    69,    70,    71,    72,    73,    74,    24,    -1,    77,
      78,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    90,    91,    -1,    -1,    -1,    -1,    -1,    -1,
      98,    99,   100,   101,    24,    -1,    53,    -1,    -1,    -1,
      -1,   109,    59,    60,    61,    62,    63,    64,    65,    66,
      67,    68,    69,    70,    71,    72,    73,    74,    75,    -1,
      77,    78,    -1,    53,    81,    -1,    -1,    -1,    -1,    59,
      60,    61,    62,    63,    64,    65,    66,    67,    68,    69,
      70,    71,    72,    73,    74,   102,    24,    77,    78,    -1,
      -1,    81,   109,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,   102,    -1,    -1,    53,    -1,    -1,    -1,   109,
      -1,    59,    60,    61,    62,    63,    64,    65,    66,    67,
      68,    69,    70,    71,    72,    73,    74,    -1,    -1,    77,
      78,    -1,    -1,    81,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,   109
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint16 yystos[] =
{
       0,   135,   136,   137,     0,   136,     3,     4,     5,     6,
       7,     8,    12,    13,    14,    15,    16,    18,    19,    20,
      22,    23,    24,    28,    42,    43,    44,    45,    46,    47,
      48,    49,    50,    51,    52,    53,    59,    60,    61,    62,
      63,    64,    65,    66,    67,    68,    69,    70,    71,    72,
      73,    74,    76,    77,    78,    81,    92,    93,    94,    95,
      96,    97,   102,   105,   108,   109,   110,   111,   138,   139,
     140,   141,   142,   143,   146,   148,   154,   157,   161,   162,
     163,   167,   170,   171,   172,   173,   174,   175,   176,   177,
     180,   181,   182,   186,   187,   188,   189,   200,   202,   203,
     204,   205,   206,   207,   208,   209,   212,   226,   227,   230,
     231,   234,   236,   237,   254,   272,   273,   277,    24,    26,
      24,    21,   210,   211,   210,    25,   210,   210,   210,   210,
     210,   210,   210,    53,   277,   115,    24,    25,    25,    25,
     210,   210,   210,    24,    25,   178,   178,   226,   226,    62,
      24,   215,    65,    60,    61,    62,    65,   277,   273,    24,
     164,   158,    24,   123,   258,   273,   226,   127,   178,   178,
     178,    79,   127,    20,   235,    24,   102,   276,    90,    21,
      23,    25,   214,   226,   258,    24,   117,   168,   169,   215,
     238,   232,   258,    62,   276,    24,   115,   155,   112,   112,
      24,   259,   260,   115,   115,   144,   273,   278,    90,   179,
     227,   278,   277,   237,   115,   258,   115,   117,   118,   120,
     121,   122,   123,   124,   125,   126,   127,   128,   130,   132,
     133,   255,   122,   124,   275,   210,   147,    24,    80,   116,
     118,   129,   240,   240,   213,   275,   258,   276,   112,    24,
     165,   166,    24,   159,   160,   120,   119,   123,    83,    84,
      85,    86,    87,    88,    89,   104,   264,   265,   266,   273,
     274,   226,   258,   119,   128,   128,   149,   264,   114,   116,
     120,   120,   115,   120,   120,   120,   120,   120,   120,   120,
     127,   120,   128,   131,   120,   120,   115,   112,   150,    24,
     117,   215,   226,   241,   242,   258,   258,   112,   114,    24,
     139,   156,   236,   113,   166,   113,   160,    24,    26,    90,
     178,   261,   260,   215,   215,   215,   215,   215,   115,   115,
     215,   116,   119,   215,   120,   221,   116,   112,   273,   150,
     116,     9,   183,   273,   120,   120,   264,    39,    40,    82,
     151,   152,   153,   189,   212,    24,   119,   239,   233,    24,
     167,   170,   216,   217,   218,   116,   113,   139,   129,   258,
     258,   258,   258,   258,   264,   264,   258,    81,   256,   266,
     258,   117,   118,   121,   126,   222,   224,   225,   189,   190,
     256,   210,    10,   184,   116,   116,   210,   210,   273,   113,
     152,   242,   112,   243,   243,   120,   220,   113,   218,   115,
     114,   179,   221,   221,   221,   116,   116,   103,   279,   118,
     121,   122,   123,   124,   125,   223,    26,    90,    91,    98,
      99,   100,   101,   226,   228,   277,   106,   145,   279,   210,
      11,   185,   114,   256,    24,   114,    17,    24,    29,    30,
      31,    32,    33,    34,    35,    36,    37,    40,    41,    54,
      55,    56,    57,    75,    82,   107,   143,   154,   167,   170,
     189,   191,   192,   193,   194,   195,   196,   197,   198,   199,
     201,   212,   230,   231,   237,   244,   245,   247,   248,   250,
     253,   254,   267,   269,   270,   272,   114,   114,   225,   258,
     114,   278,   118,   215,   215,   115,   120,   257,   225,   115,
     210,   113,   257,   210,   279,   115,   210,   115,   210,   210,
     210,   210,   210,   210,   210,   210,   210,   210,   210,    58,
     246,   246,   246,   129,   271,   268,   249,   113,   245,   126,
     119,   219,   116,   179,   258,   258,   226,   280,    90,   258,
     222,   229,   114,   258,   257,   264,   264,   129,   129,   129,
     254,   273,    75,   269,    24,   250,    24,   258,   116,   119,
     130,   252,   116,   119,   252,   258,   116,   116,    24,   115,
     114,   226,   273,   114,   222,   114,   252,   256,   279,   116,
     115,    38,   262,   262,   114,   279,   258,   279,   264,   210,
      27,   263,   263,   262,   258,   130,   251,   257,   116,   210,
     263,   252,   115,   114,   258,   131,   114,   264,   262,   114,
     262,   116,   262,   131,   263
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
yy_stack_print (yytype_int16 *bottom, yytype_int16 *top)
#else
static void
yy_stack_print (bottom, top)
    yytype_int16 *bottom;
    yytype_int16 *top;
#endif
{
  YYFPRINTF (stderr, "Stack now");
  for (; bottom <= top; ++bottom)
    YYFPRINTF (stderr, " %d", *bottom);
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
      fprintf (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr, yyrhs[yyprhs[yyrule] + yyi],
		       &(yyvsp[(yyi + 1) - (yynrhs)])
		       		       );
      fprintf (stderr, "\n");
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



/* The look-ahead symbol.  */
int yychar;

/* The semantic value of the look-ahead symbol.  */
YYSTYPE yylval;

/* Number of syntax errors so far.  */
int yynerrs;



/*----------.
| yyparse.  |
`----------*/

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
  int yyn;
  int yyresult;
  /* Number of tokens to shift before error messages enabled.  */
  int yyerrstatus;
  /* Look-ahead token as an internal (translated) token number.  */
  int yytoken = 0;
#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

  /* Three stacks and their tools:
     `yyss': related to states,
     `yyvs': related to semantic values,
     `yyls': related to locations.

     Refer to the stacks thru separate pointers, to allow yyoverflow
     to reallocate them elsewhere.  */

  /* The state stack.  */
  yytype_int16 yyssa[YYINITDEPTH];
  yytype_int16 *yyss = yyssa;
  yytype_int16 *yyssp;

  /* The semantic value stack.  */
  YYSTYPE yyvsa[YYINITDEPTH];
  YYSTYPE *yyvs = yyvsa;
  YYSTYPE *yyvsp;



#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  YYSIZE_T yystacksize = YYINITDEPTH;

  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;


  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY;		/* Cause a token to be read.  */

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
	YYSTACK_RELOCATE (yyss);
	YYSTACK_RELOCATE (yyvs);

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

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     look-ahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to look-ahead token.  */
  yyn = yypact[yystate];
  if (yyn == YYPACT_NINF)
    goto yydefault;

  /* Not known => get a look-ahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid look-ahead symbol.  */
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

  if (yyn == YYFINAL)
    YYACCEPT;

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the look-ahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token unless it is eof.  */
  if (yychar != YYEOF)
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
#line 342 "parser.y"
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
    ;}
    break;

  case 22:
#line 377 "parser.y"
    {
            if (notSkipping())
                appendCodeBlock(&currentSpec->exphdrcode, (yyvsp[(1) - (1)].codeb));
        ;}
    break;

  case 23:
#line 381 "parser.y"
    {
            if (notSkipping())
                appendCodeBlock(&currentModule->hdrcode, (yyvsp[(1) - (1)].codeb));
        ;}
    break;

  case 24:
#line 385 "parser.y"
    {
            if (notSkipping())
                appendCodeBlock(&currentModule->cppcode, (yyvsp[(1) - (1)].codeb));
        ;}
    break;

  case 48:
#line 414 "parser.y"
    {
            if (notSkipping())
            {
                classDef *scope = currentScope();

                if (scope == NULL)
                    yyerror("%TypeHeaderCode can only be used in a namespace, class or mapped type");

                appendCodeBlock(&scope->iff->hdrcode, (yyvsp[(1) - (1)].codeb));
            }
        ;}
    break;

  case 49:
#line 427 "parser.y"
    {
            if (notSkipping())
            {
                if ((currentModule->encoding = convertEncoding((yyvsp[(2) - (2)].text))) == no_type)
                    yyerror("The value of %DefaultEncoding must be one of \"ASCII\", \"Latin-1\", \"UTF-8\" or \"None\"");
            }
        ;}
    break;

  case 50:
#line 436 "parser.y"
    {
            appendString(&currentSpec->plugins, (yyvsp[(2) - (2)].text));
        ;}
    break;

  case 51:
#line 441 "parser.y"
    {
            if (notSkipping())
            {
                apiVersionRangeDef *avd;

                if (findAPI(currentSpec, (yyvsp[(2) - (3)].text)) != NULL)
                    yyerror("The API name in the %API directive has already been defined");

                if ((yyvsp[(3) - (3)].number) < 1)
                    yyerror("The version number in the %API directive must be greater than or equal to 1");

                avd = sipMalloc(sizeof (apiVersionRangeDef));

                avd->api_name = cacheName(currentSpec, (yyvsp[(2) - (3)].text));
                avd->from = (yyvsp[(3) - (3)].number);
                avd->to = -1;

                avd->next = currentModule->api_versions;
                currentModule->api_versions = avd;

                if (inMainModule())
                    setIsUsedName(avd->api_name);
            }
        ;}
    break;

  case 52:
#line 467 "parser.y"
    {
            if (notSkipping())
            {
                exceptionDef *xd;
                const char *pyname;

                if (currentSpec->genc)
                    yyerror("%Exception not allowed in a C module");

                pyname = getPythonName(&(yyvsp[(4) - (9)].optflags), scopedNameTail((yyvsp[(2) - (9)].scpvalp)));

                checkAttributes(currentSpec, currentModule, NULL, NULL,
                        pyname, FALSE);

                xd = findException(currentSpec, (yyvsp[(2) - (9)].scpvalp), TRUE);

                if (xd->cd != NULL)
                    yyerror("%Exception name has already been seen as a class name - it must be defined before being used");

                if (xd->iff->module != NULL)
                    yyerror("The %Exception has already been defined");

                /* Complete the definition. */
                xd->iff->module = currentModule;
                xd->iff->hdrcode = (yyvsp[(6) - (9)].codeb);
                xd->pyname = pyname;
                xd->bibase = (yyvsp[(3) - (9)].exceptionbase).bibase;
                xd->base = (yyvsp[(3) - (9)].exceptionbase).base;
                xd->raisecode = (yyvsp[(7) - (9)].codeb);

                if (xd->bibase != NULL || xd->base != NULL)
                    xd->exceptionnr = currentModule->nrexceptions++;
            }
        ;}
    break;

  case 53:
#line 503 "parser.y"
    {
            (yyval.exceptionbase).bibase = NULL;
            (yyval.exceptionbase).base = NULL;
        ;}
    break;

  case 54:
#line 507 "parser.y"
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
        ;}
    break;

  case 55:
#line 581 "parser.y"
    {
            (yyval.codeb) = (yyvsp[(2) - (2)].codeb);
        ;}
    break;

  case 56:
#line 586 "parser.y"
    {
            if (notSkipping())
                currentMappedType = newMappedType(currentSpec, &(yyvsp[(2) - (3)].memArg), &(yyvsp[(3) - (3)].optflags));
        ;}
    break;

  case 58:
#line 592 "parser.y"
    {
            int a;

            if (currentSpec->genc)
                yyerror("%MappedType templates not allowed in a C module");

            /* Check the template arguments are basic types or simple names. */
            for (a = 0; a < (yyvsp[(1) - (3)].signature).nrArgs; ++a)
            {
                argDef *ad = &(yyvsp[(1) - (3)].signature).args[a];

                if (ad->atype == defined_type && ad->u.snd->next != NULL)
                    yyerror("%MappedType template arguments must be simple names");
            }

            if ((yyvsp[(3) - (3)].memArg).atype != template_type)
                yyerror("%MappedType template must map a template type");

            if (notSkipping())
            {
                mappedTypeTmplDef *mtt;
                ifaceFileDef *iff;

                /* Check a template hasn't already been provided. */
                for (mtt = currentSpec->mappedtypetemplates; mtt != NULL; mtt = mtt->next)
                    if (compareScopedNames(mtt->mt->type.u.td->fqname, (yyvsp[(3) - (3)].memArg).u.td->fqname) == 0 && sameTemplateSignature(&mtt->mt->type.u.td->types, &(yyvsp[(3) - (3)].memArg).u.td->types, TRUE))
                        yyerror("%MappedType template for this type has already been defined");

                (yyvsp[(3) - (3)].memArg).nrderefs = 0;
                (yyvsp[(3) - (3)].memArg).argflags = 0;

                mtt = sipMalloc(sizeof (mappedTypeTmplDef));

                mtt->sig = (yyvsp[(1) - (3)].signature);
                mtt->mt = allocMappedType(currentSpec, &(yyvsp[(3) - (3)].memArg));
                mtt->next = currentSpec->mappedtypetemplates;

                currentSpec->mappedtypetemplates = mtt;

                currentMappedType = mtt->mt;

                /* Create a dummy interface file. */
                iff = sipMalloc(sizeof (ifaceFileDef));
                iff->hdrcode = NULL;
                mtt->mt->iff = iff;
            }
        ;}
    break;

  case 60:
#line 641 "parser.y"
    {
            if (notSkipping())
            {
                if (currentMappedType->convfromcode == NULL)
                    yyerror("%MappedType must have a %ConvertFromTypeCode directive");

                if (currentMappedType->convtocode == NULL)
                    yyerror("%MappedType must have a %ConvertToTypeCode directive");

                currentMappedType = NULL;
            }
        ;}
    break;

  case 63:
#line 659 "parser.y"
    {
            if (notSkipping())
                appendCodeBlock(&currentMappedType->iff->hdrcode, (yyvsp[(1) - (1)].codeb));
        ;}
    break;

  case 64:
#line 663 "parser.y"
    {
            if (notSkipping())
            {
                if (currentMappedType -> convfromcode != NULL)
                    yyerror("%MappedType has more than one %ConvertFromTypeCode directive");

                currentMappedType -> convfromcode = (yyvsp[(2) - (2)].codeb);
            }
        ;}
    break;

  case 65:
#line 672 "parser.y"
    {
            if (notSkipping())
            {
                if (currentMappedType -> convtocode != NULL)
                    yyerror("%MappedType has more than one %ConvertToTypeCode directive");

                currentMappedType -> convtocode = (yyvsp[(2) - (2)].codeb);
            }
        ;}
    break;

  case 68:
#line 685 "parser.y"
    {
            if (notSkipping())
            {
                applyTypeFlags(currentModule, &(yyvsp[(2) - (12)].memArg), &(yyvsp[(9) - (12)].optflags));

                (yyvsp[(5) - (12)].signature).result = (yyvsp[(2) - (12)].memArg);

                newFunction(currentSpec, currentModule, NULL,
                        currentMappedType, 0, TRUE, FALSE, (yyvsp[(3) - (12)].text), &(yyvsp[(5) - (12)].signature), (yyvsp[(7) - (12)].number), FALSE,
                        &(yyvsp[(9) - (12)].optflags), (yyvsp[(12) - (12)].codeb), NULL, (yyvsp[(8) - (12)].throwlist), (yyvsp[(10) - (12)].optsignature));
            }
        ;}
    break;

  case 69:
#line 699 "parser.y"
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
        ;}
    break;

  case 70:
#line 720 "parser.y"
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
        ;}
    break;

  case 73:
#line 740 "parser.y"
    {
            qualDef *qd;

            for (qd = currentModule -> qualifiers; qd != NULL; qd = qd -> next)
                if (qd -> qtype == platform_qualifier)
                    yyerror("%Platforms has already been defined for this module");
        ;}
    break;

  case 74:
#line 747 "parser.y"
    {
            qualDef *qd;
            int nrneeded;

            /*
             * Check that exactly one platform in the set was
             * requested.
             */

            nrneeded = 0;

            for (qd = currentModule -> qualifiers; qd != NULL; qd = qd -> next)
                if (qd -> qtype == platform_qualifier && isNeeded(qd))
                    ++nrneeded;

            if (nrneeded > 1)
                yyerror("No more than one of these %Platforms must be specified with the -t flag");
        ;}
    break;

  case 77:
#line 771 "parser.y"
    {
            newQualifier(currentModule,-1,-1,(yyvsp[(1) - (1)].text),platform_qualifier);
        ;}
    break;

  case 78:
#line 776 "parser.y"
    {
            currentModule->virterrorhandler = (yyvsp[(2) - (2)].text);
        ;}
    break;

  case 79:
#line 781 "parser.y"
    {
            newQualifier(currentModule,-1,-1,(yyvsp[(2) - (2)].text),feature_qualifier);
        ;}
    break;

  case 80:
#line 786 "parser.y"
    {
            currentTimelineOrder = 0;
        ;}
    break;

  case 81:
#line 789 "parser.y"
    {
            qualDef *qd;
            int nrneeded;

            /*
             * Check that exactly one time slot in the set was
             * requested.
             */

            nrneeded = 0;

            for (qd = currentModule -> qualifiers; qd != NULL; qd = qd -> next)
                if (qd -> qtype == time_qualifier && isNeeded(qd))
                    ++nrneeded;

            if (nrneeded > 1)
                yyerror("At most one of this %Timeline must be specified with the -t flag");

            currentModule -> nrtimelines++;
        ;}
    break;

  case 84:
#line 815 "parser.y"
    {
            newQualifier(currentModule,currentModule -> nrtimelines,currentTimelineOrder++,(yyvsp[(1) - (1)].text),time_qualifier);
        ;}
    break;

  case 85:
#line 820 "parser.y"
    {
            if (skipStackPtr >= MAX_NESTED_IF)
                yyerror("Internal error: increase the value of MAX_NESTED_IF");

            /* Nested %Ifs are implicit logical ands. */

            if (skipStackPtr > 0)
                (yyvsp[(3) - (4)].boolean) = ((yyvsp[(3) - (4)].boolean) && skipStack[skipStackPtr - 1]);

            skipStack[skipStackPtr++] = (yyvsp[(3) - (4)].boolean);
        ;}
    break;

  case 86:
#line 833 "parser.y"
    {
            (yyval.boolean) = platOrFeature((yyvsp[(1) - (1)].text),FALSE);
        ;}
    break;

  case 87:
#line 836 "parser.y"
    {
            (yyval.boolean) = platOrFeature((yyvsp[(2) - (2)].text),TRUE);
        ;}
    break;

  case 88:
#line 839 "parser.y"
    {
            (yyval.boolean) = (platOrFeature((yyvsp[(3) - (3)].text),FALSE) || (yyvsp[(1) - (3)].boolean));
        ;}
    break;

  case 89:
#line 842 "parser.y"
    {
            (yyval.boolean) = (platOrFeature((yyvsp[(4) - (4)].text),TRUE) || (yyvsp[(1) - (4)].boolean));
        ;}
    break;

  case 91:
#line 848 "parser.y"
    {
            (yyval.boolean) = timePeriod((yyvsp[(1) - (3)].text),(yyvsp[(3) - (3)].text));
        ;}
    break;

  case 92:
#line 853 "parser.y"
    {
            if (skipStackPtr-- <= 0)
                yyerror("Too many %End directives");
        ;}
    break;

  case 93:
#line 859 "parser.y"
    {
            optFlag *of;

            if ((yyvsp[(2) - (2)].optflags).nrFlags == 0)
                yyerror("%License details not specified");

            if ((of = findOptFlag(&(yyvsp[(2) - (2)].optflags),"Type",string_flag)) == NULL)
                yyerror("%License type not specified");

            currentModule -> license = sipMalloc(sizeof (licenseDef));

            currentModule -> license -> type = of -> fvalue.sval;

            currentModule -> license -> licensee = 
                ((of = findOptFlag(&(yyvsp[(2) - (2)].optflags),"Licensee",string_flag)) != NULL)
                    ? of -> fvalue.sval : NULL;

            currentModule -> license -> timestamp = 
                ((of = findOptFlag(&(yyvsp[(2) - (2)].optflags),"Timestamp",string_flag)) != NULL)
                    ? of -> fvalue.sval : NULL;

            currentModule -> license -> sig = 
                ((of = findOptFlag(&(yyvsp[(2) - (2)].optflags),"Signature",string_flag)) != NULL)
                    ? of -> fvalue.sval : NULL;
        ;}
    break;

  case 94:
#line 886 "parser.y"
    {
            if (notSkipping())
            {
                if (currentModule->defmetatype != NULL)
                    yyerror("%DefaultMetatype has already been defined for this module");

                currentModule->defmetatype = cacheName(currentSpec, (yyvsp[(2) - (2)].text));
            }
        ;}
    break;

  case 95:
#line 897 "parser.y"
    {
            if (notSkipping())
            {
                if (currentModule->defsupertype != NULL)
                    yyerror("%DefaultSupertype has already been defined for this module");

                currentModule->defsupertype = cacheName(currentSpec, (yyvsp[(2) - (2)].text));
            }
        ;}
    break;

  case 96:
#line 908 "parser.y"
    {
            /* Make sure this is the first mention of a module. */
            if (currentSpec->module != currentModule)
                yyerror("A %ConsolidatedModule cannot be %Imported");

            if (currentModule->fullname != NULL)
                yyerror("%ConsolidatedModule must appear before any %Module or %CModule directive");

            setModuleName(currentSpec, currentModule, (yyvsp[(2) - (2)].text));
            setIsConsolidated(currentModule);
        ;}
    break;

  case 97:
#line 921 "parser.y"
    {
            /* Make sure this is the first mention of a module. */
            if (currentSpec->module != currentModule)
                yyerror("A %CompositeModule cannot be %Imported");

            if (currentModule->fullname != NULL)
                yyerror("%CompositeModule must appear before any %Module or %CModule directive");

            setModuleName(currentSpec, currentModule, (yyvsp[(2) - (2)].text));
            setIsComposite(currentModule);
        ;}
    break;

  case 98:
#line 934 "parser.y"
    {
            /* Check the module hasn't already been defined. */

            moduleDef *mod;

            for (mod = currentSpec->modules; mod != NULL; mod = mod->next)
                if (mod->fullname != NULL && strcmp(mod->fullname->text, (yyvsp[(2) - (3)].text)) == 0)
                    yyerror("Module is already defined");

            /*
             * If we are in a container module then create a component module
             * and make it current.
             */
            if (isContainer(currentModule) || currentModule->container != NULL)
            {
                mod = allocModule();

                mod->file = currentContext.filename;
                mod->container = (isContainer(currentModule) ? currentModule : currentModule->container);

                currentModule = mod;
            }

            setModuleName(currentSpec, currentModule, (yyvsp[(2) - (3)].text));
            currentModule->version = (yyvsp[(3) - (3)].number);

            if (currentSpec->genc < 0)
                currentSpec->genc = (yyvsp[(1) - (3)].boolean);
            else if (currentSpec->genc != (yyvsp[(1) - (3)].boolean))
                yyerror("Cannot mix C and C++ modules");
        ;}
    break;

  case 99:
#line 967 "parser.y"
    {
            (yyval.boolean) = FALSE;
        ;}
    break;

  case 100:
#line 970 "parser.y"
    {
            (yyval.boolean) = TRUE;
        ;}
    break;

  case 102:
#line 976 "parser.y"
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
        ;}
    break;

  case 103:
#line 992 "parser.y"
    {
            (yyval.number) = -1;
        ;}
    break;

  case 105:
#line 998 "parser.y"
    {
            parseFile(NULL, (yyvsp[(2) - (2)].text), NULL, FALSE);
        ;}
    break;

  case 106:
#line 1003 "parser.y"
    {
            parseFile(NULL, (yyvsp[(2) - (2)].text), NULL, TRUE);
        ;}
    break;

  case 107:
#line 1008 "parser.y"
    {
            newImport((yyvsp[(2) - (2)].text));
        ;}
    break;

  case 108:
#line 1013 "parser.y"
    {
            (yyval.codeb) = NULL;
        ;}
    break;

  case 109:
#line 1016 "parser.y"
    {
            (yyval.codeb) = (yyvsp[(2) - (2)].codeb);
        ;}
    break;

  case 110:
#line 1021 "parser.y"
    {
            (yyval.codeb) = NULL;
        ;}
    break;

  case 111:
#line 1024 "parser.y"
    {
            (yyval.codeb) = (yyvsp[(2) - (2)].codeb);
        ;}
    break;

  case 112:
#line 1029 "parser.y"
    {
            (yyval.codeb) = NULL;
        ;}
    break;

  case 113:
#line 1032 "parser.y"
    {
            (yyval.codeb) = (yyvsp[(2) - (2)].codeb);
        ;}
    break;

  case 114:
#line 1037 "parser.y"
    {
            appendCodeBlock(&currentModule->copying, (yyvsp[(2) - (2)].codeb));
        ;}
    break;

  case 115:
#line 1042 "parser.y"
    {
            (yyval.codeb) = (yyvsp[(2) - (2)].codeb);
        ;}
    break;

  case 116:
#line 1047 "parser.y"
    {
            (yyval.codeb) = (yyvsp[(2) - (2)].codeb);
        ;}
    break;

  case 117:
#line 1052 "parser.y"
    {
            (yyval.codeb) = (yyvsp[(2) - (2)].codeb);
        ;}
    break;

  case 118:
#line 1057 "parser.y"
    {
            (yyval.codeb) = NULL;
        ;}
    break;

  case 120:
#line 1063 "parser.y"
    {
            (yyval.codeb) = (yyvsp[(2) - (2)].codeb);
        ;}
    break;

  case 121:
#line 1068 "parser.y"
    {
            (yyval.codeb) = (yyvsp[(2) - (2)].codeb);
        ;}
    break;

  case 122:
#line 1073 "parser.y"
    {
            (yyval.codeb) = (yyvsp[(2) - (2)].codeb);
        ;}
    break;

  case 123:
#line 1078 "parser.y"
    {
            (yyval.codeb) = (yyvsp[(2) - (2)].codeb);
        ;}
    break;

  case 124:
#line 1083 "parser.y"
    {
            (yyval.codeb) = (yyvsp[(2) - (2)].codeb);
        ;}
    break;

  case 125:
#line 1088 "parser.y"
    {
            (yyval.codeb) = (yyvsp[(2) - (2)].codeb);
        ;}
    break;

  case 126:
#line 1093 "parser.y"
    {
            (yyval.codeb) = (yyvsp[(2) - (2)].codeb);
        ;}
    break;

  case 127:
#line 1098 "parser.y"
    {
            (yyval.codeb) = (yyvsp[(2) - (2)].codeb);
        ;}
    break;

  case 128:
#line 1103 "parser.y"
    {
            (yyval.codeb) = (yyvsp[(2) - (2)].codeb);
        ;}
    break;

  case 129:
#line 1108 "parser.y"
    {
            (yyval.codeb) = (yyvsp[(2) - (2)].codeb);
        ;}
    break;

  case 130:
#line 1113 "parser.y"
    {
            (yyval.codeb) = (yyvsp[(2) - (2)].codeb);
        ;}
    break;

  case 131:
#line 1118 "parser.y"
    {
            if (notSkipping())
                appendCodeBlock(&currentModule->preinitcode, (yyvsp[(2) - (2)].codeb));
        ;}
    break;

  case 132:
#line 1124 "parser.y"
    {
            if (notSkipping())
                appendCodeBlock(&currentModule->initcode, (yyvsp[(2) - (2)].codeb));
        ;}
    break;

  case 133:
#line 1130 "parser.y"
    {
            if (notSkipping())
                appendCodeBlock(&currentModule->postinitcode, (yyvsp[(2) - (2)].codeb));
        ;}
    break;

  case 134:
#line 1136 "parser.y"
    {
            if (notSkipping())
                appendCodeBlock(&currentModule->unitcode, (yyvsp[(2) - (2)].codeb));
        ;}
    break;

  case 135:
#line 1142 "parser.y"
    {
            /*
             * This is a no-op and is retained for compatibility
             * until the last use of it (by SIP v3) can be removed
             * from PyQt.
             */
        ;}
    break;

  case 136:
#line 1151 "parser.y"
    {
            if (inMainModule())
                appendCodeBlock(&currentSpec -> docs,(yyvsp[(2) - (2)].codeb));
        ;}
    break;

  case 137:
#line 1157 "parser.y"
    {
            appendCodeBlock(&currentSpec -> docs,(yyvsp[(2) - (2)].codeb));
        ;}
    break;

  case 138:
#line 1162 "parser.y"
    {
            if (inMainModule())
                yywarning("%Makefile is ignored, please use the -b flag instead");
        ;}
    break;

  case 141:
#line 1172 "parser.y"
    {
            (yyval.codeb) = (yyvsp[(1) - (2)].codeb);

            append(&(yyval.codeb)->frag, (yyvsp[(2) - (2)].codeb)->frag);

            free((yyvsp[(2) - (2)].codeb)->frag);
            free((char *)(yyvsp[(2) - (2)].codeb)->filename);
            free((yyvsp[(2) - (2)].codeb));
        ;}
    break;

  case 142:
#line 1183 "parser.y"
    {
            if (notSkipping())
            {
                if (sectionFlags != 0 && (sectionFlags & ~(SECT_IS_PUBLIC | SECT_IS_PROT)) != 0)
                    yyerror("Class enums must be in the public or protected sections");

                currentEnum = newEnum(currentSpec, currentModule,
                        currentMappedType, (yyvsp[(2) - (3)].text), &(yyvsp[(3) - (3)].optflags), sectionFlags);
            }
        ;}
    break;

  case 144:
#line 1195 "parser.y"
    {
            (yyval.text) = NULL;
        ;}
    break;

  case 145:
#line 1198 "parser.y"
    {
            (yyval.text) = (yyvsp[(1) - (1)].text);
        ;}
    break;

  case 146:
#line 1203 "parser.y"
    {
            (yyval.text) = NULL;
        ;}
    break;

  case 147:
#line 1206 "parser.y"
    {
            (yyval.text) = (yyvsp[(1) - (1)].text);
        ;}
    break;

  case 154:
#line 1221 "parser.y"
    {
            if (notSkipping())
            {
                enumMemberDef *emd, **tail;

                /* Note that we don't use the assigned value. */
                emd = sipMalloc(sizeof (enumMemberDef));

                emd -> pyname = cacheName(currentSpec, getPythonName(&(yyvsp[(3) - (4)].optflags), (yyvsp[(1) - (4)].text)));
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
        ;}
    break;

  case 159:
#line 1257 "parser.y"
    {
            (yyval.valp) = NULL;
        ;}
    break;

  case 160:
#line 1260 "parser.y"
    {
            (yyval.valp) = (yyvsp[(2) - (2)].valp);
        ;}
    break;

  case 162:
#line 1266 "parser.y"
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
        ;}
    break;

  case 163:
#line 1284 "parser.y"
    {
            (yyval.qchar) = '-';
        ;}
    break;

  case 164:
#line 1287 "parser.y"
    {
            (yyval.qchar) = '+';
        ;}
    break;

  case 165:
#line 1290 "parser.y"
    {
            (yyval.qchar) = '*';
        ;}
    break;

  case 166:
#line 1293 "parser.y"
    {
            (yyval.qchar) = '/';
        ;}
    break;

  case 167:
#line 1296 "parser.y"
    {
            (yyval.qchar) = '&';
        ;}
    break;

  case 168:
#line 1299 "parser.y"
    {
            (yyval.qchar) = '|';
        ;}
    break;

  case 169:
#line 1304 "parser.y"
    {
            (yyval.qchar) = '\0';
        ;}
    break;

  case 170:
#line 1307 "parser.y"
    {
            (yyval.qchar) = '!';
        ;}
    break;

  case 171:
#line 1310 "parser.y"
    {
            (yyval.qchar) = '~';
        ;}
    break;

  case 172:
#line 1313 "parser.y"
    {
            (yyval.qchar) = '-';
        ;}
    break;

  case 173:
#line 1316 "parser.y"
    {
            (yyval.qchar) = '+';
        ;}
    break;

  case 174:
#line 1321 "parser.y"
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
        ;}
    break;

  case 176:
#line 1340 "parser.y"
    {
            if (currentSpec -> genc)
                yyerror("Scoped names are not allowed in a C module");

            appendScopedName(&(yyvsp[(1) - (3)].scpvalp),(yyvsp[(3) - (3)].scpvalp));
        ;}
    break;

  case 177:
#line 1348 "parser.y"
    {
            (yyval.scpvalp) = text2scopePart((yyvsp[(1) - (1)].text));
        ;}
    break;

  case 178:
#line 1353 "parser.y"
    {
            /*
             * We let the C++ compiler decide if the value is a valid one - no
             * point in building a full C++ parser here.
             */

            (yyval.value).vtype = scoped_value;
            (yyval.value).u.vscp = (yyvsp[(1) - (1)].scpvalp);
        ;}
    break;

  case 179:
#line 1362 "parser.y"
    {
            fcallDef *fcd;

            fcd = sipMalloc(sizeof (fcallDef));
            *fcd = (yyvsp[(3) - (4)].fcall);
            fcd -> type = (yyvsp[(1) - (4)].memArg);

            (yyval.value).vtype = fcall_value;
            (yyval.value).u.fcd = fcd;
        ;}
    break;

  case 180:
#line 1372 "parser.y"
    {
            (yyval.value).vtype = real_value;
            (yyval.value).u.vreal = (yyvsp[(1) - (1)].real);
        ;}
    break;

  case 181:
#line 1376 "parser.y"
    {
            (yyval.value).vtype = numeric_value;
            (yyval.value).u.vnum = (yyvsp[(1) - (1)].number);
        ;}
    break;

  case 182:
#line 1380 "parser.y"
    {
            (yyval.value).vtype = numeric_value;
            (yyval.value).u.vnum = 1;
        ;}
    break;

  case 183:
#line 1384 "parser.y"
    {
            (yyval.value).vtype = numeric_value;
            (yyval.value).u.vnum = 0;
        ;}
    break;

  case 184:
#line 1388 "parser.y"
    {
            (yyval.value).vtype = numeric_value;
            (yyval.value).u.vnum = 0;
        ;}
    break;

  case 185:
#line 1392 "parser.y"
    {
            (yyval.value).vtype = string_value;
            (yyval.value).u.vstr = (yyvsp[(1) - (1)].text);
        ;}
    break;

  case 186:
#line 1396 "parser.y"
    {
            (yyval.value).vtype = qchar_value;
            (yyval.value).u.vqchar = (yyvsp[(1) - (1)].qchar);
        ;}
    break;

  case 187:
#line 1402 "parser.y"
    {
            /* No values. */

            (yyval.fcall).nrArgs = 0;
        ;}
    break;

  case 188:
#line 1407 "parser.y"
    {
            /* The single or first expression. */

            (yyval.fcall).args[0] = (yyvsp[(1) - (1)].valp);
            (yyval.fcall).nrArgs = 1;
        ;}
    break;

  case 189:
#line 1413 "parser.y"
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
        ;}
    break;

  case 190:
#line 1431 "parser.y"
    {
            if (notSkipping())
            {
                applyTypeFlags(currentModule, &(yyvsp[(2) - (5)].memArg), &(yyvsp[(4) - (5)].optflags));
                newTypedef(currentSpec, currentModule, (yyvsp[(3) - (5)].text), &(yyvsp[(2) - (5)].memArg), &(yyvsp[(4) - (5)].optflags));
            }
        ;}
    break;

  case 191:
#line 1438 "parser.y"
    {
            if (notSkipping())
            {
                signatureDef *sig;
                argDef ftype;

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
        ;}
    break;

  case 192:
#line 1463 "parser.y"
    {
            if (currentSpec -> genc && (yyvsp[(2) - (2)].scpvalp)->next != NULL)
                yyerror("Namespaces not allowed in a C module");

            if (notSkipping())
                currentSupers = NULL;
        ;}
    break;

  case 193:
#line 1469 "parser.y"
    {
            if (notSkipping())
            {
                if (currentSpec->genc && currentSupers != NULL)
                    yyerror("Super-classes not allowed in a C module struct");

                defineClass((yyvsp[(2) - (5)].scpvalp), currentSupers, &(yyvsp[(5) - (5)].optflags));
                sectionFlags = SECT_IS_PUBLIC;
            }
        ;}
    break;

  case 194:
#line 1478 "parser.y"
    {
            if (notSkipping())
                completeClass((yyvsp[(2) - (8)].scpvalp), &(yyvsp[(5) - (8)].optflags), (yyvsp[(7) - (8)].boolean));
        ;}
    break;

  case 195:
#line 1484 "parser.y"
    {currentIsTemplate = TRUE;;}
    break;

  case 196:
#line 1484 "parser.y"
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
        ;}
    break;

  case 197:
#line 1510 "parser.y"
    {
            (yyval.signature) = (yyvsp[(3) - (4)].signature);
        ;}
    break;

  case 198:
#line 1515 "parser.y"
    {
            if (currentSpec->genc)
                yyerror("Class definition not allowed in a C module");

            if (notSkipping())
                currentSupers = NULL;
        ;}
    break;

  case 199:
#line 1521 "parser.y"
    {
            if (notSkipping())
            {
                defineClass((yyvsp[(2) - (5)].scpvalp), currentSupers, &(yyvsp[(5) - (5)].optflags));
                sectionFlags = SECT_IS_PRIVATE;
            }
        ;}
    break;

  case 200:
#line 1527 "parser.y"
    {
            if (notSkipping())
                (yyval.klass) = completeClass((yyvsp[(2) - (8)].scpvalp), &(yyvsp[(5) - (8)].optflags), (yyvsp[(7) - (8)].boolean));
        ;}
    break;

  case 205:
#line 1541 "parser.y"
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
        ;}
    break;

  case 206:
#line 1580 "parser.y"
    {
            (yyval.boolean) = FALSE;
        ;}
    break;

  case 207:
#line 1583 "parser.y"
    {
            (yyval.boolean) = TRUE;
        ;}
    break;

  case 218:
#line 1600 "parser.y"
    {
            if (notSkipping())
                appendCodeBlock(&currentScope()->cppcode, (yyvsp[(1) - (1)].codeb));
        ;}
    break;

  case 219:
#line 1604 "parser.y"
    {
            if (notSkipping())
                appendCodeBlock(&currentScope()->iff->hdrcode, (yyvsp[(1) - (1)].codeb));
        ;}
    break;

  case 220:
#line 1608 "parser.y"
    {
            if (notSkipping())
            {
                classDef *scope = currentScope();

                if (scope->travcode != NULL)
                    yyerror("%GCTraverseCode already given for class");

                scope->travcode = (yyvsp[(1) - (1)].codeb);
            }
        ;}
    break;

  case 221:
#line 1619 "parser.y"
    {
            if (notSkipping())
            {
                classDef *scope = currentScope();

                if (scope->clearcode != NULL)
                    yyerror("%GCClearCode already given for class");

                scope->clearcode = (yyvsp[(1) - (1)].codeb);
            }
        ;}
    break;

  case 222:
#line 1630 "parser.y"
    {
            if (notSkipping())
            {
                classDef *scope = currentScope();

                if (scope->getbufcode != NULL)
                    yyerror("%BIGetBufferCode already given for class");

                scope->getbufcode = (yyvsp[(1) - (1)].codeb);
            }
        ;}
    break;

  case 223:
#line 1641 "parser.y"
    {
            if (notSkipping())
            {
                classDef *scope = currentScope();

                if (scope->releasebufcode != NULL)
                    yyerror("%BIReleaseBufferCode already given for class");

                scope->releasebufcode = (yyvsp[(1) - (1)].codeb);
            }
        ;}
    break;

  case 224:
#line 1652 "parser.y"
    {
            if (notSkipping())
            {
                classDef *scope = currentScope();

                if (scope->readbufcode != NULL)
                    yyerror("%BIGetReadBufferCode already given for class");

                scope->readbufcode = (yyvsp[(1) - (1)].codeb);
            }
        ;}
    break;

  case 225:
#line 1663 "parser.y"
    {
            if (notSkipping())
            {
                classDef *scope = currentScope();

                if (scope->writebufcode != NULL)
                    yyerror("%BIGetWriteBufferCode already given for class");

                scope->writebufcode = (yyvsp[(1) - (1)].codeb);
            }
        ;}
    break;

  case 226:
#line 1674 "parser.y"
    {
            if (notSkipping())
            {
                classDef *scope = currentScope();

                if (scope->segcountcode != NULL)
                    yyerror("%BIGetSegCountCode already given for class");

                scope->segcountcode = (yyvsp[(1) - (1)].codeb);
            }
        ;}
    break;

  case 227:
#line 1685 "parser.y"
    {
            if (notSkipping())
            {
                classDef *scope = currentScope();

                if (scope->charbufcode != NULL)
                    yyerror("%BIGetCharBufferCode already given for class");

                scope->charbufcode = (yyvsp[(1) - (1)].codeb);
            }
        ;}
    break;

  case 228:
#line 1696 "parser.y"
    {
            if (notSkipping())
            {
                classDef *scope = currentScope();

                if (scope->picklecode != NULL)
                    yyerror("%PickleCode already given for class");

                scope->picklecode = (yyvsp[(1) - (1)].codeb);
            }
        ;}
    break;

  case 232:
#line 1710 "parser.y"
    {
            if (notSkipping())
            {
                classDef *scope = currentScope();

                if (scope->convtosubcode != NULL)
                    yyerror("Class has more than one %ConvertToSubClassCode directive");

                scope->convtosubcode = (yyvsp[(2) - (2)].codeb);
            }
        ;}
    break;

  case 233:
#line 1721 "parser.y"
    {
            if (notSkipping())
            {
                classDef *scope = currentScope();

                if (scope->convtocode != NULL)
                    yyerror("Class has more than one %ConvertToTypeCode directive");

                scope->convtocode = (yyvsp[(2) - (2)].codeb);
            }
        ;}
    break;

  case 234:
#line 1732 "parser.y"
    {
            if (currentSpec -> genc)
                yyerror("public section not allowed in a C module");

            if (notSkipping())
                sectionFlags = SECT_IS_PUBLIC | (yyvsp[(2) - (3)].number);
        ;}
    break;

  case 235:
#line 1739 "parser.y"
    {
            if (currentSpec -> genc)
                yyerror("protected section not allowed in a C module");

            if (notSkipping())
                sectionFlags = SECT_IS_PROT | (yyvsp[(2) - (3)].number);
        ;}
    break;

  case 236:
#line 1746 "parser.y"
    {
            if (currentSpec -> genc)
                yyerror("private section not allowed in a C module");

            if (notSkipping())
                sectionFlags = SECT_IS_PRIVATE | (yyvsp[(2) - (3)].number);
        ;}
    break;

  case 237:
#line 1753 "parser.y"
    {
            if (currentSpec -> genc)
                yyerror("signals section not allowed in a C module");

            if (notSkipping())
                sectionFlags = SECT_IS_SIGNAL;
        ;}
    break;

  case 238:
#line 1762 "parser.y"
    {
            (yyval.number) = 0;
        ;}
    break;

  case 239:
#line 1765 "parser.y"
    {
            (yyval.number) = SECT_IS_SLOT;
        ;}
    break;

  case 240:
#line 1770 "parser.y"
    {
            /* Note that we allow non-virtual dtors in C modules. */

            if (notSkipping())
            {
                classDef *cd = currentScope();

                if (strcmp(classBaseName(cd),(yyvsp[(3) - (11)].text)) != 0)
                    yyerror("Destructor doesn't have the same name as its class");

                if (isDtor(cd))
                    yyerror("Destructor has already been defined");

                if (currentSpec -> genc && (yyvsp[(10) - (11)].codeb) == NULL)
                    yyerror("Destructor in C modules must include %MethodCode");

                cd -> dealloccode = (yyvsp[(10) - (11)].codeb);
                cd -> dtorcode = (yyvsp[(11) - (11)].codeb);
                cd -> dtorexceptions = (yyvsp[(6) - (11)].throwlist);
                cd -> classflags |= sectionFlags;

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
        ;}
    break;

  case 241:
#line 1819 "parser.y"
    {currentCtorIsExplicit = TRUE;;}
    break;

  case 244:
#line 1823 "parser.y"
    {
            /* Note that we allow ctors in C modules. */

            if (notSkipping())
            {
                if (currentSpec -> genc)
                {
                    if ((yyvsp[(9) - (9)].codeb) == NULL && (yyvsp[(3) - (9)].signature).nrArgs != 0)
                        yyerror("Constructors with arguments in C modules must include %MethodCode");

                    if (currentCtorIsExplicit)
                        yyerror("Explicit constructors not allowed in a C module");
                }

                if ((sectionFlags & (SECT_IS_PUBLIC | SECT_IS_PROT | SECT_IS_PRIVATE)) == 0)
                    yyerror("Constructor must be in the public, private or protected sections");

                newCtor((yyvsp[(1) - (9)].text),sectionFlags,&(yyvsp[(3) - (9)].signature),&(yyvsp[(6) - (9)].optflags),(yyvsp[(9) - (9)].codeb),(yyvsp[(5) - (9)].throwlist),(yyvsp[(7) - (9)].optsignature),currentCtorIsExplicit);
            }

            free((yyvsp[(1) - (9)].text));

            currentCtorIsExplicit = FALSE;
        ;}
    break;

  case 245:
#line 1849 "parser.y"
    {
            (yyval.optsignature) = NULL;
        ;}
    break;

  case 246:
#line 1852 "parser.y"
    {
            (yyval.optsignature) = sipMalloc(sizeof (signatureDef));

            *(yyval.optsignature) = (yyvsp[(3) - (5)].signature);
        ;}
    break;

  case 247:
#line 1859 "parser.y"
    {
            (yyval.optsignature) = NULL;
        ;}
    break;

  case 248:
#line 1862 "parser.y"
    {
            (yyval.optsignature) = sipMalloc(sizeof (signatureDef));

            *(yyval.optsignature) = (yyvsp[(4) - (6)].signature);
            (yyval.optsignature) -> result = (yyvsp[(2) - (6)].memArg);
        ;}
    break;

  case 249:
#line 1870 "parser.y"
    {
            (yyval.number) = FALSE;
        ;}
    break;

  case 250:
#line 1873 "parser.y"
    {
            (yyval.number) = TRUE;
        ;}
    break;

  case 251:
#line 1878 "parser.y"
    {
            if (notSkipping())
            {
                applyTypeFlags(currentModule, &(yyvsp[(1) - (13)].memArg), &(yyvsp[(9) - (13)].optflags));

                (yyvsp[(4) - (13)].signature).result = (yyvsp[(1) - (13)].memArg);

                newFunction(currentSpec, currentModule, currentScope(), NULL,
                        sectionFlags, currentIsStatic, currentOverIsVirt, (yyvsp[(2) - (13)].text),
                        &(yyvsp[(4) - (13)].signature), (yyvsp[(6) - (13)].number), (yyvsp[(8) - (13)].number), &(yyvsp[(9) - (13)].optflags), (yyvsp[(12) - (13)].codeb), (yyvsp[(13) - (13)].codeb), (yyvsp[(7) - (13)].throwlist), (yyvsp[(10) - (13)].optsignature));
            }

            currentIsStatic = FALSE;
            currentOverIsVirt = FALSE;
        ;}
    break;

  case 252:
#line 1893 "parser.y"
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
            currentOverIsVirt = FALSE;
        ;}
    break;

  case 253:
#line 1911 "parser.y"
    {
            if (notSkipping())
            {
                classDef *cd = currentScope();

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
                        sectionFlags, currentIsStatic, currentOverIsVirt, (yyvsp[(3) - (14)].text),
                        &(yyvsp[(5) - (14)].signature), (yyvsp[(7) - (14)].number), (yyvsp[(9) - (14)].number), &(yyvsp[(10) - (14)].optflags), (yyvsp[(13) - (14)].codeb), (yyvsp[(14) - (14)].codeb), (yyvsp[(8) - (14)].throwlist), (yyvsp[(11) - (14)].optsignature));
            }

            currentIsStatic = FALSE;
            currentOverIsVirt = FALSE;
        ;}
    break;

  case 254:
#line 1937 "parser.y"
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
                            sectionFlags, currentIsStatic, currentOverIsVirt,
                            sname, &(yyvsp[(4) - (13)].signature), (yyvsp[(6) - (13)].number), (yyvsp[(8) - (13)].number), &(yyvsp[(9) - (13)].optflags), (yyvsp[(12) - (13)].codeb), (yyvsp[(13) - (13)].codeb), (yyvsp[(7) - (13)].throwlist), (yyvsp[(10) - (13)].optsignature));
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
            currentOverIsVirt = FALSE;
        ;}
    break;

  case 255:
#line 2012 "parser.y"
    {(yyval.text) = "__add__";;}
    break;

  case 256:
#line 2013 "parser.y"
    {(yyval.text) = "__sub__";;}
    break;

  case 257:
#line 2014 "parser.y"
    {(yyval.text) = "__mul__";;}
    break;

  case 258:
#line 2015 "parser.y"
    {(yyval.text) = "__div__";;}
    break;

  case 259:
#line 2016 "parser.y"
    {(yyval.text) = "__mod__";;}
    break;

  case 260:
#line 2017 "parser.y"
    {(yyval.text) = "__and__";;}
    break;

  case 261:
#line 2018 "parser.y"
    {(yyval.text) = "__or__";;}
    break;

  case 262:
#line 2019 "parser.y"
    {(yyval.text) = "__xor__";;}
    break;

  case 263:
#line 2020 "parser.y"
    {(yyval.text) = "__lshift__";;}
    break;

  case 264:
#line 2021 "parser.y"
    {(yyval.text) = "__rshift__";;}
    break;

  case 265:
#line 2022 "parser.y"
    {(yyval.text) = "__iadd__";;}
    break;

  case 266:
#line 2023 "parser.y"
    {(yyval.text) = "__isub__";;}
    break;

  case 267:
#line 2024 "parser.y"
    {(yyval.text) = "__imul__";;}
    break;

  case 268:
#line 2025 "parser.y"
    {(yyval.text) = "__idiv__";;}
    break;

  case 269:
#line 2026 "parser.y"
    {(yyval.text) = "__imod__";;}
    break;

  case 270:
#line 2027 "parser.y"
    {(yyval.text) = "__iand__";;}
    break;

  case 271:
#line 2028 "parser.y"
    {(yyval.text) = "__ior__";;}
    break;

  case 272:
#line 2029 "parser.y"
    {(yyval.text) = "__ixor__";;}
    break;

  case 273:
#line 2030 "parser.y"
    {(yyval.text) = "__ilshift__";;}
    break;

  case 274:
#line 2031 "parser.y"
    {(yyval.text) = "__irshift__";;}
    break;

  case 275:
#line 2032 "parser.y"
    {(yyval.text) = "__invert__";;}
    break;

  case 276:
#line 2033 "parser.y"
    {(yyval.text) = "__call__";;}
    break;

  case 277:
#line 2034 "parser.y"
    {(yyval.text) = "__getitem__";;}
    break;

  case 278:
#line 2035 "parser.y"
    {(yyval.text) = "__lt__";;}
    break;

  case 279:
#line 2036 "parser.y"
    {(yyval.text) = "__le__";;}
    break;

  case 280:
#line 2037 "parser.y"
    {(yyval.text) = "__eq__";;}
    break;

  case 281:
#line 2038 "parser.y"
    {(yyval.text) = "__ne__";;}
    break;

  case 282:
#line 2039 "parser.y"
    {(yyval.text) = "__gt__";;}
    break;

  case 283:
#line 2040 "parser.y"
    {(yyval.text) = "__ge__";;}
    break;

  case 284:
#line 2043 "parser.y"
    {
            (yyval.number) = FALSE;
        ;}
    break;

  case 285:
#line 2046 "parser.y"
    {
            (yyval.number) = TRUE;
        ;}
    break;

  case 286:
#line 2051 "parser.y"
    {
            (yyval.number) = 0;
        ;}
    break;

  case 287:
#line 2054 "parser.y"
    {
            if ((yyvsp[(2) - (2)].number) != 0)
                yyerror("Abstract virtual function '= 0' expected");

            (yyval.number) = TRUE;
        ;}
    break;

  case 288:
#line 2062 "parser.y"
    {
            (yyval.optflags).nrFlags = 0;
        ;}
    break;

  case 289:
#line 2065 "parser.y"
    {
            (yyval.optflags) = (yyvsp[(2) - (3)].optflags);
        ;}
    break;

  case 290:
#line 2071 "parser.y"
    {
            (yyval.optflags).flags[0] = (yyvsp[(1) - (1)].flag);
            (yyval.optflags).nrFlags = 1;
        ;}
    break;

  case 291:
#line 2075 "parser.y"
    {
            /* Check there is room. */

            if ((yyvsp[(1) - (3)].optflags).nrFlags == MAX_NR_FLAGS)
                yyerror("Too many optional flags");

            (yyval.optflags) = (yyvsp[(1) - (3)].optflags);

            (yyval.optflags).flags[(yyval.optflags).nrFlags++] = (yyvsp[(3) - (3)].flag);
        ;}
    break;

  case 292:
#line 2087 "parser.y"
    {
            (yyval.flag).ftype = bool_flag;
            (yyval.flag).fname = (yyvsp[(1) - (1)].text);
        ;}
    break;

  case 293:
#line 2091 "parser.y"
    {
            (yyval.flag) = (yyvsp[(3) - (3)].flag);
            (yyval.flag).fname = (yyvsp[(1) - (3)].text);
        ;}
    break;

  case 294:
#line 2097 "parser.y"
    {
            (yyval.flag).ftype = (strchr((yyvsp[(1) - (1)].text), '.') != NULL) ? dotted_name_flag : name_flag;
            (yyval.flag).fvalue.sval = (yyvsp[(1) - (1)].text);
        ;}
    break;

  case 295:
#line 2101 "parser.y"
    {
            nameDef *name;
            int from, to;

            (yyval.flag).ftype = api_range_flag;

            /* Check that the API is known. */
            if ((name = findAPI(currentSpec, (yyvsp[(1) - (5)].text))) == NULL)
                yyerror("unknown API name in API annotation");

            if (inMainModule())
                setIsUsedName(name);

            /* Unbounded values are represented by 0. */
            if ((from = (yyvsp[(3) - (5)].number)) < 0)
                from = 0;

            if ((to = (yyvsp[(5) - (5)].number)) < 0)
                to = 0;

            (yyval.flag).fvalue.aval = convertAPIRange(currentModule, name, from, to);
        ;}
    break;

  case 296:
#line 2123 "parser.y"
    {
            (yyval.flag).ftype = string_flag;
            (yyval.flag).fvalue.sval = (yyvsp[(1) - (1)].text);
        ;}
    break;

  case 297:
#line 2127 "parser.y"
    {
            (yyval.flag).ftype = integer_flag;
            (yyval.flag).fvalue.ival = (yyvsp[(1) - (1)].number);
        ;}
    break;

  case 298:
#line 2133 "parser.y"
    {
            (yyval.codeb) = NULL;
        ;}
    break;

  case 299:
#line 2136 "parser.y"
    {
            (yyval.codeb) = (yyvsp[(2) - (2)].codeb);
        ;}
    break;

  case 300:
#line 2141 "parser.y"
    {
            (yyval.codeb) = NULL;
        ;}
    break;

  case 301:
#line 2144 "parser.y"
    {
            (yyval.codeb) = (yyvsp[(2) - (2)].codeb);
        ;}
    break;

  case 302:
#line 2149 "parser.y"
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
        ;}
    break;

  case 303:
#line 2197 "parser.y"
    {
            /* No arguments. */

            (yyval.signature).nrArgs = 0;
        ;}
    break;

  case 304:
#line 2202 "parser.y"
    {
            /* The single or first argument. */

            (yyval.signature).args[0] = (yyvsp[(1) - (1)].memArg);
            (yyval.signature).nrArgs = 1;
        ;}
    break;

  case 305:
#line 2208 "parser.y"
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
        ;}
    break;

  case 306:
#line 2235 "parser.y"
    {
            (yyval.memArg).atype = signal_type;
            (yyval.memArg).argflags = ARG_IS_CONST;
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).name = (yyvsp[(2) - (4)].text);
            (yyval.memArg).defval = (yyvsp[(4) - (4)].valp);

            currentSpec -> sigslots = TRUE;
        ;}
    break;

  case 307:
#line 2244 "parser.y"
    {
            (yyval.memArg).atype = slot_type;
            (yyval.memArg).argflags = ARG_IS_CONST;
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).name = (yyvsp[(2) - (4)].text);
            (yyval.memArg).defval = (yyvsp[(4) - (4)].valp);

            currentSpec -> sigslots = TRUE;
        ;}
    break;

  case 308:
#line 2253 "parser.y"
    {
            (yyval.memArg).atype = anyslot_type;
            (yyval.memArg).argflags = ARG_IS_CONST;
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).name = (yyvsp[(2) - (4)].text);
            (yyval.memArg).defval = (yyvsp[(4) - (4)].valp);

            currentSpec -> sigslots = TRUE;
        ;}
    break;

  case 309:
#line 2262 "parser.y"
    {
            (yyval.memArg).atype = rxcon_type;
            (yyval.memArg).argflags = 0;
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).name = (yyvsp[(2) - (3)].text);

            if (findOptFlag(&(yyvsp[(3) - (3)].optflags), "SingleShot", bool_flag) != NULL)
                (yyval.memArg).argflags |= ARG_SINGLE_SHOT;

            currentSpec -> sigslots = TRUE;
        ;}
    break;

  case 310:
#line 2273 "parser.y"
    {
            (yyval.memArg).atype = rxdis_type;
            (yyval.memArg).argflags = 0;
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).name = (yyvsp[(2) - (3)].text);

            currentSpec -> sigslots = TRUE;
        ;}
    break;

  case 311:
#line 2281 "parser.y"
    {
            (yyval.memArg).atype = slotcon_type;
            (yyval.memArg).argflags = ARG_IS_CONST;
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).name = (yyvsp[(5) - (6)].text);

            (yyvsp[(3) - (6)].signature).result.atype = void_type;
            (yyvsp[(3) - (6)].signature).result.argflags = 0;
            (yyvsp[(3) - (6)].signature).result.nrderefs = 0;

            (yyval.memArg).u.sa = sipMalloc(sizeof (signatureDef));
            *(yyval.memArg).u.sa = (yyvsp[(3) - (6)].signature);

            currentSpec -> sigslots = TRUE;
        ;}
    break;

  case 312:
#line 2296 "parser.y"
    {
            (yyval.memArg).atype = slotdis_type;
            (yyval.memArg).argflags = ARG_IS_CONST;
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).name = (yyvsp[(5) - (6)].text);

            (yyvsp[(3) - (6)].signature).result.atype = void_type;
            (yyvsp[(3) - (6)].signature).result.argflags = 0;
            (yyvsp[(3) - (6)].signature).result.nrderefs = 0;

            (yyval.memArg).u.sa = sipMalloc(sizeof (signatureDef));
            *(yyval.memArg).u.sa = (yyvsp[(3) - (6)].signature);

            currentSpec -> sigslots = TRUE;
        ;}
    break;

  case 313:
#line 2311 "parser.y"
    {
            (yyval.memArg).atype = qobject_type;
            (yyval.memArg).argflags = 0;
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).name = (yyvsp[(2) - (3)].text);
        ;}
    break;

  case 314:
#line 2317 "parser.y"
    {
            (yyval.memArg) = (yyvsp[(1) - (2)].memArg);
            (yyval.memArg).defval = (yyvsp[(2) - (2)].valp);
        ;}
    break;

  case 315:
#line 2323 "parser.y"
    {currentIsStatic = TRUE;;}
    break;

  case 320:
#line 2331 "parser.y"
    {currentOverIsVirt = TRUE;;}
    break;

  case 323:
#line 2335 "parser.y"
    {
            if (notSkipping())
            {
                /* Check the section. */

                if (sectionFlags != 0)
                {
                    if ((sectionFlags & SECT_IS_PUBLIC) == 0)
                        yyerror("Class variables must be in the public section");

                    if (!currentIsStatic && (yyvsp[(5) - (7)].codeb) != NULL)
                        yyerror("%AccessCode cannot be specified for non-static class variables");
                }

                if (currentIsStatic && currentSpec -> genc)
                    yyerror("Cannot have static members in a C structure");

                applyTypeFlags(currentModule, &(yyvsp[(1) - (7)].memArg), &(yyvsp[(3) - (7)].optflags));

                if ((yyvsp[(6) - (7)].codeb) != NULL || (yyvsp[(7) - (7)].codeb) != NULL)
                {
                    if ((yyvsp[(5) - (7)].codeb) != NULL)
                        yyerror("Cannot mix %AccessCode and %GetCode or %SetCode");

                    if (currentScope() == NULL)
                        yyerror("Cannot specify %GetCode or %SetCode for global variables");
                }

                newVar(currentSpec,currentModule,(yyvsp[(2) - (7)].text),currentIsStatic,&(yyvsp[(1) - (7)].memArg),&(yyvsp[(3) - (7)].optflags),(yyvsp[(5) - (7)].codeb),(yyvsp[(6) - (7)].codeb),(yyvsp[(7) - (7)].codeb));
            }

            currentIsStatic = FALSE;
        ;}
    break;

  case 324:
#line 2370 "parser.y"
    {
            (yyval.memArg) = (yyvsp[(2) - (4)].memArg);
            (yyval.memArg).nrderefs += (yyvsp[(3) - (4)].number);
            (yyval.memArg).argflags |= ARG_IS_CONST | (yyvsp[(4) - (4)].number);
            (yyval.memArg).name = NULL;
        ;}
    break;

  case 325:
#line 2376 "parser.y"
    {
            (yyval.memArg) = (yyvsp[(1) - (3)].memArg);
            (yyval.memArg).nrderefs += (yyvsp[(2) - (3)].number);
            (yyval.memArg).argflags |= (yyvsp[(3) - (3)].number);
            (yyval.memArg).name = NULL;
        ;}
    break;

  case 326:
#line 2384 "parser.y"
    {
            (yyval.memArg) = (yyvsp[(1) - (3)].memArg);
            (yyval.memArg).name = (yyvsp[(2) - (3)].text);

            if (getAllowNone(&(yyvsp[(3) - (3)].optflags)))
                (yyval.memArg).argflags |= ARG_ALLOW_NONE;

            if (findOptFlag(&(yyvsp[(3) - (3)].optflags),"GetWrapper",bool_flag) != NULL)
                (yyval.memArg).argflags |= ARG_GET_WRAPPER;

            if (findOptFlag(&(yyvsp[(3) - (3)].optflags),"Array",bool_flag) != NULL)
                (yyval.memArg).argflags |= ARG_ARRAY;

            if (findOptFlag(&(yyvsp[(3) - (3)].optflags),"ArraySize",bool_flag) != NULL)
                (yyval.memArg).argflags |= ARG_ARRAY_SIZE;

            if (getTransfer(&(yyvsp[(3) - (3)].optflags)))
                (yyval.memArg).argflags |= ARG_XFERRED;

            if (findOptFlag(&(yyvsp[(3) - (3)].optflags),"TransferThis",bool_flag) != NULL)
                (yyval.memArg).argflags |= ARG_THIS_XFERRED;

            if (findOptFlag(&(yyvsp[(3) - (3)].optflags),"TransferBack",bool_flag) != NULL)
                (yyval.memArg).argflags |= ARG_XFERRED_BACK;

            if (findOptFlag(&(yyvsp[(3) - (3)].optflags), "KeepReference", bool_flag) != NULL)
            {
                (yyval.memArg).argflags |= ARG_KEEP_REF;
                (yyval.memArg).key = currentModule->next_key++;
            }

            if (findOptFlag(&(yyvsp[(3) - (3)].optflags),"In",bool_flag) != NULL)
                (yyval.memArg).argflags |= ARG_IN;

            if (findOptFlag(&(yyvsp[(3) - (3)].optflags),"Out",bool_flag) != NULL)
                (yyval.memArg).argflags |= ARG_OUT;

            if (findOptFlag(&(yyvsp[(3) - (3)].optflags), "ResultSize", bool_flag) != NULL)
                (yyval.memArg).argflags |= ARG_RESULT_SIZE;

            if (findOptFlag(&(yyvsp[(3) - (3)].optflags),"Constrained",bool_flag) != NULL)
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
        ;}
    break;

  case 327:
#line 2452 "parser.y"
    {
            (yyval.number) = 0;
        ;}
    break;

  case 328:
#line 2455 "parser.y"
    {
            if (currentSpec -> genc)
                yyerror("References not allowed in a C module");

            (yyval.number) = ARG_IS_REF;
        ;}
    break;

  case 329:
#line 2463 "parser.y"
    {
            (yyval.number) = 0;
        ;}
    break;

  case 330:
#line 2466 "parser.y"
    {
            (yyval.number) = (yyvsp[(1) - (2)].number) + 1;
        ;}
    break;

  case 331:
#line 2471 "parser.y"
    {
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).argflags = 0;
            (yyval.memArg).original_type = NULL;

            (yyval.memArg).atype = defined_type;
            (yyval.memArg).u.snd = (yyvsp[(1) - (1)].scpvalp);

            /* Try and resolve typedefs as early as possible. */
            resolveAnyTypedef(currentSpec, &(yyval.memArg));
        ;}
    break;

  case 332:
#line 2482 "parser.y"
    {
            templateDef *td;

            td = sipMalloc(sizeof(templateDef));
            td->fqname = (yyvsp[(1) - (4)].scpvalp);
            td->types = (yyvsp[(3) - (4)].signature);

            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).argflags = 0;
            (yyval.memArg).original_type = NULL;

            (yyval.memArg).atype = template_type;
            (yyval.memArg).u.td = td;
        ;}
    break;

  case 333:
#line 2496 "parser.y"
    {
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).argflags = 0;
            (yyval.memArg).original_type = NULL;

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
        ;}
    break;

  case 334:
#line 2513 "parser.y"
    {
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).argflags = 0;
            (yyval.memArg).original_type = NULL;

            (yyval.memArg).atype = ushort_type;
        ;}
    break;

  case 335:
#line 2520 "parser.y"
    {
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).argflags = 0;
            (yyval.memArg).original_type = NULL;

            (yyval.memArg).atype = short_type;
        ;}
    break;

  case 336:
#line 2527 "parser.y"
    {
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).argflags = 0;
            (yyval.memArg).original_type = NULL;

            (yyval.memArg).atype = uint_type;
        ;}
    break;

  case 337:
#line 2534 "parser.y"
    {
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).argflags = 0;
            (yyval.memArg).original_type = NULL;

            (yyval.memArg).atype = uint_type;
        ;}
    break;

  case 338:
#line 2541 "parser.y"
    {
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).argflags = 0;
            (yyval.memArg).original_type = NULL;

            (yyval.memArg).atype = int_type;
        ;}
    break;

  case 339:
#line 2548 "parser.y"
    {
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).argflags = 0;
            (yyval.memArg).original_type = NULL;

            (yyval.memArg).atype = long_type;
        ;}
    break;

  case 340:
#line 2555 "parser.y"
    {
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).argflags = 0;
            (yyval.memArg).original_type = NULL;

            (yyval.memArg).atype = ulong_type;
        ;}
    break;

  case 341:
#line 2562 "parser.y"
    {
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).argflags = 0;
            (yyval.memArg).original_type = NULL;

            (yyval.memArg).atype = longlong_type;
        ;}
    break;

  case 342:
#line 2569 "parser.y"
    {
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).argflags = 0;
            (yyval.memArg).original_type = NULL;

            (yyval.memArg).atype = ulonglong_type;
        ;}
    break;

  case 343:
#line 2576 "parser.y"
    {
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).argflags = 0;
            (yyval.memArg).original_type = NULL;

            (yyval.memArg).atype = float_type;
        ;}
    break;

  case 344:
#line 2583 "parser.y"
    {
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).argflags = 0;
            (yyval.memArg).original_type = NULL;

            (yyval.memArg).atype = double_type;
        ;}
    break;

  case 345:
#line 2590 "parser.y"
    {
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).argflags = 0;
            (yyval.memArg).original_type = NULL;

            (yyval.memArg).atype = bool_type;
        ;}
    break;

  case 346:
#line 2597 "parser.y"
    {
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).argflags = 0;
            (yyval.memArg).original_type = NULL;

            (yyval.memArg).atype = sstring_type;
        ;}
    break;

  case 347:
#line 2604 "parser.y"
    {
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).argflags = 0;
            (yyval.memArg).original_type = NULL;

            (yyval.memArg).atype = ustring_type;
        ;}
    break;

  case 348:
#line 2611 "parser.y"
    {
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).argflags = 0;
            (yyval.memArg).original_type = NULL;

            (yyval.memArg).atype = string_type;
        ;}
    break;

  case 349:
#line 2618 "parser.y"
    {
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).argflags = 0;
            (yyval.memArg).original_type = NULL;

            (yyval.memArg).atype = wstring_type;
        ;}
    break;

  case 350:
#line 2625 "parser.y"
    {
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).argflags = 0;
            (yyval.memArg).original_type = NULL;

            (yyval.memArg).atype = void_type;
        ;}
    break;

  case 351:
#line 2632 "parser.y"
    {
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).argflags = 0;
            (yyval.memArg).original_type = NULL;

            (yyval.memArg).atype = pyobject_type;
        ;}
    break;

  case 352:
#line 2639 "parser.y"
    {
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).argflags = 0;
            (yyval.memArg).original_type = NULL;

            (yyval.memArg).atype = pytuple_type;
        ;}
    break;

  case 353:
#line 2646 "parser.y"
    {
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).argflags = 0;
            (yyval.memArg).original_type = NULL;

            (yyval.memArg).atype = pylist_type;
        ;}
    break;

  case 354:
#line 2653 "parser.y"
    {
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).argflags = 0;
            (yyval.memArg).original_type = NULL;

            (yyval.memArg).atype = pydict_type;
        ;}
    break;

  case 355:
#line 2660 "parser.y"
    {
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).argflags = 0;
            (yyval.memArg).original_type = NULL;

            (yyval.memArg).atype = pycallable_type;
        ;}
    break;

  case 356:
#line 2667 "parser.y"
    {
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).argflags = 0;
            (yyval.memArg).original_type = NULL;

            (yyval.memArg).atype = pyslice_type;
        ;}
    break;

  case 357:
#line 2674 "parser.y"
    {
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).argflags = 0;
            (yyval.memArg).original_type = NULL;

            (yyval.memArg).atype = pytype_type;
        ;}
    break;

  case 358:
#line 2681 "parser.y"
    {
            (yyval.memArg).nrderefs = 0;
            (yyval.memArg).argflags = 0;
            (yyval.memArg).original_type = NULL;

            (yyval.memArg).atype = ellipsis_type;
        ;}
    break;

  case 359:
#line 2690 "parser.y"
    {
            /* The single or first type. */

            (yyval.signature).args[0] = (yyvsp[(1) - (1)].memArg);
            (yyval.signature).nrArgs = 1;
        ;}
    break;

  case 360:
#line 2696 "parser.y"
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
        ;}
    break;

  case 361:
#line 2712 "parser.y"
    {
            (yyval.throwlist) = NULL;
        ;}
    break;

  case 362:
#line 2715 "parser.y"
    {
            if (currentSpec->genc)
                yyerror("Exceptions not allowed in a C module");

            (yyval.throwlist) = (yyvsp[(3) - (4)].throwlist);
        ;}
    break;

  case 363:
#line 2723 "parser.y"
    {
            /* Empty list so use a blank. */

            (yyval.throwlist) = sipMalloc(sizeof (throwArgs));
            (yyval.throwlist) -> nrArgs = 0;
        ;}
    break;

  case 364:
#line 2729 "parser.y"
    {
            /* The only or first exception. */

            (yyval.throwlist) = sipMalloc(sizeof (throwArgs));
            (yyval.throwlist) -> nrArgs = 1;
            (yyval.throwlist) -> args[0] = findException(currentSpec, (yyvsp[(1) - (1)].scpvalp), FALSE);
        ;}
    break;

  case 365:
#line 2736 "parser.y"
    {
            /* Check that it wasn't ...(,arg...). */

            if ((yyvsp[(1) - (3)].throwlist) -> nrArgs == 0)
                yyerror("First exception of throw specifier is missing");

            /* Check there is room. */

            if ((yyvsp[(1) - (3)].throwlist) -> nrArgs == MAX_NR_ARGS)
                yyerror("Internal error - increase the value of MAX_NR_ARGS");

            (yyval.throwlist) = (yyvsp[(1) - (3)].throwlist);
            (yyval.throwlist) -> args[(yyval.throwlist) -> nrArgs++] = findException(currentSpec, (yyvsp[(3) - (3)].scpvalp), FALSE);
        ;}
    break;


/* Line 1267 of yacc.c.  */
#line 5547 "parser.c"
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
      /* If just tried and failed to reuse look-ahead token after an
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

  /* Else will try to reuse look-ahead token after shifting the error
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

  if (yyn == YYFINAL)
    YYACCEPT;

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

#ifndef yyoverflow
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEOF && yychar != YYEMPTY)
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


#line 2752 "parser.y"



/*
 * Parse the specification.
 */
void parse(sipSpec *spec, FILE *fp, char *filename, stringList *tsl,
        stringList *xfl)
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

    currentSpec = spec;
    neededQualifiers = tsl;
    excludedQualifiers = xfl;
    currentModule = NULL;
    currentMappedType = NULL;
    currentOverIsVirt = FALSE;
    currentCtorIsExplicit = FALSE;
    currentIsStatic = FALSE;
    currentIsTemplate = FALSE;
    previousFile = NULL;
    skipStackPtr = 0;
    currentScopeIdx = 0;
    sectionFlags = 0;

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
static void newModule(FILE *fp, char *filename)
{
    parseFile(fp, filename, currentModule, FALSE);
    currentModule = allocModule();
    currentModule->file = filename;
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
    newmod->next_key = 1;

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
static void parseFile(FILE *fp, char *name, moduleDef *prevmod, int optional)
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
    codeBlock *hdrcode;

    if (sectionFlags & SECT_IS_PRIVATE)
        yyerror("Classes, structs and namespaces must be in the public or protected sections");

    flags = 0;

    if ((scope = currentScope()) != NULL)
    {
        if (sectionFlags & SECT_IS_PROT)
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

    appendCodeBlock(&cd->iff->hdrcode, hdrcode);

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
static void finishClass(sipSpec *pt, moduleDef *mod, classDef *cd, optFlags *of)
{
    const char *pyname;
    optFlag *flg;

    /* Get the Python name and see if it is different to the C++ name. */
    pyname = getPythonName(of, classBaseName(cd));

    cd->pyname = NULL;
    checkAttributes(pt, mod, cd->ecd, NULL, pyname, FALSE);
    cd->pyname = cacheName(pt, pyname);

    if ((flg = findOptFlag(of, "Metatype", dotted_name_flag)) != NULL)
        cd->metatype = cacheName(pt, flg->fvalue.sval);

    if ((flg = findOptFlag(of, "Supertype", dotted_name_flag)) != NULL)
        cd->supertype = cacheName(pt, flg->fvalue.sval);

    if ((flg = findOptFlag(of, "PyQt4Flags", integer_flag)) != NULL)
        cd->pyqt4_flags = flg->fvalue.ival;

    if (findOptFlag(of, "PyQt4NoQMetaObject", bool_flag) != NULL)
        setPyQt4NoQMetaObject(cd);

    if (isOpaque(cd))
    {
        if (findOptFlag(of, "External", bool_flag) != NULL)
            setIsExternal(cd);
    }
    else
    {
        int seq_might, seq_not;
        memberDef *md;

        if (findOptFlag(of, "NoDefaultCtors", bool_flag) != NULL)
            setNoDefaultCtors(cd);

        if (cd -> ctors == NULL)
        {
            if (!noDefaultCtors(cd))
            {
                /* Provide a default ctor. */

                cd->ctors = sipMalloc(sizeof (ctorDef));
 
                cd->ctors->ctorflags = SECT_IS_PUBLIC;
                cd->ctors->pysig.nrArgs = 0;
                cd->ctors->cppsig = &cd -> ctors -> pysig;

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

        if (findOptFlag(of,"Abstract",bool_flag) != NULL)
        {
            setIsAbstractClass(cd);
            setIsIncomplete(cd);
            resetCanCreate(cd);
        }

        /* We assume a public dtor if nothing specific was provided. */
        if (!isDtor(cd))
            setIsPublicDtor(cd);

        if (findOptFlag(of, "DelayDtor", bool_flag) != NULL)
        {
            setIsDelayedDtor(cd);
            setHasDelayedDtors(mod);
        }

        if ((flg = findOptFlag(of,"VirtualErrorHandler",opt_name_flag)) != NULL)
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
        mtd->pyname = cacheName(pt, getPythonName(of, cname));

    if (findOptFlag(of, "NoRelease", bool_flag) != NULL)
        setNoRelease(mtd);

    if (getAllowNone(of))
        setHandlesNone(mtd);

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
 * Allocate, intialise and return a mapped type structure.
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
        ed->pyname = cacheName(pt, getPythonName(of, name));
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

        case ustring_type:
            s = "unsigned char";
            break;

        case ascii_string_type:
        case latin1_string_type:
        case utf8_string_type:
        case string_type:
            s = "char";
            break;

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
            s = "unsigned int";
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
            scope->iff->api_range, NULL);
    cd->iff->module = mod;

    /* Make a copy of the used list and add the enclosing scope. */
    used = &cd->iff->used;

    for (iffl = tcd->cd->iff->used; iffl != NULL; iffl = iffl->next)
        addToUsedList(used, iffl->iff);

    /* Include any scope header code. */
    if (scope != NULL)
        appendCodeBlock(&cd->iff->hdrcode, scope->iff->hdrcode);

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
codeBlock *templateCode(sipSpec *pt, ifaceFileList **used, codeBlock *ocb,
        scopedNameDef *names, scopedNameDef *values)
{
    codeBlock *ncb = NULL, **tail = &ncb;

    while (ocb != NULL)
    {
        char *at = ocb->frag;

        do
        {
            char *first = NULL;
            codeBlock *cb;
            scopedNameDef *nam, *val, *nam_first, *val_first;

            /*
             * Go through the rest of this fragment looking for each of the
             * types and the name of the class itself.
             */
            nam = names;
            val = values;

            while (nam != NULL && val != NULL)
            {
                char *cp;

                if ((cp = strstr(at, nam->name)) != NULL)
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

            if (at == ocb->frag)
            {
                cb->filename = ocb->filename;
                cb->linenr = ocb->linenr;
            }
            else
                cb->filename = NULL;

            cb->next = NULL;
            *tail = cb;
            tail = &cb->next;

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
                 * SIP generated object then translate any "::" scoping to "_".
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
            }
        }
        while (at != NULL && *at != '\0');

        ocb = ocb->next;
    }

    return ncb;
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
    typedefDef *td, **tdp;
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

    /*
     * Check it doesn't already exist and find the position in the sorted list
     * where it should be put.
     */
    for (tdp = &pt->typedefs; *tdp != NULL; tdp = &(*tdp)->next)
    {
        int res = compareScopedNames((*tdp)->fqname, fqname);

        if (res == 0)
        {
            fatalScopedName(fqname);
            fatal(" already defined\n");
        }

        if (res > 0)
            break;
    }

    td = sipMalloc(sizeof (typedefDef));

    td->tdflags = 0;
    td->fqname = fqname;
    td->ecd = scope;
    td->module = mod;
    td->type = *type;

    td->next = *tdp;
    *tdp = td;

    if (findOptFlag(optflgs, "NoTypeName", bool_flag) != NULL)
        setNoTypeName(td);

    mod->nrtypedefs++;
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
static void newVar(sipSpec *pt,moduleDef *mod,char *name,int isstatic,
           argDef *type,optFlags *of,codeBlock *acode,codeBlock *gcode,
           codeBlock *scode)
{
    varDef *var;
    classDef *escope = currentScope();
    nameDef *nd = cacheName(pt,getPythonName(of,name));

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
    var->accessfunc = acode;
    var->getcode = gcode;
    var->setcode = scode;

    if (isstatic || (escope != NULL && escope->iff->type == namespace_iface))
        setIsStaticVar(var);

    addVariable(pt, var);
}


/*
 * Create a new ctor.
 */
static void newCtor(char *name, int sectFlags, signatureDef *args,
        optFlags *optflgs, codeBlock *methodcode, throwArgs *exceptions,
        signatureDef *cppsig, int explicit)
{
    ctorDef *ct, **ctp;
    classDef *cd = currentScope();

    /* Check the name of the constructor. */
    if (strcmp(classBaseName(cd), name) != 0)
        yyerror("Constructor doesn't have the same name as its class");

    /* Add to the list of constructors. */
    ct = sipMalloc(sizeof (ctorDef));

    ct->ctorflags = sectFlags;
    ct->api_range = getAPIRange(optflgs);
    ct->pysig = *args;
    ct->cppsig = (cppsig != NULL ? cppsig : &ct->pysig);
    ct->exceptions = exceptions;
    ct->methodcode = methodcode;

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

    if (findOptFlag(optflgs, "NoDerived", bool_flag) != NULL)
    {
        if (cppsig != NULL)
            yyerror("The /NoDerived/ annotation cannot be used with a C++ signature");

        if (methodcode == NULL)
            yyerror("The /NoDerived/ annotation must be used with %MethodCode");

        ct->cppsig = NULL;
    }

    if (findOptFlag(optflgs, "Default", bool_flag) != NULL)
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
        mappedTypeDef *mt_scope, int sflags, int isstatic, int isvirt,
        char *name, signatureDef *sig, int isconst, int isabstract,
        optFlags *optflgs, codeBlock *methodcode, codeBlock *vcode,
        throwArgs *exceptions, signatureDef *cppsig)
{
    int factory, xferback, no_arg_parser;
    overDef *od, **odp, **headp;
    optFlag *of;
    virtHandlerDef *vhd;

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

    /* See if it is a factory method. */
    if (findOptFlag(optflgs, "Factory", bool_flag) != NULL)
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
    xferback = (findOptFlag(optflgs, "TransferBack", bool_flag) != NULL);

    if (factory && xferback)
        yyerror("/TransferBack/ and /Factory/ cannot both be specified");

    /* Create a new overload definition. */

    od = sipMalloc(sizeof (overDef));

    /* Set the overload flags. */

    od -> overflags = sflags;

    if (factory)
        setIsFactory(od);

    if (xferback)
        setIsResultTransferredBack(od);

    if (getTransfer(optflgs))
        setIsResultTransferred(od);

    if (findOptFlag(optflgs, "TransferThis", bool_flag) != NULL)
        setIsThisTransferredMeth(od);

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

    if ((of = findOptFlag(optflgs, "AutoGen", opt_name_flag)) != NULL)
    {
        setIsAutoGen(od);

        if (of->fvalue.sval != NULL)
        {
            qualDef *qd;

            if ((qd = findQualifier(of->fvalue.sval)) == NULL || qd->qtype != feature_qualifier)
                yyerror("No such feature");

            if (excludedFeature(excludedQualifiers, qd))
                resetIsAutoGen(od);
        }
    }

    of = findOptFlag(optflgs,"VirtualErrorHandler",opt_name_flag);
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
        vhd->virtcode = vcode;
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
    od->methodcode = methodcode;
    od->virthandler = vhd;

    no_arg_parser = (findOptFlag(optflgs, "NoArgParser", bool_flag) != NULL);

    if (no_arg_parser)
    {
        if (methodcode == NULL)
            yyerror("%MethodCode must be supplied if /NoArgParser/ is specified");
    }

    od->common = findFunction(pt, mod, c_scope, mt_scope,
            getPythonName(optflgs, name), (methodcode != NULL), sig->nrArgs,
            no_arg_parser);

    od->api_range = getAPIRange(optflgs);

    if (od->api_range == NULL)
        setNotVersioned(od->common);

    if (findOptFlag(optflgs, "Numeric", bool_flag) != NULL)
        setIsNumeric(od->common);

    /* Methods that run in new threads must be virtual. */
    if (findOptFlag(optflgs, "NewThread", bool_flag) != NULL)
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

    od -> next = NULL;

    /* Append to the list. */
    for (odp = headp; *odp != NULL; odp = &(*odp)->next)
        ;

    *odp = od;
}


/*
 * Return the Python name based on the C/C++ name and any /PyName/ annotation.
 */
static const char *getPythonName(optFlags *optflgs, const char *cname)
{
    const char *pname;
    optFlag *of;

    if ((of = findOptFlag(optflgs, "PyName", name_flag)) != NULL)
        pname = of -> fvalue.sval;
    else
        pname = cname;

    return pname;
}


/*
 * Cache a name in a module.  Entries in the cache are stored in order of
 * decreasing length.
 */
nameDef *cacheName(sipSpec *pt, const char *name)
{
    nameDef *nd, **ndp = &pt->namecache;
    size_t len = strlen(name);

    /* Skip entries that are too large. */
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
    if (mt_scope == NULL && c_scope == NULL && st != no_slot && st != neg_slot && st != pos_slot && !isNumberSlot(md) && !isRichCompareSlot(md))
        yyerror("Global operators must be either numeric or comparison operators");

    return md;
}


/*
 * Search a set of flags for a particular one and check its type.
 */
static optFlag *findOptFlag(optFlags *flgs,char *name,flagType ft)
{
    int f;

    for (f = 0; f < flgs -> nrFlags; ++f)
    {
        optFlag *of = &flgs -> flags[f];

        if (strcmp(of -> fname,name) == 0)
        {
            /*
             * An optional name can look like a boolean or a name.
             */

            if (ft == opt_name_flag)
            {
                if (of -> ftype == bool_flag)
                {
                    of -> ftype = opt_name_flag;
                    of -> fvalue.sval = NULL;
                }
                else if (of -> ftype == name_flag)
                    of -> ftype = opt_name_flag;
            }

            if (ft != of -> ftype)
                yyerror("Optional flag has a value of the wrong type");

            return of;
        }
    }

    return NULL;
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
}


/*
 * Append a code block to a list of them.  Append is needed to give the
 * specifier easy control over the order of the documentation.
 */
void appendCodeBlock(codeBlock **headp, codeBlock *new)
{
    while (*headp != NULL)
        headp = &(*headp)->next;

    *headp = new;
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
    moduleDef *imported_module = currentModule;

    /* Check it has been named. */
    if (currentModule->name == NULL)
        fatal("No %%Module has been specified for module defined in %s\n",
                previousFile);

    /* The previous module is now current. */
    currentModule = currentContext.prevmod;

    /* Import any defaults from the parsed module. */
    if (currentModule != NULL && currentModule->encoding == no_type)
        currentModule->encoding = imported_module->encoding;
}


/*
 * Find an existing qualifier.
 */
static qualDef *findQualifier(char *name)
{
    moduleDef *mod;

    for (mod = currentSpec->modules; mod != NULL; mod = mod->next)
    {
        qualDef *qd;

        for (qd = mod->qualifiers; qd != NULL; qd = qd->next)
            if (strcmp(qd->name, name) == 0)
                return qd;
    }

    return NULL;
}


/*
 * Find an existing API.
 */
static nameDef *findAPI(sipSpec *pt, const char *name)
{
    moduleDef *mod;

    for (mod = pt->modules; mod != NULL; mod = mod->next)
    {
        apiVersionRangeDef *avd;

        for (avd = mod->api_versions; avd != NULL; avd = avd->next)
            if (strcmp(avd->api_name->text, name) == 0)
                return avd->api_name;
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
static int timePeriod(char *lname,char *uname)
{
    int this, line;
    qualDef *qd, *lower, *upper;
    moduleDef *mod;

    if (lname == NULL)
        lower = NULL;
    else if ((lower = findQualifier(lname)) == NULL || lower -> qtype != time_qualifier)
        yyerror("Lower bound is not a time version");

    if (uname == NULL)
        upper = NULL;
    else if ((upper = findQualifier(uname)) == NULL || upper -> qtype != time_qualifier)
        yyerror("Upper bound is not a time version");

    /* Sanity checks on the bounds. */

    if (lower == NULL && upper == NULL)
        yyerror("Lower and upper bounds cannot both be omitted");

    if (lower != NULL && upper != NULL)
    {
        if (lower -> module != upper -> module || lower -> line != upper -> line)
            yyerror("Lower and upper bounds are from different timelines");

        if (lower == upper)
            yyerror("Lower and upper bounds must be different");

        if (lower -> order > upper -> order)
            yyerror("Later version specified as lower bound");
    }

    /* Go through each slot in the relevant timeline. */

    if (lower != NULL)
    {
        mod = lower -> module;
        line = lower -> line;
    }
    else
    {
        mod = upper -> module;
        line = upper -> line;
    }

    this = FALSE;

    for (qd = mod -> qualifiers; qd != NULL; qd = qd -> next)
    {
        if (qd -> qtype != time_qualifier || qd -> line != line)
            continue;

        if (lower != NULL && qd -> order < lower -> order)
            continue;

        if (upper != NULL && qd -> order >= upper -> order)
            continue;

        /*
         * This is within the required range so if it is also needed
         * then the expression is true.
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
static void newQualifier(moduleDef *mod, int line, int order, char *name,
        qualType qt)
{
    qualDef *qd;

    /* Check it doesn't already exist. */

    if (findQualifier(name) != NULL)
        yyerror("Version is already defined");

    qd = sipMalloc(sizeof (qualDef));
    qd->name = name;
    qd->qtype = qt;
    qd->module = mod;
    qd->line = line;
    qd->order = order;
    qd->next = mod -> qualifiers;
    mod->qualifiers = qd;
}


/*
 * Create a new imported module.
 */
static void newImport(char *filename)
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

    if ((of = findOptFlag(optflgs,"PreHook",name_flag)) != NULL)
        *pre = of -> fvalue.sval;
    else
        *pre = NULL;

    if ((of = findOptFlag(optflgs,"PostHook",name_flag)) != NULL)
        *post = of -> fvalue.sval;
    else
        *post = NULL;
}


/*
 * Get the /Transfer/ option flag.
 */
static int getTransfer(optFlags *optflgs)
{
    return (findOptFlag(optflgs, "Transfer", bool_flag) != NULL);
}


/*
 * Get the /ReleaseGIL/ option flag.
 */
static int getReleaseGIL(optFlags *optflgs)
{
    return (findOptFlag(optflgs, "ReleaseGIL", bool_flag) != NULL);
}


/*
 * Get the /HoldGIL/ option flag.
 */
static int getHoldGIL(optFlags *optflgs)
{
    return (findOptFlag(optflgs, "HoldGIL", bool_flag) != NULL);
}


/*
 * Get the /Deprecated/ option flag.
 */
static int getDeprecated(optFlags *optflgs)
{
    return (findOptFlag(optflgs, "Deprecated", bool_flag) != NULL);
}


/*
 * Get the /AllowNone/ option flag.
 */
static int getAllowNone(optFlags *optflgs)
{
    return (findOptFlag(optflgs, "AllowNone", bool_flag) != NULL);
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
    if (ad->atype == string_type && !isArray(ad) && !isReference(ad))
    {
        optFlag *of;

        if ((of = findOptFlag(flags, "Encoding", string_flag)) == NULL)
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

    if ((of = findOptFlag(optflgs, "API", api_range_flag)) == NULL)
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

