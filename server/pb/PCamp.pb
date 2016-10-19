
ï)
proto/PCamp.protoSoulProtocolcsproto/P_Common.proto"?
CampInfoLeaderMsg

id (
name (	
official ("P
CampPowerMsg

isGetDaily (
PowerSpeakCount (
ShutUpCount ("?

CampSysMsg
ids (
isShutUp (

isGetDaily ("
	ReqShutUp

id ("

SyncShutUp
isShutUp ("

SpeakOkMsg
num ("
ShutUpOkMsg
num ("
ReqPowerSpeaker
text (	"|
CampLeaderMsg

id (
name (	
force (
career (%
avatar (2.SoulProtocol.PAvatar
win ("4
CampLeaderTipsNty
state (
nextTime ("a
CampLeaderRivalNty*
rival (2.SoulProtocol.CampLeaderMsg
nextTime (
round (""
CampLeaderReadyReq
isOk (" 
CampLeaderReadyNty

id ("8
CampLeaderIntervalNty
state (
nextTime ("B
CampLeaderLoadNty
name (	
state (
nextTime ("'
CampLeaderLoadStateReq
state ("'
CampLeaderLoadStateNty
state ("E
CampLeaderFightOverNty
round (
result (
time ("#
CampLeaderRoundReq
round ("Q
CampLeaderRoundRet
round (,
leaders (2.SoulProtocol.CampLeaderMsg" 
CampJoinNty
	recommend ("
CampJoinReq
camp ("
CampJoinRet
camp ("
CampChangeReq"5
CampChangeRet
camp (
nextChangeTime ("8
CampLeaderAppointmentNty

id (
official ("8
CampLeaderAppointmentReq

id (
official ("
CampAppointmentQuitReq"
CampAppointmentQuitRet"W
CampLeaderEnterNty
round (
safeTime (
	fightTime (
state ("4
CampLeaderResultNty
round (
result ("ê
CampLeaderInfoNty
way (

id (
force (
name (	
times (%
avatar (2.SoulProtocol.PAvatar
beTimes ("
CampInfoReq"Ñ
CampInfoRet
nextChangeTime (.
infos (2.SoulProtocol.CampInfoLeaderMsg-
	powerInfo (2.SoulProtocol.CampPowerMsg"$
CampLeaderWorshipReq
type ("3
CampLeaderWorshipRet
type (
times ("#
CampLeaderStateNty
state ("!
PullerMiningOverReq

id ("!
PullerMiningOverRet

id ("
PullerMiningSubmitReq"
PullerMiningSubmitRet"+
PullerScoreNty
red (
blue ("!
PullerStoneNty
cdTimes (",
PullerStoneInfo

id (
index ("A
PullerStoneIdNty-
stones (2.SoulProtocol.PullerStoneInfo"8
PullerEnterNty
stoneNum (	
x (	
y ("Ü
PullerResutlMsg

id (
name (	
career (
camp (
force (
killNum (
score (
rank ("*
PullerRewardMsg

id (
num ("Ω
PullerOverNty
winCamp (,
infos (2.SoulProtocol.PullerResutlMsg.
rewards (2.SoulProtocol.PullerRewardMsg-
myInfo (2.SoulProtocol.PullerResutlMsg
useSec ("1
PullerStateNty
state (
nextTime ("
CampPullerEnterReq"
PullerRankReq"o
PullerRankRet
winCamp (,
infos (2.SoulProtocol.PullerResutlMsg
useSec (
myScore ("f
PullerRankMsg

id (
name (	
score (
camp (
killNum (
force (";
PullerRankNty*
infos (2.SoulProtocol.PullerRankMsg"#
PullerMyScoreNty
myScore ("0
PullerStoneTipsNty
camp (
name (	" 
PullerWinTipsNty
camp ("8
	WarTopMsg
name (	
camp (
killNum ("3
	WarTopNty&
infos (2.SoulProtocol.WarTopMsg"
WarMyKillNty
num ("4
WarTowerMsg

id (

hp (
maxHp ("

WarInfoReq"F

WarInfoRet(
infos (2.SoulProtocol.WarTowerMsg
cdTime ("}
WarTowerRankMsg

id (
name (	
career (
camp (
force (
towerNum (
	towerHurt ("
WarTowerRankReq"d
WarTowerRankRet,
infos (2.SoulProtocol.WarTowerRankMsg
towerNum (
	towerHurt ("z
WarKillRankMsg

id (
name (	
career (
camp (
force (
killNum (
assitNum ("
WarKillRankReq"`
WarKillRankRet+
infos (2.SoulProtocol.WarKillRankMsg
killNum (
assitNum ("≤
WarOverRankMsg

id (
name (	
career (
camp (
force (
killNum (
assitNum (
deadNum (

hurtPlayer	 (
	hurtTower
 ("ê
WarOverRankNty+
infos (2.SoulProtocol.WarOverRankMsg.
rewards (2.SoulProtocol.PullerRewardMsg

redCampNum (
blueCampNum (
time (
killNum (
assitNum (
deadNum (

hurtPlayer	 (
	hurtTower
 (
winCamp ("

WarCallReq

id (" 
WarCallInfoNty
cdTime ("&

WarCallNty

id (
name (	"2
CampWarStateNty
state (
nextTime ("
CampWarEnterReq":
CampWarEnterNty

redDiamond (
blueDiamond ("-
CampWarTowerTips

id (
index (".
CampWarKillTips
index (
name (	"1
CampWarKillNumTips
index (
name (	"*
WarOldRankMsg
name (	
num ("
WarOldRankReq"
KingStatusDeliveryReq"ë
WarOldRankRet.
	towerRank (2.SoulProtocol.WarOldRankMsg-
killRank (2.SoulProtocol.WarOldRankMsg
towerNum (
killNum ("0
GetDailyMsg

isGetDaily (
index ("'
HonorFameNty

lv (
exp ("
HonorFameLvReq"
HonorFameLvRet

lv (