
Ê
csproto/PChat.protoSoulProtocolcsproto/P_Common.proto"K

PCRoleInfo

id (
name (	
unionId (

vipbadgelv ("&

PriChatReq

id (
nick (	"S
PLocationInfo#
pos (2.SoulProtocol.PVector2
sceneId (
line ("»
PChatMsg*
roleInfo (2.SoulProtocol.PCRoleInfo

id (
name (	
txt (	
voice (
time (
channelType (
chatType (
voiceLen	 (
isListen
 (
voiceTx (	
index (
showId (
	showIndex (
recruitArg1 (
recruitArg2 (
recruitArg3 (	/

myLocation (2.SoulProtocol.PLocationInfo
serverId (:0
isBigTrumpet (:false
extInfo ("$
	PItemInfo

id (
uid ("µ
ChatReq

id (
txt (	
voice (
channelType (
chatType (
voiceLen (
voiceTx (	
index ()
itemInfo	 (2.SoulProtocol.PItemInfo"M

VoiceTxReq

id (
channelType (
index (
voiceTx (	"O
ReadReq
index (
channelType (
chatType (
fromId ("\

VoiceTxMsg

id (
recId (
channelType (
index (
voiceTx (	"1
ComMsg'
chatMsg (2.SoulProtocol.PChatMsg"8
ChatWorldMsg(
worldMsg (2.SoulProtocol.PChatMsg"<
AdvertiseMsg
title (	
content (	
type ("Œ

HisChatMsg(
guildMsg (2.SoulProtocol.PChatMsg(
worldMsg (2.SoulProtocol.PChatMsg*

privateMsg (2.SoulProtocol.PChatMsg"&

ChatTipMsg
type (

id ("!
GratisTrumpetMsg
count (";

PriChatMsg

id (
nick (	
serverId (:0"¥
GetEquipShowReq
	showIndex (

showFromId (
showChannelType (
showSceneId (
showSceneIndex (
showToId (
showGuildId ("S
EquipShowMsg

id (
name (	)
info (2.SoulProtocol.PackEquipInfo"D

RecruitReq
type (
arg1 (
arg2 (
arg3 (	"°
SysNoticeMsg5
notices (2$.SoulProtocol.SysNoticeMsg.noticeMsgi
	noticeMsg

id (
	starttime (
endtime (
title (	
content (	
time ("
	RobBoxReq
gesture (	"T
RobBoxInfoMsg

id (
num (
max (
gesture (	
args ("}
RobBoxBackMsg

id (
num (
max (
gesture (	
	isSuccess ("
items (2.SoulProtocol.PItem