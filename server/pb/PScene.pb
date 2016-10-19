
Á
csproto/PScene.protoSoulProtocolcsproto/P_Common.proto"/
TransferSceneReq

id (
reEnter ("/
TransferSceneMsg

id (
reEnter ("C
TeleportSceneReq

id (#
pos (2.SoulProtocol.PVector2"O
EnterSceneMsg"
role (2.SoulProtocol.PActor
area (
wave ("O
ItemEnterMsg

id (
itemId (#
pos (2.SoulProtocol.PVector2"Å
PItemMsg

id (
itemId (#
pos (2.SoulProtocol.PVector2
	collectId (
collectTime (
name (	"
	PortalReq

id ("Q
TeleportMsg

id (#
des (2.SoulProtocol.PVector2
	timestamp ("w
StartMoveReq

id (#
cur (2.SoulProtocol.PVector2#
des (2.SoulProtocol.PVector2
	timestamp ("Ö
StartMoveMsg

id (#
cur (2.SoulProtocol.PVector2#
des (2.SoulProtocol.PVector2
	timestamp (
type ("Q
StopMoveReq

id (#
cur (2.SoulProtocol.PVector2
	timestamp ("Q
StopMoveMsg

id (#
cur (2.SoulProtocol.PVector2
	timestamp ("Z
EnterSightMsg#
actor (2.SoulProtocol.PActor$
item (2.SoulProtocol.PItemMsg"+
ExitSightMsg
actor (
item ("I
	DropAllot

id (
nick (	"
items (2.SoulProtocol.PItem"]
MonsterDropMsg#
pos (2.SoulProtocol.PVector2&
allot (2.SoulProtocol.DropAllot"Z
BuffDropMsg#
pos (2.SoulProtocol.PVector2&
allot (2.SoulProtocol.DropAllot"'
ReqBuffPick

id (
type ("o
	RotateMsg

id (#
dir (2.SoulProtocol.PVector2
time (#
pos (2.SoulProtocol.PVector2"7
StageInfoMsg

id (
state (
star (")
TimesInfoMsg
type (
num ("®
CampaignGetMsg*
stages (2.SoulProtocol.StageInfoMsg)
times (2.SoulProtocol.TimesInfoMsg,
buyTimes (2.SoulProtocol.TimesInfoMsg
	callstamp ("+
CampaignBuyReq
type (
num ("?
CampaignUnlockMsg*
stages (2.SoulProtocol.StageInfoMsg"'
SyncFlagMsg

id (
flag ("'
SyncCampMsg

id (
camp ("+
SyncOnlineMsg

id (
online (")
SyncLevelMsg

id (
level ("N
SyncTeamMsg

id (
teamId (

teamLeader (
teamNum ("*
SyncSkillMsg

id (
skills ("<
SyncAttrMsg

id (!
attr (2.SoulProtocol.PAttr"B
SyncAvatarMsg

id (%
avatar (2.SoulProtocol.PAvatar"'
SyncShowMsg

id (
show ("O
SyncEscortRobMsg

id (
robbed (
	robbedIds (
flag ("-
SyncGuildMsg

id (
	guildName (	")
SyncGradeMsg

id (
grade ("'
SyncNickMsg

id (
nick (	".
SpawnTipsMsg
title (	
content (	"Ü
	InstrInfo
type (#
des (2.SoulProtocol.PVector2#
dir (2.SoulProtocol.PVector2
skillId (
targetId ("C
InstructionMsg

id (%
info (2.SoulProtocol.InstrInfo"j
WildBossStartMsg
bossName (	
	sceneName (	
sceneId (
state (
	startTime (")
SyncTitleMsg

id (
title ("
PressRoleReq

id ("–
PressRoleMsg

id (
career (
name (	
level (
camp (
force (
teamId (

teamLeader (
teamNum	 (
	guildName
 (	
isOnline (
serverId ("
SceneLoadReq

ui ("Á
SceneLoadMsg-
list (2.SoulProtocol.SceneLoadMsg.Load

ui (
sceneId ('
CampInfo
camp (
count (b
Load

sceneIndex (
sceneId (5
campInfo (2#.SoulProtocol.SceneLoadMsg.CampInfo"3
SceneLineMsg

sceneIndex (
sceneId ("%
SceneSelectReq
sceneHandle ("
CheatMsg
type (