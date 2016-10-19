
ù$
proto/PPack.protoSoulProtocolcsproto/P_Common.proto"F
TipsMessage
state (
str (	
arg (	
showFx ("4

ShowString
str (	
arg (	
rank ("
	GMCommand
command (	"
RunStringMsg
command (	"*
PutStoneInfo
funcId (

id ("¿
PackUpdateMsg*
equip (2.SoulProtocol.PackEquipInfo-
putEquip (2.SoulProtocol.PackEquipInfo(
prop (2.SoulProtocol.PackPropInfo+
propLim (2.SoulProtocol.PackPropInfo*
stone (2.SoulProtocol.PackStoneInfo,
putStone (2.SoulProtocol.PutStoneInfo)
other (2.SoulProtocol.PackPropInfo*
assets (2.SoulProtocol.PackPropInfo.
partner	 (2.SoulProtocol.PackPartnerInfo0

putPartner
 (2.SoulProtocol.PutPartnerInfo2
fortPartner (2.SoulProtocol.FortPartnerInfo,
heromate (2.SoulProtocol.PackPropInfo(
holy (2.SoulProtocol.PackHolyInfo+
putHoly (2.SoulProtocol.PackHolyInfo,
heroFrag (2.SoulProtocol.PackPropInfo0
activityItem (2.SoulProtocol.PackPropInfo0
couplesring (2.SoulProtocol.PackEquipInfo
getWay (
warArg (":
PackDeleteInfo
bagType (

id (
num (";
PackDeleteMsg*
list (2.SoulProtocol.PackDeleteInfo".
EquipPutonReq
uid (
transfer (".
EquipPutonMsg
uid (
transfer (" 
EquipTakedownReq
part (" 
EquipTakedownMsg
part ("
EquipMakeInfoReq"„
EquipMakeInfoMsg
itemId (*
fAttr (2.SoulProtocol.PackEquipAttr*
sAttr (2.SoulProtocol.PackEquipAttr*
eAttr (2.SoulProtocol.PackEquipAttr+
skill (2.SoulProtocol.PackEquipSkill
count (
makeId (
buyCount ("
EquipMakeRefreshReq"‡
EquipMakeRefreshMsg
itemId (*
fAttr (2.SoulProtocol.PackEquipAttr*
sAttr (2.SoulProtocol.PackEquipAttr*
eAttr (2.SoulProtocol.PackEquipAttr+
skill (2.SoulProtocol.PackEquipSkill
count (
makeId (
buyCount ("
EquipMakeNormalReq"?
EquipMakeNormalMsg)
item (2.SoulProtocol.PackEquipInfo"K
EquipMakeSpecialReq

tp (
career (
part (

lv ("j
EquipMakeSpecialMsg

tp (
career (
part ()
item (2.SoulProtocol.PackEquipInfo"#
EquipRefreshBuyReq
count ("5
EquipRefreshBuyMsg
count (
buyCount (";
EquipEnhanceReq
uid (
part (
count ("W
EquipEnhanceMsg
uid (
part (
count (
lvUp (
crit (")
EquipMeltReq
uid (
auto ("‹
EquipMeltMsg
uid (
auto ("
items (2.SoulProtocol.PItem+
equips (2.SoulProtocol.PackEquipInfo
percent ("!
EquipWashInfoMsg
count ("E
EquipWashReq
uid (
part (
what (
lock ("T
EquipWashMsg
uid (
part (
what (
lock (
count ("
EquipStarInfoReq"ð
EquipStarInfoMsg6
stars (2'.SoulProtocol.EquipStarInfoMsg.PartInfo
title (	
rate (9
rateInfo (2'.SoulProtocol.EquipStarInfoMsg.RateInfo$
PartInfo
part (

lv (&
RateInfo
part (
rate (";
EquipStarReq
part (
star (
replace ("!
EquipStarRaiseReq
part ("…
EquipStarRaiseMsg
part (:
rateInfo (2(.SoulProtocol.EquipStarRaiseMsg.RateInfo&
RateInfo
part (
rate ("J
EquipStarMsg
part (
star (
prevLv (
currLv ("
EquipSuitReq"_
EquipSuitMsg-
list (2.SoulProtocol.EquipSuitMsg.Suit 
Suit

id (
cnts ("0
SellItemReq!
list (2.SoulProtocol.PItem"0
SellItemMsg!
list (2.SoulProtocol.PItem"
LotteryQuery"'

LotteryReq

id (
times ("â
LotteryInfo
boxId (
freeTime (
freeNum (
allNum (-
once (2.SoulProtocol.LotteryInfo.price,
ten (2.SoulProtocol.LotteryInfo.price

isDiscount ( 
price

id (
num ("9
LotteryInfoMsg'
info (2.SoulProtocol.LotteryInfo"

LotteryMsg/
list (2!.SoulProtocol.LotteryMsg.ItemInfo
type (2
ItemInfo

id (
num (
oriId ("
SuitMeltReq
uid ("'
SuitMeltMsg
uid (
cnt (":
SuitMakeReq
target (
equip (
reel ("Y
SuitMakeMsg
target (
result (*
items (2.SoulProtocol.PackEquipInfo"
EnchInfoReq"i
EnchInfoMsg4
partInfo (2".SoulProtocol.EnchInfoMsg.PartInfo$
PartInfo
part (

id ("#
EnchReq
part (

id ("#
EnchMsg
part (

id ("5

AdvanceReq
uid (
part (
list ("~

AdvanceMsg
uid (
part (
list (

up (
transfer ()
item (2.SoulProtocol.PackEquipInfo