$PBExportHeader$shudepb_dw.sra
$PBExportComments$���⣬�˳�������ڱ��������(��Ҳ����ѡ�� �˵�->�ļ�->DataWindow����ΪPbl ��DW����ΪPBL) -- Shu<KenShu@163.net>
forward
global type shudepb_dw from application
end type
type browseinfo from structure within shudepb_dw
end type
type itemidlist from structure within shudepb_dw
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

type browseinfo from structure
	unsignedlong		howner
	unsignedlong		pidlroot
	string		pszdisplayname
	string		lpsztitle
	unsignedinteger		ulflags
	unsignedlong		lpfn
	long		lparam
	integer		iimage
end type

type itemidlist from structure
	string		mkid
end type

global type shudepb_dw from application
string appname = 'shudepb_dw'
end type
global shudepb_dw shudepb_dw

type prototypes
Function unsignedlong SHGetPathFromIDListA( unsignedlong pidl, ref string pszPath) Library 'shell32.dll'
Function unsignedlong SHBrowseForFolderA( browseinfo lpbrowseinfo ) Library 'shell32.dll'
end prototypes
forward prototypes
public subroutine af_writefile (string as_filename, string as_string_to_write)
public function string get_dir ()
public function string about ()
end prototypes

public subroutine af_writefile (string as_filename, string as_string_to_write);integer  i,j
long ll_len,loops
string ls_swap
ll_len = len(as_string_to_write)
if ll_len>32765 then
	if mod(ll_len,32765) = 0 then
		loops = ll_len/32765
	else
		loops = (ll_len/32765) + 1
	end if
else
	loops = 1 
end if

i=fileopen(as_filename,StreamMode!,write!,lockreadwrite!,replace!)

if i>0 then
	for j = 1 to loops
		ls_swap = mid(as_string_to_write,(j - 1) * 32765 + 1,32765)
		filewrite(i,ls_swap)
	next
	fileclose(i)
	return
end if
	
return
end subroutine

public function string get_dir ();browseinfo lstr_bi
itemidlist lstr_idl
ulong ll_pidl,ll_r,ll_Null
int li_pos
String ls_Path
SetNull( ll_Null )
lstr_bi.hOwner = 0
lstr_bi.pidlRoot = 0
lstr_bi.lpszTitle = '��ѡ�����ڵ���DATAWINDOW��Ŀ¼'
lstr_bi.ulFlags = 1
lstr_bi.pszDisplayName = Space( 255 )
lstr_bi.lpfn = 0
ll_pidl = SHBrowseForFolderA( lstr_bi )
ls_Path = Space( 255 )
ll_R = SHGetPathFromIDListA( ll_pidl, ls_Path )
if len(ls_Path)>0 then
	if right(ls_Path,1) = '\' then
	else
		ls_path = ls_path + '\'
	end if
end if
RETURN ls_Path
end function

public function string about ();return 'Export By Shu<KenShu@163.net>'
end function

on shudepb_dw.create
appname='shudepb_dw'
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on shudepb_dw.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;string ls_pbd = 'd:\personal\desktop\shudepb\����ҽ��ǰ̨����\�����ظ�\lyjtzhtz.dll'
setlibrarylist(ls_pbd)
if pos(getlibrarylist(),ls_pbd)>0 then
	if fileexists(ls_pbd) then
	else
		MessageBox('����','�ļ�  '+ls_pbd+' �����ڡ�~r~n~r~n--Shu<KenShu@163.net>')
		return
	end if
else
	MessageBox('����','�����������������У��������� PBx0.exe ������.~r~n~r~n--Shu<KenShu@163.net>')
	return
end if
string ls_dir
//PDW0900.exe
string ls_dataobject[] = {'d_cbryzl_cy','d_dwbm_x','d_dwbm_c','d_dwbm_z','dddw_sa','d_jzdj_jk'}
datastore ld
string ls_swap
long i,j
ls_dir = this.get_dir()
if len(ls_dir)>0 then
	ld = create datastore
	j = upperbound(ls_dataobject)
	for i = 1 to j
		ld.dataobject = ls_dataobject[i]
		ls_swap = '$PBExportHeader$'+ls_dataobject[i]+'.srd~r~n'+ld.describe('datawindow.syntax')
		af_writefile(ls_dir+ls_dataobject[i]+'.srd',ls_swap)
	next
	destroy ld
end if
MessageBox('��Ϣ','��ɡ�')
end event
