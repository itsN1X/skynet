
Ò%
proto/PGuild.protoSoulProtocolcsproto/P_Common.proto"á
GuildRoleMsg

id (
nick (	
level (
force (
time (
career (
job (
hisContribut ("7
GuildLogMsg
type (
time (
name (	")
AbdicateMsg
time (
Name (	"
DissolveMsg
time ("Œ
GuildInfoMsg
guildId (
	guildName (	

chairmanId (
chairmanName (	
campId (
level (
exp (
gold (
weekExp	 (
ranking
 (
notice (	
joinSetting (

altarCount (+
members (2.SoulProtocol.GuildRoleMsg&
log (2.SoulProtocol.GuildLogMsg,
joinList (2.SoulProtocol.GuildRoleMsg+
abdicate (2.SoulProtocol.AbdicateMsg+
dissolve (2.SoulProtocol.DissolveMsg"µ
GuildSearchMsg
guildId (
	guildName (	
campId (

chairmanId (
chairmanName (	
level (
	memberNum (
	isReqJoin (
joinTime	 ("X
GuildListMsg*
list (2.SoulProtocol.GuildSearchMsg
index (
count ("=
GuildMemberMsg+
members (2.SoulProtocol.GuildRoleMsg"0
LogMsg&
log (2.SoulProtocol.GuildLogMsg"U
GuildJoinListMsg,
joinList (2.SoulProtocol.GuildRoleMsg
joinSetting ("H
GuildAltarMsg
level (
exp (
gold (
count ("
JoinSettingMsg
type ("0
JoinOrCancelMsg
type (
guildId ("W
OperMemberMsg
type (

id (,
roleInfo (2.SoulProtocol.GuildRoleMsg"
	NoticeMsg
notice (	"
RejectedMsg
guildId ("o
SearchGuildListMsg*
list (2.SoulProtocol.GuildSearchMsg
index (
count (
guildId ("#
RoleJoinListMsg
guildIds ("#
CreateGuildReq
	guildName (	"
JoinReq
guildId (" 
CancelJoinReq
guildId ("
QuitReq
guildId ("@
OperMemberReq
type (
guildId (
playerId ("
	NoticeReq
notice (	"
GuildInfoReq
guildId ("
AltarReq
type ("
JoinSettingReq
type ("
AbdicateReq
playerId (".
GuildListReq
index (
isFirst ("
	SearchReq
name (	"±
ElementStageMsg:
stages (2*.SoulProtocol.ElementStageMsg.AttrStageMsg

difficulty (N
AttrStageMsg
sceneId (
ids (
status (
progress (")
PlayerTimeMsg

id (
time ("‡
ElementInfoMsg
status (
endTime (

difficulty (,
players (2.SoulProtocol.PlayerTimeMsg
participants (
playerRecord (-
stages (2.SoulProtocol.ElementStageMsg
passDiff ("&
CreateElementReq

difficulty (""
EnterElementReq
sceneId ("
	RewardReq
sceneId ("@
	RewardMsg
sceneId ("
items (2.SoulProtocol.PItem".
ElementTipMsg
type (
sceneId ("D
GuildTaskMsg

id (
pro (
index (
used ("+
GuildTaskExMsg

id (
index ("n
GuildTaskInitNty)
tasks (2.SoulProtocol.GuildTaskMsg/
	overTasks (2.SoulProtocol.GuildTaskExMsg"8
GuildTaskNty(
task (2.SoulProtocol.GuildTaskMsg"B
GuildOverTaskNty.
overTask (2.SoulProtocol.GuildTaskExMsg"
GuildTaskItemReq

id ("
GuildTaskRewarReq

id ("*
guildBoxInfo
boxId (
num ("@
BoxLotteryInfo
	timeStamp (
nick (	
boxId ("s
RewardHallInfoMsg+
boxList (2.SoulProtocol.guildBoxInfo1
boxesRecord (2.SoulProtocol.BoxLotteryInfo"e
GuildOneBoxMsg
boxId (:-1
num (:-1/
	oneRecord (2.SoulProtocol.BoxLotteryInfo"Ü
lotteryGuildBoxInfo
boxId (
num ("
items (2.SoulProtocol.PItem/
	oneRecord (2.SoulProtocol.BoxLotteryInfo"
GuildBuildInfoReq"ü
GuildBuildInfoMsg7
info (2).SoulProtocol.GuildBuildInfoMsg.buildInfoQ
	buildInfo

id (

lv (
exp (
	speedTime (
func ("
GuildMiningReq"
StartMineReq
type ("´
GuildMiningMsg
miningLv (
floor (
	mineCount ('

totalItems (2.SoulProtocol.PItem%
curItems (2.SoulProtocol.PItem
freeMineCount ("1
GuildBuidContributReq

id (
type ("ï
GuildBuildContributMsg

id (

lv (
exp (
	speedTime (
type ("
items (2.SoulProtocol.PItem
	startTime (")
GuildBuildProductionInfoReq

id ("ë
GuildBuildProductionInfoMsg

id (

lv (
	speedTime (
lastTime ("
items (2.SoulProtocol.PItem
	startTime ("(
GetGuildBuildProductionReq

id ("ê
GetGuildBuildProductionMsg

id (

lv (
	speedTime (
lastTime ("
items (2.SoulProtocol.PItem
	startTime (" 
GuildBuildSpeedReq

id ("?
GuildBuildSpeedMsg

id (

lv (
	speedTime ("@
GuildImpeachMsg
	isImpeach (
time (
list (