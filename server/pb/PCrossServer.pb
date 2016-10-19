
Û
proto/PCrossServer.protoSoulProtocolcsproto/P_Common.proto"
TeamSignupReq"
PerosonSignupReq"
CS3V3InviteReq
agree ("!
CS3V3InviteNotify
name (	"?
CS3V3InviteMsg
result (
reseaon (
name ("¤
CS3V3MatchSuccessMsg
authId (

id (
host (	
port (
nature (9
rolelist (2'.SoulProtocol.CS3V3MatchSuccessMsg.Roleˆ
Role

id (
nick (	
server (
career (
actorId (%
avatar (2.SoulProtocol.PAvatar
nature ("I
CS3V3ReloginMsg
authId (

id (
host (	
port ("
CS3V3SignupMsg"<
CS3V3LoginReq
authId (

id (
relogin ("-
CS3V3ReloginReq
authId (

id (" 
CS3V3LoginMsg
sceneId ("%
CS3V3EnterSceneNtf
sceneId ("(
CrossServerRegisterMsg
reason ("2
CrossServerLoginReq

id (
account (	"
CrossServerEnterGameMsg" 
CsEnterNotify
sceneId (""
CsEnterSceneReq
sceneId ("
RoleRecordReq"¤
RoleRecordMsg
score (
scoreMax (
rank (
rankMax (
winCount (
winCountMax (
koCount (

koCountMax (
signup	 (:

jumpReward
 (2&.SoulProtocol.RoleRecordMsg.JumpReward

rankReward ('

JumpReward

id (
state ("
RankInfoReq"Ó
RankInfoMsg,
list (2.SoulProtocol.RankInfoMsg.Role•
Role

id (
actorId (
nick (	
career (%
avatar (2.SoulProtocol.PAvatar
rank (
score (
server ("
RewardInfoReq"
RewardInfoMsg"
	SignupReq"³
	SignupMsg
time (.
rolelist (2.SoulProtocol.SignupMsg.Roleh
Role

id (
nick (	
career (
actorId (%
avatar (2.SoulProtocol.PAvatar"
SignupFailedNotify" 
TeamInviteNotify
what ("%
TeamInviteConfirmReq
agree ("
GiveupSignupReq"/
GiveupSignupMsg
nick (	
reason ("‹

LoadingMsg
time (+
list (2.SoulProtocol.LoadingMsg.Role
nature (2
Role
nature (
name (	
done ("

ReadyReq"
EnterTimeoutNotify"Ó
BattleReportNotify3
list (2%.SoulProtocol.BattleReportNotify.Role‡
Role
nick (	

ko (
assit (
die (
score (
nature (
online (

id (
server	 ("

HistoryReq"©
History
result (
time (
	winNature ((
list (2.SoulProtocol.History.RoleÂ
Role
nick (	
server (

ko (
assit (
die (

fightScore (
	rankScore (!
item (2.SoulProtocol.PItem
nature	 (
career
 (

id ("1

HistoryMsg#
list (2.SoulProtocol.History"¬
BattleMessageMsg
type (=

scoreReach (2).SoulProtocol.BattleMessageMsg.ScoreReach;
	killReach (2(.SoulProtocol.BattleMessageMsg.KillReach=

killReport (2).SoulProtocol.BattleMessageMsg.KillReport=

buffReport (2).SoulProtocol.BattleMessageMsg.BuffReport+

ScoreReach
nature (
score (8
	KillReach
nature (
name (	
count (o

KillReport
attacker (	
attackerNature (
defender (	
defenderNature (
score (8

BuffReport
nature (
name (	
buff ("/
ActivityStateNty
state (
time (