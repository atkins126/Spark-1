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

unit uMusic;

interface

uses
  System.SysUtils,
  Spark,
  uBaseExample;

type
  { TExample }
  TExample = class(TBaseExample)
  protected
    FFilename: string;
    FNum: Integer;
    procedure Play(aNum: Integer; aVol: Single);
  public
    procedure OnGetSettings(var aSettings: TGame.TSettings); override;
    procedure OnLoadConfig; override;
    procedure OnSaveConfig; override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnClearFrame; override;
    procedure OnUpdateFrame(aDeltaTime: Double); override;
    procedure OnRenderFrame; override;
    procedure OnRenderHUD; override;
    procedure OnShowFrame; override;
  end;

{ Routines }
procedure RunExample;

implementation

uses
  System.IOUtils;

{ Routines }
procedure RunExample;
begin
  RunGame(TExample);
end;

{ TExample }
procedure TExample.Play(aNum: Integer; aVol: Single);
begin
  FFilename := Format('arc/audio/music/song%.*d.ogg', [2,aNum]);
  UnloadMusic;
  LoadMusic(FFilename);
  PlayMusic(aVol, True);
end;

procedure TExample.OnGetSettings(var aSettings: TGame.TSettings);
begin
  inherited;
  aSettings.WindowTitle := 'Music Example';
end;

procedure TExample.OnLoadConfig;
begin
  inherited;
end;

procedure TExample.OnSaveConfig;
begin
  inherited;
end;

procedure TExample.OnStartup;
begin
  inherited;

  FNum := 1;
  FFilename := '';
  Play(1, 1.0);
end;

procedure TExample.OnShutdown;
begin
  UnloadMusic;

  inherited;
end;

procedure TExample.OnClearFrame;
begin
  inherited;
end;

procedure TExample.OnUpdateFrame(aDeltaTime: Double);
begin
  inherited;

  if KeyboardPressed(KEY_UP) then
  begin
    Inc(FNum);
    if FNum > 13 then
      FNum := 1;
    Play(FNum, 1.0);
  end
  else
  if KeyboardPressed(KEY_DOWN) then
  begin
    Dec(FNum);
    if FNum < 1 then
      FNum := 13;
    Play(FNum, 1.0);
  end
end;

procedure TExample.OnRenderFrame;
begin
  inherited;
end;

procedure TExample.OnRenderHUD;
begin
  inherited;
  HudText(DefaultFont, GREEN,  haLeft, HudTextItem('Up/Dn', 'Play sample'), []);
  HudText(DefaultFont, ORANGE, haLeft, HudTextItem('Song:', '%s', ' '), [TPath.GetFileName(FFilename)]);
end;

procedure TExample.OnShowFrame;
begin
  inherited;
end;



end.
