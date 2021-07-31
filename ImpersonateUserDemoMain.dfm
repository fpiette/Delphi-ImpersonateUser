object ImpersonateUserMainForm: TImpersonateUserMainForm
  Left = 0
  Top = 0
  Caption = 'ImpersonateUserMainForm'
  ClientHeight = 384
  ClientWidth = 716
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    716
    384)
  PixelsPerInch = 96
  TextHeight = 13
  object UserNameLabel: TLabel
    Left = 16
    Top = 19
    Width = 49
    Height = 13
    Caption = 'UserName'
  end
  object DomainLabel: TLabel
    Left = 16
    Top = 47
    Width = 35
    Height = 13
    Caption = 'Domain'
  end
  object PasswordLabel: TLabel
    Left = 16
    Top = 75
    Width = 46
    Height = 13
    Caption = 'Password'
  end
  object FilenameLabel: TLabel
    Left = 16
    Top = 102
    Width = 16
    Height = 13
    Caption = 'File'
  end
  object DataToWriteLabel: TLabel
    Left = 16
    Top = 129
    Width = 63
    Height = 13
    Caption = 'Data to write'
  end
  object UserNameEdit: TEdit
    Left = 92
    Top = 16
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'UserNameEdit'
  end
  object DomainEdit: TEdit
    Left = 92
    Top = 44
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'DomainEdit'
  end
  object PasswordEdit: TEdit
    Left = 92
    Top = 72
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'PasswordEdit'
  end
  object ImpersonateButton: TButton
    Left = 232
    Top = 14
    Width = 85
    Height = 25
    Caption = 'Impersonate'
    TabOrder = 3
    OnClick = ImpersonateButtonClick
  end
  object FileNameEdit: TEdit
    Left = 92
    Top = 100
    Width = 225
    Height = 21
    TabOrder = 4
    Text = 'FileNameEdit'
  end
  object RevertToSelfButton: TButton
    Left = 232
    Top = 42
    Width = 85
    Height = 25
    Caption = 'Revert to self'
    TabOrder = 5
    OnClick = RevertToSelfButtonClick
  end
  object FileAccessButton: TButton
    Left = 232
    Top = 70
    Width = 85
    Height = 25
    Caption = 'File access'
    TabOrder = 6
    OnClick = FileAccessButtonClick
  end
  object DisplayMemo: TMemo
    Left = 4
    Top = 188
    Width = 709
    Height = 193
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'DisplayMemo')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 7
  end
  object DataToWriteMemo: TMemo
    Left = 92
    Top = 128
    Width = 225
    Height = 51
    Lines.Strings = (
      'DataToWriteMemo')
    TabOrder = 8
  end
  object StreamCreateButton: TButton
    Left = 323
    Top = 70
    Width = 127
    Height = 25
    Caption = 'Stream Create'
    TabOrder = 9
    OnClick = StreamCreateButtonClick
  end
  object StreamFreeButton: TButton
    Left = 323
    Top = 98
    Width = 127
    Height = 25
    Caption = 'Stream Free'
    TabOrder = 10
    OnClick = StreamFreeButtonClick
  end
  object StreamRead100Button: TButton
    Left = 456
    Top = 98
    Width = 127
    Height = 25
    Caption = 'Stream Read 100 bytes'
    TabOrder = 11
    OnClick = StreamRead100ButtonClick
  end
  object StreamGetPositionButton: TButton
    Left = 323
    Top = 126
    Width = 127
    Height = 25
    Caption = 'Stream Get Position'
    TabOrder = 12
    OnClick = StreamGetPositionButtonClick
  end
  object StreamSetPositionTo10Button: TButton
    Left = 323
    Top = 154
    Width = 127
    Height = 25
    Caption = 'Stream Set Position to 10'
    TabOrder = 13
    OnClick = StreamSetPositionTo10ButtonClick
  end
  object StreamWriteDataButton: TButton
    Left = 456
    Top = 126
    Width = 127
    Height = 25
    Caption = 'Stream Write Data'
    TabOrder = 14
    OnClick = StreamWriteDataButtonClick
  end
  object StreamSetSizeTo10Button: TButton
    Left = 456
    Top = 70
    Width = 127
    Height = 25
    Caption = 'Stream SetSize to 10'
    TabOrder = 15
    OnClick = StreamSetSizeTo10ButtonClick
  end
  object OpenModeRadioGroup: TRadioGroup
    Left = 324
    Top = 10
    Width = 259
    Height = 41
    Caption = 'Open mode'
    Columns = 3
    ItemIndex = 1
    Items.Strings = (
      'Create'
      'Read'
      'ReadWrite')
    TabOrder = 16
  end
end
