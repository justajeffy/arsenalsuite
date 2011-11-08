
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
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


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     TK_API = 258,
     TK_AUTOPYNAME = 259,
     TK_DEFDOCSTRING = 260,
     TK_DEFENCODING = 261,
     TK_PLUGIN = 262,
     TK_DOCSTRING = 263,
     TK_DOC = 264,
     TK_EXPORTEDDOC = 265,
     TK_EXTRACT = 266,
     TK_MAKEFILE = 267,
     TK_ACCESSCODE = 268,
     TK_GETCODE = 269,
     TK_SETCODE = 270,
     TK_PREINITCODE = 271,
     TK_INITCODE = 272,
     TK_POSTINITCODE = 273,
     TK_UNITCODE = 274,
     TK_UNITPOSTINCLUDECODE = 275,
     TK_MODCODE = 276,
     TK_TYPECODE = 277,
     TK_PREPYCODE = 278,
     TK_COPYING = 279,
     TK_MAPPEDTYPE = 280,
     TK_CODELINE = 281,
     TK_IF = 282,
     TK_END = 283,
     TK_NAME_VALUE = 284,
     TK_PATH_VALUE = 285,
     TK_STRING_VALUE = 286,
     TK_VIRTUALCATCHERCODE = 287,
     TK_VIRTERRORHANDLER = 288,
     TK_TRAVERSECODE = 289,
     TK_CLEARCODE = 290,
     TK_GETBUFFERCODE = 291,
     TK_RELEASEBUFFERCODE = 292,
     TK_READBUFFERCODE = 293,
     TK_WRITEBUFFERCODE = 294,
     TK_SEGCOUNTCODE = 295,
     TK_CHARBUFFERCODE = 296,
     TK_PICKLECODE = 297,
     TK_METHODCODE = 298,
     TK_FROMTYPE = 299,
     TK_TOTYPE = 300,
     TK_TOSUBCLASS = 301,
     TK_INCLUDE = 302,
     TK_OPTINCLUDE = 303,
     TK_IMPORT = 304,
     TK_EXPHEADERCODE = 305,
     TK_MODHEADERCODE = 306,
     TK_TYPEHEADERCODE = 307,
     TK_MODULE = 308,
     TK_CMODULE = 309,
     TK_CONSMODULE = 310,
     TK_COMPOMODULE = 311,
     TK_CLASS = 312,
     TK_STRUCT = 313,
     TK_PUBLIC = 314,
     TK_PROTECTED = 315,
     TK_PRIVATE = 316,
     TK_SIGNALS = 317,
     TK_SIGNAL_METHOD = 318,
     TK_SLOTS = 319,
     TK_SLOT_METHOD = 320,
     TK_BOOL = 321,
     TK_SHORT = 322,
     TK_INT = 323,
     TK_LONG = 324,
     TK_FLOAT = 325,
     TK_DOUBLE = 326,
     TK_CHAR = 327,
     TK_WCHAR_T = 328,
     TK_VOID = 329,
     TK_PYOBJECT = 330,
     TK_PYTUPLE = 331,
     TK_PYLIST = 332,
     TK_PYDICT = 333,
     TK_PYCALLABLE = 334,
     TK_PYSLICE = 335,
     TK_PYTYPE = 336,
     TK_VIRTUAL = 337,
     TK_ENUM = 338,
     TK_SIGNED = 339,
     TK_UNSIGNED = 340,
     TK_SCOPE = 341,
     TK_LOGICAL_OR = 342,
     TK_CONST = 343,
     TK_STATIC = 344,
     TK_SIPSIGNAL = 345,
     TK_SIPSLOT = 346,
     TK_SIPANYSLOT = 347,
     TK_SIPRXCON = 348,
     TK_SIPRXDIS = 349,
     TK_SIPSLOTCON = 350,
     TK_SIPSLOTDIS = 351,
     TK_SIPSSIZET = 352,
     TK_NUMBER_VALUE = 353,
     TK_REAL_VALUE = 354,
     TK_TYPEDEF = 355,
     TK_NAMESPACE = 356,
     TK_TIMELINE = 357,
     TK_PLATFORMS = 358,
     TK_FEATURE = 359,
     TK_LICENSE = 360,
     TK_QCHAR_VALUE = 361,
     TK_TRUE_VALUE = 362,
     TK_FALSE_VALUE = 363,
     TK_NULL_VALUE = 364,
     TK_OPERATOR = 365,
     TK_THROW = 366,
     TK_QOBJECT = 367,
     TK_EXCEPTION = 368,
     TK_RAISECODE = 369,
     TK_EXPLICIT = 370,
     TK_TEMPLATE = 371,
     TK_ELLIPSIS = 372,
     TK_DEFMETATYPE = 373,
     TK_DEFSUPERTYPE = 374,
     TK_PROPERTY = 375,
     TK_FORMAT = 376,
     TK_GET = 377,
     TK_ID = 378,
     TK_KWARGS = 379,
     TK_LANGUAGE = 380,
     TK_LICENSEE = 381,
     TK_NAME = 382,
     TK_OPTIONAL = 383,
     TK_ORDER = 384,
     TK_REMOVELEADING = 385,
     TK_SET = 386,
     TK_SIGNATURE = 387,
     TK_TIMESTAMP = 388,
     TK_TYPE = 389,
     TK_USEARGNAMES = 390,
     TK_VERSION = 391
   };
#endif
/* Tokens.  */
#define TK_API 258
#define TK_AUTOPYNAME 259
#define TK_DEFDOCSTRING 260
#define TK_DEFENCODING 261
#define TK_PLUGIN 262
#define TK_DOCSTRING 263
#define TK_DOC 264
#define TK_EXPORTEDDOC 265
#define TK_EXTRACT 266
#define TK_MAKEFILE 267
#define TK_ACCESSCODE 268
#define TK_GETCODE 269
#define TK_SETCODE 270
#define TK_PREINITCODE 271
#define TK_INITCODE 272
#define TK_POSTINITCODE 273
#define TK_UNITCODE 274
#define TK_UNITPOSTINCLUDECODE 275
#define TK_MODCODE 276
#define TK_TYPECODE 277
#define TK_PREPYCODE 278
#define TK_COPYING 279
#define TK_MAPPEDTYPE 280
#define TK_CODELINE 281
#define TK_IF 282
#define TK_END 283
#define TK_NAME_VALUE 284
#define TK_PATH_VALUE 285
#define TK_STRING_VALUE 286
#define TK_VIRTUALCATCHERCODE 287
#define TK_VIRTERRORHANDLER 288
#define TK_TRAVERSECODE 289
#define TK_CLEARCODE 290
#define TK_GETBUFFERCODE 291
#define TK_RELEASEBUFFERCODE 292
#define TK_READBUFFERCODE 293
#define TK_WRITEBUFFERCODE 294
#define TK_SEGCOUNTCODE 295
#define TK_CHARBUFFERCODE 296
#define TK_PICKLECODE 297
#define TK_METHODCODE 298
#define TK_FROMTYPE 299
#define TK_TOTYPE 300
#define TK_TOSUBCLASS 301
#define TK_INCLUDE 302
#define TK_OPTINCLUDE 303
#define TK_IMPORT 304
#define TK_EXPHEADERCODE 305
#define TK_MODHEADERCODE 306
#define TK_TYPEHEADERCODE 307
#define TK_MODULE 308
#define TK_CMODULE 309
#define TK_CONSMODULE 310
#define TK_COMPOMODULE 311
#define TK_CLASS 312
#define TK_STRUCT 313
#define TK_PUBLIC 314
#define TK_PROTECTED 315
#define TK_PRIVATE 316
#define TK_SIGNALS 317
#define TK_SIGNAL_METHOD 318
#define TK_SLOTS 319
#define TK_SLOT_METHOD 320
#define TK_BOOL 321
#define TK_SHORT 322
#define TK_INT 323
#define TK_LONG 324
#define TK_FLOAT 325
#define TK_DOUBLE 326
#define TK_CHAR 327
#define TK_WCHAR_T 328
#define TK_VOID 329
#define TK_PYOBJECT 330
#define TK_PYTUPLE 331
#define TK_PYLIST 332
#define TK_PYDICT 333
#define TK_PYCALLABLE 334
#define TK_PYSLICE 335
#define TK_PYTYPE 336
#define TK_VIRTUAL 337
#define TK_ENUM 338
#define TK_SIGNED 339
#define TK_UNSIGNED 340
#define TK_SCOPE 341
#define TK_LOGICAL_OR 342
#define TK_CONST 343
#define TK_STATIC 344
#define TK_SIPSIGNAL 345
#define TK_SIPSLOT 346
#define TK_SIPANYSLOT 347
#define TK_SIPRXCON 348
#define TK_SIPRXDIS 349
#define TK_SIPSLOTCON 350
#define TK_SIPSLOTDIS 351
#define TK_SIPSSIZET 352
#define TK_NUMBER_VALUE 353
#define TK_REAL_VALUE 354
#define TK_TYPEDEF 355
#define TK_NAMESPACE 356
#define TK_TIMELINE 357
#define TK_PLATFORMS 358
#define TK_FEATURE 359
#define TK_LICENSE 360
#define TK_QCHAR_VALUE 361
#define TK_TRUE_VALUE 362
#define TK_FALSE_VALUE 363
#define TK_NULL_VALUE 364
#define TK_OPERATOR 365
#define TK_THROW 366
#define TK_QOBJECT 367
#define TK_EXCEPTION 368
#define TK_RAISECODE 369
#define TK_EXPLICIT 370
#define TK_TEMPLATE 371
#define TK_ELLIPSIS 372
#define TK_DEFMETATYPE 373
#define TK_DEFSUPERTYPE 374
#define TK_PROPERTY 375
#define TK_FORMAT 376
#define TK_GET 377
#define TK_ID 378
#define TK_KWARGS 379
#define TK_LANGUAGE 380
#define TK_LICENSEE 381
#define TK_NAME 382
#define TK_OPTIONAL 383
#define TK_ORDER 384
#define TK_REMOVELEADING 385
#define TK_SET 386
#define TK_SIGNATURE 387
#define TK_TIMESTAMP 388
#define TK_TYPE 389
#define TK_USEARGNAMES 390
#define TK_VERSION 391




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 171 "/blur/cpp/lib/sip/sipgen/parser.y"

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
    defDocstringCfg defdocstring;
    defEncodingCfg  defencoding;
    defMetatypeCfg  defmetatype;
    defSupertypeCfg defsupertype;
    exceptionCfg    exception;
    docstringCfg    docstring;
    extractCfg      extract;
    featureCfg      feature;
    licenseCfg      license;
    importCfg       import;
    includeCfg      include;
    moduleCfg       module;
    pluginCfg       plugin;
    propertyCfg     property;
    variableCfg     variable;



/* Line 1676 of yacc.c  */
#line 366 "/blur/cpp/lib/sip/sipgen/parser.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


