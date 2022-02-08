{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Author:       François PIETTE @ OverByte
Creation:     July 22, 2021
Description:  Classes to act (File access or other) using another user account.
License:      This program is published under MOZILLA PUBLIC LICENSE V2.0;
              you may not use this file except in compliance with the License.
              You may obtain a copy of the License at
              https://www.mozilla.org/en-US/MPL/2.0/
Version:      1.0
History:
Jul 22, 2021  1.00 F. Piette Initial release


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit ImpersonateUser;

interface

uses
    Winapi.Windows, System.Classes, System.SysUtils;

const
    LOGON32_LOGON_NEW_CREDENTIALS  = 9;    // Missing in Delphi 10.4.2

type
    TImpersonateUser = class(TComponent)
    protected
        FUserToken : THandle;
        FErrorCode : DWORD;
    public
        destructor Destroy; override;
        function  Logon(const UserName : String;
                        const Domain   : String;
                        const Password : String) : Boolean;
        procedure Logoff();
        property ErrorCode : DWORD read FErrorCode;
    end;

implementation

{ TImpersonateUser }

destructor TImpersonateUser.Destroy;
begin
    if FUserToken <> 0 then begin
        CloseHandle(FUserToken);
        FUserToken := 0;
    end;
    inherited Destroy;
end;

procedure TImpersonateUser.Logoff;
begin
    if FUserToken <> 0 then begin
        RevertToSelf();   // Revert to our user
        CloseHandle(FUserToken);
        FUserToken := 0;
    end;
end;

function TImpersonateUser.Logon(
    const UserName : String;
    const Domain   : String;
    const Password : String): Boolean;
var
    LoggedOn : Boolean;
begin
    Result := FALSE;
    if FUserToken <> 0 then
        Logoff();

    if UserName = '' then begin // Must at least provide a user name
        FErrorCode := ERROR_BAD_ARGUMENTS;
        Exit;
    end;

    if Domain <> '' then
        LoggedOn := LogonUser(PChar(UserName),
                              PChar(Domain),
                              PChar(Password),
                              LOGON32_LOGON_INTERACTIVE,
                              LOGON32_PROVIDER_DEFAULT,
                              FUserToken)
    else
        LoggedOn := LogonUser(PChar(UserName),
                              PChar(Domain),
                              PChar(Password),
                              LOGON32_LOGON_NEW_CREDENTIALS,
                              LOGON32_PROVIDER_WINNT50,
                              FUserToken);
    if not LoggedOn then begin
        FErrorCode := GetLastError();
        Exit;
    end;

    if not ImpersonateLoggedOnUser(FUserToken) then begin
        FErrorCode := GetLastError();
        Exit;
    end;

    FErrorCode := ERROR_SUCCESS;
    Result     := TRUE;
end;

end.
