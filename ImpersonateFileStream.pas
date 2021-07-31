{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Author:       François PIETTE @ OverByte
Creation:     July 22, 2021
Description:  TImpersonateFileStream is much like TFileStream but the file
              is accessed with user impersonation, that is gives access to
              the file under another account.
License:      This program is published under MOZILLA PUBLIC LICENSE V2.0;
              you may not use this file except in compliance with the License.
              You may obtain a copy of the License at
              https://www.mozilla.org/en-US/MPL/2.0/
Version:      1.0
History:
Jul 31, 2021  1.00 F. Piette Initial release


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit ImpersonateFileStream;

interface

uses
    Winapi.Windows,
    System.Classes, System.SysUtils, System.TypInfo,
    ImpersonateUser;

type
    EImpersonateFileStream = class(Exception);

    TImpersonateFileStream = class(TFileStream)
    protected
        FImpersonate   : TImpersonateUser;
    public
        constructor Create(const AFileName  : String;
                           const AMode      : Word;
                           const AUserName  : String;
                           const ADomain    : String;
                           const APassword  : String); overload;
        destructor Destroy; override;
    end;

implementation

{ TImpersonateFileStream }

constructor TImpersonateFileStream.Create(
    const AFileName  : String;
    const AMode      : Word;
    const AUserName  : String;
    const ADomain    : String;
    const APassword  : String);
begin
    // If no user name given, behave like a TFileStream (No cross account)
    if AUserName = '' then begin
        inherited Create(AFileName, AMode);
        Exit;
    end;

    // A username is given, try to logon the user before opening the file
    // and logoff once the file is opened (The file will be accessed as
    // the user used to logon, even after logoff).
    FImpersonate := TImpersonateUser.Create(nil);
    if not FImpersonate.Logon(AUserName, ADomain, APassword) then
         raise EImpersonateFileStream.CreateFmt('Logon error %d. %s.',
                             [FImpersonate.ErrorCode,
                              SysErrorMessage(FImpersonate.ErrorCode)]);
    try
        inherited Create(AFileName, AMode);
    finally
        FImpersonate.Logoff;
    end;
end;

destructor TImpersonateFileStream.Destroy;
begin
    FreeAndNil(FImpersonate);
    inherited Destroy;
end;

end.
