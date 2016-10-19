
≥-
csproto/PFight.protoSoulProtocolcsproto/P_Common.proto"{

SetDashReq

id (#
des (2.SoulProtocol.PVector2
vel (
time (
source (
	timestamp ("n

SetDashMsg

id (#
des (2.SoulProtocol.PVector2
time (
source (
	timestamp ("^
BlinkReq

id (#
des (2.SoulProtocol.PVector2
source (
	timestamp ("^
BlinkMsg

id (#
des (2.SoulProtocol.PVector2
source (
	timestamp ("+
TargetLockReq

id (
target ("+
TargetLockMsg

id (
target ("Ω
UseSkillReq

id (
skill (#
pos (2.SoulProtocol.PVector2#
dir (2.SoulProtocol.PVector2#
loc (2.SoulProtocol.PVector2
	targetids (
	timestamp ("Ã
UseSkillMsg

id (
skill (#
pos (2.SoulProtocol.PVector2#
dir (2.SoulProtocol.PVector2#
loc (2.SoulProtocol.PVector2
	targetids (
	timestamp (
state (">
UsePowerReq

id (#
dir (2.SoulProtocol.PVector2">
UsePowerMsg

id (#
dir (2.SoulProtocol.PVector2"0
SkillFinishReq
skill (
targets ("Ì
PDamage

id (#
pos (2.SoulProtocol.PVector2
hurt (:-1
state (:-1
hp (:-1
mp (:-1
ap (:-1#
des (2.SoulProtocol.PVector2
time	 (:-1
atkLock
 (
hurtBase (:-1"~
	DamageReq

id (
skill (
	skill_act (
seed (&
targets (2.SoulProtocol.PDamage
index ("ü
	DamageMsg'
attacker (2.SoulProtocol.PDamage
skill (
	skill_act (
seed (&
targets (2.SoulProtocol.PDamage
	timestamp ("3

DamagesReq%
reqs (2.SoulProtocol.DamageReq"3

DamagesMsg%
msgs (2.SoulProtocol.DamageMsg"7
SyncDamageMsg&
targets (2.SoulProtocol.PDamage"Q

AddBuffMsg

id (
buffs (
	timestamp (

stackTimes (:1"R
UpdateBuffMsg

id ("
buffs (2.SoulProtocol.PBuff
	timestamp ("Q
OccurBuffMsg

id (

hp (

mp (

ap (
	timestamp ("'

DelBuffMsg

id (
buffs ("(
SummonPoolMsg

id (
ids ("*
SummonDieMsg

id (
summon ("
DieMsg

id ("'

DefenseMsg

id (
state (")
FoeReq
targetId (
state ("5
FoeMsg

id (
targetId (
state ("%
	PkModeReq

id (
mode ("4
	PkModeMsg

id (
mode (
stamp ("(
EvilStateMsg

id (
evil ("%
	ReliveReq

id (
cost ("2
ReliveTimesMsg
	sceneType (
times ("=
ReliveTimesNty+
infos (2.SoulProtocol.ReliveTimesMsg";
	ReliveMsg

id (

hp (

mp (

ap ("ö
InitReportMsg
stamp ($
enemys (2.SoulProtocol.PActor#
heros (2.SoulProtocol.PActor
index (
randId (
randWave ("¯
	ReportReq
stamp (
endStamp (
result (
itemIds (/
summons (2.SoulProtocol.ReportReq.Summon1
fighters (2.SoulProtocol.ReportReq.Fighter%
Summon

id (
skillId (˚
Hurt
atkId (
defId (
skillId (
skillAct (
seed (
hurt ($
atkAttr (2.SoulProtocol.PAttr$
atkBuff (2.SoulProtocol.PBuff$
defAttr	 (2.SoulProtocol.PAttr$
defBuff
 (2.SoulProtocol.PBuffç
Skill

id (
times (
damage (

sampleTime (
sampleTimes (0

sampleHurt (2.SoulProtocol.ReportReq.Hurtè
Fighter

id (-
skills (2.SoulProtocol.ReportReq.Skill1

hurtSkills (2.SoulProtocol.ReportReq.Skill
hurt (
hpRegen (
relive (
mpRegen (-
dieHurt (2.SoulProtocol.ReportReq.Hurt
hit	 (
nature
 (

hp ("+
StageOverInfo
key (
value (	"Q
PDamageStatis

id (
totalDam (
bossDam (
	totalHurt ("Ã
StageOverMsg
result ("
items (2.SoulProtocol.PItem
time (
sceneId (
starKeys (	*
infos (2.SoulProtocol.StageOverInfo+
statis (2.SoulProtocol.PDamageStatis"Ö
LadderStageOverMsg
result ("
items (2.SoulProtocol.PItem
time (
section (
score (
delta ("≥
CS3V3OverMsg
result (
time (
	winNature (-
list (2.SoulProtocol.CS3V3OverMsg.Role¬
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

id ("0
SyncPhaseMsg
phase (
	timestamp ("
InitAreaReq
area (")
NextAreaMsg
area (
wave ("
SyncWaveMsg
wave ("'
ReliveCountdownMsg
	timestamp ("

AntiSpyReq
targets ("7
MorphMsg

id (
morphId (
enable (" 
StageSweepReq
stageId ("§
StageSweepOverMsg
result ("
items (2.SoulProtocol.PItem
time (
stageId (
starKeys (	*
infos (2.SoulProtocol.StageOverInfo"/
StageCallReq
teamId (
stageId ("!
StageCallMsg
	callstamp (" 
ShiftSceneMsg
stageId ("2
WildSimulateReq
stageId (
taskId ("¯
WildSimulateMsg
stageId (
taskId (
retCode (
stamp (
	waveCount (
leaveInterval (
bubbleInterval (
awayNum (
showTips	 (;
friends
 (2*.SoulProtocol.WildSimulateMsg.MyWaveFriendÅ
MyWaveFriend
waveId (
waveNum (
waveInterval (
friends ()
	moveToPos (2.SoulProtocol.PVector2"(
WildSimulateFinishReq
stageId ("G
AreaTriggerReq
areaId (
	areaIndex (

colliderId ("b
AreaTriggerMsg
areaId (
	areaIndex (

colliderId (

cd (
times (