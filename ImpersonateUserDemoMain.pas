{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Author:       François PIETTE @ OverByte
Creation:     July 22, 2021
Description:  Demo for the classes to access files in another user account.
License:      This program is published under MOZILLA PUBLIC LICENSE V2.0;
              you may not use this file except in compliance with the License.
              You may obtain a copy of the License at
              https://www.mozilla.org/en-US/MPL/2.0/
Version:      1.0
History:
Jul 31, 2021  1.00 F. Piette Initial release


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit ImpersonateUserDemoMain;

interface

uses
    Winapi.Windows, Winapi.Messages,
    System.SysUtils, System.Variants, System.Classes,
    Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
    ImpersonateUser,
    ImpersonateFileStream, Vcl.ExtCtrls;

const
    MAX_DISPLAY_LINES = 4000;

type
    TImpersonateUserMainForm = class(TForm)
        UserNameLabel: TLabel;
        DomainLabel: TLabel;
        PasswordLabel: TLabel;
        UserNameEdit: TEdit;
        DomainEdit: TEdit;
        PasswordEdit: TEdit;
        ImpersonateButton: TButton;
        FilenameLabel: TLabel;
        FileNameEdit: TEdit;
        RevertToSelfButton: TButton;
        FileAccessButton: TButton;
        DisplayMemo: TMemo;
        DataToWriteLabel: TLabel;
        DataToWriteMemo: TMemo;
        StreamCreateButton: TButton;
        StreamFreeButton: TButton;
        StreamRead100Button: TButton;
        StreamGetPositionButton: TButton;
        StreamSetPositionTo10Button: TButton;
        StreamWriteDataButton: TButton;
        StreamSetSizeTo10Button: TButton;
        OpenModeRadioGroup: TRadioGroup;
        procedure StreamSetSizeTo10ButtonClick(Sender: TObject);
        procedure FileAccessButtonClick(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure ImpersonateButtonClick(Sender: TObject);
        procedure RevertToSelfButtonClick(Sender: TObject);
        procedure StreamCreateButtonClick(Sender: TObject);
        procedure StreamFreeButtonClick(Sender: TObject);
        procedure StreamGetPositionButtonClick(Sender: TObject);
        procedure StreamRead100ButtonClick(Sender: TObject);
        procedure StreamSetPositionTo10ButtonClick(Sender: TObject);
        procedure StreamWriteDataButtonClick(Sender: TObject);
    private
        FImpersonate : TImpersonateUser;
        FStream      : TStream;
        procedure Display(const Msg : String); overload;
        procedure Display(const Msg : String; Args : array of const); overload;
    public
        destructor Destroy; override;
    end;

var
    ImpersonateUserMainForm: TImpersonateUserMainForm;

implementation

{$R *.dfm}

procedure TImpersonateUserMainForm.FormCreate(Sender: TObject);
begin
    FImpersonate      := TImpersonateUser.Create(Self);
    UserNameEdit.Text := 'JohnDoe';
    DomainEdit.Text   := '.';
    PasswordEdit.Text := 'JohnDoePassword';
    FilenameEdit.Text := 'C:\Users\JohnDoe\Documents\HelloWorld.txt';
    DataToWriteMemo.Clear;
    DataToWriteMemo.Lines.Add('ImpersonateUser demo.');
    DataToWriteMemo.Lines.Add('(c) 2021 francois.piette@overbyte.be.');
end;

destructor TImpersonateUserMainForm.Destroy;
begin
    FreeAndNil(FStream);
    inherited Destroy;
end;

// Helper function to display a message in the memo like Format()
procedure TImpersonateUserMainForm.Display(
    const Msg : String;
    Args      : array of const);
begin
    Display(Format(Msg, Args));
end;

// Helper function to display a simple stringmessage in the memo
procedure TImpersonateUserMainForm.Display(const Msg: String);
begin
    if csDestroying in ComponentState then
        Exit;
    DisplayMemo.Lines.BeginUpdate;
    try
        if DisplayMemo.Lines.Count > MAX_DISPLAY_LINES then begin
            while DisplayMemo.Lines.Count > MAX_DISPLAY_LINES do
                DisplayMemo.Lines.Delete(0);
        end;
        DisplayMemo.Lines.Add(FormatDateTime('YYYMMDD HHNNSS ', Now) + Msg);
    finally
        DisplayMemo.Lines.EndUpdate;
        SendMessage(DisplayMemo.Handle, EM_SCROLLCARET, 0, 0);
    end;
end;

procedure TImpersonateUserMainForm.StreamCreateButtonClick(Sender: TObject);
var
    Mode : WORD;
begin
    try
        case OpenModeRadioGroup.ItemIndex of
        0:   Mode := fmCreate;
        1:   Mode := fmOpenRead;
        else Mode := fmOpenReadWrite;
        end;
        // TImpersonateFileStream is much like TFileStream but the file is
        // opened using the given user account
        FStream := TImpersonateFileStream.Create(FilenameEdit.Text,
                                                 Mode,
                                                 UserNameEdit.Text,
                                                 DomainEdit.Text,
                                                 PasswordEdit.Text);
        Display('Stream created');
    except
        on E:Exception do begin
            Display('Create exception. ' + E.ClassName + ': ' + E.Message);
        end;
    end;
end;

procedure TImpersonateUserMainForm.StreamFreeButtonClick(Sender: TObject);
begin
    if not Assigned(FStream) then
        Display('Stream not opened yet')
    else begin
        FreeAndNil(FStream);
        Display('Stream freed');
    end;
end;

procedure TImpersonateUserMainForm.StreamRead100ButtonClick(Sender: TObject);
var
    Count  : LongInt;
    Buffer : TBytes;
    Text   : String;
begin
    if not Assigned(FStream) then begin
        Display('Stream no opened yet');
        Exit;
    end;
    try
        SetLength(Buffer, 100);
        Count := FStream.Read(Buffer[0], Length(Buffer));
        SetLength(Buffer, Count);
        Text := TEncoding.UTF8.GetString(Buffer);
        Display('%d bytes read from file: "%s"', [Count, Text]);
    except
        on E:Exception do begin
            Display('Read exception. ' + E.ClassName + ': ' + E.Message);
        end;
    end;
end;

procedure TImpersonateUserMainForm.StreamWriteDataButtonClick(Sender: TObject);
var
    Buffer : TBytes;
    Count  : Integer;
begin
    if not Assigned(FStream) then begin
        Display('Stream no opened yet');
        Exit;
    end;
    try
        Buffer := TEncoding.UTF8.GetBytes(DataToWriteMemo.Text);
        Count := FStream.Write(Buffer[0], Length(Buffer));
        SetLength(Buffer, Count);
        Display('%d bytes written to file: "%s"', [Count, Text]);
    except
        on E:Exception do begin
            Display('Write exception. ' + E.ClassName + ': ' + E.Message);
        end;
    end;
end;

procedure TImpersonateUserMainForm.StreamSetSizeTo10ButtonClick(Sender: TObject);
begin
    if not Assigned(FStream) then begin
        Display('Stream no opened yet');
        Exit;
    end;
    try
        FStream.Size := 10;
        Display('New size set to 10');
    except
        on E:Exception do begin
            Display('SetSize exception. ' + E.ClassName + ': ' + E.Message);
        end;
    end;
end;

procedure TImpersonateUserMainForm.StreamGetPositionButtonClick(
    Sender : TObject);
var
    Res : Int64;
begin
    if not Assigned(FStream) then begin
        Display('Stream no opened yet');
        Exit;
    end;
    try
        Res := FStream.Position;
        Display('Position is %d', [Res]);
    except
        on E:Exception do begin
            Display('GetPosition exception. ' + E.ClassName + ': ' + E.Message);
        end;
    end;
end;

procedure TImpersonateUserMainForm.StreamSetPositionTo10ButtonClick(
    Sender : TObject);
begin
    if not Assigned(FStream) then begin
        Display('Stream no opened yet');
        Exit;
    end;
    try
        FStream.Position := 10;
        Display('Position set to 10');
    except
        on E:Exception do begin
            Display('GetPosition exception. ' + E.ClassName + ': ' + E.Message);
        end;
    end;
end;

procedure TImpersonateUserMainForm.FileAccessButtonClick(Sender: TObject);
var
    Stream : TFileStream;
begin
    try
        if not FileExists(FileNameEdit.Text) then
            Display('File not found')
        else begin
            Stream := TFileStream.Create(FileNameEdit.Text, fmOpenRead);
            try
                Display('File opened');
            finally
                Stream.Free;
            end;
        end;
    except
        on E:Exception do
            Display(E.Classname + ': ' + E.Message);
    end;
end;

procedure TImpersonateUserMainForm.ImpersonateButtonClick(Sender: TObject);
begin
    if not FImpersonate.Logon(UserNameEdit.Text,
                              DomainEdit.Text,
                              PasswordEdit.Text) then begin
        Display(Format('Failed with error 0x%X', [FImpersonate.ErrorCode]));
    end
    else
        Display('Logon OK');
end;

procedure TImpersonateUserMainForm.RevertToSelfButtonClick(Sender: TObject);
begin
    FImpersonate.Logoff;
    Display('Reverted to self');
end;

end.
