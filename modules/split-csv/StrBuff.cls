VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "StrBuff"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

' ���Ա
Private cFile As TextStream      ' fso TextStream
Private cFileNumber As Integer  ' ��Open filename For Input As #filein�������ļ���(filenumber)
Private cBuff As String      ' ʹ���ַ�����Ϊbuff��
Private cRowCount As Long   ' cBuff���м���
Private cRowMax As Long     ' cBuff�������
Private cFileOpenType As Integer ' �ļ��򿪷�ʽ: 0δ֪; 1��fso OpenTextFile ��; 2 ��Open filename For Input As #filein ��ʽ��
Private cFirstWrite As Boolean  '�ǲ��ǵ�һ�����ļ�д������,��fso �򿪷�ʽʹ�ã���ֹ���ļ���ǰ����հ���

Private Const fsoOpenTextFile As Integer = 1
Private Const vbOpen As Integer = 2
Private Const otherOpen As Integer = 0

''' ��ʼ��
Private Sub class_initialize()
  cBuff = ""
  cRowCount = 0
  cFileNumber = 0
  cRowMax = 1024  '���1024�У����Ե���
  cFileOpenType = otherOpen
  cFirstWrite = True
End Sub

''' file ���� r w
Public Property Get File() As Object
    Set File = cFile
End Property

Public Property Set File(f As Object)
  Set cFile = f
End Property

'''FileNumber����  rw
Public Property Get FileNumber() As Integer
  FileNumber = cFileNumber
End Property

Public Property Let FileNumber(ByVal fn As Integer)
    cFileNumber = fn
End Property

'''buff���� r
Public Property Get Buff() As String
  Buff = cBuff
End Property

'Public Property Let Buff(buf As String)
'    cBuff = buf
'End Property

'''RowCount���� r
Public Property Get RowCount() As Long
  RowCount = cRowCount
End Property

'Public Property Let RowCount(byval n As Long)
'  cRowCount = n
'End Property

''' RowMax ���� r w
Public Property Get RowMax() As Long
  RowMax = cRowMax
End Property

Public Property Let RowMax(ByVal n As Long)
  cRowMax = n
End Property


''''''''''''''''''''''''''''''''''''
''' ���г�Ա����

Public Sub AddLine(ByVal line$, Optional ByVal line_ending$ = vbCrLf)
''' �� buff������һ��
    '' ���� line: string Ҫ���ӵ��ַ���
    '' ����lineending : string ���з�
    
    If cBuff = "" Then cBuff = line Else cBuff = cBuff & line_ending & line
    
    cRowCount = cRowCount + 1
    If cRowCount = cRowMax Then WritetoFile line_ending
End Sub

Public Sub WriteUnixFile(Optional line_ending$ = vbLf)
    ''' д��ǰ����
    ' unix �ļ����з��� vbLf ����ֻ���� textstream.write����д��
    If cRowCount = 0 Then Exit Sub
    
    Dim tp As Integer
    tp = GetOpenType()     ' ȱ�ٴ��������ƣ�tpΪ��������Ҫ���ѱ���

    If tp = fsoOpenTextFile Then
        If cFirstWrite Then
            cFile.Write cBuff
            cFirstWrite = False
        Else
            cFile.Write (line_ending & cBuff)
        End If
    End If

    cBuff = ""
    cRowCount = 0
End Sub

Public Sub WritetoFile()
''' ��buff������д���ļ�
''' fso.write ����д�뻻�з������� write #1, str ���Զ�д�뻻��vbCrLf
    
    ''' д��ǰ����
    If cRowCount = 0 Then Exit Sub
    
    Select Case GetOpenType
        Case fsoOpenTextFile
            cFile.WriteLine cBuff
        Case vbOpen
            Print #cFileNumber, cBuff   '' Write ������ �� �ַ�����˫����Ҳд�룬����Print ����
    End Select
    
    cBuff = ""
    cRowCount = 0
End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''˽�г�Ա����
Private Function GetOpenType() As Integer
''' �ж��ļ��򿪷�ʽ���� fso.opentextfile Ϊ1��vb �� Open Ϊ 2 ������Ϊ0 ��������Ҫ���д�������
    If cFileOpenType = 0 Then
        If Not cFile Is Nothing Then
            cFileOpenType = fsoOpenTextFile
        ElseIf cFileNumber > 0 And cFileNumber < 512 Then
            cFileOpenType = vbOpen
        Else
            cFileOpenType = otherOpen
        End If
    End If
    GetOpenType = cFileOpenType
End Function


''' terminate
Private Sub class_terminate()
    If Not cFile Is Nothing Then Set cFile = Nothing
End Sub