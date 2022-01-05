{==============================================================================
  ____                   _
 / ___| _ __   __ _ _ __| | __
 \___ \| '_ \ / _` | '__| |/ /
  ___) | |_) | (_| | |  |   <
 |____/| .__/ \__,_|_|  |_|\_\
       |_|  Game Library™

Copyright © 2021-2022 tinyBigGAMES™ LLC
All Rights Reserved.

Website: https://tinybiggames.com
Email  : support@tinybiggames.com

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. The origin of this software must not be misrepresented; you must not
   claim that you wrote the original software. If you use this software in
   a product, an acknowledgment in the product documentation would be
   appreciated but is not required.

2. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.

3. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in
   the documentation and/or other materials provided with the
   distribution.

4. Neither the name of the copyright holder nor the names of its
   contributors may be used to endorse or promote products derived
   from this software without specific prior written permission.

5. All video, audio, graphics and other content accessed through the
   software in this distro is the property of the applicable content owner
   and may be protected by applicable copyright law. This License gives
   Customer no rights to such content, and Company disclaims any liability
   for misuse of content.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
============================================================================= }

{$IFNDEF WIN64}
  {$MESSAGE Error 'Unsupported platform'}
{$ENDIF}

{$Z4}
{$A8}

{$INLINE AUTO}

{$WARN SYMBOL_DEPRECATED OFF}
{$WARN SYMBOL_PLATFORM OFF}

{$WARN UNIT_PLATFORM OFF}
{$WARN UNIT_DEPRECATED OFF}

unit Spark;

interface

uses
  System.Generics.Collections,
  System.SysUtils,
  System.IOUtils,
  System.Classes,
  WinAPI.Windows,
  Spark.CLibs;

{ --- COMMON ---------------------------------------------------------------- }
const
  SPARK_VERSION = '1.0.alpha1';

  ID_NIL = -1;

  cPNGExt = '.png';
  cLOGExt = '.log';

type
  { THAlign }
  THAlign = (haLeft, haCenter, haRight);

  { TVAlign }
  TVAlign = (vaTop, vaCenter, vaBottom);

  { TLineIntersection }
  TLineIntersection = (liNone, liTrue, liParallel);

{ --- MATH ------------------------------------------------------------------ }
const
  // Degree/Radian conversion
  RAD2DEG = 180.0 / PI;
  DEG2RAD = PI / 180.0;

  { Misc }
  EPSILON = 0.00001;

type
  { TPointi }
  PPointi = ^TPointi;
  TPointi = record
    X, Y: Integer;
  end;

  { TPoint }
  PPointf = ^TPointi;
  TPointf = record
    X, Y: Single;
  end;

  { TRange }
  PRange = ^TRange;
  TRange = record
    MinX, MinY, MaxX, MaxY: Single;
  end;

  { TVector }
  PVector = ^TVector;
  TVector = record
    X,Y,Z: Single;
    constructor Create(aX: Single; aY: Single);
    procedure Assign(aX: Single; aY: Single); overload; inline;
    procedure Assign(aX: Single; aY: Single; aZ: Single); overload; inline;
    procedure Assign(aVector: TVector); overload; inline;
    procedure Clear; inline;
    procedure Add(aVector: TVector); inline;
    procedure Subtract(aVector: TVector); inline;
    procedure Multiply(aVector: TVector); inline;
    procedure Divide(aVector: TVector); inline;
    function  Magnitude: Single; inline;
    function  MagnitudeTruncate(aMaxMagitude: Single): TVector; inline;
    function  Distance(aVector: TVector): Single; inline;
    procedure Normalize; inline;
    function  Angle(aVector: TVector): Single; inline;
    procedure Thrust(aAngle: Single; aSpeed: Single); inline;
    function  MagnitudeSquared: Single; inline;
    function  DotProduct(aVector: TVector): Single; inline;
    procedure Scale(aValue: Single); inline;
    procedure DivideBy(aValue: Single); inline;
    function  Project(aVector: TVector): TVector; inline;
    procedure Negate; inline;
  end;

  { TRectangle }
  PRectangle = ^TRectangle;
  TRectangle = record
    X, Y, Width, Height: Single;
    constructor Create(aX: Single; aY: Single; aWidth: Single; aHeight: Single);
    procedure Assign(aX: Single; aY: Single; aWidth: Single; aHeight: Single); inline;
    function  Intersect(aRect: TRectangle): Boolean; inline;
  end;

{ --- COLOR ----------------------------------------------------------------- }
type
  { TColor }
  PColor = ^TColor;
  TColor = record
    Red, Green, Blue, Alpha: Single;
  end;

{$REGION 'Common Colors'}
const
  ALICEBLUE           : TColor = (Red:$F0/$FF; Green:$F8/$FF; Blue:$FF/$FF; Alpha:$FF/$FF);
  ANTIQUEWHITE        : TColor = (Red:$FA/$FF; Green:$EB/$FF; Blue:$D7/$FF; Alpha:$FF/$FF);
  AQUA                : TColor = (Red:$00/$FF; Green:$FF/$FF; Blue:$FF/$FF; Alpha:$FF/$FF);
  AQUAMARINE          : TColor = (Red:$7F/$FF; Green:$FF/$FF; Blue:$D4/$FF; Alpha:$FF/$FF);
  AZURE               : TColor = (Red:$F0/$FF; Green:$FF/$FF; Blue:$FF/$FF; Alpha:$FF/$FF);
  BEIGE               : TColor = (Red:$F5/$FF; Green:$F5/$FF; Blue:$DC/$FF; Alpha:$FF/$FF);
  BISQUE              : TColor = (Red:$FF/$FF; Green:$E4/$FF; Blue:$C4/$FF; Alpha:$FF/$FF);
  BLACK               : TColor = (Red:$00/$FF; Green:$00/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  BLANCHEDALMOND      : TColor = (Red:$FF/$FF; Green:$EB/$FF; Blue:$CD/$FF; Alpha:$FF/$FF);
  BLUE                : TColor = (Red:$00/$FF; Green:$00/$FF; Blue:$FF/$FF; Alpha:$FF/$FF);
  BLUEVIOLET          : TColor = (Red:$8A/$FF; Green:$2B/$FF; Blue:$E2/$FF; Alpha:$FF/$FF);
  BROWN               : TColor = (Red:$A5/$FF; Green:$2A/$FF; Blue:$2A/$FF; Alpha:$FF/$FF);
  BURLYWOOD           : TColor = (Red:$DE/$FF; Green:$B8/$FF; Blue:$87/$FF; Alpha:$FF/$FF);
  CADETBLUE           : TColor = (Red:$5F/$FF; Green:$9E/$FF; Blue:$A0/$FF; Alpha:$FF/$FF);
  CHARTREUSE          : TColor = (Red:$7F/$FF; Green:$FF/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  CHOCOLATE           : TColor = (Red:$D2/$FF; Green:$69/$FF; Blue:$1E/$FF; Alpha:$FF/$FF);
  CORAL               : TColor = (Red:$FF/$FF; Green:$7F/$FF; Blue:$50/$FF; Alpha:$FF/$FF);
  CORNFLOWERBLUE      : TColor = (Red:$64/$FF; Green:$95/$FF; Blue:$ED/$FF; Alpha:$FF/$FF);
  CORNSILK            : TColor = (Red:$FF/$FF; Green:$F8/$FF; Blue:$DC/$FF; Alpha:$FF/$FF);
  CRIMSON             : TColor = (Red:$DC/$FF; Green:$14/$FF; Blue:$3C/$FF; Alpha:$FF/$FF);
  CYAN                : TColor = (Red:$00/$FF; Green:$FF/$FF; Blue:$FF/$FF; Alpha:$FF/$FF);
  DARKBLUE            : TColor = (Red:$00/$FF; Green:$00/$FF; Blue:$8B/$FF; Alpha:$FF/$FF);
  DARKCYAN            : TColor = (Red:$00/$FF; Green:$8B/$FF; Blue:$8B/$FF; Alpha:$FF/$FF);
  DARKGOLDENROD       : TColor = (Red:$B8/$FF; Green:$86/$FF; Blue:$0B/$FF; Alpha:$FF/$FF);
  DARKGRAY            : TColor = (Red:$A9/$FF; Green:$A9/$FF; Blue:$A9/$FF; Alpha:$FF/$FF);
  DARKGREEN           : TColor = (Red:$00/$FF; Green:$64/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  DARKGREY            : TColor = (Red:$A9/$FF; Green:$A9/$FF; Blue:$A9/$FF; Alpha:$FF/$FF);
  DARKKHAKI           : TColor = (Red:$BD/$FF; Green:$B7/$FF; Blue:$6B/$FF; Alpha:$FF/$FF);
  DARKMAGENTA         : TColor = (Red:$8B/$FF; Green:$00/$FF; Blue:$8B/$FF; Alpha:$FF/$FF);
  DARKOLIVEGREEN      : TColor = (Red:$55/$FF; Green:$6B/$FF; Blue:$2F/$FF; Alpha:$FF/$FF);
  DARKORANGE          : TColor = (Red:$FF/$FF; Green:$8C/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  DARKORCHID          : TColor = (Red:$99/$FF; Green:$32/$FF; Blue:$CC/$FF; Alpha:$FF/$FF);
  DARKRED             : TColor = (Red:$8B/$FF; Green:$00/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  DARKSALMON          : TColor = (Red:$E9/$FF; Green:$96/$FF; Blue:$7A/$FF; Alpha:$FF/$FF);
  DARKSEAGREEN        : TColor = (Red:$8F/$FF; Green:$BC/$FF; Blue:$8F/$FF; Alpha:$FF/$FF);
  DARKSLATEBLUE       : TColor = (Red:$48/$FF; Green:$3D/$FF; Blue:$8B/$FF; Alpha:$FF/$FF);
  DARKSLATEGRAY       : TColor = (Red:$2F/$FF; Green:$4F/$FF; Blue:$4F/$FF; Alpha:$FF/$FF);
  DARKSLATEGREY       : TColor = (Red:$2F/$FF; Green:$4F/$FF; Blue:$4F/$FF; Alpha:$FF/$FF);
  DARKTURQUOISE       : TColor = (Red:$00/$FF; Green:$CE/$FF; Blue:$D1/$FF; Alpha:$FF/$FF);
  DARKVIOLET          : TColor = (Red:$94/$FF; Green:$00/$FF; Blue:$D3/$FF; Alpha:$FF/$FF);
  DEEPPINK            : TColor = (Red:$FF/$FF; Green:$14/$FF; Blue:$93/$FF; Alpha:$FF/$FF);
  DEEPSKYBLUE         : TColor = (Red:$00/$FF; Green:$BF/$FF; Blue:$FF/$FF; Alpha:$FF/$FF);
  DIMGRAY             : TColor = (Red:$69/$FF; Green:$69/$FF; Blue:$69/$FF; Alpha:$FF/$FF);
  DIMGREY             : TColor = (Red:$69/$FF; Green:$69/$FF; Blue:$69/$FF; Alpha:$FF/$FF);
  DODGERBLUE          : TColor = (Red:$1E/$FF; Green:$90/$FF; Blue:$FF/$FF; Alpha:$FF/$FF);
  FIREBRICK           : TColor = (Red:$B2/$FF; Green:$22/$FF; Blue:$22/$FF; Alpha:$FF/$FF);
  FLORALWHITE         : TColor = (Red:$FF/$FF; Green:$FA/$FF; Blue:$F0/$FF; Alpha:$FF/$FF);
  FORESTGREEN         : TColor = (Red:$22/$FF; Green:$8B/$FF; Blue:$22/$FF; Alpha:$FF/$FF);
  FUCHSIA             : TColor = (Red:$FF/$FF; Green:$00/$FF; Blue:$FF/$FF; Alpha:$FF/$FF);
  GAINSBORO           : TColor = (Red:$DC/$FF; Green:$DC/$FF; Blue:$DC/$FF; Alpha:$FF/$FF);
  GHOSTWHITE          : TColor = (Red:$F8/$FF; Green:$F8/$FF; Blue:$FF/$FF; Alpha:$FF/$FF);
  GOLD                : TColor = (Red:$FF/$FF; Green:$D7/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  GOLDENROD           : TColor = (Red:$DA/$FF; Green:$A5/$FF; Blue:$20/$FF; Alpha:$FF/$FF);
  GRAY                : TColor = (Red:$80/$FF; Green:$80/$FF; Blue:$80/$FF; Alpha:$FF/$FF);
  GREEN               : TColor = (Red:$00/$FF; Green:$80/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  GREENYELLOW         : TColor = (Red:$AD/$FF; Green:$FF/$FF; Blue:$2F/$FF; Alpha:$FF/$FF);
  GREY                : TColor = (Red:$80/$FF; Green:$80/$FF; Blue:$80/$FF; Alpha:$FF/$FF);
  HONEYDEW            : TColor = (Red:$F0/$FF; Green:$FF/$FF; Blue:$F0/$FF; Alpha:$FF/$FF);
  HOTPINK             : TColor = (Red:$FF/$FF; Green:$69/$FF; Blue:$B4/$FF; Alpha:$FF/$FF);
  INDIANRED           : TColor = (Red:$CD/$FF; Green:$5C/$FF; Blue:$5C/$FF; Alpha:$FF/$FF);
  INDIGO              : TColor = (Red:$4B/$FF; Green:$00/$FF; Blue:$82/$FF; Alpha:$FF/$FF);
  IVORY               : TColor = (Red:$FF/$FF; Green:$FF/$FF; Blue:$F0/$FF; Alpha:$FF/$FF);
  KHAKI               : TColor = (Red:$F0/$FF; Green:$E6/$FF; Blue:$8C/$FF; Alpha:$FF/$FF);
  LAVENDER            : TColor = (Red:$E6/$FF; Green:$E6/$FF; Blue:$FA/$FF; Alpha:$FF/$FF);
  LAVENDERBLUSH       : TColor = (Red:$FF/$FF; Green:$F0/$FF; Blue:$F5/$FF; Alpha:$FF/$FF);
  LAWNGREEN           : TColor = (Red:$7C/$FF; Green:$FC/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  LEMONCHIFFON        : TColor = (Red:$FF/$FF; Green:$FA/$FF; Blue:$CD/$FF; Alpha:$FF/$FF);
  LIGHTBLUE           : TColor = (Red:$AD/$FF; Green:$D8/$FF; Blue:$E6/$FF; Alpha:$FF/$FF);
  LIGHTCORAL          : TColor = (Red:$F0/$FF; Green:$80/$FF; Blue:$80/$FF; Alpha:$FF/$FF);
  LIGHTCYAN           : TColor = (Red:$E0/$FF; Green:$FF/$FF; Blue:$FF/$FF; Alpha:$FF/$FF);
  LIGHTGOLDENRODYELLOW: TColor = (Red:$FA/$FF; Green:$FA/$FF; Blue:$D2/$FF; Alpha:$FF/$FF);
  LIGHTGRAY           : TColor = (Red:$D3/$FF; Green:$D3/$FF; Blue:$D3/$FF; Alpha:$FF/$FF);
  LIGHTGREEN          : TColor = (Red:$90/$FF; Green:$EE/$FF; Blue:$90/$FF; Alpha:$FF/$FF);
  LIGHTGREY           : TColor = (Red:$D3/$FF; Green:$D3/$FF; Blue:$D3/$FF; Alpha:$FF/$FF);
  LIGHTPINK           : TColor = (Red:$FF/$FF; Green:$B6/$FF; Blue:$C1/$FF; Alpha:$FF/$FF);
  LIGHTSALMON         : TColor = (Red:$FF/$FF; Green:$A0/$FF; Blue:$7A/$FF; Alpha:$FF/$FF);
  LIGHTSEAGREEN       : TColor = (Red:$20/$FF; Green:$B2/$FF; Blue:$AA/$FF; Alpha:$FF/$FF);
  LIGHTSKYBLUE        : TColor = (Red:$87/$FF; Green:$CE/$FF; Blue:$FA/$FF; Alpha:$FF/$FF);
  LIGHTSLATEGRAY      : TColor = (Red:$77/$FF; Green:$88/$FF; Blue:$99/$FF; Alpha:$FF/$FF);
  LIGHTSLATEGREY      : TColor = (Red:$77/$FF; Green:$88/$FF; Blue:$99/$FF; Alpha:$FF/$FF);
  LIGHTSTEELBLUE      : TColor = (Red:$B0/$FF; Green:$C4/$FF; Blue:$DE/$FF; Alpha:$FF/$FF);
  LIGHTYELLOW         : TColor = (Red:$FF/$FF; Green:$FF/$FF; Blue:$E0/$FF; Alpha:$FF/$FF);
  LIME                : TColor = (Red:$00/$FF; Green:$FF/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  LIMEGREEN           : TColor = (Red:$32/$FF; Green:$CD/$FF; Blue:$32/$FF; Alpha:$FF/$FF);
  LINEN               : TColor = (Red:$FA/$FF; Green:$F0/$FF; Blue:$E6/$FF; Alpha:$FF/$FF);
  MAGENTA             : TColor = (Red:$FF/$FF; Green:$00/$FF; Blue:$FF/$FF; Alpha:$FF/$FF);
  MAROON              : TColor = (Red:$80/$FF; Green:$00/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  MEDIUMAQUAMARINE    : TColor = (Red:$66/$FF; Green:$CD/$FF; Blue:$AA/$FF; Alpha:$FF/$FF);
  MEDIUMBLUE          : TColor = (Red:$00/$FF; Green:$00/$FF; Blue:$CD/$FF; Alpha:$FF/$FF);
  MEDIUMORCHID        : TColor = (Red:$BA/$FF; Green:$55/$FF; Blue:$D3/$FF; Alpha:$FF/$FF);
  MEDIUMPURPLE        : TColor = (Red:$93/$FF; Green:$70/$FF; Blue:$DB/$FF; Alpha:$FF/$FF);
  MEDIUMSEAGREEN      : TColor = (Red:$3C/$FF; Green:$B3/$FF; Blue:$71/$FF; Alpha:$FF/$FF);
  MEDIUMSLATEBLUE     : TColor = (Red:$7B/$FF; Green:$68/$FF; Blue:$EE/$FF; Alpha:$FF/$FF);
  MEDIUMSPRINGGREEN   : TColor = (Red:$00/$FF; Green:$FA/$FF; Blue:$9A/$FF; Alpha:$FF/$FF);
  MEDIUMTURQUOISE     : TColor = (Red:$48/$FF; Green:$D1/$FF; Blue:$CC/$FF; Alpha:$FF/$FF);
  MEDIUMVIOLETRED     : TColor = (Red:$C7/$FF; Green:$15/$FF; Blue:$85/$FF; Alpha:$FF/$FF);
  MIDNIGHTBLUE        : TColor = (Red:$19/$FF; Green:$19/$FF; Blue:$70/$FF; Alpha:$FF/$FF);
  MINTCREAM           : TColor = (Red:$F5/$FF; Green:$FF/$FF; Blue:$FA/$FF; Alpha:$FF/$FF);
  MISTYROSE           : TColor = (Red:$FF/$FF; Green:$E4/$FF; Blue:$E1/$FF; Alpha:$FF/$FF);
  MOCCASIN            : TColor = (Red:$FF/$FF; Green:$E4/$FF; Blue:$B5/$FF; Alpha:$FF/$FF);
  NAVAJOWHITE         : TColor = (Red:$FF/$FF; Green:$DE/$FF; Blue:$AD/$FF; Alpha:$FF/$FF);
  NAVY                : TColor = (Red:$00/$FF; Green:$00/$FF; Blue:$80/$FF; Alpha:$FF/$FF);
  OLDLACE             : TColor = (Red:$FD/$FF; Green:$F5/$FF; Blue:$E6/$FF; Alpha:$FF/$FF);
  OLIVE               : TColor = (Red:$80/$FF; Green:$80/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  OLIVEDRAB           : TColor = (Red:$6B/$FF; Green:$8E/$FF; Blue:$23/$FF; Alpha:$FF/$FF);
  ORANGE              : TColor = (Red:$FF/$FF; Green:$A5/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  ORANGERED           : TColor = (Red:$FF/$FF; Green:$45/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  ORCHID              : TColor = (Red:$DA/$FF; Green:$70/$FF; Blue:$D6/$FF; Alpha:$FF/$FF);
  PALEGOLDENROD       : TColor = (Red:$EE/$FF; Green:$E8/$FF; Blue:$AA/$FF; Alpha:$FF/$FF);
  PALEGREEN           : TColor = (Red:$98/$FF; Green:$FB/$FF; Blue:$98/$FF; Alpha:$FF/$FF);
  PALETURQUOISE       : TColor = (Red:$AF/$FF; Green:$EE/$FF; Blue:$EE/$FF; Alpha:$FF/$FF);
  PALEVIOLETRED       : TColor = (Red:$DB/$FF; Green:$70/$FF; Blue:$93/$FF; Alpha:$FF/$FF);
  PAPAYAWHIP          : TColor = (Red:$FF/$FF; Green:$EF/$FF; Blue:$D5/$FF; Alpha:$FF/$FF);
  PEACHPUFF           : TColor = (Red:$FF/$FF; Green:$DA/$FF; Blue:$B9/$FF; Alpha:$FF/$FF);
  PERU                : TColor = (Red:$CD/$FF; Green:$85/$FF; Blue:$3F/$FF; Alpha:$FF/$FF);
  PINK                : TColor = (Red:$FF/$FF; Green:$C0/$FF; Blue:$CB/$FF; Alpha:$FF/$FF);
  PLUM                : TColor = (Red:$DD/$FF; Green:$A0/$FF; Blue:$DD/$FF; Alpha:$FF/$FF);
  POWDERBLUE          : TColor = (Red:$B0/$FF; Green:$E0/$FF; Blue:$E6/$FF; Alpha:$FF/$FF);
  PURPLE              : TColor = (Red:$80/$FF; Green:$00/$FF; Blue:$80/$FF; Alpha:$FF/$FF);
  REBECCAPURPLE       : TColor = (Red:$66/$FF; Green:$33/$FF; Blue:$99/$FF; Alpha:$FF/$FF);
  RED                 : TColor = (Red:$FF/$FF; Green:$00/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  ROSYBROWN           : TColor = (Red:$BC/$FF; Green:$8F/$FF; Blue:$8F/$FF; Alpha:$FF/$FF);
  ROYALBLUE           : TColor = (Red:$41/$FF; Green:$69/$FF; Blue:$E1/$FF; Alpha:$FF/$FF);
  SADDLEBROWN         : TColor = (Red:$8B/$FF; Green:$45/$FF; Blue:$13/$FF; Alpha:$FF/$FF);
  SALMON              : TColor = (Red:$FA/$FF; Green:$80/$FF; Blue:$72/$FF; Alpha:$FF/$FF);
  SANDYBROWN          : TColor = (Red:$F4/$FF; Green:$A4/$FF; Blue:$60/$FF; Alpha:$FF/$FF);
  SEAGREEN            : TColor = (Red:$2E/$FF; Green:$8B/$FF; Blue:$57/$FF; Alpha:$FF/$FF);
  SEASHELL            : TColor = (Red:$FF/$FF; Green:$F5/$FF; Blue:$EE/$FF; Alpha:$FF/$FF);
  SIENNA              : TColor = (Red:$A0/$FF; Green:$52/$FF; Blue:$2D/$FF; Alpha:$FF/$FF);
  SILVER              : TColor = (Red:$C0/$FF; Green:$C0/$FF; Blue:$C0/$FF; Alpha:$FF/$FF);
  SKYBLUE             : TColor = (Red:$87/$FF; Green:$CE/$FF; Blue:$EB/$FF; Alpha:$FF/$FF);
  SLATEBLUE           : TColor = (Red:$6A/$FF; Green:$5A/$FF; Blue:$CD/$FF; Alpha:$FF/$FF);
  SLATEGRAY           : TColor = (Red:$70/$FF; Green:$80/$FF; Blue:$90/$FF; Alpha:$FF/$FF);
  SLATEGREY           : TColor = (Red:$70/$FF; Green:$80/$FF; Blue:$90/$FF; Alpha:$FF/$FF);
  SNOW                : TColor = (Red:$FF/$FF; Green:$FA/$FF; Blue:$FA/$FF; Alpha:$FF/$FF);
  SPRINGGREEN         : TColor = (Red:$00/$FF; Green:$FF/$FF; Blue:$7F/$FF; Alpha:$FF/$FF);
  STEELBLUE           : TColor = (Red:$46/$FF; Green:$82/$FF; Blue:$B4/$FF; Alpha:$FF/$FF);
  TAN                 : TColor = (Red:$D2/$FF; Green:$B4/$FF; Blue:$8C/$FF; Alpha:$FF/$FF);
  TEAL                : TColor = (Red:$00/$FF; Green:$80/$FF; Blue:$80/$FF; Alpha:$FF/$FF);
  THISTLE             : TColor = (Red:$D8/$FF; Green:$BF/$FF; Blue:$D8/$FF; Alpha:$FF/$FF);
  TOMATO              : TColor = (Red:$FF/$FF; Green:$63/$FF; Blue:$47/$FF; Alpha:$FF/$FF);
  TURQUOISE           : TColor = (Red:$40/$FF; Green:$E0/$FF; Blue:$D0/$FF; Alpha:$FF/$FF);
  VIOLET              : TColor = (Red:$EE/$FF; Green:$82/$FF; Blue:$EE/$FF; Alpha:$FF/$FF);
  WHEAT               : TColor = (Red:$F5/$FF; Green:$DE/$FF; Blue:$B3/$FF; Alpha:$FF/$FF);
  WHITE               : TColor = (Red:$FF/$FF; Green:$FF/$FF; Blue:$FF/$FF; Alpha:$FF/$FF);
  WHITESMOKE          : TColor = (Red:$F5/$FF; Green:$F5/$FF; Blue:$F5/$FF; Alpha:$FF/$FF);
  YELLOW              : TColor = (Red:$FF/$FF; Green:$FF/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  YELLOWGREEN         : TColor = (Red:$9A/$FF; Green:$CD/$FF; Blue:$32/$FF; Alpha:$FF/$FF);
  BLANK               : TColor = (Red:$00;     Green:$00;     Blue:$00;     Alpha:$00);
  WHITE2              : TColor = (Red:$F5/$FF; Green:$F5/$FF; Blue:$F5/$FF; Alpha:$FF/$FF);
  RED22               : TColor = (Red:$7E/$FF; Green:$32/$FF; Blue:$3F/$FF; Alpha:255/$FF);
  COLORKEY            : TColor = (Red:$FF/$FF; Green:$00;     Blue:$FF/$FF; Alpha:$FF/$FF);
  OVERLAY1            : TColor = (Red:$00/$FF; Green:$20/$FF; Blue:$29/$FF; Alpha:$B4/$FF);
  OVERLAY2            : TColor = (Red:$01/$FF; Green:$1B/$FF; Blue:$01/$FF; Alpha:255/$FF);
  DIMWHITE            : TColor = (Red:$10/$FF; Green:$10/$FF; Blue:$10/$FF; Alpha:$10/$FF);
  DARKSLATEBROWN      : TColor = (Red:30/255; Green:31/255; Blue:30/255; Alpha:1);
{$ENDREGION}

{ --- WINDOW ---------------------------------------------------------------- }
const
  DISPLAY_DEFAULT_DPI = 96;

{ --- VIEWPORT -------------------------------------------------------------- }
type
  { TViewport }
  TViewport = record
    Bitmap: Int64;
    Active: Boolean;
    Pos: TRectangle;
    Half: TVector;
    Angle: Single;
    Center: TVector;
  end;

{ --- INPUT ----------------------------------------------------------------- }
const
  MAX_AXES = 3;
  MAX_STICKS = 16;
  MAX_BUTTONS = 32;

  MOUSE_BUTTON_LEFT = 1;
  MOUSE_BUTTON_RIGHT = 2;
  MOUSE_BUTTON_MIDDLE = 3;

{$REGION 'Keyboard Constants'}
const
  KEY_A = 1;
  KEY_B = 2;
  KEY_C = 3;
  KEY_D = 4;
  KEY_E = 5;
  KEY_F = 6;
  KEY_G = 7;
  KEY_H = 8;
  KEY_I = 9;
  KEY_J = 10;
  KEY_K = 11;
  KEY_L = 12;
  KEY_M = 13;
  KEY_N = 14;
  KEY_O = 15;
  KEY_P = 16;
  KEY_Q = 17;
  KEY_R = 18;
  KEY_S = 19;
  KEY_T = 20;
  KEY_U = 21;
  KEY_V = 22;
  KEY_W = 23;
  KEY_X = 24;
  KEY_Y = 25;
  KEY_Z = 26;
  KEY_0 = 27;
  KEY_1 = 28;
  KEY_2 = 29;
  KEY_3 = 30;
  KEY_4 = 31;
  KEY_5 = 32;
  KEY_6 = 33;
  KEY_7 = 34;
  KEY_8 = 35;
  KEY_9 = 36;
  KEY_PAD_0 = 37;
  KEY_PAD_1 = 38;
  KEY_PAD_2 = 39;
  KEY_PAD_3 = 40;
  KEY_PAD_4 = 41;
  KEY_PAD_5 = 42;
  KEY_PAD_6 = 43;
  KEY_PAD_7 = 44;
  KEY_PAD_8 = 45;
  KEY_PAD_9 = 46;
  KEY_F1 = 47;
  KEY_F2 = 48;
  KEY_F3 = 49;
  KEY_F4 = 50;
  KEY_F5 = 51;
  KEY_F6 = 52;
  KEY_F7 = 53;
  KEY_F8 = 54;
  KEY_F9 = 55;
  KEY_F10 = 56;
  KEY_F11 = 57;
  KEY_F12 = 58;
  KEY_ESCAPE = 59;
  KEY_TILDE = 60;
  KEY_MINUS = 61;
  KEY_EQUALS = 62;
  KEY_BACKSPACE = 63;
  KEY_TAB = 64;
  KEY_OPENBRACE = 65;
  KEY_CLOSEBRACE = 66;
  KEY_ENTER = 67;
  KEY_SEMICOLON = 68;
  KEY_QUOTE = 69;
  KEY_BACKSLASH = 70;
  KEY_BACKSLASH2 = 71;
  KEY_COMMA = 72;
  KEY_FULLSTOP = 73;
  KEY_SLASH = 74;
  KEY_SPACE = 75;
  KEY_INSERT = 76;
  KEY_DELETE = 77;
  KEY_HOME = 78;
  KEY_END = 79;
  KEY_PGUP = 80;
  KEY_PGDN = 81;
  KEY_LEFT = 82;
  KEY_RIGHT = 83;
  KEY_UP = 84;
  KEY_DOWN = 85;
  KEY_PAD_SLASH = 86;
  KEY_PAD_ASTERISK = 87;
  KEY_PAD_MINUS = 88;
  KEY_PAD_PLUS = 89;
  KEY_PAD_DELETE = 90;
  KEY_PAD_ENTER = 91;
  KEY_PRINTSCREEN = 92;
  KEY_PAUSE = 93;
  KEY_ABNT_C1 = 94;
  KEY_YEN = 95;
  KEY_KANA = 96;
  KEY_CONVERT = 97;
  KEY_NOCONVERT = 98;
  KEY_AT = 99;
  KEY_CIRCUMFLEX = 100;
  KEY_COLON2 = 101;
  KEY_KANJI = 102;
  KEY_PAD_EQUALS = 103;
  KEY_BACKQUOTE = 104;
  KEY_SEMICOLON2 = 105;
  KEY_COMMAND = 106;
  KEY_BACK = 107;
  KEY_VOLUME_UP = 108;
  KEY_VOLUME_DOWN = 109;
  KEY_SEARCH = 110;
  KEY_DPAD_CENTER = 111;
  KEY_BUTTON_X = 112;
  KEY_BUTTON_Y = 113;
  KEY_DPAD_UP = 114;
  KEY_DPAD_DOWN = 115;
  KEY_DPAD_LEFT = 116;
  KEY_DPAD_RIGHT = 117;
  KEY_SELECT = 118;
  KEY_START = 119;
  KEY_BUTTON_L1 = 120;
  KEY_BUTTON_R1 = 121;
  KEY_BUTTON_L2 = 122;
  KEY_BUTTON_R2 = 123;
  KEY_BUTTON_A = 124;
  KEY_BUTTON_B = 125;
  KEY_THUMBL = 126;
  KEY_THUMBR = 127;
  KEY_UNKNOWN = 128;
  KEY_MODIFIERS = 215;
  KEY_LSHIFT = 215;
  KEY_RSHIFT = 216;
  KEY_LCTRL = 217;
  KEY_RCTRL = 218;
  KEY_ALT = 219;
  KEY_ALTGR = 220;
  KEY_LWIN = 221;
  KEY_RWIN = 222;
  KEY_MENU = 223;
  KEY_SCROLLLOCK = 224;
  KEY_NUMLOCK = 225;
  KEY_CAPSLOCK = 226;
  KEY_MAX = 227;
  KEYMOD_SHIFT = $0001;
  KEYMOD_CTRL = $0002;
  KEYMOD_ALT = $0004;
  KEYMOD_LWIN = $0008;
  KEYMOD_RWIN = $0010;
  KEYMOD_MENU = $0020;
  KEYMOD_COMMAND = $0040;
  KEYMOD_SCROLOCK = $0100;
  KEYMOD_NUMLOCK = $0200;
  KEYMOD_CAPSLOCK = $0400;
  KEYMOD_INALTSEQ = $0800;
  KEYMOD_ACCENT1 = $1000;
  KEYMOD_ACCENT2 = $2000;
  KEYMOD_ACCENT3 = $4000;
  KEYMOD_ACCENT4 = $8000;
{$ENDREGION}

const
  // sticks
  JOY_STICK_LS = 0;
  JOY_STICK_RS = 1;
  JOY_STICK_LT = 2;
  JOY_STICK_RT = 3;

  // axes
  JOY_AXES_X = 0;
  JOY_AXES_Y = 1;
  JOY_AXES_Z = 2;

  // buttons
  JOY_BTN_A = 0;
  JOY_BTN_B = 1;
  JOY_BTN_X = 2;
  JOY_BTN_Y = 3;
  JOY_BTN_RB = 4;
  JOY_BTN_LB = 5;
  JOY_BTN_RT = 6;
  JOY_BTN_LT = 7;
  JOY_BTN_BACK = 8;
  JOY_BTN_START = 9;
  JOY_BTN_RDPAD = 10;
  JOY_BTN_LDPAD = 11;
  JOY_BTN_DDPAD = 12;
  JOY_BTN_UDPAD = 13;

type
  { TJoystick }
  TJoystick = record
    Name: string;
    Sticks: Integer;
    Buttons: Integer;
    StickName: array [0 .. MAX_STICKS - 1] of string;
    Axes: array [0 .. MAX_STICKS - 1] of Integer;
    AxesName: array [0 .. MAX_STICKS - 1, 0 .. MAX_AXES - 1] of string;
    Pos: array [0 .. MAX_STICKS - 1, 0 .. MAX_AXES - 1] of Single;
    Button: array [0 .. MAX_BUTTONS - 1] of Boolean;
    ButtonName: array [0 .. MAX_BUTTONS - 1] of string;
    procedure Setup(aNum: Integer);
    function GetPos(aStick: Integer; aAxes: Integer): Single;
    function GetButton(aButton: Integer): Boolean;
  end;

{ --- RENDERING ------------------------------------------------------------- }
const
  BLEND_ZERO = 0;
  BLEND_ONE = 1;
  BLEND_ALPHA = 2;
  BLEND_INVERSE_ALPHA = 3;
  BLEND_SRC_COLOR = 4;
  BLEND_DEST_COLOR = 5;
  BLEND_INVERSE_SRC_COLOR = 6;
  BLEND_INVERSE_DEST_COLOR = 7;
  BLEND_CONST_COLOR = 8;
  BLEND_INVERSE_CONST_COLOR = 9;
  BLEND_ADD = 0;
  BLEND_SRC_MINUS_DEST = 1;
  BLEND_DEST_MINUS_SRC = 2;

type
  { TBlendMode }
  TBlendMode = (bmPreMultipliedAlpha, bmNonPreMultipliedAlpha, bmAdditiveAlpha, bmCopySrcToDest, bmMultiplySrcAndDest);

  { TBlendModeColor }
  TBlendModeColor = (bcColorNormal, bcColorAvgSrcDest);

{ --- BITMAP ---------------------------------------------------------------- }
type
  { TBitmap }
  TBitmap = record
    Handle: PALLEGRO_BITMAP;
    Width: Single;
    Height: Single;
    Locked: Boolean;
    LockedRegion: TRectangle;
    Filename: string;
  end;

  { TBitmapData }
  PBitmapData = ^TBitmapData;
  TBitmapData = record
    Memory: Pointer;
    Format: Integer;
    Pitch: Integer;
    PixelSize: Integer;
  end;

{ --- FONT ------------------------------------------------------------------ }
type
  { TFont }
  TFont = record
    Handle: PALLEGRO_FONT;
    Filename: string;
    Size: Cardinal;
  end;

{ --- AUDIO ----------------------------------------------------------------- }
const
  // audio
  AUDIO_CHANNEL_COUNT   = 16;
  AUDIO_PAN_NONE        = -1000.0;

type
  { TSample }
  TSample = record
    Handle: PALLEGRO_SAMPLE;
  end;

  { TSampleID }
  PSampleID = ^TSampleID;
  TSampleID = record
    Index: Integer;
    Id: Integer;
  end;

{ --- GAME ------------------------------------------------------------------ }

  { TGame }
  TGame = class
  type
    PSettings = ^TSettings;
    TSettings = record
      WindowWidth: Integer;
      WindowHeight: Integer;
      WindowTitle: string;
      WindowFullscreen: Boolean;
      WindowClearColor: TColor;
      ArchivePassword: string;
      ArchiveFilename: string;
      DefaultFontSize: Integer;
    end;
  private
    FSettings: TSettings;
    constructor Create; virtual;
  protected
    FEvent: ALLEGRO_EVENT;
    FQueue: PALLEGRO_EVENT_QUEUE;
    FTerminated: Boolean;
    FCosTable: array [0 .. 360] of Single;
    FSinTable: array [0 .. 360] of Single;
    FIDCounter: Int64;
    FDefaultFont: Int64;
    FMousePos: TVector;
    // Window
    FWindow: record
      Handle: PALLEGRO_DISPLAY;
      Ready: Boolean;
      Trans: ALLEGRO_TRANSFORM;
      Size: TVector;
      TransScale: Single;
      TransSize: TRectangle;
      UpScale: Single;
      Fullscreen: Boolean;
      Viewport: Int64;
    end;
    // Audio
    FAudio: record
      Voice: PALLEGRO_VOICE;
      Mixer: PALLEGRO_MIXER;
    end;
    // Timing
    FTimer: record
      LNow: Double;
      Passed: Double;
      Last: Double;
      Accumulator: Double;
      FrameAccumulator: Double;
      DeltaTime: Double;
      FrameCount: Cardinal;
      FrameRate: Cardinal;
      UpdateSpeed: Single;
    end;
    // Input
    FInput: record
      MouseState: ALLEGRO_MOUSE_STATE;
      KeyboardState: ALLEGRO_KEYBOARD_STATE;
      KeyCode: Integer;
      MouseButtons: array [0 .. 256] of Boolean;
      KeyButtons: array [0 .. 256] of Boolean;
      JoyButtons: array [0 .. 256] of Boolean;
      JoyStick: TJoystick;
    end;
    // Hud
    FHud: record
      TextItemPadWidth: Integer;
      Pos: TVector;
    end;
    // Music
    FMusic: record
      Handle: PALLEGRO_AUDIO_STREAM;
    end;
    // Log
    FLog: record
      FormatSettings : TFormatSettings;
      Filename: string;
      Text: Text;
      Buffer: array[Word] of Byte;
      Open: Boolean;
    end;
    // ZipArc
    FZipArc: record
      StandardFS: ALLEGRO_FILE_INTERFACE;
      PhysFS: array[ 0..1] of ALLEGRO_FILE_INTERFACE;
      Password: string;
      Filename: string;
    end;
    // Video
    FVideo: record
      Voice: PALLEGRO_VOICE;
      Mixer: PALLEGRO_MIXER;
      Handle: PALLEGRO_VIDEO;
      Loop: Boolean;
      Playing: Boolean;
      Paused: Boolean;
      Filename: string;
    end;
    FFontList: TDictionary<Int64, TFont>;
    FBitmapList: TDictionary<Int64, TBitmap>;
    FViewportList: TDictionary<Int64, TViewport>;
    FSampleList: TDictionary<Int64, TSample>;
    procedure Startup;
    procedure Shutdown;
    procedure UpdateTiming;
    function GenID: Int64;
    procedure FixupWindow;
    function TransformScale(aFullscreen: Boolean): Single;
    procedure ResizeForDPI;
    procedure LoadDefaultIcon(aWnd: HWND);
    class function  HasConsoleOutput: Boolean;
    procedure OpenLog;
    procedure CloseLog;
    procedure VideoFinishedEvent(aHandle: PALLEGRO_VIDEO);
  public
    property Settings: TSettings read FSettings;
    property MousePos: TVector read FMousePos;
    property DefaultFont: Int64 read FDefaultFont;

    destructor Destroy; override;

    // Log
    procedure Log(const aMsg: string; const aArgs: array of const; aWriteToConsole: Boolean=False);

    // Console
    class procedure ConsolePrint(const aMsg: string; const aArgs: array of const);
    class procedure ConsolePrintLn(const aMsg: string; const aArgs: array of const);

    // Math
    procedure Randomize;
    function  RandomRange(aMin, aMax: Integer): Integer; overload;
    function  RandomRange(aMin, aMax: Single): Single; overload;
    function  RandomBool: Boolean;
    function  GetRandomSeed: Integer;
    procedure SetRandomSeed(aValue: Integer);
    function  AngleCos(aAngle: Integer): Single;
    function  AngleSin(aAngle: Integer): Single;
    function  AngleDifference(aSrcAngle: Single; aDestAngle: Single): Single;
    procedure AngleRotatePos(aAngle: Single; var aX: Single; var aY: Single);
    function  ClipValue(var aValue: Single; aMin: Single; aMax: Single; aWrap: Boolean): Single; overload;
    function  ClipValue(var aValue: Integer; aMin: Integer; aMax: Integer; aWrap: Boolean): Integer; overload;
    function  SameSign(aValue1: Integer; aValue2: Integer): Boolean; overload;
    function  SameSign(aValue1: Single; aValue2: Single): Boolean; overload;
    function  SameValue(aA: Double; aB: Double; aEpsilon: Double = 0): Boolean; overload;
    function  SameValue(aA: Single; aB: Single; aEpsilon: Single = 0): Boolean; overload;
    function  Point(aX: Integer; aY: Integer): TPointi; overload;
    function  Point(aX: Single; aY: Single): TPointf; overload;
    function  Vector(aX: Single; aY: Single): TVector;
    function  Rectangle(aX: Single; aY: Single; aWidth: Single; aHeight: Single): TRectangle;
    procedure SmoothMove(var aValue: Single; aAmount: Single; aMax: Single; aDrag: Single);
    function Lerp(aFrom: Double; aTo: Double; aTime: Double): Double;

    // Collision
    function PointInRectangle(aPoint: TVector; aRect: TRectangle): Boolean;
    function PointInCircle(aPoint, aCenter: TVector; aRadius: Single): Boolean;
    function PointInTriangle(aPoint, aP1, aP2, aP3: TVector): Boolean;
    function CirclesOverlap(aCenter1: TVector; aRadius1: Single; aCenter2: TVector; aRadius2: Single): Boolean;
    function CircleInRectangle(aCenter: TVector; aRadius: Single; aRect: TRectangle): Boolean;
    function RectanglesOverlap(aRect1: TRectangle; aRect2: TRectangle): Boolean;
    function RectangleIntersection(aRect1, aRect2: TRectangle): TRectangle;
    function LineIntersection(aX1, aY1, aX2, aY2, aX3, aY3, aX4, aY4: Integer; var aX: Integer; var aY: Integer): TLineIntersection;
    function RadiusOverlap(aRadius1, aX1, aY1, aRadius2, aX2, aY2, aShrinkFactor: Single): Boolean;

    // Color
    function MakeColor(aRed: Byte; aGreen: Byte; aBlue: Byte; aAlpha: Byte): TColor; overload;
    function MakeColor(aRed: Single; aGreen: Single; aBlue: Single; aAlpha: Single): TColor; overload;
    function MakeColor(const aName: string): TColor; overload;
    function FadeColor(var aFrom: TColor; aTo: TColor; aPos: Single): TColor;
    function ColorEqual(aColor1: TColor; aColor2: TColor): Boolean;

    // Timing
    function  GetTime: Double;
    procedure ResetTiming;
    procedure SetUpdateSpeed(aSpeed: Single);
    function  GetUpdateSpeed: Single;
    function  GetDeltaTime: Double;
    function  GetFrameRate: Cardinal;
    function  FrameSpeed(var aTimer: Single; aSpeed: Single): Boolean;
    function  FrameElapsed(var aTimer: Single; aFrames: Single): Boolean;

    // Window
    function  OpenWindow(aWidth: Integer; aHeight: Integer; aTitle: string; aFullscreen: Boolean=False): Boolean;
    procedure CloseWindow;
    function  IsWindowOpen: Boolean;
    procedure SetWindowTitle(const aTitle: string);
    procedure ClearWindow(aColor: TColor);
    procedure ShowWindow;
    procedure ToggleFullscreenWindow;
    function  IsWindowFullscreen: Boolean;
    procedure SetWindowTarget(aBitmap: Int64);
    procedure ResetWindowTarget;
    procedure SetWindowViewport(aViewport: Int64);
    procedure GetWindowViewportSize(aX: PInteger; aY: PInteger; aWidth: PInteger; aHeight: PInteger); overload;
    procedure GetWindowViewportSize(var aSize: TRectangle); overload;
    procedure GetWindowSize(aWidth: System.PInteger; aHeight: System.PInteger; aAspectRatio: System.PSingle=nil);
    procedure ResetWindowTransform;
    procedure SetWindowTransformPosition(aX: Integer; aY: Integer);
    procedure SetWindowTransformAngle(aAngle: Single);
    function  SaveWindow(const aFilename: string): Boolean;

    // Viewport
    function  CreateViewport(aX: Integer; aY: Integer; aWidth: Integer; aHeight: Integer): Int64;
    procedure DestroyViewport(var aViewport: Int64);
    procedure DestroyAllViewports;
    procedure SetViewportActive(aViewport: Int64; aActive: Boolean);
    function  GetViewportActive(aViewport: Int64): Boolean;
    procedure SetViewportPosition(aViewport: Int64; aX: Integer; aY: Integer);
    procedure GetViewportSize(aViewport: Int64; aX: PInteger; aY: PInteger; aWidth: PInteger; aHeight: PInteger);
    procedure SetViewportAngle(aViewport: Int64; aAngle: Single);
    function  GetViewportAngle(aViewport: Int64): Single;
    procedure AlignViewport(aViewport: Int64; var aX: Single; var aY: Single); overload;
    procedure AlignViewport(aViewport: Int64; var aPos: TVector); overload;
    procedure ResetViewport;

    // Input
    procedure ClearInput;
    function  KeyboardPressed(aKey: Integer): Boolean;
    function  KeyboardReleased(aKey: Integer): Boolean;
    function  KeyboardDown(aKey: Integer): Boolean;
    function  KeyboardGetPressed: Integer;
    function  MousePressed(aButton: Integer): Boolean;
    function  MouseReleased(aButton: Integer): Boolean;
    function  MouseDown(aButton: Integer): Boolean;
    procedure MouseGetInfo(aX: PInteger; aY: PInteger; aWheel: PInteger); overload;
    procedure MouseGetInfo(var aPos: TVector); overload;
    procedure MouseSetPos(aX: Integer; aY: Integer);
    procedure MouseShowCursor(aShow: Boolean);
    function  JoystickPressed(aButton: Integer): Boolean;
    function  JoystickReleased(aButton: Integer): Boolean;
    function  JoystickDown(aButton: Integer): Boolean;
    function  JoystickGetPos(aStick: Integer; aAxes: Integer): Single;

    // Rendering
    procedure DrawLine(aX1, aY1, aX2, aY2: Single; aColor: TColor; aThickness: Single);
    procedure DrawRectangle(aX, aY, aWidth, aHeight, aThickness: Single; aColor: TColor);
    procedure DrawFilledRectangle(aX, aY, aWidth, aHeight: Single; aColor: TColor);
    procedure DrawCircle(aX, aY, aRadius, aThickness: Single;  aColor: TColor);
    procedure DrawFilledCircle(aX, aY, aRadius: Single; aColor: TColor);
    procedure DrawPolygon(aVertices: System.PSingle; aVertexCount: Integer; aThickness: Single; aColor: TColor);
    procedure DrawFilledPolygon(aVertices: System.PSingle; aVertexCount: Integer; aColor: TColor);
    procedure DrawTriangle(aX1, aY1, aX2, aY2, aX3, aY3, aThickness: Single; aColor: TColor);
    procedure DrawFilledTriangle(aX1, aY1, aX2, aY2, aX3, aY3: Single; aColor: TColor);
    procedure SetBlender(aOperation: Integer; aSource: Integer; aDestination: Integer);
    procedure GetBlender(aOperation: PInteger; aSource: PInteger; aDestination: PInteger);
    procedure SetBlendColor(aColor: TColor);
    function  GetBlendColor: TColor;
    procedure SetBlendMode(aMode: TBlendMode);
    procedure SetBlendModeColor(aMode: TBlendModeColor; aColor: TColor);
    procedure RestoreDefaultBlendMode;

    // Font
    function  LoadFont(aSize: Cardinal): Int64; overload;
    function  LoadFont(aSize: Cardinal; const aFilename: string): Int64; overload;
    function  LoadFont(aSize: Cardinal; aMemory: Pointer; aLength: Int64): Int64; overload;
    procedure UnloadFont(var aFont: Int64);
    procedure UnloadAllFonts;
    procedure PrintText(aFont: Int64; aX: Single; aY: Single; aColor: TColor; aAlign: THAlign; const aMsg: string; const aArgs: array of const); overload;
    procedure PrintText(aFont: Int64; aX: Single; var aY: Single; aLineSpace: Single; aColor: TColor; aAlign: THAlign; const aMsg: string; const aArgs: array of const); overload;
    procedure PrintText(aFont: Int64; aX: Single; aY: Single; aColor: TColor; aAngle: Single; const aMsg: string; const aArgs: array of const); overload;
    function  GetTextWidth(aFont: Int64; const aMsg: string; const aArgs: array of const): Single;
    function  GetLineHeight(aFont: Int64): Single;

    // Bitmap
    function  AllocBitmap(aWidth: Integer; aHeight: Integer): Int64;
    function  LoadBitmap(const aFilename: string; aColorKey: PColor): Int64;
    procedure UnloadBitmap(var aBitmap: Int64);
    procedure UnloadAllBitmaps;
    procedure GetBitmapSize(aBitmap: Int64; var aSize: TVector); overload;
    procedure GetBitmapSize(aBitmap: Int64; aWidth: PSingle; aHeight: PSingle); overload;
    procedure LockBitmap(aBitmap: Int64; aRegion: PRectangle; aData: PBitmapData=nil);
    procedure UnlockBitmap(aBitmap: Int64);
    function  GetBitmapPixel(aBitmap: Int64; aX: Integer; aY: Integer): TColor;
    procedure SetBitmapPixel(aBitmap: Int64; aX: Integer; aY: Integer; aColor: TColor);
    procedure DrawBitmap(aBitmap: Int64; aX, aY: Single; aRegion: PRectangle; aCenter: PVector;  aScale: PVector; aAngle: Single; aColor: TColor; aHFlip: Boolean; aVFlip: Boolean); overload;
    procedure DrawBitmap(aBitmap: Int64; aX, aY, aScale, aAngle: Single; aColor: TColor; aHAlign: THAlign; aVAlign: TVAlign; aHFlip: Boolean=False; aVFlip: Boolean=False); overload;
    procedure DrawTiledBitmap(aBitmap: Int64; aDeltaX: Single; aDeltaY: Single);

    // Hud
    procedure HudPos(aX: Integer; aY: Integer);
    procedure HudLineSpace(aLineSpace: Integer);
    procedure HudTextItemPadWidth(aWidth: Integer);
    procedure HudText(aFont: Int64; aColor: TColor; aAlign: THAlign; const aMsg: string; const aArgs: array of const);
    function  HudTextItem(const aKey: string; const aValue: string; const aSeperator: string='-'): string;

    // Archive
    function Mount(const aNewDir: string; const aMountPoint: string; aAppendToPath: Boolean): Boolean;
    function Unmount(const aOldDir: string): Boolean;
    function OpenZipArc(const aPassword: string; const aFilename: string): Boolean;
    function CloseZipArc: Boolean;

    // Audio
    procedure PauseAudio(aPause: Boolean);
    procedure ClearAudio;
    procedure LoadMusic(const aFilename: string);
    procedure UnloadMusic;
    procedure PlayMusic(aVolume: Single; aLoop: Boolean);
    procedure StopMusic;
    function  GetMusicLooping: Boolean;
    procedure SetMusicLooping(aLoop: Boolean);
    function  GetMusicPlaying: Boolean;
    procedure SetMusicPlaying(aPlay: Boolean);
    procedure SetMusicVolume(aVolume: Single);
    function  GetMusicVolume: Single;
    procedure SeekMusic(aTime: Single);
    procedure RewindMusic(aTime: Single);
    function  ReserveSamples(aCount: Integer): Boolean;
    function  LoadSample(const aFilename: string): Int64;
    procedure UnloadSample(var aSample: Int64);
    procedure UnloadAllSamples;
    procedure PlaySample(aSample: Int64; aVolume: Single; aPan: Single; aSpeed: Single; aLoop: Boolean; aId: PSampleID);
    procedure StopSample(aID: TSampleID);
    procedure StopAllSamples;
    function  IsSamplePlaying(aID: TSampleID): Boolean;

    // Video
    procedure LoadVideo(const aFilename: string);
    procedure UnloadVideo;
    function  IsVideoPaused: Boolean;
    procedure PauseVideo(aPause: Boolean);
    function  IsVideoLooping:  Boolean;
    procedure SetVideoLooping(aLoop: Boolean);
    function  IsVideoPlaying: Boolean;
    procedure SetVideoPlaying(aPlay: Boolean);
    function  GetVideoFilename: string;
    procedure PlayVideo(const aFilename: string; aLoop: Boolean; aGain: Single); overload;
    procedure PlayVideo(aLoop: Boolean; aGain: Single); overload;
    procedure DrawVideo(aX: Single; aY: Single);
    procedure GetVideoSize(aWidth: PSingle; aHeight: PSingle);
    procedure SeekVideo(aPos: Single);
    procedure RewindVideo;

    // Game
    procedure SetTerminated(aTerminated: Boolean);
    function  GetTerminated: Boolean;
    procedure OnGetSettings(var aSettings: TSettings); virtual;
    procedure OnLoadConfig; virtual;
    procedure OnSaveConfig; virtual;
    procedure OnStartup; virtual;
    procedure OnShutdown; virtual;
    procedure OnClearFrame; virtual;
    procedure OnUpdateFrame(aDeltaTime: Double); virtual;
    procedure OnRenderFrame; virtual;
    procedure OnRenderHUD; virtual;
    procedure OnShowFrame; virtual;
    procedure OnLoadVideo(const aFilename: string); virtual;
    procedure OnUnloadVideo(const aFilename: string); virtual;
    procedure OnVideoFinished(const aFilename: string); virtual;
    procedure Run;
  end;

  { TGameClass }
  TGameClass = class of TGame;

var
  Game: TGame = nil;

// Routines
procedure RunGame(aGame: TGameClass);

implementation

{$R Spark.res}

uses
  System.Math,
  WinAPI.Messages,
  VCL.Graphics,
  VCL.Forms;

// Routines
function SingleInstance: Boolean;
var
  LFilename: string;
  LText: System.Text;
  LOk: Boolean;
  LIOResult: Integer;
begin
  Result := False;
  LFilename := ChangeFileExt(ParamStr(0), cLOGExt);
  if not  FileExists(LFilename) then
    Result := True;
  {$I-}
  AssignFile(LText, LFilename);
  Reset(LText);
  LIOResult := IOResult;
  LOk :=  Boolean(LIOResult = 0);
  {$I+}
  if LOk then
  begin
    CloseFile(LText);
    Result := True;
  end;
end;

procedure RunGame(aGame: TGameClass);
var
  LGame: TGame;
begin
  if not SingleInstance then
  begin
    TGame.ConsolePrintLn('An instance of this application is already running, terminating!', []);
    Exit;
  end;

  LGame := aGame.Create;
  try
    LGame.Run;
  finally
    FreeAndNil(LGame);
  end;
end;

{ --- MATH ------------------------------------------------------------------ }
{ TVector }
constructor TVector.Create(aX: Single; aY: Single);
begin
  Assign(aX, aY);
  Z := 0;
end;

procedure TVector.Assign(aX: Single; aY: Single);
begin
  X := aX;
  Y := aY;
end;

procedure TVector.Assign(aX: Single; aY: Single; aZ: Single);
begin
  X := aX;
  Y := aY;
  Z := aZ;
end;

procedure TVector.Clear;
begin
  X := 0;
  Y := 0;
  Z := 0;
end;

procedure TVector.Assign(aVector: TVector);
begin
  X := aVector.X;
  Y := aVector.Y;
end;

procedure TVector.Add(aVector: TVector);
begin
  X := X + aVector.X;
  Y := Y + aVector.Y;
end;

procedure TVector.Subtract(aVector: TVector);
begin
  X := X - aVector.X;
  Y := Y - aVector.Y;
end;

procedure TVector.Multiply(aVector: TVector);
begin
  X := X * aVector.X;
  Y := Y * aVector.Y;
end;

procedure TVector.Divide(aVector: TVector);
begin
  X := X / aVector.X;
  Y := Y / aVector.Y;

end;

function TVector.Magnitude: Single;
begin
  Result := Sqrt((X * X) + (Y * Y));
end;

function TVector.MagnitudeTruncate(aMaxMagitude: Single): TVector;
var
  LMaxMagSqrd: Single;
  LVecMagSqrd: Single;
  LTruc: Single;
begin
  Result.Assign(X, Y);
  LMaxMagSqrd := aMaxMagitude * aMaxMagitude;
  LVecMagSqrd := Result.Magnitude;
  if LVecMagSqrd > LMaxMagSqrd then
  begin
    LTruc := (aMaxMagitude / Sqrt(LVecMagSqrd));
    Result.X := Result.X * LTruc;
    Result.Y := Result.Y * LTruc;
  end;
end;

function TVector.Distance(aVector: TVector): Single;
var
  LDirVec: TVector;
begin
  LDirVec.X := X - aVector.X;
  LDirVec.Y := Y - aVector.Y;
  Result := LDirVec.Magnitude;
end;

procedure TVector.Normalize;
var
  LLen, LOOL: Single;
begin
  LLen := self.Magnitude;
  if LLen <> 0 then
  begin
    LOOL := 1.0 / LLen;
    X := X * LOOL;
    Y := Y * LOOL;
  end;
end;

function TVector.Angle(aVector: TVector): Single;
var
  LXOY: Single;
  LR: TVector;
begin
  LR.Assign(self);
  LR.Subtract(aVector);
  LR.Normalize;

  if LR.Y = 0 then
  begin
    LR.Y := 0.001;
  end;

  LXOY := LR.X / LR.Y;

  Result := ArcTan(LXOY) * RAD2DEG;
  if LR.Y < 0 then
    Result := Result + 180.0;

end;

procedure TVector.Thrust(aAngle: Single; aSpeed: Single);
var
  LA: Single;

begin
  LA := aAngle + 90.0;

  Game.ClipValue(LA, 0, 360, True);

  X := X + Game.AngleCos(Round(LA)) * -(aSpeed);
  Y := Y + Game.AngleSin(Round(LA)) * -(aSpeed);
end;

function TVector.MagnitudeSquared: Single;
begin
  Result := (X * X) + (Y * Y);
end;

function TVector.DotProduct(aVector: TVector): Single;
begin
  Result := (X * aVector.X) + (Y * aVector.Y);
end;

procedure TVector.Scale(aValue: Single);
begin
  X := X * aValue;
  Y := Y * aValue;
end;

procedure TVector.DivideBy(aValue: Single);
begin
  X := X / aValue;
  Y := Y / aValue;
end;

function TVector.Project(aVector: TVector): TVector;
var
  LDP: Single;
begin
  LDP := self.DotProduct(aVector);
  Result.X := (LDP / (aVector.X * aVector.X + aVector.Y * aVector.Y)) * aVector.X;
  Result.Y := (LDP / (aVector.X * aVector.X + aVector.Y * aVector.Y)) * aVector.Y;
end;

procedure TVector.Negate;
begin
  X := -X;
  Y := -Y;
end;

{ TRectangle }
constructor TRectangle.Create(aX: Single; aY: Single; aWidth: Single; aHeight: Single);
begin
  Assign(aX, aY, aWidth, aHeight);
end;

procedure TRectangle.Assign(aX: Single; aY: Single; aWidth: Single; aHeight: Single);
begin
  X := aX;
  Y := aY;
  Width := aWidth;
  Height := aHeight;
end;

function TRectangle.Intersect(aRect: TRectangle): Boolean;
var
  LR1R, LR1B: Single;
  LR2R, LR2B: Single;
begin
  LR1R := X - (Width - 1);
  LR1B := Y - (Height - 1);
  LR2R := aRect.X - (aRect.Width - 1);
  LR2B := aRect.Y - (aRect.Height - 1);

  Result := (X < LR2R) and (LR1R > aRect.X) and (Y < LR2B) and (LR1B > aRect.Y);
end;

{ --- INPUT ----------------------------------------------------------------- }
{ TJoystick }
procedure TJoystick.Setup(aNum: Integer);
var
  LJoyCount: Integer;
  LJoy: PALLEGRO_JOYSTICK;
  LJoyState: ALLEGRO_JOYSTICK_STATE;
  LI, LJ: Integer;
begin
  LJoyCount := al_get_num_joysticks;
  if (aNum < 0) or (aNum > LJoyCount - 1) then
    Exit;

  LJoy := al_get_joystick(aNum);
  if LJoy = nil then
  begin
    Sticks := 0;
    Buttons := 0;
    Exit;
  end;

  Name := string(al_get_joystick_name(LJoy));

  al_get_joystick_state(LJoy, @LJoyState);

  Sticks := al_get_joystick_num_sticks(LJoy);
  if (Sticks > MAX_STICKS) then
    Sticks := MAX_STICKS;

  for LI := 0 to Sticks - 1 do
  begin
    StickName[LI] := string(al_get_joystick_stick_name(LJoy, LI));
    Axes[LI] := al_get_joystick_num_axes(LJoy, LI);
    for LJ := 0 to Axes[LI] - 1 do
    begin
      Pos[LI, LJ] := LJoyState.stick[LI].axis[LJ];
      AxesName[LI, LJ] := string(al_get_joystick_axis_name(LJoy, LI, LJ));
    end;
  end;

  Buttons := al_get_joystick_num_buttons(LJoy);
  if (Buttons > MAX_BUTTONS) then
    Buttons := MAX_BUTTONS;

  for LI := 0 to Buttons - 1 do
  begin
    ButtonName[LI] := string(al_get_joystick_button_name(LJoy, LI));
    Button[LI] := Boolean(LJoyState.Button[LI] >= 16384);
  end
end;

function TJoystick.GetPos(aStick: Integer; aAxes: Integer): Single;
begin
  Result := Pos[aStick, aAxes];
end;

function TJoystick.GetButton(aButton: Integer): Boolean;
begin
  Result := Button[aButton];
end;

{ --- GAME ------------------------------------------------------------------ }

function fi_fopen(const path: PUTF8Char; const mode: PUTF8Char): Pointer; cdecl; forward;

{ TGame }
procedure TGame.Startup;
begin
  // init log
  FLog.Filename := '';
  FillChar(FLog.Buffer, SizeOf(FLog.Buffer), 0);
  FLog.Open := False;
  OpenLog;

  // init math
  Randomize;
  for var I := 0 to 360 do
  begin
    FCosTable[I] := cos((I * PI / 180.0));
    FSinTable[I] := sin((I * PI / 180.0));
  end;

  // init allegro
  al_install_system(ALLEGRO_VERSION_INT, nil);

  // init devices
  al_install_joystick;
  al_install_keyboard;
  al_install_mouse;
  al_install_touch_input;
  al_install_audio;

  // init addons
  al_init_acodec_addon;
  al_init_font_addon;
  al_init_image_addon;
  al_init_native_dialog_addon;
  al_init_primitives_addon;
  al_init_ttf_addon;
  al_init_video_addon;

  // init event queues
  FQueue := al_create_event_queue;
  al_register_event_source(FQueue, al_get_joystick_event_source);
  al_register_event_source(FQueue, al_get_keyboard_event_source);
  al_register_event_source(FQueue, al_get_mouse_event_source);
  al_register_event_source(FQueue, al_get_touch_input_event_source);
  al_register_event_source(FQueue, al_get_touch_input_mouse_emulation_event_source);

  // init audio
  if al_is_audio_installed then
  begin
    FAudio.Voice := al_create_voice(44100, ALLEGRO_AUDIO_DEPTH_INT16,  ALLEGRO_CHANNEL_CONF_2);
    FAudio.Mixer := al_create_mixer(44100, ALLEGRO_AUDIO_DEPTH_FLOAT32,  ALLEGRO_CHANNEL_CONF_2);
    al_set_default_mixer(FAudio.Mixer);
    al_attach_mixer_to_voice(FAudio.Mixer, FAudio.Voice);
    al_reserve_samples(AUDIO_CHANNEL_COUNT);
  end;

  // init timing
  SetUpdateSpeed(60);
  FTimer.Last := GetTime;

  // init lists
  FFontList := TDictionary<Int64, TFont>.Create;
  FBitmapList := TDictionary<Int64, TBitmap>.Create;
  FViewportList := TDictionary<Int64, TViewport>.Create;
  FSampleList := TDictionary<Int64, TSample>.Create;

  // init input
  FInput.Joystick.Setup(0);
  ClearInput;

  // init hud
  FHud.TextItemPadWidth := 10;
  FHud.Pos.Assign(3, 3, 0);

  // init physfs
  FZipArc.StandardFS := al_get_new_file_interface^;
  al_set_physfs_file_interface;
  FZipArc.PhysFS[0] := al_get_new_file_interface^;
  FZipArc.PhysFS[1] := al_get_new_file_interface^;
  FZipArc.PhysFS[1].fi_fopen := fi_fopen;
  al_set_new_file_interface(@FZipArc.PhysFS[1]);
  PHYSFS_init(nil);

  // init window
  FWindow.Viewport := ID_NIL;
end;

procedure TGame.Shutdown;
begin
  // shutdown physfs
  PHYSFS_deinit;

  // destroy lists
  FreeAndNil(FSampleList);
  FreeAndNil(FViewportList);
  FreeAndNil(FBitmapList);
  FreeAndNil(FFontList);

  // shutdown audio
  if al_is_audio_installed then
  begin
    al_stop_samples;
    al_detach_mixer(FAudio.Mixer);
    al_destroy_mixer(FAudio.Mixer);
    al_destroy_voice(FAudio.Voice);
    al_uninstall_audio;
  end;

  // shutdown event queues
  if al_is_event_source_registered(FQueue, al_get_touch_input_mouse_emulation_event_source) then
  begin
    al_unregister_event_source(FQueue, al_get_touch_input_mouse_emulation_event_source);
  end;

  if al_is_event_source_registered(FQueue, al_get_touch_input_event_source) then
  begin
    al_unregister_event_source(FQueue, al_get_touch_input_event_source);
  end;

  if al_is_event_source_registered(FQueue, al_get_keyboard_event_source) then
  begin
    al_unregister_event_source(FQueue, al_get_keyboard_event_source);
  end;

  if al_is_event_source_registered(FQueue, al_get_mouse_event_source) then
  begin
    al_unregister_event_source(FQueue, al_get_mouse_event_source);
  end;

  if al_is_event_source_registered(FQueue, al_get_joystick_event_source) then
  begin
    al_unregister_event_source(FQueue, al_get_joystick_event_source);
  end;

  // shutdown devices

  if al_is_touch_input_installed then
  begin
    al_uninstall_touch_input;
  end;

  if al_is_mouse_installed then
  begin
    al_uninstall_mouse;
  end;

  if al_is_keyboard_installed then
  begin
    al_uninstall_keyboard;
  end;

  if al_is_joystick_installed then
  begin
    al_uninstall_joystick;
  end;

  if al_is_system_installed then
  begin
    al_uninstall_system;
  end;

  // shutdown log
  CloseLog;
end;

procedure TGame.UpdateTiming;
begin
  FTimer.LNow := GetTime;
  FTimer.Passed := FTimer.LNow - FTimer.Last;
  FTimer.Last := FTimer.LNow;

  // process framerate
  Inc(FTimer.FrameCount);
  FTimer.FrameAccumulator := FTimer.FrameAccumulator + FTimer.Passed + EPSILON;
  if FTimer.FrameAccumulator >= 1 then
  begin
    FTimer.FrameAccumulator := 0;
    FTimer.FrameRate := FTimer.FrameCount;
    FTimer.FrameCount := 0;
  end;

  // process variable update
  FTimer.Accumulator := FTimer.Accumulator + FTimer.Passed;
  while (FTimer.Accumulator >= FTimer.DeltaTime) do
  begin
    OnUpdateFrame(FTimer.DeltaTime);
    FTimer.Accumulator := FTimer.Accumulator - FTimer.DeltaTime;
  end;
end;

function TGame.GenID: Int64;
begin
  Inc(FIDCounter);
  Result := FIDCounter;
end;

procedure TGame.FixupWindow;
begin
  var LWW: Integer := al_get_display_width(FWindow.Handle);
  var LWH: Integer := al_get_display_height(FWindow.Handle);
  al_resize_display(FWindow.Handle, LWW+1, LWH+1);
  al_resize_display(FWindow.Handle, LWW, LWH);
end;

function TGame.TransformScale(aFullscreen: Boolean): Single;
var
  LScreenX, LScreenY: Integer;
  LScaleX, LScaleY: Single;
  LClipX, LClipY: Single;
  LScale: Single;
begin
  Result := 1;
  if FWindow.Handle = nil then Exit;

  LScreenX := al_get_display_width(FWindow.Handle);
  LScreenY := al_get_display_height(FWindow.Handle);

  if aFullscreen then
    begin
      LScaleX := LScreenX / FWindow.Size.X;
      LScaleY := LScreenY / FWindow.Size.Y;
      LScale := min(LScaleX, LScaleY);
      LClipX := (LScreenX - LScale * FWindow.Size.X) / 2;
      LClipY := (LScreenY - LScale * FWindow.Size.Y) / 2;
      al_build_transform(@FWindow.Trans, LClipX, LClipY, LScale, LScale, 0);
      al_use_transform(@FWindow.Trans);
      al_set_clipping_rectangle(Round(LClipX), Round(LClipY), Round(LScreenX - 2 * LClipX), Round(LScreenY - 2 * LClipY));
      FWindow.TransSize.X := LClipX;
      FWindow.TransSize.Y := LClipY;
      FWindow.TransSize.Width := LScreenX - 2 * LClipX;
      FWindow.TransSize.Height := LScreenY - 2 * LClipY;
      Result := LScale;
      FWindow.TransScale := LScale;
    end
  else
    begin
      al_identity_transform(@FWindow.Trans);
      al_use_transform(@FWindow.Trans);
      al_set_clipping_rectangle(0, 0, Round(LScreenX), Round(LScreenY));
      FWindow.TransSize.X := 0;
      FWindow.TransSize.Y := 0;
      FWindow.TransSize.Width := LScreenX;
      FWindow.TransSize.Height := LScreenY;
      FWindow.TransScale := 1;
      ResizeForDPI;
    end;
end;

procedure TGame.ResizeForDPI;
begin
  var LDpi: Integer := GetDpiForWindow(al_get_win_window_handle(FWindow.Handle));
  var LSX,LSY: Integer;
  LSX := MulDiv(Round(FWindow.Size.X), LDPI, DISPLAY_DEFAULT_DPI);
  LSY := MulDiv(Round(FWindow.Size.Y), LDpi, DISPLAY_DEFAULT_DPI);

  var LWH: HWND := al_get_win_window_handle(FWindow.Handle);
  var LWX: Integer := (GetSystemMetrics(SM_CXFULLSCREEN) - LSX) div 2;
  var LWY: Integer := (GetSystemMetrics(SM_CYFULLSCREEN) - LSY) div 2;
  al_set_window_position(FWindow.Handle, LWX, LWY);
  al_resize_display(FWindow.Handle, LSX, LSY);

  var LScale: Single := min(LSX / FWindow.Size.x, LSY / FWindow.Size.Y);
  al_set_clipping_rectangle(0, 0, LSX, LSY);
  FWindow.TransSize.X := 0;
  FWindow.TransSize.Y := 0;
  FWindow.TransSize.Width := LSX;
  FWindow.TransSize.Height := LSY;
  FWindow.TransScale := LScale;
  FWindow.UpScale := LScale;
  al_build_transform(@FWindow.Trans, 0, 0, LScale, LScale, 0);
  al_use_transform(@FWindow.Trans);

  SetWindowLong(LWH, GWL_STYLE, GetWindowLong(LWH, GWL_STYLE) and (not WS_SIZEBOX) and (not WS_MAXIMIZEBOX));
  FixupWindow;
end;

procedure TGame.LoadDefaultIcon(aWnd: HWND);
var
  LHnd: THandle;
  LIco: TIcon;
begin
  LHnd := GetModuleHandle(nil);
  if LHnd <> 0 then
  begin
    if FindResource(LHnd, 'MAINICON', RT_GROUP_ICON) <> 0 then
    begin
      LIco := TIcon.Create;
      LIco.LoadFromResourceName(LHnd, 'MAINICON');
      SendMessage(aWnd, WM_SETICON, ICON_BIG, LIco.Handle);
      FreeAndNil(LIco);
    end;
  end;
end;

class function  TGame.HasConsoleOutput: Boolean;
var
  LStdout: THandle;
begin
  LStdout := GetStdHandle(Std_Output_Handle);
  Win32Check(LStdout <> Invalid_Handle_Value);
  Result := Boolean(LStdout <> 0);
end;

procedure TGame.OpenLog;
begin
  CloseLog;

  FLog.FormatSettings.DateSeparator := '/';
  FLog.FormatSettings.TimeSeparator := ':';
  FLog.FormatSettings.ShortDateFormat := 'DD-MM-YYY HH:NN:SS';
  FLog.FormatSettings.ShortTimeFormat := 'HH:NN:SS';

  FLog.Filename := ChangeFileExt(ParamStr(0), cLogExt);

  AssignFile(FLog.Text, FLog.Filename);
  ReWrite(FLog.Text);
  SetTextBuf(FLog.Text, FLog.Buffer);
  FLog.Open := True;
end;

procedure TGame.CloseLog;
begin
  if not FLog.Open then Exit;
  CloseFile(FLog.Text);
  FLog.Open := False;
end;

constructor TGame.Create;
begin
  inherited;
  if Game <> nil then
    raise Exception.Create('An instance of TGame is already active!');
  Game := Self;
  Startup;
end;

destructor TGame.Destroy;
begin
  Shutdown;
  Game := nil;
  inherited;
end;

// Log
procedure TGame.Log(const aMsg: string; const aArgs: array of const; aWriteToConsole: Boolean=False);
var
  LLine: string;
begin
  // get line
  LLine := Format(aMsg, aArgs);

  // write to console
  if HasConsoleOutput then
  begin
    if aWriteToConsole then
      WriteLn(LLine);
  end;

  // write to logfile
  {$I-}
  LLine := Format('%s %s', [DateTimeToStr(Now, FLog.FormatSettings), LLine]);
  Writeln(FLog.Text, LLine);
  Flush(FLog.Text);
  {$I+}
end;

// Console
class procedure TGame.ConsolePrint(const aMsg: string; const aArgs: array of const);
begin
  if not HasConsoleOutput then Exit;
  Write(Format(aMsg, aArgs));
end;

class procedure TGame.ConsolePrintLn(const aMsg: string; const aArgs: array of const);
begin
  if not HasConsoleOutput then Exit;
  WriteLn(Format(aMsg, aArgs));
end;

procedure TGame.Randomize;
begin
  System.Randomize;
end;

function TGame.RandomRange(aMin, aMax: Integer): Integer;
begin
  Result := System.Math.RandomRange(aMin, aMax + 1);
end;

function TGame.RandomRange(aMin, aMax: Single): Single;
var
  LN: Single;
begin
  LN := System.Math.RandomRange(0, MaxInt) / MaxInt;
  Result := aMin + (LN * (aMax - aMin));
end;

function TGame.RandomBool: Boolean;
begin
  Result := Boolean(System.Math.RandomRange(0, 2) = 1);
end;

function TGame.GetRandomSeed: Integer;
begin
  Result := RandSeed;
end;

procedure TGame.SetRandomSeed(aValue: Integer);
begin
  RandSeed := aValue;
end;

function TGame.AngleCos(aAngle: Integer): Single;
begin
  Result := 0;
  if (aAngle < 0) or (aAngle > 360) then Exit;
  Result := FCosTable[aAngle];
end;

function TGame.AngleSin(aAngle: Integer): Single;
begin
  Result := 0;
  if (aAngle < 0) or (aAngle > 360) then Exit;
  Result := FSinTable[aAngle];
end;

function TGame.AngleDifference(aSrcAngle: Single; aDestAngle: Single): Single;
var
  LC: Single;
begin
  LC := aDestAngle - aSrcAngle -
    (Floor((aDestAngle - aSrcAngle) / 360.0) * 360.0);

  if LC >= (360.0 / 2) then
  begin
    LC := LC - 360.0;
  end;
  Result := LC;
end;

procedure TGame.AngleRotatePos(aAngle: Single; var aX: Single; var aY: Single);
var
  LNX, LNY: Single;
  LIA: Integer;
begin
  ClipValue(aAngle, 0, 359, True);

  LIA := Round(aAngle);

  LNX := aX * FCosTable[LIA] - aY * FSinTable[LIA];
  LNY := aY * FCosTable[LIA] + aX * FSinTable[LIA];

  aX := LNX;
  aY := LNY;
end;

function TGame.ClipValue(var aValue: Single; aMin: Single; aMax: Single; aWrap: Boolean): Single;
begin
  if aWrap then
    begin
      if (aValue > aMax) then
      begin
        aValue := aMin + Abs(aValue - aMax);
        if aValue > aMax then
          aValue := aMax;
      end
      else if (aValue < aMin) then
      begin
        aValue := aMax - Abs(aValue - aMin);
        if aValue < aMin then
          aValue := aMin;
      end
    end
  else
    begin
      if aValue < aMin then
        aValue := aMin
      else if aValue > aMax then
        aValue := aMax;
    end;

  Result := aValue;

end;

function TGame.ClipValue(var aValue: Integer; aMin: Integer; aMax: Integer; aWrap: Boolean): Integer;
begin
  if aWrap then
    begin
      if (aValue > aMax) then
      begin
        aValue := aMin + Abs(aValue - aMax);
        if aValue > aMax then
          aValue := aMax;
      end
      else if (aValue < aMin) then
      begin
        aValue := aMax - Abs(aValue - aMin);
        if aValue < aMin then
          aValue := aMin;
      end
    end
  else
    begin
      if aValue < aMin then
        aValue := aMin
      else if aValue > aMax then
        aValue := aMax;
    end;

  Result := aValue;
end;

function TGame.SameSign(aValue1: Integer; aValue2: Integer): Boolean;
begin
  if Sign(aValue1) = Sign(aValue2) then
    Result := True
  else
    Result := False;
end;

function TGame.SameSign(aValue1: Single; aValue2: Single): Boolean;
begin
  if Sign(aValue1) = Sign(aValue2) then
    Result := True
  else
    Result := False;
end;

function TGame.SameValue(aA: Double; aB: Double; aEpsilon: Double = 0): Boolean;
begin
  Result := System.Math.SameValue(aA, aB, aEpsilon);
end;

function TGame.SameValue(aA: Single; aB: Single; aEpsilon: Single = 0): Boolean;
begin
  Result := System.Math.SameValue(aA, aB, aEpsilon);
end;

function TGame.Point(aX: Integer; aY: Integer): TPointi;
begin
  Result.X := aX;
  Result.Y := aY;
end;

function TGame.Point(aX: Single; aY: Single): TPointf;
begin
  Result.X := aX;
  Result.Y := aY;
end;

function TGame.Vector(aX: Single; aY: Single): TVector;
begin
  Result.X := aX;
  Result.Y := aY;
  Result.Z := 0;
end;

function TGame.Rectangle(aX: Single; aY: Single; aWidth: Single; aHeight: Single): TRectangle;
begin
  Result.X := aX;
  Result.Y := aY;
  Result.Width := aWidth;
  Result.Height := aHeight;
end;

procedure TGame.SmoothMove(var aValue: Single; aAmount: Single; aMax: Single; aDrag: Single);
var
  LAmt: Single;
begin
  LAmt := aAmount;

  if LAmt > 0 then
  begin
    aValue := aValue + LAmt;
    if aValue > aMax then
      aValue := aMax;
  end else if LAmt < 0 then
  begin
    aValue := aValue + LAmt;
    if aValue < -aMax then
      aValue := -aMax;
  end else
  begin
    if aValue > 0 then
    begin
      aValue := aValue - aDrag;
      if aValue < 0 then
        aValue := 0;
    end else if aValue < 0 then
    begin
      aValue := aValue + aDrag;
      if aValue > 0 then
        aValue := 0;
    end;
  end;
end;

function TGame.Lerp(aFrom: Double; aTo: Double; aTime: Double): Double;
begin
  if aTime <= 0.5 then
    Result := aFrom + (aTo - aFrom) * aTime
  else
    Result := aTo - (aTo - aFrom) * (1.0 - aTime);
end;

// Collision
function TGame.PointInRectangle(aPoint: TVector; aRect: TRectangle): Boolean;
begin
  if ((aPoint.x >= aRect.x) and (aPoint.x <= (aRect.x + aRect.width)) and
    (aPoint.y >= aRect.y) and (aPoint.y <= (aRect.y + aRect.height))) then
    Result := True
  else
    Result := False;
end;

function TGame.PointInCircle(aPoint: TVector; aCenter: TVector; aRadius: Single): Boolean;
begin
  Result := CirclesOverlap(aPoint, 0, aCenter, aRadius);
end;

function TGame.PointInTriangle(aPoint: TVector; aP1: TVector; aP2: TVector; aP3: TVector): Boolean;
var
  LAlpha, LBeta, LGamma: Single;
begin
  LAlpha := ((aP2.y - aP3.y) * (aPoint.x - aP3.x) + (aP3.x - aP2.x) *
    (aPoint.y - aP3.y)) / ((aP2.y - aP3.y) * (aP1.x - aP3.x) + (aP3.x - aP2.x) *
    (aP1.y - aP3.y));

  LBeta := ((aP3.y - aP1.y) * (aPoint.x - aP3.x) + (aP1.x - aP3.x) *
    (aPoint.y - aP3.y)) / ((aP2.y - aP3.y) * (aP1.x - aP3.x) + (aP3.x - aP2.x) *
    (aP1.y - aP3.y));

  LGamma := 1.0 - LAlpha - LBeta;

  if ((LAlpha > 0) and (LBeta > 0) and (LGamma > 0)) then
    Result := True
  else
    Result := False;
end;

function TGame.CirclesOverlap(aCenter1: TVector; aRadius1: Single; aCenter2: TVector; aRadius2: Single): Boolean;
var
  LDX, LDY, LDistance: Single;
begin
  LDX := aCenter2.x - aCenter1.x; // X distance between centers
  LDY := aCenter2.y - aCenter1.y; // Y distance between centers

  LDistance := sqrt(LDX * LDX + LDY * LDY); // Distance between centers

  if (LDistance <= (aRadius1 + aRadius2)) then
    Result := True
  else
    Result := False;
end;

function TGame.CircleInRectangle(aCenter: TVector; aRadius: Single; aRect: TRectangle): Boolean;
var
  LDX, LDY: Single;
  LCornerDistanceSq: Single;
  LRecCenterX: Integer;
  LRecCenterY: Integer;
begin
  LRecCenterX := Round(aRect.x + aRect.width / 2);
  LRecCenterY := Round(aRect.y + aRect.height / 2);

  LDX := abs(aCenter.x - LRecCenterX);
  LDY := abs(aCenter.y - LRecCenterY);

  if (LDX > (aRect.width / 2.0 + aRadius)) then
  begin
    Result := False;
    Exit;
  end;

  if (LDY > (aRect.height / 2.0 + aRadius)) then
  begin
    Result := False;
    Exit;
  end;

  if (LDX <= (aRect.width / 2.0)) then
  begin
    Result := True;
    Exit;
  end;
  if (LDY <= (aRect.height / 2.0)) then
  begin
    Result := True;
    Exit;
  end;

  LCornerDistanceSq := (LDX - aRect.width / 2.0) * (LDX - aRect.width / 2.0) +
    (LDY - aRect.height / 2.0) * (LDY - aRect.height / 2.0);

  Result := Boolean(LCornerDistanceSq <= (aRadius * aRadius));
end;

function TGame.RectanglesOverlap(aRect1: TRectangle; aRect2: TRectangle): Boolean;
var
  LDX, LDY: Single;
begin
  LDX := abs((aRect1.x + aRect1.width / 2) - (aRect2.x + aRect2.width / 2));
  LDY := abs((aRect1.y + aRect1.height / 2) - (aRect2.y + aRect2.height / 2));

  if ((LDX <= (aRect1.width / 2 + aRect2.width / 2)) and
    ((LDY <= (aRect1.height / 2 + aRect2.height / 2)))) then
    Result := True
  else
    Result := False;
end;

function TGame.RectangleIntersection(aRect1, aRect2: TRectangle): TRectangle;
var
  LDXX, LDYY: Single;
begin
  Result.Assign(0, 0, 0, 0);

  if RectanglesOverlap(aRect1, aRect2) then
  begin
    LDXX := abs(aRect1.x - aRect2.x);
    LDYY := abs(aRect1.y - aRect2.y);

    if (aRect1.x <= aRect2.x) then
    begin
      if (aRect1.y <= aRect2.y) then
      begin
        Result.x := aRect2.x;
        Result.y := aRect2.y;
        Result.width := aRect1.width - LDXX;
        Result.height := aRect1.height - LDYY;
      end
      else
      begin
        Result.x := aRect2.x;
        Result.y := aRect1.y;
        Result.width := aRect1.width - LDXX;
        Result.height := aRect2.height - LDYY;
      end
    end
    else
    begin
      if (aRect1.y <= aRect2.y) then
      begin
        Result.x := aRect1.x;
        Result.y := aRect2.y;
        Result.width := aRect2.width - LDXX;
        Result.height := aRect1.height - LDYY;
      end
      else
      begin
        Result.x := aRect1.x;
        Result.y := aRect1.y;
        Result.width := aRect2.width - LDXX;
        Result.height := aRect2.height - LDYY;
      end
    end;

    if (aRect1.width > aRect2.width) then
    begin
      if (Result.width >= aRect2.width) then
        Result.width := aRect2.width;
    end
    else
    begin
      if (Result.width >= aRect1.width) then
        Result.width := aRect1.width;
    end;

    if (aRect1.height > aRect2.height) then
    begin
      if (Result.height >= aRect2.height) then
        Result.height := aRect2.height;
    end
    else
    begin
      if (Result.height >= aRect1.height) then
        Result.height := aRect1.height;
    end
  end;
end;

function TGame.LineIntersection(aX1, aY1, aX2, aY2, aX3, aY3, aX4, aY4: Integer; var aX: Integer; var aY: Integer): TLineIntersection;
var
  LAX, LBX, LCX, LAY, LBY, LCY, LD, LE, LF, LNum: Integer;
  LOffset: Integer;
  LX1Lo, LX1Hi, LY1Lo, LY1Hi: Integer;
begin
  Result := liNone;

  LAX := aX2 - aX1;
  LBX := aX3 - aX4;

  if (LAX < 0) then // X bound box test
  begin
    LX1Lo := aX2;
    LX1Hi := aX1;
  end
  else
  begin
    LX1Hi := aX2;
    LX1Lo := aX1;
  end;

  if (LBX > 0) then
  begin
    if (LX1Hi < aX4) or (aX3 < LX1Lo) then
      Exit;
  end
  else
  begin
    if (LX1Hi < aX3) or (aX4 < LX1Lo) then
      Exit;
  end;

  LAY := aY2 - aY1;
  LBY := aY3 - aY4;

  if (LAY < 0) then // Y bound box test
  begin
    LY1Lo := aY2;
    LY1Hi := aY1;
  end
  else
  begin
    LY1Hi := aY2;
    LY1Lo := aY1;
  end;

  if (LBY > 0) then
  begin
    if (LY1Hi < aY4) or (aY3 < LY1Lo) then
      Exit;
  end
  else
  begin
    if (LY1Hi < aY3) or (aY4 < LY1Lo) then
      Exit;
  end;

  LCX := aX1 - aX3;
  LCY := aY1 - aY3;
  LD := LBY * LCX - LBX * LCY; // alpha numerator
  LF := LAY * LBX - LAX * LBY; // both denominator

  if (LF > 0) then // alpha tests
  begin
    if (LD < 0) or (LD > LF) then
      Exit;
  end
  else
  begin
    if (LD > 0) or (LD < LF) then
      Exit
  end;

  LE := LAX * LCY - LAY * LCX; // beta numerator
  if (LF > 0) then // beta tests
  begin
    if (LE < 0) or (LE > LF) then
      Exit;
  end
  else
  begin
    if (LE > 0) or (LE < LF) then
      Exit;
  end;

  // compute intersection coordinates

  if (LF = 0) then
  begin
    Result := liParallel;
    Exit;
  end;

  LNum := LD * LAX; // numerator
  // if SameSigni(num, f) then
  if Sign(LNum) = Sign(LF) then

    LOffset := LF div 2
  else
    LOffset := -LF div 2;
  aX := aX1 + (LNum + LOffset) div LF; // intersection x

  LNum := LD * LAY;
  // if SameSigni(num, f) then
  if Sign(LNum) = Sign(LF) then
    LOffset := LF div 2
  else
    LOffset := -LF div 2;

  aY := aY1 + (LNum + LOffset) div LF; // intersection y

  Result := liTrue;
end;

function TGame.RadiusOverlap(aRadius1: Single; aX1: Single; aY1: Single; aRadius2: Single; aX2: Single; aY2: Single; aShrinkFactor: Single): Boolean;

var
  LDist: Single;
  LR1, LR2: Single;
  LV1, LV2: TVector;
begin
  LR1 := aRadius1 * aShrinkFactor;
  LR2 := aRadius2 * aShrinkFactor;

  LV1.x := aX1;
  LV1.y := aY1;
  LV2.x := aX2;
  LV2.y := aY2;

  LDist := LV1.distance(LV2);

  if (LDist < LR1) or (LDist < LR2) then
    Result := True
  else
    Result := False;
end;


// Color
function TGame.MakeColor(aRed: Byte; aGreen: Byte; aBlue: Byte; aAlpha: Byte): TColor;
var
  LColor: ALLEGRO_COLOR absolute Result;
begin
  LColor := al_map_rgba(aRed, aGreen, aBlue, aAlpha);
  Result.Red := LColor.r;
  Result.Green := LColor.g;
  Result.Blue := LColor.b;
  Result.Alpha := LColor.a;
end;

function TGame.MakeColor(aRed: Single; aGreen: Single; aBlue: Single; aAlpha: Single): TColor;
var
  LColor: ALLEGRO_COLOR absolute Result;
begin
  LColor := al_map_rgba_f(aRed, aGreen, aBlue, aAlpha);
  Result.Red := LColor.r;
  Result.Green := LColor.g;
  Result.Blue := LColor.b;
  Result.Alpha := LColor.a;
end;

function TGame.MakeColor(const aName: string): TColor;
var
  LMarshaller: TMarshaller;
  LColor: ALLEGRO_COLOR absolute Result;
begin
  LColor := al_color_name(LMarshaller.AsAnsi(aName).ToPointer);
  Result.Red := LColor.r;
  Result.Green := LColor.g;
  Result.Blue := LColor.b;
  Result.Alpha := LColor.a;
end;

function TGame.FadeColor(var aFrom: TColor; aTo: TColor; aPos: Single): TColor;
var
  LColor: TColor;
begin
  // clip to ranage 0.0 - 1.0
  if aPos < 0 then
    aPos := 0
  else if aPos > 1.0 then
    aPos := 1.0;

  // fade colors
  LColor.Alpha := aFrom.Alpha + ((aTo.Alpha - aFrom.Alpha) * aPos);
  LColor.Blue := aFrom.Blue + ((aTo.Blue - aFrom.Blue) * aPos);
  LColor.Green := aFrom.Green + ((aTo.Green - aFrom.Green) * aPos);
  LColor.Red := aFrom.Red + ((aTo.Red - aFrom.Red) * aPos);
  Result := MakeColor(LColor.Red, LColor.Green, LColor.Blue, LColor.Alpha);
  aFrom.Red := LColor.Red;
  aFrom.Green := LColor.Green;
  aFrom.Blue := LColor.Blue;
  aFrom.Alpha := LColor.Alpha;
end;

function TGame.ColorEqual(aColor1: TColor; aColor2: TColor): Boolean;
begin
  if (aColor1.Red = aColor2.Red) and (aColor1.Green = aColor2.Green) and
    (aColor1.Blue = aColor2.Blue) and (aColor1.Alpha = aColor2.Alpha) then
    Result := True
  else
    Result := False;
end;

function  TGame.GetTime: Double;
begin
   Result := al_get_time;
end;

procedure TGame.ResetTiming;
begin
  FTimer.LNow := 0;
  FTimer.Passed := 0;
  FTimer.Last := 0;

  FTimer.Accumulator := 0;
  FTimer.FrameAccumulator := 0;

  FTimer.DeltaTime := 0;

  FTimer.FrameCount := 0;
  FTimer.FrameRate := 0;

  SetUpdateSpeed(FTimer.UpdateSpeed);

  FTimer.Last := GetTime;
end;

procedure TGame.SetUpdateSpeed(aSpeed: Single);
begin
  FTimer.UpdateSpeed := aSpeed;
  FTimer.DeltaTime := 1.0 / FTimer.UpdateSpeed;
end;

function  TGame.GetUpdateSpeed: Single;
begin
  Result := FTimer.UpdateSpeed;
end;

function  TGame.GetDeltaTime: Double;
begin
  Result := FTimer.DeltaTime;
end;

function  TGame.GetFrameRate: Cardinal;
begin
  Result := FTimer.FrameRate;
end;

function  TGame.FrameSpeed(var aTimer: Single; aSpeed: Single): Boolean;
begin
  Result := False;
  aTimer := aTimer + (aSpeed / FTimer.UpdateSpeed);
  if aTimer >= 1.0 then
  begin
    aTimer := 0;
    Result := True;
  end;
end;

function  TGame.FrameElapsed(var aTimer: Single; aFrames: Single): Boolean;
begin
  Result := False;
  aTimer := aTimer + FTimer.DeltaTime;
  if aTimer > aFrames then
  begin
    aTimer := 0;
    Result := True;
  end;
end;

// Window
function  TGame.OpenWindow(aWidth: Integer; aHeight: Integer; aTitle: string; aFullscreen: Boolean): Boolean;
var
  LMarshaller: TMarshaller;
begin
  Result := False;
  if FWindow.Handle <> nil then Exit;
  al_set_new_display_flags(ALLEGRO_OPENGL_3_0 or ALLEGRO_RESIZABLE or ALLEGRO_PROGRAMMABLE_PIPELINE);
  al_set_new_display_option(ALLEGRO_COMPATIBLE_DISPLAY, 1, ALLEGRO_REQUIRE);
  al_set_new_display_option(ALLEGRO_VSYNC, 1, ALLEGRO_SUGGEST);
  al_set_new_display_option(ALLEGRO_CAN_DRAW_INTO_BITMAP, 1, ALLEGRO_REQUIRE);
  al_set_new_display_option(ALLEGRO_SAMPLE_BUFFERS, 1, ALLEGRO_SUGGEST);
  al_set_new_display_option(ALLEGRO_SAMPLES, 8, ALLEGRO_SUGGEST);
  al_set_new_window_title(LMarshaller.AsUtf8(aTitle).ToPointer);
  FWindow.Handle := al_create_display(aWidth, aHeight);
  if FWindow.Handle = nil then Exit;
  LoadDefaultIcon(al_get_win_window_handle(FWindow.Handle));
  al_register_event_source(FQueue, al_get_display_event_source(FWindow.Handle));
  FWindow.Size.X := aWidth;
  FWindow.Size.Y := aHeight;
  FWindow.Fullscreen := aFullscreen;
  TransformScale(aFullscreen);
end;

procedure TGame.CloseWindow;
begin
  if FWindow.Handle = nil then Exit;
  //al_uninstall_haptic;
  DestroyAllViewports;
  UnloadAllFonts;
  UnloadAllBitmaps;
  al_destroy_display(FWindow.Handle);
end;

procedure TGame.SetWindowTitle(const aTitle: string);
var
  LMarshaller: TMarshaller;
begin
  if FWindow.Handle = nil then Exit;
  al_set_window_title(FWindow.Handle, LMarshaller.AsUtf8(aTitle).ToPointer);
end;

function  TGame.IsWindowOpen: Boolean;
begin
  Result := Boolean(FWindow.Handle <> nil);
end;

procedure TGame.ClearWindow(aColor: TColor);
var
  LColor: ALLEGRO_COLOR absolute aColor;
begin
  if FWindow.Handle = nil then Exit;
  al_clear_to_color(LColor);
end;

procedure TGame.ShowWindow;
begin
  if FWindow.Handle = nil then Exit;
  al_flip_display;
end;

procedure TGame.ToggleFullscreenWindow;
var
  LFlags: Integer;
  LFullscreen: Boolean;
  LMX, LMY: Integer;

  function IsOnPrimaryMonitor: Boolean;
  begin
    Result := Screen.MonitorFromWindow(al_get_win_window_handle(FWindow.Handle), mdPrimary).Primary
  end;

begin
  if FWindow.Handle = nil then Exit;
  MouseGetInfo(@LMX, @LMY, nil);
  LFlags := al_get_display_flags(FWindow.Handle);
  LFullscreen := Boolean(LFlags and ALLEGRO_FULLSCREEN_WINDOW = ALLEGRO_FULLSCREEN_WINDOW);
  LFullscreen := not LFullscreen;

  // we can only go fullscreen on primrary monitor
  if LFullscreen and (not IsOnPrimaryMonitor) then Exit;
  //if LFullscreen then Exit;


  al_set_display_flag(FWindow.Handle, ALLEGRO_FULLSCREEN_WINDOW, LFullscreen);
  TransformScale(LFullscreen);
  FWindow.Fullscreen := LFullscreen;
  //if not FFullscreen then ResizeForDPI;
  MouseSetPos(LMX, LMY);
  MouseShowCursor(True);
  //Piro.ResetTiming;
end;

function  TGame.IsWindowFullscreen: Boolean;
begin
  Result := FWindow.Fullscreen;
end;

procedure TGame.SetWindowTarget(aBitmap: Int64);
var
  LBitmap: TBitmap;
begin
  if aBitmap = ID_NIL then Exit;
  if not FBitmapList.TryGetValue(aBitmap, LBitmap) then Exit;
  if LBitmap.Handle = nil then Exit;
  al_set_target_bitmap(LBitmap.Handle);
end;

procedure TGame.ResetWindowTarget;
begin
  if FWindow.Handle = nil then Exit;
  al_set_target_backbuffer(FWindow.Handle);
end;

// TODO: handle case where viewport object is destroyed
// while still being active, FViewport will then be
// invalid. A possible solution would be to have a parent
// in TViewport and if its destroyed then let parent know
// so it can take appropriet action
// UPDATE: now what I do is if the current view is about
// to be destroyed, if its active, it call SetViewport(ID_NIL)
// to deactivate before its released to set the viewport
// back to full screen.
procedure TGame.SetWindowViewport(aViewport: Int64);
begin
  if FWindow.Handle = nil then Exit;

  if aViewport <> ID_NIL then
    begin
      // check if same as current
      if FWindow.Viewport = aViewport then
        Exit
      else
      // setting a new viewport when one is current
      begin
        // set to not active to show it
        if FWindow.Viewport <> ID_NIL then
        begin
          SetViewportActive(FWindow.Viewport, False);
        end;
      end;

      FWindow.Viewport := aViewport;
      SetViewportActive(FWindow.Viewport, True);
    end
  else
    begin
      if FWindow.Viewport <> ID_NIL then
      begin
        SetViewportActive(FWindow.Viewport, False);
        FWindow.Viewport := ID_NIL;
      end;
    end;
end;

procedure TGame.GetWindowViewportSize(aX: PInteger; aY: PInteger; aWidth: PInteger; aHeight: PInteger);
begin
  if FWindow.Handle = nil then Exit;

  if FWindow.Viewport <> ID_NIL then
    begin
      GetViewportSize(FWindow.Viewport, aX, aY, aWidth, aHeight);
    end
  else
    begin
      if aX <> nil then
        aX^ := 0;
      if aY <> nil then
        aY^ := 0;
      GetWindowSize(aWidth, aHeight);
    end;
end;

procedure TGame.GetWindowViewportSize(var aSize: TRectangle);
var
  LVX,LVY,LVW,LVH: Integer;
begin
  GetWindowViewportSize(@LVX, @LVY, @LVW, @LVH);
  aSize.X := LVX;
  aSize.Y := LVY;
  aSize.Width := LVW;
  aSize.Height := LVH;
end;

procedure TGame.GetWindowSize(aWidth: System.PInteger; aHeight: System.PInteger; aAspectRatio: System.PSingle);
begin
  if FWindow.Handle = nil then  Exit;
  if aWidth <> nil then
    aWidth^ := Round(FWindow.Size.X);

  if aHeight <> nil then
    aHeight^ := Round(FWindow.Size.Y);

  if aAspectRatio <> nil then
    aAspectRatio^ := FWindow.Size.X / FWindow.Size.Y;
end;

procedure TGame.ResetWindowTransform;
begin
  if FWindow.Handle = nil then Exit;
  al_use_transform(@FWindow.Trans);
end;

procedure TGame.SetWindowTransformPosition(aX: Integer; aY: Integer);
var
  LTrans: ALLEGRO_TRANSFORM;
begin
  if FWindow.Handle = nil then Exit;
  al_copy_transform(@LTrans, al_get_current_transform);
  al_translate_transform(@LTrans, aX, aY);
  al_use_transform(@LTrans);
end;
procedure TGame.SetWindowTransformAngle(aAngle: Single);
var
  LTrans: ALLEGRO_TRANSFORM;
  LX, LY: Integer;
begin
  if FWindow.Handle = nil then Exit;
  LX := al_get_display_width(FWindow.Handle);
  LY := al_get_display_height(FWindow.Handle);

  al_copy_transform(@FWindow.Trans, al_get_current_transform);
  al_translate_transform(@FWindow.Trans, -(LX div 2), -(LY div 2));
  al_rotate_transform(@LTrans, aAngle * DEG2RAD);
  al_translate_transform(@LTrans, 0, 0);
  al_translate_transform(@LTrans, LX div 2, LY div 2);
  al_use_transform(@LTrans);
end;

function TGame.SaveWindow(const aFilename: string): Boolean;
var
  LBackbuffer: PALLEGRO_BITMAP;
  LScreenshot: PALLEGRO_BITMAP;
  LVX, LVY, LVW, LVH: Integer;
  LFilename: string;
  LMarshallar: TMarshaller;
begin
  Result := False;

  if FWindow.Handle = nil then Exit;

  // get viewport size
  LVX := Round(FWindow.TransSize.X);
  LVY := Round(FWindow.TransSize.Y);
  LVW := Round(FWindow.TransSize.Width);
  LVH := Round(FWindow.TransSize.Height);

  // create LScreenshot bitmpat
  al_set_new_bitmap_flags(ALLEGRO_MIN_LINEAR or ALLEGRO_MAG_LINEAR);
  LScreenshot := al_create_bitmap(LVW, LVH);

  // exit if failed to create LScreenshot bitmap
  if LScreenshot = nil then Exit;

  // get LBackbuffer
  LBackbuffer := al_get_backbuffer(FWindow.Handle);

  // set target to LScreenshot bitmap
  al_set_target_bitmap(LScreenshot);

  // draw viewport area of LBackbuffer to LScreenshot bitmap
  al_draw_bitmap_region(LBackbuffer, LVX, LVY, LVW, LVH, 0, 0, 0);

  // restore LBackbuffer target
  al_set_target_bitmap(LBackbuffer);

  // make sure filename is a PNG file
  LFilename := aFilename;
  LFilename := ChangeFileExt(LFilename, cPngExt);

  // save screen bitmap to PNG filename
  Result := al_save_bitmap(LMarshallar.AsAnsi(LFilename).ToPointer, LScreenshot);

  // destroy LScreenshot bitmap
  al_destroy_bitmap(LScreenshot);
end;

// Viewport
function TGame.CreateViewport(aX: Integer; aY: Integer; aWidth: Integer; aHeight: Integer): Int64;
var
  LViewport: TViewport;
begin
  Result := ID_NIL;
  LViewport.Bitmap := AllocBitmap(aWidth, aHeight);
  if LViewport.Bitmap = ID_NIL then Exit;
  LViewport.Pos.X := aX;
  LViewport.Pos.Y := aY;
  LViewport.Pos.Width := aWidth;
  LViewport.Pos.Height := aHeight;
  LViewport.Half.X := aWidth/2;
  LViewport.Half.Y := aHeight/2;
  LViewport.Center.Assign(0.5, 0.5);
  LViewport.Active := False;
  Result := GenID;
  FViewportList.Add(Result, LViewport);
end;

procedure TGame.DestroyViewport(var aViewport: Int64);
var
  LViewport: TViewport;
begin
  if not FViewportList.TryGetValue(aViewport, LViewport) then Exit;
  if LViewport.Bitmap = ID_NIL then Exit;
  if LViewport.Active then
  begin
    // this fixes the is issue where if the active viewport is destroyed
    // while active, then just pass ID_NIL to Display.SetViewport to restore
    // the fullscreen viewport instead
    SetWindowViewport(ID_NIL);
  end;
  SetViewportActive(aViewport, False);
  UnloadBitmap(LViewport.Bitmap);
  FViewportList.Remove(aViewport);
  aViewport := ID_NIL;
end;

procedure TGame.DestroyAllViewports;
var
  LItem: Int64;
  LViewport: Int64;
begin
  for LItem in FViewportList.Keys do
  begin
    LViewport := LItem;
    DestroyViewport(LViewport);
  end;
  FViewportList.Clear;
end;

procedure TGame.SetViewportActive(aViewport: Int64; aActive: Boolean);
var
  LViewport: TViewport;
begin
  if not FViewportList.TryGetValue(aViewport, LViewport) then Exit;
  if LViewport.Bitmap = ID_NIL then Exit;

  if aActive then
    begin
      if LViewport.Active then Exit;
      SetWindowTarget(LViewport.Bitmap);
    end
  else
    begin
      if not LViewport.Active then Exit;
      ResetWindowTarget;
      DrawBitmap(LViewport.Bitmap, LViewport.Pos.X+LViewport.Half.X, LViewport.Pos.Y+LViewport.Half.Y, nil, @LViewport.Center, nil, LViewport.Angle, WHITE, False, False);
    end;

  LViewport.Active := aActive;
  FViewportList.Items[aViewport] := LViewport;
end;

function  TGame.GetViewportActive(aViewport: Int64): Boolean;
var
  LViewport: TViewport;
begin
  Result := False;
  if not FViewportList.TryGetValue(aViewport, LViewport) then Exit;
  Result := LViewport.Active;
end;

procedure TGame.SetViewportPosition(aViewport: Int64; aX: Integer; aY: Integer);
var
  LViewport: TViewport;
begin
  if not FViewportList.TryGetValue(aViewport, LViewport) then Exit;
  LViewport.Pos.X := aX;
  LViewport.Pos.Y := aY;
  FViewportList.Items[aViewport] := LViewport;
end;

procedure TGame.GetViewportSize(aViewport: Int64; aX: PInteger; aY: PInteger; aWidth: PInteger; aHeight: PInteger);
var
  LViewport: TViewport;
begin
  if not FViewportList.TryGetValue(aViewport, LViewport) then Exit;
  if LViewport.Bitmap = ID_NIL then Exit;

  if aX <> nil then
    aX^ := Round(LViewport.Pos.X);
  if aY <>nil then
    aY^ := Round(LViewport.Pos.Y);
  if aWidth <> nil then
    aWidth^ := Round(LViewport.Pos.Width);
  if aHeight <> nil then
    aHeight^ := Round(LViewport.Pos.Height);
end;

procedure TGame.SetViewportAngle(aViewport: Int64; aAngle: Single);
var
  LViewport: TViewport;
begin
  if not FViewportList.TryGetValue(aViewport, LViewport) then Exit;
  LViewport.Angle := aAngle;
  //gEngine.Math.ClipValue(FAngle, 0, 359, True);
  if LViewport.Angle > 359 then
    begin
      while LViewport.Angle > 359 do
      begin
        LViewport.Angle := LViewport.Angle - 359;
      end;
    end
  else
  if LViewport.Angle < 0 then
    begin
      while LViewport.Angle < 0 do
      begin
        LViewport.Angle := LViewport.Angle + 359;
      end;
    end;
  FViewportList.Items[aViewport] := LViewport;
end;

function  TGame.GetViewportAngle(aViewport: Int64): Single;
var
  LViewport: TViewport;
begin
  Result := 0;
  if not FViewportList.TryGetValue(aViewport, LViewport) then Exit;
  Result := LViewport.Angle;
end;

procedure TGame.AlignViewport(aViewport: Int64; var aX: Single; var aY: Single);
var
  LViewport: TViewport;
begin
  if not FViewportList.TryGetValue(aViewport, LViewport) then Exit;
  aX := LViewport.Pos.X + aX;
  aY := LViewport.Pos.Y + aY;
end;

procedure TGame.AlignViewport(aViewport: Int64; var aPos: TVector);
var
  LViewport: TViewport;
begin
  if not FViewportList.TryGetValue(aViewport, LViewport) then Exit;
  aPos.X := LViewport.Pos.X + aPos.X;
  aPos.Y := LViewport.Pos.Y + aPos.Y;
end;

procedure TGame.ResetViewport;
begin
  if FWindow.Handle = nil then Exit;
  if FWindow.Viewport <> ID_NIL then
  begin
    SetViewportActive(FWindow.Viewport, False);
  end;
end;

// Input
procedure TGame.ClearInput;
begin
  FillChar(FInput.MouseButtons, SizeOf(FInput.MouseButtons), False);
  FillChar(FInput.KeyButtons, SizeOf(FInput.KeyButtons), False);
  FillChar(FInput.JoyButtons, SizeOf(FInput.JoyButtons), False);

  if FWindow.Handle <> nil then
  begin
    al_clear_keyboard_state(FWindow.Handle);
  end;
end;

function TGame.KeyboardPressed(aKey: Integer): Boolean;
begin
  Result := False;
  if not InRange(aKey, 0, 255) then  Exit;
  if KeyboardDown(aKey) and (not FInput.KeyButtons[aKey]) then
  begin
    FInput.KeyButtons[aKey] := True;
    Result := True;
  end
  else if (not KeyboardDown(aKey)) and (FInput.KeyButtons[aKey]) then
  begin
    FInput.KeyButtons[aKey] := False;
    Result := False;
  end;
end;

function TGame.KeyboardReleased(aKey: Integer): Boolean;
begin
  Result := False;
  if not InRange(aKey, 0, 255) then Exit;
  if KeyboardDown(aKey) and (not FInput.KeyButtons[aKey]) then
  begin
    FInput.KeyButtons[aKey] := True;
    Result := False;
  end
  else if (not KeyboardDown(aKey)) and (FInput.KeyButtons[aKey]) then
  begin
    FInput.KeyButtons[aKey] := False;
    Result := True;
  end;
end;

function TGame.KeyboardDown(aKey: Integer): Boolean;
begin
  Result := False;
  if not InRange(aKey, 0, 255) then Exit;
  Result := al_key_down(@FInput.KeyboardState, aKey);
end;

function TGame.KeyboardGetPressed: Integer;
begin
  Result := FInput.KeyCode;
end;

function TGame.MousePressed(aButton: Integer): Boolean;
begin
  Result := False;
  if not InRange(aButton, MOUSE_BUTTON_LEFT, MOUSE_BUTTON_MIDDLE) then Exit;

  if MouseDown(aButton) and (not FInput.MouseButtons[aButton]) then
  begin
    FInput.MouseButtons[aButton] := True;
    Result := True;
  end
  else if (not MouseDown(aButton)) and (FInput.MouseButtons[aButton]) then
  begin
    FInput.MouseButtons[aButton] := False;
    Result := False;
  end;
end;

function TGame.MouseReleased(aButton: Integer): Boolean;
begin
  Result := False;
  if not InRange(aButton, MOUSE_BUTTON_LEFT, MOUSE_BUTTON_MIDDLE) then Exit;

  if MouseDown(aButton) and (not FInput.MouseButtons[aButton]) then
  begin
    FInput.MouseButtons[aButton] := True;
    Result := False;
  end
  else if (not MouseDown(aButton)) and (FInput.MouseButtons[aButton]) then
  begin
    FInput.MouseButtons[aButton] := False;
    Result := True;
  end;

end;

function TGame.MouseDown(aButton: Integer): Boolean;
var
  LState: ALLEGRO_MOUSE_STATE;
begin
  Result := False;
  if not InRange(aButton, MOUSE_BUTTON_LEFT, MOUSE_BUTTON_MIDDLE) then Exit;
  al_get_mouse_state(@LState);
  Result := al_mouse_button_down(@LState, aButton);
end;

procedure TGame.MouseGetInfo(var aPos: TVector);
var
  LX, LY, LZ: Integer;
begin
  MouseGetInfo(@LX, @LY, @LZ);
  aPos.x := LX;
  aPos.y := LY;
  aPos.z := LZ;
end;

procedure TGame.MouseGetInfo(aX: PInteger; aY: PInteger; aWheel: PInteger);
var
  LState: ALLEGRO_MOUSE_STATE;
  LMX, LMY, LMW: Integer;
  LVX, LVY: Integer;
begin

  LVX := Round(FWindow.TransSize.x);
  LVY := Round(FWindow.TransSize.y);

  al_get_mouse_state(@LState);
  LMX := al_get_mouse_state_axis(@LState, 0);
  LMY := al_get_mouse_state_axis(@LState, 1);
  LMW := al_get_mouse_state_axis(@LState, 2);

  var LDpi: Integer := GetDpiForWindow(al_get_win_window_handle(FWindow.Handle));
  if (LDpi <> DISPLAY_DEFAULT_DPI) then
  begin
    LMX := Round((LMX - LVX) / FWindow.TransScale);
    LMY := Round((LMY - LVY) / FWindow.TransScale);
  end;

  if aX <> nil then
  begin
    aX^ := LMX;
  end;

  if aY <> nil then
  begin
    aY^ := LMY;
  end;

  if aWheel <> nil then
  begin
    aWheel^ := LMW;
  end;

end;

procedure TGame.MouseSetPos(aX: Integer; aY: Integer);
var
  LMX, LMY: Integer;
  LVX, LVY: Integer;
begin
  LMX := aX;
  LMY := aY;

  LVX := Round(FWindow.TransSize.x);
  LVY := Round(FWindow.TransSize.y);

  var LDpi: Integer := GetDpiForWindow(al_get_win_window_handle(FWindow.Handle));
  if (LDpi <> DISPLAY_DEFAULT_DPI) then
  begin
    LMX := Round(LMX * FWindow.TransScale) + LVX;
    LMY := Round(LMY * FWindow.TransScale) + LVY;
  end;

  al_set_mouse_xy(FWindow.Handle, LMX, LMY);
end;

procedure TGame.MouseShowCursor(aShow: Boolean);
begin
end;

function TGame.JoystickGetPos(aStick: Integer; aAxes: Integer): Single;
begin
  Result := FInput.Joystick.Pos[aStick, aAxes];
end;

function TGame.JoystickDown(aButton: Integer): Boolean;
begin
  Result := FInput.Joystick.Button[aButton];
end;

function TGame.JoystickPressed(aButton: Integer): Boolean;
begin
  Result := False;
  if not InRange(aButton, 0, MAX_BUTTONS) then Exit;

  if JoystickDown(aButton) and (not FInput.JoyButtons[aButton]) then
  begin
    FInput.JoyButtons[aButton] := True;
    Result := True;
  end
  else if (not JoystickDown(aButton)) and (FInput.JoyButtons[aButton]) then
  begin
    FInput.JoyButtons[aButton] := False;
    Result := False;
  end;
end;

function TGame.JoystickReleased(aButton: Integer): Boolean;
begin
  Result := False;
  if not InRange(aButton, 0, MAX_BUTTONS) then Exit;

  if JoystickDown(aButton) and (not FInput.JoyButtons[aButton]) then
  begin
    FInput.JoyButtons[aButton] := True;
    Result := False;
  end
  else if (not JoystickDown(aButton)) and (FInput.JoyButtons[aButton]) then
  begin
    FInput.JoyButtons[aButton] := False;
    Result := True;
  end;
end;

// Rendering
procedure TGame.DrawLine(aX1, aY1, aX2, aY2: Single; aColor: TColor; aThickness: Single);
var
  LColor: ALLEGRO_COLOR absolute aColor;
begin
  if FWindow.Handle = nil then Exit;
  al_draw_line(aX1, aY1, aX2, aY2, LColor, aThickness);
end;

procedure TGame.DrawRectangle(aX, aY, aWidth, aHeight, aThickness: Single; aColor: TColor);
var
  LColor: ALLEGRO_COLOR absolute aColor;
begin
  if FWindow.Handle = nil then Exit;
  al_draw_rectangle(aX, aY, aX + aWidth, aY + aHeight, LColor, aThickness);
end;

procedure TGame.DrawFilledRectangle(aX, aY, aWidth, aHeight: Single; aColor: TColor);
var
  LColor: ALLEGRO_COLOR absolute aColor;
begin
  if FWindow.Handle = nil then Exit;
  al_draw_filled_rectangle(aX, aY, aX + aWidth, aY + aHeight, LColor);
end;

procedure TGame.DrawCircle(aX, aY, aRadius, aThickness: Single; aColor: TColor);
var
  LColor: ALLEGRO_COLOR absolute aColor;
begin
  if FWindow.Handle = nil then Exit;
  al_draw_circle(aX, aY, aRadius, LColor, aThickness);
end;

procedure TGame.DrawFilledCircle(aX, aY, aRadius: Single; aColor: TColor);
var
  LColor: ALLEGRO_COLOR absolute aColor;
begin
  if FWindow.Handle = nil then Exit;
  al_draw_filled_circle(aX, aY, aRadius, LColor);
end;

procedure TGame.DrawPolygon(aVertices: System.PSingle; aVertexCount: Integer; aThickness: Single; aColor: TColor);
var
  LColor: ALLEGRO_COLOR absolute aColor;
begin
  if FWindow.Handle = nil then Exit;
  al_draw_polygon(WinApi.Windows.PSingle(aVertices), aVertexCount, ALLEGRO_LINE_JOIN_ROUND, LColor, aThickness, 1.0);
end;

procedure TGame.DrawFilledPolygon(aVertices: System.PSingle; aVertexCount: Integer; aColor: TColor);
var
  LColor: ALLEGRO_COLOR absolute aColor;
begin
  if FWindow.Handle = nil then Exit;
  al_draw_filled_polygon(WinApi.Windows.PSingle(aVertices), aVertexCount, LColor);
end;

procedure TGame.DrawTriangle(aX1, aY1, aX2, aY2, aX3, aY3, aThickness: Single; aColor: TColor);
var
  LColor: ALLEGRO_COLOR absolute aColor;
begin
  if FWindow.Handle = nil then Exit;
  al_draw_triangle(aX1, aY1, aX2, aY2, aX3, aY3, LColor, aThickness);
end;

procedure TGame.DrawFilledTriangle(aX1, aY1, aX2, aY2, aX3, aY3: Single; aColor: TColor);
var
  LColor: ALLEGRO_COLOR absolute aColor;
begin
  if FWindow.Handle = nil then Exit;
  al_draw_filled_triangle(aX1, aY1, aX2, aY2, aX3, aY3, LColor);
end;

procedure TGame.SetBlender(aOperation: Integer; aSource: Integer; aDestination: Integer);
begin
  if FWindow.Handle = nil then Exit;
  al_set_blender(aOperation, aSource, aDestination);
end;

procedure TGame.GetBlender(aOperation: PInteger; aSource: PInteger; aDestination: PInteger);
begin
  if FWindow.Handle = nil then Exit;
  al_get_blender(aOperation, aSource, aDestination);
end;

procedure TGame.SetBlendColor(aColor: TColor);
var
  LColor: ALLEGRO_COLOR absolute aColor;
begin
  if FWindow.Handle = nil then Exit;
  al_set_blend_color(LColor);
end;

function TGame.GetBlendColor: TColor;
var
  LResult: ALLEGRO_COLOR absolute Result;
begin
  Result := BLANK;
  if FWindow.Handle = nil then Exit;
  LResult := al_get_blend_color;
end;

procedure TGame.SetBlendMode(aMode: TBlendMode);
begin
  if FWindow.Handle = nil then Exit;

  case aMode of
    bmPreMultipliedAlpha:
      begin
        al_set_blender(ALLEGRO_ADD, ALLEGRO_ONE, ALLEGRO_INVERSE_ALPHA);
      end;
    bmNonPreMultipliedAlpha:
      begin
        al_set_blender(ALLEGRO_ADD, ALLEGRO_ALPHA, ALLEGRO_INVERSE_ALPHA);
      end;
    bmAdditiveAlpha:
      begin
        al_set_blender(ALLEGRO_ADD, ALLEGRO_ONE, ALLEGRO_ONE);
      end;
    bmCopySrcToDest:
      begin
        al_set_blender(ALLEGRO_ADD, ALLEGRO_ONE, ALLEGRO_ZERO);
      end;
    bmMultiplySrcAndDest:
      begin
        al_set_blender(ALLEGRO_ADD, ALLEGRO_DEST_COLOR, ALLEGRO_ZERO)
      end;
  end;
end;

procedure TGame.SetBlendModeColor(aMode: TBlendModeColor; aColor: TColor);
begin
  if FWindow.Handle = nil then Exit;
  case aMode of
    bcColorNormal:
      begin
        al_set_blender(ALLEGRO_ADD, ALLEGRO_CONST_COLOR, ALLEGRO_ONE);
        al_set_blend_color(al_map_rgba_f(aColor.red, aColor.green, aColor.blue, aColor.alpha));
      end;
    bcColorAvgSrcDest:
      begin
        al_set_blender(ALLEGRO_ADD, ALLEGRO_CONST_COLOR, ALLEGRO_CONST_COLOR);
        al_set_blend_color(al_map_rgba_f(aColor.red, aColor.green, aColor.blue, aColor.alpha));
      end;
  end;
end;

procedure TGame.RestoreDefaultBlendMode;
begin
  if FWindow.Handle = nil then  Exit;
  al_set_blender(ALLEGRO_ADD, ALLEGRO_ONE, ALLEGRO_INVERSE_ALPHA);
  al_set_blend_color(al_map_rgba(255, 255, 255, 255));
end;

// Font
function  TGame.LoadFont(aSize: Cardinal): Int64;
var
  LStream: TResourceStream;
begin
  LStream := TResourceStream.Create(HInstance, 'DEFAULTFONT', RT_RCDATA);
  try
    Result := LoadFont(aSize, LStream.Memory, LStream.Size);
  finally
    FreeAndNil(LStream);
  end;
end;

function  TGame.LoadFont(aSize: Cardinal; const aFilename: string): Int64;
var
  LMarshaller: TMarshaller;
  LFont: TFont;
begin
  Result := ID_NIL;
  if aFilename.IsEmpty then Exit;
  al_set_new_bitmap_flags(ALLEGRO_MIN_LINEAR or ALLEGRO_MAG_LINEAR or ALLEGRO_MIPMAP or ALLEGRO_VIDEO_BITMAP);
  LFont.Handle := al_load_font(LMarshaller.AsUtf8(aFilename).ToPointer, -aSize, 0);
  if LFont.Handle = nil then Exit;
  LFont.Filename := aFilename;
  LFont.Size := aSize;
  Result := GenID;
  FFontList.Add(Result, LFont);
end;

function TGame.LoadFont(aSize: Cardinal; aMemory: Pointer; aLength: Int64): Int64;
var
  LMemFile: PALLEGRO_FILE;
  LFont: TFont;
begin
  Result := ID_NIL;
  LMemFile := al_open_memfile(aMemory, aLength, 'rb');
  if LMemFile = nil then Exit;
  al_set_new_bitmap_flags(ALLEGRO_MIN_LINEAR or ALLEGRO_MAG_LINEAR or ALLEGRO_MIPMAP or ALLEGRO_VIDEO_BITMAP);
  LFont.Handle := al_load_ttf_font_f(LMemFile, '', -aSize, 0);
  if LFont.Handle = nil then
  begin
    al_fclose(LMemFile);
    Exit;
  end;
  LFont.Filename := '';
  LFont.Size := aSize;
  Result := GenID;
  FFontList.Add(Result, LFont);
end;

procedure TGame.UnloadFont(var aFont: Int64);
var
  LFont: TFont;
begin
  if not FFontList.TryGetValue(aFont, LFont) then Exit;
  if LFont.Handle = nil then Exit;
  al_destroy_font(LFont.Handle);
  FFontlist.Remove(aFont);
  aFont := ID_NIL;
end;

procedure TGame.UnloadAllFonts;
var
  LFont: TFont;
begin
  for LFont in FFontList.Values do
  begin
    if LFont.Handle <> nil then
    begin
      al_destroy_font(LFont.Handle);
    end;
  end;
  FFontList.Clear;
end;

procedure TGame.PrintText(aFont: Int64; aX: Single; aY: Single; aColor: TColor; aAlign: THAlign; const aMsg: string; const aArgs: array of const);
var
  LUstr: PALLEGRO_USTR;
  LText: string;
  LColor: ALLEGRO_COLOR absolute aColor;
  LFont: TFont;
begin
  if not FFontList.TryGetValue(aFont, LFont) then Exit;
  if LFont.Handle = nil then Exit;
  LText := Format(aMsg, aArgs);
  if LText.IsEmpty then  Exit;
  LUstr := al_ustr_new_from_utf16(PUInt16(PChar(LText)));
  al_draw_ustr(LFont.Handle, LColor, aX, aY, Ord(aAlign) or ALLEGRO_ALIGN_INTEGER, LUstr);
  al_ustr_free(LUstr);
end;

procedure TGame.PrintText(aFont: Int64; aX: Single; var aY: Single; aLineSpace: Single; aColor: TColor; aAlign: THAlign; const aMsg: string; const aArgs: array of const);
begin
  PrintText(aFont, aX, aY, aColor, aAlign, aMsg, aArgs);
  aY := aY + GetLineHeight(aFont) + aLineSpace;
end;

procedure TGame.PrintText(aFont: Int64; aX: Single; aY: Single; aColor: TColor; aAngle: Single; const aMsg: string; const aArgs: array of const);
var
  LUstr: PALLEGRO_USTR;
  LText: string;
  LFX, LFY: Single;
  LTR: ALLEGRO_TRANSFORM;
  LColor: ALLEGRO_COLOR absolute aColor;
  LTrans: ALLEGRO_TRANSFORM;
  LFont: TFont;
begin
  if not FFontList.TryGetValue(aFont, LFont) then Exit;
  if LFont.Handle = nil then Exit;
  LText := Format(aMsg, aArgs);
  if LText.IsEmpty then Exit;
  LFX := GetTextWidth(aFont, LText, []) / 2;
  LFY := GetLineHeight(aFont) / 2;
  al_identity_transform(@LTR);
  al_translate_transform(@LTR, -LFX, -LFY);
  al_rotate_transform(@LTR, aAngle * DEG2RAD);
  AngleRotatePos(aAngle, LFX, LFY);
  al_translate_transform(@LTR, aX + LFX, aY + LFY);
  LTrans := FWindow.Trans;
  al_compose_transform(@LTR, @LTrans);
  al_use_transform(@LTR);
  LUstr := al_ustr_new_from_utf16(PUInt16(PChar(LText)));
  al_draw_ustr(LFont.Handle, LColor, 0, 0, ALLEGRO_ALIGN_LEFT or ALLEGRO_ALIGN_INTEGER, LUstr);
  al_ustr_free(LUstr);
  LTrans := FWindow.Trans;
  al_use_transform(@LTrans);
end;

function  TGame.GetTextWidth(aFont: Int64; const aMsg: string; const aArgs: array of const): Single;
var
  LUstr: PALLEGRO_USTR;
  LText: string;
  LFont: TFont;
begin
  Result := 0;
  if not FFontList.TryGetValue(aFont, LFont) then Exit;
  if LFont.Handle = nil then Exit;
  LText := Format(aMsg, aArgs);
  if LText.IsEmpty then  Exit;
  LUstr := al_ustr_new_from_utf16(PUInt16(PChar(LText)));
  Result := al_get_ustr_width(LFont.Handle, LUstr);
  al_ustr_free(LUstr);
end;

function  TGame.GetLineHeight(aFont: Int64): Single;
var
  LFont: TFont;
begin
  Result := 0;
  if not FFontList.TryGetValue(aFont, LFont) then Exit;
  if LFont.Handle = nil then Exit;
  Result := al_get_font_line_height(LFont.Handle);
end;

// Bitmap
function  TGame.AllocBitmap(aWidth: Integer; aHeight: Integer): Int64;
var
  LBitmap: TBitmap;
begin
  Result := ID_NIL;
  al_set_new_bitmap_flags(ALLEGRO_MIN_LINEAR or ALLEGRO_MAG_LINEAR or ALLEGRO_MIPMAP or ALLEGRO_VIDEO_BITMAP);
  LBitmap.Handle := al_create_bitmap(aWidth, aHeight);
  if LBitmap.Handle = nil then Exit;
  LBitmap.Width := al_get_bitmap_width(LBitmap.Handle);
  LBitmap.Height := al_get_bitmap_height(LBitmap.Handle);
  LBitmap.Filename := '';
  Result := GenID;
  FBitmapList.Add(Result, LBitmap);
end;

function  TGame.LoadBitmap(const aFilename: string; aColorKey: PColor): Int64;
var
  LMarsheller: TMarshaller;
  LColorKey: PALLEGRO_COLOR absolute aColorKey;
  LBitmap: TBitmap;
begin
  Result := ID_NIL;
  if aFilename.IsEmpty then Exit;
  if not al_filename_exists(LMarsheller.AsUtf8(aFilename).ToPointer) then Exit;
  al_set_new_bitmap_flags(ALLEGRO_MIN_LINEAR or ALLEGRO_MAG_LINEAR or ALLEGRO_VIDEO_BITMAP);
  LBitmap.Handle := al_load_bitmap(LMarsheller.AsAnsi(aFilename).ToPointer);
  if LBitmap.Handle = nil then Exit;
  LBitmap.Width := al_get_bitmap_width(LBitmap.Handle);
  LBitmap.Height := al_get_bitmap_height(LBitmap.Handle);
  // apply colorkey
  if aColorKey <> nil then
    al_convert_mask_to_alpha(LBitmap.Handle, LColorKey^);
  LBitmap.Filename := aFilename;
  Result := GenID;
  FBitmapList.Add(Result, LBitmap);
end;

procedure TGame.UnloadBitmap(var aBitmap: Int64);
var
  LBitmap: TBitmap;
begin
  if not FBitmapList.TryGetValue(aBitmap, LBitmap) then Exit;
  if LBitmap.Handle = nil then Exit;
  al_destroy_bitmap(LBitmap.Handle);
  FBitmapList.Remove(aBitmap);
  aBitmap := ID_NIL;
end;

procedure TGame.UnloadAllBitmaps;
var
  LBitmap: TBitmap;
begin
  for LBitmap in FBitmapList.Values do
  begin
    if LBitmap.Handle <> nil then
    begin
       al_destroy_bitmap(LBitmap.Handle);
    end;
  end;
  FBitmapList.Clear;
end;

procedure TGame.GetBitmapSize(aBitmap: Int64; var aSize: TVector);
var
  LBitmap: TBitmap;
begin
  if not FBitmapList.TryGetValue(aBitmap, LBitmap) then Exit;
  if LBitmap.Handle = nil then Exit;
  aSize.X := LBitmap.Width;
  aSize.Y := LBitmap.Height;
end;

procedure TGame.GetBitmapSize(aBitmap: Int64; aWidth: PSingle; aHeight: PSingle);
var
  LBitmap: TBitmap;
begin
  if not FBitmapList.TryGetValue(aBitmap, LBitmap) then Exit;
  if LBitmap.Handle = nil then Exit;
  if aWidth <> nil then aWidth^ := LBitmap.Width;
  if aHeight <> nil then aHeight^ := LBitmap.Height;
end;

procedure TGame.LockBitmap(aBitmap: Int64; aRegion: PRectangle; aData: PBitmapData=nil);
var
  LLock: PALLEGRO_LOCKED_REGION;
  LBitmap: TBitmap;
begin
  if not FBitmapList.TryGetValue(aBitmap, LBitmap) then Exit;
  if LBitmap.Handle = nil then Exit;

  LLock := nil;

  if not LBitmap.Locked then
  begin
    if aRegion <> nil then
      begin
        LLock := al_lock_bitmap_region(LBitmap.Handle, Round(aRegion.X), Round(aRegion.Y), Round(aRegion.Width), Round(aRegion.Height), ALLEGRO_PIXEL_FORMAT_ANY, ALLEGRO_LOCK_READWRITE);
        LBitmap.LockedRegion.X := aRegion.X;
        LBitmap.LockedRegion.Y := aRegion.Y;
        LBitmap.LockedRegion.Width := aRegion.Width;
        LBitmap.LockedRegion.Height := aRegion.Height;
      end
    else
      begin
        LLock := al_lock_bitmap(LBitmap.Handle, ALLEGRO_PIXEL_FORMAT_ANY, ALLEGRO_LOCK_READWRITE);
        LBitmap.LockedRegion.X := 0;
        LBitmap.LockedRegion.Y := 0;
        LBitmap.LockedRegion.Width := LBitmap.Width;
        LBitmap.LockedRegion.Height := LBitmap.Height;
      end;
    LBitmap.Locked := True;
    //Display.SetTarget(FHandle);
  end;

  if LLock <> nil then
  begin
    if aData <> nil then
    begin
      aData.Memory := LLock.data;
      aData.Format := LLock.format;
      aData.Pitch := LLock.pitch;
      aData.PixelSize := LLock.pixel_size;
    end;
  end;

end;

procedure TGame.UnlockBitmap(aBitmap: Int64);
var
  LBitmap: TBitmap;
begin
  if not FBitmapList.TryGetValue(aBitmap, LBitmap) then Exit;
  if LBitmap.Handle = nil then Exit;
  if LBitmap.Locked then
  begin
    al_unlock_bitmap(LBitmap.Handle);
    LBitmap.Locked := False;
    LBitmap.LockedRegion.X := 0;
    LBitmap.LockedRegion.Y := 0;
    LBitmap.LockedRegion.Width := 0;
    LBitmap.LockedRegion.Height := 0;
  end;
end;

function  TGame.GetBitmapPixel(aBitmap: Int64; aX: Integer; aY: Integer): TColor;
var
  LX,LY: Integer;
  LResult: ALLEGRO_COLOR absolute Result;
  LBitmap: TBitmap;
begin
  if not FBitmapList.TryGetValue(aBitmap, LBitmap) then Exit;
  if LBitmap.Handle = nil then Exit;

  LX := Round(aX + LBitmap.LockedRegion.X);
  LY := Round(aY + LBitmap.lockedRegion.Y);
  LResult := al_get_pixel(LBitmap.Handle, LX, LY);
end;

procedure TGame.SetBitmapPixel(aBitmap: Int64; aX: Integer; aY: Integer; aColor: TColor);
var
  LX,LY: Integer;
  LColor: ALLEGRO_COLOR absolute aColor;
  LBitmap: TBitmap;
begin
  if not FBitmapList.TryGetValue(aBitmap, LBitmap) then Exit;
  if LBitmap.Handle = nil then Exit;

  LX := Round(aX + LBitmap.LockedRegion.X);
  LY := Round(aY + LBitmap.lockedRegion.Y);
  al_put_pixel(LX, LY, LColor);
end;

procedure TGame.DrawBitmap(aBitmap: Int64; aX, aY: Single; aRegion: PRectangle; aCenter: PVector;  aScale: PVector; aAngle: Single; aColor: TColor; aHFlip: Boolean; aVFlip: Boolean);
var
  LA: Single;
  LRG: TRectangle;
  LCP: TVector;
  LSC: TVector;
  LC: ALLEGRO_COLOR absolute aColor;
  LFlags: Integer;
  LBitmap: TBitmap;
begin
  if not FBitmapList.TryGetValue(aBitmap, LBitmap) then Exit;
  if LBitmap.Handle = nil then Exit;

  // angle
  LA := aAngle * DEG2RAD;

  // region
  if Assigned(aRegion) then
    begin
      LRG.X := aRegion.X;
      LRG.Y := aRegion.Y;
      LRG.Width := aRegion.Width;
      LRG.Height := aRegion.Height;
    end
  else
    begin
      LRG.X := 0;
      LRG.Y := 0;
      LRG.Width := LBitmap.Width;
      LRG.Height := LBitmap.Height;
    end;

  if LRG.X < 0 then
    LRG.X := 0;
  if LRG.X > LBitmap.Width - 1 then
    LRG.X := LBitmap.Width - 1;

  if LRG.Y < 0 then
    LRG.Y := 0;
  if LRG.Y > LBitmap.Height - 1 then
    LRG.Y := LBitmap.Height - 1;

  if LRG.Width < 0 then
    LRG.Width := 0;
  if LRG.Width > LBitmap.Width then
    LRG.Width := LRG.Width;

  if LRG.Height < 0 then
    LRG.Height := 0;
  if LRG.Height > LBitmap.Height then
    LRG.Height := LRG.Height;

  // center
  if Assigned(aCenter) then
    begin
      LCP.X := (LRG.Width * aCenter.X);
      LCP.Y := (LRG.Height * aCenter.Y);
    end
  else
    begin
      LCP.X := 0;
      LCP.Y := 0;
    end;

  // scale
  if Assigned(aScale) then
    begin
      LSC.X := aScale.X;
      LSC.Y := aScale.Y;
    end
  else
    begin
      LSC.X := 1;
      LSC.Y := 1;
    end;

  // flags
  LFlags := 0;
  if aHFlip then LFlags := LFlags or ALLEGRO_FLIP_HORIZONTAL;
  if aVFlip then LFlags := LFlags or ALLEGRO_FLIP_VERTICAL;

  // render
  al_draw_tinted_scaled_rotated_bitmap_region(LBitmap.Handle, LRG.X, LRG.Y, LRG.Width, LRG.Height, LC, LCP.X, LCP.Y, aX, aY, LSC.X, LSC.Y, LA, LFlags);
end;

procedure TGame.DrawBitmap(aBitmap: Int64; aX, aY, aScale, aAngle: Single; aColor: TColor; aHAlign: THAlign; aVAlign: TVAlign; aHFlip: Boolean=False; aVFlip: Boolean=False);
var
  LCenter: TVector;
  LScale: TVector;
  LBitmap: TBitmap;
begin
  if not FBitmapList.TryGetValue(aBitmap, LBitmap) then Exit;
  if LBitmap.Handle = nil then Exit;

  LCenter.X := 0;
  LCenter.Y := 0;

  LScale.X := aScale;
  LScale.Y := aScale;

  case aHAlign of
    haLeft  : LCenter.X := 0;
    haCenter: LCenter.X := 0.5;
    haRight : LCenter.X := 1;
  end;

  case aVAlign of
    vaTop   : LCenter.Y := 0;
    vaCenter: LCenter.Y := 0.5;
    vaBottom: LCenter.Y := 1;
  end;

  DrawBitmap(aBitmap, aX, aY, nil, @LCenter, @LScale, aAngle, aColor, aHFlip, aVFlip);
end;

procedure TGame.DrawTiledBitmap(aBitmap: Int64; aDeltaX: Single; aDeltaY: Single);
var
  LW,LH    : Integer;
  LOX,LOY  : Integer;
  LPX,LPY  : Single;
  LFX,LFY  : Single;
  LTX,LTY  : Integer;
  LVPW,LVPH: Integer;
  LVR,LVB  : Integer;
  LIX,LIY  : Integer;
var
  LBitmap: TBitmap;
begin
  if not FBitmapList.TryGetValue(aBitmap, LBitmap) then Exit;
  if LBitmap.Handle = nil then Exit;

  GetWindowViewportSize(nil, nil, @LVPW, @LVPH);

  LW := Round(LBitmap.Width);
  LH := Round(LBitmap.Height);

  LOX := -LW+1;
  LOY := -LH+1;

  LPX := aDeltaX;
  LPY := aDeltaY;

  LFX := LPX-floor(LPX);
  LFY := LPY-floor(LPY);

  LTX := floor(LPX)-LOX;
  LTY := floor(LPY)-LOY;

  if (LTX>=0) then LTX := LTX mod LW + LOX else LTX := LW - -LTX mod LW + LOX;
  if (LTY>=0) then LTY := LTY mod LH + LOY else LTY := LH - -LTY mod LH + LOY;

  LVR := LVPW;
  LVB := LVPH;
  LIY := LTY;

  while LIY<LVB do
  begin
    LIX := LTX;
    while LIX<LVR do
    begin
      al_draw_bitmap(LBitmap.Handle, LIX+LFX, LIY+LFY, 0);
      LIX := LIX+LW;
    end;
   LIY := LIY+LH;
  end;
end;

// Hud
procedure TGame.HudPos(aX: Integer; aY: Integer);
begin
  FHud.Pos.Assign(aX, aY);
end;

procedure TGame.HudLineSpace(aLineSpace: Integer);
begin
  FHud.Pos.Z := aLineSpace;
end;

procedure TGame.HudTextItemPadWidth(aWidth: Integer);
begin
  FHud.TextItemPadWidth := aWidth;
end;

  procedure TGame.HudText(aFont: Int64; aColor: TColor; aAlign: THAlign; const aMsg: string; const aArgs: array of const);
begin
  PrintText(aFont, FHud.Pos.X, FHud.Pos.Y, FHud.Pos.Z, aColor, aAlign, aMsg, aArgs);
end;

function  TGame.HudTextItem(const aKey: string; const aValue: string; const aSeperator: string='-'): string;
begin
  Result := Format('%s %s %s', [aKey.PadRight(FHud.TextItemPadWidth), aSeperator, aValue]);
end;

// Archive
function TGame.Mount(const aNewDir: string; const aMountPoint: string; aAppendToPath: Boolean): Boolean;
var
  LAppendToPath: Integer;
begin
  if aAppendToPath then
    LAppendToPath := 1
  else
    LAppendToPath := 0;
  Result := Boolean(PHYSFS_mount(PAnsiChar(AnsiString(aNewDir)), PAnsiChar(AnsiString(aMountPoint)), LAppendToPath) <> 0);
end;

function TGame.Unmount(const aOldDir: string): Boolean;
begin
  Result := Boolean(PHYSFS_unmount(PAnsiChar(AnsiString(aOldDir))) <> 0);
end;

function fi_fopen(const path: PUTF8Char; const mode: PUTF8Char): Pointer; cdecl;
var
  LMarshaller: TMarshaller;
  LPath: string;
begin
  if Game.FZipArc.Password.IsEmpty then
    LPath := string(path)
  else
    LPath := string(path) + '$' +Game.FZipArc.Password;

  Result := Game.FZipArc.PhysFS[0].fi_fopen(LMarshaller.AsUtf8(LPath).ToPointer, mode);
end;

function TGame.OpenZipArc(const aPassword: string; const aFilename: string): Boolean;
begin
  Result := False;
  if aFilename.IsEmpty then Exit;
  if not TFile.Exists(aFilename) then Exit;
  FZipArc.Password := aPassword;
  FZipArc.Filename := aFilename;
  Result := Mount(aFilename, '', True);
end;

function TGame.CloseZipArc: Boolean;
begin
  Result := False;
  if FZipArc.Filename.IsEmpty  then Exit;
  Result := Unmount(FZipArc.Filename);
  if Result then
  begin
    FZipArc.Password := '';
    FZipArc.Filename := '';
  end;
end;

// Audio
procedure TGame.PauseAudio(aPause: Boolean);
begin
  if not al_is_audio_installed then Exit;
  al_set_mixer_playing(FAudio.Mixer, not aPause);
end;

procedure TGame.ClearAudio;
begin
  UnloadAllSamples;
  UnloadMusic;
end;

procedure TGame.LoadMusic(const aFilename: string);
var
  LMarshaller: TMarshaller;
begin
  if not al_is_audio_installed then Exit;
  if aFilename.IsEmpty then Exit;
  if not al_filename_exists(LMarshaller.AsUtf8(aFilename).ToPointer) then Exit;
  UnloadMusic;
  FMusic.Handle := al_load_audio_stream(LMarshaller.AsUtf8(aFilename).ToPointer, 4, 2048);
  if FMusic.Handle = nil then Exit;
  //al_register_event_source(FQueue, al_get_audio_stream_event_source(FMusic.Handle));
  al_set_audio_stream_playmode(FMusic.Handle, ALLEGRO_PLAYMODE_ONCE);
  al_attach_audio_stream_to_mixer(FMusic.Handle, FAudio.Mixer);
  //al_attach_audio_stream_to_mixer(FMusic.Handle, al_get_default_mixer());
  al_set_audio_stream_playing(FMusic.Handle, False);
end;

procedure TGame.UnloadMusic;
begin
  if not al_is_audio_installed then Exit;
  if FMusic.Handle <> nil then
  begin
    al_set_audio_stream_playing(FMusic.Handle, False);
    al_drain_audio_stream(FMusic.Handle);
    al_detach_audio_stream(FMusic.Handle);
    al_destroy_audio_stream(FMusic.Handle);
    FMusic.Handle := nil;
  end;
end;

procedure TGame.PlayMusic(aVolume: Single; aLoop: Boolean);
begin
  if not al_is_audio_installed then Exit;
  if FMusic.Handle = nil then Exit;
  StopMusic;
  SetMusicLooping(aLoop);
  SetMusicVolume(aVolume);
  al_rewind_audio_stream(FMusic.Handle);
  SetMusicPlaying(True);
end;

procedure TGame.StopMusic;
begin
  if not al_is_audio_installed then Exit;
  if FMusic.Handle = nil then Exit;
  al_set_audio_stream_playing(FMusic.Handle, False);
  al_rewind_audio_stream(FMusic.Handle);
end;

function  TGame.GetMusicLooping: Boolean;
var
  LMode: ALLEGRO_PLAYMODE;
begin
  Result := False;
  if not al_is_audio_installed then Exit;
  if FMusic.Handle = nil then Exit;

  LMode := al_get_audio_stream_playmode(FMusic.Handle);
  if (LMode = ALLEGRO_PLAYMODE_LOOP) or
     (LMode = _ALLEGRO_PLAYMODE_STREAM_ONEDIR) then
  begin
    Result := True;
  end;
end;

procedure TGame.SetMusicLooping(aLoop: Boolean);
var
  LMode: ALLEGRO_PLAYMODE;
begin
  if not al_is_audio_installed then Exit;
  if aLoop then
    LMode := ALLEGRO_PLAYMODE_LOOP
  else
    LMode := ALLEGRO_PLAYMODE_ONCE;
  al_set_audio_stream_playmode(FMusic.Handle, LMode);
end;

function  TGame.GetMusicPlaying: Boolean;
begin
  Result := False;
  if not al_is_audio_installed then Exit;
  Result := al_get_audio_stream_playing(FMusic.Handle);
end;

procedure TGame.SetMusicPlaying(aPlay: Boolean);
begin
  if not al_is_audio_installed then Exit;
  if FMusic.Handle = nil then Exit;
  al_set_audio_stream_playing(FMusic.Handle, aPlay);
end;

procedure TGame.SetMusicVolume(aVolume: Single);
begin
  if not al_is_audio_installed then Exit;
  if FMusic.Handle = nil then Exit;
  al_set_audio_stream_gain(FMusic.Handle, aVolume);
end;

function  TGame.GetMusicVolume: Single;
begin
  Result := 0;
  if not al_is_audio_installed then Exit;
  if FMusic.Handle = nil then Exit;
  Result := al_get_audio_stream_gain(FMusic.Handle);
end;

procedure TGame.SeekMusic(aTime: Single);
begin
  if FMusic.Handle = nil then Exit;
  if not al_is_audio_installed then Exit;
  al_seek_audio_stream_secs(FMusic.Handle, aTime);
end;

procedure TGame.RewindMusic(aTime: Single);
begin
  if FMusic.Handle = nil then Exit;
  if not al_is_audio_installed then Exit;
  al_rewind_audio_stream(FMusic.Handle);
end;

function  TGame.ReserveSamples(aCount: Integer): Boolean;
begin
  Result := al_reserve_samples(aCount);
end;

function  TGame.LoadSample(const aFilename: string): Int64;
var
  LMarshaller: TMarshaller;
  LSample: TSample;
begin
  Result := ID_NIL;
  if not al_filename_exists(LMarshaller.AsUtf8(aFilename).ToPointer) then Exit;
  LSample.Handle := al_load_sample(LMarshaller.AsUtf8(aFilename).ToPointer);
  if LSample.Handle = nil then Exit;
  Result := GenID;
  FSampleList.Add(Result, LSample);
end;

procedure TGame.UnloadSample(var aSample: Int64);
var
  LSample: TSample;
begin
  if not FSampleList.TryGetValue(aSample, LSample) then Exit;
  if LSample.Handle = nil then Exit;
  al_destroy_sample(LSample.Handle);
  FSampleList.Remove(aSample);
  aSample := ID_NIL;
end;

procedure TGame.UnloadAllSamples;
var
  LItem: Int64;
  LSample: Int64;
begin
  for LItem in FSampleList.Keys do
  begin
    LSample := LItem;
    UnloadSample(LSample);
  end;
  FSampleList.Clear;
end;

procedure TGame.PlaySample(aSample: Int64; aVolume: Single; aPan: Single; aSpeed: Single; aLoop: Boolean; aId: PSampleID);
var
  LSample: TSample;
  LMode: ALLEGRO_PLAYMODE;
  LID: ALLEGRO_SAMPLE_ID;
begin
  if not FSampleList.TryGetValue(aSample, LSample) then Exit;
  if LSample.Handle = nil then Exit;

  if aId <> nil then
  begin
    aId.Index := -1;
    aId.Id := -1;
  end;

  if aLoop then
    LMode := ALLEGRO_PLAYMODE_LOOP
  else
    LMode := ALLEGRO_PLAYMODE_ONCE;

  if al_play_sample(LSample.Handle, aVolume, aPan, aSpeed, LMode, @LID) then
  begin
    if aId <> nil then
    begin
      aId.Index := LID._index;
      aId.Id := LID._id;
    end;
  end;
end;

procedure TGame.StopSample(aID: TSampleID);
var
  LID: ALLEGRO_SAMPLE_ID;
begin
  if IsSamplePlaying(aID) then
  begin
    LID._index := aID.Index;
    LID._id := aID.Id;
    al_stop_sample(@LID);
  end;
end;

procedure TGame.StopAllSamples;
begin
  al_stop_samples;
end;

function  TGame.IsSamplePlaying(aID: TSampleID): Boolean;
var
  LInstance: PALLEGRO_SAMPLE_INSTANCE;
  LID: ALLEGRO_SAMPLE_ID;
begin
  Result := False;
  LID._index := aID.Index;
  LID._id := aID.Id;
  LInstance := al_lock_sample_id(@LID);
  if LInstance <> nil then
  begin
    Result := al_get_sample_instance_playing(LInstance);
    al_unlock_sample_id(@LID);
  end;
end;

// Video
procedure TGame.LoadVideo(const aFilename: string);
var
  LMarsheller: TMarshaller;
  LFilename: string;
begin
  LFilename := aFilename;
  if LFilename.IsEmpty then  Exit;

  if not al_filename_exists(LMarsheller.AsUtf8(LFilename).ToPointer) then
  begin
    Log('Video file was not found: %s', [LFilename]);
    Exit;
  end;

  UnloadVideo;

  if al_is_audio_installed then
  begin
    if FVideo.Voice = nil then
    begin
      FVideo.Voice := al_create_voice(44100, ALLEGRO_AUDIO_DEPTH_INT16, ALLEGRO_CHANNEL_CONF_2);
      FVideo.Mixer := al_create_mixer(44100, ALLEGRO_AUDIO_DEPTH_FLOAT32, ALLEGRO_CHANNEL_CONF_2);
      al_attach_mixer_to_voice(FVideo.Mixer, FVideo.Voice);
    end;
  end;

  FVideo.Handle := al_open_video(LMarsheller.AsAnsi(LFilename).ToPointer);
  if FVideo.Handle <> nil then
  begin
    al_register_event_source(FQueue, al_get_video_event_source(FVideo.Handle));
    al_set_video_playing(FVideo.Handle, False);
    FVideo.Filename := aFilename;
    OnLoadVideo(FVideo.Filename);
  end;
end;

procedure TGame.UnloadVideo;
begin
  if FVideo.Handle <> nil then
  begin
    OnUnloadVideo(FVideo.Filename);
    al_set_video_playing(FVideo.Handle, False);
    al_unregister_event_source(FQueue, al_get_video_event_source(FVideo.Handle));
    al_close_video(FVideo.Handle);

    if al_is_audio_installed then
    begin
      if FVideo.Voice = nil then
      begin
        FVideo.Voice := al_create_voice(44100, ALLEGRO_AUDIO_DEPTH_INT16, ALLEGRO_CHANNEL_CONF_2);
        FVideo.Mixer := al_create_mixer(44100, ALLEGRO_AUDIO_DEPTH_FLOAT32, ALLEGRO_CHANNEL_CONF_2);
        al_attach_mixer_to_voice(FVideo.Mixer, FVideo.Voice);
      end;
    end;

    FVideo.Handle := nil;
    FVideo.Filename := '';
    FVideo.Loop := False;
    FVideo.Playing := False;
    FVideo.Paused := False;
  end;
end;

function  TGame.IsVideoPaused: Boolean;
begin
  Result := FVideo.Paused;
end;

procedure TGame.PauseVideo(aPause: Boolean);
begin
  // if not FPlaying then Exit;
  if FVideo.Handle = nil then Exit;

  // if trying to pause and video is not playing, just exit
  if (aPause = True) then
  begin
    if not al_is_video_playing(FVideo.Handle) then
    Exit;
  end;

  // if trying to unpause without first being paused, just exit
  if (aPause = False) then
  begin
    if FVideo.Paused = False then
      Exit;
  end;

  al_set_video_playing(FVideo.Handle, not aPause);
  FVideo.Paused := aPause;
end;

function  TGame.IsVideoLooping:  Boolean;
begin
  Result := FVideo.Loop;
end;

procedure TGame.SetVideoLooping(aLoop: Boolean);
begin
  FVideo.Loop := aLoop;
end;

function  TGame.IsVideoPlaying: Boolean;
begin
  if FVideo.Handle = nil then
    Result := False
  else
    Result := al_is_video_playing(FVideo.Handle);
end;

procedure TGame.SetVideoPlaying(aPlay: Boolean);
begin
  if FVideo.Handle = nil then Exit;
  if FVideo.Paused then Exit;
  al_set_video_playing(FVideo.Handle, aPlay);
  FVideo.Playing := aPlay;
  FVideo.Paused := False;
end;

function  TGame.GetVideoFilename: string;
begin
  Result := FVideo.Filename;
end;

procedure TGame.PlayVideo(const aFilename: string; aLoop: Boolean; aGain: Single);
begin
  LoadVideo(aFilename);
  PlayVideo(aLoop, aGain);
end;

procedure TGame.PlayVideo(aLoop: Boolean; aGain: Single);
begin
  if FVideo.Handle = nil then Exit;
  al_start_video(FVideo.Handle, FVideo.Mixer);
  al_set_mixer_gain(FVideo.Mixer, aGain);
  al_set_video_playing(FVideo.Handle, True);
  FVideo.Loop := aLoop;
  FVideo.Playing := True;
  FVideo.Paused := False;
end;

procedure TGame.DrawVideo(aX: Single; aY: Single);
var
  LFrame: PALLEGRO_BITMAP;
  LSize: TVector;
  LScaled: TVector;
  LWidth: Single;
  LHeight: Single;
  LViewportSize: TRectangle;
begin
  if FVideo.Handle = nil then Exit;
  if (not IsVideoPlaying) and (not FVideo.Paused) then Exit;

  LFrame := al_get_video_frame(FVideo.Handle);
  if LFrame <> nil then
  begin
    GetWindowViewportSize(LViewportSize);
    LSize.X := al_get_bitmap_width(LFrame);
    LSize.Y := al_get_bitmap_height(LFrame);
    LScaled.X := al_get_video_scaled_width(FVideo.Handle);
    LScaled.Y := al_get_video_scaled_height(FVideo.Handle);

    if LSize.X > LViewportSize.Width then
      LScaled.X := LViewportSize.Width;

    if LSize.Y > LViewportSize.Height then
      LScaled.Y := LViewportSize.Height;

    al_draw_scaled_bitmap(LFrame, 0, 0,
      LSize.X,
      LSize.Y,
      aX, aY,
      LScaled.X,
      LScaled.Y,
      0);
  end;
end;

procedure TGame.GetVideoSize(aWidth: PSingle; aHeight: PSingle);
begin
  if FVideo.Handle = nil then
  begin
    if aWidth <> nil then
      aWidth^ := 0;
    if aHeight <> nil then
      aHeight^ := 0;
    Exit;
  end;
  if aWidth <> nil then
    aWidth^ := al_get_video_scaled_width(FVideo.Handle);
  if aHeight <> nil then
    aHeight^ := al_get_video_scaled_height(FVideo.Handle);
end;

procedure TGame.SeekVideo(aPos: Single);
begin
  if FVideo.Handle = nil then Exit;
  al_seek_video(FVideo.Handle, aPos);
end;

procedure TGame.RewindVideo;
begin
  if FVideo.Handle = nil then Exit;
  al_seek_video(FVideo.Handle, 0);
end;

procedure TGame.VideoFinishedEvent(aHandle: PALLEGRO_VIDEO);
begin
  if FVideo.Handle <> aHandle then Exit;
  RewindVideo;
  if FVideo.Loop then
    begin
      //Rewind;
      if not FVideo.Paused then
        SetVideoPlaying(True);
    end
  else
    begin
      OnVideoFinished(FVideo.Filename);
    end;
end;

// Game
procedure TGame.SetTerminated(aTerminated: Boolean);
begin
  FTerminated := aTerminated;
end;

function  TGame.GetTerminated: Boolean;
begin
  Result := FTerminated;
end;

procedure TGame.OnGetSettings(var aSettings: TSettings);
begin
  FSettings.WindowWidth := 960;
  FSettings.WindowHeight := 540;
  FSettings.WindowTitle := 'TGame';
  FSettings.WindowFullscreen := False;
  FSettings.WindowClearColor := DARKSLATEBROWN;
  FSettings.ArchivePassword := '';
  FSettings.ArchiveFilename := '';
  FSettings.DefaultFontSize := 16;
end;

procedure TGame.OnLoadConfig;
begin
end;

procedure TGame.OnSaveConfig;
begin
end;

procedure TGame.OnStartup;
begin
  if not FSettings.ArchiveFilename.IsEmpty then
    OpenZipArc(FSettings.ArchivePassword, FSettings.ArchiveFilename);

  OpenWindow(FSettings.WindowWidth, FSettings.WindowHeight,
    FSettings.WindowTitle, FSettings.WindowFullscreen);

  if FSettings.DefaultFontSize > 0 then
    FDefaultFont := LoadFont(FSettings.DefaultFontSize);
end;

procedure TGame.OnShutdown;
begin
  UnloadFont(FDefaultFont);
  CloseWindow;
  CloseZipArc;
end;

procedure TGame.OnUpdateFrame(aDeltaTime: Double);
begin
  MouseGetInfo(FMousePos);

  if KeyboardPressed(KEY_ESCAPE) then
    SetTerminated(True);

  if KeyboardPressed(KEY_F10) then
    ToggleFullscreenWindow;
end;

procedure TGame.OnClearFrame;
begin
  ClearWindow(FSettings.WindowClearColor);
end;

procedure TGame.OnRenderFrame;
begin
end;

procedure TGame.OnRenderHUD;
begin
  HudPos(3, 3);
  HudText(FDefaultFont, WHITE, haLeft, 'fps %d', [GetFrameRate]);
  HudText(FDefaultFont, GREEN, haLeft, HudTextItem('ESC', 'Quit'), []);
  HudText(FDefaultFont, GREEN, haLeft, HudTextItem('F10', 'Toggle fullscreen'), []);
end;

procedure TGame.OnShowFrame;
begin
  ShowWindow;
end;

procedure TGame.OnLoadVideo(const aFilename: string);
begin
end;

procedure TGame.OnUnloadVideo(const aFilename: string);
begin
end;

procedure TGame.OnVideoFinished(const aFilename: string);
begin
end;

procedure TGame.Run;
begin
  FTerminated := True;
  FWindow.Ready := False;

  try
    OnGetSettings(FSettings);
    OnLoadConfig;
    OnStartup;
    ClearInput;
    if IsWindowOpen then
    begin
      ResetTiming;
      FTerminated := False;
      FWindow.Ready := True;
    end;

    while not FTerminated do
    begin
      // input
      FInput.KeyCode := 0;
      al_get_keyboard_state(@FInput.KeyboardState);
      al_get_mouse_state(@FInput.MouseState);

    repeat

      if al_get_next_event(FQueue, @FEvent) then
      begin

        case FEvent._type of
          ALLEGRO_EVENT_DISPLAY_CLOSE:
            begin
              FTerminated := True;
            end;

          ALLEGRO_EVENT_DISPLAY_RESIZE:
            begin
            end;

          ALLEGRO_EVENT_DISPLAY_DISCONNECTED,
          ALLEGRO_EVENT_DISPLAY_HALT_DRAWING,
          ALLEGRO_EVENT_DISPLAY_LOST,
          ALLEGRO_EVENT_DISPLAY_SWITCH_OUT:
            begin
              // clear input
              if FEvent._type = ALLEGRO_EVENT_DISPLAY_SWITCH_OUT then
                ClearInput;

              // pause audio
              PauseAudio(True);

              // pause Video
              PauseVideo(True);

              // display not ready
              FWindow.Ready := False;
            end;

          ALLEGRO_EVENT_DISPLAY_CONNECTED,
          ALLEGRO_EVENT_DISPLAY_RESUME_DRAWING,
          ALLEGRO_EVENT_DISPLAY_FOUND,
          ALLEGRO_EVENT_DISPLAY_SWITCH_IN:
            begin
              // reset timing
              ResetTiming;

              // unpause audio
              PauseAudio(False);

              // unpause video
              PauseVideo(False);

              // display ready
              FWindow.Ready := True;
            end;

          ALLEGRO_EVENT_KEY_CHAR:
            begin
              FInput.KeyCode := FEvent.keyboard.unichar;
            end;

          ALLEGRO_EVENT_JOYSTICK_AXIS:
            begin
              if (FEvent.Joystick.stick < MAX_STICKS) and
                (FEvent.Joystick.axis < MAX_AXES) then
              begin
                FInput.Joystick.Pos[FEvent.Joystick.stick][FEvent.Joystick.axis] :=
                  FEvent.Joystick.Pos;
              end;
            end;

          ALLEGRO_EVENT_JOYSTICK_BUTTON_DOWN:
            begin
              FInput.Joystick.Button[FEvent.Joystick.Button] := True;
            end;

          ALLEGRO_EVENT_JOYSTICK_BUTTON_UP:
            begin
              FInput.Joystick.Button[FEvent.Joystick.Button] := False;
            end;

          ALLEGRO_EVENT_JOYSTICK_CONFIGURATION:
            begin
              al_reconfigure_joysticks;
              FInput.Joystick.Setup(0);
            end;

          ALLEGRO_EVENT_VIDEO_FINISHED:
            begin
              VideoFinishedEvent(PALLEGRO_VIDEO(FEvent.user.data1));
            end;

        end;
      end;
    until al_is_event_queue_empty(FQueue);

    if FWindow.Ready then
      begin
        //FDisplay.ResetTransform;
        UpdateTiming;
        OnClearFrame;
        OnRenderFrame;
        var trans: ALLEGRO_TRANSFORM := al_get_current_transform^;
        //Display.ResetTransform;
        OnRenderHUD;
        al_use_transform(@trans);
        OnShowFrame;
      end
    else
      begin
        Sleep(1);
      end;
    end;

  finally
    ClearInput;
    ClearAudio;
    UnloadAllFonts;
    UnloadAllBitmaps;
    UnloadAllSamples;
    UnloadVideo;
    OnShutdown;
    OnSaveConfig;
  end;

end;

end.
